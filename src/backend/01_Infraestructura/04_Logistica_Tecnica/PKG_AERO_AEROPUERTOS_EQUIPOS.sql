CREATE OR REPLACE PACKAGE PKG_AERO_AEROPUERTOS_EQUIPOS AS
    /**
     * Package: PKG_AERO_AEROPUERTOS_EQUIPOS
     * Descripción: Control de movilidad y asignación de equipo de apoyo (GSE).
     * Mando: Limpieza automática de asignaciones activas.
     */

    -- Procedimiento principal de asignación (Solicitado por Coordinación)
    PROCEDURE pr_asignar (
        p_id_aeropuerto IN NUMBER,
        p_id_equipo     IN NUMBER,
        p_motivo        IN VARCHAR2
    );

    -- Procedimiento para retirar equipo manualmente
    PROCEDURE pr_retirar (
        p_id_equipo IN NUMBER,
        p_motivo    IN VARCHAR2
    );

    -- Listar historial de movimientos
    PROCEDURE pr_listar_historial (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_AEROPUERTOS_EQUIPOS;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_AEROPUERTOS_EQUIPOS AS

    PROCEDURE pr_asignar (
        p_id_aeropuerto IN NUMBER,
        p_id_equipo     IN NUMBER,
        p_motivo        IN VARCHAR2
    ) IS
    BEGIN
        -- 1. Limpieza Automática: Cerrar asignaciones activas (Mando del Coordinador)
        UPDATE aero_aeropuertos_equipos
        SET fecha_retiro = SYSDATE,
            activo = 'N',
            motivo = 'TRASLADO AUTOMATICO: ' || p_motivo
        WHERE id_equipo = p_id_equipo
          AND fecha_retiro IS NULL;

        -- 2. Registro de la nueva asignación
        INSERT INTO aero_aeropuertos_equipos (
            id_aeropuerto, id_equipo, fecha_asignacion, motivo, activo
        ) VALUES (
            p_id_aeropuerto, p_id_equipo, SYSDATE, p_motivo, 'S'
        );

        -- 3. Actualizar la ubicación actual en la tabla maestra de equipos
        UPDATE aero_equipos_apoyo
        SET id_aeropuerto = p_id_aeropuerto,
            actualizado_en = SYSTIMESTAMP
        WHERE id_equipo = p_id_equipo;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20000, 'Error en la asignación técnica de equipo: ' || SQLERRM);
    END pr_asignar;

    PROCEDURE pr_retirar (
        p_id_equipo IN NUMBER,
        p_motivo    IN VARCHAR2
    ) IS
    BEGIN
        UPDATE aero_aeropuertos_equipos
        SET fecha_retiro = SYSDATE,
            activo = 'N',
            motivo = p_motivo
        WHERE id_equipo = p_id_equipo
          AND fecha_retiro IS NULL;
        COMMIT;
    END pr_retirar;

    PROCEDURE pr_listar_historial (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                e.nombre AS Equipo,
                a.nombre AS Aeropuerto,
                h.fecha_asignacion AS Desde,
                h.fecha_retiro AS Hasta,
                h.motivo AS Motivo_Traslado,
                h.activo AS Es_Ubicacion_Actual
            FROM aero_aeropuertos_equipos h
            JOIN aero_aeropuertos a ON h.id_aeropuerto = a.id_aeropuerto
            JOIN aero_equipos_apoyo e ON h.id_equipo = e.id_equipo
            ORDER BY h.fecha_asignacion DESC;
    END pr_listar_historial;

END PKG_AERO_AEROPUERTOS_EQUIPOS;
/

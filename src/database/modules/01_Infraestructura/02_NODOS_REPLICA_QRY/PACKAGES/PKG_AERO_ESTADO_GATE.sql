CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_ESTADO_GATE AS
    /**
     * Package: PKG_AERO_ESTADO_GATE
     * Descripción: Auditoría y registro histórico de cambios de estado en puertas.
     * Esquema: AEROGT
     */

    PROCEDURE pr_registrar_cambio (
        p_id_gate         IN AEROGT.aero_estado_gate.id_gate%TYPE,
        p_estado_anterior IN AEROGT.aero_estado_gate.estado_anterior%TYPE,
        p_estado_nuevo    IN AEROGT.aero_estado_gate.estado_nuevo%TYPE,
        p_motivo          IN AEROGT.aero_estado_gate.motivo%TYPE,
        p_id_empleado     IN AEROGT.aero_estado_gate.id_empleado_registro%TYPE
    );

    PROCEDURE pr_listar_historial (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_ESTADO_GATE;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_ESTADO_GATE AS

    PROCEDURE pr_registrar_cambio (
        p_id_gate         IN AEROGT.aero_estado_gate.id_gate%TYPE,
        p_estado_anterior IN AEROGT.aero_estado_gate.estado_anterior%TYPE,
        p_estado_nuevo    IN AEROGT.aero_estado_gate.estado_nuevo%TYPE,
        p_motivo          IN AEROGT.aero_estado_gate.motivo%TYPE,
        p_id_empleado     IN AEROGT.aero_estado_gate.id_empleado_registro%TYPE
    ) IS
    BEGIN
        INSERT INTO AEROGT.aero_estado_gate (
            id_gate, estado_anterior, estado_nuevo, motivo, id_empleado_registro
        ) VALUES (
            p_id_gate, p_estado_anterior, p_estado_nuevo, p_motivo, p_id_empleado
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al registrar auditoría de puerta: ' || SQLERRM);
    END pr_registrar_cambio;

    PROCEDURE pr_listar_historial (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                l.registrado_en   AS Fecha_Cambio,
                g.codigo          AS Codigo_Puerta,
                l.estado_anterior AS Estado_Previo,
                l.estado_nuevo    AS Estado_Actualizado,
                l.motivo          AS Razon_Cambio,
                e.nombres || ' ' || e.apellidos AS Usuario_Operario
            FROM AEROGT.aero_estado_gate l
            JOIN AEROGT.aero_puertas_gates g ON l.id_gate = g.id_gate
            LEFT JOIN AEROGT.rrhh_empleados e ON l.id_empleado_registro = e.id_empleado
            ORDER BY l.registrado_en DESC;
    END pr_listar_historial;

END PKG_AERO_ESTADO_GATE;
/

CREATE OR REPLACE PACKAGE PKG_AERO_INCIDENCIAS_INFRA AS
    /**
     * Package: PKG_AERO_INCIDENCIAS_INFRA
     * Descripción: Reporte y seguimiento de fallos en la infraestructura aeroportuaria.
     */

    PROCEDURE pr_registrar (
        p_id_aeropuerto IN NUMBER,
        p_tipo          IN VARCHAR2,
        p_descripcion   IN CLOB,
        p_zona          IN VARCHAR2,
        p_severidad     IN VARCHAR2,
        p_responsable   IN VARCHAR2,
        p_costo_est     IN NUMBER
    );

    PROCEDURE pr_cerrar (
        p_id_incidencia IN NUMBER,
        p_responsable   IN VARCHAR2
    );

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_INCIDENCIAS_INFRA;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_INCIDENCIAS_INFRA AS

    PROCEDURE pr_registrar (
        p_id_aeropuerto IN NUMBER,
        p_tipo          IN VARCHAR2,
        p_descripcion   IN CLOB,
        p_zona          IN VARCHAR2,
        p_severidad     IN VARCHAR2,
        p_responsable   IN VARCHAR2,
        p_costo_est     IN NUMBER
    ) IS
    BEGIN
        INSERT INTO aero_incidencias_infra (
            id_aeropuerto, tipo, descripcion, zona_afectada, 
            severidad, estado, fecha_apertura, responsable, costo_estimado_gtq
        ) VALUES (
            p_id_aeropuerto, p_tipo, p_descripcion, p_zona, 
            p_severidad, 'ABIERTA', SYSTIMESTAMP, p_responsable, p_costo_est
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al registrar incidencia: ' || SQLERRM);
    END pr_registrar;

    PROCEDURE pr_cerrar (
        p_id_incidencia IN NUMBER,
        p_responsable   IN VARCHAR2
    ) IS
    BEGIN
        UPDATE aero_incidencias_infra
        SET estado = 'CERRADA',
            fecha_cierre = SYSTIMESTAMP,
            responsable = p_responsable,
            actualizado_en = SYSTIMESTAMP
        WHERE id_incidencia = p_id_incidencia;
        COMMIT;
    END pr_cerrar;

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                id_incidencia   AS ID,
                tipo            AS Falla_Reportada,
                zona_afectada   AS Ubicacion_Falla,
                severidad       AS Prioridad,
                estado          AS Estado_Reparacion,
                fecha_apertura  AS Apertura,
                responsable     AS Ingeniero_ACargo,
                costo_estimado_gtq AS Costo_GTQ
            FROM aero_incidencias_infra
            WHERE id_aeropuerto = p_id_aeropuerto
            ORDER BY fecha_apertura DESC;
    END pr_listar;

END PKG_AERO_INCIDENCIAS_INFRA;
/

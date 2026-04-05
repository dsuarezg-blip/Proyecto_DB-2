CREATE OR REPLACE PACKAGE PKG_AERO_SISTEMAS_INCENDIO AS
    /**
     * Package: PKG_AERO_SISTEMAS_INCENDIO
     * Descripción: Gestión de sistemas de extinción y prevención de incendios.
     */

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_zona          IN VARCHAR2,
        p_tipo_sistema  IN VARCHAR2,
        p_capacidad_l   IN NUMBER,
        p_u_prueba      IN DATE,
        p_p_prueba      IN DATE,
        p_estado        IN VARCHAR2
    );

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_SISTEMAS_INCENDIO;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_SISTEMAS_INCENDIO AS

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_zona          IN VARCHAR2,
        p_tipo_sistema  IN VARCHAR2,
        p_capacidad_l   IN NUMBER,
        p_u_prueba      IN DATE,
        p_p_prueba      IN DATE,
        p_estado        IN VARCHAR2
    ) IS
    BEGIN
        MERGE INTO aero_sistemas_incendio i
        USING (SELECT p_id_aeropuerto as id_a, p_zona as z FROM dual) d
        ON (i.id_aeropuerto = d.id_a AND i.zona = d.z)
        WHEN MATCHED THEN
            UPDATE SET tipo_sistema = p_tipo_sistema, capacidad_litros = p_capacidad_l,
                       ultima_prueba = p_u_prueba, proxima_prueba = p_p_prueba,
                       estado = p_estado, actualizado_en = SYSTIMESTAMP
        WHEN NOT MATCHED THEN
            INSERT (id_aeropuerto, zona, tipo_sistema, capacidad_litros, 
                    ultima_prueba, proxima_prueba, estado)
            VALUES (p_id_aeropuerto, p_zona, p_tipo_sistema, p_capacidad_l, 
                    p_u_prueba, p_p_prueba, p_estado);
        COMMIT;
    END pr_upsert;

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                zona             AS Zona_Protegida,
                tipo_sistema     AS Tipo_Sistema,
                capacidad_litros AS Capacidad_Agua_L,
                ultima_prueba    AS Fecha_Ult_Prueba,
                proxima_prueba   AS Fecha_Prox_Prueba,
                estado           AS Estado_Operativo
            FROM aero_sistemas_incendio
            WHERE id_aeropuerto = p_id_aeropuerto
            ORDER BY zona ASC;
    END pr_listar;

END PKG_AERO_SISTEMAS_INCENDIO;
/

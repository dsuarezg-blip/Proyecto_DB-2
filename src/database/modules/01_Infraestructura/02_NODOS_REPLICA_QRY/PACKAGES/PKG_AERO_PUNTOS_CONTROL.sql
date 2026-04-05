CREATE OR REPLACE PACKAGE PKG_AERO_PUNTOS_CONTROL AS
    /**
     * Package: PKG_AERO_PUNTOS_CONTROL
     * Descripción: Gestión de puntos de inspección y seguridad perimetral.
     */

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_nivel_acceso  IN VARCHAR2,
        p_tipo_control  IN VARCHAR2,
        p_estado        IN VARCHAR2
    );

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_PUNTOS_CONTROL;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_PUNTOS_CONTROL AS

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_nivel_acceso  IN VARCHAR2,
        p_tipo_control  IN VARCHAR2,
        p_estado        IN VARCHAR2
    ) IS
    BEGIN
        MERGE INTO aero_puntos_control c
        USING (SELECT p_id_aeropuerto as id_a, p_nombre as n FROM dual) d
        ON (c.id_aeropuerto = d.id_a AND c.nombre = d.n)
        WHEN MATCHED THEN
            UPDATE SET nivel_acceso = p_nivel_acceso, tipo_control = p_tipo_control,
                       estado = p_estado
        WHEN NOT MATCHED THEN
            INSERT (id_aeropuerto, nombre, nivel_acceso, tipo_control, estado)
            VALUES (p_id_aeropuerto, p_nombre, p_nivel_acceso, p_tipo_control, p_estado);
        COMMIT;
    END pr_upsert;

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                nombre        AS Punto_Inspeccion,
                nivel_acceso  AS Ambito_Acceso,
                tipo_control  AS Metodo_Control,
                estado        AS Estado_Punto
            FROM aero_puntos_control
            WHERE id_aeropuerto = p_id_aeropuerto
            ORDER BY nombre ASC;
    END pr_listar;

END PKG_AERO_PUNTOS_CONTROL;
/

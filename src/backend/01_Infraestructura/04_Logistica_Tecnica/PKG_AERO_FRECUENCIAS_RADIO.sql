CREATE OR REPLACE PACKAGE PKG_AERO_FRECUENCIAS_RADIO AS
    /**
     * Package: PKG_AERO_FRECUENCIAS_RADIO
     * Descripción: Gestión de frecuencias VHF/UHF de soporte a la navegación.
     */

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_tipo          IN VARCHAR2,
        p_servicio      IN VARCHAR2,
        p_frec_mhz      IN NUMBER,
        p_activa        IN CHAR
    );

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_FRECUENCIAS_RADIO;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_FRECUENCIAS_RADIO AS

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_tipo          IN VARCHAR2,
        p_servicio      IN VARCHAR2,
        p_frec_mhz      IN NUMBER,
        p_activa        IN CHAR
    ) IS
    BEGIN
        MERGE INTO aero_frecuencias_radio f
        USING (SELECT p_id_aeropuerto as id_a, p_servicio as srv FROM dual) d
        ON (f.id_aeropuerto = d.id_a AND f.servicio = d.srv)
        WHEN MATCHED THEN
            UPDATE SET tipo = p_tipo, frecuencia_mhz = p_frec_mhz, activa = p_activa
        WHEN NOT MATCHED THEN
            INSERT (id_aeropuerto, tipo, servicio, frecuencia_mhz, activa)
            VALUES (p_id_aeropuerto, p_tipo, p_servicio, p_frec_mhz, p_activa);
        COMMIT;
    END pr_upsert;

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                servicio        AS Servicio_Radio,
                tipo            AS Banda_Frecuencia,
                frecuencia_mhz  AS Frecuencia_MHz,
                activa          AS Estado_Activa
            FROM aero_frecuencias_radio
            WHERE id_aeropuerto = p_id_aeropuerto
            ORDER BY servicio ASC;
    END pr_listar;

END PKG_AERO_FRECUENCIAS_RADIO;
/

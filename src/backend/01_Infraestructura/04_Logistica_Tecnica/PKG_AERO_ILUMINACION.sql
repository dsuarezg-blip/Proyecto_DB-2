CREATE OR REPLACE PACKAGE PKG_AERO_ILUMINACION AS
    /**
     * Package: PKG_AERO_ILUMINACION
     * Descripción: Sistemas de iluminación de aproximación, pista y plataforma.
     */

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_zona          IN VARCHAR2,
        p_tipo_sistema  IN VARCHAR2,
        p_intensidad    IN VARCHAR2,
        p_estado        IN VARCHAR2,
        p_f_instalacion IN DATE,
        p_vida_util     IN NUMBER
    );

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_ILUMINACION;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_ILUMINACION AS

    PROCEDURE pr_upsert (
        p_id_aeropuerto IN NUMBER,
        p_zona          IN VARCHAR2,
        p_tipo_sistema  IN VARCHAR2,
        p_intensidad    IN VARCHAR2,
        p_estado        IN VARCHAR2,
        p_f_instalacion IN DATE,
        p_vida_util     IN NUMBER
    ) IS
    BEGIN
        MERGE INTO aero_iluminacion i
        USING (SELECT p_id_aeropuerto as id_a, p_zona as z FROM dual) d
        ON (i.id_aeropuerto = d.id_a AND i.zona = d.z)
        WHEN MATCHED THEN
            UPDATE SET tipo_sistema = p_tipo_sistema, intensidad = p_intensidad,
                       estado = p_estado, fecha_instalacion = p_f_instalacion,
                       vida_util_anios = p_vida_util, actualizado_en = SYSTIMESTAMP
        WHEN NOT MATCHED THEN
            INSERT (id_aeropuerto, zona, tipo_sistema, intensidad, estado, 
                    fecha_instalacion, vida_util_anios)
            VALUES (p_id_aeropuerto, p_zona, p_tipo_sistema, p_intensidad, p_estado, 
                    p_f_instalacion, p_vida_util);
        COMMIT;
    END pr_upsert;

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                zona           AS Ubicacion_Pista,
                tipo_sistema   AS Tecnologia,
                intensidad     AS Nivel_Luminico,
                estado         AS Estado_Operativo,
                vida_util_anios AS Vida_Restante_Anios
            FROM aero_iluminacion
            WHERE id_aeropuerto = p_id_aeropuerto
            ORDER BY zona ASC;
    END pr_listar;

END PKG_AERO_ILUMINACION;
/

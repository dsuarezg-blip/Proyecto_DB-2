CREATE OR REPLACE PACKAGE AEROGT.PKG_GEOG_ZONAS_HORARIAS AS
    /**
     * Package: PKG_GEOG_ZONAS_HORARIAS
     * Descripción: Gestión de zonas horarias y desplazamientos UTC.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_nombre     IN geog_zonas_horarias.nombre%TYPE,
        p_utc_offset IN geog_zonas_horarias.utc_offset%TYPE,
        p_codigo_tz  IN geog_zonas_horarias.codigo_tz%TYPE,
        p_aplica_dst IN geog_zonas_horarias.aplica_dst%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_zona    IN geog_zonas_horarias.id_zona%TYPE,
        p_nombre     IN geog_zonas_horarias.nombre%TYPE,
        p_utc_offset IN geog_zonas_horarias.utc_offset%TYPE,
        p_codigo_tz  IN geog_zonas_horarias.codigo_tz%TYPE,
        p_aplica_dst IN geog_zonas_horarias.aplica_dst%TYPE,
        p_activo     IN geog_zonas_horarias.activo%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_zona IN geog_zonas_horarias.id_zona%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_obtener_por_id (
        p_id_zona IN geog_zonas_horarias.id_zona%TYPE,
        p_cursor  OUT SYS_REFCURSOR
    );

END PKG_GEOG_ZONAS_HORARIAS;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_GEOG_ZONAS_HORARIAS AS

    PROCEDURE pr_insertar (
        p_nombre     IN geog_zonas_horarias.nombre%TYPE,
        p_utc_offset IN geog_zonas_horarias.utc_offset%TYPE,
        p_codigo_tz  IN geog_zonas_horarias.codigo_tz%TYPE,
        p_aplica_dst IN geog_zonas_horarias.aplica_dst%TYPE
    ) IS
    BEGIN
        INSERT INTO geog_zonas_horarias (nombre, utc_offset, codigo_tz, aplica_dst)
        VALUES (p_nombre, p_utc_offset, p_codigo_tz, p_aplica_dst);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar zona horaria: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_zona    IN geog_zonas_horarias.id_zona%TYPE,
        p_nombre     IN geog_zonas_horarias.nombre%TYPE,
        p_utc_offset IN geog_zonas_horarias.utc_offset%TYPE,
        p_codigo_tz  IN geog_zonas_horarias.codigo_tz%TYPE,
        p_aplica_dst IN geog_zonas_horarias.aplica_dst%TYPE,
        p_activo     IN geog_zonas_horarias.activo%TYPE
    ) IS
    BEGIN
        UPDATE geog_zonas_horarias
        SET nombre = p_nombre,
            utc_offset = p_utc_offset,
            codigo_tz = p_codigo_tz,
            aplica_dst = p_aplica_dst,
            activo = p_activo
        WHERE id_zona = p_id_zona;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Zona horaria no encontrada.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_zona IN geog_zonas_horarias.id_zona%TYPE
    ) IS
    BEGIN
        UPDATE geog_zonas_horarias SET activo = 'N' WHERE id_zona = p_id_zona;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_zonas_horarias
            ORDER BY nombre ASC;
    END pr_listar;

    PROCEDURE pr_obtener_por_id (
        p_id_zona IN geog_zonas_horarias.id_zona%TYPE,
        p_cursor  OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_zonas_horarias WHERE id_zona = p_id_zona;
    END pr_obtener_por_id;

END PKG_GEOG_ZONAS_HORARIAS;
/

CREATE OR REPLACE PACKAGE AEROGT.PKG_GEOG_CIUDADES AS
    /**
     * Package: PKG_GEOG_CIUDADES
     * Descripción: Gestión de ciudades vinculadas a estados/departamentos.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_estado     IN geog_ciudades.id_estado%TYPE,
        p_nombre        IN geog_ciudades.nombre%TYPE,
        p_codigo_postal IN geog_ciudades.codigo_postal%TYPE,
        p_latitud       IN geog_ciudades.latitud%TYPE,
        p_longitud      IN geog_ciudades.longitud%TYPE,
        p_poblacion     IN geog_ciudades.poblacion%TYPE,
        p_altitud_msnm  IN geog_ciudades.altitud_msnm%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_ciudad     IN geog_ciudades.id_ciudad%TYPE,
        p_id_estado     IN geog_ciudades.id_estado%TYPE,
        p_nombre        IN geog_ciudades.nombre%TYPE,
        p_codigo_postal IN geog_ciudades.codigo_postal%TYPE,
        p_latitud       IN geog_ciudades.latitud%TYPE,
        p_longitud      IN geog_ciudades.longitud%TYPE,
        p_poblacion     IN geog_ciudades.poblacion%TYPE,
        p_altitud_msnm  IN geog_ciudades.altitud_msnm%TYPE,
        p_activo        IN geog_ciudades.activo%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_ciudad IN geog_ciudades.id_ciudad%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_obtener_por_id (
        p_id_ciudad IN geog_ciudades.id_ciudad%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_estado (
        p_id_estado IN geog_ciudades.id_estado%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    );

END PKG_GEOG_CIUDADES;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_GEOG_CIUDADES AS

    PROCEDURE pr_insertar (
        p_id_estado     IN geog_ciudades.id_estado%TYPE,
        p_nombre        IN geog_ciudades.nombre%TYPE,
        p_codigo_postal IN geog_ciudades.codigo_postal%TYPE,
        p_latitud       IN geog_ciudades.latitud%TYPE,
        p_longitud      IN geog_ciudades.longitud%TYPE,
        p_poblacion     IN geog_ciudades.poblacion%TYPE,
        p_altitud_msnm  IN geog_ciudades.altitud_msnm%TYPE
    ) IS
    BEGIN
        INSERT INTO geog_ciudades (
            id_estado, nombre, codigo_postal, latitud, 
            longitud, poblacion, altitud_msnm
        ) VALUES (
            p_id_estado, p_nombre, p_codigo_postal, p_latitud, 
            p_longitud, p_poblacion, p_altitud_msnm
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar ciudad: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_ciudad     IN geog_ciudades.id_ciudad%TYPE,
        p_id_estado     IN geog_ciudades.id_estado%TYPE,
        p_nombre        IN geog_ciudades.nombre%TYPE,
        p_codigo_postal IN geog_ciudades.codigo_postal%TYPE,
        p_latitud       IN geog_ciudades.latitud%TYPE,
        p_longitud      IN geog_ciudades.longitud%TYPE,
        p_poblacion     IN geog_ciudades.poblacion%TYPE,
        p_altitud_msnm  IN geog_ciudades.altitud_msnm%TYPE,
        p_activo        IN geog_ciudades.activo%TYPE
    ) IS
    BEGIN
        UPDATE geog_ciudades
        SET id_estado = p_id_estado,
            nombre = p_nombre,
            codigo_postal = p_codigo_postal,
            latitud = p_latitud,
            longitud = p_longitud,
            poblacion = p_poblacion,
            altitud_msnm = p_altitud_msnm,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_ciudad = p_id_ciudad;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Ciudad no encontrada.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_ciudad IN geog_ciudades.id_ciudad%TYPE
    ) IS
    BEGIN
        UPDATE geog_ciudades SET activo = 'N', actualizado_en = SYSTIMESTAMP WHERE id_ciudad = p_id_ciudad;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT c.*, e.nombre as estado_nombre, p.nombre as pais_nombre
            FROM geog_ciudades c
            JOIN geog_estados_dep e ON c.id_estado = e.id_estado
            JOIN geog_paises p ON e.id_pais = p.id_pais
            ORDER BY p.nombre, e.nombre, c.nombre ASC;
    END pr_listar;

    PROCEDURE pr_obtener_por_id (
        p_id_ciudad IN geog_ciudades.id_ciudad%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_ciudades WHERE id_ciudad = p_id_ciudad;
    END pr_obtener_por_id;

    PROCEDURE pr_listar_por_estado (
        p_id_estado IN geog_ciudades.id_estado%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_ciudades 
            WHERE id_estado = p_id_estado AND activo = 'S'
            ORDER BY nombre ASC;
    END pr_listar_por_estado;

END PKG_GEOG_CIUDADES;
/

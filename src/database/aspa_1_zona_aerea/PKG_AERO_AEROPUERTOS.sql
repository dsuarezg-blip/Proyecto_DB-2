CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_AEROPUERTOS AS
    /**
     * Package: PKG_AERO_AEROPUERTOS
     * Descripción: Gestión central de aeropuertos del sistema AeroGT.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_ciudad    IN aero_aeropuertos.id_ciudad%TYPE,
        p_id_zona      IN aero_aeropuertos.id_zona%TYPE,
        p_codigo_iata  IN aero_aeropuertos.codigo_iata%TYPE,
        p_codigo_icao  IN aero_aeropuertos.codigo_icao%TYPE,
        p_nombre       IN aero_aeropuertos.nombre%TYPE,
        p_nombre_corto IN aero_aeropuertos.nombre_corto%TYPE,
        p_tipo         IN aero_aeropuertos.tipo%TYPE,
        p_latitud      IN aero_aeropuertos.latitud%TYPE,
        p_longitud     IN aero_aeropuertos.longitud%TYPE,
        p_altitud_ft   IN aero_aeropuertos.altitud_ft%TYPE,
        p_es_hub       IN aero_aeropuertos.es_hub%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_aeropuerto IN aero_aeropuertos.id_aeropuerto%TYPE,
        p_id_ciudad     IN aero_aeropuertos.id_ciudad%TYPE,
        p_id_zona       IN aero_aeropuertos.id_zona%TYPE,
        p_codigo_iata   IN aero_aeropuertos.codigo_iata%TYPE,
        p_codigo_icao   IN aero_aeropuertos.codigo_icao%TYPE,
        p_nombre        IN aero_aeropuertos.nombre%TYPE,
        p_nombre_corto  IN aero_aeropuertos.nombre_corto%TYPE,
        p_tipo          IN aero_aeropuertos.tipo%TYPE,
        p_latitud       IN aero_aeropuertos.latitud%TYPE,
        p_longitud      IN aero_aeropuertos.longitud%TYPE,
        p_altitud_ft    IN aero_aeropuertos.altitud_ft%TYPE,
        p_es_hub        IN aero_aeropuertos.es_hub%TYPE,
        p_activo        IN aero_aeropuertos.activo%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_aeropuerto IN aero_aeropuertos.id_aeropuerto%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_obtener_por_id (
        p_id_aeropuerto IN aero_aeropuertos.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_hubs (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_ciudad (
        p_id_ciudad IN aero_aeropuertos.id_ciudad%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    );

END PKG_AERO_AEROPUERTOS;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_AEROPUERTOS AS

    PROCEDURE pr_insertar (
        p_id_ciudad    IN aero_aeropuertos.id_ciudad%TYPE,
        p_id_zona      IN aero_aeropuertos.id_zona%TYPE,
        p_codigo_iata  IN aero_aeropuertos.codigo_iata%TYPE,
        p_codigo_icao  IN aero_aeropuertos.codigo_icao%TYPE,
        p_nombre       IN aero_aeropuertos.nombre%TYPE,
        p_nombre_corto IN aero_aeropuertos.nombre_corto%TYPE,
        p_tipo         IN aero_aeropuertos.tipo%TYPE,
        p_latitud      IN aero_aeropuertos.latitud%TYPE,
        p_longitud     IN aero_aeropuertos.longitud%TYPE,
        p_altitud_ft   IN aero_aeropuertos.altitud_ft%TYPE,
        p_es_hub       IN aero_aeropuertos.es_hub%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_aeropuertos (
            id_ciudad, id_zona, codigo_iata, codigo_icao, 
            nombre, nombre_corto, tipo, latitud, 
            longitud, altitud_ft, es_hub
        ) VALUES (
            p_id_ciudad, p_id_zona, p_codigo_iata, p_codigo_icao, 
            p_nombre, p_nombre_corto, p_tipo, p_latitud, 
            p_longitud, p_altitud_ft, p_es_hub
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar aeropuerto: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_aeropuerto IN aero_aeropuertos.id_aeropuerto%TYPE,
        p_id_ciudad     IN aero_aeropuertos.id_ciudad%TYPE,
        p_id_zona       IN aero_aeropuertos.id_zona%TYPE,
        p_codigo_iata   IN aero_aeropuertos.codigo_iata%TYPE,
        p_codigo_icao   IN aero_aeropuertos.codigo_icao%TYPE,
        p_nombre        IN aero_aeropuertos.nombre%TYPE,
        p_nombre_corto  IN aero_aeropuertos.nombre_corto%TYPE,
        p_tipo          IN aero_aeropuertos.tipo%TYPE,
        p_latitud       IN aero_aeropuertos.latitud%TYPE,
        p_longitud      IN aero_aeropuertos.longitud%TYPE,
        p_altitud_ft    IN aero_aeropuertos.altitud_ft%TYPE,
        p_es_hub        IN aero_aeropuertos.es_hub%TYPE,
        p_activo        IN aero_aeropuertos.activo%TYPE
    ) IS
    BEGIN
        UPDATE aero_aeropuertos
        SET id_ciudad = p_id_ciudad,
            id_zona = p_id_zona,
            codigo_iata = p_codigo_iata,
            codigo_icao = p_codigo_icao,
            nombre = p_nombre,
            nombre_corto = p_nombre_corto,
            tipo = p_tipo,
            latitud = p_latitud,
            longitud = p_longitud,
            altitud_ft = p_altitud_ft,
            es_hub = p_es_hub,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_aeropuerto = p_id_aeropuerto;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Aeropuerto no encontrado.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_aeropuerto IN aero_aeropuertos.id_aeropuerto%TYPE
    ) IS
    BEGIN
        UPDATE aero_aeropuertos SET activo = 'N', actualizado_en = SYSTIMESTAMP WHERE id_aeropuerto = p_id_aeropuerto;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT a.*, c.nombre as ciudad_nombre, z.nombre as zona_nombre
            FROM aero_aeropuertos a
            JOIN geog_ciudades c ON a.id_ciudad = c.id_ciudad
            JOIN geog_zonas_horarias z ON a.id_zona = z.id_zona
            ORDER BY a.nombre ASC;
    END pr_listar;

    PROCEDURE pr_obtener_por_id (
        p_id_aeropuerto IN aero_aeropuertos.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_aeropuertos WHERE id_aeropuerto = p_id_aeropuerto;
    END pr_obtener_por_id;

    PROCEDURE pr_listar_hubs (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_aeropuertos WHERE es_hub = 'S' AND activo = 'S';
    END pr_listar_hubs;

    PROCEDURE pr_listar_por_ciudad (
        p_id_ciudad IN aero_aeropuertos.id_ciudad%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_aeropuertos WHERE id_ciudad = p_id_ciudad AND activo = 'S';
    END pr_listar_por_ciudad;

END PKG_AERO_AEROPUERTOS;
/

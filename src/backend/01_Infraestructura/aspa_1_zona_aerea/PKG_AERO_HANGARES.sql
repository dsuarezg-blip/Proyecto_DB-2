CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_HANGARES AS
    /**
     * Package: PKG_AERO_HANGARES
     * Descripción: Gestión de hangares de mantenimiento y resguardo.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_aeropuerto   IN aero_hangares.id_aeropuerto%TYPE,
        p_nombre          IN aero_hangares.nombre%TYPE,
        p_tipo            IN aero_hangares.tipo%TYPE,
        p_capacidad_aeros IN aero_hangares.capacidad_aeronaves%TYPE,
        p_area_m2         IN aero_hangares.area_m2%TYPE,
        p_altura_m        IN aero_hangares.altura_m%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_hangar       IN aero_hangares.id_hangar%TYPE,
        p_id_aeropuerto   IN aero_hangares.id_aeropuerto%TYPE,
        p_nombre          IN aero_hangares.nombre%TYPE,
        p_tipo            IN aero_hangares.tipo%TYPE,
        p_capacidad_aeros IN aero_hangares.capacidad_aeronaves%TYPE,
        p_area_m2         IN aero_hangares.area_m2%TYPE,
        p_altura_m        IN aero_hangares.altura_m%TYPE,
        p_disponible      IN aero_hangares.disponible%TYPE,
        p_activo          IN aero_hangares.activo%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_hangar IN aero_hangares.id_hangar%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_disponibles (
        p_id_aeropuerto IN aero_hangares.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_HANGARES;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_HANGARES AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto   IN aero_hangares.id_aeropuerto%TYPE,
        p_nombre          IN aero_hangares.nombre%TYPE,
        p_tipo            IN aero_hangares.tipo%TYPE,
        p_capacidad_aeros IN aero_hangares.capacidad_aeronaves%TYPE,
        p_area_m2         IN aero_hangares.area_m2%TYPE,
        p_altura_m        IN aero_hangares.altura_m%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_hangares (
            id_aeropuerto, nombre, tipo, capacidad_aeronaves, area_m2, altura_m
        ) VALUES (
            p_id_aeropuerto, p_nombre, p_tipo, p_capacidad_aeros, p_area_m2, p_altura_m
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar hangar: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_hangar       IN aero_hangares.id_hangar%TYPE,
        p_id_aeropuerto   IN aero_hangares.id_aeropuerto%TYPE,
        p_nombre          IN aero_hangares.nombre%TYPE,
        p_tipo            IN aero_hangares.tipo%TYPE,
        p_capacidad_aeros IN aero_hangares.capacidad_aeronaves%TYPE,
        p_area_m2         IN aero_hangares.area_m2%TYPE,
        p_altura_m        IN aero_hangares.altura_m%TYPE,
        p_disponible      IN aero_hangares.disponible%TYPE,
        p_activo          IN aero_hangares.activo%TYPE
    ) IS
    BEGIN
        UPDATE aero_hangares
        SET id_aeropuerto = p_id_aeropuerto,
            nombre = p_nombre,
            tipo = p_tipo,
            capacidad_aeronaves = p_capacidad_aeros,
            area_m2 = p_area_m2,
            altura_m = p_altura_m,
            disponible = p_disponible,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_hangar = p_id_hangar;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Hangar no encontrado.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_hangar IN aero_hangares.id_hangar%TYPE
    ) IS
    BEGIN
        UPDATE aero_hangares SET activo = 'N', actualizado_en = SYSTIMESTAMP WHERE id_hangar = p_id_hangar;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT h.*, a.nombre as aeropuerto_nombre
            FROM aero_hangares h
            JOIN aero_aeropuertos a ON h.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.nombre, h.nombre ASC;
    END pr_listar;

    PROCEDURE pr_listar_disponibles (
        p_id_aeropuerto IN aero_hangares.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_hangares 
            WHERE id_aeropuerto = p_id_aeropuerto AND disponible = 'S' AND activo = 'S'
            ORDER BY nombre ASC;
    END pr_listar_disponibles;

END PKG_AERO_HANGARES;
/

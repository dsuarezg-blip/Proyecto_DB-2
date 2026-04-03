CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_PLATAFORMAS AS
    /**
     * Package: PKG_AERO_PLATAFORMAS
     * Descripción: Gestión de plataformas de estacionamiento de aeronaves.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_aeropuerto     IN aero_plataformas.id_aeropuerto%TYPE,
        p_nombre            IN aero_plataformas.nombre%TYPE,
        p_tipo              IN aero_plataformas.tipo%TYPE,
        p_capacidad_aeros   IN aero_plataformas.capacidad_aeronaves%TYPE,
        p_area_m2           IN aero_plataformas.area_m2%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_plataforma     IN aero_plataformas.id_plataforma%TYPE,
        p_id_aeropuerto     IN aero_plataformas.id_aeropuerto%TYPE,
        p_nombre            IN aero_plataformas.nombre%TYPE,
        p_tipo              IN aero_plataformas.tipo%TYPE,
        p_capacidad_aeros   IN aero_plataformas.capacidad_aeronaves%TYPE,
        p_area_m2           IN aero_plataformas.area_m2%TYPE,
        p_estado            IN aero_plataformas.estado%TYPE,
        p_activa            IN aero_plataformas.activa%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_plataforma IN aero_plataformas.id_plataforma%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_aeropuerto (
        p_id_aeropuerto IN aero_plataformas.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_PLATAFORMAS;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_PLATAFORMAS AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto     IN aero_plataformas.id_aeropuerto%TYPE,
        p_nombre            IN aero_plataformas.nombre%TYPE,
        p_tipo              IN aero_plataformas.tipo%TYPE,
        p_capacidad_aeros   IN aero_plataformas.capacidad_aeronaves%TYPE,
        p_area_m2           IN aero_plataformas.area_m2%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_plataformas (
            id_aeropuerto, nombre, tipo, capacidad_aeronaves, area_m2
        ) VALUES (
            p_id_aeropuerto, p_nombre, p_tipo, p_capacidad_aeros, p_area_m2
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar plataforma: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_plataforma     IN aero_plataformas.id_plataforma%TYPE,
        p_id_aeropuerto     IN aero_plataformas.id_aeropuerto%TYPE,
        p_nombre            IN aero_plataformas.nombre%TYPE,
        p_tipo              IN aero_plataformas.tipo%TYPE,
        p_capacidad_aeros   IN aero_plataformas.capacidad_aeronaves%TYPE,
        p_area_m2           IN aero_plataformas.area_m2%TYPE,
        p_estado            IN aero_plataformas.estado%TYPE,
        p_activa            IN aero_plataformas.activa%TYPE
    ) IS
    BEGIN
        UPDATE aero_plataformas
        SET id_aeropuerto = p_id_aeropuerto,
            nombre = p_nombre,
            tipo = p_tipo,
            capacidad_aeronaves = p_capacidad_aeros,
            area_m2 = p_area_m2,
            estado = p_estado,
            activa = p_activa,
            actualizado_en = SYSTIMESTAMP
        WHERE id_plataforma = p_id_plataforma;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Plataforma no encontrada.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_plataforma IN aero_plataformas.id_plataforma%TYPE
    ) IS
    BEGIN
        UPDATE aero_plataformas SET activa = 'N', actualizado_en = SYSTIMESTAMP WHERE id_plataforma = p_id_plataforma;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT pl.*, a.nombre as aeropuerto_nombre
            FROM aero_plataformas pl
            JOIN aero_aeropuertos a ON pl.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.nombre, pl.nombre ASC;
    END pr_listar;

    PROCEDURE pr_listar_por_aeropuerto (
        p_id_aeropuerto IN aero_plataformas.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_plataformas 
            WHERE id_aeropuerto = p_id_aeropuerto AND activa = 'S'
            ORDER BY nombre ASC;
    END pr_listar_por_aeropuerto;

END PKG_AERO_PLATAFORMAS;
/

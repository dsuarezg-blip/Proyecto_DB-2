CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_CALLES_RODAJE AS
    /**
     * Package: PKG_AERO_CALLES_RODAJE
     * Descripción: Gestión de calles de rodaje (taxiways).
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN aero_calles_rodaje.id_aeropuerto%TYPE,
        p_designacion   IN aero_calles_rodaje.designacion%TYPE,
        p_longitud_m    IN aero_calles_rodaje.longitud_m%TYPE,
        p_ancho_m       IN aero_calles_rodaje.ancho_m%TYPE,
        p_tipo          IN aero_calles_rodaje.tipo%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_taxiway    IN aero_calles_rodaje.id_taxiway%TYPE,
        p_id_aeropuerto IN aero_calles_rodaje.id_aeropuerto%TYPE,
        p_designacion   IN aero_calles_rodaje.designacion%TYPE,
        p_longitud_m    IN aero_calles_rodaje.longitud_m%TYPE,
        p_ancho_m       IN aero_calles_rodaje.ancho_m%TYPE,
        p_tipo          IN aero_calles_rodaje.tipo%TYPE,
        p_estado        IN aero_calles_rodaje.estado%TYPE,
        p_activa        IN aero_calles_rodaje.activa%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_taxiway IN aero_calles_rodaje.id_taxiway%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_aeropuerto (
        p_id_aeropuerto IN aero_calles_rodaje.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_CALLES_RODAJE;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_CALLES_RODAJE AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN aero_calles_rodaje.id_aeropuerto%TYPE,
        p_designacion   IN aero_calles_rodaje.designacion%TYPE,
        p_longitud_m    IN aero_calles_rodaje.longitud_m%TYPE,
        p_ancho_m       IN aero_calles_rodaje.ancho_m%TYPE,
        p_tipo          IN aero_calles_rodaje.tipo%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_calles_rodaje (
            id_aeropuerto, designacion, longitud_m, ancho_m, tipo
        ) VALUES (
            p_id_aeropuerto, p_designacion, p_longitud_m, p_ancho_m, p_tipo
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar calle de rodaje: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_taxiway    IN aero_calles_rodaje.id_taxiway%TYPE,
        p_id_aeropuerto IN aero_calles_rodaje.id_aeropuerto%TYPE,
        p_designacion   IN aero_calles_rodaje.designacion%TYPE,
        p_longitud_m    IN aero_calles_rodaje.longitud_m%TYPE,
        p_ancho_m       IN aero_calles_rodaje.ancho_m%TYPE,
        p_tipo          IN aero_calles_rodaje.tipo%TYPE,
        p_estado        IN aero_calles_rodaje.estado%TYPE,
        p_activa        IN aero_calles_rodaje.activa%TYPE
    ) IS
    BEGIN
        UPDATE aero_calles_rodaje
        SET id_aeropuerto = p_id_aeropuerto,
            designacion = p_designacion,
            longitud_m = p_longitud_m,
            ancho_m = p_ancho_m,
            tipo = p_tipo,
            estado = p_estado,
            activa = p_activa,
            actualizado_en = SYSTIMESTAMP
        WHERE id_taxiway = p_id_taxiway;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Calle de rodaje no encontrada.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_taxiway IN aero_calles_rodaje.id_taxiway%TYPE
    ) IS
    BEGIN
        UPDATE aero_calles_rodaje SET activa = 'N', actualizado_en = SYSTIMESTAMP WHERE id_taxiway = p_id_taxiway;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT t.*, a.nombre as aeropuerto_nombre
            FROM aero_calles_rodaje t
            JOIN aero_aeropuertos a ON t.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.nombre, t.designacion ASC;
    END pr_listar;

    PROCEDURE pr_listar_por_aeropuerto (
        p_id_aeropuerto IN aero_calles_rodaje.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_calles_rodaje 
            WHERE id_aeropuerto = p_id_aeropuerto AND activa = 'S'
            ORDER BY designacion ASC;
    END pr_listar_por_aeropuerto;

END PKG_AERO_CALLES_RODAJE;
/

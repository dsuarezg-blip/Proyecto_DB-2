CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_PISTAS AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto   IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion     IN aero_pistas.designacion%TYPE,
        p_longitud_m      IN aero_pistas.longitud_m%TYPE,
        p_ancho_m         IN aero_pistas.ancho_m%TYPE,
        p_tipo_superficie IN aero_pistas.tipo_superficie%TYPE,
        p_resistencia_pcn IN aero_pistas.resistencia_pcn%TYPE,
        p_iluminada       IN aero_pistas.iluminada%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_pista        IN aero_pistas.id_pista%TYPE,
        p_id_aeropuerto   IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion     IN aero_pistas.designacion%TYPE,
        p_longitud_m      IN aero_pistas.longitud_m%TYPE,
        p_ancho_m         IN aero_pistas.ancho_m%TYPE,
        p_tipo_superficie IN aero_pistas.tipo_superficie%TYPE,
        p_resistencia_pcn IN aero_pistas.resistencia_pcn%TYPE,
        p_iluminada       IN aero_pistas.iluminada%TYPE,
        p_activa          IN aero_pistas.activa%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_pista IN aero_pistas.id_pista%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_obtener_por_id (
        p_id_pista IN aero_pistas.id_pista%TYPE,
        p_cursor   OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_aeropuerto (
        p_id_aeropuerto IN aero_pistas.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_PISTAS;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_PISTAS AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto   IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion     IN aero_pistas.designacion%TYPE,
        p_longitud_m      IN aero_pistas.longitud_m%TYPE,
        p_ancho_m         IN aero_pistas.ancho_m%TYPE,
        p_tipo_superficie IN aero_pistas.tipo_superficie%TYPE,
        p_resistencia_pcn IN aero_pistas.resistencia_pcn%TYPE,
        p_iluminada       IN aero_pistas.iluminada%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_pistas (
            id_aeropuerto, designacion, longitud_m, ancho_m,
            tipo_superficie, resistencia_pcn, iluminada
        ) VALUES (
            p_id_aeropuerto, p_designacion, p_longitud_m, p_ancho_m,
            p_tipo_superficie, p_resistencia_pcn, p_iluminada
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'Error al insertar pista: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_pista        IN aero_pistas.id_pista%TYPE,
        p_id_aeropuerto   IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion     IN aero_pistas.designacion%TYPE,
        p_longitud_m      IN aero_pistas.longitud_m%TYPE,
        p_ancho_m         IN aero_pistas.ancho_m%TYPE,
        p_tipo_superficie IN aero_pistas.tipo_superficie%TYPE,
        p_resistencia_pcn IN aero_pistas.resistencia_pcn%TYPE,
        p_iluminada       IN aero_pistas.iluminada%TYPE,
        p_activa          IN aero_pistas.activa%TYPE
    ) IS
    BEGIN
        UPDATE aero_pistas SET
            id_aeropuerto   = p_id_aeropuerto,
            designacion     = p_designacion,
            longitud_m      = p_longitud_m,
            ancho_m         = p_ancho_m,
            tipo_superficie = p_tipo_superficie,
            resistencia_pcn = p_resistencia_pcn,
            iluminada       = p_iluminada,
            activa          = p_activa
        WHERE id_pista = p_id_pista;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20002, 'Error al actualizar pista: ' || SQLERRM);
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_pista IN aero_pistas.id_pista%TYPE
    ) IS
    BEGIN
        DELETE FROM aero_pistas WHERE id_pista = p_id_pista;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20003, 'Error al eliminar pista: ' || SQLERRM);
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT p.id_pista, p.id_aeropuerto, a.codigo_iata,
                   p.designacion, p.longitud_m, p.ancho_m,
                   p.tipo_superficie, p.resistencia_pcn,
                   p.iluminada, p.activa
            FROM aero_pistas p
            JOIN aero_aeropuertos a ON p.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.codigo_iata, p.designacion;
    END pr_listar;

    PROCEDURE pr_obtener_por_id (
        p_id_pista IN aero_pistas.id_pista%TYPE,
        p_cursor   OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_pistas WHERE id_pista = p_id_pista;
    END pr_obtener_por_id;

    PROCEDURE pr_listar_por_aeropuerto (
        p_id_aeropuerto IN aero_pistas.id_aeropuerto%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_pistas
            WHERE id_aeropuerto = p_id_aeropuerto
            ORDER BY designacion;
    END pr_listar_por_aeropuerto;

END PKG_AERO_PISTAS;
/

CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_PISTAS AS
    /**
     * Package: PKG_AERO_PISTAS
     * Descripción: Gestión técnica de pistas de aterrizaje.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_aeropuerto    IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion      IN aero_pistas.designacion%TYPE,
        p_longitud_m       IN aero_pistas.longitud_m%TYPE,
        p_ancho_m          IN aero_pistas.ancho_m%TYPE,
        p_orientacion      IN aero_pistas.orientacion_grados%TYPE,
        p_tipo_superficie  IN aero_pistas.tipo_superficie%TYPE,
        p_carga_max_kg     IN aero_pistas.carga_max_kg%TYPE,
        p_iluminada        IN aero_pistas.iluminada%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_pista         IN aero_pistas.id_pista%TYPE,
        p_id_aeropuerto    IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion      IN aero_pistas.designacion%TYPE,
        p_longitud_m       IN aero_pistas.longitud_m%TYPE,
        p_ancho_m          IN aero_pistas.ancho_m%TYPE,
        p_orientacion      IN aero_pistas.orientacion_grados%TYPE,
        p_tipo_superficie  IN aero_pistas.tipo_superficie%TYPE,
        p_estado           IN aero_pistas.estado%TYPE,
        p_carga_max_kg     IN aero_pistas.carga_max_kg%TYPE,
        p_iluminada        IN aero_pistas.iluminada%TYPE,
        p_activa           IN aero_pistas.activa%TYPE
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
        p_id_aeropuerto    IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion      IN aero_pistas.designacion%TYPE,
        p_longitud_m       IN aero_pistas.longitud_m%TYPE,
        p_ancho_m          IN aero_pistas.ancho_m%TYPE,
        p_orientacion      IN aero_pistas.orientacion_grados%TYPE,
        p_tipo_superficie  IN aero_pistas.tipo_superficie%TYPE,
        p_carga_max_kg     IN aero_pistas.carga_max_kg%TYPE,
        p_iluminada        IN aero_pistas.iluminada%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_pistas (
            id_aeropuerto, designacion, longitud_m, ancho_m, 
            orientacion_grados, tipo_superficie, carga_max_kg, iluminada
        ) VALUES (
            p_id_aeropuerto, p_designacion, p_longitud_m, p_ancho_m, 
            p_orientacion, p_tipo_superficie, p_carga_max_kg, p_iluminada
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar pista: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_pista         IN aero_pistas.id_pista%TYPE,
        p_id_aeropuerto    IN aero_pistas.id_aeropuerto%TYPE,
        p_designacion      IN aero_pistas.designacion%TYPE,
        p_longitud_m       IN aero_pistas.longitud_m%TYPE,
        p_ancho_m          IN aero_pistas.ancho_m%TYPE,
        p_orientacion      IN aero_pistas.orientacion_grados%TYPE,
        p_tipo_superficie  IN aero_pistas.tipo_superficie%TYPE,
        p_estado           IN aero_pistas.estado%TYPE,
        p_carga_max_kg     IN aero_pistas.carga_max_kg%TYPE,
        p_iluminada        IN aero_pistas.iluminada%TYPE,
        p_activa           IN aero_pistas.activa%TYPE
    ) IS
    BEGIN
        UPDATE aero_pistas
        SET id_aeropuerto = p_id_aeropuerto,
            designacion = p_designacion,
            longitud_m = p_longitud_m,
            ancho_m = p_ancho_m,
            orientacion_grados = p_orientacion,
            tipo_superficie = p_tipo_superficie,
            estado = p_estado,
            carga_max_kg = p_carga_max_kg,
            iluminada = p_iluminada,
            activa = p_activa,
            actualizado_en = SYSTIMESTAMP
        WHERE id_pista = p_id_pista;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Pista no encontrada.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_pista IN aero_pistas.id_pista%TYPE
    ) IS
    BEGIN
        UPDATE aero_pistas SET activa = 'N', actualizado_en = SYSTIMESTAMP WHERE id_pista = p_id_pista;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT p.*, a.nombre as aeropuerto_nombre
            FROM aero_pistas p
            JOIN aero_aeropuertos a ON p.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.nombre, p.designacion ASC;
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
            WHERE id_aeropuerto = p_id_aeropuerto AND activa = 'S'
            ORDER BY designacion ASC;
    END pr_listar_por_aeropuerto;

END PKG_AERO_PISTAS;
/

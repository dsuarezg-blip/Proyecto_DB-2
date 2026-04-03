CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_UMBRALES_PISTA AS
    /**
     * Package: PKG_AERO_UMBRALES_PISTA
     * Descripción: Gestión de umbrales y puntos de toque en pista.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_pista    IN aero_umbrales_pista.id_pista%TYPE,
        p_designacion IN aero_umbrales_pista.designacion%TYPE,
        p_latitud     IN aero_umbrales_pista.latitud%TYPE,
        p_longitud    IN aero_umbrales_pista.longitud%TYPE,
        p_elevacion   IN aero_umbrales_pista.elevacion_ft%TYPE,
        p_desplazado  IN aero_umbrales_pista.desplazado_m%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_umbral   IN aero_umbrales_pista.id_umbral%TYPE,
        p_id_pista    IN aero_umbrales_pista.id_pista%TYPE,
        p_designacion IN aero_umbrales_pista.designacion%TYPE,
        p_latitud     IN aero_umbrales_pista.latitud%TYPE,
        p_longitud    IN aero_umbrales_pista.longitud%TYPE,
        p_elevacion   IN aero_umbrales_pista.elevacion_ft%TYPE,
        p_desplazado  IN aero_umbrales_pista.desplazado_m%TYPE,
        p_activo      IN aero_umbrales_pista.activo%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_umbral IN aero_umbrales_pista.id_umbral%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_pista (
        p_id_pista IN aero_umbrales_pista.id_pista%TYPE,
        p_cursor   OUT SYS_REFCURSOR
    );

END PKG_AERO_UMBRALES_PISTA;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_UMBRALES_PISTA AS

    PROCEDURE pr_insertar (
        p_id_pista    IN aero_umbrales_pista.id_pista%TYPE,
        p_designacion IN aero_umbrales_pista.designacion%TYPE,
        p_latitud     IN aero_umbrales_pista.latitud%TYPE,
        p_longitud    IN aero_umbrales_pista.longitud%TYPE,
        p_elevacion   IN aero_umbrales_pista.elevacion_ft%TYPE,
        p_desplazado  IN aero_umbrales_pista.desplazado_m%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_umbrales_pista (
            id_pista, designacion, latitud, longitud, 
            elevacion_ft, desplazado_m
        ) VALUES (
            p_id_pista, p_designacion, p_latitud, p_longitud, 
            p_elevacion, p_desplazado
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar umbral: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_umbral   IN aero_umbrales_pista.id_umbral%TYPE,
        p_id_pista    IN aero_umbrales_pista.id_pista%TYPE,
        p_designacion IN aero_umbrales_pista.designacion%TYPE,
        p_latitud     IN aero_umbrales_pista.latitud%TYPE,
        p_longitud    IN aero_umbrales_pista.longitud%TYPE,
        p_elevacion   IN aero_umbrales_pista.elevacion_ft%TYPE,
        p_desplazado  IN aero_umbrales_pista.desplazado_m%TYPE,
        p_activo      IN aero_umbrales_pista.activo%TYPE
    ) IS
    BEGIN
        UPDATE aero_umbrales_pista
        SET id_pista = p_id_pista,
            designacion = p_designacion,
            latitud = p_latitud,
            longitud = p_longitud,
            elevacion_ft = p_elevacion,
            desplazado_m = p_desplazado,
            activo = p_activo
        WHERE id_umbral = p_id_umbral;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Umbral no encontrado.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_umbral IN aero_umbrales_pista.id_umbral%TYPE
    ) IS
    BEGIN
        UPDATE aero_umbrales_pista SET activo = 'N' WHERE id_umbral = p_id_umbral;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT u.*, p.designacion as pista_original, a.nombre as aeropuerto_nombre
            FROM aero_umbrales_pista u
            JOIN aero_pistas p ON u.id_pista = p.id_pista
            JOIN aero_aeropuertos a ON p.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.nombre, p.designacion, u.designacion ASC;
    END pr_listar;

    PROCEDURE pr_listar_por_pista (
        p_id_pista IN aero_umbrales_pista.id_pista%TYPE,
        p_cursor   OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_umbrales_pista 
            WHERE id_pista = p_id_pista AND activo = 'S'
            ORDER BY designacion ASC;
    END pr_listar_por_pista;

END PKG_AERO_UMBRALES_PISTA;
/

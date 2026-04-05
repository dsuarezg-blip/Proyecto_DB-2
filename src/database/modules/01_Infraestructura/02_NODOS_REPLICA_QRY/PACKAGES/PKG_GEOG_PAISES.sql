CREATE OR REPLACE PACKAGE AEROGT.PKG_GEOG_PAISES AS
    /**
     * Package: PKG_GEOG_PAISES
     * Descripción: Gestión de países vinculados a continentes.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_continente   IN geog_paises.id_continente%TYPE,
        p_nombre          IN geog_paises.nombre%TYPE,
        p_codigo_iso2     IN geog_paises.codigo_iso2%TYPE,
        p_codigo_iso3     IN geog_paises.codigo_iso3%TYPE,
        p_cod_telefonico  IN geog_paises.codigo_telefonico%TYPE,
        p_moneda          IN geog_paises.moneda%TYPE,
        p_idioma          IN geog_paises.idioma_principal%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_pais         IN geog_paises.id_pais%TYPE,
        p_id_continente   IN geog_paises.id_continente%TYPE,
        p_nombre          IN geog_paises.nombre%TYPE,
        p_codigo_iso2     IN geog_paises.codigo_iso2%TYPE,
        p_codigo_iso3     IN geog_paises.codigo_iso3%TYPE,
        p_cod_telefonico  IN geog_paises.codigo_telefonico%TYPE,
        p_moneda          IN geog_paises.moneda%TYPE,
        p_idioma          IN geog_paises.idioma_principal%TYPE,
        p_activo          IN geog_paises.activo%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_pais IN geog_paises.id_pais%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_obtener_por_id (
        p_id_pais IN geog_paises.id_pais%TYPE,
        p_cursor  OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_continente (
        p_id_continente IN geog_paises.id_continente%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_GEOG_PAISES;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_GEOG_PAISES AS

    PROCEDURE pr_insertar (
        p_id_continente   IN geog_paises.id_continente%TYPE,
        p_nombre          IN geog_paises.nombre%TYPE,
        p_codigo_iso2     IN geog_paises.codigo_iso2%TYPE,
        p_codigo_iso3     IN geog_paises.codigo_iso3%TYPE,
        p_cod_telefonico  IN geog_paises.codigo_telefonico%TYPE,
        p_moneda          IN geog_paises.moneda%TYPE,
        p_idioma          IN geog_paises.idioma_principal%TYPE
    ) IS
    BEGIN
        INSERT INTO geog_paises (
            id_continente, nombre, codigo_iso2, codigo_iso3, 
            codigo_telefonico, moneda, idioma_principal
        ) VALUES (
            p_id_continente, p_nombre, p_codigo_iso2, p_codigo_iso3, 
            p_cod_telefonico, p_moneda, p_idioma
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar país: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_pais         IN geog_paises.id_pais%TYPE,
        p_id_continente   IN geog_paises.id_continente%TYPE,
        p_nombre          IN geog_paises.nombre%TYPE,
        p_codigo_iso2     IN geog_paises.codigo_iso2%TYPE,
        p_codigo_iso3     IN geog_paises.codigo_iso3%TYPE,
        p_cod_telefonico  IN geog_paises.codigo_telefonico%TYPE,
        p_moneda          IN geog_paises.moneda%TYPE,
        p_idioma          IN geog_paises.idioma_principal%TYPE,
        p_activo          IN geog_paises.activo%TYPE
    ) IS
    BEGIN
        UPDATE geog_paises
        SET id_continente = p_id_continente,
            nombre = p_nombre,
            codigo_iso2 = p_codigo_iso2,
            codigo_iso3 = p_codigo_iso3,
            codigo_telefonico = p_cod_telefonico,
            moneda = p_moneda,
            idioma_principal = p_idioma,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_pais = p_id_pais;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'País no encontrado.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_pais IN geog_paises.id_pais%TYPE
    ) IS
    BEGIN
        UPDATE geog_paises SET activo = 'N', actualizado_en = SYSTIMESTAMP WHERE id_pais = p_id_pais;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT p.*, c.nombre as continente_nombre
            FROM geog_paises p
            JOIN geog_continentes c ON p.id_continente = c.id_continente
            ORDER BY p.nombre ASC;
    END pr_listar;

    PROCEDURE pr_obtener_por_id (
        p_id_pais IN geog_paises.id_pais%TYPE,
        p_cursor  OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_paises WHERE id_pais = p_id_pais;
    END pr_obtener_por_id;

    PROCEDURE pr_listar_por_continente (
        p_id_continente IN geog_paises.id_continente%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_paises 
            WHERE id_continente = p_id_continente AND activo = 'S'
            ORDER BY nombre ASC;
    END pr_listar_por_continente;

END PKG_GEOG_PAISES;
/

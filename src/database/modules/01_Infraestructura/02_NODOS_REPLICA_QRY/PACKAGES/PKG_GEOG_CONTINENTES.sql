CREATE OR REPLACE PACKAGE AEROGT.PKG_GEOG_CONTINENTES AS
    /**
     * Package: PKG_GEOG_CONTINENTES
     * Descripción: Gestiona la información de los continentes para el sistema AeroGT.
     * Esquema: AEROGT
     * PDB: AERO_LA_AURORA
     * Autor: Backend Developer (AeroGT)
     */

    -- Procedimiento para insertar un nuevo continente
    PROCEDURE pr_insertar (
        p_nombre     IN geog_continentes.nombre%TYPE,
        p_codigo_iso IN geog_continentes.codigo_iso%TYPE
    );

    -- Procedimiento para actualizar un continente existente
    PROCEDURE pr_actualizar (
        p_id_continente IN geog_continentes.id_continente%TYPE,
        p_nombre        IN geog_continentes.nombre%TYPE,
        p_codigo_iso    IN geog_continentes.codigo_iso%TYPE,
        p_activo        IN geog_continentes.activo%TYPE
    );

    -- Procedimiento para eliminación lógica de un continente
    PROCEDURE pr_eliminar (
        p_id_continente IN geog_continentes.id_continente%TYPE
    );

    -- Procedimiento para listar todos los continentes (Retorna SYS_REFCURSOR)
    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    -- Procedimiento para obtener un continente por su ID (Retorna SYS_REFCURSOR)
    PROCEDURE pr_obtener_por_id (
        p_id_continente IN geog_continentes.id_continente%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_GEOG_CONTINENTES;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_GEOG_CONTINENTES AS

    PROCEDURE pr_insertar (
        p_nombre     IN geog_continentes.nombre%TYPE,
        p_codigo_iso IN geog_continentes.codigo_iso%TYPE
    ) IS
    BEGIN
        INSERT INTO geog_continentes (nombre, codigo_iso)
        VALUES (p_nombre, p_codigo_iso);
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error: El nombre o código ISO del continente ya existe.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error inesperado al insertar continente: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_continente IN geog_continentes.id_continente%TYPE,
        p_nombre        IN geog_continentes.nombre%TYPE,
        p_codigo_iso    IN geog_continentes.codigo_iso%TYPE,
        p_activo        IN geog_continentes.activo%TYPE
    ) IS
    BEGIN
        UPDATE geog_continentes
        SET nombre = p_nombre,
            codigo_iso = p_codigo_iso,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_continente = p_id_continente;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error: No se encontró el continente con ID ' || p_id_continente);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error inesperado al actualizar continente: ' || SQLERRM);
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_continente IN geog_continentes.id_continente%TYPE
    ) IS
    BEGIN
        -- Realizamos una eliminación lógica cambiando el estado a 'N'
        UPDATE geog_continentes
        SET activo = 'N',
            actualizado_en = SYSTIMESTAMP
        WHERE id_continente = p_id_continente;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error: No se encontró el continente con ID ' || p_id_continente);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error inesperado al eliminar continente: ' || SQLERRM);
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_continente, nombre, codigo_iso, activo, creado_en, actualizado_en
            FROM geog_continentes
            ORDER BY nombre ASC;
    END pr_listar;

    PROCEDURE pr_obtener_por_id (
        p_id_continente IN geog_continentes.id_continente%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_continente, nombre, codigo_iso, activo, creado_en, actualizado_en
            FROM geog_continentes
            WHERE id_continente = p_id_continente;
    END pr_obtener_por_id;

END PKG_GEOG_CONTINENTES;
/

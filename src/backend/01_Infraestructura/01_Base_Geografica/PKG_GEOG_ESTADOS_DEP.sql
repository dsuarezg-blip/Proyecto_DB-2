CREATE OR REPLACE PACKAGE AEROGT.PKG_GEOG_ESTADOS_DEP AS
    /**
     * Package: PKG_GEOG_ESTADOS_DEP
     * Descripción: Gestión de estados o departamentos subordinados a países.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_pais IN geog_estados_dep.id_pais%TYPE,
        p_nombre  IN geog_estados_dep.nombre%TYPE,
        p_codigo  IN geog_estados_dep.codigo%TYPE,
        p_tipo    IN geog_estados_dep.tipo%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_estado IN geog_estados_dep.id_estado%TYPE,
        p_id_pais   IN geog_estados_dep.id_pais%TYPE,
        p_nombre    IN geog_estados_dep.nombre%TYPE,
        p_codigo    IN geog_estados_dep.codigo%TYPE,
        p_tipo      IN geog_estados_dep.tipo%TYPE,
        p_activo    IN geog_estados_dep.activo%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_estado IN geog_estados_dep.id_estado%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_obtener_por_id (
        p_id_estado IN geog_estados_dep.id_estado%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_por_pais (
        p_id_pais IN geog_estados_dep.id_pais%TYPE,
        p_cursor  OUT SYS_REFCURSOR
    );

END PKG_GEOG_ESTADOS_DEP;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_GEOG_ESTADOS_DEP AS

    PROCEDURE pr_insertar (
        p_id_pais IN geog_estados_dep.id_pais%TYPE,
        p_nombre  IN geog_estados_dep.nombre%TYPE,
        p_codigo  IN geog_estados_dep.codigo%TYPE,
        p_tipo    IN geog_estados_dep.tipo%TYPE
    ) IS
    BEGIN
        INSERT INTO geog_estados_dep (id_pais, nombre, codigo, tipo)
        VALUES (p_id_pais, p_nombre, p_codigo, p_tipo);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar estado/departamento: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_estado IN geog_estados_dep.id_estado%TYPE,
        p_id_pais   IN geog_estados_dep.id_pais%TYPE,
        p_nombre    IN geog_estados_dep.nombre%TYPE,
        p_codigo    IN geog_estados_dep.codigo%TYPE,
        p_tipo      IN geog_estados_dep.tipo%TYPE,
        p_activo    IN geog_estados_dep.activo%TYPE
    ) IS
    BEGIN
        UPDATE geog_estados_dep
        SET id_pais = p_id_pais,
            nombre = p_nombre,
            codigo = p_codigo,
            tipo = p_tipo,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_estado = p_id_estado;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Estado/Departamento no encontrado.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_estado IN geog_estados_dep.id_estado%TYPE
    ) IS
    BEGIN
        UPDATE geog_estados_dep SET activo = 'N', actualizado_en = SYSTIMESTAMP WHERE id_estado = p_id_estado;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT e.*, p.nombre as pais_nombre
            FROM geog_estados_dep e
            JOIN geog_paises p ON e.id_pais = p.id_pais
            ORDER BY p.nombre, e.nombre ASC;
    END pr_listar;

    PROCEDURE pr_obtener_por_id (
        p_id_estado IN geog_estados_dep.id_estado%TYPE,
        p_cursor    OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_estados_dep WHERE id_estado = p_id_estado;
    END pr_obtener_por_id;

    PROCEDURE pr_listar_por_pais (
        p_id_pais IN geog_estados_dep.id_pais%TYPE,
        p_cursor  OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM geog_estados_dep 
            WHERE id_pais = p_id_pais AND activo = 'S'
            ORDER BY nombre ASC;
    END pr_listar_por_pais;

END PKG_GEOG_ESTADOS_DEP;
/

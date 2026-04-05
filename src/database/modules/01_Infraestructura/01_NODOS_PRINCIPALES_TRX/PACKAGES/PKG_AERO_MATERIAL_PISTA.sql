CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_MATERIAL_PISTA AS
    /**
     * Package: PKG_AERO_MATERIAL_PISTA
     * Descripción: Control de materiales y mantenimiento de pavimentos de pista.
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_pista        IN aero_material_pista.id_pista%TYPE,
        p_tipo_material   IN aero_material_pista.tipo_material%TYPE,
        p_fecha_reparacion IN aero_material_pista.fecha_ultima_reparacion%TYPE,
        p_vida_util       IN aero_material_pista.vida_util_anios%TYPE,
        p_pcn_valor       IN aero_material_pista.pcn_valor%TYPE,
        p_notas           IN aero_material_pista.notas%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_material     IN aero_material_pista.id_material%TYPE,
        p_id_pista        IN aero_material_pista.id_pista%TYPE,
        p_tipo_material   IN aero_material_pista.tipo_material%TYPE,
        p_fecha_reparacion IN aero_material_pista.fecha_ultima_reparacion%TYPE,
        p_vida_util       IN aero_material_pista.vida_util_anios%TYPE,
        p_pcn_valor       IN aero_material_pista.pcn_valor%TYPE,
        p_notas           IN aero_material_pista.notas%TYPE
    );

    PROCEDURE pr_eliminar (
        p_id_material IN aero_material_pista.id_material%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

    PROCEDURE pr_obtener_por_pista (
        p_id_pista IN aero_material_pista.id_pista%TYPE,
        p_cursor   OUT SYS_REFCURSOR
    );

END PKG_AERO_MATERIAL_PISTA;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_MATERIAL_PISTA AS

    PROCEDURE pr_insertar (
        p_id_pista        IN aero_material_pista.id_pista%TYPE,
        p_tipo_material   IN aero_material_pista.tipo_material%TYPE,
        p_fecha_reparacion IN aero_material_pista.fecha_ultima_reparacion%TYPE,
        p_vida_util       IN aero_material_pista.vida_util_anios%TYPE,
        p_pcn_valor       IN aero_material_pista.pcn_valor%TYPE,
        p_notas           IN aero_material_pista.notas%TYPE
    ) IS
    BEGIN
        INSERT INTO aero_material_pista (
            id_pista, tipo_material, fecha_ultima_reparacion, 
            vida_util_anios, pcn_valor, notas
        ) VALUES (
            p_id_pista, p_tipo_material, p_fecha_reparacion, 
            p_vida_util, p_pcn_valor, p_notas
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar material de pista: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_material     IN aero_material_pista.id_material%TYPE,
        p_id_pista        IN aero_material_pista.id_pista%TYPE,
        p_tipo_material   IN aero_material_pista.tipo_material%TYPE,
        p_fecha_reparacion IN aero_material_pista.fecha_ultima_reparacion%TYPE,
        p_vida_util       IN aero_material_pista.vida_util_anios%TYPE,
        p_pcn_valor       IN aero_material_pista.pcn_valor%TYPE,
        p_notas           IN aero_material_pista.notas%TYPE
    ) IS
    BEGIN
        UPDATE aero_material_pista
        SET id_pista = p_id_pista,
            tipo_material = p_tipo_material,
            fecha_ultima_reparacion = p_fecha_reparacion,
            vida_util_anios = p_vida_util,
            pcn_valor = p_pcn_valor,
            notas = p_notas,
            actualizado_en = SYSTIMESTAMP
        WHERE id_material = p_id_material;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Material no encontrado.');
        END IF;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_eliminar (
        p_id_material IN aero_material_pista.id_material%TYPE
    ) IS
    BEGIN
        DELETE FROM aero_material_pista WHERE id_material = p_id_material;
        COMMIT;
    END pr_eliminar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT m.*, p.designacion as pista_designacion, a.nombre as aeropuerto_nombre
            FROM aero_material_pista m
            JOIN aero_pistas p ON m.id_pista = p.id_pista
            JOIN aero_aeropuertos a ON p.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.nombre, p.designacion ASC;
    END pr_listar;

    PROCEDURE pr_obtener_por_pista (
        p_id_pista IN aero_material_pista.id_pista%TYPE,
        p_cursor   OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_material_pista WHERE id_pista = p_id_pista;
    END pr_obtener_por_pista;

END PKG_AERO_MATERIAL_PISTA;
/

CREATE OR REPLACE PACKAGE PKG_AERO_BODEGAS_LOG AS
    /**
     * Package: PKG_AERO_BODEGAS_LOG
     * Descripción: Soporte para almacenamiento de carga y logística de suministros.
     */

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_capacidad_kg  IN NUMBER,
        p_temp_control  IN CHAR
    );

    PROCEDURE pr_actualizar (
        p_id_bodega     IN NUMBER,
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_capacidad_kg  IN NUMBER,
        p_temp_control  IN CHAR,
        p_estado        IN VARCHAR2,
        p_activa        IN CHAR
    );

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_AERO_BODEGAS_LOG;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_BODEGAS_LOG AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_capacidad_kg  IN NUMBER,
        p_temp_control  IN CHAR
    ) IS
    BEGIN
        INSERT INTO aero_bodegas_log (
            id_aeropuerto, nombre, tipo, area_m2, 
            capacidad_kg, temperatura_controlada, estado, activa
        ) VALUES (
            p_id_aeropuerto, p_nombre, p_tipo, p_area_m2, 
            p_capacidad_kg, p_temp_control, 'OPERATIVA', 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar bodega: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_bodega     IN NUMBER,
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_capacidad_kg  IN NUMBER,
        p_temp_control  IN CHAR,
        p_estado        IN VARCHAR2,
        p_activa        IN CHAR
    ) IS
    BEGIN
        UPDATE aero_bodegas_log
        SET id_aeropuerto = p_id_aeropuerto,
            nombre = p_nombre,
            tipo = p_tipo,
            area_m2 = p_area_m2,
            capacidad_kg = p_capacidad_kg,
            temperatura_controlada = p_temp_control,
            estado = p_estado,
            activa = p_activa,
            actualizado_en = SYSTIMESTAMP
        WHERE id_bodega = p_id_bodega;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_listar (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                nombre                 AS Nombre_Bodega,
                tipo                   AS Tipo_Almacenamiento,
                area_m2                AS Superficie_M2,
                capacidad_kg           AS Capacidad_KG,
                temperatura_controlada AS Climatizada,
                estado                 AS Estado_Operativo,
                activa                 AS Activa
            FROM aero_bodegas_log
            WHERE id_aeropuerto = p_id_aeropuerto
            ORDER BY nombre ASC;
    END pr_listar;

END PKG_AERO_BODEGAS_LOG;
/

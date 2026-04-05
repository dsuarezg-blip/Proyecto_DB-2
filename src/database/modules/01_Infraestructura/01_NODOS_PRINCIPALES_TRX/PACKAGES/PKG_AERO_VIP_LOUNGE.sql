CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_VIP_LOUNGE AS
    /**
     * Package: PKG_AERO_VIP_LOUNGE
     * Descripción: Gestión de salas VIP (Alineado con requerimientos UI).
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_terminal    IN AEROGT.aero_vip_lounge.id_terminal%TYPE,
        p_nombre         IN AEROGT.aero_vip_lounge.nombre%TYPE,
        p_operador       IN AEROGT.aero_vip_lounge.operador%TYPE,
        p_capacidad      IN AEROGT.aero_vip_lounge.capacidad%TYPE,
        p_precio_usd     IN AEROGT.aero_vip_lounge.precio_acceso_usd%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_vip         IN AEROGT.aero_vip_lounge.id_vip%TYPE,
        p_id_terminal    IN AEROGT.aero_vip_lounge.id_terminal%TYPE,
        p_nombre         IN AEROGT.aero_vip_lounge.nombre%TYPE,
        p_operador       IN AEROGT.aero_vip_lounge.operador%TYPE,
        p_capacidad      IN AEROGT.aero_vip_lounge.capacidad%TYPE,
        p_precio_usd     IN AEROGT.aero_vip_lounge.precio_acceso_usd%TYPE,
        p_activo         IN AEROGT.aero_vip_lounge.activo%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_VIP_LOUNGE;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_VIP_LOUNGE AS

    PROCEDURE pr_insertar (
        p_id_terminal    IN AEROGT.aero_vip_lounge.id_terminal%TYPE,
        p_nombre         IN AEROGT.aero_vip_lounge.nombre%TYPE,
        p_operador       IN AEROGT.aero_vip_lounge.operador%TYPE,
        p_capacidad      IN AEROGT.aero_vip_lounge.capacidad%TYPE,
        p_precio_usd     IN AEROGT.aero_vip_lounge.precio_acceso_usd%TYPE
    ) IS
    BEGIN
        INSERT INTO AEROGT.aero_vip_lounge (
            id_terminal, nombre, operador, capacidad, precio_acceso_usd, activo
        ) VALUES (
            p_id_terminal, p_nombre, p_operador, p_capacidad, p_precio_usd, 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar sala VIP: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_vip         IN AEROGT.aero_vip_lounge.id_vip%TYPE,
        p_id_terminal    IN AEROGT.aero_vip_lounge.id_terminal%TYPE,
        p_nombre         IN AEROGT.aero_vip_lounge.nombre%TYPE,
        p_operador       IN AEROGT.aero_vip_lounge.operador%TYPE,
        p_capacidad      IN AEROGT.aero_vip_lounge.capacidad%TYPE,
        p_precio_usd     IN AEROGT.aero_vip_lounge.precio_acceso_usd%TYPE,
        p_activo         IN AEROGT.aero_vip_lounge.activo%TYPE
    ) IS
    BEGIN
        UPDATE AEROGT.aero_vip_lounge
        SET id_terminal = p_id_terminal,
            nombre = p_nombre,
            operador = p_operador,
            capacidad = p_capacidad,
            precio_acceso_usd = p_precio_usd,
            activo = p_activo
        WHERE id_vip = p_id_vip;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                v.id_vip            AS ID,
                t.nombre            AS Terminal_Ubicacion,
                v.nombre            AS Nombre_Sala_VIP,
                v.operador          AS Operador_Sala,
                v.capacidad         AS Capacidad_Maxima,
                v.precio_acceso_usd AS Precio_Acceso_USD,
                v.activo            AS Estado_Activo
            FROM AEROGT.aero_vip_lounge v
            JOIN AEROGT.aero_terminales t ON v.id_terminal = t.id_terminal
            ORDER BY t.nombre, v.nombre ASC;
    END pr_listar;

END PKG_AERO_VIP_LOUNGE;
/

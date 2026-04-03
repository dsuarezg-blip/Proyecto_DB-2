CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_SISTEMAS_EQUIPAJE AS
    /**
     * Package: PKG_AERO_SISTEMAS_EQUIPAJE
     * Descripción: Gestión de bandas de equipaje y logística (Alineado con requerimientos UI).
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_terminal   IN AEROGT.aero_sistemas_equipaje.id_terminal%TYPE,
        p_codigo        IN AEROGT.aero_sistemas_equipaje.codigo%TYPE,
        p_tipo          IN AEROGT.aero_sistemas_equipaje.tipo%TYPE,
        p_longitud_m    IN AEROGT.aero_sistemas_equipaje.longitud_m%TYPE,
        p_capacidad_mal IN AEROGT.aero_sistemas_equipaje.capacidad_maletas_hora%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_banda      IN AEROGT.aero_sistemas_equipaje.id_banda%TYPE,
        p_id_terminal   IN AEROGT.aero_sistemas_equipaje.id_terminal%TYPE,
        p_codigo        IN AEROGT.aero_sistemas_equipaje.codigo%TYPE,
        p_tipo          IN AEROGT.aero_sistemas_equipaje.tipo%TYPE,
        p_longitud_m    IN AEROGT.aero_sistemas_equipaje.longitud_m%TYPE,
        p_capacidad_mal IN AEROGT.aero_sistemas_equipaje.capacidad_maletas_hora%TYPE,
        p_estado        IN AEROGT.aero_sistemas_equipaje.estado%TYPE,
        p_activo        IN AEROGT.aero_sistemas_equipaje.activo%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_SISTEMAS_EQUIPAJE;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_SISTEMAS_EQUIPAJE AS

    PROCEDURE pr_insertar (
        p_id_terminal   IN AEROGT.aero_sistemas_equipaje.id_terminal%TYPE,
        p_codigo        IN AEROGT.aero_sistemas_equipaje.codigo%TYPE,
        p_tipo          IN AEROGT.aero_sistemas_equipaje.tipo%TYPE,
        p_longitud_m    IN AEROGT.aero_sistemas_equipaje.longitud_m%TYPE,
        p_capacidad_mal IN AEROGT.aero_sistemas_equipaje.capacidad_maletas_hora%TYPE
    ) IS
    BEGIN
        INSERT INTO AEROGT.aero_sistemas_equipaje (
            id_terminal, codigo, tipo, longitud_m, capacidad_maletas_hora
        ) VALUES (
            p_id_terminal, p_codigo, p_tipo, p_longitud_m, p_capacidad_mal
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar sistema de equipaje: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_banda      IN AEROGT.aero_sistemas_equipaje.id_banda%TYPE,
        p_id_terminal   IN AEROGT.aero_sistemas_equipaje.id_terminal%TYPE,
        p_codigo        IN AEROGT.aero_sistemas_equipaje.codigo%TYPE,
        p_tipo          IN AEROGT.aero_sistemas_equipaje.tipo%TYPE,
        p_longitud_m    IN AEROGT.aero_sistemas_equipaje.longitud_m%TYPE,
        p_capacidad_mal IN AEROGT.aero_sistemas_equipaje.capacidad_maletas_hora%TYPE,
        p_estado        IN AEROGT.aero_sistemas_equipaje.estado%TYPE,
        p_activo        IN AEROGT.aero_sistemas_equipaje.activo%TYPE
    ) IS
    BEGIN
        UPDATE AEROGT.aero_sistemas_equipaje
        SET id_terminal = p_id_terminal,
            codigo = p_codigo,
            tipo = p_tipo,
            longitud_m = p_longitud_m,
            capacidad_maletas_hora = p_capacidad_mal,
            estado = p_estado,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_banda = p_id_banda;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                b.id_banda      AS ID,
                t.nombre        AS Terminal,
                b.codigo        AS Codigo_Banda,
                b.tipo          AS Tipo_Sistema,
                b.longitud_m    AS Longitud_Metros,
                b.capacidad_maletas_hora AS Capacidad_Maletas_Hora,
                b.estado        AS Estado_Operativo,
                b.activo        AS Activo
            FROM AEROGT.aero_sistemas_equipaje b
            JOIN AEROGT.aero_terminales t ON b.id_terminal = t.id_terminal
            ORDER BY t.nombre, b.codigo ASC;
    END pr_listar;

END PKG_AERO_SISTEMAS_EQUIPAJE;
/

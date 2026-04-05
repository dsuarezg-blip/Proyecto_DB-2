CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_SALAS_ESPERA AS
    /**
     * Package: PKG_AERO_SALAS_ESPERA
     * Descripción: Gestión de salas de espera y confort (Alineado con DDL real).
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_terminal   IN AEROGT.aero_salas_espera.id_terminal%TYPE,
        p_nombre        IN AEROGT.aero_salas_espera.nombre%TYPE,
        p_capacidad     IN AEROGT.aero_salas_espera.capacidad_personas%TYPE,
        p_wifi          IN AEROGT.aero_salas_espera.tiene_wifi%TYPE,
        p_enchufes      IN AEROGT.aero_salas_espera.tiene_enchufes%TYPE,
        p_area          IN AEROGT.aero_salas_espera.area_m2%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_sala       IN AEROGT.aero_salas_espera.id_sala%TYPE,
        p_id_terminal   IN AEROGT.aero_salas_espera.id_terminal%TYPE,
        p_nombre        IN AEROGT.aero_salas_espera.nombre%TYPE,
        p_capacidad     IN AEROGT.aero_salas_espera.capacidad_personas%TYPE,
        p_wifi          IN AEROGT.aero_salas_espera.tiene_wifi%TYPE,
        p_enchufes      IN AEROGT.aero_salas_espera.tiene_enchufes%TYPE,
        p_area          IN AEROGT.aero_salas_espera.area_m2%TYPE,
        p_activa        IN AEROGT.aero_salas_espera.activa%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_SALAS_ESPERA;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_SALAS_ESPERA AS

    PROCEDURE pr_insertar (
        p_id_terminal   IN AEROGT.aero_salas_espera.id_terminal%TYPE,
        p_nombre        IN AEROGT.aero_salas_espera.nombre%TYPE,
        p_capacidad     IN AEROGT.aero_salas_espera.capacidad_personas%TYPE,
        p_wifi          IN AEROGT.aero_salas_espera.tiene_wifi%TYPE,
        p_enchufes      IN AEROGT.aero_salas_espera.tiene_enchufes%TYPE,
        p_area          IN AEROGT.aero_salas_espera.area_m2%TYPE
    ) IS
    BEGIN
        INSERT INTO AEROGT.aero_salas_espera (
            id_terminal, nombre, capacidad_personas, tiene_wifi, tiene_enchufes, area_m2, activa
        ) VALUES (
            p_id_terminal, p_nombre, p_capacidad, p_wifi, p_enchufes, p_area, 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar sala de espera: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_sala       IN AEROGT.aero_salas_espera.id_sala%TYPE,
        p_id_terminal   IN AEROGT.aero_salas_espera.id_terminal%TYPE,
        p_nombre        IN AEROGT.aero_salas_espera.nombre%TYPE,
        p_capacidad     IN AEROGT.aero_salas_espera.capacidad_personas%TYPE,
        p_wifi          IN AEROGT.aero_salas_espera.tiene_wifi%TYPE,
        p_enchufes      IN AEROGT.aero_salas_espera.tiene_enchufes%TYPE,
        p_area          IN AEROGT.aero_salas_espera.area_m2%TYPE,
        p_activa        IN AEROGT.aero_salas_espera.activa%TYPE
    ) IS
    BEGIN
        UPDATE AEROGT.aero_salas_espera
        SET id_terminal = p_id_terminal,
            nombre = p_nombre,
            capacidad_personas = p_capacidad,
            tiene_wifi = p_wifi,
            tiene_enchufes = p_enchufes,
            area_m2 = p_area,
            activa = p_activa
        WHERE id_sala = p_id_sala;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                s.id_sala            AS ID,
                t.nombre             AS Terminal,
                s.nombre             AS Nombre_Sala,
                s.capacidad_personas AS Aforo_Maximo,
                s.tiene_wifi         AS Cuenta_Con_WiFi,
                s.tiene_enchufes     AS Cuenta_Con_Tomas,
                s.area_m2            AS Metros_Cuadrados,
                s.activa             AS Estado_Activa
            FROM AEROGT.aero_salas_espera s
            JOIN AEROGT.aero_terminales t ON s.id_terminal = t.id_terminal
            ORDER BY t.nombre, s.nombre ASC;
    END pr_listar;

END PKG_AERO_SALAS_ESPERA;
/

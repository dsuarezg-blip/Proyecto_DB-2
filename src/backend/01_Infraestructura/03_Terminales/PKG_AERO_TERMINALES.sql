CREATE OR REPLACE PACKAGE PKG_AERO_TERMINALES AS
    /**
     * Package: PKG_AERO_TERMINALES
     * Descripción: Gestión de terminales (Alineado con DDL real: capacidad_pax_hora, codigo, etc).
     */

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_codigo        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_nivel_pisos   IN NUMBER,
        p_capacidad_hr  IN NUMBER
    );

    PROCEDURE pr_actualizar (
        p_id_terminal   IN NUMBER,
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_codigo        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_nivel_pisos   IN NUMBER,
        p_capacidad_hr  IN NUMBER,
        p_estado        IN VARCHAR2,
        p_activa        IN CHAR
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_TERMINALES;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_TERMINALES AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_codigo        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_nivel_pisos   IN NUMBER,
        p_capacidad_hr  IN NUMBER
    ) IS
    BEGIN
        INSERT INTO aero_terminales (
            id_aeropuerto, nombre, codigo, tipo, area_m2, 
            nivel_pisos, capacidad_pax_hora, estado, activa
        ) VALUES (
            p_id_aeropuerto, p_nombre, p_codigo, p_tipo, p_area_m2, 
            p_nivel_pisos, p_capacidad_hr, 'OPERATIVA', 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar terminal: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_terminal   IN NUMBER,
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_codigo        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_area_m2       IN NUMBER,
        p_nivel_pisos   IN NUMBER,
        p_capacidad_hr  IN NUMBER,
        p_estado        IN VARCHAR2,
        p_activa        IN CHAR
    ) IS
    BEGIN
        UPDATE aero_terminales
        SET id_aeropuerto = p_id_aeropuerto,
            nombre = p_nombre,
            codigo = p_codigo,
            tipo = p_tipo,
            area_m2 = p_area_m2,
            nivel_pisos = p_nivel_pisos,
            capacidad_pax_hora = p_capacidad_hr,
            estado = p_estado,
            activa = p_activa,
            actualizado_en = SYSTIMESTAMP
        WHERE id_terminal = p_id_terminal;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                t.id_terminal        AS ID,
                a.nombre             AS Aeropuerto,
                t.nombre             AS Nombre_Terminal,
                t.codigo             AS Codigo_Terminal,
                t.tipo               AS Tipo_Terminal,
                t.area_m2            AS Superficie_M2,
                t.nivel_pisos        AS Niveles,
                t.capacidad_pax_hora AS Capacidad_PAX_Hora,
                t.estado             AS Estado_Operativo,
                t.activa             AS Activa
            FROM aero_terminales t
            JOIN aero_aeropuertos a ON t.id_aeropuerto = a.id_aeropuerto
            ORDER BY a.nombre, t.nombre ASC;
    END pr_listar;

END PKG_AERO_TERMINALES;
/

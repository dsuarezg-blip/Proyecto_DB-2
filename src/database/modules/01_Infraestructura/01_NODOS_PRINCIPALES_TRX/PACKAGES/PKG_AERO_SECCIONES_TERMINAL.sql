CREATE OR REPLACE PACKAGE BODY PKG_AERO_SECCIONES_TERMINAL AS
    PROCEDURE pr_insertar (
        p_id_terminal IN NUMBER,
        p_nombre      IN VARCHAR2,
        p_tipo        IN VARCHAR2,
        p_nivel       IN NUMBER,
        p_area_m2     IN NUMBER
    ) IS
    BEGIN
        INSERT INTO aero_secciones_terminal (
            id_terminal, nombre, tipo, nivel, area_m2, activa
        ) VALUES (
            p_id_terminal, p_nombre, p_tipo, p_nivel, p_area_m2, 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar seccion: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_seccion  IN NUMBER,
        p_id_terminal IN NUMBER,
        p_nombre      IN VARCHAR2,
        p_tipo        IN VARCHAR2,
        p_nivel       IN NUMBER,
        p_area_m2     IN NUMBER,
        p_activa      IN CHAR
    ) IS
    BEGIN
        UPDATE aero_secciones_terminal
        SET id_terminal    = p_id_terminal,
            nombre         = p_nombre,
            tipo           = p_tipo,
            nivel          = p_nivel,
            area_m2        = p_area_m2,
            activa         = p_activa,
            actualizado_en = SYSTIMESTAMP
        WHERE id_seccion = p_id_seccion;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT
                s.id_seccion   AS ID_SECCION,
                s.id_terminal  AS ID_TERMINAL,
                t.nombre       AS TERMINAL,
                s.nombre       AS NOMBRE,
                s.tipo         AS TIPO,
                s.nivel        AS NIVEL,
                s.area_m2      AS AREA_M2,
                s.activa       AS ACTIVA
            FROM aero_secciones_terminal s
            JOIN aero_terminales t ON s.id_terminal = t.id_terminal
            ORDER BY t.nombre, s.nivel, s.nombre ASC;
    END pr_listar;
END PKG_AERO_SECCIONES_TERMINAL;
/
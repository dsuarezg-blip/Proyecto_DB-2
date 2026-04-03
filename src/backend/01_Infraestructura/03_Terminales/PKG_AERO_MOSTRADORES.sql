CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_MOSTRADORES AS
    /**
     * Package: PKG_AERO_MOSTRADORES
     * Descripción: Gestión de mostradores de check-in y atención (Alineado con requerimientos UI).
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_terminal IN AEROGT.aero_mostradores.id_terminal%TYPE,
        p_codigo      IN AEROGT.aero_mostradores.codigo%TYPE,
        p_tipo        IN AEROGT.aero_mostradores.tipo%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_counter  IN AEROGT.aero_mostradores.id_counter%TYPE,
        p_id_terminal IN AEROGT.aero_mostradores.id_terminal%TYPE,
        p_codigo      IN AEROGT.aero_mostradores.codigo%TYPE,
        p_tipo        IN AEROGT.aero_mostradores.tipo%TYPE,
        p_activo      IN AEROGT.aero_mostradores.activo%TYPE
    );

    PROCEDURE pr_actualizar_estado (
        p_id_counter IN AEROGT.aero_mostradores.id_counter%TYPE,
        p_estado     IN AEROGT.aero_mostradores.estado%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_MOSTRADORES;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_MOSTRADORES AS

    PROCEDURE pr_insertar (
        p_id_terminal IN AEROGT.aero_mostradores.id_terminal%TYPE,
        p_codigo      IN AEROGT.aero_mostradores.codigo%TYPE,
        p_tipo        IN AEROGT.aero_mostradores.tipo%TYPE
    ) IS
    BEGIN
        INSERT INTO AEROGT.aero_mostradores (
            id_terminal, codigo, tipo, estado, activo
        ) VALUES (
            p_id_terminal, p_codigo, p_tipo, 'CERRADO', 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar mostrador: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_counter  IN AEROGT.aero_mostradores.id_counter%TYPE,
        p_id_terminal IN AEROGT.aero_mostradores.id_terminal%TYPE,
        p_codigo      IN AEROGT.aero_mostradores.codigo%TYPE,
        p_tipo        IN AEROGT.aero_mostradores.tipo%TYPE,
        p_activo      IN AEROGT.aero_mostradores.activo%TYPE
    ) IS
    BEGIN
        UPDATE AEROGT.aero_mostradores
        SET id_terminal = p_id_terminal,
            codigo = p_codigo,
            tipo = p_tipo,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_counter = p_id_counter;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_actualizar_estado (
        p_id_counter IN AEROGT.aero_mostradores.id_counter%TYPE,
        p_estado     IN AEROGT.aero_mostradores.estado%TYPE
    ) IS
    BEGIN
        UPDATE AEROGT.aero_mostradores
        SET estado = p_estado,
            actualizado_en = SYSTIMESTAMP
        WHERE id_counter = p_id_counter;
        COMMIT;
    END pr_actualizar_estado;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                m.id_counter AS ID,
                t.nombre      AS Terminal,
                m.codigo      AS Codigo_Mostrador,
                m.tipo        AS Tipo_Servicio,
                m.estado      AS Estado_Actual,
                m.activo      AS Habilitado
            FROM AEROGT.aero_mostradores m
            JOIN AEROGT.aero_terminales t ON m.id_terminal = t.id_terminal
            ORDER BY t.nombre, m.codigo ASC;
    END pr_listar;

END PKG_AERO_MOSTRADORES;
/

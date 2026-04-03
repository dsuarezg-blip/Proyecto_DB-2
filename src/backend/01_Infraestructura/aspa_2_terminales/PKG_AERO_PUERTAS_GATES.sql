CREATE OR REPLACE PACKAGE AEROGT.PKG_AERO_PUERTAS_GATES AS
    /**
     * Package: PKG_AERO_PUERTAS_GATES
     * Descripción: Control de puertas de embarque y mangas (Alineado con requerimientos UI).
     * Esquema: AEROGT
     */

    PROCEDURE pr_insertar (
        p_id_seccion    IN AEROGT.aero_puertas_gates.id_seccion%TYPE,
        p_codigo        IN AEROGT.aero_puertas_gates.codigo%TYPE,
        p_tipo          IN AEROGT.aero_puertas_gates.tipo%TYPE,
        p_capacidad_pax IN AEROGT.aero_puertas_gates.capacidad_pax%TYPE,
        p_tiene_jetway  IN AEROGT.aero_puertas_gates.tiene_jetway%TYPE
    );

    PROCEDURE pr_actualizar (
        p_id_gate       IN AEROGT.aero_puertas_gates.id_gate%TYPE,
        p_id_seccion    IN AEROGT.aero_puertas_gates.id_seccion%TYPE,
        p_codigo        IN AEROGT.aero_puertas_gates.codigo%TYPE,
        p_tipo          IN AEROGT.aero_puertas_gates.tipo%TYPE,
        p_capacidad_pax IN AEROGT.aero_puertas_gates.capacidad_pax%TYPE,
        p_tiene_jetway  IN AEROGT.aero_puertas_gates.tiene_jetway%TYPE,
        p_activo        IN AEROGT.aero_puertas_gates.activo%TYPE
    );

    PROCEDURE pr_actualizar_estado (
        p_id_gate IN AEROGT.aero_puertas_gates.id_gate%TYPE,
        p_estado  IN AEROGT.aero_puertas_gates.estado%TYPE
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_PUERTAS_GATES;
/

CREATE OR REPLACE PACKAGE BODY AEROGT.PKG_AERO_PUERTAS_GATES AS

    PROCEDURE pr_insertar (
        p_id_seccion    IN AEROGT.aero_puertas_gates.id_seccion%TYPE,
        p_codigo        IN AEROGT.aero_puertas_gates.codigo%TYPE,
        p_tipo          IN AEROGT.aero_puertas_gates.tipo%TYPE,
        p_capacidad_pax IN AEROGT.aero_puertas_gates.capacidad_pax%TYPE,
        p_tiene_jetway  IN AEROGT.aero_puertas_gates.tiene_jetway%TYPE
    ) IS
    BEGIN
        INSERT INTO AEROGT.aero_puertas_gates (
            id_seccion, codigo, tipo, capacidad_pax, tiene_jetway, estado, activo
        ) VALUES (
            p_id_seccion, p_codigo, p_tipo, p_capacidad_pax, p_tiene_jetway, 'DISPONIBLE', 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar puerta: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_gate       IN AEROGT.aero_puertas_gates.id_gate%TYPE,
        p_id_seccion    IN AEROGT.aero_puertas_gates.id_seccion%TYPE,
        p_codigo        IN AEROGT.aero_puertas_gates.codigo%TYPE,
        p_tipo          IN AEROGT.aero_puertas_gates.tipo%TYPE,
        p_capacidad_pax IN AEROGT.aero_puertas_gates.capacidad_pax%TYPE,
        p_tiene_jetway  IN AEROGT.aero_puertas_gates.tiene_jetway%TYPE,
        p_activo        IN AEROGT.aero_puertas_gates.activo%TYPE
    ) IS
    BEGIN
        UPDATE AEROGT.aero_puertas_gates
        SET id_seccion = p_id_seccion,
            codigo = p_codigo,
            tipo = p_tipo,
            capacidad_pax = p_capacidad_pax,
            tiene_jetway = p_tiene_jetway,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_gate = p_id_gate;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_actualizar_estado (
        p_id_gate IN AEROGT.aero_puertas_gates.id_gate%TYPE,
        p_estado  IN AEROGT.aero_puertas_gates.estado%TYPE
    ) IS
    BEGIN
        UPDATE AEROGT.aero_puertas_gates
        SET estado = p_estado,
            actualizado_en = SYSTIMESTAMP
        WHERE id_gate = p_id_gate;
        COMMIT;
    END pr_actualizar_estado;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                g.id_gate        AS ID,
                t.nombre         AS Terminal,
                s.nombre         AS Seccion,
                g.codigo         AS Puerto_Gato,
                g.tipo           AS Tipo_Puerta,
                g.capacidad_pax  AS Capacidad_PAX,
                g.tiene_jetway   AS Tiene_Manga,
                g.estado         AS Estado_Actual,
                g.activo         AS Activo
            FROM AEROGT.aero_puertas_gates g
            JOIN AEROGT.aero_secciones_terminal s ON g.id_seccion = s.id_seccion
            JOIN AEROGT.aero_terminales t ON s.id_terminal = t.id_terminal
            ORDER BY t.nombre, s.nombre, g.codigo ASC;
    END pr_listar;

END PKG_AERO_PUERTAS_GATES;
/

CREATE OR REPLACE PACKAGE PKG_AERO_EQUIPOS_APOYO AS
    /**
     * Package: PKG_AERO_EQUIPOS_APOYO (Ground Support Equipment - GSE).
     * Descripción: Gestión de equipos técnicos y alertas de mantenimiento preventivo.
     * Esquema: Infraestructura Técnica
     */

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_marca         IN VARCHAR2,
        p_modelo        IN VARCHAR2,
        p_serial        IN VARCHAR2,
        p_f_adquisicion IN DATE,
        p_f_prox_mant   IN DATE
    );

    PROCEDURE pr_actualizar (
        p_id_equipo     IN NUMBER,
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_marca         IN VARCHAR2,
        p_modelo        IN VARCHAR2,
        p_serial        IN VARCHAR2,
        p_estado        IN VARCHAR2,
        p_f_prox_mant   IN DATE,
        p_activo        IN CHAR
    );

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_EQUIPOS_APOYO;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_EQUIPOS_APOYO AS

    PROCEDURE pr_insertar (
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_marca         IN VARCHAR2,
        p_modelo        IN VARCHAR2,
        p_serial        IN VARCHAR2,
        p_f_adquisicion IN DATE,
        p_f_prox_mant   IN DATE
    ) IS
    BEGIN
        INSERT INTO aero_equipos_apoyo (
            id_aeropuerto, nombre, tipo, marca, modelo, 
            numero_serie, estado, fecha_adquisicion, proximo_mantenimiento, activo
        ) VALUES (
            p_id_aeropuerto, p_nombre, p_tipo, p_marca, p_modelo, 
            p_serial, 'OPERATIVO', p_f_adquisicion, p_f_prox_mant, 'S'
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al insertar equipo: ' || SQLERRM);
    END pr_insertar;

    PROCEDURE pr_actualizar (
        p_id_equipo     IN NUMBER,
        p_id_aeropuerto IN NUMBER,
        p_nombre        IN VARCHAR2,
        p_tipo          IN VARCHAR2,
        p_marca         IN VARCHAR2,
        p_modelo        IN VARCHAR2,
        p_serial        IN VARCHAR2,
        p_estado        IN VARCHAR2,
        p_f_prox_mant   IN DATE,
        p_activo        IN CHAR
    ) IS
    BEGIN
        UPDATE aero_equipos_apoyo
        SET id_aeropuerto = p_id_aeropuerto,
            nombre = p_nombre,
            tipo = p_tipo,
            marca = p_marca,
            modelo = p_modelo,
            numero_serie = p_serial,
            estado = p_estado,
            proximo_mantenimiento = p_f_prox_mant,
            activo = p_activo,
            actualizado_en = SYSTIMESTAMP
        WHERE id_equipo = p_id_equipo;
        COMMIT;
    END pr_actualizar;

    PROCEDURE pr_listar (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                e.id_equipo,
                a.nombre AS Aeropuerto_Base,
                e.nombre AS Equipo,
                e.tipo AS Tipo_Equipo,
                e.marca,
                e.modelo,
                e.numero_serie AS SN,
                e.estado,
                e.proximo_mantenimiento AS Fecha_Prox_Mant,
                -- Alerta Preventiva según Mando del Coordinador
                CASE 
                    WHEN e.proximo_mantenimiento <= TRUNC(SYSDATE) + 7 THEN 'S'
                    ELSE 'N'
                END AS requiere_mant
            FROM aero_equipos_apoyo e
            JOIN aero_aeropuertos a ON e.id_aeropuerto = a.id_aeropuerto
            WHERE e.activo = 'S'
            ORDER BY requiere_mant DESC, e.proximo_mantenimiento ASC;
    END pr_listar;

END PKG_AERO_EQUIPOS_APOYO;
/

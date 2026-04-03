CREATE OR REPLACE PACKAGE PKG_AERO_HISTORICO_INFRA AS
    /**
     * Package: PKG_AERO_HISTORICO_INFRA
     * Descripción: Registro polimórfico de cambios en el Módulo de Infraestructura.
     */

    PROCEDURE pr_registrar_cambio (
        p_id_aeropuerto IN NUMBER,
        p_entidad       IN VARCHAR2, -- Ejemplo: 'aero_pistas', 'aero_terminales'
        p_id_entidad    IN NUMBER,
        p_campo         IN VARCHAR2,
        p_valor_ant     IN CLOB,
        p_valor_nue     IN CLOB,
        p_responsable   IN VARCHAR2
    );

    PROCEDURE pr_listar_por_entidad (
        p_entidad    IN VARCHAR2,
        p_id_entidad IN NUMBER,
        p_cursor     OUT SYS_REFCURSOR
    );

END PKG_AERO_HISTORICO_INFRA;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_HISTORICO_INFRA AS

    PROCEDURE pr_registrar_cambio (
        p_id_aeropuerto IN NUMBER,
        p_entidad       IN VARCHAR2,
        p_id_entidad    IN NUMBER,
        p_campo         IN VARCHAR2,
        p_valor_ant     IN CLOB,
        p_valor_nue     IN CLOB,
        p_responsable   IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO aero_historico_infra (
            id_aeropuerto, entidad, id_entidad, campo_modificado, 
            valor_anterior, valor_nuevo, modificado_por, modificado_en
        ) VALUES (
            p_id_aeropuerto, p_entidad, p_id_entidad, p_campo, 
            p_valor_ant, p_valor_nue, p_responsable, SYSTIMESTAMP
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- En auditoría no bloqueamos la transacción principal si falla el log
    END pr_registrar_cambio;

    PROCEDURE pr_listar_por_entidad (
        p_entidad    IN VARCHAR2,
        p_id_entidad IN NUMBER,
        p_cursor     OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                h.id_historico      AS ID,
                h.campo_modificado  AS Campo,
                h.valor_anterior    AS Anterior,
                h.valor_nuevo       AS Nuevo,
                h.modificado_por    AS Usuario,
                h.modificado_en     AS Fecha
            FROM aero_historico_infra h
            WHERE entidad = p_entidad 
              AND id_entidad = p_id_entidad
            ORDER BY h.modificado_en DESC;
    END pr_listar_por_entidad;

END PKG_AERO_HISTORICO_INFRA;
/

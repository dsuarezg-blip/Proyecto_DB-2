CREATE OR REPLACE PACKAGE PKG_AERO_DETALLE_TECNICO AS
    /**
     * Package: PKG_AERO_DETALLE_TECNICO
     * Descripción: Gestión técnica de infraestructura crítica (Radar, ILS, OACI).
     * Relación: 1:1 con aero_aeropuertos.
     */

    PROCEDURE pr_upsert (
        p_id_aeropuerto     IN NUMBER,
        p_cat_oaci          IN VARCHAR2,
        p_cat_faa           IN VARCHAR2,
        p_certreg_aip       IN CHAR,
        p_cappax_anual      IN NUMBER,
        p_capops_anual      IN NUMBER,
        p_area_m2           IN NUMBER,
        p_anno_inauguracion IN NUMBER,
        p_ultima_remodel    IN NUMBER,
        p_tiene_radar       IN CHAR,
        p_tiene_ils         IN CHAR,
        p_tiene_vor         IN CHAR,
        p_tiene_dme         IN CHAR,
        p_notas             IN CLOB
    );

    PROCEDURE pr_obtener_por_aeropuerto (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

    PROCEDURE pr_listar_completo (
        p_cursor OUT SYS_REFCURSOR
    );

END PKG_AERO_DETALLE_TECNICO;
/

CREATE OR REPLACE PACKAGE BODY PKG_AERO_DETALLE_TECNICO AS

    PROCEDURE pr_upsert (
        p_id_aeropuerto     IN NUMBER,
        p_cat_oaci          IN VARCHAR2,
        p_cat_faa           IN VARCHAR2,
        p_certreg_aip       IN CHAR,
        p_cappax_anual      IN NUMBER,
        p_capops_anual      IN NUMBER,
        p_area_m2           IN NUMBER,
        p_anno_inauguracion IN NUMBER,
        p_ultima_remodel    IN NUMBER,
        p_tiene_radar       IN CHAR,
        p_tiene_ils         IN CHAR,
        p_tiene_vor         IN CHAR,
        p_tiene_dme         IN CHAR,
        p_notas             IN CLOB
    ) IS
    BEGIN
        -- Implementación UPSERT para mantener 1:1
        MERGE INTO aero_detalle_tecnico d
        USING (SELECT p_id_aeropuerto as id FROM dual) s
        ON (d.id_aeropuerto = s.id)
        WHEN MATCHED THEN
            UPDATE SET 
                categoria_oaci = p_cat_oaci,
                categoria_faa = p_cat_faa,
                certificado_aip = p_certreg_aip,
                capacidad_anual_pax = p_cappax_anual,
                capacidad_anual_ops = p_capops_anual,
                superficie_total_m2 = p_area_m2,
                anno_inauguracion = p_anno_inauguracion,
                ultima_remodelacion = p_ultima_remodel,
                tiene_radar = p_tiene_radar,
                tiene_ils = p_tiene_ils,
                tiene_vor = p_tiene_vor,
                tiene_dme = p_tiene_dme,
                notas = p_notas,
                actualizado_en = SYSTIMESTAMP
        WHEN NOT MATCHED THEN
            INSERT (
                id_aeropuerto, categoria_oaci, categoria_faa, certificado_aip,
                capacidad_anual_pax, capacidad_anual_ops, superficie_total_m2,
                anno_inauguracion, ultima_remodelacion, tiene_radar,
                tiene_ils, tiene_vor, tiene_dme, notas
            ) VALUES (
                p_id_aeropuerto, p_cat_oaci, p_cat_faa, p_certreg_aip,
                p_cappax_anual, p_capops_anual, p_area_m2,
                p_anno_inauguracion, p_ultima_remodel, p_tiene_radar,
                p_tiene_ils, p_tiene_vor, p_tiene_dme, p_notas
            );
        COMMIT;
    END pr_upsert;

    PROCEDURE pr_obtener_por_aeropuerto (
        p_id_aeropuerto IN NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT * FROM aero_detalle_tecnico 
            WHERE id_aeropuerto = p_id_aeropuerto;
    END pr_obtener_por_aeropuerto;

    PROCEDURE pr_listar_completo (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                a.nombre AS Aeropuerto,
                d.categoria_oaci AS Cat_OACI,
                d.categoria_faa AS Cat_FAA,
                d.capacidad_anual_pax AS Capacidad_Pasajeros,
                d.capacidad_anual_ops AS Capacidad_Operaciones,
                d.tiene_radar AS Radar,
                d.tiene_ils AS ILS,
                d.tiene_vor AS VOR,
                d.actualizado_en AS Ultima_Actualizacion
            FROM aero_aeropuertos a
            LEFT JOIN aero_detalle_tecnico d ON a.id_aeropuerto = d.id_aeropuerto
            ORDER BY a.nombre ASC;
    END pr_listar_completo;

END PKG_AERO_DETALLE_TECNICO;
/

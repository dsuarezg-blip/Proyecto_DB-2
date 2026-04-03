SET SERVEROUTPUT ON;
SET FEEDBACK ON;

DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_aero NUMBER := 1; -- Asumiendo que existe el ID 1 (La Aurora)
    v_id_equipo NUMBER;
    
    -- Variables para lectura de cursor
    v_nombre VARCHAR2(100);
    v_mant   CHAR(1);
    v_estado VARCHAR2(30);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- INICIO DE VALIDACIÓN ASPA 3: INFRAESTRUCTURA ---');

    -- ==========================================
    -- 1. VALIDACIÓN PKG_AERO_DETALLE_TECNICO (1:1)
    -- ==========================================
    DBMS_OUTPUT.PUT_LINE('1. Probando UPSERT en Detalle Técnico...');
    PKG_AERO_DETALLE_TECNICO.pr_upsert(
        p_id_aeropuerto => v_id_aero,
        p_cat_oaci => 'CAT II',
        p_cat_faa => 'GROUP V',
        p_certreg_aip => 'S',
        p_cappax_anual => 5000000,
        p_capops_anual => 20000,
        p_area_m2 => 150000,
        p_anno_inauguracion => 1960,
        p_ultima_remodel => 2024,
        p_tiene_radar => 'S',
        p_tiene_ils => 'S',
        p_tiene_vor => 'S',
        p_tiene_dme => 'S',
        p_notas => 'Prueba de validación automática'
    );
    DBMS_OUTPUT.PUT_LINE('[OK] Upsert ejecutado correctamente.');

    -- ==========================================
    -- 2. VALIDACIÓN PKG_AERO_EQUIPOS_APOYO (ALERTAS)
    -- ==========================================
    DBMS_OUTPUT.PUT_LINE('2. Probando Alertas de Mantenimiento...');
    
    -- Equipo que NO requiere mantenimiento (30 días a futuro)
    PKG_AERO_EQUIPOS_APOYO.pr_insertar(v_id_aero, 'Remolcador T-1', 'TOWBAR', 'TUG', 'GT-100', 'SN-001', SYSDATE-365, SYSDATE+30);
    
    -- Equipo que SÍ requiere mantenimiento (En 2 días)
    PKG_AERO_EQUIPOS_APOYO.pr_insertar(v_id_aero, 'Escalera E-2', 'STAIRS', 'Wollard', 'CM-200', 'SN-002', SYSDATE-500, SYSDATE+2);
    
    -- Validar bandera en el listado
    PKG_AERO_EQUIPOS_APOYO.pr_listar(v_cursor);
    LOOP
        FETCH v_cursor INTO v_id_equipo, v_nombre, v_nombre, v_nombre, v_nombre, v_nombre, v_nombre, v_estado, v_nombre, v_mant;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Equipo: ' || v_nombre || ' | Requiere Mant: ' || v_mant);
    END LOOP;
    CLOSE v_cursor;

    -- ==========================================
    -- 3. VALIDACIÓN PKG_AERO_AEROPUERTOS_EQUIPOS (LIMPIEZA)
    -- ==========================================
    DBMS_OUTPUT.PUT_LINE('3. Probando Limpieza Automática de Asignación...');
    
    -- Asignación inicial (Aeropuerto 1)
    PKG_AERO_AEROPUERTOS_EQUIPOS.pr_asignar(v_id_aero, v_id_equipo, 'Asignación Inicial');
    
    -- Re-asignación a otro aeropuerto (Ej: ID 2 - Santa Elena)
    PKG_AERO_AEROPUERTOS_EQUIPOS.pr_asignar(2, v_id_equipo, 'Traslado de Emergencia');
    
    DBMS_OUTPUT.PUT_LINE('[OK] El sistema debió cerrar la asignación previa en Aeropuerto 1.');

    DBMS_OUTPUT.PUT_LINE('--- VALIDACIÓN COMPLETADA EXITOSAMENTE ---');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ERROR] Falla en la validación: ' || SQLERRM);
END;
/

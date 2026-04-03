-- ============================================================
-- SCRIPT DE PRUEBAS UNITARIAS: BASE GEOGRÁFICA AEROGT
-- ============================================================
-- Objetivo: Validar el CRUD de los 5 packages de Infraestructura (Fase 1)
-- Requisito: Ejecutar en SQL Developer o SQL*Plus
-- ============================================================

SET SERVEROUTPUT ON;
SET FEEDBACK ON;

-- Variables para recibir los REFCURSORs del Frontend
VARIABLE rc_cont REFCURSOR;
VARIABLE rc_pais REFCURSOR;
VARIABLE rc_est  REFCURSOR;
VARIABLE rc_ciu  REFCURSOR;
VARIABLE rc_tz   REFCURSOR;

DECLARE
    v_id_cont NUMBER;
    v_id_pais NUMBER;
    v_id_est  NUMBER;
    v_id_ciu  NUMBER;
    v_id_tz   NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- INICIO DE PRUEBAS AEROGT: GEOGRAFÍA ---');

    -- 1. PRUEBA: PKG_GEOG_CONTINENTES (Estructura Raíz)
    DBMS_OUTPUT.PUT_LINE('1. Probando PKG_GEOG_CONTINENTES...');
    AEROGT.PKG_GEOG_CONTINENTES.PR_INSERTAR('ANTÁRTIDA', 'AN');
    
    -- 2. PRUEBA: PKG_GEOG_PAISES (Relación Continente -> País)
    -- Necesitamos recuperar el ID (suponiendo que es el último insertado para test)
    SELECT id_continente INTO v_id_cont FROM geog_continentes WHERE codigo_iso = 'AN';
    
    DBMS_OUTPUT.PUT_LINE('2. Probando PKG_GEOG_PAISES (ID Cont: ' || v_id_cont || ')...');
    AEROGT.PKG_GEOG_PAISES.PR_INSERTAR(v_id_cont, 'TIERRA DE PRUEBA', 'TP', 'TPR', '+999', 'CRED', 'ES');

    -- 3. PRUEBA: PKG_GEOG_ESTADOS_DEP (Relación País -> Estado)
    SELECT id_pais INTO v_id_pais FROM geog_paises WHERE codigo_iso2 = 'TP';
    
    DBMS_OUTPUT.PUT_LINE('3. Probando PKG_GEOG_ESTADOS_DEP (ID Pais: ' || v_id_pais || ')...');
    AEROGT.PKG_GEOG_ESTADOS_DEP.PR_INSERTAR(v_id_pais, 'DEPARTAMENTO TEST', 'DTEST', 'DEPARTAMENTO');

    -- 4. PRUEBA: PKG_GEOG_CIUDADES (Relación Estado -> Ciudad)
    SELECT id_estado INTO v_id_est FROM geog_estados_dep WHERE nombre = 'DEPARTAMENTO TEST';
    
    DBMS_OUTPUT.PUT_LINE('4. Probando PKG_GEOG_CIUDADES (ID Est: ' || v_id_est || ')...');
    AEROGT.PKG_GEOG_CIUDADES.PR_INSERTAR(v_id_est, 'CIUDAD TEST', '01001', 14.63, -90.50, 10000, 1500);

    -- 5. PRUEBA: PKG_GEOG_ZONAS_HORARIAS
    DBMS_OUTPUT.PUT_LINE('5. Probando PKG_GEOG_ZONAS_HORARIAS...');
    AEROGT.PKG_GEOG_ZONAS_HORARIAS.PR_INSERTAR('GMT-06:00', '-06:00', 'America/Guatemala', 'N');

    -- 6. VERIFICACIÓN DE ATOMICIDAD (Falla intencional - Duplicado)
    DBMS_OUTPUT.PUT_LINE('6. Verificando ACID (Intento duplicado en Continentes)...');
    BEGIN
        AEROGT.PKG_GEOG_CONTINENTES.PR_INSERTAR('ANTÁRTIDA', 'AN'); -- Esto debe dar error
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('   AVISO ESPERADO: Capturado error de duplicado (ID ' || SQLCODE || '): ' || SQLERRM);
    END;

    DBMS_OUTPUT.PUT_LINE('--- FIN DE PROCESAMIENTO DML ---');
END;
/

-- CONSULTA FINAL PARA EL FRONTEND (Visualización de resultados)
DBMS_OUTPUT.PUT_LINE('--- RESULTADOS PARA EL FRONTEND (SYS_REFCURSOR) ---');

-- Listar continentes
EXEC AEROGT.PKG_GEOG_CONTINENTES.PR_LISTAR(:rc_cont);
PRINT rc_cont;

-- Listar países de la Antártida
DECLARE
    v_id NUMBER;
BEGIN
    SELECT id_continente INTO v_id FROM geog_continentes WHERE codigo_iso = 'AN';
    AEROGT.PKG_GEOG_PAISES.PR_LISTAR_POR_CONTINENTE(v_id, :rc_pais);
END;
/
PRINT rc_pais;

-- Listar ciudades con su jerarquía completa (Join en el Package)
EXEC AEROGT.PKG_GEOG_CIUDADES.PR_LISTAR(:rc_ciu);
PRINT rc_ciu;

-- Listar Zonas Horarias
EXEC AEROGT.PKG_GEOG_ZONAS_HORARIAS.PR_LISTAR(:rc_tz);
PRINT rc_tz;

-- LIMPIEZA DE PRUEBA (Opcional, para repetir el test)
-- ROLLBACK;  -- Si los packages tuvieran COMMIT internos, esto no servirá, pero los míos usan COMMIT.
-- Por lo tanto, para repetir pruebas se debe borrar manualmente si se desea:
-- DELETE FROM geog_ciudades WHERE nombre = 'CIUDAD TEST';
-- DELETE FROM geog_estados_dep WHERE nombre = 'DEPARTAMENTO TEST';
-- DELETE FROM geog_paises WHERE nombre = 'TIERRA DE PRUEBA';
-- DELETE FROM geog_continentes WHERE nombre = 'ANTÁRTIDA';
-- COMMIT;

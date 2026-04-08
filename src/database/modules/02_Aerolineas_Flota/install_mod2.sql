-- ============================================================
--  SCRIPT DE INSTALACION Y PRUEBA — MODULO 2
--  Aerolineas & Flota — Oracle 21c
--  Ejecutar como usuario AEROGT en PDB AERO_LA_AURORA
-- ============================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK ON
SET ECHO OFF

PROMPT ============================================================
PROMPT  PASO 1: Compilando especificacion del paquete (HEADER)
PROMPT ============================================================

@@pkg_mod2_spec.sql

PROMPT ============================================================
PROMPT  PASO 2: Compilando cuerpo del paquete (BODY)
PROMPT ============================================================

@@pkg_mod2_body.sql

PROMPT ============================================================
PROMPT  PASO 3: Verificando compilacion
PROMPT ============================================================

SELECT object_name, object_type, status
FROM   user_objects
WHERE  object_name = 'PKG_AEROLINEAS_FLOTA'
ORDER BY object_type;

PROMPT ============================================================
PROMPT  PASO 4: Pruebas del backend
PROMPT ============================================================

-- PRUEBA 1: Insertar aerolinea
DECLARE
  v_res NUMBER;
  v_msg VARCHAR2(500);
BEGIN
  PKG_AEROLINEAS_FLOTA.SP_INSERTAR_AEROLINEA(
    p_codigo_iata => 'GX',
    p_codigo_icao => 'GXG',
    p_nombre      => 'Aerolinea Guatemala S.A.',
    p_pais_origen => 1,
    p_sitio_web   => 'www.aeroguate.com.gt',
    p_resultado   => v_res,
    p_mensaje     => v_msg
  );
  DBMS_OUTPUT.PUT_LINE('[TEST 1 - Insertar Aerolinea]');
  DBMS_OUTPUT.PUT_LINE('  Resultado: ' || v_res || ' | Mensaje: ' || v_msg);
END;
/

-- PRUEBA 2: Insertar modelo de avion
DECLARE
  v_res NUMBER;
  v_msg VARCHAR2(500);
  v_id_al NUMBER;
BEGIN
  SELECT id_aerolinea INTO v_id_al
  FROM   linea_aerolineas WHERE codigo_iata = 'GX' AND ROWNUM = 1;

  PKG_AEROLINEAS_FLOTA.SP_INSERTAR_MODELO(
    p_id_aerolinea    => v_id_al,
    p_fabricante      => 'Boeing',
    p_modelo          => '737-800',
    p_cap_pax_max     => 162,
    p_alcance_km      => 5765,
    p_autonomia_horas => 7.5,
    p_resultado       => v_res,
    p_mensaje         => v_msg
  );
  DBMS_OUTPUT.PUT_LINE('[TEST 2 - Insertar Modelo]');
  DBMS_OUTPUT.PUT_LINE('  Resultado: ' || v_res || ' | Mensaje: ' || v_msg);
END;
/

-- PRUEBA 3: Registrar avion en la flota
DECLARE
  v_res      NUMBER;
  v_msg      VARCHAR2(500);
  v_id_avion NUMBER;
  v_id_model NUMBER;
  v_id_al    NUMBER;
BEGIN
  SELECT id_aerolinea INTO v_id_al
  FROM   linea_aerolineas WHERE codigo_iata = 'GX' AND ROWNUM = 1;

  SELECT id_modelo INTO v_id_model
  FROM   flota_modelos WHERE id_aerolinea = v_id_al AND modelo = '737-800' AND ROWNUM = 1;

  PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_AVION(
    p_id_modelo    => v_id_model,
    p_id_aerolinea => v_id_al,
    p_id_config    => NULL,
    p_matricula    => 'TG-GXA',
    p_numero_serie => 'MSN-40567',
    p_anno_fab     => 2018,
    p_id_avion     => v_id_avion,
    p_resultado    => v_res,
    p_mensaje      => v_msg
  );
  DBMS_OUTPUT.PUT_LINE('[TEST 3 - Registrar Avion]');
  DBMS_OUTPUT.PUT_LINE('  ID Avion: ' || v_id_avion);
  DBMS_OUTPUT.PUT_LINE('  Resultado: ' || v_res || ' | Mensaje: ' || v_msg);
END;
/

-- PRUEBA 4: Registrar mantenimiento
DECLARE
  v_res    NUMBER;
  v_msg    VARCHAR2(500);
  v_id_av  NUMBER;
BEGIN
  SELECT id_avion INTO v_id_av
  FROM   flota_aviones WHERE matricula = 'TG-GXA' AND ROWNUM = 1;

  PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_MANTENIMIENTO(
    p_id_avion     => v_id_av,
    p_tipo         => 'CHECK-A',
    p_descripcion  => TO_CLOB('Revision de rutina tipo A - inspeccion general'),
    p_fecha_inicio => SYSTIMESTAMP,
    p_fecha_fin    => SYSTIMESTAMP + INTERVAL '2' DAY,
    p_proveedor    => 'MRO Guatemala S.A.',
    p_costo_usd    => 15000,
    p_resultado    => v_res,
    p_mensaje      => v_msg
  );
  DBMS_OUTPUT.PUT_LINE('[TEST 4 - Registrar Mantenimiento]');
  DBMS_OUTPUT.PUT_LINE('  Resultado: ' || v_res || ' | Mensaje: ' || v_msg);
END;
/

-- PRUEBA 5: Registrar certificado
DECLARE
  v_res   NUMBER;
  v_msg   VARCHAR2(500);
  v_id_av NUMBER;
BEGIN
  SELECT id_avion INTO v_id_av
  FROM   flota_aviones WHERE matricula = 'TG-GXA' AND ROWNUM = 1;

  PKG_AEROLINEAS_FLOTA.SP_REGISTRAR_CERTIFICADO(
    p_id_avion      => v_id_av,
    p_tipo          => 'AERONAVEGABILIDAD',
    p_numero        => 'DGAC-2026-00123',
    p_autoridad     => 'DGAC Guatemala',
    p_fecha_emision => SYSDATE,
    p_fecha_vence   => SYSDATE + 365,
    p_resultado     => v_res,
    p_mensaje       => v_msg
  );
  DBMS_OUTPUT.PUT_LINE('[TEST 5 - Registrar Certificado]');
  DBMS_OUTPUT.PUT_LINE('  Resultado: ' || v_res || ' | Mensaje: ' || v_msg);
END;
/

-- PRUEBA 6: Verificar funcion FN_AVION_DISPONIBLE
DECLARE
  v_id_av    NUMBER;
  v_disp     CHAR(1);
  v_matricula VARCHAR2(20) := 'TG-GXA';
BEGIN
  SELECT id_avion INTO v_id_av
  FROM   flota_aviones WHERE matricula = v_matricula AND ROWNUM = 1;

  v_disp := PKG_AEROLINEAS_FLOTA.FN_AVION_DISPONIBLE(v_id_av);

  DBMS_OUTPUT.PUT_LINE('[TEST 6 - FN_AVION_DISPONIBLE]');
  DBMS_OUTPUT.PUT_LINE('  Avion ' || v_matricula || ' disponible: ' ||
    CASE v_disp WHEN 'S' THEN 'SI' ELSE 'NO' END);
END;
/

-- PRUEBA 7: Reporte de flota general
DECLARE
  v_cursor SYS_REFCURSOR;
  v_iata   VARCHAR2(5);
  v_nombre VARCHAR2(150);
  v_total  NUMBER;
  v_oper   NUMBER;
BEGIN
  PKG_AEROLINEAS_FLOTA.SP_REPORTE_FLOTA_GENERAL(p_cursor => v_cursor);
  DBMS_OUTPUT.PUT_LINE('[TEST 7 - Reporte Flota General]');
  DBMS_OUTPUT.PUT_LINE('  IATA | Aerolinea | Total | Operativos');
  LOOP
    FETCH v_cursor INTO v_iata, v_nombre, v_total, v_oper;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('  ' || v_iata || ' | ' || v_nombre ||
                         ' | ' || v_total || ' | ' || v_oper);
  END LOOP;
  CLOSE v_cursor;
END;
/

PROMPT ============================================================
PROMPT  RESUMEN DE OBJETOS COMPILADOS
PROMPT ============================================================

SELECT object_name, object_type,
       TO_CHAR(last_ddl_time, 'DD/MM/YYYY HH24:MI') AS ultima_compilacion,
       status
FROM   user_objects
WHERE  object_name LIKE 'PKG_%'
ORDER BY object_type, object_name;

PROMPT ============================================================
PROMPT  FIN DE INSTALACION — MODULO 2 BACKEND LISTO
PROMPT ============================================================

EXIT;

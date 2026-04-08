-- ============================================================
--  PKG_AEROLINEAS_FLOTA — ESPECIFICACION (HEADER)
--  Modulo 2: Aerolineas & Flota
--  Sistema Aeropuerto Internacional La Aurora
--  Oracle 21c — PDB: AERO_LA_AURORA
--  Usuario: AEROGT
-- ============================================================
--  Ejecutar como: AEROGT en AERO_LA_AURORA
--  @pkg_mod2_spec.sql
-- ============================================================

CREATE OR REPLACE PACKAGE PKG_AEROLINEAS_FLOTA AS

  -- ===========================================================
  -- SECCION 1: GESTION DE AEROLINEAS
  -- ===========================================================

  -- Insertar una nueva aerolinea
  PROCEDURE SP_INSERTAR_AEROLINEA(
    p_codigo_iata   IN  VARCHAR2,
    p_codigo_icao   IN  VARCHAR2,
    p_nombre        IN  VARCHAR2,
    p_pais_origen   IN  NUMBER,
    p_sitio_web     IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener todas las aerolineas
  PROCEDURE SP_OBTENER_AEROLINEAS(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Obtener una aerolinea por ID
  PROCEDURE SP_OBTENER_AEROLINEA_POR_ID(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  );

  -- Actualizar datos de una aerolinea
  PROCEDURE SP_ACTUALIZAR_AEROLINEA(
    p_id_aerolinea  IN  NUMBER,
    p_nombre        IN  VARCHAR2,
    p_sitio_web     IN  VARCHAR2,
    p_activa        IN  CHAR,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Activar o desactivar una aerolinea
  PROCEDURE SP_CAMBIAR_ESTADO_AEROLINEA(
    p_id_aerolinea  IN  NUMBER,
    p_activa        IN  CHAR,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener aerolineas activas solamente
  PROCEDURE SP_OBTENER_AEROLINEAS_ACTIVAS(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Buscar aerolinea por codigo IATA
  FUNCTION FN_BUSCAR_POR_IATA(
    p_codigo_iata IN VARCHAR2
  ) RETURN SYS_REFCURSOR;

  -- Contar total de aerolineas activas
  FUNCTION FN_CONTAR_AEROLINEAS_ACTIVAS
  RETURN NUMBER;

  -- ===========================================================
  -- SECCION 2: GESTION DE ALIANZAS
  -- ===========================================================

  -- Insertar alianza aerea
  PROCEDURE SP_INSERTAR_ALIANZA(
    p_nombre        IN  VARCHAR2,
    p_anno_fund     IN  NUMBER,
    p_sede          IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener todas las alianzas
  PROCEDURE SP_OBTENER_ALIANZAS(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Asignar aerolinea a alianza
  PROCEDURE SP_ASIGNAR_AEROLINEA_ALIANZA(
    p_id_aerolinea  IN  NUMBER,
    p_id_alianza    IN  NUMBER,
    p_fecha_ingreso IN  DATE,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener alianzas de una aerolinea
  PROCEDURE SP_OBTENER_ALIANZAS_AEROLINEA(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  );

  -- ===========================================================
  -- SECCION 3: GESTION DE MODELOS DE AVION
  -- ===========================================================

  -- Insertar modelo de avion
  PROCEDURE SP_INSERTAR_MODELO(
    p_id_aerolinea    IN  NUMBER,
    p_fabricante      IN  VARCHAR2,
    p_modelo          IN  VARCHAR2,
    p_cap_pax_max     IN  NUMBER,
    p_alcance_km      IN  NUMBER,
    p_autonomia_horas IN  NUMBER,
    p_resultado       OUT NUMBER,
    p_mensaje         OUT VARCHAR2
  );

  -- Obtener modelos de una aerolinea
  PROCEDURE SP_OBTENER_MODELOS_AEROLINEA(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  );

  -- Obtener todos los modelos
  PROCEDURE SP_OBTENER_TODOS_MODELOS(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Actualizar modelo
  PROCEDURE SP_ACTUALIZAR_MODELO(
    p_id_modelo       IN  NUMBER,
    p_fabricante      IN  VARCHAR2,
    p_modelo          IN  VARCHAR2,
    p_cap_pax_max     IN  NUMBER,
    p_alcance_km      IN  NUMBER,
    p_resultado       OUT NUMBER,
    p_mensaje         OUT VARCHAR2
  );

  -- ===========================================================
  -- SECCION 4: GESTION DE AVIONES (FLOTA)
  -- ===========================================================

  -- Registrar nuevo avion en la flota
  PROCEDURE SP_REGISTRAR_AVION(
    p_id_modelo     IN  NUMBER,
    p_id_aerolinea  IN  NUMBER,
    p_id_config     IN  NUMBER,
    p_matricula     IN  VARCHAR2,
    p_numero_serie  IN  VARCHAR2,
    p_anno_fab      IN  NUMBER,
    p_id_avion      OUT NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener todos los aviones
  PROCEDURE SP_OBTENER_FLOTA(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Obtener aviones de una aerolinea
  PROCEDURE SP_OBTENER_FLOTA_AEROLINEA(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  );

  -- Obtener avion por ID (detalle completo)
  PROCEDURE SP_OBTENER_AVION_POR_ID(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- Cambiar estado de un avion
  PROCEDURE SP_CAMBIAR_ESTADO_AVION(
    p_id_avion      IN  NUMBER,
    p_nuevo_estado  IN  VARCHAR2,
    p_motivo        IN  VARCHAR2,
    p_id_empleado   IN  NUMBER DEFAULT NULL,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Actualizar horas de vuelo acumuladas
  PROCEDURE SP_ACTUALIZAR_HORAS_VUELO(
    p_id_avion      IN  NUMBER,
    p_horas_nuevas  IN  NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener aviones operativos
  PROCEDURE SP_OBTENER_AVIONES_OPERATIVOS(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Verificar si un avion esta disponible para vuelo
  FUNCTION FN_AVION_DISPONIBLE(
    p_id_avion IN NUMBER
  ) RETURN CHAR;

  -- Obtener matricula de un avion
  FUNCTION FN_OBTENER_MATRICULA(
    p_id_avion IN NUMBER
  ) RETURN VARCHAR2;

  -- Contar aviones de una aerolinea
  FUNCTION FN_CONTAR_AVIONES_AEROLINEA(
    p_id_aerolinea IN NUMBER
  ) RETURN NUMBER;

  -- ===========================================================
  -- SECCION 5: MANTENIMIENTO
  -- ===========================================================

  -- Registrar mantenimiento realizado
  PROCEDURE SP_REGISTRAR_MANTENIMIENTO(
    p_id_avion      IN  NUMBER,
    p_tipo          IN  VARCHAR2,
    p_descripcion   IN  CLOB,
    p_fecha_inicio  IN  TIMESTAMP WITH TIME ZONE,
    p_fecha_fin     IN  TIMESTAMP WITH TIME ZONE,
    p_proveedor     IN  VARCHAR2,
    p_costo_usd     IN  NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener historial de mantenimiento de un avion
  PROCEDURE SP_OBTENER_HISTORIAL_MANTEN(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- Obtener aviones en mantenimiento actualmente
  PROCEDURE SP_AVIONES_EN_MANTENIMIENTO(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Registrar averia
  PROCEDURE SP_REGISTRAR_AVERIA(
    p_id_avion      IN  NUMBER,
    p_descripcion   IN  CLOB,
    p_severidad     IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Resolver averia
  PROCEDURE SP_RESOLVER_AVERIA(
    p_id_averia     IN  NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener averias pendientes de un avion
  PROCEDURE SP_OBTENER_AVERIAS_PENDIENTES(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- ===========================================================
  -- SECCION 6: CERTIFICADOS E INSPECCIONES
  -- ===========================================================

  -- Registrar certificado de aeronavegabilidad
  PROCEDURE SP_REGISTRAR_CERTIFICADO(
    p_id_avion        IN  NUMBER,
    p_tipo            IN  VARCHAR2,
    p_numero          IN  VARCHAR2,
    p_autoridad       IN  VARCHAR2,
    p_fecha_emision   IN  DATE,
    p_fecha_vence     IN  DATE,
    p_resultado       OUT NUMBER,
    p_mensaje         OUT VARCHAR2
  );

  -- Obtener certificados de un avion
  PROCEDURE SP_OBTENER_CERTIFICADOS(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- Obtener certificados por vencer (proximos 30 dias)
  PROCEDURE SP_CERTIFICADOS_POR_VENCER(
    p_dias_alerta IN  NUMBER DEFAULT 30,
    p_cursor      OUT SYS_REFCURSOR
  );

  -- Registrar inspeccion de seguridad
  PROCEDURE SP_REGISTRAR_INSPECCION(
    p_id_avion      IN  NUMBER,
    p_tipo          IN  VARCHAR2,
    p_fecha         IN  DATE,
    p_inspector     IN  VARCHAR2,
    p_resultado_ins IN  VARCHAR2,
    p_observaciones IN  CLOB,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener inspecciones de un avion
  PROCEDURE SP_OBTENER_INSPECCIONES(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- Verificar si un avion tiene certificados vigentes
  FUNCTION FN_TIENE_CERTIFICADOS_VIGENTES(
    p_id_avion IN NUMBER
  ) RETURN CHAR;

  -- ===========================================================
  -- SECCION 7: MOTORES Y COMPONENTES
  -- ===========================================================

  -- Registrar motor de un avion
  PROCEDURE SP_REGISTRAR_MOTOR(
    p_id_avion      IN  NUMBER,
    p_posicion      IN  VARCHAR2,
    p_fabricante    IN  VARCHAR2,
    p_modelo_motor  IN  VARCHAR2,
    p_numero_serie  IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener motores de un avion
  PROCEDURE SP_OBTENER_MOTORES(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- Registrar componente tecnico
  PROCEDURE SP_REGISTRAR_COMPONENTE(
    p_id_avion      IN  NUMBER,
    p_nombre        IN  VARCHAR2,
    p_part_number   IN  VARCHAR2,
    p_numero_serie  IN  VARCHAR2,
    p_proximo_camb  IN  DATE,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener componentes proximos a cambiar
  PROCEDURE SP_COMPONENTES_POR_CAMBIAR(
    p_dias_alerta IN  NUMBER DEFAULT 30,
    p_cursor      OUT SYS_REFCURSOR
  );

  -- ===========================================================
  -- SECCION 8: PROVEEDORES DE REPUESTOS
  -- ===========================================================

  -- Registrar proveedor
  PROCEDURE SP_REGISTRAR_PROVEEDOR(
    p_nombre        IN  VARCHAR2,
    p_pais          IN  NUMBER,
    p_contacto      IN  VARCHAR2,
    p_email         IN  VARCHAR2,
    p_telefono      IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener proveedores
  PROCEDURE SP_OBTENER_PROVEEDORES(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Asignar proveedor a avion
  PROCEDURE SP_ASIGNAR_PROVEEDOR_AVION(
    p_id_avion      IN  NUMBER,
    p_id_proveedor  IN  NUMBER,
    p_tipo_servicio IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- ===========================================================
  -- SECCION 9: TELEMETRIA Y PESO/BALANCE
  -- ===========================================================

  -- Registrar dato de telemetria
  PROCEDURE SP_REGISTRAR_TELEMETRIA(
    p_id_avion      IN  NUMBER,
    p_latitud       IN  NUMBER,
    p_longitud      IN  NUMBER,
    p_altitud_ft    IN  NUMBER,
    p_velocidad_kmh IN  NUMBER,
    p_temp_ext      IN  NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  );

  -- Obtener ultima posicion de un avion
  PROCEDURE SP_OBTENER_ULTIMA_POSICION(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- Registrar o actualizar peso y balance
  PROCEDURE SP_REGISTRAR_PESO_BALANCE(
    p_id_avion          IN  NUMBER,
    p_peso_vacio_kg     IN  NUMBER,
    p_peso_max_desp_kg  IN  NUMBER,
    p_peso_max_ate_kg   IN  NUMBER,
    p_comb_max_kg       IN  NUMBER,
    p_payload_max_kg    IN  NUMBER,
    p_resultado         OUT NUMBER,
    p_mensaje           OUT VARCHAR2
  );

  -- ===========================================================
  -- SECCION 10: REPORTES DEL MODULO 2
  -- ===========================================================

  -- Reporte general de flota por aerolinea
  PROCEDURE SP_REPORTE_FLOTA_GENERAL(
    p_cursor OUT SYS_REFCURSOR
  );

  -- Reporte de aviones por estado
  PROCEDURE SP_REPORTE_AVIONES_POR_ESTADO(
    p_estado IN  VARCHAR2 DEFAULT NULL,
    p_cursor OUT SYS_REFCURSOR
  );

  -- Reporte de mantenimientos por periodo
  PROCEDURE SP_REPORTE_MANTENIMIENTOS_PERIODO(
    p_fecha_ini IN  DATE,
    p_fecha_fin IN  DATE,
    p_cursor    OUT SYS_REFCURSOR
  );

  -- Estadisticas de flota por aerolinea
  PROCEDURE SP_ESTADISTICAS_FLOTA(
    p_id_aerolinea IN  NUMBER DEFAULT NULL,
    p_cursor       OUT SYS_REFCURSOR
  );

END PKG_AEROLINEAS_FLOTA;
/

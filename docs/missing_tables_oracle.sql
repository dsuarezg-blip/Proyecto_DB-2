-- ============================================================
--  TABLAS FALTANTES - Oracle 23ai
--  Sistema Aerolínea Guatemala
--  89 tablas pendientes de crear
-- ============================================================
SET ECHO OFF
SET FEEDBACK ON
SET DEFINE OFF

-- ============================================================
-- MÓDULO 1 — INFRAESTRUCTURA (tablas faltantes)
-- ============================================================
CREATE TABLE aero_pistas (
    id_pista        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_aeropuerto   NUMBER(10) NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    designacion     VARCHAR2(10) NOT NULL,
    longitud_m      NUMBER(8,2),
    ancho_m         NUMBER(6,2),
    tipo_superficie VARCHAR2(15) CHECK (tipo_superficie IN ('ASFALTO','CONCRETO','GRAVA','CESPED')),
    resistencia_pcn NUMBER(6,2),
    iluminada       CHAR(1) DEFAULT 'S' CHECK (iluminada IN ('S','N')),
    activa          CHAR(1) DEFAULT 'S' CHECK (activa IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_aeropuerto, designacion)
);

CREATE TABLE aero_material_pista (
    id_material     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pista        NUMBER(10) NOT NULL REFERENCES aero_pistas(id_pista),
    tipo_material   VARCHAR2(60) NOT NULL,
    espesor_cm      NUMBER(6,2),
    fecha_ultima_reparacion DATE,
    condicion       VARCHAR2(30),
    notas           CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_umbrales_pista (
    id_umbral       NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pista        NUMBER(10) NOT NULL REFERENCES aero_pistas(id_pista),
    designacion     VARCHAR2(10) NOT NULL,
    latitud         NUMBER(10,7),
    longitud        NUMBER(10,7),
    elevacion_ft    NUMBER(10),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_puertas_gates (
    id_gate         NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_seccion      NUMBER(10) NOT NULL REFERENCES aero_secciones_terminal(id_seccion),
    codigo          VARCHAR2(10) NOT NULL,
    tipo            VARCHAR2(30),
    estado          VARCHAR2(20) DEFAULT 'DISPONIBLE' CHECK (estado IN ('DISPONIBLE','OCUPADO','EN_MANTENIMIENTO','RESERVADO','CERRADO')),
    capacidad_pax   NUMBER(10),
    tiene_jetway    CHAR(1) DEFAULT 'N' CHECK (tiene_jetway IN ('S','N')),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_estado_gate (
    id_log_gate     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_gate         NUMBER(10) NOT NULL REFERENCES aero_puertas_gates(id_gate),
    estado_anterior VARCHAR2(20) CHECK (estado_anterior IN ('DISPONIBLE','OCUPADO','EN_MANTENIMIENTO','RESERVADO','CERRADO')),
    estado_nuevo    VARCHAR2(20) CHECK (estado_nuevo IN ('DISPONIBLE','OCUPADO','EN_MANTENIMIENTO','RESERVADO','CERRADO')),
    motivo          VARCHAR2(200),
    id_empleado_registro NUMBER(10),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_vip_lounge (
    id_vip          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_terminal     NUMBER(10) NOT NULL REFERENCES aero_terminales(id_terminal),
    nombre          VARCHAR2(80) NOT NULL,
    operador        VARCHAR2(80),
    capacidad       NUMBER(10),
    precio_acceso_usd NUMBER(8,2),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_frecuencias_radio (
    id_frecuencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_aeropuerto   NUMBER(10) NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    tipo            VARCHAR2(10) CHECK (tipo IN ('VHF','UHF','HF','SATCOM')),
    servicio        VARCHAR2(60),
    frecuencia_mhz  NUMBER(8,3),
    activa          CHAR(1) DEFAULT 'S' CHECK (activa IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_puntos_control (
    id_control      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_aeropuerto   NUMBER(10) NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(80) NOT NULL,
    nivel_acceso    VARCHAR2(20) CHECK (nivel_acceso IN ('PUBLICO','RESTRINGIDO','SEGURIDAD','OPERACIONES','ADMINISTRACION')),
    tipo_control    VARCHAR2(40),
    estado          VARCHAR2(30) DEFAULT 'ACTIVO',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_estacionamientos_pax (
    id_parking      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_aeropuerto   NUMBER(10) NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(60) NOT NULL,
    tipo            VARCHAR2(40),
    capacidad_vehiculos NUMBER(10),
    tarifa_hora_gtq NUMBER(8,2),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

-- ============================================================
-- MÓDULO 2 — FLOTA (tablas faltantes)
-- ============================================================
CREATE TABLE flota_aviones (
    id_avion        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_modelo       NUMBER(10) NOT NULL REFERENCES flota_modelos(id_modelo),
    id_aerolinea    NUMBER(10) NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    id_config       NUMBER(10) REFERENCES flota_config_cabina(id_config),
    matricula       VARCHAR2(20) NOT NULL UNIQUE,
    numero_serie    VARCHAR2(50) NOT NULL UNIQUE,
    anno_fabricacion NUMBER(10),
    estado          VARCHAR2(20) DEFAULT 'OPERATIVO' CHECK (estado IN ('OPERATIVO','EN_MANTENIMIENTO','EN_REPARACION','RETIRADO','ARRENDADO','EN_INSPECCION')),
    horas_vuelo_total NUMBER(10,1) DEFAULT 0,
    ciclos_total    NUMBER(10) DEFAULT 0,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_estado_avion (
    id_estado       NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    estado_anterior VARCHAR2(20) CHECK (estado_anterior IN ('OPERATIVO','EN_MANTENIMIENTO','EN_REPARACION','RETIRADO','ARRENDADO','EN_INSPECCION')),
    estado_nuevo    VARCHAR2(20) CHECK (estado_nuevo IN ('OPERATIVO','EN_MANTENIMIENTO','EN_REPARACION','RETIRADO','ARRENDADO','EN_INSPECCION')),
    motivo          VARCHAR2(200),
    id_empleado     NUMBER(10),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_hist_matriculas (
    id_hist_mat     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    matricula       VARCHAR2(20) NOT NULL,
    fecha_desde     DATE NOT NULL,
    fecha_hasta     DATE,
    motivo_cambio   VARCHAR2(100),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_motores (
    id_motor        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    posicion        VARCHAR2(10) NOT NULL,
    fabricante      VARCHAR2(60),
    modelo_motor    VARCHAR2(60),
    numero_serie    VARCHAR2(50) NOT NULL UNIQUE,
    horas_totales   NUMBER(10,1) DEFAULT 0,
    ciclos_totales  NUMBER(10) DEFAULT 0,
    estado          VARCHAR2(30) DEFAULT 'OPERATIVO',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_componentes (
    id_componente   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    nombre          VARCHAR2(100) NOT NULL,
    part_number     VARCHAR2(60),
    numero_serie    VARCHAR2(60),
    estado          VARCHAR2(30) DEFAULT 'OPERATIVO',
    fecha_instalacion DATE,
    proximo_cambio  DATE,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_peso_balance (
    id_peso         NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    peso_vacio_kg   NUMBER(10,2),
    peso_max_despegue_kg NUMBER(10,2),
    peso_max_aterrizaje_kg NUMBER(10,2),
    combustible_max_kg NUMBER(10,2),
    payload_max_kg  NUMBER(10,2),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_telemetria (
    id_telemetria   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    latitud         NUMBER(10,7),
    longitud        NUMBER(10,7),
    altitud_ft      NUMBER(10),
    velocidad_kmh   NUMBER(10),
    temperatura_ext_c NUMBER(5,1),
    presion_cabina_hpa NUMBER(7,2)
);

CREATE TABLE flota_hist_manten (
    id_manten       NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(60) NOT NULL,
    descripcion     CLOB,
    fecha_inicio    TIMESTAMP WITH TIME ZONE,
    fecha_fin       TIMESTAMP WITH TIME ZONE,
    proveedor       VARCHAR2(100),
    costo_usd       NUMBER(14,2),
    aprobado_por    NUMBER(10),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_certificados (
    id_cert         NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(80) NOT NULL,
    numero          VARCHAR2(60),
    autoridad_emisora VARCHAR2(80),
    fecha_emision   DATE,
    fecha_vencimiento DATE,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_log_averias (
    id_averia       NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    descripcion     CLOB NOT NULL,
    severidad       VARCHAR2(20) CHECK (severidad IN ('BAJA','MEDIA','ALTA','CRITICA')),
    estado          VARCHAR2(30) DEFAULT 'ABIERTA',
    reportado_en    TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    resuelto_en     TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_proveed_rep (
    id_proveedor    NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(150) NOT NULL,
    pais            NUMBER(10) REFERENCES geog_paises(id_pais),
    contacto_nombre VARCHAR2(100),
    contacto_email  VARCHAR2(100),
    telefono        VARCHAR2(30),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_proveed_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    id_proveedor    NUMBER(10) NOT NULL REFERENCES flota_proveed_rep(id_proveedor),
    tipo_servicio   VARCHAR2(80),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_avion, id_proveedor)
);

CREATE TABLE flota_ins_seguridad (
    id_inspeccion   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(60) NOT NULL,
    fecha           DATE NOT NULL,
    inspector       VARCHAR2(100),
    resultado       VARCHAR2(30) CHECK (resultado IN ('APROBADO','OBSERVACIONES','RECHAZADO')),
    observaciones   CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_capacidad_carg (
    id_capacidad    NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    vol_total_m3    NUMBER(8,2),
    peso_max_hold_kg NUMBER(10,2),
    num_compartimentos NUMBER(10),
    acepta_carga_peligrosa CHAR(1) DEFAULT 'N' CHECK (acepta_carga_peligrosa IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_eq_emergencia (
    id_emergencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(60) NOT NULL,
    cantidad        NUMBER(10) DEFAULT 1,
    ubicacion       VARCHAR2(80),
    fecha_vencimiento DATE,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_sistemas_entre (
    id_ife          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    proveedor       VARCHAR2(60),
    version         VARCHAR2(30),
    canales_video   NUMBER(10),
    canales_audio   NUMBER(10),
    tiene_wifi      CHAR(1) DEFAULT 'N' CHECK (tiene_wifi IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_wifi_service (
    id_wifi         NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    proveedor       VARCHAR2(60),
    tecnologia      VARCHAR2(30),
    velocidad_mbps  NUMBER(6,2),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_reserv_hangar (
    id_reserva      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    id_hangar       NUMBER(10) NOT NULL REFERENCES aero_hangares(id_hangar),
    fecha_entrada   TIMESTAMP WITH TIME ZONE,
    fecha_salida    TIMESTAMP WITH TIME ZONE,
    motivo          VARCHAR2(150),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_consumo_comb (
    id_consumo      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    id_instancia_vuelo NUMBER(10),
    fase_vuelo      VARCHAR2(30),
    combustible_kg  NUMBER(10,2),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

-- ============================================================
-- MÓDULO 3 — RRHH (tablas faltantes)
-- ============================================================
CREATE TABLE rrhh_contratos (
    id_contrato     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empleado     NUMBER(10) NOT NULL UNIQUE REFERENCES rrhh_empleados(id_empleado),
    tipo            VARCHAR2(30) CHECK (tipo IN ('TIEMPO_INDEFINIDO','TIEMPO_DEFINIDO','TEMPORAL','PRACTICANTE')),
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE,
    salario_base_gtq NUMBER(10,2) NOT NULL,
    jornada         VARCHAR2(30),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_licencias_pil (
    id_licencia     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empleado     NUMBER(10) NOT NULL REFERENCES rrhh_empleados(id_empleado),
    tipo            VARCHAR2(30) NOT NULL,
    numero          VARCHAR2(40) NOT NULL UNIQUE,
    autoridad_emisora VARCHAR2(80),
    fecha_emision   DATE,
    fecha_vencimiento DATE NOT NULL,
    habilitaciones  VARCHAR2(200),
    activa          CHAR(1) DEFAULT 'S' CHECK (activa IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_turnos (
    id_turno        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(60) NOT NULL UNIQUE,
    tipo            VARCHAR2(10) CHECK (tipo IN ('MANANA','TARDE','NOCHE','ROTATIVO')),
    hora_entrada    VARCHAR2(8),
    hora_salida     VARCHAR2(8),
    duracion_horas  NUMBER(4,1),
    dias_semana     VARCHAR2(20),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_asign_turnos (
    id_asignacion   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empleado     NUMBER(10) NOT NULL REFERENCES rrhh_empleados(id_empleado),
    id_turno        NUMBER(10) NOT NULL REFERENCES rrhh_turnos(id_turno),
    fecha_desde     DATE NOT NULL,
    fecha_hasta     DATE,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_empleado, id_turno, fecha_desde)
);

CREATE TABLE rrhh_tripulacion (
    id_trip_vuelo   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empleado     NUMBER(10) NOT NULL REFERENCES rrhh_empleados(id_empleado),
    id_instancia    NUMBER(10),
    rol             VARCHAR2(40) NOT NULL,
    es_comandante   CHAR(1) DEFAULT 'N' CHECK (es_comandante IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_viaticos (
    id_viatico      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empleado     NUMBER(10) NOT NULL REFERENCES rrhh_empleados(id_empleado),
    destino         VARCHAR2(100),
    fecha_inicio    DATE,
    fecha_fin       DATE,
    monto_aprobado_gtq NUMBER(10,2),
    monto_gastado_gtq NUMBER(10,2),
    estado          VARCHAR2(30) DEFAULT 'PENDIENTE',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

-- ============================================================
-- MÓDULO 4 — OPERACIONES & VUELOS (tablas faltantes)
-- ============================================================
CREATE TABLE oper_frecuencias (
    id_frecuencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_programa     NUMBER(10) NOT NULL REFERENCES oper_programas_vuelo(id_programa),
    dias_operacion  VARCHAR2(20) NOT NULL,
    hora_salida_local VARCHAR2(8) NOT NULL,
    hora_llegada_local VARCHAR2(8) NOT NULL,
    activa          CHAR(1) DEFAULT 'S' CHECK (activa IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_vuelos_instancia (
    id_instancia    NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_programa     NUMBER(10) NOT NULL REFERENCES oper_programas_vuelo(id_programa),
    id_avion        NUMBER(10) REFERENCES flota_aviones(id_avion),
    id_aeropuerto_origen  NUMBER(10) REFERENCES aero_aeropuertos(id_aeropuerto),
    id_aeropuerto_destino NUMBER(10) REFERENCES aero_aeropuertos(id_aeropuerto),
    fecha_vuelo     DATE NOT NULL,
    std             TIMESTAMP WITH TIME ZONE,
    sta             TIMESTAMP WITH TIME ZONE,
    atd             TIMESTAMP WITH TIME ZONE,
    ata             TIMESTAMP WITH TIME ZONE,
    estado          VARCHAR2(20) DEFAULT 'PROGRAMADO' CHECK (estado IN ('PROGRAMADO','EN_PROCESO','DESPEGADO','ATERRIZADO','CANCELADO','DEMORADO','DESVIADO')),
    pax_total       NUMBER(10) DEFAULT 0,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_tiempos_slot (
    id_slot         NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    slot_salida     TIMESTAMP WITH TIME ZONE,
    slot_llegada    TIMESTAMP WITH TIME ZONE,
    estado          VARCHAR2(30) DEFAULT 'ASIGNADO',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_bitacora_vuelo (
    id_bitacora     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_estado_cat   NUMBER(10) REFERENCES oper_cat_estados(id_estado_cat),
    descripcion     CLOB,
    usuario_registro VARCHAR2(50),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_cancelaciones (
    id_cancel       NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    motivo          VARCHAR2(100),
    tipo_causa      VARCHAR2(30),
    pax_afectados   NUMBER(10) DEFAULT 0,
    costo_estimado_usd NUMBER(12,2),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_demoras_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_demora_cat   NUMBER(10) NOT NULL REFERENCES oper_demoras_cat(id_demora_cat),
    minutos_demora  NUMBER(10) NOT NULL,
    descripcion     VARCHAR2(200),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_escalas_reales (
    id_escala_r     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_aeropuerto   NUMBER(10) NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    llegada_real    TIMESTAMP WITH TIME ZONE,
    salida_real     TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_planes_vuelo (
    id_plan_vuelo   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    nivel_vuelo     VARCHAR2(10),
    ruta_aerea      VARCHAR2(500),
    combustible_total_kg NUMBER(10,2),
    combustible_reserva_kg NUMBER(10,2),
    altitud_crucero_ft NUMBER(10),
    tiempo_estimado_min NUMBER(10),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_log_despegue (
    id_despegue     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    id_pista        NUMBER(10) REFERENCES aero_pistas(id_pista),
    hora_despegue   TIMESTAMP WITH TIME ZONE,
    viento_kt       NUMBER(10),
    temperatura_c   NUMBER(4,1),
    peso_despegue_kg NUMBER(10,2),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_log_aterrizaje (
    id_aterrizaje   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    id_pista        NUMBER(10) REFERENCES aero_pistas(id_pista),
    hora_aterrizaje TIMESTAMP WITH TIME ZONE,
    viento_kt       NUMBER(10),
    peso_aterrizaje_kg NUMBER(10,2),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_solicitud_gate (
    id_sol_gate     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_gate         NUMBER(10) REFERENCES aero_puertas_gates(id_gate),
    hora_inicio     TIMESTAMP WITH TIME ZONE,
    hora_fin        TIMESTAMP WITH TIME ZONE,
    estado          VARCHAR2(30) DEFAULT 'PENDIENTE',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_pushback_log (
    id_pushback     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    hora_inicio     TIMESTAMP WITH TIME ZONE,
    hora_fin        TIMESTAMP WITH TIME ZONE,
    tractorista     NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_manejo_rampa (
    id_rampa        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    tipo_servicio   VARCHAR2(40) NOT NULL,
    responsable     NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    estado          VARCHAR2(30) DEFAULT 'PENDIENTE',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_combustible_carg (
    id_fuel_log     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    tipo_combustible VARCHAR2(20),
    cantidad_kg     NUMBER(10,2),
    proveedor       VARCHAR2(80),
    factura_numero  VARCHAR2(40),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_control_peso (
    id_peso_manif   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    peso_pax_kg     NUMBER(10,2),
    peso_equipaje_kg NUMBER(10,2),
    peso_carga_kg   NUMBER(10,2),
    peso_combustible_kg NUMBER(10,2),
    peso_total_kg   NUMBER(10,2),
    aprobado        CHAR(1) DEFAULT 'N' CHECK (aprobado IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_catering_pedido (
    id_catering     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    proveedor       VARCHAR2(80),
    comidas_primera NUMBER(10) DEFAULT 0,
    comidas_ejecutivo NUMBER(10) DEFAULT 0,
    comidas_economica NUMBER(10) DEFAULT 0,
    estado          VARCHAR2(30) DEFAULT 'PENDIENTE',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_limpieza_log (
    id_limpieza     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    tipo            VARCHAR2(30),
    empresa         VARCHAR2(80),
    inicio          TIMESTAMP WITH TIME ZONE,
    fin             TIMESTAMP WITH TIME ZONE,
    calificacion    NUMBER(10) CHECK (calificacion BETWEEN 1 AND 5),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_reporte_capitan (
    id_rep_cap      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    id_comandante   NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    resumen_vuelo   CLOB,
    horas_vuelo_real NUMBER(6,2),
    incidencias     CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_reprograma (
    id_repro        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    std_original    TIMESTAMP WITH TIME ZONE,
    std_nueva       TIMESTAMP WITH TIME ZONE,
    motivo          CLOB,
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

-- ============================================================
-- MÓDULO 5 — PASAJEROS & EQUIPAJE (tablas faltantes)
-- ============================================================
CREATE TABLE pax_maestro (
    id_pax          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombres         VARCHAR2(80) NOT NULL,
    apellidos       VARCHAR2(80) NOT NULL,
    tipo_doc_principal VARCHAR2(30) CHECK (tipo_doc_principal IN ('DPI','PASAPORTE','LICENCIA_CONDUCIR','PERMISO_TRABAJO','OTRO')),
    numero_doc_principal VARCHAR2(30) NOT NULL,
    pais_doc        NUMBER(10) REFERENCES geog_paises(id_pais),
    fecha_nacimiento DATE,
    genero          CHAR(1) CHECK (genero IN ('M','F','O')),
    nacionalidad    NUMBER(10) REFERENCES geog_paises(id_pais),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (tipo_doc_principal, numero_doc_principal)
);

CREATE TABLE pax_documentos (
    id_doc          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    tipo            VARCHAR2(30) CHECK (tipo IN ('DPI','PASAPORTE','LICENCIA_CONDUCIR','PERMISO_TRABAJO','OTRO')),
    numero          VARCHAR2(30) NOT NULL,
    pais_emisor     NUMBER(10) REFERENCES geog_paises(id_pais),
    fecha_emision   DATE,
    fecha_vencimiento DATE,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (tipo, numero)
);

CREATE TABLE pax_telefonos (
    id_tel          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    tipo            VARCHAR2(20) CHECK (tipo IN ('MOVIL','CASA','TRABAJO','EMERGENCIA')),
    codigo_pais     VARCHAR2(5),
    numero          VARCHAR2(20) NOT NULL,
    es_principal    CHAR(1) DEFAULT 'N' CHECK (es_principal IN ('S','N')),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE pax_emails (
    id_email        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    email           VARCHAR2(100) NOT NULL,
    es_principal    CHAR(1) DEFAULT 'N' CHECK (es_principal IN ('S','N')),
    verificado      CHAR(1) DEFAULT 'N' CHECK (verificado IN ('S','N')),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE pax_cliente_frec (
    id_milla        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    id_aerolinea    NUMBER(10) NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    numero_membresia VARCHAR2(20) NOT NULL UNIQUE,
    nivel           VARCHAR2(20) DEFAULT 'BASIC',
    millas_disponibles NUMBER(19) DEFAULT 0,
    millas_acumuladas_total NUMBER(19) DEFAULT 0,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_pax, id_aerolinea)
);

CREATE TABLE pax_asistencias (
    id_asist        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    tipo            VARCHAR2(40) NOT NULL,
    requiere_silla  CHAR(1) DEFAULT 'N' CHECK (requiere_silla IN ('S','N')),
    requiere_oxigeno CHAR(1) DEFAULT 'N' CHECK (requiere_oxigeno IN ('S','N')),
    notas           CLOB,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE pax_menores_solos (
    id_menor        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL UNIQUE REFERENCES pax_maestro(id_pax),
    id_empleado_responsable NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    nombre_tutor_origen  VARCHAR2(100),
    telefono_tutor_origen VARCHAR2(30),
    nombre_tutor_destino VARCHAR2(100),
    telefono_tutor_destino VARCHAR2(30),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE reserva_encabezado (
    id_reserva_pnr  NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pnr             VARCHAR2(10) NOT NULL UNIQUE,
    canal_venta     VARCHAR2(30),
    id_agencia      NUMBER(10),
    estado          VARCHAR2(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA')),
    total_pagar     NUMBER(12,2),
    moneda          CHAR(3) DEFAULT 'GTQ',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE reserva_pax_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_reserva_pnr  NUMBER(10) NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    es_titular      CHAR(1) DEFAULT 'N' CHECK (es_titular IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_reserva_pnr, id_pax)
);

CREATE TABLE reserva_detalle (
    id_segmento     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_reserva_pnr  NUMBER(10) NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    clase_reserva   VARCHAR2(5),
    clase_cabina    VARCHAR2(20) CHECK (clase_cabina IN ('PRIMERA_CLASE','EJECUTIVO','ECONOMICA_PREMIUM','ECONOMICA')),
    tarifa_base_gtq NUMBER(10,2),
    estado          VARCHAR2(20) DEFAULT 'CONFIRMADO',
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE reserva_estado (
    id_pago_hist    NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_reserva_pnr  NUMBER(10) NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_metodo_pago  NUMBER(10) REFERENCES fin_metodos_pago(id_metodo),
    monto_gtq       NUMBER(12,2) NOT NULL,
    referencia_pago VARCHAR2(60),
    estado          VARCHAR2(20) CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA')),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE boleto_electronico (
    id_etkt         NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_reserva_pnr  NUMBER(10) NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    id_segmento     NUMBER(10) NOT NULL UNIQUE REFERENCES reserva_detalle(id_segmento),
    numero_boleto   VARCHAR2(20) NOT NULL UNIQUE,
    estado          VARCHAR2(20) DEFAULT 'ACTIVO',
    total_gtq       NUMBER(12,2),
    emitido_en      TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE boleto_impuestos_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_etkt         NUMBER(10) NOT NULL REFERENCES boleto_electronico(id_etkt),
    id_tax_item     NUMBER(10) NOT NULL REFERENCES boleto_impuestos(id_tax_item),
    monto_gtq       NUMBER(10,2) NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_etkt, id_tax_item)
);

CREATE TABLE checkin_registro (
    id_checkin      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_etkt         NUMBER(10) NOT NULL UNIQUE REFERENCES boleto_electronico(id_etkt),
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    canal           VARCHAR2(20) CHECK (canal IN ('MOSTRADOR','WEB','MOVIL','KIOSKO','AUTOMATICO')),
    id_counter      NUMBER(10) REFERENCES aero_mostradores(id_counter),
    id_agente       NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    realizado_en    TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE checkin_boarding_pass (
    id_pass         NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_checkin      NUMBER(10) NOT NULL UNIQUE REFERENCES checkin_registro(id_checkin),
    codigo_barras   VARCHAR2(60) NOT NULL UNIQUE,
    numero_asiento  VARCHAR2(5),
    grupo_embarque  VARCHAR2(5),
    generado_en     TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE asientos_asignados (
    id_asiento_pax  NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_checkin      NUMBER(10) NOT NULL UNIQUE REFERENCES checkin_registro(id_checkin),
    id_avion        NUMBER(10) NOT NULL REFERENCES flota_aviones(id_avion),
    fila            NUMBER(10) NOT NULL,
    letra           CHAR(1) NOT NULL,
    clase           VARCHAR2(20) CHECK (clase IN ('PRIMERA_CLASE','EJECUTIVO','ECONOMICA_PREMIUM','ECONOMICA')),
    es_ventana      CHAR(1) DEFAULT 'N' CHECK (es_ventana IN ('S','N')),
    es_pasillo      CHAR(1) DEFAULT 'N' CHECK (es_pasillo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_avion, id_checkin, fila, letra)
);

CREATE TABLE manifiesto_pax (
    id_manif        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    total_pax       NUMBER(10) DEFAULT 0,
    adultos         NUMBER(10) DEFAULT 0,
    menores         NUMBER(10) DEFAULT 0,
    infantes        NUMBER(10) DEFAULT 0,
    cerrado         CHAR(1) DEFAULT 'N' CHECK (cerrado IN ('S','N')),
    cerrado_en      TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_equipaje (
    id_bag          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    id_etkt         NUMBER(10) NOT NULL REFERENCES boleto_electronico(id_etkt),
    tipo            VARCHAR2(20) CHECK (tipo IN ('MALETA','BOLSO','FRAGIL','ESPECIAL','MASCOTA')),
    peso_kg         NUMBER(6,2),
    estado          VARCHAR2(20) DEFAULT 'REGISTRADO' CHECK (estado IN ('REGISTRADO','EN_BODEGA','EN_VUELO','ENTREGADO','PERDIDO','DANIADO','RECLAMADO')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_tags (
    id_tag          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_bag          NUMBER(10) NOT NULL UNIQUE REFERENCES bag_equipaje(id_bag),
    numero_tag      VARCHAR2(20) NOT NULL UNIQUE,
    codigo_barras   VARCHAR2(60) NOT NULL UNIQUE,
    generado_en     TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_trazabilidad (
    id_track        NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tag          NUMBER(10) NOT NULL REFERENCES bag_tags(id_tag),
    ubicacion       VARCHAR2(80),
    estado          VARCHAR2(20) CHECK (estado IN ('REGISTRADO','EN_BODEGA','EN_VUELO','ENTREGADO','PERDIDO','DANIADO','RECLAMADO')),
    escaneado_por   NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_peso_adicional (
    id_excess       NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_bag          NUMBER(10) NOT NULL REFERENCES bag_equipaje(id_bag),
    kg_adicionales  NUMBER(5,2) NOT NULL,
    tarifa_kg_gtq   NUMBER(8,2) NOT NULL,
    total_gtq       NUMBER(10,2) NOT NULL,
    estado_pago     VARCHAR2(20) DEFAULT 'PENDIENTE' CHECK (estado_pago IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_contenedores_uld (
    id_uld          NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_instancia    NUMBER(10) NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    numero_uld      VARCHAR2(20) NOT NULL,
    tipo            VARCHAR2(20),
    posicion_bodega VARCHAR2(10),
    peso_carga_kg   NUMBER(8,2),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_reclamos (
    id_reclamo      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_bag          NUMBER(10) NOT NULL REFERENCES bag_equipaje(id_bag),
    id_pax          NUMBER(10) NOT NULL REFERENCES pax_maestro(id_pax),
    tipo_reclamo    VARCHAR2(30) CHECK (tipo_reclamo IN ('PERDIDO','DANIADO','DEMORADO','CONTENIDO_FALTANTE')),
    estado          VARCHAR2(30) DEFAULT 'ABIERTO',
    descripcion     CLOB,
    fecha_reclamo   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_indemnizaciones (
    id_pago_indem   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_reclamo      NUMBER(10) NOT NULL UNIQUE REFERENCES bag_reclamos(id_reclamo),
    monto_gtq       NUMBER(12,2) NOT NULL,
    estado          VARCHAR2(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA')),
    pagado_en       TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_objetos_prohib (
    id_hallazgo     NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_bag          NUMBER(10) NOT NULL REFERENCES bag_equipaje(id_bag),
    descripcion     CLOB NOT NULL,
    tipo_objeto     VARCHAR2(60),
    accion_tomada   VARCHAR2(60),
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_hist_reclamos (
    id_hist_legal   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_reclamo      NUMBER(10) NOT NULL REFERENCES bag_reclamos(id_reclamo),
    estado_anterior VARCHAR2(30),
    estado_nuevo    VARCHAR2(30),
    nota            CLOB,
    registrado_en   TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

-- ============================================================
-- MÓDULO 6 — SEGURIDAD & FINANZAS (tablas faltantes)
-- ============================================================
CREATE TABLE seg_incidentes (
    id_incidente    NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empleado     NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    id_aeropuerto   NUMBER(10) NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    tipo            VARCHAR2(20) CHECK (tipo IN ('PELEA','AMENAZA','ROBO','ACTO_INDEBIDO','CONTRABANDO','OTRO')),
    descripcion     CLOB NOT NULL,
    severidad       VARCHAR2(20) CHECK (severidad IN ('BAJA','MEDIA','ALTA','CRITICA')),
    estado          VARCHAR2(30) DEFAULT 'ABIERTO',
    fecha_ocurrencia TIMESTAMP WITH TIME ZONE NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_arrestos (
    id_arresto      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_incidente    NUMBER(10) NOT NULL REFERENCES seg_incidentes(id_incidente),
    id_pax          NUMBER(10) REFERENCES pax_maestro(id_pax),
    motivo          VARCHAR2(200) NOT NULL,
    hora_detencion  TIMESTAMP WITH TIME ZONE NOT NULL,
    autoridad_entrega VARCHAR2(100),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_video_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_incidente    NUMBER(10) NOT NULL REFERENCES seg_incidentes(id_incidente),
    id_video        NUMBER(10) NOT NULL REFERENCES seg_pruebas_video(id_video),
    relevancia      VARCHAR2(20) CHECK (relevancia IN ('ALTA','MEDIA','BAJA')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_incidente, id_video)
);

CREATE TABLE seg_objetos_perdidos (
    id_objeto       NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_aeropuerto   NUMBER(10) NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    descripcion     CLOB NOT NULL,
    tipo            VARCHAR2(60),
    zona_hallazgo   VARCHAR2(80),
    entregado       CHAR(1) DEFAULT 'N' CHECK (entregado IN ('S','N')),
    hallado_en      TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_entrega_obj (
    id_entrega      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_objeto       NUMBER(10) NOT NULL UNIQUE REFERENCES seg_objetos_perdidos(id_objeto),
    id_pax          NUMBER(10) REFERENCES pax_maestro(id_pax),
    agente          NUMBER(10) REFERENCES rrhh_empleados(id_empleado),
    fecha_entrega   TIMESTAMP WITH TIME ZONE NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_lista_negra (
    id_black_list   NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pax          NUMBER(10) NOT NULL UNIQUE REFERENCES pax_maestro(id_pax),
    motivo          CLOB NOT NULL,
    nivel_riesgo    VARCHAR2(20) CHECK (nivel_riesgo IN ('BAJO','MEDIO','ALTO','CRITICO')),
    fecha_inclusion DATE NOT NULL,
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE fin_facturacion_linea (
    id_factura      NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_aerolinea    NUMBER(10) NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    id_instancia    NUMBER(10) REFERENCES oper_vuelos_instancia(id_instancia),
    numero_factura  VARCHAR2(30) NOT NULL UNIQUE,
    tipo            VARCHAR2(30),
    total_gtq       NUMBER(14,2) NOT NULL,
    estado          VARCHAR2(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA')),
    emitido_en      TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE fin_notas_credito (
    id_nota_cred    NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_factura      NUMBER(10) NOT NULL REFERENCES fin_facturacion_linea(id_factura),
    numero_nota     VARCHAR2(30) NOT NULL UNIQUE,
    monto_gtq       NUMBER(14,2) NOT NULL,
    motivo          VARCHAR2(200),
    estado          VARCHAR2(20) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE reporte_config (
    id_reporte_cfg  NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR2(100) NOT NULL UNIQUE,
    tipo            VARCHAR2(15) CHECK (tipo IN ('DIARIO','SEMANAL','MENSUAL','TRIMESTRAL','ANUAL','BAJO_DEMANDA')),
    descripcion     CLOB,
    formato_salida  VARCHAR2(20) DEFAULT 'PDF',
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE reporte_dest_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_reporte_cfg  NUMBER(10) NOT NULL REFERENCES reporte_config(id_reporte_cfg),
    id_destinatario NUMBER(10) NOT NULL REFERENCES reporte_destinatarios(id_destinatario),
    activo          CHAR(1) DEFAULT 'S' CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_reporte_cfg, id_destinatario)
);

-- ============================================================
-- FKs DIFERIDAS (tablas que referencian tablas creadas después)
-- ============================================================
ALTER TABLE flota_estado_avion ADD CONSTRAINT fk_est_avion_emp
    FOREIGN KEY (id_empleado) REFERENCES rrhh_empleados(id_empleado);

ALTER TABLE aero_estado_gate ADD CONSTRAINT fk_gate_emp
    FOREIGN KEY (id_empleado_registro) REFERENCES rrhh_empleados(id_empleado);

ALTER TABLE rrhh_tripulacion ADD CONSTRAINT fk_trip_instancia
    FOREIGN KEY (id_instancia) REFERENCES oper_vuelos_instancia(id_instancia);

ALTER TABLE flota_consumo_comb ADD CONSTRAINT fk_comb_instancia
    FOREIGN KEY (id_instancia_vuelo) REFERENCES oper_vuelos_instancia(id_instancia);

-- ============================================================
-- INDICES ADICIONALES
-- ============================================================
CREATE INDEX idx_ovi_fecha     ON oper_vuelos_instancia(fecha_vuelo);
CREATE INDEX idx_ovi_estado    ON oper_vuelos_instancia(estado);
CREATE INDEX idx_pax_doc       ON pax_maestro(tipo_doc_principal, numero_doc_principal);
CREATE INDEX idx_bag_estado    ON bag_equipaje(estado);
CREATE INDEX idx_reserva_pnr   ON reserva_encabezado(pnr);
CREATE INDEX idx_etkt_numero   ON boleto_electronico(numero_boleto);
CREATE INDEX idx_seg_fecha     ON seg_incidentes(fecha_ocurrencia);
CREATE INDEX idx_fin_factura   ON fin_facturacion_linea(numero_factura);

-- ============================================================
-- VIEWS ORACLE
-- ============================================================
CREATE OR REPLACE VIEW v_vuelos_hoy AS
SELECT
    vi.id_instancia,
    la.codigo_iata AS aerolinea,
    pv.numero_vuelo,
    ao.codigo_iata AS origen,
    ad.codigo_iata AS destino,
    vi.std,
    vi.sta,
    vi.estado,
    vi.pax_total
FROM oper_vuelos_instancia vi
JOIN oper_programas_vuelo pv   ON vi.id_programa = pv.id_programa
JOIN linea_aerolineas la       ON pv.id_aerolinea = la.id_aerolinea
JOIN aero_aeropuertos ao       ON vi.id_aeropuerto_origen = ao.id_aeropuerto
JOIN aero_aeropuertos ad       ON vi.id_aeropuerto_destino = ad.id_aeropuerto
WHERE TRUNC(vi.fecha_vuelo) = TRUNC(SYSDATE);

CREATE OR REPLACE VIEW v_equipaje_en_transito AS
SELECT
    bt.numero_tag,
    pm.nombres || ' ' || pm.apellidos AS pasajero,
    be.peso_kg,
    be.estado,
    (SELECT bt2.registrado_en FROM bag_trazabilidad bt2
     WHERE bt2.id_tag = bt.id_tag
     AND ROWNUM = 1
     ORDER BY bt2.registrado_en DESC) AS ultimo_escaneo
FROM bag_equipaje be
JOIN bag_tags bt       ON be.id_bag = bt.id_bag
JOIN pax_maestro pm    ON be.id_pax = pm.id_pax
WHERE be.estado NOT IN ('ENTREGADO','PERDIDO');

CREATE OR REPLACE VIEW v_otp_por_aerolinea AS
SELECT
    la.nombre AS aerolinea,
    EXTRACT(YEAR FROM vi.fecha_vuelo) AS anno,
    EXTRACT(MONTH FROM vi.fecha_vuelo) AS mes,
    COUNT(*) AS total_vuelos,
    SUM(CASE WHEN vi.estado = 'ATERRIZADO' AND vi.ata <= vi.sta THEN 1 ELSE 0 END) AS a_tiempo,
    ROUND(
        SUM(CASE WHEN vi.estado = 'ATERRIZADO' AND vi.ata <= vi.sta THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*),0), 2
    ) AS otp_porcentaje
FROM oper_vuelos_instancia vi
JOIN oper_programas_vuelo pv ON vi.id_programa = pv.id_programa
JOIN linea_aerolineas la     ON pv.id_aerolinea = la.id_aerolinea
GROUP BY la.nombre, EXTRACT(YEAR FROM vi.fecha_vuelo), EXTRACT(MONTH FROM vi.fecha_vuelo);

CREATE OR REPLACE VIEW v_aviones_operativos AS
SELECT
    av.matricula,
    av.numero_serie,
    la.nombre AS aerolinea,
    fm.fabricante || ' ' || fm.modelo AS modelo,
    av.estado,
    av.horas_vuelo_total,
    (SELECT MAX(hm.fecha_inicio) FROM flota_hist_manten hm WHERE hm.id_avion = av.id_avion) AS ultimo_mantenimiento
FROM flota_aviones av
JOIN flota_modelos fm        ON av.id_modelo = fm.id_modelo
JOIN linea_aerolineas la     ON av.id_aerolinea = la.id_aerolinea
WHERE av.activo = 'S';

CREATE OR REPLACE VIEW v_empleados_activos AS
SELECT
    e.codigo_empleado,
    e.nombres || ' ' || e.apellidos AS nombre_completo,
    p.nombre AS puesto,
    d.nombre AS departamento,
    la.nombre AS aerolinea,
    e.email_corporativo,
    e.fecha_ingreso,
    FLOOR(MONTHS_BETWEEN(SYSDATE, e.fecha_ingreso)/12) AS anios_servicio
FROM rrhh_empleados e
JOIN rrhh_puestos p           ON e.id_puesto = p.id_puesto
JOIN rrhh_departamentos d     ON e.id_depto = d.id_depto
LEFT JOIN linea_aerolineas la ON e.id_aerolinea = la.id_aerolinea
WHERE e.activo = 'S';

COMMIT;

SELECT 'TABLAS CREADAS: ' || COUNT(*) AS resultado FROM user_tables;

EXIT;

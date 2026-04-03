-- ============================================================
--  SISTEMA DE GESTIÓN AEROPORTUARIA - GUATEMALA
--  Script DDL - Oracle Database 23ai Free
--  Convertido desde PostgreSQL 15 → Oracle 23ai
--  Usuario: AEROGT  |  PDB: FREEPDB1
--  Puerto: 1539     |  Fecha: 2026-03-22
--  Módulos: 6  |  Tablas: 161  |  FKs: 227
-- ============================================================

-- Ejecutar como: sqlplus aerogt/"AeroGT_2025#"@servidor-db.local:1539/FREEPDB1
-- Comando:  @/home/umg/create_aerogt_oracle.sql

SET ECHO ON
SET FEEDBACK ON  
SET DEFINE OFF
SET SERVEROUTPUT ON

--  SISTEMA DE GESTIÓN AEROPORTUARIA - GUATEMALA
--  Script DDL Completo - PostgreSQL 15+
--  Empresa: Aerolínea Guatemalteca
--  Módulos: Infraestructura, Aerolíneas & Flota, RRHH,
--           Operaciones & Vuelos, Pasajeros & Equipaje,
--           Seguridad & Finanzas
--  Generado: 2026-03-18

-- TIPOS ENUMERADOS

-- ██████████████████████████████████████████████████████████
-- MÓDULO 1: INFRAESTRUCTURA
-- ██████████████████████████████████████████████████████████

-- ------------------------------------------------------------
-- GEOGRAFÍA
-- ------------------------------------------------------------
CREATE TABLE geog_continentes (
    id_continente   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(60)     NOT NULL UNIQUE,
    codigo_iso      CHAR(2)         NOT NULL UNIQUE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE geog_paises (
    id_pais         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_continente   NUMBER(10)             NOT NULL REFERENCES geog_continentes(id_continente),
    nombre          VARCHAR2(100)    NOT NULL,
    codigo_iso2     CHAR(2)         NOT NULL UNIQUE,
    codigo_iso3     CHAR(3)         NOT NULL UNIQUE,
    codigo_telefonico VARCHAR2(10),
    moneda          VARCHAR2(10),
    idioma_principal VARCHAR2(50),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE geog_estados_dep (
    id_estado       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pais         NUMBER(10)             NOT NULL REFERENCES geog_paises(id_pais),
    nombre          VARCHAR2(100)    NOT NULL,
    codigo          VARCHAR2(10),
    tipo            VARCHAR2(50)     DEFAULT 'DEPARTAMENTO',
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_pais, nombre)
);

CREATE TABLE geog_ciudades (
    id_ciudad       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_estado       NUMBER(10)             NOT NULL REFERENCES geog_estados_dep(id_estado),
    nombre          VARCHAR2(100)    NOT NULL,
    codigo_postal   VARCHAR2(20),
    latitud         NUMBER(10,7),
    longitud        NUMBER(10,7),
    poblacion       NUMBER(19),
    altitud_msnm    NUMBER(10),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE geog_zonas_horarias (
    id_zona         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(80)     NOT NULL UNIQUE,
    utc_offset      VARCHAR2(30)        NOT NULL,
    codigo_tz       VARCHAR2(50)     NOT NULL UNIQUE,
    aplica_dst      CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N'))
);

-- ------------------------------------------------------------
-- AEROPUERTOS (EJE CENTRAL)
-- ------------------------------------------------------------
CREATE TABLE aero_aeropuertos (
    id_aeropuerto   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_ciudad       NUMBER(10)             NOT NULL REFERENCES geog_ciudades(id_ciudad),
    id_zona         NUMBER(10)             NOT NULL REFERENCES geog_zonas_horarias(id_zona),
    codigo_iata     CHAR(3)         NOT NULL UNIQUE,
    codigo_icao     CHAR(4)         NOT NULL UNIQUE,
    nombre          VARCHAR2(150)    NOT NULL,
    nombre_corto    VARCHAR2(60),
    tipo            VARCHAR2(40)     DEFAULT 'INTERNACIONAL',
    latitud         NUMBER(10,7)   NOT NULL,
    longitud        NUMBER(10,7)   NOT NULL,
    altitud_ft      NUMBER(10),
    es_hub          CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ------------------------------------------------------------
-- ASPA 1: ZONA AÉREA (PISTAS, RODAJE, PLATAFORMAS, HANGARES)
-- ------------------------------------------------------------
CREATE TABLE aero_pistas (
    id_pista        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    designacion     VARCHAR2(10)     NOT NULL,
    longitud_m      NUMBER(8,2)    NOT NULL,
    ancho_m         NUMBER(6,2)    NOT NULL,
    orientacion_grados NUMBER(5,2),
    tipo_superficie VARCHAR2(15) CHECK (tipo_superficie IN ('ASFALTO','CONCRETO','GRAVA','CESPED'))      DEFAULT 'ASFALTO',
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVA',
    carga_max_kg    NUMBER(19),
    iluminada       CHAR(1)         DEFAULT 'S' NOT NULL,
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_aeropuerto, designacion)
);

CREATE TABLE aero_material_pista (
    id_material     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pista        NUMBER(10)             NOT NULL UNIQUE REFERENCES aero_pistas(id_pista),
    tipo_material   VARCHAR2(60)     NOT NULL,
    fecha_ultima_reparacion DATE,
    vida_util_anios NUMBER(10),
    pcn_valor       NUMBER(6,2),
    notas           CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_umbrales_pista (
    id_umbral       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pista        NUMBER(10)             NOT NULL REFERENCES aero_pistas(id_pista),
    designacion     VARCHAR2(10)     NOT NULL,
    latitud         NUMBER(10,7),
    longitud        NUMBER(10,7),
    elevacion_ft    NUMBER(10),
    desplazado_m    NUMBER(6,2)    DEFAULT 0,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_calles_rodaje (
    id_taxiway      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    designacion     VARCHAR2(10)     NOT NULL,
    longitud_m      NUMBER(8,2),
    ancho_m         NUMBER(5,2),
    tipo            VARCHAR2(30)     DEFAULT 'PRINCIPAL',
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVA',
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_aeropuerto, designacion)
);

CREATE TABLE aero_plataformas (
    id_plataforma   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(60)     NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'AVIACION_COMERCIAL',
    capacidad_aeronaves NUMBER(10),
    area_m2         NUMBER(10,2),
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVA',
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_hangares (
    id_hangar       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(60)     NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'MANTENIMIENTO',
    capacidad_aeronaves NUMBER(10),
    area_m2         NUMBER(10,2),
    altura_m        NUMBER(6,2),
    disponible      CHAR(1)         DEFAULT 'S' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ------------------------------------------------------------
-- ASPA 2: TERMINALES
-- ------------------------------------------------------------
CREATE TABLE aero_terminales (
    id_terminal     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(80)     NOT NULL,
    codigo          VARCHAR2(10),
    tipo            VARCHAR2(40)     DEFAULT 'INTERNACIONAL',
    area_m2         NUMBER(10,2),
    nivel_pisos     NUMBER(10)             DEFAULT 1,
    capacidad_pax_hora NUMBER(10),
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVA',
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_secciones_terminal (
    id_seccion      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_terminal     NUMBER(10)             NOT NULL REFERENCES aero_terminales(id_terminal),
    nombre          VARCHAR2(80)     NOT NULL,
    tipo            VARCHAR2(40),
    nivel           NUMBER(10)             DEFAULT 1,
    area_m2         NUMBER(8,2),
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_puertas_gates (
    id_gate         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_seccion      NUMBER(10)             NOT NULL REFERENCES aero_secciones_terminal(id_seccion),
    codigo          VARCHAR2(10)     NOT NULL,
    tipo            VARCHAR2(30)     DEFAULT 'MANGA',
    estado          VARCHAR2(20) CHECK (estado IN ('DISPONIBLE','OCUPADO','EN_MANTENIMIENTO','RESERVADO','CERRADO'))     DEFAULT 'DISPONIBLE',
    tipo_aeronave_max VARCHAR2(20),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_estado_gate (
    id_log_gate     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_gate         NUMBER(10)             NOT NULL REFERENCES aero_puertas_gates(id_gate),
    estado_anterior VARCHAR2(20) CHECK (estado_anterior IN ('DISPONIBLE','OCUPADO','EN_MANTENIMIENTO','RESERVADO','CERRADO')),
    estado_nuevo    VARCHAR2(20) CHECK (estado_nuevo IN ('DISPONIBLE','OCUPADO','EN_MANTENIMIENTO','RESERVADO','CERRADO'))     NOT NULL,
    motivo          VARCHAR2(200),
    id_empleado_registro NUMBER(10),            -- FK a rrhh_empleados agregada al final con ALTER TABLE
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_salas_espera (
    id_sala         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_terminal     NUMBER(10)             NOT NULL REFERENCES aero_terminales(id_terminal),
    nombre          VARCHAR2(80)     NOT NULL,
    capacidad_personas NUMBER(10),
    tiene_wifi      CHAR(1)         DEFAULT 'S' NOT NULL,
    tiene_enchufes  CHAR(1)         DEFAULT 'S' NOT NULL,
    area_m2         NUMBER(8,2),
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_vip_lounge (
    id_vip          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_terminal     NUMBER(10)             NOT NULL REFERENCES aero_terminales(id_terminal),
    nombre          VARCHAR2(80)     NOT NULL,
    operador        VARCHAR2(80),
    capacidad       NUMBER(10),
    precio_acceso_usd NUMBER(8,2),
    horario_apertura TIME,
    horario_cierre  TIME,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_mostradores (
    id_counter      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_terminal     NUMBER(10)             NOT NULL REFERENCES aero_terminales(id_terminal),
    codigo          VARCHAR2(10)     NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'CHECK_IN',
    estado          VARCHAR2(30)     DEFAULT 'DISPONIBLE',
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_sistemas_equipaje (
    id_banda        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_terminal     NUMBER(10)             NOT NULL REFERENCES aero_terminales(id_terminal),
    codigo          VARCHAR2(20)     NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'RECLAIM',
    longitud_m      NUMBER(6,2),
    capacidad_maletas_hora NUMBER(10),
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVO',
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ------------------------------------------------------------
-- ASPA 3: TÉCNICA / LOGÍSTICA
-- ------------------------------------------------------------
CREATE TABLE aero_detalle_tecnico (
    id_detalle      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL UNIQUE REFERENCES aero_aeropuertos(id_aeropuerto),
    categoria_oaci  VARCHAR2(10),
    categoria_faa   VARCHAR2(10),
    certificado_aip CHAR(1)         DEFAULT 'N' NOT NULL,
    capacidad_anual_pax NUMBER(19),
    capacidad_anual_ops NUMBER(10),
    superficie_total_m2 NUMBER(12,2),
    anno_inauguracion NUMBER(10),
    ultima_remodelacion NUMBER(10),
    tiene_radar     CHAR(1)         DEFAULT 'S' NOT NULL,
    tiene_ils       CHAR(1)         DEFAULT 'S' NOT NULL,
    tiene_vor       CHAR(1)         DEFAULT 'S' NOT NULL,
    tiene_dme       CHAR(1)         DEFAULT 'S' NOT NULL,
    notas           CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_frecuencias_radio (
    id_frecuencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    tipo            VARCHAR2(10) CHECK (tipo IN ('VHF','UHF','HF','SATCOM')) DEFAULT 'VHF',
    servicio        VARCHAR2(60)     NOT NULL,
    frecuencia_mhz  NUMBER(8,3)    NOT NULL,
    descripcion     VARCHAR2(150),
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_iluminacion (
    id_luz          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    zona            VARCHAR2(60)     NOT NULL,
    tipo_sistema    VARCHAR2(60),
    intensidad      VARCHAR2(20),
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVO',
    fecha_instalacion DATE,
    vida_util_anios NUMBER(10),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_bodegas_log (
    id_bodega       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(60)     NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'CARGA_GENERAL',
    area_m2         NUMBER(10,2),
    capacidad_kg    NUMBER(19),
    temperatura_controlada CHAR(1)  DEFAULT 'N' NOT NULL,
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVA',
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_equipos_apoyo (
    id_equipo       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(80)     NOT NULL,
    tipo            VARCHAR2(60)     NOT NULL,
    marca           VARCHAR2(60),
    modelo          VARCHAR2(60),
    numero_serie    VARCHAR2(50),
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVO',
    fecha_adquisicion DATE,
    proximo_mantenimiento DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Aeropuertos ↔ Equipos (un equipo puede moverse entre aeropuertos)
CREATE TABLE aero_aeropuertos_equipos (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    id_equipo       NUMBER(10)             NOT NULL REFERENCES aero_equipos_apoyo(id_equipo),
    fecha_asignacion DATE           DEFAULT CURRENT_DATE,
    fecha_retiro    DATE,
    motivo          VARCHAR2(150),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    UNIQUE (id_aeropuerto, id_equipo, fecha_asignacion)
);

-- ------------------------------------------------------------
-- ASPA 4: SEGURIDAD FÍSICA
-- ------------------------------------------------------------
CREATE TABLE aero_sistemas_incendio (
    id_fire_sys     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    zona            VARCHAR2(80)     NOT NULL,
    tipo_sistema    VARCHAR2(60)     NOT NULL,
    capacidad_litros NUMBER(10),
    ultima_prueba   DATE,
    proxima_prueba  DATE,
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVO',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_puntos_control (
    id_control      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(80)     NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'SEGURIDAD',
    VARCHAR2(30)    VARCHAR2(20) CHECK (VARCHAR2(30) IN ('PUBLICO','RESTRINGIDO','SEGURIDAD','OPERACIONES','ADMINISTRACION'))    DEFAULT 'RESTRINGIDO',
    tiene_rayos_x   CHAR(1)         DEFAULT 'S' NOT NULL,
    tiene_arco_detector CHAR(1)     DEFAULT 'S' NOT NULL,
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVO',
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_estacionamientos_pax (
    id_parking      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    nombre          VARCHAR2(60)     NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'CORTO_PLAZO',
    capacidad_vehiculos NUMBER(10),
    tarifa_hora_gtq NUMBER(6,2),
    tarifa_dia_gtq  NUMBER(8,2),
    VARCHAR2(30)    VARCHAR2(30),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ------------------------------------------------------------
-- ASPA 5: AUDITORÍA INFRAESTRUCTURA
-- ------------------------------------------------------------
CREATE TABLE aero_incidencias_infra (
    id_incidencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    tipo            VARCHAR2(60)     NOT NULL,
    descripcion     CLOB            NOT NULL,
    zona_afectada   VARCHAR2(100),
    severidad       VARCHAR2(20)     DEFAULT 'MEDIA',
    estado          VARCHAR2(30)     DEFAULT 'ABIERTA',
    fecha_apertura  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    fecha_cierre    TIMESTAMP WITH TIME ZONE,
    responsable     VARCHAR2(100),
    costo_estimado_gtq NUMBER(12,2),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE aero_historico_infra (
    id_historico    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    entidad         VARCHAR2(60)     NOT NULL,
    id_entidad      NUMBER(10)             NOT NULL,     -- ID polimórfico (sin FK, referencia dinámica por entidad)
    campo_modificado VARCHAR2(80),
    valor_anterior  CLOB,
    valor_nuevo     CLOB,
    modificado_por  VARCHAR2(100),
    modificado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ██████████████████████████████████████████████████████████
-- MÓDULO 2: AEROLÍNEAS & FLOTA
-- ██████████████████████████████████████████████████████████

CREATE TABLE linea_aerolineas (
    id_aerolinea    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    codigo_iata     CHAR(2)         NOT NULL UNIQUE,
    codigo_icao     CHAR(3)         NOT NULL UNIQUE,
    nombre          VARCHAR2(150)    NOT NULL,
    nombre_comercial VARCHAR2(100),
    pais_origen     NUMBER(10)             REFERENCES geog_paises(id_pais),
    sitio_web       VARCHAR2(200),
    telefono_central VARCHAR2(30),
    email_central   VARCHAR2(100),
    fecha_fundacion DATE,
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE linea_contactos (
    id_contacto     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    tipo            VARCHAR2(40)     DEFAULT 'GENERAL',
    nombre          VARCHAR2(100)    NOT NULL,
    cargo           VARCHAR2(80),
    telefono        VARCHAR2(30),
    email           VARCHAR2(100),
    es_principal    CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE linea_alianzas (
    id_alianza      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(80)     NOT NULL UNIQUE,
    descripcion     CLOB,
    anno_fundacion  NUMBER(10),
    sede            VARCHAR2(100),
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Aerolíneas ↔ Alianzas
CREATE TABLE linea_alianzas_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    id_alianza      NUMBER(10)             NOT NULL REFERENCES linea_alianzas(id_alianza),
    fecha_ingreso   DATE            NOT NULL,
    fecha_salida    DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    UNIQUE (id_aerolinea, id_alianza)
);

CREATE TABLE linea_ac_compartidos (
    id_acuerdo      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    id_aerolinea_socio NUMBER(10)          NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    tipo            VARCHAR2(40)     DEFAULT 'CODESHARE',
    fecha_inicio    DATE            NOT NULL,
    fecha_fin       DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    notas           CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_aerolinea, id_aerolinea_socio, tipo)
);

CREATE TABLE flota_modelos (
    id_modelo       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    fabricante      VARCHAR2(60)     NOT NULL,
    modelo          VARCHAR2(60)     NOT NULL,
    variante        VARCHAR2(30),
    capacidad_pax_max NUMBER(10),
    alcance_km      NUMBER(10),
    velocidad_crucero_kmh NUMBER(10),
    autonomia_horas NUMBER(4,1),
    envergadura_m   NUMBER(6,2),
    longitud_m      NUMBER(6,2),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_aerolinea, fabricante, modelo, variante)
);

CREATE TABLE flota_config_cabina (
    id_config       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_modelo       NUMBER(10)             NOT NULL REFERENCES flota_modelos(id_modelo),
    nombre_config   VARCHAR2(80)     NOT NULL,
    total_asientos  NUMBER(10)             NOT NULL,
    primera_clase   NUMBER(10)             DEFAULT 0,
    ejecutivo       NUMBER(10)             DEFAULT 0,
    economica_prem  NUMBER(10)             DEFAULT 0,
    economica       NUMBER(10)             DEFAULT 0,
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_tipo_asiento (
    id_tipo_asiento NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    clase           VARCHAR2(20) CHECK (clase IN ('PRIMERA_CLASE','EJECUTIVO','ECONOMICA_PREMIUM','ECONOMICA'))    NOT NULL,
    descripcion     VARCHAR2(100),
    ancho_pulgadas  NUMBER(4,1),
    paso_pulgadas   NUMBER(10),
    reclinacion_grados NUMBER(10),
    tiene_pantalla  CHAR(1)         DEFAULT 'N' NOT NULL,
    tiene_enchufe   CHAR(1)         DEFAULT 'N' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Configuración ↔ Tipo de Asiento
CREATE TABLE flota_tipo_asiento_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_config       NUMBER(10)             NOT NULL REFERENCES flota_config_cabina(id_config),
    id_tipo_asiento NUMBER(10)             NOT NULL REFERENCES flota_tipo_asiento(id_tipo_asiento),
    cantidad        NUMBER(10)             DEFAULT 0,
    UNIQUE (id_config, id_tipo_asiento)
);

CREATE TABLE flota_aviones (
    id_avion        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_modelo       NUMBER(10)             NOT NULL REFERENCES flota_modelos(id_modelo),
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    id_config       NUMBER(10)             REFERENCES flota_config_cabina(id_config),
    matricula       VARCHAR2(20)     NOT NULL UNIQUE,
    numero_serie    VARCHAR2(50)     NOT NULL UNIQUE,
    anno_fabricacion NUMBER(10),
    fecha_entrega   DATE,
    estado          VARCHAR2(20) CHECK (estado IN ('OPERATIVO','EN_MANTENIMIENTO','EN_REPARACION','RETIRADO','ARRENDADO','EN_INSPECCION'))    DEFAULT 'OPERATIVO',
    base_operaciones NUMBER(10)            REFERENCES aero_aeropuertos(id_aeropuerto),
    horas_vuelo_total NUMBER(10,1) DEFAULT 0,
    ciclos_total    NUMBER(10)             DEFAULT 0,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_estado_avion (
    id_estado       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    estado_anterior VARCHAR2(20) CHECK (estado_anterior IN ('OPERATIVO','EN_MANTENIMIENTO','EN_REPARACION','RETIRADO','ARRENDADO','EN_INSPECCION')),
    estado_nuevo    VARCHAR2(20) CHECK (estado_nuevo IN ('OPERATIVO','EN_MANTENIMIENTO','EN_REPARACION','RETIRADO','ARRENDADO','EN_INSPECCION'))    NOT NULL,
    motivo          VARCHAR2(200),
    id_empleado     NUMBER(10),             -- FK a rrhh_empleados agregada al final con ALTER TABLE
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_hist_matriculas (
    id_hist_mat     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    matricula       VARCHAR2(20)     NOT NULL,
    id_aerolinea    NUMBER(10)             REFERENCES linea_aerolineas(id_aerolinea),
    fecha_desde     DATE            NOT NULL,
    fecha_hasta     DATE,
    motivo_cambio   VARCHAR2(100),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_motores (
    id_motor        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    posicion        VARCHAR2(10)     NOT NULL,
    fabricante      VARCHAR2(60)     NOT NULL,
    modelo          VARCHAR2(60)     NOT NULL,
    numero_serie    VARCHAR2(50)     NOT NULL UNIQUE,
    horas_totales   NUMBER(10,1)   DEFAULT 0,
    ciclos_totales  NUMBER(10)             DEFAULT 0,
    estado          VARCHAR2(30)     DEFAULT 'OPERATIVO',
    fecha_instalacion DATE,
    proximo_overhaul DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_componentes (
    id_componente   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    nombre          VARCHAR2(100)    NOT NULL,
    part_number     VARCHAR2(60),
    numero_serie    VARCHAR2(60),
    tipo            VARCHAR2(60),
    estado          VARCHAR2(30)     DEFAULT 'INSTALADO',
    fecha_instalacion DATE,
    vida_util_horas NUMBER(10,1),
    horas_restantes NUMBER(10,1),
    proximo_cambio  DATE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_peso_balance (
    id_peso         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    peso_vacio_kg   NUMBER(10,2)   NOT NULL,
    peso_max_despegue_kg NUMBER(10,2) NOT NULL,
    peso_max_aterrizaje_kg NUMBER(10,2),
    peso_max_sin_comb_kg NUMBER(10,2),
    carga_max_comercial_kg NUMBER(10,2),
    combustible_max_kg NUMBER(10,2),
    cg_referencia_mm NUMBER(8,2),
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- [flota_consumo_comb reubicado más abajo por orden de FK]

CREATE TABLE flota_telemetria (
    id_telemetria   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    latitud         NUMBER(10,7),
    longitud        NUMBER(10,7),
    altitud_ft      NUMBER(10),
    velocidad_kmh   NUMBER(10),
    rumbo_grados    NUMBER(5,2),
    temperatura_ext NUMBER(5,2),
    presion_cabina  NUMBER(7,2),
    estado_motores  CLOB
);

CREATE TABLE flota_hist_manten (
    id_manten       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(60)     NOT NULL,
    descripcion     CLOB            NOT NULL,
    fecha_inicio    TIMESTAMP WITH TIME ZONE     NOT NULL,
    fecha_fin       TIMESTAMP WITH TIME ZONE,
    proveedor       VARCHAR2(100),
    id_hangar       NUMBER(10)             REFERENCES aero_hangares(id_hangar),
    costo_usd       NUMBER(14,2),
    horas_avion_al_manten NUMBER(10,1),
    aprobado_por    VARCHAR2(100),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_certificados (
    id_cert         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(80)     NOT NULL,
    numero          VARCHAR2(60)     NOT NULL,
    organismo_emisor VARCHAR2(80),
    fecha_emision   DATE            NOT NULL,
    fecha_vencimiento DATE          NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_log_averias (
    id_averia       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    descripcion     CLOB            NOT NULL,
    severidad       VARCHAR2(20)     DEFAULT 'MENOR',
    sistema_afectado VARCHAR2(80),
    fecha_reporte   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    fecha_reparacion TIMESTAMP WITH TIME ZONE,
    reportado_por   VARCHAR2(100),
    solucion        CLOB,
    estado          VARCHAR2(30)     DEFAULT 'ABIERTA',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_proveed_rep (
    id_proveedor    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(150)    NOT NULL,
    codigo          VARCHAR2(30),
    pais            NUMBER(10)             REFERENCES geog_paises(id_pais),
    contacto_nombre VARCHAR2(100),
    contacto_email  VARCHAR2(100),
    contacto_tel    VARCHAR2(30),
    certificaciones CLOB[],
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Aviones ↔ Proveedores de repuestos
CREATE TABLE flota_proveed_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    id_proveedor    NUMBER(10)             NOT NULL REFERENCES flota_proveed_rep(id_proveedor),
    tipo_servicio   VARCHAR2(80),
    fecha_desde     DATE            DEFAULT CURRENT_DATE,
    fecha_hasta     DATE,
    contrato_ref    VARCHAR2(60),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    UNIQUE (id_avion, id_proveedor, tipo_servicio)
);

CREATE TABLE flota_ins_seguridad (
    id_inspeccion   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(60)     NOT NULL,
    fecha           DATE            NOT NULL,
    inspector       VARCHAR2(100),
    organismo       VARCHAR2(100),
    resultado       VARCHAR2(30)     DEFAULT 'APROBADO',
    observaciones   CLOB,
    proxima_insp    DATE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_capacidad_carg (
    id_capacidad    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    compartimentos  NUMBER(10)             DEFAULT 2,
    vol_total_m3    NUMBER(8,2),
    vol_bodega_frontal_m3 NUMBER(7,2),
    vol_bodega_trasera_m3 NUMBER(7,2),
    peso_max_hold_kg NUMBER(10,2),
    acepta_carga_peligrosa CHAR(1)  DEFAULT 'N' NOT NULL,
    acepta_animales CHAR(1)         DEFAULT 'N' NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_eq_emergencia (
    id_emergencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    tipo            VARCHAR2(60)     NOT NULL,
    cantidad        NUMBER(10)             DEFAULT 1,
    ubicacion       VARCHAR2(80),
    fecha_vencimiento DATE,
    estado          VARCHAR2(30)     DEFAULT 'VIGENTE',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_sistemas_entre (
    id_ife          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    proveedor       VARCHAR2(60),
    version         VARCHAR2(30),
    pantallas_pax   NUMBER(10),
    pantallas_tripulacion NUMBER(10),
    canales_video   NUMBER(10),
    canales_audio   NUMBER(10),
    juegos          CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_wifi_service (
    id_wifi         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL UNIQUE REFERENCES flota_aviones(id_avion),
    proveedor       VARCHAR2(60),
    tecnologia      VARCHAR2(30),
    velocidad_mbps  NUMBER(6,2),
    cobertura       VARCHAR2(60),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_reserv_hangar (
    id_reserva      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    id_hangar       NUMBER(10)             NOT NULL REFERENCES aero_hangares(id_hangar),
    fecha_entrada   TIMESTAMP WITH TIME ZONE     NOT NULL,
    fecha_salida    TIMESTAMP WITH TIME ZONE,
    motivo          VARCHAR2(150),
    costo_gtq       NUMBER(12,2),
    estado          VARCHAR2(30)     DEFAULT 'ACTIVA',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ██████████████████████████████████████████████████████████
-- MÓDULO 3: RECURSOS HUMANOS
-- ██████████████████████████████████████████████████████████

CREATE TABLE rrhh_departamentos (
    id_depto        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(80)     NOT NULL UNIQUE,
    descripcion     CLOB,
    id_depto_padre  NUMBER(10)             REFERENCES rrhh_departamentos(id_depto),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_puestos (
    id_puesto       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_depto        NUMBER(10)             NOT NULL REFERENCES rrhh_departamentos(id_depto),
    nombre          VARCHAR2(100)    NOT NULL,
    descripcion     CLOB,
    nivel_jerarquico NUMBER(10)            DEFAULT 1,
    salario_min_gtq NUMBER(10,2),
    salario_max_gtq NUMBER(10,2),
    requiere_licencia CHAR(1)       DEFAULT 'N' NOT NULL,
    tipo_licencia   VARCHAR2(30),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_empleados (
    id_empleado     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_puesto       NUMBER(10)             NOT NULL REFERENCES rrhh_puestos(id_puesto),
    id_depto        NUMBER(10)             NOT NULL REFERENCES rrhh_departamentos(id_depto),
    id_aerolinea    NUMBER(10)             REFERENCES linea_aerolineas(id_aerolinea),
    codigo_empleado VARCHAR2(20)     NOT NULL UNIQUE,
    nombres         VARCHAR2(80)     NOT NULL,
    apellidos       VARCHAR2(80)     NOT NULL,
    dpi             VARCHAR2(20)     UNIQUE,
    pasaporte       VARCHAR2(20),
    fecha_nacimiento DATE,
    genero          CHAR(1),
    nacionalidad    NUMBER(10)             REFERENCES geog_paises(id_pais),
    email_corporativo VARCHAR2(100)  NOT NULL UNIQUE,
    email_personal  VARCHAR2(100),
    telefono        VARCHAR2(20),
    telefono_emergencia VARCHAR2(20),
    contacto_emergencia VARCHAR2(100),
    fecha_ingreso   DATE            NOT NULL,
    estado          VARCHAR2(20)     DEFAULT 'ACTIVO',
    id_supervisor   NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_contratos (
    id_contrato     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL UNIQUE REFERENCES rrhh_empleados(id_empleado),
    tipo            VARCHAR2(30) CHECK (tipo IN ('TIEMPO_INDEFINIDO','TIEMPO_DEFINIDO','TEMPORAL','PRACTICANTE'))   DEFAULT 'TIEMPO_INDEFINIDO',
    fecha_inicio    DATE            NOT NULL,
    fecha_fin       DATE,
    salario_base_gtq NUMBER(10,2)  NOT NULL,
    bonificaciones_gtq NUMBER(10,2) DEFAULT 0,
    jornada         VARCHAR2(30)     DEFAULT 'COMPLETA',
    horas_semana    NUMBER(4,1)    DEFAULT 40,
    moneda          CHAR(3)         DEFAULT 'GTQ',
    notas           CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_licencias_pil (
    id_licencia     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    tipo            VARCHAR2(30)     NOT NULL,
    numero          VARCHAR2(40)     NOT NULL UNIQUE,
    organismo_emisor VARCHAR2(80),
    pais_emisor     NUMBER(10)             REFERENCES geog_paises(id_pais),
    fecha_emision   DATE            NOT NULL,
    fecha_vencimiento DATE          NOT NULL,
    habilitaciones  CLOB[],
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_cert_medicas (
    id_cert_med     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    tipo            VARCHAR2(50)     NOT NULL,
    medico          VARCHAR2(100),
    centro_medico   VARCHAR2(100),
    fecha_examen    DATE            NOT NULL,
    fecha_vencimiento DATE,
    apto            CHAR(1)         DEFAULT 'S' NOT NULL,
    restricciones   CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_hist_salarial (
    id_hist_sal     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    salario_anterior_gtq NUMBER(10,2),
    salario_nuevo_gtq NUMBER(10,2) NOT NULL,
    motivo          VARCHAR2(100),
    efectivo_desde  DATE            NOT NULL,
    aprobado_por    VARCHAR2(100),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_turnos (
    id_turno        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(60)     NOT NULL UNIQUE,
    tipo            VARCHAR2(10) CHECK (tipo IN ('MANANA','TARDE','NOCHE','ROTATIVO'))      DEFAULT 'MANANA',
    hora_entrada    TIME            NOT NULL,
    hora_salida     TIME            NOT NULL,
    dias_semana     VARCHAR2(200)           DEFAULT '{1,2,3,4,5}',
    horas_diarias   NUMBER(4,1),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Empleados ↔ Turnos
CREATE TABLE rrhh_asign_turnos (
    id_asignacion   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    id_turno        NUMBER(10)             NOT NULL REFERENCES rrhh_turnos(id_turno),
    fecha_desde     DATE            NOT NULL,
    fecha_hasta     DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_empleado, id_turno, fecha_desde)
);

CREATE TABLE rrhh_asistencia (
    id_asistencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    fecha           DATE            NOT NULL,
    hora_entrada    TIMESTAMP WITH TIME ZONE,
    hora_salida     TIMESTAMP WITH TIME ZONE,
    tipo            VARCHAR2(20)     DEFAULT 'NORMAL',
    estado          VARCHAR2(20)     DEFAULT 'PRESENTE',
    observaciones   VARCHAR2(200),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_empleado, fecha)
);

-- [rrhh_tripulacion reubicado más abajo por orden de FK]

CREATE TABLE rrhh_sist_usuarios (
    id_usuario      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL UNIQUE REFERENCES rrhh_empleados(id_empleado),
    username        VARCHAR2(50)     NOT NULL UNIQUE,
    password_hash   VARCHAR2(255)    NOT NULL,
    email           VARCHAR2(100)    NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    ultimo_login    TIMESTAMP WITH TIME ZONE,
    intentos_fallidos NUMBER(10)           DEFAULT 0,
    bloqueado       CHAR(1)         DEFAULT 'N' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_sist_roles (
    id_rol          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(60)     NOT NULL UNIQUE,
    descripcion     CLOB,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_sist_permisos (
    id_permiso      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    modulo          VARCHAR2(40)     NOT NULL,
    accion          VARCHAR2(30)     NOT NULL,
    descripcion     VARCHAR2(150),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (modulo, accion)
);

-- M:N Usuarios ↔ Roles
CREATE TABLE rrhh_roles_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_usuario      NUMBER(10)             NOT NULL REFERENCES rrhh_sist_usuarios(id_usuario),
    id_rol          NUMBER(10)             NOT NULL REFERENCES rrhh_sist_roles(id_rol),
    asignado_por    NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    asignado_en     TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    UNIQUE (id_usuario, id_rol)
);

-- M:N Roles ↔ Permisos
CREATE TABLE rrhh_permisos_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_rol          NUMBER(10)             NOT NULL REFERENCES rrhh_sist_roles(id_rol),
    id_permiso      NUMBER(10)             NOT NULL REFERENCES rrhh_sist_permisos(id_permiso),
    UNIQUE (id_rol, id_permiso)
);

CREATE TABLE rrhh_log_auditoria (
    id_log          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_usuario      NUMBER(10)             NOT NULL REFERENCES rrhh_sist_usuarios(id_usuario),
    accion          VARCHAR2(60)     NOT NULL,
    modulo          VARCHAR2(40),
    entidad         VARCHAR2(60),
    id_entidad      NUMBER(10),                          -- ID polimórfico (sin FK, referencia dinámica por módulo)
    descripcion     CLOB,
    ip_address      VARCHAR2(45),
    user_agent      VARCHAR2(255),
    exitoso         CHAR(1)         DEFAULT 'S' NOT NULL,
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_hist_capacit (
    id_capacit      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    nombre_curso    VARCHAR2(150)    NOT NULL,
    tipo            VARCHAR2(60),
    proveedor       VARCHAR2(100),
    fecha_inicio    DATE,
    fecha_fin       DATE,
    horas           NUMBER(6,1),
    calificacion    NUMBER(4,2),
    aprobado        CHAR(1)         DEFAULT 'S' NOT NULL,
    certificado_url VARCHAR2(255),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_fotos (
    id_foto         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL UNIQUE REFERENCES rrhh_empleados(id_empleado),
    url_foto        VARCHAR2(255),
    url_biometrico  VARCHAR2(255),
    fecha_captura   DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_exped_disc (
    id_expediente   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    tipo_falta      VARCHAR2(60)     NOT NULL,
    descripcion     CLOB            NOT NULL,
    sancion         VARCHAR2(60),
    fecha_falta     DATE            NOT NULL,
    fecha_sancion   DATE,
    aprobado_por    VARCHAR2(100),
    estado          VARCHAR2(30)     DEFAULT 'ABIERTO',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_viaticos (
    id_viatico      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    destino         VARCHAR2(100)    NOT NULL,
    fecha_salida    DATE            NOT NULL,
    fecha_retorno   DATE,
    monto_aprobado_gtq NUMBER(10,2) NOT NULL,
    monto_gastado_gtq NUMBER(10,2),
    estado          VARCHAR2(30)     DEFAULT 'PENDIENTE',
    aprobado_por    NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    comprobantes    CLOB[],
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE rrhh_equipo_prot (
    id_epp          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    tipo_equipo     VARCHAR2(80)     NOT NULL,
    descripcion     VARCHAR2(150),
    cantidad        NUMBER(10)             DEFAULT 1,
    fecha_entrega   DATE            DEFAULT CURRENT_DATE,
    fecha_devolucion DATE,
    estado          VARCHAR2(30)     DEFAULT 'ACTIVO',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ██████████████████████████████████████████████████████████
-- MÓDULO 4: OPERACIONES & VUELOS
-- ██████████████████████████████████████████████████████████

CREATE TABLE oper_programas_vuelo (
    id_programa     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    numero_vuelo    VARCHAR2(10)     NOT NULL,
    id_origen       NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    id_destino      NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    tipo            VARCHAR2(20)     DEFAULT 'COMERCIAL',
    temporada       VARCHAR2(30),
    fecha_vigencia_desde DATE       NOT NULL,
    fecha_vigencia_hasta DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_aerolinea, numero_vuelo, temporada)
);

CREATE TABLE oper_frecuencias (
    id_frecuencia   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_programa     NUMBER(10)             NOT NULL REFERENCES oper_programas_vuelo(id_programa),
    dias_operacion  VARCHAR2(200)           DEFAULT '{1,2,3,4,5,6,7}',
    hora_salida_local TIME          NOT NULL,
    hora_llegada_local TIME         NOT NULL,
    duracion_min    NUMBER(10),
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_vuelos_instancia (
    id_instancia    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_programa     NUMBER(10)             NOT NULL REFERENCES oper_programas_vuelo(id_programa),
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    id_aeropuerto_origen  NUMBER(10)       NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    id_aeropuerto_destino NUMBER(10)       NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    fecha_vuelo     DATE            NOT NULL,
    std             TIMESTAMP WITH TIME ZONE     NOT NULL,
    sta             TIMESTAMP WITH TIME ZONE     NOT NULL,
    atd             TIMESTAMP WITH TIME ZONE,
    ata             TIMESTAMP WITH TIME ZONE,
    estado          VARCHAR2(20) CHECK (estado IN ('PROGRAMADO','EN_PROCESO','DESPEGADO','ATERRIZADO','CANCELADO','DEMORADO','DESVIADO'))    DEFAULT 'PROGRAMADO',
    pax_total       NUMBER(10)             DEFAULT 0,
    carga_kg        NUMBER(10,2)   DEFAULT 0,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_programa, id_avion, fecha_vuelo, std)
);

CREATE TABLE rrhh_tripulacion (
    id_trip_vuelo   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    id_instancia    NUMBER(10)             REFERENCES oper_vuelos_instancia(id_instancia),
    rol             VARCHAR2(40)     NOT NULL,
    es_comandante   CHAR(1)         DEFAULT 'N' NOT NULL,
    horas_vuelo_trip NUMBER(6,1),
    confirmado      CHAR(1)         DEFAULT 'N' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE flota_consumo_comb (
    id_consumo      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    id_instancia_vuelo NUMBER(10)             REFERENCES oper_vuelos_instancia(id_instancia),
    fase_vuelo      VARCHAR2(30)     NOT NULL,
    combustible_kg  NUMBER(10,2)   NOT NULL,
    duracion_min    NUMBER(10),
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_tiempos_slot (
    id_slot         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    slot_salida     TIMESTAMP WITH TIME ZONE,
    slot_llegada    TIMESTAMP WITH TIME ZONE,
    coordinado_con  VARCHAR2(60),
    estado          VARCHAR2(30)     DEFAULT 'ASIGNADO',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_cat_estados (
    id_estado_cat   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    codigo          VARCHAR2(10)     NOT NULL UNIQUE,
    nombre          VARCHAR2(60)     NOT NULL,
    descripcion     CLOB,
    es_final        CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N'))
);

CREATE TABLE oper_bitacora_vuelo (
    id_bitacora     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_estado_cat   NUMBER(10)             NOT NULL REFERENCES oper_cat_estados(id_estado_cat),
    descripcion     CLOB,
    registrado_por  NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_cancelaciones (
    id_cancel       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    motivo          VARCHAR2(100)    NOT NULL,
    descripcion     CLOB,
    tipo_causa      VARCHAR2(30)     DEFAULT 'OPERACIONAL',
    pax_afectados   NUMBER(10)             DEFAULT 0,
    costo_estimado_usd NUMBER(12,2),
    autorizado_por  NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    cancelado_en    TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_demoras_cat (
    id_demora_cat   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    codigo_iata     VARCHAR2(5)      NOT NULL UNIQUE,
    descripcion     VARCHAR2(150)    NOT NULL,
    responsable     VARCHAR2(60),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N'))
);

-- M:N Instancias ↔ Categorías de demora
CREATE TABLE oper_demoras_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_demora_cat   NUMBER(10)             NOT NULL REFERENCES oper_demoras_cat(id_demora_cat),
    minutos_demora  NUMBER(10)             NOT NULL,
    descripcion     CLOB,
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_instancia, id_demora_cat)
);

CREATE TABLE oper_escalas_prog (
    id_escala_p     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_programa     NUMBER(10)             NOT NULL REFERENCES oper_programas_vuelo(id_programa),
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    orden           NUMBER(10)             NOT NULL,
    duracion_min    NUMBER(10),
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_escalas_reales (
    id_escala_r     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    orden           NUMBER(10)             NOT NULL,
    llegada_real    TIMESTAMP WITH TIME ZONE,
    salida_real     TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_planes_vuelo (
    id_plan_vuelo   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    nivel_vuelo     VARCHAR2(10),
    ruta_aerea      CLOB,
    tiempo_vuelo_estimado NUMBER(10),
    combustible_total_kg NUMBER(10,2),
    combustible_ruta_kg NUMBER(10,2),
    combustible_reserva_kg NUMBER(10,2),
    altitud_crucero_ft NUMBER(10),
    velocidad_tas_kt NUMBER(10),
    aprobado_por    VARCHAR2(60),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_log_despegue (
    id_despegue     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    id_pista        NUMBER(10)             NOT NULL REFERENCES aero_pistas(id_pista),
    hora_despegue   TIMESTAMP WITH TIME ZONE     NOT NULL,
    viento_dir_grados NUMBER(10),
    viento_kt       NUMBER(10),
    temperatura_c   NUMBER(4,1),
    qnh_hpa         NUMBER(6,2),
    peso_despegue_kg NUMBER(10,2),
    distancia_rodaje_m NUMBER(10),
    comandante      NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_log_aterrizaje (
    id_aterrizaje   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    id_pista        NUMBER(10)             NOT NULL REFERENCES aero_pistas(id_pista),
    hora_aterrizaje TIMESTAMP WITH TIME ZONE     NOT NULL,
    viento_dir_grados NUMBER(10),
    viento_kt       NUMBER(10),
    temperatura_c   NUMBER(4,1),
    qnh_hpa         NUMBER(6,2),
    peso_aterrizaje_kg NUMBER(10,2),
    distancia_frenado_m NUMBER(10),
    comandante      NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_notams (
    id_notam        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    numero          VARCHAR2(30)     NOT NULL,
    tipo            VARCHAR2(20),
    descripcion     CLOB            NOT NULL,
    inicio_vigencia TIMESTAMP WITH TIME ZONE     NOT NULL,
    fin_vigencia    TIMESTAMP WITH TIME ZONE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_metar_hist (
    id_metar        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    observado_en    TIMESTAMP WITH TIME ZONE     NOT NULL,
    temperatura_c   NUMBER(4,1),
    punto_rocio_c   NUMBER(4,1),
    viento_dir_grados NUMBER(10),
    viento_kt       NUMBER(10),
    rafagas_kt      NUMBER(10),
    visibilidad_m   NUMBER(10),
    techo_ft        NUMBER(10),
    qnh_hpa         NUMBER(6,2),
    metar_raw       CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_solicitud_gate (
    id_sol_gate     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_gate         NUMBER(10)             NOT NULL REFERENCES aero_puertas_gates(id_gate),
    hora_inicio     TIMESTAMP WITH TIME ZONE     NOT NULL,
    hora_fin        TIMESTAMP WITH TIME ZONE,
    estado          VARCHAR2(30)     DEFAULT 'PENDIENTE',
    aprobado_por    NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_pushback_log (
    id_pushback     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    hora_inicio     TIMESTAMP WITH TIME ZONE,
    hora_fin        TIMESTAMP WITH TIME ZONE,
    tractorista     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    autorizado_por  VARCHAR2(60),
    incidencias     CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_manejo_rampa (
    id_rampa        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    tipo_servicio   VARCHAR2(40)     NOT NULL,
    responsable     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    hora_inicio     TIMESTAMP WITH TIME ZONE,
    hora_fin        TIMESTAMP WITH TIME ZONE,
    estado          VARCHAR2(30)     DEFAULT 'PENDIENTE',
    observaciones   CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_combustible_carg (
    id_fuel_log     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    tipo_combustible VARCHAR2(20)    DEFAULT 'JET_A1',
    cantidad_kg     NUMBER(10,2)   NOT NULL,
    cantidad_litros NUMBER(10,2),
    densidad        NUMBER(6,4),
    proveedor       VARCHAR2(80),
    hora_inicio     TIMESTAMP WITH TIME ZONE,
    hora_fin        TIMESTAMP WITH TIME ZONE,
    operario        NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_control_peso (
    id_peso_manif   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    peso_pax_kg     NUMBER(10,2),
    peso_equipaje_kg NUMBER(10,2),
    peso_carga_kg   NUMBER(10,2),
    peso_correo_kg  NUMBER(10,2),
    peso_combustible_kg NUMBER(10,2),
    peso_total_kg   NUMBER(10,2),
    cg_porcentaje   NUMBER(5,2),
    aprobado        CHAR(1)         DEFAULT 'N' NOT NULL,
    aprobado_por    NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_catering_pedido (
    id_catering     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    proveedor       VARCHAR2(80),
    comidas_primera NUMBER(10)             DEFAULT 0,
    comidas_ejecutivo NUMBER(10)           DEFAULT 0,
    comidas_economica NUMBER(10)           DEFAULT 0,
    dietas_especiales CLOB,
    bebidas_alcoholicas CHAR(1)     DEFAULT 'S' NOT NULL,
    costo_total_usd NUMBER(10,2),
    estado          VARCHAR2(30)     DEFAULT 'PENDIENTE',
    hora_entrega    TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_limpieza_log (
    id_limpieza     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    tipo            VARCHAR2(30)     DEFAULT 'TRANSITO',
    empresa         VARCHAR2(80),
    responsable     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    hora_inicio     TIMESTAMP WITH TIME ZONE,
    hora_fin        TIMESTAMP WITH TIME ZONE,
    calificacion    NUMBER(10)             CHECK (calificacion BETWEEN 1 AND 5),
    observaciones   CLOB,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_reporte_capitan (
    id_rep_cap      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    id_comandante   NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    resumen_vuelo   CLOB,
    incidencias_tecnicas CLOB,
    incidencias_pax CLOB,
    condiciones_clima CLOB,
    combustible_restante_kg NUMBER(10,2),
    horas_vuelo_real NUMBER(6,2),
    firma_digital   VARCHAR2(255),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_estadisticas_d (
    id_stats        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             REFERENCES aero_aeropuertos(id_aeropuerto),
    id_aerolinea    NUMBER(10)             REFERENCES linea_aerolineas(id_aerolinea),
    fecha           DATE            NOT NULL,
    total_vuelos    NUMBER(10)             DEFAULT 0,
    vuelos_puntuales NUMBER(10)            DEFAULT 0,
    vuelos_demorados NUMBER(10)            DEFAULT 0,
    vuelos_cancelados NUMBER(10)           DEFAULT 0,
    pax_total       NUMBER(10)             DEFAULT 0,
    carga_total_kg  NUMBER(12,2)   DEFAULT 0,
    otp_porcentaje  NUMBER(5,2),
    generado_en     TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE oper_reprograma (
    id_repro        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    std_original    TIMESTAMP WITH TIME ZONE     NOT NULL,
    std_nueva       TIMESTAMP WITH TIME ZONE     NOT NULL,
    sta_original    TIMESTAMP WITH TIME ZONE,
    sta_nueva       TIMESTAMP WITH TIME ZONE,
    motivo          CLOB,
    autorizado_por  NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    reprogramado_en TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ██████████████████████████████████████████████████████████
-- MÓDULO 5: PASAJEROS & EQUIPAJE
-- ██████████████████████████████████████████████████████████

CREATE TABLE pax_maestro (
    id_pax          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombres         VARCHAR2(80)     NOT NULL,
    apellidos       VARCHAR2(80)     NOT NULL,
    tipo_doc_principal VARCHAR2(30) CHECK (tipo_doc_principal IN ('DPI','PASAPORTE','LICENCIA_CONDUCIR','PERMISO_TRABAJO','OTRO')) DEFAULT 'PASAPORTE',
    numero_doc_principal VARCHAR2(30) NOT NULL,
    pais_doc        NUMBER(10)             REFERENCES geog_paises(id_pais),
    fecha_nacimiento DATE,
    genero          CHAR(1),
    nacionalidad    NUMBER(10)             REFERENCES geog_paises(id_pais),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (tipo_doc_principal, numero_doc_principal)
);

CREATE TABLE pax_documentos (
    id_doc          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    tipo            VARCHAR2(30) CHECK (tipo IN ('DPI','PASAPORTE','LICENCIA_CONDUCIR','PERMISO_TRABAJO','OTRO'))  NOT NULL,
    numero          VARCHAR2(30)     NOT NULL,
    pais_emisor     NUMBER(10)             REFERENCES geog_paises(id_pais),
    fecha_emision   DATE,
    fecha_vencimiento DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (tipo, numero)
);

CREATE TABLE pax_telefonos (
    id_tel          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    tipo            VARCHAR2(20)     DEFAULT 'MOVIL',
    codigo_pais     VARCHAR2(5)      DEFAULT '+502',
    numero          VARCHAR2(20)     NOT NULL,
    es_principal    CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE pax_emails (
    id_email        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    email           VARCHAR2(100)    NOT NULL,
    es_principal    CHAR(1)         DEFAULT 'N' NOT NULL,
    verificado      CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE pax_cliente_frec (
    id_milla        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    numero_membresia VARCHAR2(20)    NOT NULL UNIQUE,
    nivel           VARCHAR2(20)     DEFAULT 'BASICO',
    millas_acumuladas NUMBER(19)        DEFAULT 0,
    millas_disponibles NUMBER(19)       DEFAULT 0,
    fecha_inscripcion DATE          DEFAULT CURRENT_DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_pax, id_aerolinea)
);

CREATE TABLE pax_asistencias (
    id_asist        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    tipo            VARCHAR2(40)     NOT NULL,
    descripcion     VARCHAR2(200),
    requiere_silla  CHAR(1)         DEFAULT 'N' NOT NULL,
    requiere_oxigeno CHAR(1)        DEFAULT 'N' NOT NULL,
    notas_operativas CLOB,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE pax_menores_solos (
    id_menor        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL UNIQUE REFERENCES pax_maestro(id_pax),
    id_empleado_responsable NUMBER(10)     REFERENCES rrhh_empleados(id_empleado),
    nombre_tutor_origen VARCHAR2(100),
    tel_tutor_origen VARCHAR2(20),
    nombre_tutor_destino VARCHAR2(100),
    tel_tutor_destino VARCHAR2(20),
    instrucciones   CLOB,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE fin_metodos_pago (
    id_metodo       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(60)     NOT NULL UNIQUE,
    tipo            VARCHAR2(30)     DEFAULT 'TRANSFERENCIA',
    procesador      VARCHAR2(60),
    comision_porcentaje NUMBER(5,4) DEFAULT 0,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE reserva_encabezado (
    id_reserva_pnr  NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    pnr             VARCHAR2(10)     NOT NULL UNIQUE,
    canal_venta     VARCHAR2(30)     DEFAULT 'WEB',
    id_agencia      NUMBER(10),                          -- FK futura: tabla agencias_viaje (pendiente de módulo)
    estado          VARCHAR2(20) CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA'))     DEFAULT 'PENDIENTE',
    moneda          CHAR(3)         DEFAULT 'GTQ',
    total_tarifa    NUMBER(12,2)   DEFAULT 0,
    total_impuestos NUMBER(12,2)   DEFAULT 0,
    total_cargos    NUMBER(12,2)   DEFAULT 0,
    total_pagar     NUMBER(12,2)   DEFAULT 0,
    fecha_limite_pago TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Pasajeros ↔ Reservas
CREATE TABLE reserva_pax_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_reserva_pnr  NUMBER(10)             NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    es_titular      CHAR(1)         DEFAULT 'N' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_reserva_pnr, id_pax)
);

CREATE TABLE reserva_detalle (
    id_segmento     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_reserva_pnr  NUMBER(10)             NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    clase_reserva   VARCHAR2(5)      NOT NULL,
    clase_cabina    VARCHAR2(20) CHECK (clase_cabina IN ('PRIMERA_CLASE','EJECUTIVO','ECONOMICA_PREMIUM','ECONOMICA'))    DEFAULT 'ECONOMICA',
    tarifa_base_gtq NUMBER(10,2)   NOT NULL,
    estado          VARCHAR2(20)     DEFAULT 'CONFIRMADO',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_instancia, id_pax)
);

CREATE TABLE reserva_estado (
    id_pago_hist    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_reserva_pnr  NUMBER(10)             NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_metodo_pago  NUMBER(10)             REFERENCES fin_metodos_pago(id_metodo),
    monto_gtq       NUMBER(12,2)   NOT NULL,
    estado          VARCHAR2(20) CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA'))     NOT NULL,
    referencia_pago VARCHAR2(60),
    procesador      VARCHAR2(40),
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE boleto_electronico (
    id_etkt         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_reserva_pnr  NUMBER(10)             NOT NULL REFERENCES reserva_encabezado(id_reserva_pnr),
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    id_segmento     NUMBER(10)             NOT NULL UNIQUE REFERENCES reserva_detalle(id_segmento),
    numero_boleto   VARCHAR2(20)     NOT NULL UNIQUE,
    estado          VARCHAR2(20)     DEFAULT 'VALIDO',
    clase_reserva   VARCHAR2(5),
    tarifa_base_gtq NUMBER(10,2),
    total_gtq       NUMBER(12,2),
    emitido_en      TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    valido_hasta    DATE
);

CREATE TABLE boleto_impuestos (
    id_tax_item     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    codigo          VARCHAR2(10)     NOT NULL UNIQUE,
    descripcion     VARCHAR2(100)    NOT NULL,
    tipo            VARCHAR2(30)     DEFAULT 'AEROPORTUARIO',
    id_pais         NUMBER(10)             REFERENCES geog_paises(id_pais),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Boletos ↔ Impuestos
CREATE TABLE boleto_impuestos_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_etkt         NUMBER(10)             NOT NULL REFERENCES boleto_electronico(id_etkt),
    id_tax_item     NUMBER(10)             NOT NULL REFERENCES boleto_impuestos(id_tax_item),
    monto_gtq       NUMBER(10,2)   NOT NULL,
    UNIQUE (id_etkt, id_tax_item)
);

CREATE TABLE checkin_registro (
    id_checkin      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_etkt         NUMBER(10)             NOT NULL UNIQUE REFERENCES boleto_electronico(id_etkt),
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    canal           VARCHAR2(20)     DEFAULT 'MOSTRADOR',
    id_counter      NUMBER(10)             REFERENCES aero_mostradores(id_counter),
    id_empleado     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    estado          VARCHAR2(20)     DEFAULT 'COMPLETADO',
    realizado_en    TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE checkin_boarding_pass (
    id_pass         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_checkin      NUMBER(10)             NOT NULL UNIQUE REFERENCES checkin_registro(id_checkin),
    codigo_barras   VARCHAR2(60)     NOT NULL UNIQUE,
    qr_data         CLOB,
    numero_asiento  VARCHAR2(5),
    grupo_embarque  VARCHAR2(5),
    emitido_en      TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE asientos_asignados (
    id_asiento_pax  NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_checkin      NUMBER(10)             NOT NULL UNIQUE REFERENCES checkin_registro(id_checkin),
    id_avion        NUMBER(10)             NOT NULL REFERENCES flota_aviones(id_avion),
    fila            NUMBER(10)             NOT NULL,
    letra           CHAR(1)         NOT NULL,
    numero_asiento  VARCHAR2(5)      GENERATED ALWAYS AS (fila::text || letra) STORED,
    clase           VARCHAR2(20) CHECK (clase IN ('PRIMERA_CLASE','EJECUTIVO','ECONOMICA_PREMIUM','ECONOMICA'))    DEFAULT 'ECONOMICA',
    es_ventana      CHAR(1) DEFAULT 'S' CHECK (es_ventana IN ('S','N')),
    es_pasillo      CHAR(1) DEFAULT 'N' CHECK (es_pasillo IN ('S','N')),
    asignado_en     TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_avion, id_checkin, fila, letra)
);

CREATE TABLE manifiesto_pax (
    id_manif        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL UNIQUE REFERENCES oper_vuelos_instancia(id_instancia),
    total_pax       NUMBER(10)             DEFAULT 0,
    adultos         NUMBER(10)             DEFAULT 0,
    menores         NUMBER(10)             DEFAULT 0,
    infantes        NUMBER(10)             DEFAULT 0,
    pax_especiales  NUMBER(10)             DEFAULT 0,
    cerrado         CHAR(1)         DEFAULT 'N' NOT NULL,
    cerrado_por     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    cerrado_en      TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_equipaje (
    id_bag          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    id_etkt         NUMBER(10)             NOT NULL REFERENCES boleto_electronico(id_etkt),
    tipo            VARCHAR2(20)     DEFAULT 'BODEGA',
    peso_kg         NUMBER(6,2)    NOT NULL,
    descripcion     VARCHAR2(100),
    estado          VARCHAR2(20) CHECK (estado IN ('REGISTRADO','EN_BODEGA','EN_VUELO','ENTREGADO','PERDIDO','DANIADO','RECLAMADO')) DEFAULT 'REGISTRADO',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_tags (
    id_tag          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_bag          NUMBER(10)             NOT NULL UNIQUE REFERENCES bag_equipaje(id_bag),
    numero_tag      VARCHAR2(20)     NOT NULL UNIQUE,
    codigo_barras   VARCHAR2(60),
    emitido_en      TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_trazabilidad (
    id_track        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_tag          NUMBER(10)             NOT NULL REFERENCES bag_tags(id_tag),
    ubicacion       VARCHAR2(80)     NOT NULL,
    estado          VARCHAR2(20) CHECK (estado IN ('REGISTRADO','EN_BODEGA','EN_VUELO','ENTREGADO','PERDIDO','DANIADO','RECLAMADO')) NOT NULL,
    id_empleado     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_peso_adicional (
    id_excess       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_bag          NUMBER(10)             NOT NULL REFERENCES bag_equipaje(id_bag),
    kg_adicionales  NUMBER(5,2)    NOT NULL,
    tarifa_kg_gtq   NUMBER(8,2)    NOT NULL,
    total_gtq       NUMBER(10,2)   NOT NULL,
    VARCHAR2(30)     VARCHAR2(20) CHECK (VARCHAR2(30) IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA'))     DEFAULT 'PENDIENTE',
    pagado_en       TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_contenedores_uld (
    id_uld          NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_instancia    NUMBER(10)             NOT NULL REFERENCES oper_vuelos_instancia(id_instancia),
    numero_uld      VARCHAR2(20)     NOT NULL,
    tipo            VARCHAR2(20)     NOT NULL,
    posicion_bodega VARCHAR2(10),
    peso_tara_kg    NUMBER(8,2),
    peso_carga_kg   NUMBER(8,2),
    sellado         CHAR(1)         DEFAULT 'N' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_reclamos (
    id_reclamo      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_bag          NUMBER(10)             NOT NULL REFERENCES bag_equipaje(id_bag),
    tipo_reclamo    VARCHAR2(30)     DEFAULT 'PERDIDA',
    descripcion     CLOB,
    estado          VARCHAR2(30)     DEFAULT 'ABIERTO',
    id_pax          NUMBER(10)             NOT NULL REFERENCES pax_maestro(id_pax),
    fecha_reclamo   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    fecha_resolucion TIMESTAMP WITH TIME ZONE,
    agente          NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_indemnizaciones (
    id_pago_indem   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_reclamo      NUMBER(10)             NOT NULL UNIQUE REFERENCES bag_reclamos(id_reclamo),
    monto_gtq       NUMBER(12,2)   NOT NULL,
    moneda          CHAR(3)         DEFAULT 'GTQ',
    metodo_pago     VARCHAR2(40),
    referencia      VARCHAR2(60),
    aprobado_por    NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    pagado_en       TIMESTAMP WITH TIME ZONE,
    estado          VARCHAR2(20) CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA'))     DEFAULT 'PENDIENTE',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_objetos_prohib (
    id_hallazgo     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_bag          NUMBER(10)             NOT NULL REFERENCES bag_equipaje(id_bag),
    descripcion     CLOB            NOT NULL,
    tipo_objeto     VARCHAR2(60)     NOT NULL,
    accion_tomada   VARCHAR2(60),
    id_empleado     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    id_punto_control NUMBER(10)            REFERENCES aero_puntos_control(id_control),
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE bag_hist_reclamos (
    id_hist_legal   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_reclamo      NUMBER(10)             NOT NULL REFERENCES bag_reclamos(id_reclamo),
    estado_anterior VARCHAR2(30),
    estado_nuevo    VARCHAR2(30)     NOT NULL,
    nota            CLOB,
    actualizado_por NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- ██████████████████████████████████████████████████████████
-- MÓDULO 6: SEGURIDAD & FINANZAS
-- ██████████████████████████████████████████████████████████

CREATE TABLE seg_incidentes (
    id_incidente    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    tipo            VARCHAR2(20) CHECK (tipo IN ('PELEA','AMENAZA','ROBO','ACTO_INDEBIDO','CONTRABANDO','OTRO'))  DEFAULT 'OTRO',
    descripcion     CLOB            NOT NULL,
    zona            VARCHAR2(80),
    severidad       VARCHAR2(20)     DEFAULT 'MEDIA',
    estado          VARCHAR2(30)     DEFAULT 'ABIERTO',
    fecha_ocurrencia TIMESTAMP WITH TIME ZONE    DEFAULT SYSTIMESTAMP NOT NULL,
    fecha_cierre    TIMESTAMP WITH TIME ZONE,
    autoridades_notificadas CHAR(1) DEFAULT 'N' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_arrestos (
    id_arresto      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_incidente    NUMBER(10)             NOT NULL REFERENCES seg_incidentes(id_incidente),
    id_pax          NUMBER(10)             REFERENCES pax_maestro(id_pax),
    nombre_detenido VARCHAR2(150),
    motivo          VARCHAR2(200)    NOT NULL,
    hora_detencion  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    hora_liberacion TIMESTAMP WITH TIME ZONE,
    autoridad_entrega VARCHAR2(100),
    numero_acta     VARCHAR2(60),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_motivos_arresto (
    id_motivo       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    descripcion     VARCHAR2(150)    NOT NULL UNIQUE,
    codigo_legal    VARCHAR2(30),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N'))
);

CREATE TABLE seg_entidades_pol (
    id_entidad      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(100)    NOT NULL,
    tipo            VARCHAR2(40)     DEFAULT 'POLICIA',
    jurisdiccion    VARCHAR2(80),
    telefono        VARCHAR2(30),
    email           VARCHAR2(80),
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_pruebas_video (
    id_video        NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             REFERENCES aero_aeropuertos(id_aeropuerto),
    camara          VARCHAR2(30),
    url_archivo     VARCHAR2(255),
    duracion_seg    NUMBER(10),
    fecha_inicio    TIMESTAMP WITH TIME ZONE,
    fecha_fin       TIMESTAMP WITH TIME ZONE,
    retenido        CHAR(1)         DEFAULT 'N' NOT NULL,
    retenido_hasta  DATE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Incidentes ↔ Videos
CREATE TABLE seg_video_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_incidente    NUMBER(10)             NOT NULL REFERENCES seg_incidentes(id_incidente),
    id_video        NUMBER(10)             NOT NULL REFERENCES seg_pruebas_video(id_video),
    relevancia      VARCHAR2(20)     DEFAULT 'PRINCIPAL',
    UNIQUE (id_incidente, id_video)
);

CREATE TABLE seg_objetos_perdidos (
    id_objeto       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    descripcion     CLOB            NOT NULL,
    tipo            VARCHAR2(60),
    zona_hallazgo   VARCHAR2(80),
    id_gate         NUMBER(10)             REFERENCES aero_puertas_gates(id_gate),
    fecha_hallazgo  DATE            DEFAULT CURRENT_DATE,
    entregado       CHAR(1)         DEFAULT 'N' NOT NULL,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_entrega_obj (
    id_entrega      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_objeto       NUMBER(10)             NOT NULL UNIQUE REFERENCES seg_objetos_perdidos(id_objeto),
    id_pax          NUMBER(10)             REFERENCES pax_maestro(id_pax),
    nombre_receptor VARCHAR2(150),
    doc_receptor    VARCHAR2(30),
    agente          NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    fecha_entrega   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    acta_entrega    VARCHAR2(60)
);

CREATE TABLE seg_lista_negra (
    id_black_list   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_pax          NUMBER(10)             NOT NULL UNIQUE REFERENCES pax_maestro(id_pax),
    motivo          CLOB            NOT NULL,
    nivel_riesgo    VARCHAR2(20)     DEFAULT 'MEDIO',
    autoridad_origen VARCHAR2(80),
    fecha_inclusion DATE            DEFAULT CURRENT_DATE,
    fecha_exclusion DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE seg_acceso_areas (
    id_acceso_log   NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    zona            VARCHAR2(60)     NOT NULL,
    tipo_acceso     VARCHAR2(20)     DEFAULT 'ENTRADA',
    metodo          VARCHAR2(30)     DEFAULT 'BIOMETRICO',
    permitido       CHAR(1)         DEFAULT 'S' NOT NULL,
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- FINANZAS
CREATE TABLE fin_facturacion_linea (
    id_factura      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_aerolinea    NUMBER(10)             NOT NULL REFERENCES linea_aerolineas(id_aerolinea),
    id_instancia    NUMBER(10)             REFERENCES oper_vuelos_instancia(id_instancia),
    numero_factura  VARCHAR2(30)     NOT NULL UNIQUE,
    serie           VARCHAR2(10)     DEFAULT 'A',
    tipo            VARCHAR2(30)     DEFAULT 'TASA_ATERRIZAJE',
    fecha_emision   DATE            DEFAULT CURRENT_DATE,
    fecha_vencimiento DATE,
    subtotal_gtq    NUMBER(14,2)   NOT NULL,
    impuestos_gtq   NUMBER(14,2)   DEFAULT 0,
    total_gtq       NUMBER(14,2)   NOT NULL,
    estado          VARCHAR2(20) CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA'))     DEFAULT 'PENDIENTE',
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    actualizado_en  TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE fin_tarifario_aereo (
    id_tarifa       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(80)     NOT NULL,
    tipo_servicio   VARCHAR2(60)     NOT NULL,
    id_aeropuerto   NUMBER(10)             REFERENCES aero_aeropuertos(id_aeropuerto),
    id_aerolinea    NUMBER(10)             REFERENCES linea_aerolineas(id_aerolinea),
    monto_gtq       NUMBER(12,2)   NOT NULL,
    unidad          VARCHAR2(20)     DEFAULT 'POR_VUELO',
    vigente_desde   DATE            NOT NULL,
    vigente_hasta   DATE,
    activa          CHAR(1)         DEFAULT 'S' NOT NULL,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE fin_impuestos_pais (
    id_impuesto_config NUMBER(10) GENERATED ALWAYS AS IDENTITY       PRIMARY KEY,
    id_pais         NUMBER(10)             NOT NULL REFERENCES geog_paises(id_pais),
    nombre          VARCHAR2(80)     NOT NULL,
    codigo          VARCHAR2(10)     NOT NULL,
    porcentaje      NUMBER(6,4)    NOT NULL,
    aplica_a        VARCHAR2(60),
    vigente_desde   DATE            NOT NULL,
    vigente_hasta   DATE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_pais, codigo, vigente_desde)
);

-- [fin_metodos_pago movido más arriba]

CREATE TABLE fin_caja_diaria (
    id_caja         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_empleado     NUMBER(10)             NOT NULL REFERENCES rrhh_empleados(id_empleado),
    id_aeropuerto   NUMBER(10)             NOT NULL REFERENCES aero_aeropuertos(id_aeropuerto),
    fecha           DATE            DEFAULT CURRENT_DATE,
    monto_apertura_gtq NUMBER(12,2) DEFAULT 0,
    monto_cierre_gtq NUMBER(12,2),
    total_cobros_gtq NUMBER(12,2)  DEFAULT 0,
    total_pagos_gtq NUMBER(12,2)   DEFAULT 0,
    diferencia_gtq  NUMBER(12,2),
    estado          VARCHAR2(20)     DEFAULT 'ABIERTA',
    cerrada_en      TIMESTAMP WITH TIME ZONE,
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    UNIQUE (id_empleado, fecha)
);

CREATE TABLE fin_notas_credito (
    id_nota_cred    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_factura      NUMBER(10)             NOT NULL REFERENCES fin_facturacion_linea(id_factura),
    numero_nota     VARCHAR2(30)     NOT NULL UNIQUE,
    motivo          CLOB            NOT NULL,
    monto_gtq       NUMBER(14,2)   NOT NULL,
    estado          VARCHAR2(20) CHECK (estado IN ('PENDIENTE','PAGADO','REEMBOLSADO','CANCELADO','EN_DISPUTA'))     DEFAULT 'PENDIENTE',
    emitido_por     NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    emitido_en      TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE fin_auditoria_precios (
    id_audit_pre    NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_tarifa       NUMBER(10)             NOT NULL REFERENCES fin_tarifario_aereo(id_tarifa),
    monto_anterior  NUMBER(12,2),
    monto_nuevo     NUMBER(12,2)   NOT NULL,
    motivo          VARCHAR2(150),
    modificado_por  NUMBER(10)             REFERENCES rrhh_empleados(id_empleado),
    modificado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- SISTEMA
CREATE TABLE sys_log_replicacion (
    id_repl_log     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    servidor_origen VARCHAR2(80)     NOT NULL,
    servidor_destino VARCHAR2(80)    NOT NULL,
    tabla           VARCHAR2(80),
    registros_replicados NUMBER(19),
    estado          VARCHAR2(20)     DEFAULT 'EXITOSO',
    inicio          TIMESTAMP WITH TIME ZONE     NOT NULL,
    fin             TIMESTAMP WITH TIME ZONE,
    error_msg       CLOB,
    registrado_en   TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE sys_failover_history (
    id_failover     NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    servidor_primario VARCHAR2(80)   NOT NULL,
    servidor_secundario VARCHAR2(80) NOT NULL,
    tipo            VARCHAR2(30)     DEFAULT 'AUTOMATICO',
    motivo          CLOB,
    inicio          TIMESTAMP WITH TIME ZONE     NOT NULL,
    fin             TIMESTAMP WITH TIME ZONE,
    rto_segundos    NUMBER(10),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE sys_backup_log (
    id_backup       NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    tipo            VARCHAR2(30)     DEFAULT 'COMPLETO',
    servidor        VARCHAR2(80)     NOT NULL,
    destino         VARCHAR2(200),
    tamano_bytes    NUMBER(19),
    estado          VARCHAR2(20)     DEFAULT 'EXITOSO',
    inicio          TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    fin             TIMESTAMP WITH TIME ZONE,
    checksum        VARCHAR2(80),
    error_msg       CLOB
);

CREATE TABLE sys_diccionario (
    id_dict         NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    schema_nombre   VARCHAR2(40)     NOT NULL,
    tabla_nombre    VARCHAR2(80)     NOT NULL,
    columna_nombre  VARCHAR2(80),
    tipo_dato       VARCHAR2(40),
    descripcion     CLOB,
    es_pk           CHAR(1)         DEFAULT 'N' NOT NULL,
    es_fk           CHAR(1)         DEFAULT 'N' NOT NULL,
    tabla_referencia VARCHAR2(80),
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    UNIQUE (schema_nombre, tabla_nombre, columna_nombre)
);

CREATE TABLE reporte_config (
    id_reporte_cfg  NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(100)    NOT NULL,
    tipo            VARCHAR2(15) CHECK (tipo IN ('DIARIO','SEMANAL','MENSUAL','TRIMESTRAL','ANUAL','BAJO_DEMANDA'))    DEFAULT 'DIARIO',
    descripcion     CLOB,
    query_base      CLOB,
    parametros      CLOB,
    formato_salida  VARCHAR2(20)     DEFAULT 'PDF',
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

CREATE TABLE reporte_destinatarios (
    id_destinatario NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    nombre          VARCHAR2(100)    NOT NULL,
    email           VARCHAR2(100)    NOT NULL UNIQUE,
    activo          CHAR(1)         DEFAULT 'S' NOT NULL CHECK (activo IN ('S','N')),
    creado_en       TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL
);

-- M:N Reportes ↔ Destinatarios
CREATE TABLE reporte_dest_union (
    id              NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    id_reporte_cfg  NUMBER(10)             NOT NULL REFERENCES reporte_config(id_reporte_cfg),
    id_destinatario NUMBER(10)             NOT NULL REFERENCES reporte_destinatarios(id_destinatario),
    UNIQUE (id_reporte_cfg, id_destinatario)
);

CREATE TABLE hist_archivado_pax (
    id_hist_pax     NUMBER(19) GENERATED ALWAYS AS IDENTITY       PRIMARY KEY,
    id_pax_original NUMBER(10)             NOT NULL,
    datos_pax       CLOB           NOT NULL,
    datos_reservas  CLOB,
    datos_boletos   CLOB,
    archivado_en    TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    motivo          VARCHAR2(60)     DEFAULT 'PURGA_PERIODICA'
);

CREATE TABLE hist_archivado_ops (
    id_hist_ops     NUMBER(19) GENERATED ALWAYS AS IDENTITY       PRIMARY KEY,
    id_instancia_original NUMBER(10)       NOT NULL,
    datos_vuelo     CLOB           NOT NULL,
    datos_bitacora  CLOB,
    datos_telemetria CLOB,
    archivado_en    TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    motivo          VARCHAR2(60)     DEFAULT 'PURGA_PERIODICA'
);

CREATE TABLE hist_migracion_data (
    id_version      NUMBER(10) GENERATED ALWAYS AS IDENTITY          PRIMARY KEY,
    version         VARCHAR2(20)     NOT NULL UNIQUE,
    descripcion     CLOB,
    script_aplicado CLOB,
    aplicado_por    VARCHAR2(60),
    aplicado_en     TIMESTAMP WITH TIME ZONE     DEFAULT SYSTIMESTAMP NOT NULL,
    exitoso         CHAR(1)         DEFAULT 'S' NOT NULL,
    duracion_seg    NUMBER(10)
);

-- ALTER TABLE: FKs diferidas (tablas creadas en módulos anteriores
-- que referencian módulos posteriores)
ALTER TABLE aero_estado_gate
    ADD CONSTRAINT fk_estado_gate_empleado
    FOREIGN KEY (id_empleado_registro) REFERENCES rrhh_empleados(id_empleado);

ALTER TABLE flota_estado_avion
    ADD CONSTRAINT fk_estado_avion_empleado
    FOREIGN KEY (id_empleado) REFERENCES rrhh_empleados(id_empleado);

-- ÍNDICES ESTRATÉGICOS

-- Geografía
CREATE INDEX idx_paises_continente    ON geog_paises(id_continente);
CREATE INDEX idx_estados_pais         ON geog_estados_dep(id_pais);
CREATE INDEX idx_ciudades_estado      ON geog_ciudades(id_estado);

-- Aeropuertos
CREATE INDEX idx_aeropuerto_ciudad    ON aero_aeropuertos(id_ciudad);
CREATE INDEX idx_aeropuerto_iata      ON aero_aeropuertos(codigo_iata);
CREATE INDEX idx_aeropuerto_icao      ON aero_aeropuertos(codigo_icao);
CREATE INDEX idx_pistas_aeropuerto    ON aero_pistas(id_aeropuerto);
CREATE INDEX idx_gates_seccion        ON aero_puertas_gates(id_seccion);
CREATE INDEX idx_terminales_aeropuerto ON aero_terminales(id_aeropuerto);
CREATE INDEX idx_secciones_terminal   ON aero_secciones_terminal(id_terminal);

-- Aerolíneas & Flota
CREATE INDEX idx_aerolinea_iata       ON linea_aerolineas(codigo_iata);
CREATE INDEX idx_aerolinea_icao       ON linea_aerolineas(codigo_icao);
CREATE INDEX idx_avion_matricula      ON flota_aviones(matricula);
CREATE INDEX idx_avion_aerolinea      ON flota_aviones(id_aerolinea);
CREATE INDEX idx_avion_modelo         ON flota_aviones(id_modelo);
CREATE INDEX idx_avion_estado         ON flota_aviones(estado);
CREATE INDEX idx_telemetria_avion_ts  ON flota_telemetria(id_avion, registrado_en DESC);

-- RRHH
CREATE INDEX idx_empleado_codigo      ON rrhh_empleados(codigo_empleado);
CREATE INDEX idx_empleado_email       ON rrhh_empleados(email_corporativo);
CREATE INDEX idx_empleado_dpi         ON rrhh_empleados(dpi);
CREATE INDEX idx_usuario_username     ON rrhh_sist_usuarios(username);
CREATE INDEX idx_asistencia_emp_fecha ON rrhh_asistencia(id_empleado, fecha DESC);
CREATE INDEX idx_log_usuario_ts       ON rrhh_log_auditoria(id_usuario, registrado_en DESC);

-- Operaciones
CREATE INDEX idx_vuelo_fecha          ON oper_vuelos_instancia(fecha_vuelo);
CREATE INDEX idx_vuelo_estado         ON oper_vuelos_instancia(estado);
CREATE INDEX idx_vuelo_origen         ON oper_vuelos_instancia(id_aeropuerto_origen);
CREATE INDEX idx_vuelo_destino        ON oper_vuelos_instancia(id_aeropuerto_destino);
CREATE INDEX idx_vuelo_avion          ON oper_vuelos_instancia(id_avion);
CREATE INDEX idx_vuelo_programa       ON oper_vuelos_instancia(id_programa);
CREATE INDEX idx_vuelo_std            ON oper_vuelos_instancia(std);
CREATE INDEX idx_bitacora_instancia   ON oper_bitacora_vuelo(id_instancia, registrado_en DESC);
CREATE INDEX idx_metar_aeropuerto_ts  ON oper_metar_hist(id_aeropuerto, observado_en DESC);

-- Pasajeros
CREATE INDEX idx_pax_doc              ON pax_maestro(tipo_doc_principal, numero_doc_principal);
CREATE INDEX idx_pax_apellidos        ON pax_maestro USING gin(to_tsvector('spanish', apellidos || ' ' || nombres));
CREATE INDEX idx_reserva_pnr          ON reserva_encabezado(pnr);
CREATE INDEX idx_reserva_estado       ON reserva_encabezado(estado);
CREATE INDEX idx_boleto_numero        ON boleto_electronico(numero_boleto);
CREATE INDEX idx_bag_tag_numero       ON bag_tags(numero_tag);
CREATE INDEX idx_bag_estado           ON bag_equipaje(estado);
CREATE INDEX idx_checkin_instancia    ON checkin_registro(id_instancia);

-- Seguridad & Finanzas
CREATE INDEX idx_incidente_aeropuerto ON seg_incidentes(id_aeropuerto);
CREATE INDEX idx_incidente_fecha      ON seg_incidentes(fecha_ocurrencia DESC);
CREATE INDEX idx_factura_aerolinea    ON fin_facturacion_linea(id_aerolinea);
CREATE INDEX idx_factura_estado       ON fin_facturacion_linea(estado);
CREATE INDEX idx_factura_numero       ON fin_facturacion_linea(numero_factura);
CREATE INDEX idx_acceso_empleado_ts   ON seg_acceso_areas(id_empleado, registrado_en DESC);

-- VISTAS ÚTILES

CREATE OR REPLACE VIEW v_vuelos_hoy AS
SELECT
    vi.id_instancia,
    la.codigo_iata          AS aerolinea,
    pv.numero_vuelo,
    ao.codigo_iata           AS origen,
    ad.codigo_iata           AS destino,
    vi.std,
    vi.sta,
    vi.atd,
    vi.ata,
    vi.estado,
    fa.matricula             AS avion,
    vi.pax_total
FROM oper_vuelos_instancia vi
JOIN oper_programas_vuelo pv     ON vi.id_programa = pv.id_programa
JOIN linea_aerolineas la         ON pv.id_aerolinea = la.id_aerolinea
JOIN aero_aeropuertos ao         ON vi.id_aeropuerto_origen = ao.id_aeropuerto
JOIN aero_aeropuertos ad         ON vi.id_aeropuerto_destino = ad.id_aeropuerto
JOIN flota_aviones fa            ON vi.id_avion = fa.id_avion
WHERE vi.fecha_vuelo = CURRENT_DATE;

CREATE OR REPLACE VIEW v_equipaje_en_transito AS
SELECT
    bt.numero_tag,
    pm.nombres || ' ' || pm.apellidos AS pasajero,
    be.peso_kg,
    be.estado,
    bt2.registrado_en AS ultimo_escaneo,
    bt2.ubicacion
FROM bag_equipaje be
JOIN bag_tags bt                  ON be.id_bag = bt.id_bag
JOIN pax_maestro pm               ON be.id_pax = pm.id_pax
JOIN LATERAL (
    SELECT ubicacion, registrado_en
    FROM bag_trazabilidad
    WHERE id_tag = bt.id_tag
    ORDER BY registrado_en DESC
    LIMIT 1
) bt2 ON TRUE
WHERE be.estado NOT IN ('ENTREGADO','PERDIDO');

CREATE OR REPLACE VIEW v_otp_por_aerolinea AS
SELECT
    la.nombre                   AS aerolinea,
    DATE_TRUNC('month', vi.fecha_vuelo::timestamptz) AS mes,
    COUNT(*)                    AS total_vuelos,
    COUNT(*) FILTER (WHERE vi.atd <= vi.std + VARCHAR2(30) '15 min') AS puntuales,
    ROUND(
        COUNT(*) FILTER (WHERE vi.atd <= vi.std + VARCHAR2(30) '15 min') * 100.0 / NULLIF(COUNT(*),0),2
    )                           AS otp_porcentaje
FROM oper_vuelos_instancia vi
JOIN oper_programas_vuelo pv     ON vi.id_programa = pv.id_programa
JOIN linea_aerolineas la         ON pv.id_aerolinea = la.id_aerolinea
WHERE vi.estado IN ('ATERRIZADO','DESPEGADO')
  AND vi.atd IS NOT NULL
GROUP BY la.nombre, DATE_TRUNC('month', vi.fecha_vuelo::timestamptz)
ORDER BY mes DESC, otp_porcentaje DESC;

CREATE OR REPLACE VIEW v_aviones_operativos AS
SELECT
    fa.matricula,
    fm.fabricante || ' ' || fm.modelo AS tipo,
    la.nombre AS aerolinea,
    fa.horas_vuelo_total,
    fa.ciclos_total,
    fa.estado,
    aa.codigo_iata AS base,
    (SELECT fecha FROM flota_hist_manten WHERE id_avion = fa.id_avion ORDER BY fecha_inicio DESC LIMIT 1) AS ultimo_mantenimiento
FROM flota_aviones fa
JOIN flota_modelos fm             ON fa.id_modelo = fm.id_modelo
JOIN linea_aerolineas la          ON fa.id_aerolinea = la.id_aerolinea
LEFT JOIN aero_aeropuertos aa     ON fa.base_operaciones = aa.id_aeropuerto
WHERE fa.activo = 'S';

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
JOIN rrhh_puestos p               ON e.id_puesto = p.id_puesto
JOIN rrhh_departamentos d         ON e.id_depto = d.id_depto
LEFT JOIN linea_aerolineas la     ON e.id_aerolinea = la.id_aerolinea
WHERE e.activo = 'S';

-- DATOS INICIALES (SEED)

-- Continentes
INSERT INTO geog_continentes (nombre, codigo_iso) VALUES
('América',        'AM'),
('Europa',         'EU'),
('Asia',           'AS'),
('África',         'AF'),
('Oceanía',        'OC'),
('Antártida',      'AN');

-- Zonas horarias
INSERT INTO geog_zonas_horarias (nombre, utc_offset, codigo_tz, aplica_dst) VALUES
('Hora Central de Guatemala', '-06:00', 'America/Guatemala',    FALSE),
('Hora del Este (EE.UU.)',    '-05:00', 'America/New_York',      TRUE),
('Hora Central (EE.UU.)',     '-06:00', 'America/Chicago',       TRUE),
('Hora del Pacífico (EE.UU.)','-08:00', 'America/Los_Angeles',   TRUE),
('Hora de Madrid',            '+01:00', 'Europe/Madrid',         TRUE),
('Hora de Ciudad de México',  '-06:00', 'America/Mexico_City',   TRUE),
('Hora de Bogotá',            '-05:00', 'America/Bogota',        FALSE),
('Hora de Miami',             '-05:00', 'America/Miami',         TRUE);

-- Guatemala (país)
INSERT INTO geog_paises (id_continente, nombre, codigo_iso2, codigo_iso3, codigo_telefonico, moneda, idioma_principal)
VALUES (1, 'Guatemala', 'GT', 'GTM', '+502', 'GTQ', 'Español');

-- Departamentos de Guatemala
INSERT INTO geog_estados_dep (id_pais, nombre, codigo, tipo) VALUES
(1, 'Guatemala',           'GT-GU', 'Departamento'),
(1, 'Sacatepéquez',        'GT-SA', 'Departamento'),
(1, 'Escuintla',           'GT-ES', 'Departamento'),
(1, 'Quetzaltenango',      'GT-QZ', 'Departamento'),
(1, 'Izabal',              'GT-IZ', 'Departamento'),
(1, 'Petén',               'GT-PE', 'Departamento'),
(1, 'Alta Verapaz',        'GT-AV', 'Departamento');

-- Ciudades
INSERT INTO geog_ciudades (id_estado, nombre, latitud, longitud, altitud_msnm) VALUES
(1, 'Ciudad de Guatemala', 14.6349, -90.5069, 1502),
(2, 'Antigua Guatemala',   14.5586, -90.7295, 1530),
(3, 'Santa Lucía Cotz.',   14.3389, -90.6644,  333),
(4, 'Quetzaltenango',      14.8436, -91.5177, 2333),
(5, 'Puerto Barrios',      15.7167, -88.5833,    3),
(6, 'Santa Elena de la Cruz', 16.9200, -89.8900, 127),
(7, 'Cobán',               15.4667, -90.3667, 1316);

-- Aeropuerto principal
INSERT INTO aero_aeropuertos (id_ciudad, id_zona, codigo_iata, codigo_icao, nombre, nombre_corto, tipo, latitud, longitud, altitud_ft, es_hub)
VALUES
(1, 1, 'GUA', 'MGGT', 'Aeropuerto Internacional La Aurora', 'La Aurora', 'INTERNACIONAL', 14.5833, -90.5275, 4952, TRUE),
(4, 1, 'AAZ', 'MGQZ', 'Aeropuerto Internacional Quetzaltenango', 'Quetzaltenango', 'NACIONAL', 14.8659, -91.5020, 7779, FALSE),
(6, 1, 'FRS', 'MGTK', 'Aeropuerto Internacional Mundo Maya', 'Mundo Maya', 'INTERNACIONAL', 16.9138, -89.8663, 427, FALSE);

-- Aerolínea guatemalteca (EJE)
INSERT INTO linea_aerolineas (codigo_iata, codigo_icao, nombre, nombre_comercial, pais_origen, sitio_web)
VALUES ('GX', 'GXG', 'Aerolínea Guatemala S.A.', 'AeroGT', 1, 'https://www.aerogt.com.gt');

-- Categorías de estado de vuelo
INSERT INTO oper_cat_estados (codigo, nombre, es_final) VALUES
('SCH', 'Programado',    FALSE),
('BOA', 'Abordando',     FALSE),
('DEP', 'Despegado',     FALSE),
('ARR', 'Aterrizado',    TRUE),
('CAN', 'Cancelado',     TRUE),
('DEL', 'Demorado',      FALSE),
('DIV', 'Desviado',      FALSE),
('RTN', 'Retorno',       FALSE);

-- Categorías de demora IATA
INSERT INTO oper_demoras_cat (codigo_iata, descripcion, responsable) VALUES
('11', 'Check-in pasajeros',                   'AEROLINEA'),
('13', 'Pasajeros rezagados o pendientes',      'AEROLINEA'),
('14', 'Exceso de equipaje',                    'AEROLINEA'),
('21', 'Documentación de carga',                'AEROLINEA'),
('31', 'Carga y descarga equipaje',             'TERRESTRE'),
('32', 'Carga y descarga de carga',             'TERRESTRE'),
('41', 'Catering tardío',                       'PROVEEDOR'),
('51', 'Limpieza tardía de aeronave',           'PROVEEDOR'),
('61', 'Mal funcionamiento de la aeronave',     'TECNICO'),
('62', 'Componentes faltantes',                 'TECNICO'),
('71', 'Control de tráfico aéreo (en ruta)',    'ATC'),
('72', 'Control de tráfico aéreo (tierra)',     'ATC'),
('81', 'Condiciones meteorológicas',            'CLIMA'),
('93', 'Restricciones gubernamentales',         'GOBIERNO');

-- Tipos de impuestos aplicables en Guatemala
INSERT INTO boleto_impuestos (codigo, descripcion, tipo, id_pais) VALUES
('GT-TA', 'Tasa de Aeropuerto Guatemala',        'AEROPORTUARIO', 1),
('GT-IVA','IVA 12% Guatemala',                   'IMPUESTO',      1),
('GT-SC', 'Seguro de Vuelo Obligatorio',          'SEGURO',        1),
('US-XT', 'Impuesto EE.UU. Internac.',           'IMPUESTO',      NULL);

-- Roles del sistema
INSERT INTO rrhh_sist_roles (nombre, descripcion) VALUES
('SUPERADMIN',         'Acceso total al sistema'),
('ADMIN_OPERACIONES',  'Gestión de operaciones de vuelo'),
('AGENTE_CHECKIN',     'Atención en mostrador y check-in'),
('SEGURIDAD',          'Control de acceso y seguridad'),
('SUPERVISOR_RAMPA',   'Coordinación de rampa y carga'),
('FINANCIERO',         'Facturación y finanzas'),
('RRHH',               'Gestión de recursos humanos'),
('SOLO_LECTURA',       'Consulta sin modificaciones');

-- Métodos de pago
INSERT INTO fin_metodos_pago (nombre, tipo, procesador) VALUES
('Visa',              'TARJETA_CREDITO',  'Visanet Guatemala'),
('Mastercard',        'TARJETA_CREDITO',  'BAM Neto'),
('American Express',  'TARJETA_CREDITO',  'Amex Guatemala'),
('Transferencia BAM', 'TRANSFERENCIA',    'Banco Agromercantil'),
('Depósito Bancario', 'DEPOSITO',         NULL),
('Efectivo GTQ',      'EFECTIVO',         NULL),
('PayPal',            'DIGITAL',          'PayPal Inc.'),
('Cheque Certificado','CHEQUE',           NULL);

-- Insertar registro de migración inicial
INSERT INTO hist_migracion_data (version, descripcion, aplicado_por, exitoso)
VALUES ('1.0.0', 'Creación inicial del schema completo aerogt - 6 módulos', 'DBA_INICIAL', TRUE);

-- COMENTARIOS EN TABLAS
COMMENT ON SCHEMA aerogt IS 'Schema principal del Sistema de Gestión Aeroportuaria de Guatemala';
COMMENT ON TABLE aero_aeropuertos IS 'EJE CENTRAL del Módulo de Infraestructura. Tabla núcleo que conecta todos los activos aeroportuarios.';
COMMENT ON TABLE linea_aerolineas IS 'EJE CENTRAL del Módulo de Aerolíneas. Todas las aerolíneas que operan en los aeropuertos del sistema.';
COMMENT ON TABLE rrhh_empleados IS 'EJE CENTRAL del Módulo de RRHH. Todos los empleados y tripulantes de la empresa.';
COMMENT ON TABLE oper_vuelos_instancia IS 'EJE CENTRAL de Operaciones. Cada instancia concreta de un vuelo programado.';
COMMENT ON TABLE pax_maestro IS 'EJE CENTRAL del Módulo de Pasajeros. Registro único de cada pasajero.';
COMMENT ON TABLE seg_incidentes IS 'EJE del Módulo de Seguridad. Registro de todos los incidentes de seguridad.';
COMMENT ON TABLE fin_facturacion_linea IS 'EJE del Módulo Financiero. Facturación a aerolíneas por uso de instalaciones.';

-- Tablas de unión M:N
COMMENT ON TABLE aero_aeropuertos_equipos IS 'TABLA DE UNION M:N — Aeropuertos ↔ Equipos de Apoyo (un equipo puede moverse entre aeropuertos)';
COMMENT ON TABLE linea_alianzas_union IS 'TABLA DE UNION M:N — Aerolíneas ↔ Alianzas Internacionales';
COMMENT ON TABLE flota_tipo_asiento_union IS 'TABLA DE UNION M:N — Configuración de Cabina ↔ Tipos de Asiento';
COMMENT ON TABLE flota_proveed_union IS 'TABLA DE UNION M:N — Aviones ↔ Proveedores de Repuestos';
COMMENT ON TABLE rrhh_asign_turnos IS 'TABLA DE UNION M:N — Empleados ↔ Turnos de Trabajo';
COMMENT ON TABLE rrhh_roles_union IS 'TABLA DE UNION M:N — Usuarios del Sistema ↔ Roles';
COMMENT ON TABLE rrhh_permisos_union IS 'TABLA DE UNION M:N — Roles ↔ Permisos del Sistema';
COMMENT ON TABLE oper_demoras_union IS 'TABLA DE UNION M:N — Instancias de Vuelo ↔ Categorías de Demora IATA';
COMMENT ON TABLE reserva_pax_union IS 'TABLA DE UNION M:N — Pasajeros ↔ Reservas (un PNR puede tener varios pasajeros)';
COMMENT ON TABLE boleto_impuestos_union IS 'TABLA DE UNION M:N — Boletos Electrónicos ↔ Tipos de Impuesto';
COMMENT ON TABLE seg_video_union IS 'TABLA DE UNION M:N — Incidentes de Seguridad ↔ Grabaciones de Video';
COMMENT ON TABLE reporte_dest_union IS 'TABLA DE UNION M:N — Configuración de Reportes ↔ Destinatarios';

-- FIN DEL SCRIPT
-- Total tablas: 108+
-- Total relaciones M:N con tabla de unión: 12
-- Total vistas: 4
-- Compatible con: PostgreSQL 14+
-- Esquema: aerogt
-- Para ejecutar: psql -U postgres -d mi_base -f create_db.sql

EXIT;

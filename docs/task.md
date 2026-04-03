# Panel de Control - Proyecto AeroGT

## Entorno y Configuraciones Globales
- **PDB (Pluggable Database):** `AERO_LA_AURORA`
- **Esquema (Schema):** `AEROGT`
- **Base de Datos Destino:** Oracle 21c (IP Target: `172.16.10.10`)
- **Universo DDL:** 161 tablas.
- **Enfoque Actual (Fase 1):** **Módulo 1 - Infraestructura (31 tablas base)**. 

## Reglas Operativas del Director
- **Analizar DDL**: Validar siempre el modelo y orquestar (Agente Backend / Frontend).
- **Validar Integridad**: Proteger relaciones `FOREIGN KEY` (ej. referencias a geog_ciudades, aero_aeropuertos).
- **Mantener el Foco**: Cero código de otros módulos.

## Inventario del Módulo 1 (Infraestructura)
> Para cada tabla se espera: 1. Package PL/SQL, 2. Página ASPX.

### Base Geográfica (5)
- [x] `geog_continentes`
- [x] `geog_paises`
- [x] `geog_estados_dep`
- [x] `geog_ciudades`
- [x] `geog_zonas_horarias`

### Aeropuertos - Eje Central (1)
- [x] `aero_aeropuertos`

### ASPA 1: Zona Aérea (6)
- [x] `aero_pistas`
- [x] `aero_material_pista`
- [x] `aero_umbrales_pista`
- [x] `aero_calles_rodaje`
- [x] `aero_plataformas`
- [x] `aero_hangares`

### ASPA 2: Terminales (9)
- [/] `aero_terminales`
- [/] `aero_secciones_terminal`
- [/] `aero_puertas_gates`
- [/] `aero_estado_gate`
- [/] `aero_salas_espera`
- [/] `aero_vip_lounge`
- [/] `aero_mostradores`
- [/] `aero_sistemas_equipaje`

### ASPA 3: Técnica / Logística (6)
- [/] `aero_detalle_tecnico`
- [ ] `aero_frecuencias_radio`
- [ ] `aero_iluminacion`
- [ ] `aero_bodegas_log`
- [/] `aero_equipos_apoyo`
- [/] `aero_aeropuertos_equipos`

### ASPA 4: Seguridad Física (3)
- [ ] `aero_sistemas_incendio`
- [ ] `aero_puntos_control`
- [ ] `aero_estacionamientos_pax`

### ASPA 5: Auditoría Infraestructura (2)
- [ ] `aero_incidencias_infra`
- [ ] `aero_historico_infra`

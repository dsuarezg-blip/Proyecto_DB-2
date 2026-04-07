-- ============================================================
--  PKG_RRHH_QRY  --  Consultas / Lectura
--  Módulo 3 · RRHH & Compras
--  Servidor réplica (reportes): 172.16.10.20:1521/aero_la_aurora
--  Servidor productivo (consultas operativas): 172.16.10.10
--  Autor: Nesto (Persona 3)
-- ============================================================

-- ============================================================
-- ESPECIFICACIÓN
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_RRHH_QRY AS

  -- ── EMPLEADOS ────────────────────────────────────────────
  PROCEDURE SP_LISTAR_EMPLEADOS (
      p_estado   IN  VARCHAR2 DEFAULT NULL,
      p_id_depto IN  NUMBER   DEFAULT NULL,
      p_cursor   OUT SYS_REFCURSOR
  );

  PROCEDURE SP_OBTENER_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  PROCEDURE SP_BUSCAR_EMPLEADOS (
      p_termino IN  VARCHAR2,
      p_cursor  OUT SYS_REFCURSOR
  );

  FUNCTION FN_NOMBRE_EMPLEADO (p_id_empleado IN NUMBER) RETURN VARCHAR2;

  -- ── DEPARTAMENTOS Y PUESTOS ──────────────────────────────
  PROCEDURE SP_LISTAR_DEPARTAMENTOS (
      p_cursor OUT SYS_REFCURSOR
  );

  PROCEDURE SP_LISTAR_PUESTOS (
      p_id_depto IN  NUMBER DEFAULT NULL,
      p_cursor   OUT SYS_REFCURSOR
  );

  -- ── CONTRATOS ────────────────────────────────────────────
  PROCEDURE SP_OBTENER_CONTRATO_ACTIVO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  PROCEDURE SP_LISTAR_CONTRATOS_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── LICENCIAS ────────────────────────────────────────────
  PROCEDURE SP_LISTAR_LICENCIAS_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  PROCEDURE SP_LISTAR_LICENCIAS_POR_VENCER (
      p_dias_umbral IN  NUMBER DEFAULT 90,
      p_cursor      OUT SYS_REFCURSOR
  );

  FUNCTION FN_PILOTO_VIGENTE (p_id_empleado IN NUMBER) RETURN CHAR;

  -- ── CERTIFICADOS MÉDICOS ─────────────────────────────────
  PROCEDURE SP_LISTAR_CERT_MEDICAS (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  PROCEDURE SP_LISTAR_CERTS_POR_VENCER (
      p_dias_umbral IN  NUMBER DEFAULT 60,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── HISTORIAL SALARIAL ───────────────────────────────────
  PROCEDURE SP_HISTORIAL_SALARIAL (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── TURNOS ───────────────────────────────────────────────
  PROCEDURE SP_LISTAR_TURNOS (
      p_cursor OUT SYS_REFCURSOR
  );

  PROCEDURE SP_TURNOS_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── ASISTENCIA ───────────────────────────────────────────
  PROCEDURE SP_ASISTENCIA_DIA (
      p_fecha  IN  DATE DEFAULT NULL,
      p_cursor OUT SYS_REFCURSOR
  );

  PROCEDURE SP_REPORTE_ASISTENCIA_MES (
      p_id_empleado IN  NUMBER,
      p_anio        IN  NUMBER,
      p_mes         IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  PROCEDURE SP_RESUMEN_ASISTENCIA_DEPTO (
      p_id_depto IN  NUMBER,
      p_anio     IN  NUMBER,
      p_mes      IN  NUMBER,
      p_cursor   OUT SYS_REFCURSOR
  );

  -- ── TRIPULACIÓN ──────────────────────────────────────────
  PROCEDURE SP_TRIPULACION_POR_VUELO (
      p_id_instancia IN  NUMBER,
      p_cursor       OUT SYS_REFCURSOR
  );

  PROCEDURE SP_VUELOS_TRIPULANTE (
      p_id_empleado IN  NUMBER,
      p_fecha_ini   IN  DATE DEFAULT NULL,
      p_fecha_fin   IN  DATE DEFAULT NULL,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── VIÁTICOS ─────────────────────────────────────────────
  PROCEDURE SP_LISTAR_VIATICOS (
      p_id_empleado IN  NUMBER DEFAULT NULL,
      p_estado      IN  VARCHAR2 DEFAULT NULL,
      p_cursor      OUT SYS_REFCURSOR
  );

  PROCEDURE SP_OBTENER_VIATICO (
      p_id_viatico IN  NUMBER,
      p_cursor     OUT SYS_REFCURSOR
  );

  FUNCTION FN_SALDO_VIATICO (p_id_viatico IN NUMBER) RETURN NUMBER;

  -- ── EQUIPO DE PROTECCIÓN ─────────────────────────────────
  PROCEDURE SP_LISTAR_EPP_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── EXPEDIENTES DISCIPLINARIOS ───────────────────────────
  PROCEDURE SP_LISTAR_EXPEDIENTES (
      p_id_empleado IN  NUMBER DEFAULT NULL,
      p_estado      IN  VARCHAR2 DEFAULT NULL,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── CAPACITACIONES ───────────────────────────────────────
  PROCEDURE SP_CAPACITACIONES_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  );

  -- ── USUARIOS Y ROLES ─────────────────────────────────────
  PROCEDURE SP_LISTAR_USUARIOS (
      p_cursor OUT SYS_REFCURSOR
  );

  PROCEDURE SP_OBTENER_ROLES_USUARIO (
      p_id_usuario IN  NUMBER,
      p_cursor     OUT SYS_REFCURSOR
  );

  PROCEDURE SP_VALIDAR_LOGIN (
      p_username     IN  VARCHAR2,
      p_tiene_acceso OUT CHAR,
      p_id_usuario   OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  );

  -- ── AUDITORÍA ────────────────────────────────────────────
  PROCEDURE SP_LOG_AUDITORIA (
      p_id_usuario IN  NUMBER DEFAULT NULL,
      p_fecha_ini  IN  DATE   DEFAULT NULL,
      p_fecha_fin  IN  DATE   DEFAULT NULL,
      p_cursor     OUT SYS_REFCURSOR
  );

  -- ── REPORTES DASHBOARD ───────────────────────────────────
  PROCEDURE SP_RESUMEN_DASHBOARD (
      p_total_empleados   OUT NUMBER,
      p_activos           OUT NUMBER,
      p_lics_por_vencer   OUT NUMBER,
      p_viaticos_pend     OUT NUMBER
  );

  PROCEDURE SP_REPORTE_PLANTILLA_COMPLETA (
      p_cursor OUT SYS_REFCURSOR
  );

END PKG_RRHH_QRY;
/

-- ============================================================
-- CUERPO
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_RRHH_QRY AS

  -- ── EMPLEADOS ────────────────────────────────────────────
  PROCEDURE SP_LISTAR_EMPLEADOS (
      p_estado   IN  VARCHAR2 DEFAULT NULL,
      p_id_depto IN  NUMBER   DEFAULT NULL,
      p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT e.id_empleado, e.codigo_empleado,
                 e.nombres || ' ' || e.apellidos AS nombre_completo,
                 p.nombre AS puesto, d.nombre AS departamento,
                 e.email_corporativo, e.telefono,
                 e.fecha_ingreso, e.estado
          FROM   rrhh_empleados e
          JOIN   rrhh_puestos       p ON e.id_puesto = p.id_puesto
          JOIN   rrhh_departamentos d ON e.id_depto  = d.id_depto
          WHERE  (p_estado   IS NULL OR e.estado     = p_estado)
          AND    (p_id_depto IS NULL OR e.id_depto   = p_id_depto)
          ORDER BY e.apellidos, e.nombres;
  END SP_LISTAR_EMPLEADOS;

  PROCEDURE SP_OBTENER_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT e.*,
                 p.nombre AS nombre_puesto,
                 d.nombre AS nombre_depto,
                 sv.username,
                 s_sup.nombres || ' ' || s_sup.apellidos AS nombre_supervisor
          FROM   rrhh_empleados e
          JOIN   rrhh_puestos       p   ON e.id_puesto    = p.id_puesto
          JOIN   rrhh_departamentos d   ON e.id_depto     = d.id_depto
          LEFT JOIN rrhh_sist_usuarios sv ON e.id_empleado = sv.id_empleado
          LEFT JOIN rrhh_empleados s_sup  ON e.id_supervisor = s_sup.id_empleado
          WHERE  e.id_empleado = p_id_empleado;
  END SP_OBTENER_EMPLEADO;

  PROCEDURE SP_BUSCAR_EMPLEADOS (
      p_termino IN  VARCHAR2,
      p_cursor  OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT e.id_empleado, e.codigo_empleado,
                 e.nombres || ' ' || e.apellidos AS nombre_completo,
                 p.nombre AS puesto, d.nombre AS departamento, e.estado
          FROM   rrhh_empleados e
          JOIN   rrhh_puestos       p ON e.id_puesto = p.id_puesto
          JOIN   rrhh_departamentos d ON e.id_depto  = d.id_depto
          WHERE  UPPER(e.nombres || ' ' || e.apellidos) LIKE UPPER('%'||p_termino||'%')
          OR     UPPER(e.codigo_empleado)               LIKE UPPER('%'||p_termino||'%')
          OR     UPPER(e.email_corporativo)             LIKE UPPER('%'||p_termino||'%')
          ORDER BY e.apellidos;
  END SP_BUSCAR_EMPLEADOS;

  FUNCTION FN_NOMBRE_EMPLEADO (p_id_empleado IN NUMBER) RETURN VARCHAR2 AS
      v_nombre VARCHAR2(200);
  BEGIN
      SELECT nombres || ' ' || apellidos INTO v_nombre
      FROM   rrhh_empleados WHERE id_empleado = p_id_empleado;
      RETURN v_nombre;
  EXCEPTION WHEN OTHERS THEN RETURN NULL;
  END FN_NOMBRE_EMPLEADO;

  -- ── DEPARTAMENTOS Y PUESTOS ──────────────────────────────
  PROCEDURE SP_LISTAR_DEPARTAMENTOS (p_cursor OUT SYS_REFCURSOR) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT d.id_depto, d.nombre,
                 dp.nombre AS depto_padre,
                 (SELECT COUNT(*) FROM rrhh_empleados e WHERE e.id_depto = d.id_depto AND e.estado='ACTIVO') AS total_empleados
          FROM   rrhh_departamentos d
          LEFT JOIN rrhh_departamentos dp ON d.id_depto_padre = dp.id_depto
          ORDER BY d.nombre;
  END SP_LISTAR_DEPARTAMENTOS;

  PROCEDURE SP_LISTAR_PUESTOS (
      p_id_depto IN  NUMBER DEFAULT NULL,
      p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT p.id_puesto, p.nombre, p.nivel, p.salario_min_gtq, p.salario_max_gtq,
                 d.nombre AS departamento
          FROM   rrhh_puestos       p
          JOIN   rrhh_departamentos d ON p.id_depto = d.id_depto
          WHERE  (p_id_depto IS NULL OR p.id_depto = p_id_depto)
          AND    p.activo = 'S'
          ORDER BY p.nombre;
  END SP_LISTAR_PUESTOS;

  -- ── CONTRATOS ────────────────────────────────────────────
  PROCEDURE SP_OBTENER_CONTRATO_ACTIVO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT c.*, e.nombres || ' ' || e.apellidos AS nombre_empleado
          FROM   rrhh_contratos c
          JOIN   rrhh_empleados e ON c.id_empleado = e.id_empleado
          WHERE  c.id_empleado = p_id_empleado AND c.activo = 'S';
  END SP_OBTENER_CONTRATO_ACTIVO;

  PROCEDURE SP_LISTAR_CONTRATOS_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT * FROM rrhh_contratos
          WHERE  id_empleado = p_id_empleado
          ORDER BY fecha_inicio DESC;
  END SP_LISTAR_CONTRATOS_EMPLEADO;

  -- ── LICENCIAS ────────────────────────────────────────────
  PROCEDURE SP_LISTAR_LICENCIAS_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT l.*,
                 e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 CASE WHEN l.fecha_vencimiento < SYSDATE THEN 'VENCIDA'
                      WHEN l.fecha_vencimiento < SYSDATE + 90 THEN 'POR_VENCER'
                      ELSE 'VIGENTE' END AS estado_vigencia,
                 ROUND(l.fecha_vencimiento - SYSDATE) AS dias_restantes
          FROM   rrhh_licencias_pil l
          JOIN   rrhh_empleados     e ON l.id_empleado = e.id_empleado
          WHERE  l.id_empleado = p_id_empleado
          ORDER BY l.fecha_vencimiento;
  END SP_LISTAR_LICENCIAS_EMPLEADO;

  PROCEDURE SP_LISTAR_LICENCIAS_POR_VENCER (
      p_dias_umbral IN  NUMBER DEFAULT 90,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT l.*, e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 p.nombre AS puesto,
                 ROUND(l.fecha_vencimiento - SYSDATE) AS dias_restantes
          FROM   rrhh_licencias_pil l
          JOIN   rrhh_empleados     e ON l.id_empleado = e.id_empleado
          JOIN   rrhh_puestos       p ON e.id_puesto   = p.id_puesto
          WHERE  l.activa = 'S'
          AND    l.fecha_vencimiento BETWEEN SYSDATE AND SYSDATE + p_dias_umbral
          ORDER BY l.fecha_vencimiento;
  END SP_LISTAR_LICENCIAS_POR_VENCER;

  FUNCTION FN_PILOTO_VIGENTE (p_id_empleado IN NUMBER) RETURN CHAR AS
      v_count NUMBER;
  BEGIN
      SELECT COUNT(*) INTO v_count FROM rrhh_licencias_pil
      WHERE  id_empleado = p_id_empleado AND activa = 'S' AND fecha_vencimiento >= SYSDATE;
      RETURN CASE WHEN v_count > 0 THEN 'S' ELSE 'N' END;
  EXCEPTION WHEN OTHERS THEN RETURN 'N';
  END FN_PILOTO_VIGENTE;

  -- ── CERTIFICADOS MÉDICOS ─────────────────────────────────
  PROCEDURE SP_LISTAR_CERT_MEDICAS (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT c.*, e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 ROUND(c.fecha_vencimiento - SYSDATE) AS dias_restantes
          FROM   rrhh_cert_medicas c
          JOIN   rrhh_empleados    e ON c.id_empleado = e.id_empleado
          WHERE  c.id_empleado = p_id_empleado
          ORDER BY c.fecha_examen DESC;
  END SP_LISTAR_CERT_MEDICAS;

  PROCEDURE SP_LISTAR_CERTS_POR_VENCER (
      p_dias_umbral IN  NUMBER DEFAULT 60,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT c.*, e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 ROUND(c.fecha_vencimiento - SYSDATE) AS dias_restantes
          FROM   rrhh_cert_medicas c
          JOIN   rrhh_empleados    e ON c.id_empleado = e.id_empleado
          WHERE  c.fecha_vencimiento BETWEEN SYSDATE AND SYSDATE + p_dias_umbral
          ORDER BY c.fecha_vencimiento;
  END SP_LISTAR_CERTS_POR_VENCER;

  -- ── HISTORIAL SALARIAL ───────────────────────────────────
  PROCEDURE SP_HISTORIAL_SALARIAL (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT h.*, e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 ROUND((h.salario_nuevo_gtq - h.salario_anterior_gtq) / NULLIF(h.salario_anterior_gtq,0) * 100, 2) AS pct_incremento
          FROM   rrhh_hist_salarial h
          JOIN   rrhh_empleados     e ON h.id_empleado = e.id_empleado
          WHERE  h.id_empleado = p_id_empleado
          ORDER BY h.fecha_cambio DESC;
  END SP_HISTORIAL_SALARIAL;

  -- ── TURNOS ───────────────────────────────────────────────
  PROCEDURE SP_LISTAR_TURNOS (p_cursor OUT SYS_REFCURSOR) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT t.*,
                 (SELECT COUNT(*) FROM rrhh_asign_turnos at2 WHERE at2.id_turno = t.id_turno AND at2.activo='S') AS empleados_asignados
          FROM   rrhh_turnos t WHERE t.activo = 'S' ORDER BY t.nombre;
  END SP_LISTAR_TURNOS;

  PROCEDURE SP_TURNOS_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT at2.id_asignacion, t.nombre AS turno, t.tipo,
                 t.hora_entrada, t.hora_salida, t.dias_semana,
                 at2.fecha_desde, at2.fecha_hasta, at2.activo
          FROM   rrhh_asign_turnos at2
          JOIN   rrhh_turnos       t  ON at2.id_turno = t.id_turno
          WHERE  at2.id_empleado = p_id_empleado
          ORDER BY at2.activo DESC, at2.fecha_desde DESC;
  END SP_TURNOS_EMPLEADO;

  -- ── ASISTENCIA ───────────────────────────────────────────
  PROCEDURE SP_ASISTENCIA_DIA (
      p_fecha  IN  DATE DEFAULT NULL,
      p_cursor OUT SYS_REFCURSOR
  ) AS
      v_fecha DATE := NVL(p_fecha, TRUNC(SYSDATE));
  BEGIN
      OPEN p_cursor FOR
          SELECT a.id_asistencia, e.codigo_empleado,
                 e.nombres || ' ' || e.apellidos AS nombre_completo,
                 d.nombre AS departamento,
                 a.hora_entrada, a.hora_salida, a.estado, a.observaciones
          FROM   rrhh_asistencia   a
          JOIN   rrhh_empleados    e ON a.id_empleado = e.id_empleado
          JOIN   rrhh_departamentos d ON e.id_depto   = d.id_depto
          WHERE  TRUNC(a.fecha) = TRUNC(v_fecha)
          ORDER BY e.apellidos;
  END SP_ASISTENCIA_DIA;

  PROCEDURE SP_REPORTE_ASISTENCIA_MES (
      p_id_empleado IN  NUMBER,
      p_anio        IN  NUMBER,
      p_mes         IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT a.fecha, a.hora_entrada, a.hora_salida, a.estado, a.observaciones,
                 e.nombres || ' ' || e.apellidos AS nombre_empleado
          FROM   rrhh_asistencia a
          JOIN   rrhh_empleados  e ON a.id_empleado = e.id_empleado
          WHERE  a.id_empleado = p_id_empleado
          AND    EXTRACT(YEAR  FROM a.fecha) = p_anio
          AND    EXTRACT(MONTH FROM a.fecha) = p_mes
          ORDER BY a.fecha;
  END SP_REPORTE_ASISTENCIA_MES;

  PROCEDURE SP_RESUMEN_ASISTENCIA_DEPTO (
      p_id_depto IN  NUMBER,
      p_anio     IN  NUMBER,
      p_mes      IN  NUMBER,
      p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 COUNT(*) AS dias_totales,
                 SUM(CASE WHEN a.estado = 'PRESENTE' THEN 1 ELSE 0 END) AS presentes,
                 SUM(CASE WHEN a.estado = 'AUSENTE'  THEN 1 ELSE 0 END) AS ausentes,
                 SUM(CASE WHEN a.estado = 'PERMISO'  THEN 1 ELSE 0 END) AS permisos
          FROM   rrhh_asistencia   a
          JOIN   rrhh_empleados    e ON a.id_empleado = e.id_empleado
          WHERE  e.id_depto = p_id_depto
          AND    EXTRACT(YEAR  FROM a.fecha) = p_anio
          AND    EXTRACT(MONTH FROM a.fecha) = p_mes
          GROUP BY e.nombres || ' ' || e.apellidos
          ORDER BY e.nombres;
  END SP_RESUMEN_ASISTENCIA_DEPTO;

  -- ── TRIPULACIÓN ──────────────────────────────────────────
  PROCEDURE SP_TRIPULACION_POR_VUELO (
      p_id_instancia IN  NUMBER,
      p_cursor       OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT t.id_trip_vuelo, t.rol, t.es_comandante,
                 e.codigo_empleado,
                 e.nombres || ' ' || e.apellidos AS nombre_completo,
                 p.nombre AS puesto,
                 FN_PILOTO_VIGENTE(e.id_empleado) AS licencia_vigente
          FROM   rrhh_tripulacion t
          JOIN   rrhh_empleados   e ON t.id_empleado = e.id_empleado
          JOIN   rrhh_puestos     p ON e.id_puesto   = p.id_puesto
          WHERE  t.id_instancia = p_id_instancia
          ORDER BY DECODE(t.es_comandante,'S',1,2), t.rol;
  END SP_TRIPULACION_POR_VUELO;

  PROCEDURE SP_VUELOS_TRIPULANTE (
      p_id_empleado IN  NUMBER,
      p_fecha_ini   IN  DATE DEFAULT NULL,
      p_fecha_fin   IN  DATE DEFAULT NULL,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT t.rol, t.es_comandante,
                 v.id_instancia, v.fecha_vuelo, v.estado,
                 v.std, v.sta
          FROM   rrhh_tripulacion     t
          JOIN   oper_vuelos_instancia v ON t.id_instancia = v.id_instancia
          WHERE  t.id_empleado = p_id_empleado
          AND    (p_fecha_ini IS NULL OR v.fecha_vuelo >= p_fecha_ini)
          AND    (p_fecha_fin IS NULL OR v.fecha_vuelo <= p_fecha_fin)
          ORDER BY v.fecha_vuelo DESC;
  END SP_VUELOS_TRIPULANTE;

  -- ── VIÁTICOS ─────────────────────────────────────────────
  PROCEDURE SP_LISTAR_VIATICOS (
      p_id_empleado IN  NUMBER DEFAULT NULL,
      p_estado      IN  VARCHAR2 DEFAULT NULL,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT v.*,
                 e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 e.codigo_empleado,
                 ap.nombres || ' ' || ap.apellidos AS aprobado_por_nombre,
                 NVL(v.monto_aprobado_gtq,0) - NVL(v.monto_gastado_gtq,0) AS saldo
          FROM   rrhh_viaticos  v
          JOIN   rrhh_empleados e  ON v.id_empleado = e.id_empleado
          LEFT JOIN rrhh_empleados ap ON v.aprobado_por = ap.id_empleado
          WHERE  (p_id_empleado IS NULL OR v.id_empleado = p_id_empleado)
          AND    (p_estado      IS NULL OR v.estado       = p_estado)
          ORDER BY v.fecha_salida DESC;
  END SP_LISTAR_VIATICOS;

  PROCEDURE SP_OBTENER_VIATICO (
      p_id_viatico IN  NUMBER,
      p_cursor     OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT v.*, e.nombres || ' ' || e.apellidos AS nombre_empleado
          FROM   rrhh_viaticos v
          JOIN   rrhh_empleados e ON v.id_empleado = e.id_empleado
          WHERE  v.id_viatico = p_id_viatico;
  END SP_OBTENER_VIATICO;

  FUNCTION FN_SALDO_VIATICO (p_id_viatico IN NUMBER) RETURN NUMBER AS
      v_aprobado NUMBER; v_gastado NUMBER;
  BEGIN
      SELECT monto_aprobado_gtq, NVL(monto_gastado_gtq,0)
      INTO   v_aprobado, v_gastado
      FROM   rrhh_viaticos WHERE id_viatico = p_id_viatico;
      RETURN v_aprobado - v_gastado;
  EXCEPTION WHEN OTHERS THEN RETURN 0;
  END FN_SALDO_VIATICO;

  -- ── EQUIPO DE PROTECCIÓN ─────────────────────────────────
  PROCEDURE SP_LISTAR_EPP_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT eq.*, e.nombres || ' ' || e.apellidos AS nombre_empleado
          FROM   rrhh_equipo_prot eq
          JOIN   rrhh_empleados   e ON eq.id_empleado = e.id_empleado
          WHERE  eq.id_empleado = p_id_empleado
          ORDER BY eq.fecha_entrega DESC;
  END SP_LISTAR_EPP_EMPLEADO;

  -- ── EXPEDIENTES DISCIPLINARIOS ───────────────────────────
  PROCEDURE SP_LISTAR_EXPEDIENTES (
      p_id_empleado IN  NUMBER DEFAULT NULL,
      p_estado      IN  VARCHAR2 DEFAULT NULL,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT ex.*, e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 e.codigo_empleado
          FROM   rrhh_exped_disc ex
          JOIN   rrhh_empleados  e ON ex.id_empleado = e.id_empleado
          WHERE  (p_id_empleado IS NULL OR ex.id_empleado = p_id_empleado)
          AND    (p_estado      IS NULL OR ex.estado      = p_estado)
          ORDER BY ex.fecha_falta DESC;
  END SP_LISTAR_EXPEDIENTES;

  -- ── CAPACITACIONES ───────────────────────────────────────
  PROCEDURE SP_CAPACITACIONES_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT c.*, e.nombres || ' ' || e.apellidos AS nombre_empleado
          FROM   rrhh_hist_capacit c
          JOIN   rrhh_empleados    e ON c.id_empleado = e.id_empleado
          WHERE  c.id_empleado = p_id_empleado
          ORDER BY c.fecha_inicio DESC;
  END SP_CAPACITACIONES_EMPLEADO;

  -- ── USUARIOS Y ROLES ─────────────────────────────────────
  PROCEDURE SP_LISTAR_USUARIOS (p_cursor OUT SYS_REFCURSOR) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT u.id_usuario, u.username, u.email, u.activo, u.bloqueado,
                 u.ultimo_login, u.intentos_fallidos,
                 e.nombres || ' ' || e.apellidos AS nombre_empleado,
                 e.codigo_empleado
          FROM   rrhh_sist_usuarios u
          JOIN   rrhh_empleados     e ON u.id_empleado = e.id_empleado
          ORDER BY e.apellidos;
  END SP_LISTAR_USUARIOS;

  PROCEDURE SP_OBTENER_ROLES_USUARIO (
      p_id_usuario IN  NUMBER,
      p_cursor     OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT r.id_rol, r.nombre, r.descripcion
          FROM   rrhh_roles_union ru
          JOIN   rrhh_sist_roles  r ON ru.id_rol = r.id_rol
          WHERE  ru.id_usuario = p_id_usuario AND r.activo = 'S';
  END SP_OBTENER_ROLES_USUARIO;

  PROCEDURE SP_VALIDAR_LOGIN (
      p_username     IN  VARCHAR2,
      p_tiene_acceso OUT CHAR,
      p_id_usuario   OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  ) AS
      v_activo    CHAR(1);
      v_bloqueado CHAR(1);
      v_emp_activo CHAR(1);
  BEGIN
      SELECT u.id_usuario, u.activo, u.bloqueado, e.estado
      INTO   p_id_usuario, v_activo, v_bloqueado, v_emp_activo
      FROM   rrhh_sist_usuarios u
      JOIN   rrhh_empleados     e ON u.id_empleado = e.id_empleado
      WHERE  u.username = p_username;

      IF v_bloqueado = 'S' THEN
          p_tiene_acceso := 'N'; p_mensaje := 'Cuenta bloqueada. Contacte al administrador.';
      ELSIF v_activo = 'N' THEN
          p_tiene_acceso := 'N'; p_mensaje := 'Cuenta desactivada.';
      ELSIF v_emp_activo != 'ACTIVO' THEN
          p_tiene_acceso := 'N'; p_mensaje := 'El empleado no está activo en el sistema.';
      ELSE
          p_tiene_acceso := 'S'; p_mensaje := 'Acceso permitido.';
          UPDATE rrhh_sist_usuarios
          SET    ultimo_login = SYSTIMESTAMP, intentos_fallidos = 0
          WHERE  id_usuario = p_id_usuario;
          COMMIT;
      END IF;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_tiene_acceso := 'N'; p_id_usuario := NULL;
          p_mensaje := 'Usuario no encontrado.';
      WHEN OTHERS THEN
          p_tiene_acceso := 'N'; p_mensaje := 'Error del sistema: ' || SQLERRM;
  END SP_VALIDAR_LOGIN;

  -- ── AUDITORÍA ────────────────────────────────────────────
  PROCEDURE SP_LOG_AUDITORIA (
      p_id_usuario IN  NUMBER DEFAULT NULL,
      p_fecha_ini  IN  DATE   DEFAULT NULL,
      p_fecha_fin  IN  DATE   DEFAULT NULL,
      p_cursor     OUT SYS_REFCURSOR
  ) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT l.*, u.username,
                 e.nombres || ' ' || e.apellidos AS nombre_empleado
          FROM   rrhh_log_auditoria l
          JOIN   rrhh_sist_usuarios u ON l.id_usuario   = u.id_usuario
          JOIN   rrhh_empleados     e ON u.id_empleado   = e.id_empleado
          WHERE  (p_id_usuario IS NULL OR l.id_usuario  = p_id_usuario)
          AND    (p_fecha_ini  IS NULL OR TRUNC(l.registrado_en) >= p_fecha_ini)
          AND    (p_fecha_fin  IS NULL OR TRUNC(l.registrado_en) <= p_fecha_fin)
          ORDER BY l.registrado_en DESC;
  END SP_LOG_AUDITORIA;

  -- ── REPORTES DASHBOARD ───────────────────────────────────
  PROCEDURE SP_RESUMEN_DASHBOARD (
      p_total_empleados OUT NUMBER,
      p_activos         OUT NUMBER,
      p_lics_por_vencer OUT NUMBER,
      p_viaticos_pend   OUT NUMBER
  ) AS
  BEGIN
      SELECT COUNT(*) INTO p_total_empleados FROM rrhh_empleados;
      SELECT COUNT(*) INTO p_activos FROM rrhh_empleados WHERE estado = 'ACTIVO';
      SELECT COUNT(*) INTO p_lics_por_vencer FROM rrhh_licencias_pil
      WHERE  activa = 'S' AND fecha_vencimiento BETWEEN SYSDATE AND SYSDATE + 90;
      SELECT COUNT(*) INTO p_viaticos_pend FROM rrhh_viaticos WHERE estado = 'PENDIENTE';
  END SP_RESUMEN_DASHBOARD;

  PROCEDURE SP_REPORTE_PLANTILLA_COMPLETA (p_cursor OUT SYS_REFCURSOR) AS
  BEGIN
      OPEN p_cursor FOR
          SELECT e.codigo_empleado,
                 e.nombres || ' ' || e.apellidos AS nombre_completo,
                 p.nombre AS puesto, d.nombre AS departamento,
                 e.email_corporativo, e.telefono, e.fecha_ingreso,
                 FLOOR(MONTHS_BETWEEN(SYSDATE, e.fecha_ingreso)/12) AS anios_servicio,
                 e.estado,
                 c.tipo AS tipo_contrato, c.salario_base_gtq,
                 FN_PILOTO_VIGENTE(e.id_empleado) AS piloto_vigente
          FROM   rrhh_empleados    e
          JOIN   rrhh_puestos       p  ON e.id_puesto = p.id_puesto
          JOIN   rrhh_departamentos d  ON e.id_depto  = d.id_depto
          LEFT JOIN rrhh_contratos  c  ON e.id_empleado = c.id_empleado AND c.activo = 'S'
          ORDER BY d.nombre, e.apellidos;
  END SP_REPORTE_PLANTILLA_COMPLETA;

END PKG_RRHH_QRY;
/

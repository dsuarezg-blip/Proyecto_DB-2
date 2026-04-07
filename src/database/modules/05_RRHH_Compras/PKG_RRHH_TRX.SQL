-- ============================================================
--  PKG_RRHH_TRX  --  Transacciones / Escritura
--  Módulo 3 · RRHH & Compras
--  Servidor productivo: 172.16.10.10:1521/aero_la_aurora
--  Usuario: AEROGT / AeroGT_2025#
--  Autor  : Nesto (Persona 3)
-- ============================================================
-- REGLA: NINGÚN SQL directo en VB.NET. Solo llamadas a este PKG.
-- ============================================================

-- ============================================================
-- ESPECIFICACIÓN
-- ============================================================
CREATE OR REPLACE PACKAGE PKG_RRHH_TRX AS

  -- ── EMPLEADOS ────────────────────────────────────────────
  PROCEDURE SP_INSERTAR_EMPLEADO (
      p_id_puesto          IN  NUMBER,
      p_id_depto           IN  NUMBER,
      p_id_aerolinea       IN  NUMBER DEFAULT NULL,
      p_codigo_empleado    IN  VARCHAR2,
      p_nombres            IN  VARCHAR2,
      p_apellidos          IN  VARCHAR2,
      p_dpi                IN  VARCHAR2 DEFAULT NULL,
      p_pasaporte          IN  VARCHAR2 DEFAULT NULL,
      p_fecha_nacimiento   IN  DATE     DEFAULT NULL,
      p_genero             IN  CHAR     DEFAULT NULL,
      p_email_corporativo  IN  VARCHAR2,
      p_email_personal     IN  VARCHAR2 DEFAULT NULL,
      p_telefono           IN  VARCHAR2 DEFAULT NULL,
      p_telefono_emergencia IN VARCHAR2 DEFAULT NULL,
      p_contacto_emergencia IN VARCHAR2 DEFAULT NULL,
      p_fecha_ingreso      IN  DATE,
      p_id_supervisor      IN  NUMBER   DEFAULT NULL,
      p_resultado          OUT NUMBER,
      p_mensaje            OUT VARCHAR2
  );

  PROCEDURE SP_CAMBIAR_ESTADO_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_estado      IN  VARCHAR2,    -- ACTIVO | INACTIVO | SUSPENDIDO | RETIRADO
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  );

  PROCEDURE SP_ACTUALIZAR_EMPLEADO (
      p_id_empleado         IN  NUMBER,
      p_telefono            IN  VARCHAR2 DEFAULT NULL,
      p_telefono_emergencia IN  VARCHAR2 DEFAULT NULL,
      p_contacto_emergencia IN  VARCHAR2 DEFAULT NULL,
      p_email_personal      IN  VARCHAR2 DEFAULT NULL,
      p_id_supervisor       IN  NUMBER   DEFAULT NULL,
      p_resultado           OUT NUMBER,
      p_mensaje             OUT VARCHAR2
  );

  -- ── CONTRATOS ────────────────────────────────────────────
  PROCEDURE SP_REGISTRAR_CONTRATO (
      p_id_empleado     IN  NUMBER,
      p_tipo            IN  VARCHAR2,   -- TIEMPO_INDEFINIDO | TIEMPO_DEFINIDO | TEMPORAL | PRACTICANTE
      p_fecha_inicio    IN  DATE,
      p_fecha_fin       IN  DATE     DEFAULT NULL,
      p_salario_base    IN  NUMBER,
      p_jornada         IN  VARCHAR2 DEFAULT NULL,
      p_resultado       OUT NUMBER,
      p_mensaje         OUT VARCHAR2
  );

  -- ── LICENCIAS DE PILOTO ──────────────────────────────────
  PROCEDURE SP_REGISTRAR_LICENCIA (
      p_id_empleado       IN  NUMBER,
      p_tipo              IN  VARCHAR2,
      p_numero            IN  VARCHAR2,
      p_organismo_emisor  IN  VARCHAR2 DEFAULT NULL,
      p_pais_emisor       IN  NUMBER   DEFAULT NULL,
      p_fecha_emision     IN  DATE,
      p_fecha_vencimiento IN  DATE,
      p_habilitaciones    IN  VARCHAR2 DEFAULT NULL,
      p_resultado         OUT NUMBER,
      p_mensaje           OUT VARCHAR2
  );

  PROCEDURE SP_ACTUALIZAR_LICENCIA (
      p_id_licencia       IN  NUMBER,
      p_fecha_vencimiento IN  DATE,
      p_habilitaciones    IN  VARCHAR2 DEFAULT NULL,
      p_activa            IN  CHAR     DEFAULT 'S',
      p_resultado         OUT NUMBER,
      p_mensaje           OUT VARCHAR2
  );

  -- ── CERTIFICADOS MÉDICOS ─────────────────────────────────
  PROCEDURE SP_REGISTRAR_CERT_MEDICA (
      p_id_empleado       IN  NUMBER,
      p_tipo              IN  VARCHAR2,
      p_medico            IN  VARCHAR2 DEFAULT NULL,
      p_centro_medico     IN  VARCHAR2 DEFAULT NULL,
      p_fecha_examen      IN  DATE,
      p_fecha_vencimiento IN  DATE     DEFAULT NULL,
      p_apto              IN  CHAR     DEFAULT 'S',
      p_restricciones     IN  VARCHAR2 DEFAULT NULL,
      p_resultado         OUT NUMBER,
      p_mensaje           OUT VARCHAR2
  );

  -- ── HISTORIAL SALARIAL ───────────────────────────────────
  PROCEDURE SP_REGISTRAR_CAMBIO_SALARIO (
      p_id_empleado         IN  NUMBER,
      p_salario_anterior    IN  NUMBER,
      p_salario_nuevo       IN  NUMBER,
      p_motivo              IN  VARCHAR2 DEFAULT NULL,
      p_aprobado_por        IN  NUMBER   DEFAULT NULL,
      p_resultado           OUT NUMBER,
      p_mensaje             OUT VARCHAR2
  );

  -- ── TURNOS ───────────────────────────────────────────────
  PROCEDURE SP_CREAR_TURNO (
      p_nombre        IN  VARCHAR2,
      p_tipo          IN  VARCHAR2,   -- MANANA | TARDE | NOCHE | ROTATIVO
      p_hora_entrada  IN  VARCHAR2,
      p_hora_salida   IN  VARCHAR2,
      p_duracion_horas IN NUMBER   DEFAULT NULL,
      p_dias_semana   IN  VARCHAR2 DEFAULT NULL,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  );

  PROCEDURE SP_ASIGNAR_TURNO (
      p_id_empleado  IN  NUMBER,
      p_id_turno     IN  NUMBER,
      p_fecha_desde  IN  DATE,
      p_fecha_hasta  IN  DATE DEFAULT NULL,
      p_resultado    OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  );

  PROCEDURE SP_DESACTIVAR_TURNO_EMPLEADO (
      p_id_asignacion IN  NUMBER,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  );

  -- ── ASISTENCIA ───────────────────────────────────────────
  PROCEDURE SP_REGISTRAR_ENTRADA (
      p_id_empleado IN  NUMBER,
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  );

  PROCEDURE SP_REGISTRAR_SALIDA (
      p_id_empleado IN  NUMBER,
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  );

  PROCEDURE SP_REGISTRAR_ASISTENCIA_MANUAL (
      p_id_empleado   IN  NUMBER,
      p_fecha         IN  DATE,
      p_hora_entrada  IN  VARCHAR2 DEFAULT NULL,
      p_hora_salida   IN  VARCHAR2 DEFAULT NULL,
      p_estado        IN  VARCHAR2 DEFAULT 'PRESENTE',
      p_observaciones IN  VARCHAR2 DEFAULT NULL,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  );

  -- ── TRIPULACIÓN ──────────────────────────────────────────
  PROCEDURE SP_ASIGNAR_TRIPULACION (
      p_id_empleado  IN  NUMBER,
      p_id_instancia IN  NUMBER,
      p_rol          IN  VARCHAR2,
      p_es_comandante IN CHAR DEFAULT 'N',
      p_resultado    OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  );

  PROCEDURE SP_QUITAR_TRIPULACION (
      p_id_trip_vuelo IN  NUMBER,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  );

  -- ── VIÁTICOS ─────────────────────────────────────────────
  PROCEDURE SP_SOLICITAR_VIATICO (
      p_id_empleado       IN  NUMBER,
      p_destino           IN  VARCHAR2,
      p_fecha_salida      IN  DATE,
      p_fecha_retorno     IN  DATE     DEFAULT NULL,
      p_monto_aprobado    IN  NUMBER,
      p_aprobado_por      IN  NUMBER   DEFAULT NULL,
      p_resultado         OUT NUMBER,
      p_mensaje           OUT VARCHAR2
  );

  PROCEDURE SP_LIQUIDAR_VIATICO (
      p_id_viatico      IN  NUMBER,
      p_monto_gastado   IN  NUMBER,
      p_resultado       OUT NUMBER,
      p_mensaje         OUT VARCHAR2
  );

  PROCEDURE SP_CAMBIAR_ESTADO_VIATICO (
      p_id_viatico  IN  NUMBER,
      p_estado      IN  VARCHAR2,  -- PENDIENTE | APROBADO | LIQUIDADO | RECHAZADO
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  );

  -- ── EQUIPO DE PROTECCIÓN ─────────────────────────────────
  PROCEDURE SP_REGISTRAR_EQUIPO_PROT (
      p_id_empleado    IN  NUMBER,
      p_tipo_equipo    IN  VARCHAR2,
      p_descripcion    IN  VARCHAR2 DEFAULT NULL,
      p_cantidad       IN  NUMBER   DEFAULT 1,
      p_fecha_entrega  IN  DATE     DEFAULT NULL,
      p_resultado      OUT NUMBER,
      p_mensaje        OUT VARCHAR2
  );

  PROCEDURE SP_DEVOLVER_EQUIPO_PROT (
      p_id_epp          IN  NUMBER,
      p_fecha_devolucion IN  DATE,
      p_resultado       OUT NUMBER,
      p_mensaje         OUT VARCHAR2
  );

  -- ── EXPEDIENTES DISCIPLINARIOS ───────────────────────────
  PROCEDURE SP_REGISTRAR_EXPEDIENTE (
      p_id_empleado  IN  NUMBER,
      p_tipo_falta   IN  VARCHAR2,
      p_descripcion  IN  VARCHAR2,
      p_sancion      IN  VARCHAR2 DEFAULT NULL,
      p_fecha_falta  IN  DATE,
      p_aprobado_por IN  VARCHAR2 DEFAULT NULL,
      p_resultado    OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  );

  PROCEDURE SP_CERRAR_EXPEDIENTE (
      p_id_expediente IN  NUMBER,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  );

  -- ── CAPACITACIONES ───────────────────────────────────────
  PROCEDURE SP_REGISTRAR_CAPACITACION (
      p_id_empleado     IN  NUMBER,
      p_nombre_curso    IN  VARCHAR2,
      p_tipo            IN  VARCHAR2 DEFAULT NULL,
      p_proveedor       IN  VARCHAR2 DEFAULT NULL,
      p_fecha_inicio    IN  DATE     DEFAULT NULL,
      p_fecha_fin       IN  DATE     DEFAULT NULL,
      p_horas           IN  NUMBER   DEFAULT NULL,
      p_calificacion    IN  NUMBER   DEFAULT NULL,
      p_aprobado        IN  CHAR     DEFAULT 'S',
      p_certificado_url IN  VARCHAR2 DEFAULT NULL,
      p_resultado       OUT NUMBER,
      p_mensaje         OUT VARCHAR2
  );

  -- ── FOTOS ────────────────────────────────────────────────
  PROCEDURE SP_GUARDAR_FOTO (
      p_id_empleado    IN  NUMBER,
      p_url_foto       IN  VARCHAR2 DEFAULT NULL,
      p_url_biometrico IN  VARCHAR2 DEFAULT NULL,
      p_fecha_captura  IN  DATE     DEFAULT NULL,
      p_resultado      OUT NUMBER,
      p_mensaje        OUT VARCHAR2
  );

  -- ── USUARIOS DEL SISTEMA ─────────────────────────────────
  PROCEDURE SP_CREAR_USUARIO (
      p_id_empleado  IN  NUMBER,
      p_username     IN  VARCHAR2,
      p_password_hash IN VARCHAR2,
      p_email        IN  VARCHAR2,
      p_resultado    OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  );

  PROCEDURE SP_CAMBIAR_ESTADO_USUARIO (
      p_id_usuario IN  NUMBER,
      p_activo     IN  CHAR,   -- S | N
      p_resultado  OUT NUMBER,
      p_mensaje    OUT VARCHAR2
  );

  PROCEDURE SP_ASIGNAR_ROL (
      p_id_usuario IN  NUMBER,
      p_id_rol     IN  NUMBER,
      p_resultado  OUT NUMBER,
      p_mensaje    OUT VARCHAR2
  );

  PROCEDURE SP_QUITAR_ROL (
      p_id_usuario IN  NUMBER,
      p_id_rol     IN  NUMBER,
      p_resultado  OUT NUMBER,
      p_mensaje    OUT VARCHAR2
  );

  PROCEDURE SP_REGISTRAR_AUDITORIA (
      p_id_usuario  IN  NUMBER,
      p_accion      IN  VARCHAR2,
      p_modulo      IN  VARCHAR2 DEFAULT NULL,
      p_entidad     IN  VARCHAR2 DEFAULT NULL,
      p_id_entidad  IN  NUMBER   DEFAULT NULL,
      p_descripcion IN  VARCHAR2 DEFAULT NULL,
      p_ip_address  IN  VARCHAR2 DEFAULT NULL,
      p_exitoso     IN  CHAR     DEFAULT 'S'
  );

END PKG_RRHH_TRX;
/

-- ============================================================
-- CUERPO
-- ============================================================
CREATE OR REPLACE PACKAGE BODY PKG_RRHH_TRX AS

  -- ── EMPLEADOS ────────────────────────────────────────────
  PROCEDURE SP_INSERTAR_EMPLEADO (
      p_id_puesto          IN  NUMBER,
      p_id_depto           IN  NUMBER,
      p_id_aerolinea       IN  NUMBER DEFAULT NULL,
      p_codigo_empleado    IN  VARCHAR2,
      p_nombres            IN  VARCHAR2,
      p_apellidos          IN  VARCHAR2,
      p_dpi                IN  VARCHAR2 DEFAULT NULL,
      p_pasaporte          IN  VARCHAR2 DEFAULT NULL,
      p_fecha_nacimiento   IN  DATE     DEFAULT NULL,
      p_genero             IN  CHAR     DEFAULT NULL,
      p_email_corporativo  IN  VARCHAR2,
      p_email_personal     IN  VARCHAR2 DEFAULT NULL,
      p_telefono           IN  VARCHAR2 DEFAULT NULL,
      p_telefono_emergencia IN VARCHAR2 DEFAULT NULL,
      p_contacto_emergencia IN VARCHAR2 DEFAULT NULL,
      p_fecha_ingreso      IN  DATE,
      p_id_supervisor      IN  NUMBER   DEFAULT NULL,
      p_resultado          OUT NUMBER,
      p_mensaje            OUT VARCHAR2
  ) AS
      v_count NUMBER;
  BEGIN
      SELECT COUNT(*) INTO v_count
      FROM   rrhh_empleados
      WHERE  codigo_empleado = p_codigo_empleado;
      IF v_count > 0 THEN
          p_resultado := 0;
          p_mensaje   := 'El código de empleado ya existe: ' || p_codigo_empleado;
          RETURN;
      END IF;

      INSERT INTO rrhh_empleados (
          id_puesto, id_depto, id_aerolinea, codigo_empleado,
          nombres, apellidos, dpi, pasaporte, fecha_nacimiento,
          genero, email_corporativo, email_personal,
          telefono, telefono_emergencia, contacto_emergencia,
          fecha_ingreso, estado, id_supervisor
      ) VALUES (
          p_id_puesto, p_id_depto, p_id_aerolinea, p_codigo_empleado,
          p_nombres, p_apellidos, p_dpi, p_pasaporte, p_fecha_nacimiento,
          p_genero, p_email_corporativo, p_email_personal,
          p_telefono, p_telefono_emergencia, p_contacto_emergencia,
          p_fecha_ingreso, 'ACTIVO', p_id_supervisor
      );
      COMMIT;
      p_resultado := 1;
      p_mensaje   := 'Empleado registrado correctamente.';
  EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK;
          p_resultado := 0;
          p_mensaje   := 'Ya existe un empleado con ese DPI o email corporativo.';
      WHEN OTHERS THEN
          ROLLBACK;
          p_resultado := -1;
          p_mensaje   := 'Error: ' || SQLERRM;
  END SP_INSERTAR_EMPLEADO;

  -- ─────────────────────────────────────────────────────────
  PROCEDURE SP_CAMBIAR_ESTADO_EMPLEADO (
      p_id_empleado IN  NUMBER,
      p_estado      IN  VARCHAR2,
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_empleados
      SET    estado = p_estado
      WHERE  id_empleado = p_id_empleado;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0;
          p_mensaje   := 'Empleado no encontrado.';
          RETURN;
      END IF;
      COMMIT;
      p_resultado := 1;
      p_mensaje   := 'Estado actualizado a ' || p_estado;
  EXCEPTION
      WHEN OTHERS THEN
          ROLLBACK;
          p_resultado := -1;
          p_mensaje   := 'Error: ' || SQLERRM;
  END SP_CAMBIAR_ESTADO_EMPLEADO;

  -- ─────────────────────────────────────────────────────────
  PROCEDURE SP_ACTUALIZAR_EMPLEADO (
      p_id_empleado         IN  NUMBER,
      p_telefono            IN  VARCHAR2 DEFAULT NULL,
      p_telefono_emergencia IN  VARCHAR2 DEFAULT NULL,
      p_contacto_emergencia IN  VARCHAR2 DEFAULT NULL,
      p_email_personal      IN  VARCHAR2 DEFAULT NULL,
      p_id_supervisor       IN  NUMBER   DEFAULT NULL,
      p_resultado           OUT NUMBER,
      p_mensaje             OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_empleados
      SET    telefono              = NVL(p_telefono, telefono),
             telefono_emergencia   = NVL(p_telefono_emergencia, telefono_emergencia),
             contacto_emergencia   = NVL(p_contacto_emergencia, contacto_emergencia),
             email_personal        = NVL(p_email_personal, email_personal),
             id_supervisor         = NVL(p_id_supervisor, id_supervisor)
      WHERE  id_empleado = p_id_empleado;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Empleado no encontrado.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Datos actualizados correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_ACTUALIZAR_EMPLEADO;

  -- ── CONTRATOS ────────────────────────────────────────────
  PROCEDURE SP_REGISTRAR_CONTRATO (
      p_id_empleado  IN  NUMBER,
      p_tipo         IN  VARCHAR2,
      p_fecha_inicio IN  DATE,
      p_fecha_fin    IN  DATE     DEFAULT NULL,
      p_salario_base IN  NUMBER,
      p_jornada      IN  VARCHAR2 DEFAULT NULL,
      p_resultado    OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  ) AS
  BEGIN
      -- Desactivar contrato anterior
      UPDATE rrhh_contratos
      SET    activo = 'N'
      WHERE  id_empleado = p_id_empleado AND activo = 'S';

      INSERT INTO rrhh_contratos (
          id_empleado, tipo, fecha_inicio, fecha_fin, salario_base_gtq, jornada, activo
      ) VALUES (
          p_id_empleado, p_tipo, p_fecha_inicio, p_fecha_fin, p_salario_base, p_jornada, 'S'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Contrato registrado correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_CONTRATO;

  -- ── LICENCIAS DE PILOTO ──────────────────────────────────
  PROCEDURE SP_REGISTRAR_LICENCIA (
      p_id_empleado       IN  NUMBER,
      p_tipo              IN  VARCHAR2,
      p_numero            IN  VARCHAR2,
      p_organismo_emisor  IN  VARCHAR2 DEFAULT NULL,
      p_pais_emisor       IN  NUMBER   DEFAULT NULL,
      p_fecha_emision     IN  DATE,
      p_fecha_vencimiento IN  DATE,
      p_habilitaciones    IN  VARCHAR2 DEFAULT NULL,
      p_resultado         OUT NUMBER,
      p_mensaje           OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_licencias_pil (
          id_empleado, tipo, numero, organismo_emisor, pais_emisor,
          fecha_emision, fecha_vencimiento, activa
      ) VALUES (
          p_id_empleado, p_tipo, p_numero, p_organismo_emisor, p_pais_emisor,
          p_fecha_emision, p_fecha_vencimiento, 'S'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Licencia registrada correctamente.';
  EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK;
          p_resultado := 0; p_mensaje := 'Ya existe una licencia con ese número.';
      WHEN OTHERS THEN
          ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_LICENCIA;

  PROCEDURE SP_ACTUALIZAR_LICENCIA (
      p_id_licencia       IN  NUMBER,
      p_fecha_vencimiento IN  DATE,
      p_habilitaciones    IN  VARCHAR2 DEFAULT NULL,
      p_activa            IN  CHAR     DEFAULT 'S',
      p_resultado         OUT NUMBER,
      p_mensaje           OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_licencias_pil
      SET    fecha_vencimiento = p_fecha_vencimiento,
             activa            = p_activa
      WHERE  id_licencia = p_id_licencia;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Licencia no encontrada.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Licencia actualizada.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_ACTUALIZAR_LICENCIA;

  -- ── CERTIFICADOS MÉDICOS ─────────────────────────────────
  PROCEDURE SP_REGISTRAR_CERT_MEDICA (
      p_id_empleado       IN  NUMBER,
      p_tipo              IN  VARCHAR2,
      p_medico            IN  VARCHAR2 DEFAULT NULL,
      p_centro_medico     IN  VARCHAR2 DEFAULT NULL,
      p_fecha_examen      IN  DATE,
      p_fecha_vencimiento IN  DATE     DEFAULT NULL,
      p_apto              IN  CHAR     DEFAULT 'S',
      p_restricciones     IN  VARCHAR2 DEFAULT NULL,
      p_resultado         OUT NUMBER,
      p_mensaje           OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_cert_medicas (
          id_empleado, tipo, medico, centro_medico,
          fecha_examen, fecha_vencimiento, apto, restricciones
      ) VALUES (
          p_id_empleado, p_tipo, p_medico, p_centro_medico,
          p_fecha_examen, p_fecha_vencimiento, p_apto, p_restricciones
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Certificado médico registrado.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_CERT_MEDICA;

  -- ── HISTORIAL SALARIAL ───────────────────────────────────
  PROCEDURE SP_REGISTRAR_CAMBIO_SALARIO (
      p_id_empleado      IN  NUMBER,
      p_salario_anterior IN  NUMBER,
      p_salario_nuevo    IN  NUMBER,
      p_motivo           IN  VARCHAR2 DEFAULT NULL,
      p_aprobado_por     IN  NUMBER   DEFAULT NULL,
      p_resultado        OUT NUMBER,
      p_mensaje          OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_hist_salarial (
          id_empleado, salario_anterior_gtq, salario_nuevo_gtq,
          motivo, aprobado_por, fecha_cambio
      ) VALUES (
          p_id_empleado, p_salario_anterior, p_salario_nuevo,
          p_motivo, p_aprobado_por, SYSDATE
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Cambio salarial registrado.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_CAMBIO_SALARIO;

  -- ── TURNOS ───────────────────────────────────────────────
  PROCEDURE SP_CREAR_TURNO (
      p_nombre         IN  VARCHAR2,
      p_tipo           IN  VARCHAR2,
      p_hora_entrada   IN  VARCHAR2,
      p_hora_salida    IN  VARCHAR2,
      p_duracion_horas IN  NUMBER   DEFAULT NULL,
      p_dias_semana    IN  VARCHAR2 DEFAULT NULL,
      p_resultado      OUT NUMBER,
      p_mensaje        OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_turnos (
          nombre, tipo, hora_entrada, hora_salida, duracion_horas, dias_semana, activo
      ) VALUES (
          p_nombre, p_tipo, p_hora_entrada, p_hora_salida, p_duracion_horas, p_dias_semana, 'S'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Turno creado correctamente.';
  EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK; p_resultado := 0; p_mensaje := 'Ya existe un turno con ese nombre.';
      WHEN OTHERS THEN
          ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_CREAR_TURNO;

  PROCEDURE SP_ASIGNAR_TURNO (
      p_id_empleado IN  NUMBER,
      p_id_turno    IN  NUMBER,
      p_fecha_desde IN  DATE,
      p_fecha_hasta IN  DATE DEFAULT NULL,
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  ) AS
      v_count NUMBER;
  BEGIN
      SELECT COUNT(*) INTO v_count
      FROM   rrhh_asign_turnos
      WHERE  id_empleado = p_id_empleado
      AND    id_turno    = p_id_turno
      AND    activo      = 'S';
      IF v_count > 0 THEN
          p_resultado := 0;
          p_mensaje   := 'El empleado ya tiene ese turno asignado y activo.';
          RETURN;
      END IF;

      INSERT INTO rrhh_asign_turnos (
          id_empleado, id_turno, fecha_desde, fecha_hasta, activo
      ) VALUES (
          p_id_empleado, p_id_turno, p_fecha_desde, p_fecha_hasta, 'S'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Turno asignado correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_ASIGNAR_TURNO;

  PROCEDURE SP_DESACTIVAR_TURNO_EMPLEADO (
      p_id_asignacion IN  NUMBER,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_asign_turnos SET activo = 'N'
      WHERE  id_asignacion = p_id_asignacion;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Asignación no encontrada.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Turno desactivado.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_DESACTIVAR_TURNO_EMPLEADO;

  -- ── ASISTENCIA ───────────────────────────────────────────
  PROCEDURE SP_REGISTRAR_ENTRADA (
      p_id_empleado IN  NUMBER,
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  ) AS
      v_count NUMBER;
  BEGIN
      SELECT COUNT(*) INTO v_count
      FROM   rrhh_asistencia
      WHERE  id_empleado = p_id_empleado
      AND    TRUNC(fecha) = TRUNC(SYSDATE)
      AND    hora_entrada IS NOT NULL
      AND    hora_salida  IS NULL;
      IF v_count > 0 THEN
          p_resultado := 0;
          p_mensaje   := 'El empleado ya tiene una entrada activa hoy.';
          RETURN;
      END IF;
      INSERT INTO rrhh_asistencia (id_empleado, fecha, hora_entrada, estado)
      VALUES (p_id_empleado, TRUNC(SYSDATE), TO_CHAR(SYSTIMESTAMP,'HH24:MI'), 'PRESENTE');
      COMMIT;
      p_resultado := 1; p_mensaje := 'Entrada registrada: ' || TO_CHAR(SYSTIMESTAMP,'HH24:MI');
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_ENTRADA;

  PROCEDURE SP_REGISTRAR_SALIDA (
      p_id_empleado IN  NUMBER,
      p_resultado   OUT NUMBER,
      p_mensaje     OUT VARCHAR2
  ) AS
      v_id_asistencia NUMBER;
  BEGIN
      SELECT id_asistencia INTO v_id_asistencia
      FROM   rrhh_asistencia
      WHERE  id_empleado = p_id_empleado
      AND    TRUNC(fecha) = TRUNC(SYSDATE)
      AND    hora_salida  IS NULL
      AND    ROWNUM = 1;

      UPDATE rrhh_asistencia
      SET    hora_salida = TO_CHAR(SYSTIMESTAMP,'HH24:MI')
      WHERE  id_asistencia = v_id_asistencia;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Salida registrada: ' || TO_CHAR(SYSTIMESTAMP,'HH24:MI');
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          p_resultado := 0; p_mensaje := 'No hay entrada activa para este empleado hoy.';
      WHEN OTHERS THEN
          ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_SALIDA;

  PROCEDURE SP_REGISTRAR_ASISTENCIA_MANUAL (
      p_id_empleado   IN  NUMBER,
      p_fecha         IN  DATE,
      p_hora_entrada  IN  VARCHAR2 DEFAULT NULL,
      p_hora_salida   IN  VARCHAR2 DEFAULT NULL,
      p_estado        IN  VARCHAR2 DEFAULT 'PRESENTE',
      p_observaciones IN  VARCHAR2 DEFAULT NULL,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_asistencia (
          id_empleado, fecha, hora_entrada, hora_salida, estado, observaciones
      ) VALUES (
          p_id_empleado, p_fecha, p_hora_entrada, p_hora_salida, p_estado, p_observaciones
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Asistencia registrada manualmente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_ASISTENCIA_MANUAL;

  -- ── TRIPULACIÓN ──────────────────────────────────────────
  PROCEDURE SP_ASIGNAR_TRIPULACION (
      p_id_empleado   IN  NUMBER,
      p_id_instancia  IN  NUMBER,
      p_rol           IN  VARCHAR2,
      p_es_comandante IN  CHAR DEFAULT 'N',
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
      v_count      NUMBER;
      v_tiene_lic  CHAR(1) := 'N';
  BEGIN
      SELECT COUNT(*) INTO v_count
      FROM   rrhh_tripulacion
      WHERE  id_empleado = p_id_empleado AND id_instancia = p_id_instancia;
      IF v_count > 0 THEN
          p_resultado := 0; p_mensaje := 'El empleado ya está asignado a este vuelo.'; RETURN;
      END IF;

      IF p_rol IN ('CAPITAN','COPILOTO') THEN
          SELECT DECODE(COUNT(*),0,'N','S') INTO v_tiene_lic
          FROM   rrhh_licencias_pil
          WHERE  id_empleado = p_id_empleado
          AND    activa = 'S'
          AND    fecha_vencimiento >= SYSDATE;
          IF v_tiene_lic = 'N' THEN
              p_resultado := 0; p_mensaje := 'El empleado no tiene licencia de piloto vigente.'; RETURN;
          END IF;
      END IF;

      INSERT INTO rrhh_tripulacion (id_empleado, id_instancia, rol, es_comandante)
      VALUES (p_id_empleado, p_id_instancia, p_rol, p_es_comandante);
      COMMIT;
      p_resultado := 1; p_mensaje := 'Tripulante asignado correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_ASIGNAR_TRIPULACION;

  PROCEDURE SP_QUITAR_TRIPULACION (
      p_id_trip_vuelo IN  NUMBER,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
      DELETE FROM rrhh_tripulacion WHERE id_trip_vuelo = p_id_trip_vuelo;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Registro de tripulación no encontrado.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Tripulante eliminado del vuelo.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_QUITAR_TRIPULACION;

  -- ── VIÁTICOS ─────────────────────────────────────────────
  PROCEDURE SP_SOLICITAR_VIATICO (
      p_id_empleado    IN  NUMBER,
      p_destino        IN  VARCHAR2,
      p_fecha_salida   IN  DATE,
      p_fecha_retorno  IN  DATE     DEFAULT NULL,
      p_monto_aprobado IN  NUMBER,
      p_aprobado_por   IN  NUMBER   DEFAULT NULL,
      p_resultado      OUT NUMBER,
      p_mensaje        OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_viaticos (
          id_empleado, destino, fecha_salida, fecha_retorno,
          monto_aprobado_gtq, aprobado_por, estado
      ) VALUES (
          p_id_empleado, p_destino, p_fecha_salida, p_fecha_retorno,
          p_monto_aprobado, p_aprobado_por, 'PENDIENTE'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Viático solicitado correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_SOLICITAR_VIATICO;

  PROCEDURE SP_LIQUIDAR_VIATICO (
      p_id_viatico    IN  NUMBER,
      p_monto_gastado IN  NUMBER,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_viaticos
      SET    monto_gastado_gtq = p_monto_gastado, estado = 'LIQUIDADO'
      WHERE  id_viatico = p_id_viatico;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Viático no encontrado.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Viático liquidado correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_LIQUIDAR_VIATICO;

  PROCEDURE SP_CAMBIAR_ESTADO_VIATICO (
      p_id_viatico IN  NUMBER,
      p_estado     IN  VARCHAR2,
      p_resultado  OUT NUMBER,
      p_mensaje    OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_viaticos SET estado = p_estado WHERE id_viatico = p_id_viatico;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Viático no encontrado.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Estado actualizado a ' || p_estado;
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_CAMBIAR_ESTADO_VIATICO;

  -- ── EQUIPO DE PROTECCIÓN ─────────────────────────────────
  PROCEDURE SP_REGISTRAR_EQUIPO_PROT (
      p_id_empleado   IN  NUMBER,
      p_tipo_equipo   IN  VARCHAR2,
      p_descripcion   IN  VARCHAR2 DEFAULT NULL,
      p_cantidad      IN  NUMBER   DEFAULT 1,
      p_fecha_entrega IN  DATE     DEFAULT NULL,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_equipo_prot (
          id_empleado, tipo_equipo, descripcion, cantidad, fecha_entrega, estado
      ) VALUES (
          p_id_empleado, p_tipo_equipo, p_descripcion, p_cantidad,
          NVL(p_fecha_entrega, SYSDATE), 'ACTIVO'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Equipo de protección registrado.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_EQUIPO_PROT;

  PROCEDURE SP_DEVOLVER_EQUIPO_PROT (
      p_id_epp           IN  NUMBER,
      p_fecha_devolucion IN  DATE,
      p_resultado        OUT NUMBER,
      p_mensaje          OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_equipo_prot
      SET    fecha_devolucion = p_fecha_devolucion, estado = 'DEVUELTO'
      WHERE  id_epp = p_id_epp;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Registro EPP no encontrado.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Devolución registrada correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_DEVOLVER_EQUIPO_PROT;

  -- ── EXPEDIENTES DISCIPLINARIOS ───────────────────────────
  PROCEDURE SP_REGISTRAR_EXPEDIENTE (
      p_id_empleado  IN  NUMBER,
      p_tipo_falta   IN  VARCHAR2,
      p_descripcion  IN  VARCHAR2,
      p_sancion      IN  VARCHAR2 DEFAULT NULL,
      p_fecha_falta  IN  DATE,
      p_aprobado_por IN  VARCHAR2 DEFAULT NULL,
      p_resultado    OUT NUMBER,
      p_mensaje      OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_exped_disc (
          id_empleado, tipo_falta, descripcion, sancion,
          fecha_falta, aprobado_por, estado
      ) VALUES (
          p_id_empleado, p_tipo_falta, p_descripcion, p_sancion,
          p_fecha_falta, p_aprobado_por, 'ABIERTO'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Expediente disciplinario registrado.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_EXPEDIENTE;

  PROCEDURE SP_CERRAR_EXPEDIENTE (
      p_id_expediente IN  NUMBER,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_exped_disc SET estado = 'CERRADO', fecha_sancion = SYSDATE
      WHERE  id_expediente = p_id_expediente;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Expediente no encontrado.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Expediente cerrado.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_CERRAR_EXPEDIENTE;

  -- ── CAPACITACIONES ───────────────────────────────────────
  PROCEDURE SP_REGISTRAR_CAPACITACION (
      p_id_empleado     IN  NUMBER,
      p_nombre_curso    IN  VARCHAR2,
      p_tipo            IN  VARCHAR2 DEFAULT NULL,
      p_proveedor       IN  VARCHAR2 DEFAULT NULL,
      p_fecha_inicio    IN  DATE     DEFAULT NULL,
      p_fecha_fin       IN  DATE     DEFAULT NULL,
      p_horas           IN  NUMBER   DEFAULT NULL,
      p_calificacion    IN  NUMBER   DEFAULT NULL,
      p_aprobado        IN  CHAR     DEFAULT 'S',
      p_certificado_url IN  VARCHAR2 DEFAULT NULL,
      p_resultado       OUT NUMBER,
      p_mensaje         OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_hist_capacit (
          id_empleado, nombre_curso, tipo, proveedor,
          fecha_inicio, fecha_fin, horas, calificacion, aprobado, certificado_url
      ) VALUES (
          p_id_empleado, p_nombre_curso, p_tipo, p_proveedor,
          p_fecha_inicio, p_fecha_fin, p_horas, p_calificacion, p_aprobado, p_certificado_url
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Capacitación registrada correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_CAPACITACION;

  -- ── FOTOS ────────────────────────────────────────────────
  PROCEDURE SP_GUARDAR_FOTO (
      p_id_empleado    IN  NUMBER,
      p_url_foto       IN  VARCHAR2 DEFAULT NULL,
      p_url_biometrico IN  VARCHAR2 DEFAULT NULL,
      p_fecha_captura  IN  DATE     DEFAULT NULL,
      p_resultado      OUT NUMBER,
      p_mensaje        OUT VARCHAR2
  ) AS
  BEGIN
      MERGE INTO rrhh_fotos tgt
      USING (SELECT p_id_empleado AS id_empleado FROM dual) src
      ON (tgt.id_empleado = src.id_empleado)
      WHEN MATCHED THEN
          UPDATE SET url_foto = NVL(p_url_foto, url_foto),
                     url_biometrico = NVL(p_url_biometrico, url_biometrico),
                     fecha_captura = NVL(p_fecha_captura, fecha_captura)
      WHEN NOT MATCHED THEN
          INSERT (id_empleado, url_foto, url_biometrico, fecha_captura, activo)
          VALUES (p_id_empleado, p_url_foto, p_url_biometrico, NVL(p_fecha_captura, SYSDATE), 'S');
      COMMIT;
      p_resultado := 1; p_mensaje := 'Foto guardada correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_GUARDAR_FOTO;

  -- ── USUARIOS DEL SISTEMA ─────────────────────────────────
  PROCEDURE SP_CREAR_USUARIO (
      p_id_empleado   IN  NUMBER,
      p_username      IN  VARCHAR2,
      p_password_hash IN  VARCHAR2,
      p_email         IN  VARCHAR2,
      p_resultado     OUT NUMBER,
      p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
      INSERT INTO rrhh_sist_usuarios (
          id_empleado, username, password_hash, email, activo, intentos_fallidos, bloqueado
      ) VALUES (
          p_id_empleado, p_username, p_password_hash, p_email, 'S', 0, 'N'
      );
      COMMIT;
      p_resultado := 1; p_mensaje := 'Usuario creado correctamente.';
  EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK;
          p_resultado := 0; p_mensaje := 'El username o empleado ya tiene usuario.';
      WHEN OTHERS THEN
          ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_CREAR_USUARIO;

  PROCEDURE SP_CAMBIAR_ESTADO_USUARIO (
      p_id_usuario IN  NUMBER,
      p_activo     IN  CHAR,
      p_resultado  OUT NUMBER,
      p_mensaje    OUT VARCHAR2
  ) AS
  BEGIN
      UPDATE rrhh_sist_usuarios SET activo = p_activo WHERE id_usuario = p_id_usuario;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Usuario no encontrado.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Estado de usuario actualizado.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_CAMBIAR_ESTADO_USUARIO;

  PROCEDURE SP_ASIGNAR_ROL (
      p_id_usuario IN  NUMBER,
      p_id_rol     IN  NUMBER,
      p_resultado  OUT NUMBER,
      p_mensaje    OUT VARCHAR2
  ) AS
      v_count NUMBER;
  BEGIN
      SELECT COUNT(*) INTO v_count FROM rrhh_roles_union
      WHERE id_usuario = p_id_usuario AND id_rol = p_id_rol;
      IF v_count > 0 THEN
          p_resultado := 0; p_mensaje := 'El usuario ya tiene ese rol.'; RETURN;
      END IF;
      INSERT INTO rrhh_roles_union (id_usuario, id_rol) VALUES (p_id_usuario, p_id_rol);
      COMMIT;
      p_resultado := 1; p_mensaje := 'Rol asignado correctamente.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_ASIGNAR_ROL;

  PROCEDURE SP_QUITAR_ROL (
      p_id_usuario IN  NUMBER,
      p_id_rol     IN  NUMBER,
      p_resultado  OUT NUMBER,
      p_mensaje    OUT VARCHAR2
  ) AS
  BEGIN
      DELETE FROM rrhh_roles_union WHERE id_usuario = p_id_usuario AND id_rol = p_id_rol;
      IF SQL%ROWCOUNT = 0 THEN
          p_resultado := 0; p_mensaje := 'Relación usuario-rol no encontrada.'; RETURN;
      END IF;
      COMMIT;
      p_resultado := 1; p_mensaje := 'Rol removido del usuario.';
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK; p_resultado := -1; p_mensaje := 'Error: ' || SQLERRM;
  END SP_QUITAR_ROL;

  PROCEDURE SP_REGISTRAR_AUDITORIA (
      p_id_usuario  IN  NUMBER,
      p_accion      IN  VARCHAR2,
      p_modulo      IN  VARCHAR2 DEFAULT NULL,
      p_entidad     IN  VARCHAR2 DEFAULT NULL,
      p_id_entidad  IN  NUMBER   DEFAULT NULL,
      p_descripcion IN  VARCHAR2 DEFAULT NULL,
      p_ip_address  IN  VARCHAR2 DEFAULT NULL,
      p_exitoso     IN  CHAR     DEFAULT 'S'
  ) AS
      PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
      INSERT INTO rrhh_log_auditoria (
          id_usuario, accion, modulo, entidad, id_entidad,
          descripcion, ip_address, exitoso
      ) VALUES (
          p_id_usuario, p_accion, p_modulo, p_entidad, p_id_entidad,
          p_descripcion, p_ip_address, p_exitoso
      );
      COMMIT;
  EXCEPTION WHEN OTHERS THEN
      ROLLBACK;
  END SP_REGISTRAR_AUDITORIA;

END PKG_RRHH_TRX;
/

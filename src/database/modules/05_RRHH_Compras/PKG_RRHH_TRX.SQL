-- ============================================================
-- PKG_RRHH_TRX.SQL
-- Módulo 5: Recursos Humanos & Compras
-- Paquete de transacciones (INSERT / UPDATE / DELETE)
-- Nodo: Principal (.10) - Solo escritura
-- ============================================================

CREATE OR REPLACE PACKAGE PKG_RRHH AS

    -- EMPLEADOS
    PROCEDURE SP_INSERTAR_EMPLEADO(
        p_id_puesto     IN  rrhh_empleados.id_puesto%TYPE,
        p_id_depto      IN  rrhh_empleados.id_depto%TYPE,
        p_codigo        IN  rrhh_empleados.codigo_empleado%TYPE,
        p_nombres       IN  rrhh_empleados.nombres%TYPE,
        p_apellidos     IN  rrhh_empleados.apellidos%TYPE,
        p_dpi           IN  rrhh_empleados.dpi%TYPE,
        p_email         IN  rrhh_empleados.email_corporativo%TYPE,
        p_fecha_ingreso IN  rrhh_empleados.fecha_ingreso%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    );

    PROCEDURE SP_ACTUALIZAR_ESTADO_EMPLEADO(
        p_id_empleado   IN  rrhh_empleados.id_empleado%TYPE,
        p_estado        IN  rrhh_empleados.activo%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    );

    -- CONTRATOS
    PROCEDURE SP_REGISTRAR_CONTRATO(
        p_id_empleado   IN  rrhh_contratos.id_empleado%TYPE,
        p_tipo          IN  rrhh_contratos.tipo_contrato%TYPE,
        p_fecha_inicio  IN  rrhh_contratos.fecha_inicio%TYPE,
        p_salario       IN  rrhh_contratos.salario_base%TYPE,
        p_jornada       IN  rrhh_contratos.jornada%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    );

    -- TURNOS
    PROCEDURE SP_ASIGNAR_TURNO(
        p_id_empleado   IN  rrhh_asignacion_turnos.id_empleado%TYPE,
        p_id_turno      IN  rrhh_asignacion_turnos.id_turno%TYPE,
        p_fecha_desde   IN  rrhh_asignacion_turnos.fecha_desde%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    );

    -- ASISTENCIA
    PROCEDURE SP_REGISTRAR_ENTRADA(
        p_id_empleado   IN  rrhh_asistencia.id_empleado%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    );

    -- TRIPULACION
    PROCEDURE SP_ASIGNAR_TRIPULACION(
        p_id_empleado   IN  oper_tripulacion_vuelo.id_empleado%TYPE,
        p_id_instancia  IN  oper_tripulacion_vuelo.id_instancia%TYPE,
        p_rol           IN  oper_tripulacion_vuelo.rol%TYPE,
        p_comandante    IN  oper_tripulacion_vuelo.es_comandante%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    );

END PKG_RRHH;
/

CREATE OR REPLACE PACKAGE BODY PKG_RRHH AS

    -- ─────────────────────────────────────────────
    -- SP_INSERTAR_EMPLEADO
    -- ─────────────────────────────────────────────
    PROCEDURE SP_INSERTAR_EMPLEADO(
        p_id_puesto     IN  rrhh_empleados.id_puesto%TYPE,
        p_id_depto      IN  rrhh_empleados.id_depto%TYPE,
        p_codigo        IN  rrhh_empleados.codigo_empleado%TYPE,
        p_nombres       IN  rrhh_empleados.nombres%TYPE,
        p_apellidos     IN  rrhh_empleados.apellidos%TYPE,
        p_dpi           IN  rrhh_empleados.dpi%TYPE,
        p_email         IN  rrhh_empleados.email_corporativo%TYPE,
        p_fecha_ingreso IN  rrhh_empleados.fecha_ingreso%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO rrhh_empleados (
            id_puesto, id_depto, codigo_empleado,
            nombres, apellidos, dpi,
            email_corporativo, fecha_ingreso, activo
        ) VALUES (
            p_id_puesto, p_id_depto, p_codigo,
            p_nombres, p_apellidos, p_dpi,
            p_email, p_fecha_ingreso, 'S'
        );
        COMMIT;
        p_resultado := 1;
        p_mensaje   := 'Empleado registrado exitosamente.';
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: El código o DPI ya existe.';
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: ' || SQLERRM;
    END SP_INSERTAR_EMPLEADO;

    -- ─────────────────────────────────────────────
    -- SP_ACTUALIZAR_ESTADO_EMPLEADO
    -- ─────────────────────────────────────────────
    PROCEDURE SP_ACTUALIZAR_ESTADO_EMPLEADO(
        p_id_empleado   IN  rrhh_empleados.id_empleado%TYPE,
        p_estado        IN  rrhh_empleados.activo%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    ) AS
    BEGIN
        UPDATE rrhh_empleados
        SET    activo = p_estado
        WHERE  id_empleado = p_id_empleado;

        IF SQL%ROWCOUNT = 0 THEN
            p_resultado := 0;
            p_mensaje   := 'Empleado no encontrado.';
        ELSE
            COMMIT;
            p_resultado := 1;
            p_mensaje   := 'Estado actualizado correctamente.';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: ' || SQLERRM;
    END SP_ACTUALIZAR_ESTADO_EMPLEADO;

    -- ─────────────────────────────────────────────
    -- SP_REGISTRAR_CONTRATO
    -- ─────────────────────────────────────────────
    PROCEDURE SP_REGISTRAR_CONTRATO(
        p_id_empleado   IN  rrhh_contratos.id_empleado%TYPE,
        p_tipo          IN  rrhh_contratos.tipo_contrato%TYPE,
        p_fecha_inicio  IN  rrhh_contratos.fecha_inicio%TYPE,
        p_salario       IN  rrhh_contratos.salario_base%TYPE,
        p_jornada       IN  rrhh_contratos.jornada%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO rrhh_contratos (
            id_empleado, tipo_contrato,
            fecha_inicio, salario_base, jornada
        ) VALUES (
            p_id_empleado, p_tipo,
            p_fecha_inicio, p_salario, p_jornada
        );
        COMMIT;
        p_resultado := 1;
        p_mensaje   := 'Contrato registrado exitosamente.';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: ' || SQLERRM;
    END SP_REGISTRAR_CONTRATO;

    -- ─────────────────────────────────────────────
    -- SP_ASIGNAR_TURNO
    -- ─────────────────────────────────────────────
    PROCEDURE SP_ASIGNAR_TURNO(
        p_id_empleado   IN  rrhh_asignacion_turnos.id_empleado%TYPE,
        p_id_turno      IN  rrhh_asignacion_turnos.id_turno%TYPE,
        p_fecha_desde   IN  rrhh_asignacion_turnos.fecha_desde%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO rrhh_asignacion_turnos (
            id_empleado, id_turno, fecha_desde
        ) VALUES (
            p_id_empleado, p_id_turno, p_fecha_desde
        );
        COMMIT;
        p_resultado := 1;
        p_mensaje   := 'Turno asignado correctamente.';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: ' || SQLERRM;
    END SP_ASIGNAR_TURNO;

    -- ─────────────────────────────────────────────
    -- SP_REGISTRAR_ENTRADA
    -- ─────────────────────────────────────────────
    PROCEDURE SP_REGISTRAR_ENTRADA(
        p_id_empleado   IN  rrhh_asistencia.id_empleado%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO rrhh_asistencia (
            id_empleado, fecha_hora_entrada
        ) VALUES (
            p_id_empleado, SYSTIMESTAMP
        );
        COMMIT;
        p_resultado := 1;
        p_mensaje   := 'Entrada registrada: ' ||
                       TO_CHAR(SYSTIMESTAMP, 'DD/MM/YYYY HH24:MI');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: ' || SQLERRM;
    END SP_REGISTRAR_ENTRADA;

    -- ─────────────────────────────────────────────
    -- SP_ASIGNAR_TRIPULACION
    -- ─────────────────────────────────────────────
    PROCEDURE SP_ASIGNAR_TRIPULACION(
        p_id_empleado   IN  oper_tripulacion_vuelo.id_empleado%TYPE,
        p_id_instancia  IN  oper_tripulacion_vuelo.id_instancia%TYPE,
        p_rol           IN  oper_tripulacion_vuelo.rol%TYPE,
        p_comandante    IN  oper_tripulacion_vuelo.es_comandante%TYPE,
        p_resultado     OUT NUMBER,
        p_mensaje       OUT VARCHAR2
    ) AS
    BEGIN
        INSERT INTO oper_tripulacion_vuelo (
            id_empleado, id_instancia,
            rol, es_comandante
        ) VALUES (
            p_id_empleado, p_id_instancia,
            p_rol, p_comandante
        );
        COMMIT;
        p_resultado := 1;
        p_mensaje   := 'Tripulante asignado correctamente.';
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: El empleado ya está asignado a este vuelo.';
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 0;
            p_mensaje   := 'Error: ' || SQLERRM;
    END SP_ASIGNAR_TRIPULACION;

END PKG_RRHH;
/
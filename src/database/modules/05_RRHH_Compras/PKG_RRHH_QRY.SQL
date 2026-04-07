-- ============================================================
-- PKG_RRHH_QRY.SQL
-- Módulo 5: Recursos Humanos & Compras
-- Paquete de consultas (SELECT / Reportes)
-- Nodo: Réplica (.20) - Solo lectura
-- ============================================================

CREATE OR REPLACE PACKAGE PKG_RRHH_QRY AS

    PROCEDURE SP_OBTENER_EMPLEADOS(
        p_cursor    OUT SYS_REFCURSOR
    );

    PROCEDURE SP_OBTENER_EMPLEADO_POR_ID(
        p_id_empleado   IN  rrhh_empleados.id_empleado%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

    PROCEDURE SP_OBTENER_DEPARTAMENTOS(
        p_cursor    OUT SYS_REFCURSOR
    );

    PROCEDURE SP_OBTENER_PUESTOS(
        p_cursor    OUT SYS_REFCURSOR
    );

    PROCEDURE SP_OBTENER_TURNOS(
        p_cursor    OUT SYS_REFCURSOR
    );

    PROCEDURE SP_REPORTE_ASISTENCIA_MES(
        p_id_empleado   IN  rrhh_asistencia.id_empleado%TYPE,
        p_anio          IN  NUMBER,
        p_mes           IN  NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    );

    PROCEDURE SP_OBTENER_TRIPULACION_VUELO(
        p_id_instancia  IN  oper_tripulacion_vuelo.id_instancia%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    );

END PKG_RRHH_QRY;
/

CREATE OR REPLACE PACKAGE BODY PKG_RRHH_QRY AS

    PROCEDURE SP_OBTENER_EMPLEADOS(
        p_cursor    OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT  e.id_empleado,
                    e.codigo_empleado,
                    e.nombres || ' ' || e.apellidos AS nombre_completo,
                    e.dpi,
                    e.email_corporativo,
                    p.nombre_puesto,
                    d.nombre_depto,
                    e.fecha_ingreso,
                    CASE e.activo WHEN 'S' THEN 'ACTIVO' ELSE 'INACTIVO' END AS estado
            FROM    rrhh_empleados  e
            JOIN    rrhh_puestos    p ON e.id_puesto = p.id_puesto
            JOIN    rrhh_deptos     d ON e.id_depto  = d.id_depto
            ORDER BY e.apellidos, e.nombres;
    END SP_OBTENER_EMPLEADOS;

    PROCEDURE SP_OBTENER_EMPLEADO_POR_ID(
        p_id_empleado   IN  rrhh_empleados.id_empleado%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT  e.id_empleado,
                    e.codigo_empleado,
                    e.nombres,
                    e.apellidos,
                    e.dpi,
                    e.email_corporativo,
                    e.fecha_ingreso,
                    e.activo
            FROM    rrhh_empleados e
            WHERE   e.id_empleado = p_id_empleado;
    END SP_OBTENER_EMPLEADO_POR_ID;

    PROCEDURE SP_OBTENER_DEPARTAMENTOS(
        p_cursor    OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT  id_depto,
                    nombre_depto,
                    descripcion
            FROM    rrhh_deptos
            ORDER BY nombre_depto;
    END SP_OBTENER_DEPARTAMENTOS;

    PROCEDURE SP_OBTENER_PUESTOS(
        p_cursor    OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT  p.id_puesto,
                    p.nombre_puesto,
                    p.nivel,
                    d.nombre_depto
            FROM    rrhh_puestos p
            JOIN    rrhh_deptos  d ON p.id_depto = d.id_depto
            ORDER BY p.nombre_puesto;
    END SP_OBTENER_PUESTOS;

    PROCEDURE SP_OBTENER_TURNOS(
        p_cursor    OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT  id_turno,
                    nombre_turno,
                    hora_entrada,
                    hora_salida,
                    dias_semana
            FROM    rrhh_turnos
            ORDER BY nombre_turno;
    END SP_OBTENER_TURNOS;

    PROCEDURE SP_REPORTE_ASISTENCIA_MES(
        p_id_empleado   IN  rrhh_asistencia.id_empleado%TYPE,
        p_anio          IN  NUMBER,
        p_mes           IN  NUMBER,
        p_cursor        OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT  a.id_asistencia,
                    e.nombres || ' ' || e.apellidos AS empleado,
                    a.fecha_hora_entrada,
                    a.fecha_hora_salida,
                    ROUND((a.fecha_hora_salida - a.fecha_hora_entrada) * 24, 2)
                        AS horas_trabajadas
            FROM    rrhh_asistencia a
            JOIN    rrhh_empleados  e ON a.id_empleado = e.id_empleado
            WHERE   a.id_empleado = p_id_empleado
            AND     EXTRACT(YEAR  FROM a.fecha_hora_entrada) = p_anio
            AND     EXTRACT(MONTH FROM a.fecha_hora_entrada) = p_mes
            ORDER BY a.fecha_hora_entrada;
    END SP_REPORTE_ASISTENCIA_MES;

    PROCEDURE SP_OBTENER_TRIPULACION_VUELO(
        p_id_instancia  IN  oper_tripulacion_vuelo.id_instancia%TYPE,
        p_cursor        OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_cursor FOR
            SELECT  e.codigo_empleado,
                    e.nombres || ' ' || e.apellidos AS nombre_completo,
                    t.rol,
                    t.es_comandante
            FROM    oper_tripulacion_vuelo t
            JOIN    rrhh_empleados         e ON t.id_empleado = e.id_empleado
            WHERE   t.id_instancia = p_id_instancia
            ORDER BY t.rol;
    END SP_OBTENER_TRIPULACION_VUELO;

END PKG_RRHH_QRY;
/
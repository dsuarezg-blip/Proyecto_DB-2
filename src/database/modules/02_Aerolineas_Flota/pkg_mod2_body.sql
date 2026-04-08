-- ============================================================
--  PKG_AEROLINEAS_FLOTA — CUERPO (BODY)
--  Modulo 2: Aerolineas & Flota
--  Sistema Aeropuerto Internacional La Aurora
--  Oracle 21c — PDB: AERO_LA_AURORA
-- ============================================================

CREATE OR REPLACE PACKAGE BODY PKG_AEROLINEAS_FLOTA AS

-- ============================================================
-- SECCION 1: GESTION DE AEROLINEAS
-- ============================================================

  PROCEDURE SP_INSERTAR_AEROLINEA(
    p_codigo_iata   IN  VARCHAR2,
    p_codigo_icao   IN  VARCHAR2,
    p_nombre        IN  VARCHAR2,
    p_pais_origen   IN  NUMBER,
    p_sitio_web     IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    -- Verificar que el codigo IATA no exista
    SELECT COUNT(*) INTO v_existe
    FROM   linea_aerolineas
    WHERE  codigo_iata = UPPER(p_codigo_iata);

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Error: Ya existe una aerolinea con el codigo IATA ' || UPPER(p_codigo_iata);
      RETURN;
    END IF;

    -- Verificar que el codigo ICAO no exista
    SELECT COUNT(*) INTO v_existe
    FROM   linea_aerolineas
    WHERE  codigo_icao = UPPER(p_codigo_icao);

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Error: Ya existe una aerolinea con el codigo ICAO ' || UPPER(p_codigo_icao);
      RETURN;
    END IF;

    -- Verificar que el pais exista
    SELECT COUNT(*) INTO v_existe
    FROM   geog_paises
    WHERE  id_pais = p_pais_origen;

    IF v_existe = 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Error: El pais de origen con ID ' || p_pais_origen || ' no existe.';
      RETURN;
    END IF;

    INSERT INTO linea_aerolineas (
      codigo_iata, codigo_icao, nombre, pais_origen, sitio_web, activa
    ) VALUES (
      UPPER(p_codigo_iata), UPPER(p_codigo_icao), p_nombre, p_pais_origen,
      p_sitio_web, 'S'
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Aerolinea "' || p_nombre || '" registrada exitosamente.';

  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      ROLLBACK;
      p_resultado := 0;
      p_mensaje   := 'Error: Codigo IATA o ICAO ya existe en el sistema.';
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error inesperado: ' || SQLERRM;
  END SP_INSERTAR_AEROLINEA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_AEROLINEAS(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        a.id_aerolinea,
        a.codigo_iata,
        a.codigo_icao,
        a.nombre,
        p.nombre        AS pais_origen,
        a.sitio_web,
        a.activa,
        a.creado_en
      FROM  linea_aerolineas a
      JOIN  geog_paises       p ON a.pais_origen = p.id_pais
      ORDER BY a.nombre;
  END SP_OBTENER_AEROLINEAS;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_AEROLINEA_POR_ID(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        a.id_aerolinea,
        a.codigo_iata,
        a.codigo_icao,
        a.nombre,
        a.pais_origen,
        p.nombre        AS nombre_pais,
        a.sitio_web,
        a.activa,
        a.creado_en,
        FN_CONTAR_AVIONES_AEROLINEA(a.id_aerolinea) AS total_aviones
      FROM  linea_aerolineas a
      JOIN  geog_paises       p ON a.pais_origen = p.id_pais
      WHERE a.id_aerolinea = p_id_aerolinea;
  END SP_OBTENER_AEROLINEA_POR_ID;

  ---------------------------------------------------------------

  PROCEDURE SP_ACTUALIZAR_AEROLINEA(
    p_id_aerolinea  IN  NUMBER,
    p_nombre        IN  VARCHAR2,
    p_sitio_web     IN  VARCHAR2,
    p_activa        IN  CHAR,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM   linea_aerolineas
    WHERE  id_aerolinea = p_id_aerolinea;

    IF v_existe = 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Error: Aerolinea con ID ' || p_id_aerolinea || ' no encontrada.';
      RETURN;
    END IF;

    UPDATE linea_aerolineas
    SET    nombre         = p_nombre,
           sitio_web      = p_sitio_web,
           activa         = p_activa
    WHERE  id_aerolinea   = p_id_aerolinea;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Aerolinea actualizada correctamente.';

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error al actualizar: ' || SQLERRM;
  END SP_ACTUALIZAR_AEROLINEA;

  ---------------------------------------------------------------

  PROCEDURE SP_CAMBIAR_ESTADO_AEROLINEA(
    p_id_aerolinea  IN  NUMBER,
    p_activa        IN  CHAR,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_aviones_activos NUMBER := 0;
  BEGIN
    -- Si se desactiva, verificar que no tenga aviones en vuelo
    IF p_activa = 'N' THEN
      SELECT COUNT(*) INTO v_aviones_activos
      FROM   flota_aviones f
      JOIN   oper_vuelos_instancia v ON f.id_avion = v.id_avion
      WHERE  f.id_aerolinea = p_id_aerolinea
      AND    v.estado IN ('DESPEGADO', 'EN_PROCESO');

      IF v_aviones_activos > 0 THEN
        p_resultado := 0;
        p_mensaje   := 'No se puede desactivar: la aerolinea tiene ' ||
                       v_aviones_activos || ' vuelo(s) activo(s) en este momento.';
        RETURN;
      END IF;
    END IF;

    UPDATE linea_aerolineas
    SET    activa = p_activa
    WHERE  id_aerolinea = p_id_aerolinea;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Estado cambiado a ' ||
                   CASE p_activa WHEN 'S' THEN 'ACTIVA' ELSE 'INACTIVA' END ||
                   ' correctamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_CAMBIAR_ESTADO_AEROLINEA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_AEROLINEAS_ACTIVAS(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT a.id_aerolinea, a.codigo_iata, a.codigo_icao, a.nombre,
             p.nombre AS pais, a.sitio_web
      FROM   linea_aerolineas a
      JOIN   geog_paises       p ON a.pais_origen = p.id_pais
      WHERE  a.activa = 'S'
      ORDER BY a.nombre;
  END SP_OBTENER_AEROLINEAS_ACTIVAS;

  ---------------------------------------------------------------

  FUNCTION FN_BUSCAR_POR_IATA(
    p_codigo_iata IN VARCHAR2
  ) RETURN SYS_REFCURSOR AS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
      SELECT a.id_aerolinea, a.codigo_iata, a.codigo_icao, a.nombre,
             p.nombre AS pais, a.activa
      FROM   linea_aerolineas a
      JOIN   geog_paises       p ON a.pais_origen = p.id_pais
      WHERE  a.codigo_iata = UPPER(p_codigo_iata);
    RETURN v_cursor;
  END FN_BUSCAR_POR_IATA;

  ---------------------------------------------------------------

  FUNCTION FN_CONTAR_AEROLINEAS_ACTIVAS RETURN NUMBER AS
    v_total NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_total
    FROM   linea_aerolineas
    WHERE  activa = 'S';
    RETURN v_total;
  END FN_CONTAR_AEROLINEAS_ACTIVAS;

-- ============================================================
-- SECCION 2: GESTION DE ALIANZAS
-- ============================================================

  PROCEDURE SP_INSERTAR_ALIANZA(
    p_nombre        IN  VARCHAR2,
    p_anno_fund     IN  NUMBER,
    p_sede          IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM   linea_alianzas
    WHERE  UPPER(nombre) = UPPER(p_nombre);

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'La alianza "' || p_nombre || '" ya existe.';
      RETURN;
    END IF;

    INSERT INTO linea_alianzas (nombre, anno_fundacion, sede)
    VALUES (p_nombre, p_anno_fund, p_sede);

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Alianza "' || p_nombre || '" registrada exitosamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_INSERTAR_ALIANZA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_ALIANZAS(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT id_alianza, nombre, anno_fundacion, sede
      FROM   linea_alianzas
      ORDER BY nombre;
  END SP_OBTENER_ALIANZAS;

  ---------------------------------------------------------------

  PROCEDURE SP_ASIGNAR_AEROLINEA_ALIANZA(
    p_id_aerolinea  IN  NUMBER,
    p_id_alianza    IN  NUMBER,
    p_fecha_ingreso IN  DATE,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM   linea_alianzas_union
    WHERE  id_aerolinea = p_id_aerolinea
    AND    id_alianza   = p_id_alianza
    AND    activo       = 'S';

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'La aerolinea ya pertenece a esta alianza.';
      RETURN;
    END IF;

    INSERT INTO linea_alianzas_union (id_aerolinea, id_alianza, fecha_ingreso, activo)
    VALUES (p_id_aerolinea, p_id_alianza, NVL(p_fecha_ingreso, SYSDATE), 'S');

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Aerolinea asignada a la alianza exitosamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_ASIGNAR_AEROLINEA_ALIANZA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_ALIANZAS_AEROLINEA(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT al.id_alianza, al.nombre, al.anno_fundacion, al.sede,
             u.fecha_ingreso, u.activo
      FROM   linea_alianzas_union u
      JOIN   linea_alianzas       al ON u.id_alianza = al.id_alianza
      WHERE  u.id_aerolinea = p_id_aerolinea
      ORDER BY al.nombre;
  END SP_OBTENER_ALIANZAS_AEROLINEA;

-- ============================================================
-- SECCION 3: GESTION DE MODELOS DE AVION
-- ============================================================

  PROCEDURE SP_INSERTAR_MODELO(
    p_id_aerolinea    IN  NUMBER,
    p_fabricante      IN  VARCHAR2,
    p_modelo          IN  VARCHAR2,
    p_cap_pax_max     IN  NUMBER,
    p_alcance_km      IN  NUMBER,
    p_autonomia_horas IN  NUMBER,
    p_resultado       OUT NUMBER,
    p_mensaje         OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    -- Verificar que la aerolinea exista
    SELECT COUNT(*) INTO v_existe
    FROM   linea_aerolineas
    WHERE  id_aerolinea = p_id_aerolinea;

    IF v_existe = 0 THEN
      p_resultado := 0;
      p_mensaje   := 'La aerolinea con ID ' || p_id_aerolinea || ' no existe.';
      RETURN;
    END IF;

    IF p_cap_pax_max <= 0 THEN
      p_resultado := 0;
      p_mensaje   := 'La capacidad maxima de pasajeros debe ser mayor a cero.';
      RETURN;
    END IF;

    INSERT INTO flota_modelos (
      id_aerolinea, fabricante, modelo, capacidad_pax_max,
      alcance_km, autonomia_horas
    ) VALUES (
      p_id_aerolinea, p_fabricante, p_modelo,
      p_cap_pax_max, p_alcance_km, p_autonomia_horas
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Modelo ' || p_fabricante || ' ' || p_modelo || ' registrado exitosamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_INSERTAR_MODELO;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_MODELOS_AEROLINEA(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT m.id_modelo, m.fabricante, m.modelo,
             m.capacidad_pax_max, m.alcance_km, m.autonomia_horas,
             COUNT(a.id_avion) AS aviones_en_flota
      FROM   flota_modelos m
      LEFT JOIN flota_aviones a ON m.id_modelo = a.id_modelo AND a.activo = 'S'
      WHERE  m.id_aerolinea = p_id_aerolinea
      GROUP BY m.id_modelo, m.fabricante, m.modelo,
               m.capacidad_pax_max, m.alcance_km, m.autonomia_horas
      ORDER BY m.fabricante, m.modelo;
  END SP_OBTENER_MODELOS_AEROLINEA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_TODOS_MODELOS(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT m.id_modelo, la.codigo_iata, la.nombre AS aerolinea,
             m.fabricante, m.modelo, m.capacidad_pax_max,
             m.alcance_km, m.autonomia_horas
      FROM   flota_modelos     m
      JOIN   linea_aerolineas  la ON m.id_aerolinea = la.id_aerolinea
      ORDER BY la.nombre, m.fabricante, m.modelo;
  END SP_OBTENER_TODOS_MODELOS;

  ---------------------------------------------------------------

  PROCEDURE SP_ACTUALIZAR_MODELO(
    p_id_modelo       IN  NUMBER,
    p_fabricante      IN  VARCHAR2,
    p_modelo          IN  VARCHAR2,
    p_cap_pax_max     IN  NUMBER,
    p_alcance_km      IN  NUMBER,
    p_resultado       OUT NUMBER,
    p_mensaje         OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM flota_modelos WHERE id_modelo = p_id_modelo;

    IF v_existe = 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Modelo con ID ' || p_id_modelo || ' no encontrado.';
      RETURN;
    END IF;

    UPDATE flota_modelos
    SET    fabricante        = p_fabricante,
           modelo            = p_modelo,
           capacidad_pax_max = p_cap_pax_max,
           alcance_km        = p_alcance_km
    WHERE  id_modelo = p_id_modelo;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Modelo actualizado correctamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_ACTUALIZAR_MODELO;

-- ============================================================
-- SECCION 4: GESTION DE AVIONES (FLOTA)
-- ============================================================

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
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    -- Verificar matricula unica
    SELECT COUNT(*) INTO v_existe
    FROM   flota_aviones
    WHERE  matricula = UPPER(p_matricula);

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'La matricula ' || UPPER(p_matricula) || ' ya esta registrada.';
      RETURN;
    END IF;

    -- Verificar numero de serie unico
    SELECT COUNT(*) INTO v_existe
    FROM   flota_aviones
    WHERE  numero_serie = p_numero_serie;

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'El numero de serie ya esta registrado para otro avion.';
      RETURN;
    END IF;

    -- Validar año de fabricacion razonable
    IF p_anno_fab < 1950 OR p_anno_fab > EXTRACT(YEAR FROM SYSDATE) THEN
      p_resultado := 0;
      p_mensaje   := 'Anno de fabricacion invalido: ' || p_anno_fab;
      RETURN;
    END IF;

    INSERT INTO flota_aviones (
      id_modelo, id_aerolinea, id_config, matricula,
      numero_serie, anno_fabricacion, estado, horas_vuelo_total,
      ciclos_total, activo
    ) VALUES (
      p_id_modelo, p_id_aerolinea, p_id_config, UPPER(p_matricula),
      p_numero_serie, p_anno_fab, 'OPERATIVO', 0, 0, 'S'
    ) RETURNING id_avion INTO p_id_avion;

    -- Registrar estado inicial en historial
    INSERT INTO flota_estado_avion (
      id_avion, estado_anterior, estado_nuevo, motivo, registrado_en
    ) VALUES (
      p_id_avion, NULL, 'OPERATIVO', 'Registro inicial del avion', SYSTIMESTAMP
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Avion con matricula ' || UPPER(p_matricula) || ' registrado exitosamente. ID: ' || p_id_avion;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_id_avion  := NULL;
      p_resultado := -1;
      p_mensaje   := 'Error al registrar avion: ' || SQLERRM;
  END SP_REGISTRAR_AVION;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_FLOTA(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        av.id_avion,
        av.matricula,
        av.numero_serie,
        la.codigo_iata       AS aerolinea_iata,
        la.nombre            AS aerolinea,
        mo.fabricante,
        mo.modelo,
        av.anno_fabricacion,
        av.estado,
        av.horas_vuelo_total,
        av.ciclos_total,
        av.activo
      FROM  flota_aviones     av
      JOIN  flota_modelos     mo ON av.id_modelo    = mo.id_modelo
      JOIN  linea_aerolineas  la ON av.id_aerolinea = la.id_aerolinea
      ORDER BY la.nombre, av.matricula;
  END SP_OBTENER_FLOTA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_FLOTA_AEROLINEA(
    p_id_aerolinea IN  NUMBER,
    p_cursor       OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        av.id_avion,
        av.matricula,
        av.numero_serie,
        mo.fabricante,
        mo.modelo,
        av.anno_fabricacion,
        av.estado,
        av.horas_vuelo_total,
        av.ciclos_total,
        FN_TIENE_CERTIFICADOS_VIGENTES(av.id_avion) AS certs_vigentes
      FROM  flota_aviones av
      JOIN  flota_modelos mo ON av.id_modelo = mo.id_modelo
      WHERE av.id_aerolinea = p_id_aerolinea
      AND   av.activo = 'S'
      ORDER BY av.estado, av.matricula;
  END SP_OBTENER_FLOTA_AEROLINEA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_AVION_POR_ID(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        av.id_avion,
        av.matricula,
        av.numero_serie,
        la.id_aerolinea,
        la.codigo_iata       AS iata,
        la.nombre            AS aerolinea,
        mo.id_modelo,
        mo.fabricante,
        mo.modelo,
        mo.capacidad_pax_max,
        av.anno_fabricacion,
        av.estado,
        av.horas_vuelo_total,
        av.ciclos_total,
        pb.peso_vacio_kg,
        pb.peso_max_despegue_kg,
        pb.combustible_max_kg,
        av.activo,
        av.creado_en
      FROM  flota_aviones        av
      JOIN  flota_modelos        mo ON av.id_modelo    = mo.id_modelo
      JOIN  linea_aerolineas     la ON av.id_aerolinea = la.id_aerolinea
      LEFT JOIN flota_peso_balance pb ON av.id_avion   = pb.id_avion
      WHERE av.id_avion = p_id_avion;
  END SP_OBTENER_AVION_POR_ID;

  ---------------------------------------------------------------

  PROCEDURE SP_CAMBIAR_ESTADO_AVION(
    p_id_avion      IN  NUMBER,
    p_nuevo_estado  IN  VARCHAR2,
    p_motivo        IN  VARCHAR2,
    p_id_empleado   IN  NUMBER DEFAULT NULL,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_estado_actual VARCHAR2(25);
    v_estados_validos VARCHAR2(200) :=
      'OPERATIVO,EN_MANTENIMIENTO,EN_REPARACION,RETIRADO,ARRENDADO,EN_INSPECCION';
  BEGIN
    -- Obtener estado actual
    SELECT estado INTO v_estado_actual
    FROM   flota_aviones
    WHERE  id_avion = p_id_avion;

    -- Validar que el nuevo estado sea permitido
    IF INSTR(',' || v_estados_validos || ',', ',' || p_nuevo_estado || ',') = 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Estado invalido: ' || p_nuevo_estado ||
                     '. Valores permitidos: ' || v_estados_validos;
      RETURN;
    END IF;

    -- No se puede reactivar un avion retirado
    IF v_estado_actual = 'RETIRADO' AND p_nuevo_estado != 'RETIRADO' THEN
      p_resultado := 0;
      p_mensaje   := 'Un avion RETIRADO no puede cambiar a otro estado.';
      RETURN;
    END IF;

    -- Actualizar estado
    UPDATE flota_aviones
    SET    estado         = p_nuevo_estado,
           actualizado_en = SYSTIMESTAMP
    WHERE  id_avion = p_id_avion;

    -- Registrar en historial de estados
    INSERT INTO flota_estado_avion (
      id_avion, estado_anterior, estado_nuevo, motivo, id_empleado, registrado_en
    ) VALUES (
      p_id_avion, v_estado_actual, p_nuevo_estado, p_motivo, p_id_empleado, SYSTIMESTAMP
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Estado del avion cambiado de ' || v_estado_actual ||
                   ' a ' || p_nuevo_estado || ' correctamente.';

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_resultado := 0;
      p_mensaje   := 'Avion con ID ' || p_id_avion || ' no encontrado.';
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_CAMBIAR_ESTADO_AVION;

  ---------------------------------------------------------------

  PROCEDURE SP_ACTUALIZAR_HORAS_VUELO(
    p_id_avion      IN  NUMBER,
    p_horas_nuevas  IN  NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
    IF p_horas_nuevas < 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Las horas de vuelo no pueden ser negativas.';
      RETURN;
    END IF;

    UPDATE flota_aviones
    SET    horas_vuelo_total = horas_vuelo_total + p_horas_nuevas,
           ciclos_total      = ciclos_total + 1,
           actualizado_en    = SYSTIMESTAMP
    WHERE  id_avion = p_id_avion;

    IF SQL%ROWCOUNT = 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Avion con ID ' || p_id_avion || ' no encontrado.';
      RETURN;
    END IF;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := p_horas_nuevas || ' horas acumuladas correctamente al avion ID ' || p_id_avion;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_ACTUALIZAR_HORAS_VUELO;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_AVIONES_OPERATIVOS(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT av.id_avion, av.matricula, la.codigo_iata,
             la.nombre AS aerolinea, mo.fabricante, mo.modelo,
             av.horas_vuelo_total
      FROM   flota_aviones    av
      JOIN   flota_modelos    mo ON av.id_modelo    = mo.id_modelo
      JOIN   linea_aerolineas la ON av.id_aerolinea = la.id_aerolinea
      WHERE  av.estado = 'OPERATIVO'
      AND    av.activo = 'S'
      ORDER BY la.nombre, av.matricula;
  END SP_OBTENER_AVIONES_OPERATIVOS;

  ---------------------------------------------------------------

  FUNCTION FN_AVION_DISPONIBLE(
    p_id_avion IN NUMBER
  ) RETURN CHAR AS
    v_estado    VARCHAR2(25);
    v_en_vuelo  NUMBER := 0;
  BEGIN
    SELECT estado INTO v_estado
    FROM   flota_aviones
    WHERE  id_avion = p_id_avion;

    IF v_estado != 'OPERATIVO' THEN
      RETURN 'N';
    END IF;

    -- Verificar que no este asignado a un vuelo activo
    SELECT COUNT(*) INTO v_en_vuelo
    FROM   oper_vuelos_instancia
    WHERE  id_avion = p_id_avion
    AND    estado IN ('PROGRAMADO', 'EN_PROCESO', 'DESPEGADO');

    IF v_en_vuelo > 0 THEN
      RETURN 'N';
    END IF;

    RETURN 'S';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'N';
    WHEN OTHERS THEN
      RETURN 'N';
  END FN_AVION_DISPONIBLE;

  ---------------------------------------------------------------

  FUNCTION FN_OBTENER_MATRICULA(
    p_id_avion IN NUMBER
  ) RETURN VARCHAR2 AS
    v_matricula VARCHAR2(20);
  BEGIN
    SELECT matricula INTO v_matricula
    FROM   flota_aviones
    WHERE  id_avion = p_id_avion;
    RETURN v_matricula;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END FN_OBTENER_MATRICULA;

  ---------------------------------------------------------------

  FUNCTION FN_CONTAR_AVIONES_AEROLINEA(
    p_id_aerolinea IN NUMBER
  ) RETURN NUMBER AS
    v_total NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_total
    FROM   flota_aviones
    WHERE  id_aerolinea = p_id_aerolinea
    AND    activo = 'S';
    RETURN v_total;
  END FN_CONTAR_AVIONES_AEROLINEA;

-- ============================================================
-- SECCION 5: MANTENIMIENTO
-- ============================================================

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
  ) AS
    v_estado VARCHAR2(25);
  BEGIN
    SELECT estado INTO v_estado
    FROM   flota_aviones WHERE id_avion = p_id_avion;

    INSERT INTO flota_hist_manten (
      id_avion, tipo, descripcion, fecha_inicio, fecha_fin,
      proveedor, costo_usd
    ) VALUES (
      p_id_avion, p_tipo, p_descripcion, p_fecha_inicio,
      p_fecha_fin, p_proveedor, p_costo_usd
    );

    -- Si el avion no estaba en mantenimiento, cambiar su estado
    IF v_estado = 'OPERATIVO' THEN
      UPDATE flota_aviones
      SET    estado = 'EN_MANTENIMIENTO', actualizado_en = SYSTIMESTAMP
      WHERE  id_avion = p_id_avion;

      INSERT INTO flota_estado_avion (id_avion, estado_anterior, estado_nuevo, motivo)
      VALUES (p_id_avion, 'OPERATIVO', 'EN_MANTENIMIENTO',
              'Inicio de mantenimiento tipo: ' || p_tipo);
    END IF;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Mantenimiento tipo "' || p_tipo || '" registrado correctamente.';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_resultado := 0;
      p_mensaje   := 'Avion con ID ' || p_id_avion || ' no encontrado.';
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_MANTENIMIENTO;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_HISTORIAL_MANTEN(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT m.id_manten, m.tipo, m.descripcion,
             m.fecha_inicio, m.fecha_fin,
             m.proveedor, m.costo_usd,
             ROUND(EXTRACT(DAY FROM (m.fecha_fin - m.fecha_inicio))
                 + EXTRACT(HOUR FROM (m.fecha_fin - m.fecha_inicio)) / 24, 1) AS dias_duracion
      FROM   flota_hist_manten m
      WHERE  m.id_avion = p_id_avion
      ORDER BY m.fecha_inicio DESC;
  END SP_OBTENER_HISTORIAL_MANTEN;

  ---------------------------------------------------------------

  PROCEDURE SP_AVIONES_EN_MANTENIMIENTO(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT av.id_avion, av.matricula, la.nombre AS aerolinea,
             mo.fabricante, mo.modelo, av.estado,
             (SELECT MAX(m.fecha_inicio)
              FROM   flota_hist_manten m
              WHERE  m.id_avion = av.id_avion) AS ultimo_manten_inicio
      FROM   flota_aviones    av
      JOIN   flota_modelos    mo ON av.id_modelo    = mo.id_modelo
      JOIN   linea_aerolineas la ON av.id_aerolinea = la.id_aerolinea
      WHERE  av.estado IN ('EN_MANTENIMIENTO', 'EN_REPARACION', 'EN_INSPECCION')
      ORDER BY la.nombre, av.matricula;
  END SP_AVIONES_EN_MANTENIMIENTO;

  ---------------------------------------------------------------

  PROCEDURE SP_REGISTRAR_AVERIA(
    p_id_avion      IN  NUMBER,
    p_descripcion   IN  CLOB,
    p_severidad     IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_estado_avion VARCHAR2(25);
  BEGIN
    IF p_severidad NOT IN ('BAJA','MEDIA','ALTA','CRITICA') THEN
      p_resultado := 0;
      p_mensaje   := 'Severidad invalida. Use: BAJA, MEDIA, ALTA o CRITICA.';
      RETURN;
    END IF;

    INSERT INTO flota_log_averias (
      id_avion, descripcion, severidad, estado, reportado_en
    ) VALUES (
      p_id_avion, p_descripcion, p_severidad, 'ABIERTA', SYSTIMESTAMP
    );

    -- Si es critica, cambiar estado del avion
    IF p_severidad = 'CRITICA' THEN
      SELECT estado INTO v_estado_avion
      FROM   flota_aviones WHERE id_avion = p_id_avion;

      IF v_estado_avion = 'OPERATIVO' THEN
        UPDATE flota_aviones
        SET    estado = 'EN_REPARACION', actualizado_en = SYSTIMESTAMP
        WHERE  id_avion = p_id_avion;

        INSERT INTO flota_estado_avion (id_avion, estado_anterior, estado_nuevo, motivo)
        VALUES (p_id_avion, 'OPERATIVO', 'EN_REPARACION', 'Averia critica detectada');
      END IF;
    END IF;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Averia ' || p_severidad || ' registrada.' ||
                   CASE WHEN p_severidad = 'CRITICA'
                        THEN ' Avion cambiado a EN_REPARACION.'
                        ELSE '' END;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_AVERIA;

  ---------------------------------------------------------------

  PROCEDURE SP_RESOLVER_AVERIA(
    p_id_averia     IN  NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
    UPDATE flota_log_averias
    SET    estado       = 'RESUELTA',
           resuelto_en  = SYSTIMESTAMP
    WHERE  id_averia = p_id_averia
    AND    estado    = 'ABIERTA';

    IF SQL%ROWCOUNT = 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Averia no encontrada o ya estaba resuelta.';
      RETURN;
    END IF;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Averia ID ' || p_id_averia || ' marcada como resuelta.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_RESOLVER_AVERIA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_AVERIAS_PENDIENTES(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT id_averia, descripcion, severidad, estado, reportado_en
      FROM   flota_log_averias
      WHERE  id_avion = p_id_avion
      AND    estado   = 'ABIERTA'
      ORDER BY
        CASE severidad
          WHEN 'CRITICA' THEN 1 WHEN 'ALTA' THEN 2
          WHEN 'MEDIA'   THEN 3 ELSE 4
        END,
        reportado_en DESC;
  END SP_OBTENER_AVERIAS_PENDIENTES;

-- ============================================================
-- SECCION 6: CERTIFICADOS E INSPECCIONES
-- ============================================================

  PROCEDURE SP_REGISTRAR_CERTIFICADO(
    p_id_avion        IN  NUMBER,
    p_tipo            IN  VARCHAR2,
    p_numero          IN  VARCHAR2,
    p_autoridad       IN  VARCHAR2,
    p_fecha_emision   IN  DATE,
    p_fecha_vence     IN  DATE,
    p_resultado       OUT NUMBER,
    p_mensaje         OUT VARCHAR2
  ) AS
  BEGIN
    IF p_fecha_vence <= p_fecha_emision THEN
      p_resultado := 0;
      p_mensaje   := 'La fecha de vencimiento debe ser posterior a la fecha de emision.';
      RETURN;
    END IF;

    -- Desactivar certificado anterior del mismo tipo si existe
    UPDATE flota_certificados
    SET    activo = 'N'
    WHERE  id_avion = p_id_avion
    AND    tipo     = p_tipo
    AND    activo   = 'S';

    -- Insertar el nuevo certificado
    INSERT INTO flota_certificados (
      id_avion, tipo, numero, autoridad_emisora,
      fecha_emision, fecha_vencimiento, activo
    ) VALUES (
      p_id_avion, p_tipo, p_numero, p_autoridad,
      p_fecha_emision, p_fecha_vence, 'S'
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Certificado tipo "' || p_tipo || '" registrado. Vence: ' ||
                   TO_CHAR(p_fecha_vence, 'DD/MM/YYYY');
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_CERTIFICADO;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_CERTIFICADOS(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT c.id_cert, c.tipo, c.numero, c.autoridad_emisora,
             c.fecha_emision, c.fecha_vencimiento, c.activo,
             CASE
               WHEN c.fecha_vencimiento < SYSDATE          THEN 'VENCIDO'
               WHEN c.fecha_vencimiento < SYSDATE + 30     THEN 'POR_VENCER'
               ELSE 'VIGENTE'
             END AS estado_cert,
             ROUND(c.fecha_vencimiento - SYSDATE) AS dias_para_vencer
      FROM   flota_certificados c
      WHERE  c.id_avion = p_id_avion
      ORDER BY c.activo DESC, c.fecha_vencimiento;
  END SP_OBTENER_CERTIFICADOS;

  ---------------------------------------------------------------

  PROCEDURE SP_CERTIFICADOS_POR_VENCER(
    p_dias_alerta IN  NUMBER DEFAULT 30,
    p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        av.matricula,
        la.nombre       AS aerolinea,
        c.tipo          AS tipo_certificado,
        c.numero,
        c.autoridad_emisora,
        c.fecha_vencimiento,
        ROUND(c.fecha_vencimiento - SYSDATE) AS dias_restantes
      FROM   flota_certificados  c
      JOIN   flota_aviones       av ON c.id_avion    = av.id_avion
      JOIN   linea_aerolineas    la ON av.id_aerolinea = la.id_aerolinea
      WHERE  c.activo             = 'S'
      AND    c.fecha_vencimiento  <= SYSDATE + p_dias_alerta
      ORDER BY c.fecha_vencimiento;
  END SP_CERTIFICADOS_POR_VENCER;

  ---------------------------------------------------------------

  PROCEDURE SP_REGISTRAR_INSPECCION(
    p_id_avion      IN  NUMBER,
    p_tipo          IN  VARCHAR2,
    p_fecha         IN  DATE,
    p_inspector     IN  VARCHAR2,
    p_resultado_ins IN  VARCHAR2,
    p_observaciones IN  CLOB,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
    IF p_resultado_ins NOT IN ('APROBADO', 'OBSERVACIONES', 'RECHAZADO') THEN
      p_resultado := 0;
      p_mensaje   := 'Resultado invalido. Use: APROBADO, OBSERVACIONES o RECHAZADO.';
      RETURN;
    END IF;

    INSERT INTO flota_ins_seguridad (
      id_avion, tipo, fecha, inspector, resultado, observaciones
    ) VALUES (
      p_id_avion, p_tipo, p_fecha, p_inspector, p_resultado_ins, p_observaciones
    );

    -- Si la inspeccion fue rechazada, cambiar estado del avion
    IF p_resultado_ins = 'RECHAZADO' THEN
      UPDATE flota_aviones
      SET    estado = 'EN_INSPECCION', actualizado_en = SYSTIMESTAMP
      WHERE  id_avion = p_id_avion
      AND    estado   = 'OPERATIVO';
    END IF;

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Inspeccion de seguridad registrada. Resultado: ' || p_resultado_ins;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_INSPECCION;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_INSPECCIONES(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT id_inspeccion, tipo, fecha, inspector, resultado, observaciones
      FROM   flota_ins_seguridad
      WHERE  id_avion = p_id_avion
      ORDER BY fecha DESC;
  END SP_OBTENER_INSPECCIONES;

  ---------------------------------------------------------------

  FUNCTION FN_TIENE_CERTIFICADOS_VIGENTES(
    p_id_avion IN NUMBER
  ) RETURN CHAR AS
    v_vencidos NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_vencidos
    FROM   flota_certificados
    WHERE  id_avion          = p_id_avion
    AND    activo             = 'S'
    AND    fecha_vencimiento  < SYSDATE;

    IF v_vencidos > 0 THEN
      RETURN 'N';
    END IF;
    RETURN 'S';
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'N';
  END FN_TIENE_CERTIFICADOS_VIGENTES;

-- ============================================================
-- SECCION 7: MOTORES Y COMPONENTES
-- ============================================================

  PROCEDURE SP_REGISTRAR_MOTOR(
    p_id_avion      IN  NUMBER,
    p_posicion      IN  VARCHAR2,
    p_fabricante    IN  VARCHAR2,
    p_modelo_motor  IN  VARCHAR2,
    p_numero_serie  IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM   flota_motores
    WHERE  numero_serie = p_numero_serie;

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'El numero de serie del motor ya existe: ' || p_numero_serie;
      RETURN;
    END IF;

    INSERT INTO flota_motores (
      id_avion, posicion, fabricante, modelo_motor,
      numero_serie, horas_totales, ciclos_totales, estado
    ) VALUES (
      p_id_avion, p_posicion, p_fabricante, p_modelo_motor,
      p_numero_serie, 0, 0, 'OPERATIVO'
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Motor ' || p_fabricante || ' ' || p_modelo_motor ||
                   ' registrado en posicion ' || p_posicion;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_MOTOR;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_MOTORES(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT id_motor, posicion, fabricante, modelo_motor,
             numero_serie, horas_totales, ciclos_totales, estado
      FROM   flota_motores
      WHERE  id_avion = p_id_avion
      ORDER BY posicion;
  END SP_OBTENER_MOTORES;

  ---------------------------------------------------------------

  PROCEDURE SP_REGISTRAR_COMPONENTE(
    p_id_avion      IN  NUMBER,
    p_nombre        IN  VARCHAR2,
    p_part_number   IN  VARCHAR2,
    p_numero_serie  IN  VARCHAR2,
    p_proximo_camb  IN  DATE,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
    IF p_proximo_camb IS NOT NULL AND p_proximo_camb < SYSDATE THEN
      p_resultado := 0;
      p_mensaje   := 'La fecha de proximo cambio no puede ser en el pasado.';
      RETURN;
    END IF;

    INSERT INTO flota_componentes (
      id_avion, nombre, part_number, numero_serie,
      estado, fecha_instalacion, proximo_cambio
    ) VALUES (
      p_id_avion, p_nombre, p_part_number, p_numero_serie,
      'OPERATIVO', SYSDATE, p_proximo_camb
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Componente "' || p_nombre || '" registrado correctamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_COMPONENTE;

  ---------------------------------------------------------------

  PROCEDURE SP_COMPONENTES_POR_CAMBIAR(
    p_dias_alerta IN  NUMBER DEFAULT 30,
    p_cursor      OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT av.matricula, la.nombre AS aerolinea,
             c.nombre AS componente, c.part_number, c.numero_serie,
             c.proximo_cambio,
             ROUND(c.proximo_cambio - SYSDATE) AS dias_restantes
      FROM   flota_componentes  c
      JOIN   flota_aviones      av ON c.id_avion    = av.id_avion
      JOIN   linea_aerolineas   la ON av.id_aerolinea = la.id_aerolinea
      WHERE  c.estado         = 'OPERATIVO'
      AND    c.proximo_cambio IS NOT NULL
      AND    c.proximo_cambio <= SYSDATE + p_dias_alerta
      ORDER BY c.proximo_cambio;
  END SP_COMPONENTES_POR_CAMBIAR;

-- ============================================================
-- SECCION 8: PROVEEDORES
-- ============================================================

  PROCEDURE SP_REGISTRAR_PROVEEDOR(
    p_nombre        IN  VARCHAR2,
    p_pais          IN  NUMBER,
    p_contacto      IN  VARCHAR2,
    p_email         IN  VARCHAR2,
    p_telefono      IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
    INSERT INTO flota_proveed_rep (
      nombre, pais, contacto_nombre, contacto_email, telefono, activo
    ) VALUES (
      p_nombre, p_pais, p_contacto, p_email, p_telefono, 'S'
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Proveedor "' || p_nombre || '" registrado exitosamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_PROVEEDOR;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_PROVEEDORES(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT pr.id_proveedor, pr.nombre, p.nombre AS pais,
             pr.contacto_nombre, pr.contacto_email, pr.telefono, pr.activo
      FROM   flota_proveed_rep pr
      JOIN   geog_paises        p ON pr.pais = p.id_pais
      WHERE  pr.activo = 'S'
      ORDER BY pr.nombre;
  END SP_OBTENER_PROVEEDORES;

  ---------------------------------------------------------------

  PROCEDURE SP_ASIGNAR_PROVEEDOR_AVION(
    p_id_avion      IN  NUMBER,
    p_id_proveedor  IN  NUMBER,
    p_tipo_servicio IN  VARCHAR2,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM   flota_proveed_union
    WHERE  id_avion    = p_id_avion
    AND    id_proveedor = p_id_proveedor
    AND    activo       = 'S';

    IF v_existe > 0 THEN
      p_resultado := 0;
      p_mensaje   := 'Este proveedor ya esta asignado a ese avion.';
      RETURN;
    END IF;

    INSERT INTO flota_proveed_union (id_avion, id_proveedor, tipo_servicio, activo)
    VALUES (p_id_avion, p_id_proveedor, p_tipo_servicio, 'S');

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Proveedor asignado al avion correctamente.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_ASIGNAR_PROVEEDOR_AVION;

-- ============================================================
-- SECCION 9: TELEMETRIA Y PESO/BALANCE
-- ============================================================

  PROCEDURE SP_REGISTRAR_TELEMETRIA(
    p_id_avion      IN  NUMBER,
    p_latitud       IN  NUMBER,
    p_longitud      IN  NUMBER,
    p_altitud_ft    IN  NUMBER,
    p_velocidad_kmh IN  NUMBER,
    p_temp_ext      IN  NUMBER,
    p_resultado     OUT NUMBER,
    p_mensaje       OUT VARCHAR2
  ) AS
  BEGIN
    INSERT INTO flota_telemetria (
      id_avion, registrado_en, latitud, longitud,
      altitud_ft, velocidad_kmh, temperatura_ext_c
    ) VALUES (
      p_id_avion, SYSTIMESTAMP, p_latitud, p_longitud,
      p_altitud_ft, p_velocidad_kmh, p_temp_ext
    );

    COMMIT;
    p_resultado := 1;
    p_mensaje   := 'Telemetria registrada OK.';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_TELEMETRIA;

  ---------------------------------------------------------------

  PROCEDURE SP_OBTENER_ULTIMA_POSICION(
    p_id_avion IN  NUMBER,
    p_cursor   OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT t.latitud, t.longitud, t.altitud_ft,
             t.velocidad_kmh, t.temperatura_ext_c, t.registrado_en
      FROM   flota_telemetria t
      WHERE  t.id_avion    = p_id_avion
      AND    t.registrado_en = (
               SELECT MAX(t2.registrado_en)
               FROM   flota_telemetria t2
               WHERE  t2.id_avion = p_id_avion
             );
  END SP_OBTENER_ULTIMA_POSICION;

  ---------------------------------------------------------------

  PROCEDURE SP_REGISTRAR_PESO_BALANCE(
    p_id_avion          IN  NUMBER,
    p_peso_vacio_kg     IN  NUMBER,
    p_peso_max_desp_kg  IN  NUMBER,
    p_peso_max_ate_kg   IN  NUMBER,
    p_comb_max_kg       IN  NUMBER,
    p_payload_max_kg    IN  NUMBER,
    p_resultado         OUT NUMBER,
    p_mensaje           OUT VARCHAR2
  ) AS
    v_existe NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM   flota_peso_balance WHERE id_avion = p_id_avion;

    IF v_existe > 0 THEN
      UPDATE flota_peso_balance
      SET    peso_vacio_kg        = p_peso_vacio_kg,
             peso_max_despegue_kg = p_peso_max_desp_kg,
             peso_max_aterrizaje_kg = p_peso_max_ate_kg,
             combustible_max_kg  = p_comb_max_kg,
             payload_max_kg      = p_payload_max_kg,
             actualizado_en      = SYSTIMESTAMP
      WHERE  id_avion = p_id_avion;
      p_mensaje := 'Peso y balance actualizado correctamente.';
    ELSE
      INSERT INTO flota_peso_balance (
        id_avion, peso_vacio_kg, peso_max_despegue_kg,
        peso_max_aterrizaje_kg, combustible_max_kg, payload_max_kg
      ) VALUES (
        p_id_avion, p_peso_vacio_kg, p_peso_max_desp_kg,
        p_peso_max_ate_kg, p_comb_max_kg, p_payload_max_kg
      );
      p_mensaje := 'Peso y balance registrado correctamente.';
    END IF;

    COMMIT;
    p_resultado := 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := -1;
      p_mensaje   := 'Error: ' || SQLERRM;
  END SP_REGISTRAR_PESO_BALANCE;

-- ============================================================
-- SECCION 10: REPORTES
-- ============================================================

  PROCEDURE SP_REPORTE_FLOTA_GENERAL(
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        la.codigo_iata                              AS iata,
        la.nombre                                   AS aerolinea,
        COUNT(av.id_avion)                          AS total_aviones,
        SUM(CASE WHEN av.estado = 'OPERATIVO'       THEN 1 ELSE 0 END) AS operativos,
        SUM(CASE WHEN av.estado = 'EN_MANTENIMIENTO' THEN 1 ELSE 0 END) AS en_manten,
        SUM(CASE WHEN av.estado = 'EN_REPARACION'   THEN 1 ELSE 0 END) AS en_reparacion,
        SUM(CASE WHEN av.estado = 'RETIRADO'        THEN 1 ELSE 0 END) AS retirados,
        ROUND(AVG(av.horas_vuelo_total), 1)         AS promedio_horas,
        ROUND(AVG(EXTRACT(YEAR FROM SYSDATE) - av.anno_fabricacion), 1) AS promedio_edad_anios
      FROM  linea_aerolineas la
      LEFT JOIN flota_aviones av ON la.id_aerolinea = av.id_aerolinea AND av.activo = 'S'
      WHERE la.activa = 'S'
      GROUP BY la.codigo_iata, la.nombre
      ORDER BY la.nombre;
  END SP_REPORTE_FLOTA_GENERAL;

  ---------------------------------------------------------------

  PROCEDURE SP_REPORTE_AVIONES_POR_ESTADO(
    p_estado IN  VARCHAR2 DEFAULT NULL,
    p_cursor OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT av.matricula, la.codigo_iata, la.nombre AS aerolinea,
             mo.fabricante, mo.modelo, av.estado,
             av.horas_vuelo_total, av.anno_fabricacion,
             EXTRACT(YEAR FROM SYSDATE) - av.anno_fabricacion AS edad_anios
      FROM   flota_aviones    av
      JOIN   flota_modelos    mo ON av.id_modelo    = mo.id_modelo
      JOIN   linea_aerolineas la ON av.id_aerolinea = la.id_aerolinea
      WHERE  (p_estado IS NULL OR av.estado = p_estado)
      AND    av.activo = 'S'
      ORDER BY av.estado, la.nombre, av.matricula;
  END SP_REPORTE_AVIONES_POR_ESTADO;

  ---------------------------------------------------------------

  PROCEDURE SP_REPORTE_MANTENIMIENTOS_PERIODO(
    p_fecha_ini IN  DATE,
    p_fecha_fin IN  DATE,
    p_cursor    OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT av.matricula, la.nombre AS aerolinea,
             m.tipo, m.descripcion,
             m.fecha_inicio, m.fecha_fin,
             m.proveedor, m.costo_usd,
             ROUND(EXTRACT(DAY  FROM (m.fecha_fin - m.fecha_inicio))
                 + EXTRACT(HOUR FROM (m.fecha_fin - m.fecha_inicio)) / 24, 1) AS dias_duracion
      FROM   flota_hist_manten m
      JOIN   flota_aviones     av ON m.id_avion    = av.id_avion
      JOIN   linea_aerolineas  la ON av.id_aerolinea = la.id_aerolinea
      WHERE  TRUNC(m.fecha_inicio) >= p_fecha_ini
      AND    TRUNC(m.fecha_inicio) <= p_fecha_fin
      ORDER BY m.fecha_inicio DESC;
  END SP_REPORTE_MANTENIMIENTOS_PERIODO;

  ---------------------------------------------------------------

  PROCEDURE SP_ESTADISTICAS_FLOTA(
    p_id_aerolinea IN  NUMBER DEFAULT NULL,
    p_cursor       OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN p_cursor FOR
      SELECT
        la.nombre                                       AS aerolinea,
        COUNT(DISTINCT av.id_avion)                     AS total_aviones,
        COUNT(DISTINCT mo.id_modelo)                    AS tipos_avion,
        ROUND(AVG(av.horas_vuelo_total),1)              AS horas_prom,
        MAX(av.horas_vuelo_total)                       AS max_horas,
        SUM(av.ciclos_total)                            AS total_ciclos,
        COUNT(DISTINCT pr.id_proveedor)                 AS num_proveedores,
        SUM(CASE WHEN c.fecha_vencimiento < SYSDATE
                  AND c.activo = 'S'
             THEN 1 ELSE 0 END)                         AS certs_vencidos,
        SUM(NVL(ma.costo_usd, 0))                       AS costo_manten_total_usd
      FROM   linea_aerolineas la
      LEFT JOIN flota_aviones     av ON la.id_aerolinea = av.id_aerolinea
      LEFT JOIN flota_modelos     mo ON av.id_modelo    = mo.id_modelo
      LEFT JOIN flota_proveed_union pu ON av.id_avion   = pu.id_avion
      LEFT JOIN flota_proveed_rep  pr ON pu.id_proveedor = pr.id_proveedor
      LEFT JOIN flota_certificados  c ON av.id_avion    = c.id_avion
      LEFT JOIN flota_hist_manten  ma ON av.id_avion    = ma.id_avion
      WHERE (p_id_aerolinea IS NULL OR la.id_aerolinea = p_id_aerolinea)
      GROUP BY la.nombre
      ORDER BY la.nombre;
  END SP_ESTADISTICAS_FLOTA;

END PKG_AEROLINEAS_FLOTA;
/

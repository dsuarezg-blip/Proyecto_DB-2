-- ============================================================
-- SCRIPT: seed_usuario_pruebas.sql
-- Descripción: Inserta un usuario administrador de pruebas
--              respetando la cadena de FK del esquema AEROGT.
-- Esquema: AEROGT | PDB: AERO_LA_AURORA
-- IMPORTANTE: Ejecutar con el usuario AEROGT conectado.
-- ============================================================

-- PASO 1: Departamento base (si no existe)
INSERT INTO rrhh_departamentos (nombre, descripcion, activo)
SELECT 'TI - Tecnología', 'Departamento de Sistemas y Pruebas', 'S'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM rrhh_departamentos WHERE nombre = 'TI - Tecnología'
);

-- PASO 2: Puesto base (si no existe)
INSERT INTO rrhh_puestos (nombre, descripcion, nivel, activo)
SELECT 'Administrador de Sistema', 'Acceso total al sistema AeroGT', 1, 'S'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM rrhh_puestos WHERE nombre = 'Administrador de Sistema'
);

COMMIT;

-- PASO 3: Empleado de pruebas (si no existe)
DECLARE
    v_id_depto  NUMBER;
    v_id_puesto NUMBER;
BEGIN
    SELECT id_depto INTO v_id_depto
    FROM rrhh_departamentos
    WHERE nombre = 'TI - Tecnología';

    SELECT id_puesto INTO v_id_puesto
    FROM rrhh_puestos
    WHERE nombre = 'Administrador de Sistema';

    INSERT INTO rrhh_empleados (
        id_puesto, id_depto, codigo_empleado,
        nombres, apellidos, activo
    )
    SELECT v_id_puesto, v_id_depto, 'EMP-TEST-001',
           'Admin', 'AeroGT', 'S'
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1 FROM rrhh_empleados WHERE codigo_empleado = 'EMP-TEST-001'
    );

    COMMIT;
END;
/

-- PASO 4: Rol ADMIN (si no existe)
INSERT INTO rrhh_sist_roles (nombre, descripcion, activo)
SELECT 'ADMIN', 'Administrador con acceso total', 'S'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1 FROM rrhh_sist_roles WHERE nombre = 'ADMIN'
);

COMMIT;

-- PASO 5: Usuario de pruebas
-- Usuario: admin_test
-- Contraseña: Admin2025*  (almacenada como hash SHA-256)
DECLARE
    v_id_empleado NUMBER;
BEGIN
    SELECT id_empleado INTO v_id_empleado
    FROM rrhh_empleados
    WHERE codigo_empleado = 'EMP-TEST-001';

    INSERT INTO rrhh_sist_usuarios (
        id_empleado, username, password_hash, email, activo, bloqueado
    )
    SELECT v_id_empleado,
           'admin_test',
           LOWER(RAWTOHEX(SYS.DBMS_CRYPTO.HASH(
               UTL_RAW.CAST_TO_RAW('Admin2025*'),
               SYS.DBMS_CRYPTO.HASH_SH256
           ))),
           'admin.test@aerogt.gob.gt',
           'S', 'N'
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1 FROM rrhh_sist_usuarios WHERE username = 'admin_test'
    );

    COMMIT;
END;
/

-- PASO 6: Asignar rol ADMIN al usuario de pruebas
DECLARE
    v_id_usuario NUMBER;
    v_id_rol     NUMBER;
BEGIN
    SELECT id_usuario INTO v_id_usuario
    FROM rrhh_sist_usuarios WHERE username = 'admin_test';

    SELECT id_rol INTO v_id_rol
    FROM rrhh_sist_roles WHERE nombre = 'ADMIN';

    INSERT INTO rrhh_roles_union (id_usuario, id_rol, activo)
    SELECT v_id_usuario, v_id_rol, 'S'
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1 FROM rrhh_roles_union
        WHERE id_usuario = v_id_usuario AND id_rol = v_id_rol
    );

    COMMIT;
END;
/

-- ============================================================
-- VERIFICACIÓN FINAL
-- ============================================================
SELECT
    u.username,
    e.nombres || ' ' || e.apellidos AS nombre_completo,
    r.nombre                        AS rol,
    u.activo,
    u.bloqueado
FROM rrhh_sist_usuarios u
JOIN rrhh_empleados     e  ON u.id_empleado = e.id_empleado
JOIN rrhh_roles_union   ru ON u.id_usuario  = ru.id_usuario
JOIN rrhh_sist_roles    r  ON ru.id_rol     = r.id_rol
WHERE u.username = 'admin_test';

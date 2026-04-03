CREATE OR REPLACE PACKAGE PKG_SIST_SEGURIDAD AS
    /**
     * Package: PKG_SIST_SEGURIDAD
     * Descripción: Gestión unificada de autenticación y auditoría para AeroGT.
     */

    -- Procedimiento para autenticar usuarios (Compatible con AuthService.vb)
    PROCEDURE pr_autenticar (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2,
        p_cursor   OUT SYS_REFCURSOR
    );

    -- Procedimiento para auditoría de acciones
    PROCEDURE pr_registrar_log (
        p_id_usuario  IN NUMBER,
        p_accion      IN VARCHAR2,
        p_modulo      IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_exitoso     IN CHAR
    );

END PKG_SIST_SEGURIDAD;
/

CREATE OR REPLACE PACKAGE BODY PKG_SIST_SEGURIDAD AS

    PROCEDURE pr_autenticar (
        p_username IN VARCHAR2,
        p_password IN VARCHAR2,
        p_cursor   OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT 
                u.id_usuario,
                u.email,
                r.nombre as rol_nombre
            FROM rrhh_sist_usuarios u
            JOIN rrhh_roles_union ru ON u.id_usuario = ru.id_usuario
            JOIN rrhh_sist_roles r ON ru.id_rol = r.id_rol
            WHERE u.username = p_username 
              AND u.password_hash = p_password
              AND u.activo = 'S'
              AND u.bloqueado = 'N'
              AND ru.activo = 'S';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error en el proceso de autenticación: ' || SQLERRM);
    END pr_autenticar;

    PROCEDURE pr_registrar_log (
        p_id_usuario  IN NUMBER,
        p_accion      IN VARCHAR2,
        p_modulo      IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_exitoso     IN CHAR
    ) IS
    BEGIN
        INSERT INTO rrhh_log_auditoria (
            id_usuario, accion, modulo, descripcion, exitoso, registrado_en
        ) VALUES (
            p_id_usuario, p_accion, p_modulo, p_descripcion, p_exitoso, SYSTIMESTAMP
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            NULL; -- En auditoría no bloqueamos la transacción principal si falla el log
    END pr_registrar_log;

END PKG_SIST_SEGURIDAD;
/

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS sac 
    DEFAULT CHARACTER SET latin1 
    COLLATE latin1_general_ci;

USE sac;

CREATE TABLE IF NOT EXISTS sac_acciones (
    id int(11)              NOT NULL AUTO_INCREMENT COMMENT 'ID de registro de la acción',
    modulo_id int(11)       NOT NULL COMMENT 'ID del módulo relacionado a la acción',
    codigo varchar(50)      NOT NULL COMMENT 'Código de identificación de la acción',
    nombre varchar(255)     NOT NULL COMMENT 'Nombre de la acción',
    descripcion text        NOT NULL COMMENT 'Descripción de la acción',
    activo tinyint(1)       NOT NULL COMMENT 'Determina si la acción esta activa o no',
    creado datetime         NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de creación del registro',
    editado datetime        NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de actualización del registro',
    
    PRIMARY KEY (id),
    UNIQUE KEY ux_sac_acciones_codigo (modulo_id,codigo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Acciones de los módulos gestionados';

CREATE TABLE IF NOT EXISTS sac_actividades (
    id bigint(20)           NOT NULL AUTO_INCREMENT COMMENT 'ID de registro de la actividad',
    tabla varchar(255)      NOT NULL COMMENT 'Nombre de la tabla afectada por la actividad',
    registro_id bigint(20)  NOT NULL COMMENT 'ID del registro afectado por la actividad',
    usuario_id bigint(20)   NOT NULL COMMENT 'ID del usuario relacionado a la actividad',
    tipo tinyint(4)         NOT NULL COMMENT 'Tipo de actividad: 1-Agregar, 2-Visualizar, 3-Actualizar, 4-Eliminar, 5-Login Logrado, 6-Logout, 7-Login Fallido, 8-Clave Actualizada, 9-Cambio en Roles, 10-Cambio en Permisos',
    fecha datetime          NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de la actividad',
    detalles mediumtext     CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'Detalles adicionales en formato JSON',
    
    PRIMARY KEY (id),
    KEY fk_sac_actividades_usuario_id (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Actividades (log) de cambios importantes';

CREATE TABLE IF NOT EXISTS sac_intentos (
    id bigint(20)           NOT NULL AUTO_INCREMENT COMMENT 'ID de registro del intento',
    usuario_id bigint(20)   NOT NULL COMMENT 'ID del usuario relacionado al intento',
    fecha datetime          NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora en la que se realizo el intento',
    logrado tinyint(1)      NOT NULL COMMENT 'Determina si el intento fue satisfactorio=1 o no=0',
    ip varchar(50)          NOT NULL COMMENT 'Dirección IP desde el cual se realizo la intento',

    PRIMARY KEY (id),
    KEY fk_sac_intentos_usuario_id (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Intentos de inicio de sesión';

CREATE TABLE IF NOT EXISTS sac_modulos (
    id int(11)              NOT NULL AUTO_INCREMENT COMMENT 'ID de registro del módulo',
    sistema_id int(11)      NOT NULL COMMENT 'ID del sistema relacionado al módulo',
    codigo varchar(50)      NOT NULL COMMENT 'Código de identificación del módulo',
    nombre varchar(255)     NOT NULL COMMENT 'Nombre del módulo',
    descripcion text        NOT NULL COMMENT 'Descripción sobre el módulo',
    activo tinyint(1)       NOT NULL COMMENT 'Determina si el módulo esta activo o no',
    creado datetime         NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de creación del registro',
    editado datetime        NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de actualización del registro',
    
    PRIMARY KEY (id),
    UNIQUE KEY ux_sac_modulos_codigo (sistema_id,codigo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Módulos de sistemas gestionados';

CREATE TABLE sac_reseteos (
    id bigint(20)           NOT NULL AUTO_INCREMENT COMMENT 'ID de registro del reseteo',
    usuario_id bigint(20)   NOT NULL COMMENT 'ID del usuario relacionado al reseteo',
    token varchar(36)       NOT NULL COMMENT 'Token de reseteo',
    creado datetime         NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de creación del registro',
    vigencia datetime       NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de vigencia del token de reseteo',

    PRIMARY KEY (id),
    KEY fk_sac_reseteos_usuario_id (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Reseteos de contraseña';

CREATE TABLE IF NOT EXISTS sac_roles (
    id int(11)              NOT NULL AUTO_INCREMENT COMMENT 'ID de registro del rol',
    codigo varchar(50)      NOT NULL COMMENT 'Código de identificación del rol',
    nombre varchar(255)     NOT NULL COMMENT 'Nombre del rol',
    descripcion text        NOT NULL COMMENT 'Descripción del rol',
    activo tinyint(1)       NOT NULL COMMENT 'Determina si el rol esta activo o no',
    creado datetime         NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de creación del registro',
    editado datetime        NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de actualización del registro',

    PRIMARY KEY (id),
    UNIQUE KEY ux_sac_roles_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Roles gestionados';

CREATE TABLE IF NOT EXISTS sac_roles_permisos (
    rol_id int(11)          NOT NULL COMMENT 'ID del rol relacionado',
    accion_id int(11)       NOT NULL COMMENT 'ID de la acción relacionada',

    UNIQUE KEY ux_sac_roles_permisos_relacion (rol_id,accion_id),
    KEY fk_sac_roles_acciones_accion_id (accion_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Asociación de roles con acciones';

CREATE TABLE IF NOT EXISTS sac_sesiones (
    id bigint(20)           NOT NULL AUTO_INCREMENT COMMENT 'ID de registro de la sesión',
    usuario_id bigint(20)   NOT NULL COMMENT 'ID del usuario relacionado a la sesión',
    token text              NOT NULL COMMENT 'Token de la sesión',
    inicio datetime         NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de inicio de la sesión',
    vigencia datetime       NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de vigencia de la sesión',

    PRIMARY KEY (id),
    UNIQUE KEY ux_sac_sesiones_token (token) USING HASH,
    KEY fk_sac_sesiones_usuario_id (usuario_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Tokens de sesión y vigencias';

CREATE TABLE IF NOT EXISTS sac_sistemas (
    id int(11)          NOT NULL AUTO_INCREMENT COMMENT 'ID de registro del sistema',
    codigo varchar(50)  NOT NULL COMMENT 'Código de identificación del sistema',
    nombre varchar(255) NOT NULL COMMENT 'Nombre completo del sistema',
    descripcion text    NOT NULL COMMENT 'Descripción sobre el sistema',
    activo tinyint(1)   NOT NULL COMMENT 'Determina si el sistema esta activo o no',
    creado datetime     NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de creación del registro',
    editado datetime    NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de actualización del registro',

    PRIMARY KEY (id),
    UNIQUE KEY ux_sac_sistemas_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Sistemas gestionados';

CREATE TABLE IF NOT EXISTS sac_usuarios (
    id bigint(20)       NOT NULL AUTO_INCREMENT COMMENT 'ID de registro del usuario',
    cuenta varchar(128) NOT NULL COMMENT 'Nombre de la cuenta de usuario',
    correo varchar(255) NOT NULL COMMENT 'Dirección de correo del usuario',
    clave varchar(255)  NOT NULL COMMENT 'Clave de acceso protegida, definida por el usuario',
    estatus tinyint(4)  NOT NULL COMMENT 'Estatus del usuario: 1=Activo, 2=Pendiente, 3=Suspendido, 9=Fuera de Servicio',
    creado datetime     NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de creación del registro',
    editado datetime    NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha y hora de actualización del registro',

    PRIMARY KEY (id),
    UNIQUE KEY ux_sac_usuarios_cuenta (cuenta),
    UNIQUE KEY ux_sac_usuarios_correo (correo)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Usuarios gestionados';

CREATE TABLE IF NOT EXISTS sac_usuarios_roles (
    usuario_id bigint(20)   NOT NULL COMMENT 'ID del usuario relacionado',
    rol_id int(11)          NOT NULL COMMENT 'ID del rol relacionado',

    UNIQUE KEY ux_sac_usuarios_roles_relacion (usuario_id,rol_id),
    KEY fk_sac_usuarios_roles_rol_id (rol_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci 
    COMMENT='Asociación de usuarios con roles';


ALTER TABLE sac_acciones
    ADD CONSTRAINT fk_sac_acciones_modulo_id 
        FOREIGN KEY (modulo_id) REFERENCES sac_modulos (id);

ALTER TABLE sac_actividades
    ADD CONSTRAINT fk_sac_actividades_usuario_id 
        FOREIGN KEY (usuario_id) REFERENCES sac_usuarios (id);

ALTER TABLE sac_intentos
    ADD CONSTRAINT fk_sac_ntentos_usuario_id 
        FOREIGN KEY (usuario_id) REFERENCES sac_usuarios (id);

ALTER TABLE sac_modulos
    ADD CONSTRAINT fk_sac_modulos_sistema_id 
        FOREIGN KEY (sistema_id) REFERENCES sac_sistemas (id);

ALTER TABLE sac_reseteos
    ADD CONSTRAINT fk_sac_reseteos_usuario_id 
        FOREIGN KEY (usuario_id) REFERENCES sac_usuarios (id);

ALTER TABLE sac_roles_permisos
    ADD CONSTRAINT fk_sac_roles_acciones_accion_id 
        FOREIGN KEY (accion_id) REFERENCES sac_acciones (id),
    ADD CONSTRAINT fk_sac_roles_acciones_rol 
        FOREIGN KEY (rol_id) REFERENCES sac_roles (id);

ALTER TABLE sac_sesiones
    ADD CONSTRAINT fk_sac_sesiones_usuario_id 
        FOREIGN KEY (usuario_id) REFERENCES sac_usuarios (id);

ALTER TABLE sac_usuarios_roles
    ADD CONSTRAINT fk_sac_usuarios_roles_rol_id 
        FOREIGN KEY (rol_id) REFERENCES sac_roles (id),
    ADD CONSTRAINT fk_sac_usuarios_roles_usuario_id 
        FOREIGN KEY (usuario_id) REFERENCES sac_usuarios (id);

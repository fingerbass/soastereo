USE master
GO

CREATE DATABASE soa
GO

USE soa
GO

--==================================================================================================================================================
--==================================================================================================================================================
--==================================================================================================================================================

Select * From seg_usuarios

CREATE TABLE seg_db_error(
	iddberror INT IDENTITY(1,1) PRIMARY KEY,
    usuario VARCHAR(MAX) NOT NULL,
    numero VARCHAR(MAX) NOT NULL,
    gravedad VARCHAR(MAX) NOT NULL,
    estado VARCHAR(MAX) NOT NULL,
    procedimiento VARCHAR(MAX) NOT NULL,
    linea VARCHAR(MAX) NOT NULL,
    mensaje VARCHAR(MAX) NOT NULL
)

Drop table seg_db_error
select * from seg_db_error

-- Creación de la tabla CLIENTE
CREATE TABLE adm_clientes (
    idcliente INT IDENTITY(1,1) PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
	numerodocumento VARCHAR(8) NOT NULL,
	direccion VARCHAR(250) NOT NULL,
	distrito VARCHAR(50) NOT NULL,
	ciudad VARCHAR(50) NOT NULL,
    email VARCHAR(250) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    activo BIT DEFAULT 1,
	usuarioregistro VARCHAR(50) NOT NULL,
    fecharegistro DATETIME NOT NULL
);

drop table adm_clientes

-- Creación de la tabla CATEGORIA
CREATE TABLE adm_categorias (
    idcategoria INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(MAX) NOT NULL,
	activo BIT DEFAULT 1,
	usuarioregistro VARCHAR(50) NOT NULL,
    fecharegistro DATETIME NOT NULL
);

-- Creación de la tabla PROVEEDOR
CREATE TABLE adm_proveedores (
    idproveedor INT IDENTITY(1,1) PRIMARY KEY,
	idcategoria INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(250) NOT NULL,
    reputacion FLOAT NOT NULL,
    verificado BIT DEFAULT 0,
    activo BIT DEFAULT 1,
	usuarioregistro VARCHAR(50) NOT NULL,
    fecharegistro DATETIME NOT NULL
);

-- Creación de la tabla EVENTO
CREATE TABLE adm_eventos (
    idevento INT IDENTITY(1,1) PRIMARY KEY,
    idcliente INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    fecha DATETIME NOT NULL,
    lugar VARCHAR(255),
    descripcion TEXT,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Planificado', 'En Progreso', 'Completado', 'Cancelado')),
    costo_total DECIMAL(10, 2),
    creado_en DATETIME2 DEFAULT GETDATE(),
    actualizado_en DATETIME2 DEFAULT GETDATE(),
	usuarioregistro VARCHAR(50) NOT NULL,
    fecharegistro DATETIME NOT NULL
);




-- Creación de la tabla PROVEEDOR_EVENTO
CREATE TABLE PROVEEDOR_EVENTO (
    id INT IDENTITY(1,1) PRIMARY KEY,
    evento_id INT,
    proveedor_id INT,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Pendiente', 'Confirmado', 'Cancelado')),
    costo DECIMAL(10, 2),
    asignado_en DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (evento_id) REFERENCES EVENTO(id),
    FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(id)
);

-- Creación de la tabla PAGO
CREATE TABLE PAGO (
    id INT IDENTITY(1,1) PRIMARY KEY,
    evento_id INT,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATE NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Pendiente', 'Procesado', 'Cancelado')),
    metodo_pago VARCHAR(50) NOT NULL,
    FOREIGN KEY (evento_id) REFERENCES EVENTO(id)
);

-- Creación de la tabla EVALUACION
CREATE TABLE EVALUACION (
    id INT IDENTITY(1,1) PRIMARY KEY,
    evento_id INT,
    proveedor_id INT,
    puntuacion INT NOT NULL CHECK (puntuacion >= 1 AND puntuacion <= 5),
    comentario TEXT,
    creado_en DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (evento_id) REFERENCES EVENTO(id),
    FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(id)
);

-- Creación de la tabla QUEJA
CREATE TABLE QUEJA (
    id INT IDENTITY(1,1) PRIMARY KEY,
    evento_id INT,
    cliente_id INT,
    proveedor_id INT,
    descripcion TEXT NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Pendiente', 'En Revisión', 'Resuelta', 'Cerrada')),
    creado_en DATETIME2 DEFAULT GETDATE(),
    resuelto_en DATETIME2,
    FOREIGN KEY (evento_id) REFERENCES EVENTO(id),
    FOREIGN KEY (cliente_id) REFERENCES CLIENTE(id),
    FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(id)
);





--========================================================================================================================================================





USE [master]
GO
/****** Object:  Database [mmfm]    Script Date: 11/04/2024 17:09:25 ******/
CREATE DATABASE [soa]
GO

USE [soa]
GO

CREATE TABLE [dbo].[adm_empresas](
	[idempresa] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[ruc] [varchar](11) NOT NULL,
	[direccion] [varchar](100) NOT NULL,
	[distrito] [varchar](50) NOT NULL,
	[ciudad] [varchar](50) NOT NULL,
	[telefono] [varchar](20) NOT NULL,
	[email] [varchar](80) NOT NULL,
	[activo] [bit] NOT NULL,
	[logo] [image] NULL,
	[isotipo] [image] NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_empresas] PRIMARY KEY CLUSTERED 
(
	[idempresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_empresas_areas]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_empresas_areas](
	[idarea] [int] IDENTITY(1,1) NOT NULL,
	[idsede] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_empresas_areas] PRIMARY KEY CLUSTERED 
(
	[idarea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_empresas_cargos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_empresas_cargos](
	[idcargo] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_empresas_cargos] PRIMARY KEY CLUSTERED 
(
	[idcargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_empresas_sedes]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_empresas_sedes](
	[idsede] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[direccion] [varchar](100) NOT NULL,
	[distrito] [varchar](50) NOT NULL,
	[ciudad] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_empresas_sedes] PRIMARY KEY CLUSTERED 
(
	[idsede] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_empresas_terceros]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_empresas_terceros](
	[idtercero] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[ruc] [varchar](11) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[direccion] [varchar](100) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_empresas_proveedor_cliente] PRIMARY KEY CLUSTERED 
(
	[idtercero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_empresas_tipos_personal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_empresas_tipos_personal](
	[idtipopersonalempresa] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[idtipopersonal] [int] NOT NULL,
	[flgarea] [bit] NOT NULL,
	[flgbrevete] [bit] NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_personal_tipo] PRIMARY KEY CLUSTERED 
(
	[idtipopersonalempresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_personal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_personal](
	[idpersonal] [int] IDENTITY(1,1) NOT NULL,
	[idpersona] [int] NOT NULL,
	[codigo] [varchar](20) NOT NULL,
	[codigoenlace] [varchar](20) NOT NULL,
	[idempresa] [int] NOT NULL,
	[idarea] [int] NOT NULL,
	[fechaingreso] [date] NOT NULL,
	[fechacese] [date] NOT NULL,
	[idcargo] [int] NOT NULL,
	[idtipopersonal] [int] NOT NULL,
	[idtercero] [int] NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_empresas_personal] PRIMARY KEY CLUSTERED 
(
	[idpersonal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_personal_activos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_personal_activos](
	[idpersonalactivo] [int] IDENTITY(1,1) NOT NULL,
	[idpersonal] [int] NOT NULL,
	[idtipoactivo] [int] NOT NULL,
	[equipo] [varchar](50) NOT NULL,
	[serie] [varchar](50) NOT NULL,
	[modelo] [varchar](50) NOT NULL,
	[marca] [varchar](50) NOT NULL,
	[color] [varchar](50) NOT NULL,
	[propietario] [varchar](50) NOT NULL,
	[autorizador] [varchar](50) NOT NULL,
	[codigobarras] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_personal_activos] PRIMARY KEY CLUSTERED 
(
	[idpersonalactivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_personas]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_personas](
	[idpersona] [int] IDENTITY(1,1) NOT NULL,
	[idtipodocumento] [varchar](2) NOT NULL,
	[documento] [varchar](10) NOT NULL,
	[paterno] [varchar](50) NOT NULL,
	[materno] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[nacimiento] [date] NOT NULL,
	[sexo] [varchar](1) NOT NULL,
	[brevete] [varchar](50) NOT NULL,
	[brevete_tipo] [varchar](50) NOT NULL,
	[brevete_vencimiento] [date] NOT NULL,
	[discamec] [varchar](50) NOT NULL,
	[discamec_vencimiento] [date] NOT NULL,
	[foto] [image] NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_personas] PRIMARY KEY CLUSTERED 
(
	[idpersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_servicios]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_servicios](
	[idservicio] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[isotipo] [image] NULL,
	[puesto] [bit] NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_servicios] PRIMARY KEY CLUSTERED 
(
	[idservicio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_servicios_empresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_servicios_empresa](
	[idservicioempresa] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[idservicio] [int] NOT NULL,
	[inicio] [date] NOT NULL,
	[termino] [date] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_servicios_empresa] PRIMARY KEY CLUSTERED 
(
	[idservicioempresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_tipos_activos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_tipos_activos](
	[idtipoactivo] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_tipos_activos] PRIMARY KEY CLUSTERED 
(
	[idtipoactivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_tipos_documentos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_tipos_documentos](
	[idtipodocumento] [varchar](2) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[sigla] [varchar](4) NOT NULL,
	[digitos] [int] NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_tipo_documento] PRIMARY KEY CLUSTERED 
(
	[idtipodocumento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_tipos_incidencias]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_tipos_incidencias](
	[idtipoincidencia] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_tipos_incidencias] PRIMARY KEY CLUSTERED 
(
	[idtipoincidencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_tipos_ingresosalida]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_tipos_ingresosalida](
	[idtipoingresosalida] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idtipoingresosalida] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_tipos_personal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_tipos_personal](
	[idtipopersonal] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_tipos_personal] PRIMARY KEY CLUSTERED 
(
	[idtipopersonal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[adm_tipos_vehiculos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adm_tipos_vehiculos](
	[idtipovehiculo] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_adm_tipos_vehiculos] PRIMARY KEY CLUSTERED 
(
	[idtipovehiculo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seg_log_actividades]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seg_log_actividades](
	[idlogusuario] [int] IDENTITY(1,1) NOT NULL,
	[idusuario] [int] NOT NULL,
	[accion] [int] NOT NULL,
	[opcion] [varchar](100) NOT NULL,
	[valoranterior] [varchar](max) NOT NULL,
	[valoractual] [varchar](max) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
	[latitud] [geography] NOT NULL,
	[longitud] [geography] NOT NULL,
	[dispositivo] [varchar](50) NOT NULL,
	[ip] [varchar](50) NOT NULL,
 CONSTRAINT [PK_seg_log_actividades] PRIMARY KEY CLUSTERED 
(
	[idlogusuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seg_log_db_error]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seg_log_db_error](
	[iderror] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [nvarchar](128) NOT NULL,
	[hora] [datetime] NOT NULL,
	[numero] [int] NOT NULL,
	[gravedad] [int] NULL,
	[estado] [int] NULL,
	[procedimiento] [nvarchar](126) NULL,
	[linea] [int] NULL,
	[mensaje] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_seg_db_error] PRIMARY KEY CLUSTERED 
(
	[iderror] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seg_roles]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seg_roles](
	[idrol] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_seg_roles] PRIMARY KEY CLUSTERED 
(
	[idrol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seg_usuarios]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seg_usuarios](
	[idusuario] [int] IDENTITY(1,1) NOT NULL,
	[paterno] [varchar](50) NOT NULL,
	[materno] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[idtipodocumento] [char](2) NOT NULL,
	[documento] [varchar](20) NOT NULL,
	[login] [varchar](50) NOT NULL,
	[password] [varbinary](max) NOT NULL,
	[email] [varchar](80) NOT NULL,
	[movil] [varchar](20) NOT NULL,
	[ultimoingreso] [datetime] NOT NULL,
	[cambioclave] [datetime] NOT NULL,
	[administrador] [bit] NOT NULL,
	[activo] [bit] NOT NULL,
	[foto] [image] NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_seg_usuarios] PRIMARY KEY CLUSTERED 
(
	[idusuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seg_usuarios_empresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seg_usuarios_empresa](
	[idusuarioempresa] [int] IDENTITY(1,1) NOT NULL,
	[idusuario] [int] NOT NULL,
	[idempresa] [int] NOT NULL,
	[idrol] [int] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_seg_usuarios_empresa] PRIMARY KEY CLUSTERED 
(
	[idusuarioempresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seg_usuarios_password]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seg_usuarios_password](
	[idusuariopassword] [int] IDENTITY(1,1) NOT NULL,
	[idusuario] [int] NOT NULL,
	[password] [varbinary](max) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_seg_usuarios_password] PRIMARY KEY CLUSTERED 
(
	[idusuariopassword] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seg_usuarios_sede]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seg_usuarios_sede](
	[idusuariosede] [int] IDENTITY(1,1) NOT NULL,
	[idusuario] [int] NOT NULL,
	[idsede] [int] NOT NULL,
	[idrol] [int] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_seg_usuarios_sede] PRIMARY KEY CLUSTERED 
(
	[idusuariosede] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sis_parametros]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sis_parametros](
	[idparametro] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[idusuario] [int] NOT NULL,
	[variable] [varchar](50) NOT NULL,
	[valor] [varchar](250) NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_sis_parametros] PRIMARY KEY CLUSTERED 
(
	[idparametro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_camaras]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_camaras](
	[idcamara] [varchar](50) NOT NULL,
	[idpuesto] [int] NOT NULL,
	[nombre] [varchar](250) NOT NULL,
	[observacion] [varchar](max) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_correspondencia]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_correspondencia](
	[idcorrespondencia] [int] IDENTITY(1,1) NOT NULL,
	[idtipocorrespondencia] [int] NOT NULL,
	[destinatario_idpersonal] [int] NOT NULL,
	[remitente] [varchar](250) NOT NULL,
	[recepcion_fecha] [datetime] NOT NULL,
	[recepcion_usuario] [varchar](50) NOT NULL,
	[recepcion_observacion] [varchar](250) NOT NULL,
	[entrega_fecha] [datetime] NOT NULL,
	[entrega_usuario] [varchar](50) NOT NULL,
	[entrega_observacion] [varchar](250) NOT NULL,
	[uuid] [uniqueidentifier] NOT NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK__vig_docu__2CEDF3A035E90E11] PRIMARY KEY CLUSTERED 
(
	[idcorrespondencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_documentos_upload]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_documentos_upload](
	[iddocumentoupload] [int] IDENTITY(1,1) NOT NULL,
	[app] [varchar](250) NOT NULL,
	[usuario] [varchar](250) NOT NULL,
	[uuid] [uniqueidentifier] NOT NULL,
	[ruta] [varchar](250) NOT NULL,
	[archivo] [varchar](250) NOT NULL,
	[archivoNuevo] [varchar](250) NOT NULL,
	[carpeta] [varchar](50) NOT NULL,
	[empresa] [varchar](250) NOT NULL,
	[peso] [int] NOT NULL,
	[extension] [varchar](50) NOT NULL,
	[fieldname] [varchar](250) NOT NULL,
	[originalname] [varchar](250) NOT NULL,
	[encoding] [varchar](250) NOT NULL,
	[mimetype] [varchar](250) NOT NULL,
	[destination] [varchar](250) NOT NULL,
	[filename] [varchar](250) NOT NULL,
	[path] [varchar](250) NOT NULL,
	[size] [int] NOT NULL,
	[accion] [varchar](50) NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK__vig_docu__D9A3A14C23DCFC69] PRIMARY KEY CLUSTERED 
(
	[iddocumentoupload] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_incidencias]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_incidencias](
	[idincidencia] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[idsede] [int] NOT NULL,
	[idpuesto] [int] NOT NULL,
	[idtipoincidencia] [int] NOT NULL,
	[idusuario] [int] NOT NULL,
	[idpersonal] [int] NOT NULL,
	[nombre] [varchar](250) NOT NULL,
	[observacion] [varchar](max) NOT NULL,
	[fechaincidencia] [datetime] NOT NULL,
	[uuid] [uniqueidentifier] NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK__vig_inci__2AB127894CBF58E7] PRIMARY KEY CLUSTERED 
(
	[idincidencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_ingresosalida]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_ingresosalida](
	[ides] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[idsede] [int] NOT NULL,
	[idpuesto] [int] NOT NULL,
	[idtipopersonal] [int] NOT NULL,
	[idpersonal] [int] NOT NULL,
	[idpersonalvisita] [int] NOT NULL,
	[ingreso_tiporegistro] [int] NOT NULL,
	[ingreso_hora] [datetime] NOT NULL,
	[ingreso_idsede] [int] NOT NULL,
	[ingreso_idvehiculo] [int] NOT NULL,
	[ingreso_observacion] [varchar](50) NOT NULL,
	[ingreso_usuario] [varchar](50) NOT NULL,
	[salida_tiporegistro] [int] NOT NULL,
	[salida_hora] [datetime] NOT NULL,
	[salida_idsede] [int] NOT NULL,
	[salida_idvehiculo] [int] NOT NULL,
	[salida_observacion] [varchar](100) NOT NULL,
	[salida_usuario] [varchar](50) NOT NULL,
 CONSTRAINT [PK_vig_ingresosalida] PRIMARY KEY CLUSTERED 
(
	[ides] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_ingresosalida_activos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_ingresosalida_activos](
	[idesactivo] [int] IDENTITY(1,1) NOT NULL,
	[ides] [int] NOT NULL,
	[idtipoactivo] [int] NOT NULL,
	[serie] [varchar](50) NOT NULL,
	[equipo] [varchar](50) NOT NULL,
	[marca] [varchar](50) NOT NULL,
	[modelo] [varchar](50) NOT NULL,
	[color] [varchar](50) NOT NULL,
	[salida] [datetime] NOT NULL,
 CONSTRAINT [PK__vig_ingr__B5D89A671F5A8E93] PRIMARY KEY CLUSTERED 
(
	[idesactivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_ingresosalida_upload]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_ingresosalida_upload](
	[idingresosalidaupload] [int] IDENTITY(1,1) NOT NULL,
	[app] [varchar](250) NOT NULL,
	[ides] [int] NOT NULL,
	[tipoingresosalida] [varchar](50) NOT NULL,
	[usuario] [varchar](250) NOT NULL,
	[ruta] [varchar](250) NOT NULL,
	[archivo] [varchar](250) NOT NULL,
	[archivoNuevo] [varchar](250) NOT NULL,
	[carpeta] [varchar](50) NOT NULL,
	[empresa] [varchar](250) NOT NULL,
	[peso] [int] NOT NULL,
	[extension] [varchar](50) NOT NULL,
	[fieldname] [varchar](250) NOT NULL,
	[originalname] [varchar](250) NOT NULL,
	[encoding] [varchar](250) NOT NULL,
	[mimetype] [varchar](250) NOT NULL,
	[destination] [varchar](250) NOT NULL,
	[filename] [varchar](250) NOT NULL,
	[path] [varchar](250) NOT NULL,
	[size] [int] NOT NULL,
	[accion] [varchar](50) NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idingresosalidaupload] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_puestos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_puestos](
	[idpuesto] [int] IDENTITY(1,1) NOT NULL,
	[idsede] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_vig_puestos] PRIMARY KEY CLUSTERED 
(
	[idpuesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_tipos_correspondencia]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_tipos_correspondencia](
	[idtipocorrespondencia] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[observacion] [varchar](250) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[idtipocorrespondencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vig_vehiculos]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vig_vehiculos](
	[idvehiculo] [int] IDENTITY(1,1) NOT NULL,
	[placa] [varchar](10) NOT NULL,
	[marca] [varchar](50) NOT NULL,
	[color] [varchar](50) NOT NULL,
	[idtipovehiculo] [int] NOT NULL,
	[vencimiento_soat] [date] NOT NULL,
	[vencimiento_revision] [date] NOT NULL,
	[codigo] [varchar](10) NOT NULL,
	[observacion] [varchar](100) NOT NULL,
	[activo] [bit] NOT NULL,
	[usuarioregistro] [varchar](50) NOT NULL,
	[fecharegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_vig_vehiculos] PRIMARY KEY CLUSTERED 
(
	[idvehiculo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vt_seg_log_acciones]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vt_seg_log_acciones]
AS
SELECT 1 AS idaccion, 'INICIO DE SESION' AS nombre UNION 
SELECT 2 AS idaccion, 'CIERRE SESION' AS nombre UNION 
SELECT 3 AS idaccion, 'SELECCION' AS nombre UNION 
SELECT 4 AS idaccion, 'AGREGAR REGISTRO' AS nombre UNION
SELECT 5 AS idaccion, 'EDITAR REGISTRO' AS nombre UNION
SELECT 6 AS idaccion, 'ELIMINAR REGISTRO' AS nombre UNION
SELECT 7 AS idaccion, 'EXPORTAR' AS nombre
  
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_ruc]  DEFAULT (' ') FOR [ruc]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_direccion]  DEFAULT (' ') FOR [direccion]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_distrito]  DEFAULT (' ') FOR [distrito]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_ciudad]  DEFAULT (' ') FOR [ciudad]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_telefono]  DEFAULT (' ') FOR [telefono]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_email]  DEFAULT (' ') FOR [email]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_empresas] ADD  CONSTRAINT [DF_adm_empresas_fecharegistro]  DEFAULT ('19000101') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_empresas_areas] ADD  CONSTRAINT [DF_Table_2_idempresa]  DEFAULT ((0)) FOR [idsede]
GO
ALTER TABLE [dbo].[adm_empresas_areas] ADD  CONSTRAINT [DF_adm_empresas_areas_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_empresas_areas] ADD  CONSTRAINT [DF_adm_empresas_areas_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_empresas_areas] ADD  CONSTRAINT [DF_adm_empresas_areas_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_empresas_areas] ADD  CONSTRAINT [DF_adm_empresas_areas_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_empresas_cargos] ADD  CONSTRAINT [DF_adm_empresas_cargos_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[adm_empresas_cargos] ADD  CONSTRAINT [DF_adm_empresas_cargos_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_empresas_cargos] ADD  CONSTRAINT [DF_adm_empresas_cargos_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_empresas_cargos] ADD  CONSTRAINT [DF_adm_empresas_cargos_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_empresas_cargos] ADD  CONSTRAINT [DF_adm_empresas_cargos_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_direccion]  DEFAULT (' ') FOR [direccion]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_distrito]  DEFAULT (' ') FOR [distrito]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_ciudad]  DEFAULT (' ') FOR [ciudad]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_empresas_sedes] ADD  CONSTRAINT [DF_adm_empresas_sedes_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_empresas_terceros] ADD  CONSTRAINT [DF_adm_empresas_terceros_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[adm_empresas_terceros] ADD  CONSTRAINT [DF_adm_empresas_proveedor_cliente_ruc]  DEFAULT (' ') FOR [ruc]
GO
ALTER TABLE [dbo].[adm_empresas_terceros] ADD  CONSTRAINT [DF_adm_empresas_proveedor_cliente_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_empresas_terceros] ADD  CONSTRAINT [DF_adm_empresas_proveedor_cliente_direccion]  DEFAULT (' ') FOR [direccion]
GO
ALTER TABLE [dbo].[adm_empresas_terceros] ADD  CONSTRAINT [DF_adm_empresas_proveedor_cliente_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_empresas_terceros] ADD  CONSTRAINT [DF_adm_empresas_proveedor_cliente_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_empresas_terceros] ADD  CONSTRAINT [DF_adm_empresas_proveedor_cliente_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_empresas_tipos_personal] ADD  CONSTRAINT [DF_adm_tipos_personal_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[adm_empresas_tipos_personal] ADD  CONSTRAINT [DF_adm_empresas_tipos_personal_idtipopersonal]  DEFAULT ((0)) FOR [idtipopersonal]
GO
ALTER TABLE [dbo].[adm_empresas_tipos_personal] ADD  CONSTRAINT [DF_adm_tipos_personal_flgidarea]  DEFAULT ((0)) FOR [flgarea]
GO
ALTER TABLE [dbo].[adm_empresas_tipos_personal] ADD  CONSTRAINT [DF_adm_tipos_personal_flgbrevete]  DEFAULT ((0)) FOR [flgbrevete]
GO
ALTER TABLE [dbo].[adm_empresas_tipos_personal] ADD  CONSTRAINT [DF_adm_personal_tipo_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_empresas_tipos_personal] ADD  CONSTRAINT [DF_adm_personal_tipo_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_empresas_tipos_personal] ADD  CONSTRAINT [DF_adm_personal_tipo_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_Table_1_tipodocumento]  DEFAULT ((0)) FOR [idpersona]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_empresas_personal_codigo]  DEFAULT (' ') FOR [codigo]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_empresas_personal_codigoenlace]  DEFAULT (' ') FOR [codigoenlace]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_personal_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_Table_1_nacimiento]  DEFAULT ((0)) FOR [idarea]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_personal_fechaingreso]  DEFAULT ('1900-01-01') FOR [fechaingreso]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_personal_fechacese]  DEFAULT ('1900-01-01') FOR [fechacese]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_personal_idcargo]  DEFAULT ((0)) FOR [idcargo]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_personal_idtipopersonal]  DEFAULT ((0)) FOR [idtipopersonal]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_personal_idtercero]  DEFAULT ((0)) FOR [idtercero]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_empresas_personal_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_empresas_personal_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_personal] ADD  CONSTRAINT [DF_adm_empresas_personal_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_idpersonal]  DEFAULT ((0)) FOR [idpersonal]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_idtipoactivo]  DEFAULT ((0)) FOR [idtipoactivo]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_equipo]  DEFAULT (' ') FOR [equipo]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_serie]  DEFAULT (' ') FOR [serie]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_modelo]  DEFAULT (' ') FOR [modelo]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_marca]  DEFAULT (' ') FOR [marca]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_color]  DEFAULT (' ') FOR [color]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_propietario]  DEFAULT (' ') FOR [propietario]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_autorizador]  DEFAULT (' ') FOR [autorizador]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_codigobarras]  DEFAULT (' ') FOR [codigobarras]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_personal_activos] ADD  CONSTRAINT [DF_adm_personal_activos_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_tipodocumento]  DEFAULT (' ') FOR [idtipodocumento]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_documento]  DEFAULT (' ') FOR [documento]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_paterno]  DEFAULT (' ') FOR [paterno]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_materno]  DEFAULT (' ') FOR [materno]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_nacimiento]  DEFAULT ('1900-01-01') FOR [nacimiento]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_sexo]  DEFAULT ('M') FOR [sexo]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_licencia]  DEFAULT (' ') FOR [brevete]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_brevete_tipo]  DEFAULT (' ') FOR [brevete_tipo]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_licencia_vencimiento]  DEFAULT ('1900-01-01') FOR [brevete_vencimiento]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_discamec]  DEFAULT (' ') FOR [discamec]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_discamec_vencimeinto]  DEFAULT ('1900-01-01') FOR [discamec_vencimiento]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_personas] ADD  CONSTRAINT [DF_adm_personas_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_servicios] ADD  CONSTRAINT [DF_adm_servicios_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_servicios] ADD  CONSTRAINT [DF_adm_servicios_puesto]  DEFAULT ((0)) FOR [puesto]
GO
ALTER TABLE [dbo].[adm_servicios] ADD  CONSTRAINT [DF_adm_servicios_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_servicios] ADD  CONSTRAINT [DF_adm_servicios_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_servicios] ADD  CONSTRAINT [DF_adm_servicios_fecharegistro]  DEFAULT ('19000101') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_servicios_empresa] ADD  CONSTRAINT [DF_adm_servicios_empresa_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[adm_servicios_empresa] ADD  CONSTRAINT [DF_adm_servicios_empresa_idservicio]  DEFAULT ((0)) FOR [idservicio]
GO
ALTER TABLE [dbo].[adm_servicios_empresa] ADD  CONSTRAINT [DF_adm_servicios_empresa_inicio]  DEFAULT ('19000101') FOR [inicio]
GO
ALTER TABLE [dbo].[adm_servicios_empresa] ADD  CONSTRAINT [DF_adm_servicios_empresa_termino]  DEFAULT ('19000101') FOR [termino]
GO
ALTER TABLE [dbo].[adm_servicios_empresa] ADD  CONSTRAINT [DF_adm_servicios_empresa_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_servicios_empresa] ADD  CONSTRAINT [DF_adm_servicios_empresa_fecharegistro]  DEFAULT ('19000101') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_tipos_activos] ADD  CONSTRAINT [DF_adm_tipos_activos_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_tipos_activos] ADD  CONSTRAINT [DF_adm_tipos_activos_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_tipos_activos] ADD  CONSTRAINT [DF_adm_tipos_activos_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_tipos_activos] ADD  CONSTRAINT [DF_adm_tipos_activos_fechausuario]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_tipos_documentos] ADD  CONSTRAINT [DF_adm_tipo_documento_idtipodocumento]  DEFAULT (' ') FOR [idtipodocumento]
GO
ALTER TABLE [dbo].[adm_tipos_documentos] ADD  CONSTRAINT [DF_adm_tipo_documento_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_tipos_documentos] ADD  CONSTRAINT [DF_adm_tipo_documento_sigla]  DEFAULT (' ') FOR [sigla]
GO
ALTER TABLE [dbo].[adm_tipos_documentos] ADD  CONSTRAINT [DF_adm_tipos_documentos_digitos]  DEFAULT ((0)) FOR [digitos]
GO
ALTER TABLE [dbo].[adm_tipos_documentos] ADD  CONSTRAINT [DF_adm_tipo_documento_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_tipos_documentos] ADD  CONSTRAINT [DF_adm_tipo_documento_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_tipos_documentos] ADD  CONSTRAINT [DF_adm_tipo_documento_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_tipos_incidencias] ADD  CONSTRAINT [DF_adm_tipos_incidencias_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_tipos_incidencias] ADD  CONSTRAINT [DF_adm_tipos_incidencias_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_tipos_incidencias] ADD  CONSTRAINT [DF_adm_tipos_incidencias_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_tipos_incidencias] ADD  CONSTRAINT [DF_adm_tipos_incidencias_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_tipos_personal] ADD  CONSTRAINT [DF_adm_tipos_personal_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_tipos_personal] ADD  CONSTRAINT [DF_adm_tipos_personal_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[adm_tipos_personal] ADD  CONSTRAINT [DF_adm_tipos_personal_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_tipos_personal] ADD  CONSTRAINT [DF_adm_tipos_personal_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[adm_tipos_vehiculos] ADD  CONSTRAINT [DF_adm_tipos_vehiculos_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[adm_tipos_vehiculos] ADD  CONSTRAINT [DF_adm_tipos_vehiculos_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[adm_tipos_vehiculos] ADD  CONSTRAINT [DF_adm_tipos_vehiculos_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_idusuario]  DEFAULT ((0)) FOR [idusuario]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_accion]  DEFAULT ((0)) FOR [accion]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_opcion]  DEFAULT (' ') FOR [opcion]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_valoranterior]  DEFAULT (' ') FOR [valoranterior]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_valoractual]  DEFAULT (' ') FOR [valoractual]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_dispositivo]  DEFAULT (' ') FOR [dispositivo]
GO
ALTER TABLE [dbo].[seg_log_actividades] ADD  CONSTRAINT [DF_seg_log_actividades_ip]  DEFAULT (' ') FOR [ip]
GO
ALTER TABLE [dbo].[seg_log_db_error] ADD  CONSTRAINT [DF_seg_db_error_hora]  DEFAULT (getdate()) FOR [hora]
GO
ALTER TABLE [dbo].[seg_roles] ADD  CONSTRAINT [DF_seg_roles_nombre]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[seg_roles] ADD  CONSTRAINT [DF_seg_roles_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[seg_roles] ADD  CONSTRAINT [DF_seg_roles_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[seg_roles] ADD  CONSTRAINT [DF_seg_roles_fecharegistro]  DEFAULT ('19000101') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[seg_usuarios] ADD  CONSTRAINT [DF_seg_usuarios_idtipodocumento]  DEFAULT (' ') FOR [idtipodocumento]
GO
ALTER TABLE [dbo].[seg_usuarios] ADD  CONSTRAINT [DF_seg_usuarios_ultimoingreso]  DEFAULT ('19000101') FOR [ultimoingreso]
GO
ALTER TABLE [dbo].[seg_usuarios] ADD  CONSTRAINT [DF_seg_usuarios_cambioclave]  DEFAULT ('19000101') FOR [cambioclave]
GO
ALTER TABLE [dbo].[seg_usuarios] ADD  CONSTRAINT [DF_seg_usuarios_idrol]  DEFAULT ((0)) FOR [administrador]
GO
ALTER TABLE [dbo].[seg_usuarios] ADD  CONSTRAINT [DF_seg_usuarios_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[seg_usuarios] ADD  CONSTRAINT [DF_seg_usuarios_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[seg_usuarios] ADD  CONSTRAINT [DF_seg_usuarios_fecharegistro]  DEFAULT ('19000101') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[seg_usuarios_empresa] ADD  CONSTRAINT [DF_seg_usuarios_empresa_idusuario]  DEFAULT ((0)) FOR [idusuario]
GO
ALTER TABLE [dbo].[seg_usuarios_empresa] ADD  CONSTRAINT [DF_seg_usuarios_empresa_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[seg_usuarios_empresa] ADD  CONSTRAINT [DF_seg_usuarios_empresa_idrol]  DEFAULT ((0)) FOR [idrol]
GO
ALTER TABLE [dbo].[seg_usuarios_empresa] ADD  CONSTRAINT [DF_seg_usuarios_empresa_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[seg_usuarios_empresa] ADD  CONSTRAINT [DF_seg_usuarios_empresa_fecharegistro]  DEFAULT ('19000101') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[seg_usuarios_password] ADD  CONSTRAINT [DF_seg_usuarios_password_idusuario]  DEFAULT ((0)) FOR [idusuario]
GO
ALTER TABLE [dbo].[seg_usuarios_password] ADD  CONSTRAINT [DF_seg_usuarios_password_fecharegistro]  DEFAULT ('1900-01-01') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[seg_usuarios_sede] ADD  CONSTRAINT [DF_seg_usuarios_sede_idusuario]  DEFAULT ((0)) FOR [idusuario]
GO
ALTER TABLE [dbo].[seg_usuarios_sede] ADD  CONSTRAINT [DF_Table_1_idempresa]  DEFAULT ((0)) FOR [idsede]
GO
ALTER TABLE [dbo].[seg_usuarios_sede] ADD  CONSTRAINT [DF_seg_usuarios_sede_idrol]  DEFAULT ((0)) FOR [idrol]
GO
ALTER TABLE [dbo].[seg_usuarios_sede] ADD  CONSTRAINT [DF_seg_usuarios_sede_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[seg_usuarios_sede] ADD  CONSTRAINT [DF_seg_usuarios_sede_fecharegistro]  DEFAULT ('19000101') FOR [fecharegistro]
GO
ALTER TABLE [dbo].[sis_parametros] ADD  CONSTRAINT [DF_sis_parametros_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[sis_parametros] ADD  CONSTRAINT [DF_sis_parametros_idusuario]  DEFAULT ((0)) FOR [idusuario]
GO
ALTER TABLE [dbo].[sis_parametros] ADD  CONSTRAINT [DF_sis_parametros_variable]  DEFAULT (' ') FOR [variable]
GO
ALTER TABLE [dbo].[sis_parametros] ADD  CONSTRAINT [DF_sis_parametros_valor]  DEFAULT (' ') FOR [valor]
GO
ALTER TABLE [dbo].[sis_parametros] ADD  CONSTRAINT [DF_sis_parametros_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[sis_parametros] ADD  CONSTRAINT [DF_sis_parametros_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[vig_camaras] ADD  CONSTRAINT [DF_vig_camaras_idpuesto]  DEFAULT ((0)) FOR [idpuesto]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_idtipocorrespondencia]  DEFAULT ((0)) FOR [idtipocorrespondencia]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_destinatario_idpersonal]  DEFAULT ((0)) FOR [destinatario_idpersonal]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_remitente]  DEFAULT (' ') FOR [remitente]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_recepcion_fecha]  DEFAULT ('19000101') FOR [recepcion_fecha]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_recepcion_usuario]  DEFAULT (' ') FOR [recepcion_usuario]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_recepcion_observacion]  DEFAULT (' ') FOR [recepcion_observacion]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_entrega_fecha]  DEFAULT ('19000101') FOR [entrega_fecha]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_entrega_usuario]  DEFAULT (' ') FOR [entrega_usuario]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_documentos_entrega_observacion]  DEFAULT (' ') FOR [entrega_observacion]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_correspondencia_uuid]  DEFAULT (newid()) FOR [uuid]
GO
ALTER TABLE [dbo].[vig_correspondencia] ADD  CONSTRAINT [DF_vig_correspondencia_activo]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[vig_documentos_upload] ADD  CONSTRAINT [DF_vig_documentos_upload_uuid]  DEFAULT (newid()) FOR [uuid]
GO
ALTER TABLE [dbo].[vig_incidencias] ADD  CONSTRAINT [DF_vig_incidencias_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[vig_incidencias] ADD  CONSTRAINT [DF_vig_incidencias_idsede]  DEFAULT ((0)) FOR [idsede]
GO
ALTER TABLE [dbo].[vig_incidencias] ADD  CONSTRAINT [DF_vig_incidencias_idpuesto]  DEFAULT ((0)) FOR [idpuesto]
GO
ALTER TABLE [dbo].[vig_incidencias] ADD  CONSTRAINT [DF_vig_incidencias_uuid]  DEFAULT (newid()) FOR [uuid]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_idempresa]  DEFAULT ((0)) FOR [idempresa]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_idsede]  DEFAULT ((0)) FOR [idsede]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_idpuesto]  DEFAULT ((0)) FOR [idpuesto]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_tipopersona]  DEFAULT ((0)) FOR [idtipopersonal]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_idpersonal]  DEFAULT ((0)) FOR [idpersonal]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_idpersonalvisita]  DEFAULT ((0)) FOR [idpersonalvisita]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_Table_1_idtiporegistro]  DEFAULT ((0)) FOR [ingreso_tiporegistro]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_ingreso_hora]  DEFAULT ('1900-01-01') FOR [ingreso_hora]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_Ingreso_idsede]  DEFAULT ((0)) FOR [ingreso_idsede]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_ingreso_idvehiculo]  DEFAULT ((0)) FOR [ingreso_idvehiculo]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_ingreso_observacion]  DEFAULT (' ') FOR [ingreso_observacion]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_ingreso_usuario]  DEFAULT (' ') FOR [ingreso_usuario]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_salida_tiporegistro]  DEFAULT ((0)) FOR [salida_tiporegistro]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_salida_hora]  DEFAULT ('1900-01-01') FOR [salida_hora]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_salida_idsede]  DEFAULT ((0)) FOR [salida_idsede]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_salida_idvehiculo]  DEFAULT ((0)) FOR [salida_idvehiculo]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_salida_observacion]  DEFAULT (' ') FOR [salida_observacion]
GO
ALTER TABLE [dbo].[vig_ingresosalida] ADD  CONSTRAINT [DF_vig_ingresosalida_salida_usuario]  DEFAULT (' ') FOR [salida_usuario]
GO
ALTER TABLE [dbo].[vig_ingresosalida_activos] ADD  CONSTRAINT [DF_vig_ingresosalida_activos_salida]  DEFAULT ('19000101') FOR [salida]
GO
ALTER TABLE [dbo].[vig_puestos] ADD  CONSTRAINT [DF_vig_puestos_idarea]  DEFAULT ((0)) FOR [idsede]
GO
ALTER TABLE [dbo].[vig_puestos] ADD  CONSTRAINT [DF_vig_puestos_idcamara]  DEFAULT (' ') FOR [nombre]
GO
ALTER TABLE [dbo].[vig_puestos] ADD  CONSTRAINT [DF_vig_puestos_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[vig_puestos] ADD  CONSTRAINT [DF_vig_puestos_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[vig_puestos] ADD  CONSTRAINT [DF_vig_puestos_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_placa]  DEFAULT (' ') FOR [placa]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_marca]  DEFAULT (' ') FOR [marca]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_Table_1_idtipo]  DEFAULT ((0)) FOR [idtipovehiculo]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_vencimiento_soat]  DEFAULT ('1900-01-01') FOR [vencimiento_soat]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_vencimiento_revision]  DEFAULT ('1900-01-01') FOR [vencimiento_revision]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_codigo]  DEFAULT (' ') FOR [codigo]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_observacion]  DEFAULT (' ') FOR [observacion]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_activo]  DEFAULT ((0)) FOR [activo]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_usuarioregistro]  DEFAULT (' ') FOR [usuarioregistro]
GO
ALTER TABLE [dbo].[vig_vehiculos] ADD  CONSTRAINT [DF_vig_vehiculos_fecharegistro]  DEFAULT (getdate()) FOR [fecharegistro]
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_areas_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_areas
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_areas_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idarea
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_areas.nombre
			  ,adm_empresas_areas.activo
			  ,adm_empresas_areas.usuarioregistro
			  ,adm_empresas_areas.fecharegistro
		FROM adm_empresas_areas
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_empresas_areas.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_empresas_areas.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_empresas_areas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_areas_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_areas por sede y por empresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_areas_lista_idempresa]
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idarea
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_areas.nombre
			  ,adm_empresas_areas.activo
			  ,adm_empresas_areas.usuarioregistro
			  ,adm_empresas_areas.fecharegistro
		FROM adm_empresas_areas
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND adm_empresas_areas.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND adm_empresas_areas.activo = 0 THEN 1 -- inactivos
			END = 1
		AND adm_empresas_sedes.idempresa = @idempresa
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, adm_empresas_areas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_areas_lista_idsede]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_areas por sede
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_areas_lista_idsede]
@idsede INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idarea
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_areas.nombre
			  ,adm_empresas_areas.activo
			  ,adm_empresas_areas.usuarioregistro
			  ,adm_empresas_areas.fecharegistro
		FROM adm_empresas_areas
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND adm_empresas_areas.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND adm_empresas_areas.activo = 0 THEN 1 -- inactivos
			END = 1
		AND adm_empresas_areas.idsede = @idsede
		ORDER BY adm_empresas_areas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_areas_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_empresas_areas
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_areas_mantenimiento]
@tipo INT,
@idarea INT = NULL OUTPUT,
@idsede INT = 0,
@nombre VARCHAR(50) = " ",
@activo INT = 0,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_empresas_areas VALUES(
						@idsede
						,@nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idsede = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_empresas_areas
						SET nombre = @nombre
							,activo = @activo
						WHERE idarea = @idarea
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_empresas_areas WHERE idarea = @idarea
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_cargos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 03/10/2023
-- Description:	Lista de la tabla adm_empresas_terceros
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_cargos_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idcargo
		      ,adm_empresas.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_cargos.nombre
			  ,adm_empresas_cargos.activo
			  ,adm_empresas_cargos.usuarioregistro
			  ,adm_empresas_cargos.fecharegistro
		FROM adm_empresas_cargos
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_cargos.idempresa
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_empresas_cargos.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_empresas_cargos.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_empresas_cargos.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_cargos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 03/10/2023
-- Description:	Mantenimiento de la tabla adm_empresas_tercero
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_cargos_mantenimiento] 
@tipo INT,
@idcargo INT = NULL OUTPUT,
@idempresa INT = NULL OUTPUT,
@nombre VARCHAR(100) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_empresas_cargos VALUES(
						 @idempresa
						,@nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idcargo = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_empresas_cargos
						SET idempresa = @idempresa
							,nombre = @nombre
							,activo = @activo
						WHERE idcargo = @idcargo
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_empresas_cargos WHERE idcargo = @idcargo
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idempresa
			  ,nombre
			  ,ruc
			  ,direccion
			  ,distrito
			  ,ciudad
			  ,telefono
			  ,email
			  ,activo
			  ,logo
			  ,isotipo
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_empresas
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_empresas
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_mantenimiento] 
@tipo INT,
@idempresa INT = NULL OUTPUT,
@nombre VARCHAR(100) = " ",
@ruc VARCHAR(11) = " ",
@direccion VARCHAR(100) = " ",
@distrito VARCHAR(50) = " ",
@ciudad VARCHAR(50) = " ",
@telefono VARCHAR(20) = " ",
@email VARCHAR(80) = " ",
@activo INT = 1,
@logo IMAGE = null,
@isotipo IMAGE = null,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_empresas VALUES(
						@nombre
						,@ruc
						,@direccion
						,@distrito
						,@ciudad
						,@telefono
						,@email
						,@activo
						,@logo
						,@isotipo
						,@usuarioregistro
						,GETDATE())

					SET @idempresa = SCOPE_IDENTITY();

					INSERT INTO adm_empresas_sedes VALUES (
						 @idempresa
						,'OFICINA PRINCIPAL'
						,@direccion
						,@distrito
						,@ciudad
						,@activo
						,@usuarioregistro
						,GETDATE())

					INSERT INTO adm_empresas_terceros VALUES (
						 @idempresa
						,@ruc
						,@nombre
						,@direccion
						,@activo
						,@usuarioregistro
						,GETDATE())
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_empresas
						SET nombre = @nombre
							,ruc = @ruc
							,direccion = @direccion
							,distrito = @distrito
							,ciudad = @ciudad
							,telefono = @telefono
							,email = @email
							,activo = @activo
							,logo = @logo
							,isotipo = @isotipo
						WHERE idempresa = @idempresa
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_empresas WHERE idempresa = @idempresa
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_sedes_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_sedes
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_sedes_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idsede
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.nombre
			  ,adm_empresas_sedes.direccion
			  ,adm_empresas_sedes.distrito
			  ,adm_empresas_sedes.ciudad
			  ,adm_empresas_sedes.activo
			  ,adm_empresas_sedes.usuarioregistro
			  ,adm_empresas_sedes.fecharegistro
		FROM adm_empresas_sedes
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_empresas_sedes.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_empresas_sedes.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_sedes_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_sedes
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_sedes_lista_idempresa]
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idsede
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.nombre
			  ,adm_empresas_sedes.direccion
			  ,adm_empresas_sedes.distrito
			  ,adm_empresas_sedes.ciudad
			  ,adm_empresas_sedes.activo
			  ,adm_empresas_sedes.usuarioregistro
			  ,adm_empresas_sedes.fecharegistro
		FROM adm_empresas_sedes
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND adm_empresas_sedes.activo = 1 AND adm_empresas_sedes.idempresa = @idempresa THEN 1 -- activos + empresa
				WHEN @idestado = 0 AND adm_empresas_sedes.activo = 0 AND adm_empresas_sedes.idempresa = @idempresa THEN 1 -- inactivos + empresa
			END = 1
		AND adm_empresas_sedes.idempresa = @idempresa
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_sedes_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_empresas_sedes
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_sedes_mantenimiento]
@tipo INT,
@idsede INT = NULL OUTPUT,
@idempresa INT = 0,
@nombre VARCHAR(50) = " ",
@direccion VARCHAR(100) = " ",
@distrito VARCHAR(50) = " ",
@ciudad VARCHAR(50) = " ",
@activo INT = 0,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_empresas_sedes VALUES(
						@idempresa
						,@nombre
						,@direccion
						,@distrito
						,@ciudad
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idsede = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_empresas_sedes
						SET idempresa = @idempresa
							,nombre = @nombre
							,direccion = @direccion
							,distrito = @distrito
							,ciudad = @ciudad
							,activo = @activo
						WHERE idsede = @idsede
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_empresas_sedes WHERE idsede = @idsede
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_terceros_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_terceros
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_terceros_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtercero
		      ,adm_empresas.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_terceros.ruc
			  ,adm_empresas_terceros.nombre
			  ,adm_empresas_terceros.direccion
			  ,adm_empresas_terceros.activo
			  ,adm_empresas_terceros.usuarioregistro
			  ,adm_empresas_terceros.fecharegistro
		FROM adm_empresas_terceros
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_terceros.idempresa
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_empresas_terceros.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_empresas_terceros.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_empresas_terceros.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_terceros_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 03/10/2023
-- Description:	Lista de la tabla adm_empresas_terceros
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_terceros_lista_idempresa] 
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtercero
		      ,adm_empresas.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_terceros.ruc
			  ,adm_empresas_terceros.nombre
			  ,adm_empresas_terceros.direccion
			  ,adm_empresas_terceros.activo
			  ,adm_empresas_terceros.usuarioregistro
			  ,adm_empresas_terceros.fecharegistro
		FROM adm_empresas_terceros
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_terceros.idempresa
		WHERE adm_empresas_terceros.idempresa = @idempresa
		AND CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_empresas_terceros.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_empresas_terceros.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_empresas_terceros.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_terceros_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_empresas_tercero
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_terceros_mantenimiento] 
@tipo INT,
@idtercero INT = NULL OUTPUT,
@idempresa INT = NULL OUTPUT,
@ruc VARCHAR(11) = " ",
@nombre VARCHAR(100) = " ",
@direccion VARCHAR(100) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_empresas_terceros VALUES(
						 @idempresa
						,@ruc
						,@nombre
						,@direccion
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idtercero = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_empresas_terceros
						SET idempresa = @idempresa
							,nombre = @nombre
							,ruc = @ruc
							,direccion = @direccion
							,activo = @activo
						WHERE idtercero = @idtercero
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_empresas_terceros WHERE idtercero = @idtercero
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_tipos_personal_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_tipos_personal
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_tipos_personal_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipopersonalempresa
			  ,adm_empresas_tipos_personal.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_tipos_personal.nombre AS nombre
			  ,adm_empresas_tipos_personal.flgarea
			  ,adm_empresas_tipos_personal.flgbrevete
			  ,adm_empresas_tipos_personal.activo
			  ,adm_empresas_tipos_personal.usuarioregistro
			  ,adm_empresas_tipos_personal.fecharegistro
		FROM adm_empresas_tipos_personal
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_tipos_personal.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_empresas_tipos_personal.idtipopersonal
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_empresas_tipos_personal.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_empresas_tipos_personal.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_empresas.nombre, adm_tipos_personal.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_tipos_personal_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_tipos_personal por idempresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_tipos_personal_lista_idempresa] 
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipopersonalempresa
			  ,adm_empresas_tipos_personal.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_tipos_personal.nombre AS nombre
			  ,adm_empresas_tipos_personal.flgarea
			  ,adm_empresas_tipos_personal.flgbrevete
			  ,adm_empresas_tipos_personal.activo
			  ,adm_empresas_tipos_personal.usuarioregistro
			  ,adm_empresas_tipos_personal.fecharegistro
		FROM adm_empresas_tipos_personal
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_tipos_personal.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_empresas_tipos_personal.idtipopersonal
		WHERE adm_empresas_tipos_personal.idempresa = @idempresa
			AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND adm_empresas_tipos_personal.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND adm_empresas_tipos_personal.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_tipos_personal.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_empresas_tipos_personal_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_empresas_tipos_personal
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_empresas_tipos_personal_mantenimiento]
@tipo INT,
@idtipopersonalempresa INT = NULL OUTPUT,
@idempresa INT = 0,
@idtipopersonal INT = 0,
@flgarea INT = 0,
@flgbrevete INT = 0,
@activo INT = 0,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_empresas_tipos_personal VALUES(
						@idempresa
						,@idtipopersonal
						,@flgarea
						,@flgbrevete
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idtipopersonalempresa = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_empresas_tipos_personal
						SET idempresa = @idempresa
							,idtipopersonal = @idtipopersonal
							,flgarea = @flgarea
							,flgbrevete = @flgbrevete
							,activo = @activo
						WHERE idtipopersonalempresa = @idtipopersonalempresa
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_empresas_tipos_personal WHERE idtipopersonalempresa = @idtipopersonalempresa
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_activos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal_activos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_activos_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal_activos.idpersonalactivo
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.nombre AS area
			  ,adm_tipos_personal.nombre AS tipo
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipo
			  ,adm_personal_activos.equipo
			  ,adm_personal_activos.serie
			  ,adm_personal_activos.modelo
			  ,adm_personal_activos.marca
			  ,adm_personal_activos.color
			  ,adm_personal_activos.propietario
			  ,adm_personal_activos.autorizador
			  ,adm_personal_activos.codigobarras
			  ,adm_personal_activos.usuarioregistro
			  ,adm_personal_activos.fecharegistro
		FROM adm_personal_activos
		INNER JOIN adm_personal ON adm_personal.idpersonal = adm_personal_activos.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = adm_personal_activos.idtipoactivo
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idempresa
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_personal_activos.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_personal_activos.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_activos_lista_equipo]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal_activos por equipo
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_activos_lista_equipo] 
@equipo VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal_activos.idpersonalactivo
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.nombre AS area
			  ,adm_tipos_personal.nombre AS tipo
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipo
			  ,adm_personal_activos.equipo
			  ,adm_personal_activos.serie
			  ,adm_personal_activos.modelo
			  ,adm_personal_activos.marca
			  ,adm_personal_activos.color
			  ,adm_personal_activos.propietario
			  ,adm_personal_activos.autorizador
			  ,adm_personal_activos.codigobarras
			  ,adm_personal_activos.usuarioregistro
			  ,adm_personal_activos.fecharegistro
		FROM adm_personal_activos
		INNER JOIN adm_personal ON adm_personal.idpersonal = adm_personal_activos.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = adm_personal_activos.idtipoactivo
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE adm_personal_activos.equipo = @equipo
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_activos_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal_activos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_activos_lista_idempresa] 
@idempresa INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal_activos.idpersonalactivo
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.nombre AS area
			  ,adm_tipos_personal.nombre AS tipo
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipo
			  ,adm_personal_activos.equipo
			  ,adm_personal_activos.serie
			  ,adm_personal_activos.modelo
			  ,adm_personal_activos.marca
			  ,adm_personal_activos.color
			  ,adm_personal_activos.propietario
			  ,adm_personal_activos.autorizador
			  ,adm_personal_activos.codigobarras
			  ,adm_personal_activos.usuarioregistro
			  ,adm_personal_activos.fecharegistro
		FROM adm_personal_activos
		INNER JOIN adm_personal ON adm_personal.idpersonal = adm_personal_activos.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = adm_personal_activos.idtipoactivo
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idempresa
		WHERE terceros.idempresa = @idempresa
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_activos_lista_idpersonal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal_activos por idpersona
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_activos_lista_idpersonal] 
@idpersonal INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal_activos.idpersonalactivo
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.nombre AS area
			  ,adm_tipos_personal.nombre AS tipo
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipo
			  ,adm_personal_activos.equipo
			  ,adm_personal_activos.serie
			  ,adm_personal_activos.modelo
			  ,adm_personal_activos.marca
			  ,adm_personal_activos.color
			  ,adm_personal_activos.propietario
			  ,adm_personal_activos.autorizador
			  ,adm_personal_activos.codigobarras
			  ,adm_personal_activos.usuarioregistro
			  ,adm_personal_activos.fecharegistro
		FROM adm_personal_activos
		INNER JOIN adm_personal ON adm_personal.idpersonal = adm_personal_activos.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = adm_personal_activos.idtipoactivo
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE adm_personal_activos.idpersonal = @idpersonal
		AND CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_personal_activos.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_personal_activos.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_activos_lista_serie]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal_activos por serie
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_activos_lista_serie] 
@serie VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal_activos.idpersonalactivo
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.nombre AS area
			  ,adm_tipos_personal.nombre AS tipo
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipo
			  ,adm_personal_activos.equipo
			  ,adm_personal_activos.serie
			  ,adm_personal_activos.modelo
			  ,adm_personal_activos.marca
			  ,adm_personal_activos.color
			  ,adm_personal_activos.propietario
			  ,adm_personal_activos.autorizador
			  ,adm_personal_activos.codigobarras
			  ,adm_personal_activos.usuarioregistro
			  ,adm_personal_activos.fecharegistro
		FROM adm_personal_activos
		INNER JOIN adm_personal ON adm_personal.idpersonal = adm_personal_activos.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = adm_personal_activos.idtipoactivo
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE adm_personal_activos.serie = @serie
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_activos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 06/11/2023
-- Description:	Mantenimiento de la tabla adm_personal_activos
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_activos_mantenimiento]
@tipo INT,
@idpersonalactivo INT = NULL OUTPUT,
@idpersonal INT = 0,
@idtipoactivo VARCHAR(50) = " ",
@equipo VARCHAR(50) = " ",
@serie VARCHAR(50) = " ",
@modelo VARCHAR(50) = " ",
@marca VARCHAR(50) = " ",
@color VARCHAR(50) = " ",
@propietario VARCHAR(50) = " ",
@autorizador VARCHAR(50) = " ",
@codigobarras VARCHAR(50) = " ",
@activo INT = 0,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_personal_activos VALUES(
						@idpersonal
						,@idtipoactivo
						,@equipo
						,@serie
						,@modelo
						,@marca
						,@color
						,@propietario
						,@autorizador
						,@codigobarras
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idpersonalactivo = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_personal_activos
						SET 
							 idpersonal = @idpersonal
							,idtipoactivo = @idtipoactivo
							,equipo = @equipo
							,serie = @serie
							,modelo = @modelo
							,marca = @marca
							,color = @color
							,propietario = @propietario
							,autorizador = @autorizador
							,codigobarras = @codigobarras
							,activo = @activo
						WHERE idpersonalactivo = @idpersonalactivo
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_personal_activos WHERE idpersonalactivo = @idpersonalactivo
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.idtipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_personas.brevete
			  ,adm_personas.brevete_tipo
			  ,adm_personas.brevete_vencimiento
			  ,adm_personas.discamec
			  ,adm_personas.discamec_vencimiento
			  /*,adm_empresas.idempresa
			  ,adm_empresas.nombre AS empresa*/
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  /*,adm_empresas_areas.idarea
			  ,adm_empresas_areas.nombre AS area*/
			  ,adm_empresas_cargos.idcargo
			  ,adm_empresas_cargos.nombre AS cargo
			  ,adm_personal.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_personal.codigo
			  ,adm_personal.codigoenlace
			  ,adm_personal.fechaingreso
			  ,adm_personal.fechacese
		      ,adm_personal.idarea
			  ,adm_empresas_areas.nombre AS area
			  ,adm_personal.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipopersonal
			  ,adm_personal.idtercero
			  ,terceros.nombre AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal.usuarioregistro
			  ,adm_personal.fecharegistro
		FROM adm_personal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_empresas_terceros terceros ON terceros.idtercero = adm_personal.idtercero
		INNER JOIN adm_empresas_cargos ON adm_empresas_cargos.idcargo = adm_personal.idcargo
		/*LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero*/
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND adm_personal.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND adm_personal.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_personal en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_lista_idempresa] 
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_empresas.nombre AS empresa
			  ,adm_personal.codigo
			  ,adm_personal.codigoenlace
		      ,adm_personal.idarea
			  ,adm_empresas_areas.nombre AS area
			  ,adm_personal.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipo
			  ,adm_personal.idtercero
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal.usuarioregistro
			  ,adm_personal.fecharegistro
		FROM adm_personal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND adm_personal.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND adm_personal.activo = 0 THEN 1 -- inactivos
			END = 1
		AND adm_empresas_sedes.idempresa = @idempresa
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_lista_idempresa_idtipopersonal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_lista_idempresa_idtipopersonal] 
@idempresa INT = 0,
@idtipopersonal INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.idtipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_personas.brevete
			  ,adm_personas.brevete_tipo
			  ,adm_personas.brevete_vencimiento
			  ,adm_personas.discamec
			  ,adm_personas.discamec_vencimiento
			  /*,adm_empresas.idempresa
			  ,adm_empresas.nombre AS empresa*/
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  /*,adm_empresas_areas.idarea
			  ,adm_empresas_areas.nombre AS area*/
			  ,adm_empresas_cargos.idcargo
			  ,adm_empresas_cargos.nombre AS cargo
			  ,adm_personal.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_personal.codigo
			  ,adm_personal.codigoenlace
			  ,adm_personal.fechaingreso
			  ,adm_personal.fechacese
		      ,adm_personal.idarea
			  ,adm_empresas_areas.nombre AS area
			  ,adm_personal.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipopersonal
			  ,adm_personal.idtercero
			  ,terceros.nombre AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal.usuarioregistro
			  ,adm_personal.fecharegistro
		FROM adm_personal
		LEFT JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		LEFT JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		LEFT JOIN adm_empresas ON adm_empresas.idempresa = adm_personal.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		LEFT JOIN adm_empresas_terceros terceros ON terceros.idtercero = adm_personal.idtercero
		LEFT JOIN adm_empresas_cargos ON adm_empresas_cargos.idcargo = adm_personal.idcargo
		/*LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero*/
		WHERE adm_personal.idempresa = @idempresa AND adm_personal.idtipopersonal = @idtipopersonal
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_lista_idpersonal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_personal en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_lista_idpersonal] 
@idpersonal INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_empresas.nombre AS empresa
			  ,adm_personal.codigo
			  ,adm_personal.codigoenlace
		      ,adm_personal.idarea
			  ,adm_empresas_areas.nombre AS area
			  ,adm_personal.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipo
			  ,adm_personal.idtercero
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal.usuarioregistro
			  ,adm_personal.fecharegistro
		FROM adm_personal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND adm_personal.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND adm_personal.activo = 0 THEN 1 -- inactivos
			END = 1
		AND adm_personal.idpersonal = @idpersonal
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_lista_idsede]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_empresas_personal en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_lista_idsede] 
@idsede INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_empresas.nombre AS empresa
			  ,adm_personal.codigo
			  ,adm_personal.codigoenlace
		      ,adm_personal.idarea
			  ,adm_empresas_areas.nombre AS area
			  ,adm_personal.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipo
			  ,adm_personal.idtercero
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,adm_personal.usuarioregistro
			  ,adm_personal.fecharegistro
		FROM adm_personal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND adm_personal.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND adm_personal.activo = 0 THEN 1 -- inactivos
			END = 1
		AND adm_empresas_sedes.idsede = @idsede
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personal_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla ad_personal
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personal_mantenimiento] 
@tipo INT,
@idpersonal INT = NULL OUTPUT,
@idpersona INT = 0,
@codigo VARCHAR(20) = " ",
@codigoenlace VARCHAR(20) = " ",
@idempresa INT = 0,
@idarea INT = 0,
@fechaingreso DATETIME = "1900-01-01",
@fechacese DATETIME = "1900-01-01",
@idcargo INT = 0,
@idtipopersonal INT = 0,
@idtercero INT = 0,
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_personal VALUES(
						@idpersona
						,@codigo
						,@codigoenlace
						,@idempresa
						,@idarea
						,@fechaingreso
						,@fechacese
						,@idcargo
						,@idtipopersonal
						,@idtercero
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idpersonal = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_personal
						SET idpersona = @idpersona
							,codigo = @codigo
							,codigoenlace = @codigoenlace
							,idempresa = @idempresa
							,idarea = @idarea
							,fechaingreso = @fechaingreso
							,fechacese = @fechacese
							,idcargo = @idcargo
							,idtipopersonal = @idtipopersonal
							,idtercero = @idtercero
							,activo = @activo
						WHERE idpersonal = @idpersonal
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_personal WHERE idpersonal = @idpersonal
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personas_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personas en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personas_lista] 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idpersona
			  ,adm_personas.idtipodocumento
			  ,adm_tipos_documentos.nombre AS tipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombrecompleto
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_personas.brevete
			  ,adm_personas.brevete_tipo
			  ,adm_personas.brevete_vencimiento 
			  ,adm_personas.discamec
			  ,adm_personas.discamec_vencimiento 
			  ,adm_personas.foto
			  ,adm_personas.usuarioregistro
			  ,adm_personas.fecharegistro
		FROM adm_personas
		INNER JOIN adm_tipos_documentos ON adm_tipos_documentos.idtipodocumento = adm_personas.idtipodocumento
		ORDER BY paterno,materno,nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personas_lista_documento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personas por tipo y numero de documento
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personas_lista_documento] 
@idtipodocumento VARCHAR(2) = " ",
@documento VARCHAR(10) = " "
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idpersona
			  ,adm_personas.idtipodocumento
			  ,adm_tipos_documentos.nombre AS tipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombrecompleto
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_personas.brevete
			  ,adm_personas.brevete_tipo
			  ,adm_personas.brevete_vencimiento 
			  ,adm_personas.discamec
			  ,adm_personas.discamec_vencimiento 
			  ,adm_personas.foto
			  ,adm_personas.usuarioregistro
			  ,adm_personas.fecharegistro
		FROM adm_personas
		INNER JOIN adm_tipos_documentos ON adm_tipos_documentos.idtipodocumento = adm_personas.idtipodocumento
		WHERE adm_personas.idtipodocumento = @idtipodocumento AND adm_personas.documento = @documento
		ORDER BY paterno,materno,nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personas_lista_idpersona]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personas en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personas_lista_idpersona] 
@idpersona INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idpersona
			  ,adm_personas.idtipodocumento
			  ,adm_tipos_documentos.nombre AS tipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombrecompleto
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
			  ,adm_personas.brevete
			  ,adm_personas.brevete_tipo
			  ,adm_personas.brevete_vencimiento 
			  ,adm_personas.discamec
			  ,adm_personas.discamec_vencimiento 
			  ,adm_personas.foto
			  ,adm_personas.usuarioregistro
			  ,adm_personas.fecharegistro
		FROM adm_personas
		INNER JOIN adm_tipos_documentos ON adm_tipos_documentos.idtipodocumento = adm_personas.idtipodocumento
		WHERE adm_personas.idpersona = @idpersona
		ORDER BY paterno,materno,nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_personas_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_personas
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_personas_mantenimiento] 
@tipo INT,
@idpersona INT = NULL OUTPUT,
@idtipodocumento VARCHAR(2) = " ",
@documento VARCHAR(10) = " ",
@paterno VARCHAR(50) = " ",
@materno VARCHAR(50) = " ",
@nombre VARCHAR(50) = " ",
@nacimiento DATETIME = "1900-01-01",
@sexo VARCHAR(1) = "M",
@brevete VARCHAR(50) = " ",
@brevete_tipo VARCHAR(50) = " ",
@brevete_vencimiento DATETIME = "1900-01-01",
@discamec VARCHAR(50) = " ",
@discamec_vencimiento DATETIME = "1900-01-01",
@foto IMAGE = null,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_personas VALUES(
						@idtipodocumento
						,@documento
						,@paterno
						,@materno
						,@nombre
						,@nacimiento
						,@sexo
						,@brevete
						,@brevete_tipo
						,@brevete_vencimiento
						,@discamec
						,@discamec_vencimiento
						,@foto
						,@usuarioregistro
						,GETDATE())

					SET @idpersona = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_personas
						SET idtipodocumento = @idtipodocumento
							,documento = @documento
							,paterno = @paterno
							,materno = @materno
							,nombre = @nombre
							,nacimiento = @nacimiento
							,sexo = @sexo
							,brevete = @brevete
							,brevete_tipo = @brevete_tipo
							,brevete_vencimiento = @brevete_vencimiento
							,discamec = @discamec
							,discamec_vencimiento = @discamec_vencimiento
							,foto = @foto
						WHERE idpersona = @idpersona
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_personas WHERE idpersona = @idpersona
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_servicios_empresa_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_servicios_empresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_servicios_empresa_lista] 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idservicioempresa
			  ,adm_servicios_empresa.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas.ruc
			  ,adm_servicios_empresa.idservicio
			  ,adm_servicios.nombre AS servicio
			  ,adm_servicios_empresa.inicio
			  ,adm_servicios_empresa.termino
			  ,adm_servicios_empresa.usuarioregistro
			  ,adm_servicios_empresa.fecharegistro
		FROM adm_servicios_empresa
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_servicios_empresa.idempresa
		INNER JOIN adm_servicios ON adm_servicios.idservicio = adm_servicios_empresa.idservicio
		ORDER BY adm_empresas.nombre, adm_servicios.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_servicios_empresa_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_servicios_empresa por idempresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_servicios_empresa_lista_idempresa] 
@idempresa INT 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idservicioempresa
			  ,adm_servicios_empresa.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas.ruc
			  ,adm_servicios_empresa.idservicio
			  ,adm_servicios.nombre AS servicio
			  ,adm_servicios_empresa.inicio
			  ,adm_servicios_empresa.termino
			  ,adm_servicios.isotipo
			  ,adm_servicios.puesto
			  ,adm_servicios_empresa.usuarioregistro
			  ,adm_servicios_empresa.fecharegistro
		FROM adm_servicios_empresa
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_servicios_empresa.idempresa
		INNER JOIN adm_servicios ON adm_servicios.idservicio = adm_servicios_empresa.idservicio
		WHERE adm_servicios_empresa.idempresa = @idempresa
		ORDER BY adm_empresas.nombre, adm_servicios.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_servicios_empresa_lista_idservicio]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_servicios_empresa por idservicio
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_servicios_empresa_lista_idservicio]
@idservicio INT 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idservicioempresa
			  ,adm_servicios_empresa.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas.ruc
			  ,adm_servicios_empresa.idservicio
			  ,adm_servicios.nombre AS servicio
			  ,adm_servicios_empresa.inicio
			  ,adm_servicios_empresa.termino
			  ,adm_servicios_empresa.usuarioregistro
			  ,adm_servicios_empresa.fecharegistro
		FROM adm_servicios_empresa
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_servicios_empresa.idempresa
		INNER JOIN adm_servicios ON adm_servicios.idservicio = adm_servicios_empresa.idservicio
		WHERE adm_servicios_empresa.idservicio = @idservicio
		ORDER BY adm_empresas.nombre, adm_servicios.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_servicios_empresa_lista_idusuario]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_servicios_empresa por usuario
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_servicios_empresa_lista_idusuario] 
@idusuario INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idservicioempresa
			  ,adm_servicios_empresa.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas.ruc
			  ,adm_servicios_empresa.idservicio
			  ,adm_servicios.nombre AS servicio
			  ,adm_servicios_empresa.inicio
			  ,adm_servicios_empresa.termino
			  ,adm_servicios_empresa.usuarioregistro
			  ,adm_servicios_empresa.fecharegistro
		FROM adm_servicios_empresa
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_servicios_empresa.idempresa
		INNER JOIN adm_servicios ON adm_servicios.idservicio = adm_servicios_empresa.idservicio
		INNER JOIN seg_usuarios_empresa ON seg_usuarios_empresa.idempresa = adm_servicios_empresa.idempresa
		WHERE seg_usuarios_empresa.idusuario = @idusuario
		ORDER BY adm_empresas.nombre, adm_servicios.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_servicios_empresa_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_servicios_empresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_servicios_empresa_mantenimiento] 
@tipo INT,
@idservicioempresa INT = NULL OUTPUT,
@idempresa INT = 0,
@idservicio INT = 0,
@inicio DATETIME = "1900-01-01",
@termino DATETIME = "1900-01-01",
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_servicios_empresa VALUES(
						@idempresa
						,@idservicio
						,@inicio
						,@termino
						,@usuarioregistro
						,GETDATE())

					SET @idservicioempresa = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_servicios_empresa
						SET idempresa = @idempresa
							,idservicio = @idservicio
							,inicio = @inicio
							,termino = @termino
						WHERE idservicioempresa = @idservicioempresa
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_servicios_empresa WHERE idservicioempresa = @idservicioempresa
						END

			IF @tipo = 1 OR @tipo = 2
				BEGIN
					DECLARE @flgpuesto INT = 0
					BEGIN
						SELECT @flgpuesto = puesto FROM adm_servicios WHERE idservicio = @idservicio 
					END
					IF @flgpuesto = 1
						BEGIN
							INSERT INTO vig_puestos SELECT idsede, 'PUESTO ' + nombre, 1, @usuarioregistro, GETDATE() FROM adm_empresas_sedes WHERE idempresa = @idempresa AND idsede NOT IN (SELECT idsede FROM vig_puestos)
						END
					ELSE 
						IF @tipo = 3
							BEGIN
								DELETE adm_servicios_empresa WHERE idservicioempresa = @idservicioempresa
							END
				END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_servicios_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_servicios en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_servicios_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idservicio
			  ,nombre
			  ,isotipo
			  ,puesto 
			  ,activo
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_servicios
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_servicios_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_servicios
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_servicios_mantenimiento] 
@tipo INT,
@idservicio INT = NULL OUTPUT,
@nombre VARCHAR(100) = " ",
@isotipo IMAGE = null,
@puesto INT = 0,
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_servicios VALUES(
						@nombre
						,@isotipo
						,@puesto
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idservicio = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_servicios
						SET nombre = @nombre
							,isotipo = @isotipo
							,puesto = @puesto
							,activo = @activo
						WHERE idservicio = @idservicio
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_servicios WHERE idservicio = @idservicio
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_activos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personas en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_activos_lista]
@idestado INT = 2

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipoactivo
			  ,nombre
			  ,activo
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_tipos_activos
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_activos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_tipos_activos
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_activos_mantenimiento] 
@tipo INT,
@idtipoactivo INT = NULL OUTPUT,
@nombre VARCHAR(100) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_tipos_activos VALUES(
						@nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idtipoactivo = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_tipos_activos
						SET nombre = @nombre
							,activo = @activo
						WHERE idtipoactivo = @idtipoactivo
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_tipos_activos WHERE idtipoactivo = @idtipoactivo
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_documentos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personas en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_documentos_lista]
@idestado INT = 2
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipodocumento
			  ,nombre
			  ,sigla
			  ,digitos
			  ,activo
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_tipos_documentos
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_documentos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_tipos_documentos
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_documentos_mantenimiento] 
@tipo INT,
@idtipodocumento VARCHAR(2) = " ",
@nombre VARCHAR(100) = " ",
@sigla VARCHAR(4) = " ",
@digitos INT = 0,
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_tipos_documentos VALUES(
						@idtipodocumento
						,@nombre
						,@sigla
						,@digitos
						,@activo
						,@usuarioregistro
						,GETDATE())
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_tipos_documentos
						SET nombre = @nombre
							,sigla = @sigla
							,digitos = @digitos
							,activo = @activo
						WHERE idtipodocumento = @idtipodocumento
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_tipos_documentos WHERE idtipodocumento = @idtipodocumento
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_incidencias_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_tipos_incidencias en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_incidencias_lista] 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipoincidencia
			  ,nombre
			  ,activo
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_tipos_incidencias
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_incidencias_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 06/10/2023
-- Description:	Mantenimiento de la tabla adm_tipos_incidencias
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_incidencias_mantenimiento] 
@tipo INT,
@idtipoincidencia INT = NULL OUTPUT,
@activo INT = 0,
@nombre VARCHAR(50) = " ",
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_tipos_incidencias VALUES(
						 @nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idtipoincidencia = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_tipos_incidencias
						SET nombre = @nombre, activo = @activo
						WHERE idtipoincidencia = @idtipoincidencia
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_tipos_incidencias WHERE idtipoincidencia = @idtipoincidencia
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_ingresosalida_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_tipos_ingresosalida en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_ingresosalida_lista]
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipoingresosalida
			  ,nombre
			  ,activo
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_tipos_ingresosalida
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_ingresosalida_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_tipos_ingresosalida
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_ingresosalida_mantenimiento] 
@tipo INT,
@idtipoingresosalida INT = NULL OUTPUT,
@nombre VARCHAR(100) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_tipos_ingresosalida VALUES(
						 @nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idtipoingresosalida = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_tipos_ingresosalida
						SET nombre = @nombre
							,activo = @activo
						WHERE idtipoingresosalida = @idtipoingresosalida
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_tipos_ingresosalida WHERE idtipoingresosalida = @idtipoingresosalida
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_personal_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personas en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_personal_lista]
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipopersonal
			  ,nombre
			  ,activo
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_tipos_personal
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_personal_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla adm_tipos_personal
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_personal_mantenimiento] 
@tipo INT,
@idtipopersonal INT = NULL OUTPUT,
@nombre VARCHAR(100) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_tipos_personal VALUES(
						 @nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idtipopersonal = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_tipos_personal
						SET nombre = @nombre
							,activo = @activo
						WHERE idtipopersonal = @idtipopersonal
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_tipos_personal WHERE idtipopersonal = @idtipopersonal
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_vehiculos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_tipos_vehiculos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_vehiculos_lista] 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idtipovehiculo
			  ,nombre
			  ,usuarioregistro
			  ,fecharegistro
		FROM adm_tipos_vehiculos
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_adm_tipos_vehiculos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 06/10/2023
-- Description:	Mantenimiento de la tabla adm_tipos_vehiculos
-- =============================================
CREATE PROCEDURE [dbo].[USP_adm_tipos_vehiculos_mantenimiento] 
@tipo INT,
@idtipovehiculo INT = NULL OUTPUT,
@nombre VARCHAR(50) = " ",
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO adm_tipos_vehiculos VALUES(
						 @nombre
						,@usuarioregistro
						,GETDATE())

					SET @idtipovehiculo = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE adm_tipos_vehiculos
						SET nombre = @nombre
						WHERE idtipovehiculo = @idtipovehiculo
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE adm_tipos_vehiculos WHERE @idtipovehiculo = @idtipovehiculo
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_empresas_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla seg_empresas
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_empresas_mantenimiento] 
@tipo INT,
@idusuarioempresa INT = NULL OUTPUT,
@idusuario INT = 0,
@idempresa INT = 0,
@idrol INT = 0,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO seg_usuarios_empresa VALUES(
						 @idusuario
						,@idempresa
						,@idrol
						,@usuarioregistro
						,GETDATE())

					SET @idusuarioempresa = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE seg_usuarios_empresa
						SET idusuario = @idusuario
							,idempresa = @idempresa
							,idrol = @idrol
						WHERE idusuarioempresa = @idusuarioempresa
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE seg_usuarios_empresa WHERE idusuarioempresa = @idusuarioempresa
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_error_mostrar]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 01/05/2023
-- Description:	Muestra mensaje en el registro de errores
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_error_mostrar]
AS
BEGIN
    SET NOCOUNT ON;
    -- Imprimir información de error. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Gravedad ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', Estado ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedimiento ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Linea ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END

GO
/****** Object:  StoredProcedure [dbo].[USP_seg_error_registro]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 01/05/2023
-- Description:	Registro de errores
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_error_registro]
@iderror [int] = 0 OUTPUT -- contiene el iderror de la fila insertada

AS
BEGIN
    SET NOCOUNT ON;
	-- El valor del parámetro de salida de 0 indica que la información de error no se registró
    SET @iderror = 0;

    BEGIN TRY
        -- Volver si no hay información de error para registrar
        IF ERROR_NUMBER() IS NULL
            RETURN;

		-- Retorna si está dentro de una transacción no comprometida.
		-- La inserción/modificación de datos no está permitida cuando una transacción está en un estado no comprometido.
		IF XACT_STATE() = -1
        BEGIN
            PRINT 'No se puede registrar el error porque la transacción actual está en un estado no comprometido. ' 
                + 'Revierta la transacción antes de ejecutar uspLogError para registrar con éxito la información del error.';
            RETURN;
        END

        INSERT seg_db_error
            (
            usuario, 
            numero, 
            gravedad, 
            estado, 
            procedimiento, 
            linea, 
            mensaje
            ) 
        VALUES 
            (
            CONVERT(sysname, CURRENT_USER), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Devolver el iderror de la fila insertada
        SET @iderror = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'Ocurrió un error en el procedimiento almacenado USP_seg_db_error_registro: ';
        EXECUTE USP_seg_error_mostrar;
        RETURN -1;
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_log_actividades_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 08/11/2023
-- Description:	Lista de la tabla seg_log_actividades
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_log_actividades_lista] 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT seg_log_actividades.idlogusuario
			  ,seg_log_actividades.idusuario
			  ,seg_usuarios.paterno
			  ,seg_usuarios.materno
			  ,seg_usuarios.nombre
			  ,seg_log_actividades.accion
			  ,seg_log_actividades.opcion
			  ,seg_log_actividades.valoranterior
			  ,seg_log_actividades.valoractual
			  ,seg_log_actividades.fecharegistro
			  ,seg_log_actividades.latitud
			  ,seg_log_actividades.longitud
			  ,seg_log_actividades.latitud.ToString() AS latitudstring
			  ,seg_log_actividades.longitud.ToString() AS longitudstring
			  ,seg_log_actividades.dispositivo
			  ,seg_log_actividades.ip
		FROM seg_log_actividades
		LEFT JOIN seg_usuarios ON seg_usuarios.idusuario = seg_log_actividades.idusuario
		ORDER BY seg_usuarios.paterno, seg_usuarios.materno, seg_usuarios.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_log_actividades_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 08/11/2023
-- Description:	Mantenimiento de la tabla seg_log_actividades
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_log_actividades_mantenimiento]

@tipo INT,
@idlogusuario INT = NULL OUTPUT,
@idusuario INT = 0,
@accion INT = 0,
@opcion VARCHAR(100) = " ",
@valoranterior VARCHAR(MAX) = " ",
@valoractual VARCHAR(MAX) = " ",
@latitud GEOGRAPHY = " ",
@longitud GEOGRAPHY = " ",
@dispositivo VARCHAR(50) = " ",
@ip VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO seg_log_actividades VALUES(
								 @idusuario
								,@accion
								,@opcion
								,@valoranterior
								,@valoractual
								,GETDATE()
								,@latitud
								,@longitud
								,@dispositivo
								,@ip
							)
					SET @idlogusuario = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE seg_log_actividades
						SET		 @idusuario = @idusuario
								,@accion = @accion
								,@opcion = @opcion
								,@valoranterior = @valoranterior
								,@valoractual = @valoractual
								,@latitud = @latitud
								,@longitud = @longitud
								,@dispositivo = @dispositivo
								,@ip = @ip
						WHERE idlogusuario = @idlogusuario
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE seg_log_actividades WHERE idlogusuario = @idlogusuario
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_roles_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla seg_roles en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_roles_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idrol
			  ,nombre
			  ,activo
			  ,usuarioregistro
			  ,fecharegistro
		FROM seg_roles
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_roles_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla seg_roles
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_roles_mantenimiento] 
@tipo INT,
@idrol INT = NULL OUTPUT,
@nombre VARCHAR(50) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO seg_roles VALUES(
						@nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idrol = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE seg_roles
						SET nombre = @nombre
							,activo = @activo
						WHERE idrol = @idrol
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE seg_roles WHERE idrol = @idrol
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_empresa_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla seg_usuarios_empresa en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_empresa_lista] 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idusuarioempresa
			  ,seg_usuarios_empresa.idusuario
			  ,seg_usuarios.paterno + ' ' + seg_usuarios.materno + ' ' + seg_usuarios.nombre AS nombre
			  ,seg_usuarios.login
			  ,seg_usuarios_empresa.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas.ruc
			  ,seg_usuarios_empresa.idrol
			  ,seg_roles.nombre AS rol
			  ,seg_usuarios_empresa.usuarioregistro
			  ,seg_usuarios_empresa.fecharegistro
		FROM seg_usuarios_empresa
		INNER JOIN seg_usuarios ON seg_usuarios.idusuario = seg_usuarios_empresa.idusuario
		INNER JOIN adm_empresas ON adm_empresas.idempresa = seg_usuarios_empresa.idempresa
		INNER JOIN seg_roles ON seg_roles.idrol = seg_usuarios_empresa.idrol
		ORDER BY seg_usuarios.paterno,seg_usuarios.materno,seg_usuarios.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_empresa_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla seg_usuarios_empresa por idempresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_empresa_lista_idempresa] 
@idempresa INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idusuarioempresa
			  ,seg_usuarios_empresa.idusuario
			  ,seg_usuarios.paterno + ' ' + seg_usuarios.materno + ' ' + seg_usuarios.nombre AS nombre
			  ,seg_usuarios.login
			  ,seg_usuarios_empresa.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas.ruc
			  ,seg_usuarios_empresa.idrol
			  ,seg_roles.nombre AS rol
			  ,seg_usuarios_empresa.usuarioregistro
			  ,seg_usuarios_empresa.fecharegistro
		FROM seg_usuarios_empresa
		INNER JOIN seg_usuarios ON seg_usuarios.idusuario = seg_usuarios_empresa.idusuario
		INNER JOIN adm_empresas ON adm_empresas.idempresa = seg_usuarios_empresa.idempresa
		INNER JOIN seg_roles ON seg_roles.idrol = seg_usuarios_empresa.idrol
		WHERE seg_usuarios_empresa.idempresa = @idempresa
		ORDER BY seg_usuarios.paterno,seg_usuarios.materno,seg_usuarios.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_empresa_lista_idusuario]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla seg_usuarios_empresa por idusuario
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_empresa_lista_idusuario] 
@idusuario INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idusuarioempresa
			  ,seg_usuarios_empresa.idusuario
			  ,seg_usuarios.paterno + ' ' + seg_usuarios.materno + ' ' + seg_usuarios.nombre AS nombre
			  ,seg_usuarios.login
			  ,seg_usuarios_empresa.idempresa
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas.ruc
			  ,adm_empresas.logo
			  ,adm_empresas.isotipo
			  ,seg_usuarios_empresa.idrol
			  ,seg_roles.nombre AS rol
			  ,seg_usuarios_empresa.usuarioregistro
			  ,seg_usuarios_empresa.fecharegistro
		FROM seg_usuarios_empresa
		INNER JOIN seg_usuarios ON seg_usuarios.idusuario = seg_usuarios_empresa.idusuario
		INNER JOIN adm_empresas ON adm_empresas.idempresa = seg_usuarios_empresa.idempresa
		INNER JOIN seg_roles ON seg_roles.idrol = seg_usuarios_empresa.idrol
		WHERE seg_usuarios_empresa.idusuario = @idusuario
		ORDER BY adm_empresas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_empresa_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla seg_usuarios
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_empresa_mantenimiento] 
@tipo INT,
@idusuarioempresa INT = null OUTPUT,
@idusuario INT = 0,
@idempresa INT = 0,
@idrol INT = 0,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;
--    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO seg_usuarios_empresa VALUES(
						 @idusuario
						,@idempresa
						,@idrol
						,@usuarioregistro
						,GETDATE())

					SET @idusuarioempresa = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE seg_usuarios_empresa
						SET idrol = @idrol
						WHERE idusuarioempresa = @idusuarioempresa
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE seg_usuarios_empresa WHERE idusuarioempresa = @idusuarioempresa
						END
        COMMIT TRANSACTION;
	IF @@TRANCOUNT > 0
    BEGIN
		ROLLBACK TRANSACTION;
	END

  --  END TRY
  --  BEGIN CATCH
		---- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
  --      IF @@TRANCOUNT > 0
  --      BEGIN
  --          ROLLBACK TRANSACTION;
  --      END

  --      --EXECUTE USP_seg_error_registro;
  --  END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla seg_usuarios en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idusuario
			  ,paterno
			  ,materno
			  ,nombre
			  ,idtipodocumento
			  ,documento
			  ,login
			  ,email
			  ,movil
			  ,CASE WHEN ultimoingreso='1900-01-01' THEN Null ELSE ultimoingreso END AS ultimoingreso
			  ,CASE WHEN cambioclave='1900-01-01' THEN Null ELSE cambioclave END AS cambioclave
			  ,administrador
			  ,activo
			  ,foto
			  ,usuarioregistro
			  ,fecharegistro
		FROM seg_usuarios
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY paterno,materno,nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_lista_idusuario]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla seg_usuarios en orden alfabetico
-- =============================================
create PROCEDURE [dbo].[USP_seg_usuarios_lista_idusuario] 
@idusuario INT

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idusuario
			  ,paterno
			  ,materno
			  ,nombre
			  ,idtipodocumento
			  ,documento
			  ,login
			  ,email
			  ,movil
			  ,CASE WHEN ultimoingreso='1900-01-01' THEN Null ELSE ultimoingreso END AS ultimoingreso
			  ,CASE WHEN cambioclave='1900-01-01' THEN Null ELSE cambioclave END AS cambioclave
			  ,administrador
			  ,activo
			  ,foto
			  ,usuarioregistro
			  ,fecharegistro
		FROM seg_usuarios
		WHERE seg_usuarios.idusuario = @idusuario
		ORDER BY paterno,materno,nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla seg_usuarios
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_mantenimiento] 
@tipo INT,
@idusuario INT = null OUTPUT,
@paterno VARCHAR(50) = " ",
@materno VARCHAR(50) = " ",
@nombre VARCHAR(50) = " ",
@idtipodocumento CHAR(2) = " ",
@documento VARCHAR(20) = " ",
@login VARCHAR(50) = " ",
@password VARCHAR(50) = " ",
@email VARCHAR(80) = " ",
@movil VARCHAR(20) = " ",
@administrador INT = 0,
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " ",
@foto IMAGE = null

AS
BEGIN
    SET NOCOUNT ON;
--    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO seg_usuarios VALUES(
						 @paterno
						,@materno
						,@nombre
						,@idtipodocumento
						,@documento
						,@login
						,HASHBYTES('SHA2_512',@password)
						,@email
						,@movil
						,'1900-01-01'
						,'1900-01-01'
						,@administrador
						,@activo
						,@foto
						,@usuarioregistro
						,GETDATE())

					SET @idusuario = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE seg_usuarios
						SET paterno = @paterno
							,materno = @materno
							,nombre = @nombre
							,idtipodocumento = @idtipodocumento
							,documento = @documento
							,email = @email
							,movil = @movil
							,administrador = @administrador
							,activo = @activo
							,foto = @foto
						WHERE idusuario = @idusuario
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE seg_usuarios WHERE idusuario = @idusuario
						END
        COMMIT TRANSACTION;
	IF @@TRANCOUNT > 0
    BEGIN
		ROLLBACK TRANSACTION;
	END

  --  END TRY
  --  BEGIN CATCH
		---- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
  --      IF @@TRANCOUNT > 0
  --      BEGIN
  --          ROLLBACK TRANSACTION;
  --      END

  --      --EXECUTE USP_seg_error_registro;
  --  END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_password_cambiar]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 01/08/2023
-- Description:	Actualizar password del usuario
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_password_cambiar]
@idusuario INT,
@password VARCHAR(50) = " ",
@restablece INT = 0
AS
BEGIN
    SET NOCOUNT ON;
	UPDATE seg_usuarios
	SET password = HASHBYTES('SHA2_512',@password)
		,cambioclave = IIF(@restablece = 0, GETDATE(), '19000101')
	WHERE idusuario = @idusuario
	INSERT INTO seg_usuarios_password VALUES(@idusuario
											,HASHBYTES('SHA2_512',@password)
											,IIF(@restablece = 0, GETDATE(), '19000101'))
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_password_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla seg_usuarios_password
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_password_mantenimiento] 
@tipo INT,
@idusuariopassword INT = NULL OUTPUT,
@idusuario INT = 0,
@password VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO seg_usuarios_password VALUES(
						 @idusuario
						,HASHBYTES('SHA2_512',@password)
						,GETDATE())

					SET @idusuario = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE seg_usuarios_password
						SET idusuario = @idusuario
							,password = HASHBYTES('SHA2_512',@password)
						WHERE idusuariopassword = @idusuariopassword
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE seg_usuarios_password WHERE idusuariopassword = @idusuariopassword
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_seg_usuarios_ultimoingreso_cambiar]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 01/08/2023
-- Description:	Actualizar fecha ultimo ingreso del usuario
-- =============================================
CREATE PROCEDURE [dbo].[USP_seg_usuarios_ultimoingreso_cambiar]
@idusuario INT
AS
BEGIN
    SET NOCOUNT ON;
	UPDATE seg_usuarios
	SET ultimoingreso = GETDATE()
	WHERE idusuario = @idusuario
END
GO
/****** Object:  StoredProcedure [dbo].[USP_sis_parametros_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 01/08/2023
-- Description:	Lista de la tabla sis_parametros
-- =============================================
CREATE PROCEDURE [dbo].[USP_sis_parametros_lista] 
@idtipo INT = -1, -- -1 = Todo, 0 = Globales, 1 = De Empresa, 2 = De Usuario
@idempresa INT = -1,
@idusuario INT = -1

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idparametro
			  ,ISNULL(sis_parametros.idempresa,0) AS idempresa
			  ,ISNULL(adm_empresas.nombre, ' ') AS empresa
			  ,ISNULL(sis_parametros.idusuario,0) AS idusuario
			  ,ISNULL(seg_usuarios.nombre,' ') AS usuario
			  ,variable
			  ,valor
			  ,sis_parametros.usuarioregistro
			  ,sis_parametros.fecharegistro
		FROM sis_parametros
		LEFT JOIN adm_empresas ON adm_empresas.idempresa = sis_parametros.idempresa
		LEFT JOIN seg_usuarios ON seg_usuarios.idusuario = sis_parametros.idusuario
		WHERE CASE
			WHEN @idtipo = -1 THEN 1 -- TODO
			WHEN @idtipo = 0 AND sis_parametros.idempresa = 0 AND sis_parametros.idusuario = 0 THEN 1 -- GLOBALES
			WHEN @idtipo = 1 AND sis_parametros.idempresa <> 0 THEN 1 -- POR EMPRESA 
			WHEN @idtipo = 2 AND sis_parametros.idusuario <> 0 THEN 1 -- POR USUARIO 
		END = 1
		ORDER BY variable
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_sis_parametros_lista_carga]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 01/08/2023
-- Description:	Lista de la tabla sis_parametros
-- =============================================
CREATE PROCEDURE [dbo].[USP_sis_parametros_lista_carga] 
@idtipo INT = -1, -- -1 = Todo, 0 = Globales, 1 = De Empresa (es necesario indicar el IDEMPRESA), 2 = De Usuario (es necesario indicar el IDUSUARIO)
@idempresa INT = -1,
@idusuario INT = -1

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT variable
			  ,valor
		FROM sis_parametros
		LEFT JOIN adm_empresas ON adm_empresas.idempresa = sis_parametros.idempresa
		LEFT JOIN seg_usuarios ON seg_usuarios.idusuario = sis_parametros.idusuario
		WHERE CASE
			WHEN @idtipo = -1 THEN 1 -- TODO
			WHEN @idtipo = 0 AND sis_parametros.idempresa = 0 AND sis_parametros.idusuario = 0 THEN 1 -- GLOBALES
			WHEN @idtipo = 1 AND sis_parametros.idempresa = @idempresa THEN 1 -- POR EMPRESA 
			WHEN @idtipo = 2 AND sis_parametros.idusuario = @idusuario THEN 1 -- POR USUARIO 
		END = 1
		ORDER BY variable
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_sis_parametros_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 01/08/2023
-- Description:	Mantenimiento de la tabla sis_parametros
-- =============================================
CREATE PROCEDURE [dbo].[USP_sis_parametros_mantenimiento] 
@tipo INT,
@idparametro INT = NULL OUTPUT,
@idempresa INT = 0,
@idusuario INT = 0,
@variable VARCHAR(50) = " ",
@valor VARCHAR(250) = " ",
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO sis_parametros VALUES(
						@idempresa
						,@idusuario
						,@variable
						,@valor
						,@usuarioregistro
						,GETDATE())

					SET @idparametro = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE sis_parametros
						SET idempresa = @idempresa
							,idusuario = @idusuario
							,variable = @variable
							,valor = @valor
						WHERE idparametro = @idparametro
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE sis_parametros WHERE idparametro = @idparametro
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_agentes en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_agentes.idagente
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
		      ,vig_agentes.ingreso
			  ,vig_agentes.cese
			  ,vig_agentes.activo
			  ,adm_personas.foto
			  ,vig_agentes.usuarioregistro
			  ,vig_agentes.fecharegistro
		FROM vig_agentes
		INNER JOIN adm_personas ON adm_personas.idpersona = vig_agentes.idpersona
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND vig_agentes.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND vig_agentes.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_agentes en orden alfabetico por empresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_lista_idempresa]
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_agentes.idagente
		      ,adm_empresas_sedes.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
		      ,vig_agentes.ingreso
			  ,vig_agentes.cese
			  ,vig_agentes.activo
			  ,adm_personas.foto
			  ,vig_agentes.usuarioregistro
			  ,vig_agentes.fecharegistro
		FROM vig_agentes
		INNER JOIN adm_personas ON adm_personas.idpersona = vig_agentes.idpersona
		INNER JOIN vig_agentes_sede ON vig_agentes_sede.idagente = vig_agentes.idagente
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_agentes_sede.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE adm_empresas_sedes.idempresa = @idempresa
		AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_agentes.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_agentes.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_lista_idsede]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_agentes en orden alfabetico por empresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_lista_idsede]
@idsede INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_agentes.idagente
		      ,adm_empresas_sedes.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
		      ,vig_agentes.ingreso
			  ,vig_agentes.cese
			  ,vig_agentes.activo
			  ,adm_personas.foto
			  ,vig_agentes.usuarioregistro
			  ,vig_agentes.fecharegistro
		FROM vig_agentes
		INNER JOIN adm_personas ON adm_personas.idpersona = vig_agentes.idpersona
		INNER JOIN vig_agentes_sede ON vig_agentes_sede.idagente = vig_agentes.idagente
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_agentes_sede.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE adm_empresas_sedes.idsede = @idsede
		AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_agentes.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_agentes.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla vig_agentes
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_mantenimiento] 
@tipo INT,
@idagente INT = NULL OUTPUT,
@idpersona INT = 0,
@ingreso DATETIME = "1900101",
@cese DATETIME = "1900101",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_agentes VALUES(
						@idpersona
						,@ingreso
						,@cese
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idagente = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_agentes
						SET idpersona = @idpersona
							,ingreso = @ingreso
							,cese = @cese
							,activo = @activo
						WHERE idagente = @idagente
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_agentes WHERE idagente = @idagente
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_sede_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_agentes_sede en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_sede_lista]
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_agentes_sede.idagentesede
		      ,vig_agentes_sede.idagente
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
		      ,vig_agentes.ingreso
			  ,vig_agentes.cese
			  ,vig_agentes.activo
			  ,adm_personas.foto
			  ,vig_agentes.usuarioregistro
			  ,vig_agentes.fecharegistro
		FROM vig_agentes_sede
		INNER JOIN vig_agentes ON vig_agentes.idagente = vig_agentes_sede.idagente
		INNER JOIN adm_personas ON adm_personas.idpersona = vig_agentes.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_agentes_sede.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_agentes_sede.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_agentes_sede.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_sede_lista_idagente]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_agentes_sede en orden alfabetico por agente
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_sede_lista_idagente]
@idagente INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_agentes_sede.idagentesede
		      ,vig_agentes_sede.idagente
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
		      ,vig_agentes.ingreso
			  ,vig_agentes.cese
			  ,vig_agentes.activo
			  ,adm_personas.foto
			  ,vig_agentes.usuarioregistro
			  ,vig_agentes.fecharegistro
		FROM vig_agentes_sede
		INNER JOIN vig_agentes ON vig_agentes.idagente = vig_agentes_sede.idagente
		INNER JOIN adm_personas ON adm_personas.idpersona = vig_agentes.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_agentes_sede.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE vig_agentes_sede.idagente = @idagente
		AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_agentes_sede.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_agentes_sede.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_sede_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_agentes_sede en orden alfabetico por idempresa
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_sede_lista_idempresa]
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_agentes_sede.idagentesede
		      ,vig_agentes_sede.idagente
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
		      ,vig_agentes.ingreso
			  ,vig_agentes.cese
			  ,vig_agentes.activo
			  ,adm_personas.foto
			  ,vig_agentes.usuarioregistro
			  ,vig_agentes.fecharegistro
		FROM vig_agentes_sede
		INNER JOIN vig_agentes ON vig_agentes.idagente = vig_agentes_sede.idagente
		INNER JOIN adm_personas ON adm_personas.idpersona = vig_agentes.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_agentes_sede.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE adm_empresas_sedes.idempresa = @idempresa
		AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_agentes_sede.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_agentes_sede.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_sede_lista_idsede]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_agentes_sede en orden alfabetico por agente
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_sede_lista_idsede]
@idsede INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_agentes_sede.idagentesede
		      ,vig_agentes_sede.idagente
			  ,adm_empresas_sedes.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_personas.nacimiento
			  ,adm_personas.sexo
		      ,vig_agentes.ingreso
			  ,vig_agentes.cese
			  ,vig_agentes.activo
			  ,adm_personas.foto
			  ,vig_agentes.usuarioregistro
			  ,vig_agentes.fecharegistro
		FROM vig_agentes_sede
		INNER JOIN vig_agentes ON vig_agentes.idagente = vig_agentes_sede.idagente
		INNER JOIN adm_personas ON adm_personas.idpersona = vig_agentes.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_agentes_sede.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE vig_agentes_sede.idsede = @idsede
		AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_agentes_sede.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_agentes_sede.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_agentes_sede_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla vig_agentes_sede
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_agentes_sede_mantenimiento] 
@tipo INT,
@idagentesede INT = NULL OUTPUT,
@idsede INT = 0,
@idagente INT = 0,
@inicio DATETIME = "1900101",
@termino DATETIME = "1900101",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_agentes_sede VALUES(
						@idsede
						,@idagente
						,@inicio
						,@termino
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idagentesede = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_agentes_sede
						SET idsede = @idsede
							,inicio = @inicio
							,termino = @termino
							,activo = @activo
						WHERE idagentesede = @idagentesede
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_agentes_sede WHERE idagentesede = @idagentesede
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_camaras_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_camaras en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_camaras_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_camaras.idcamara
		      ,adm_empresas.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
		      ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_sedes.direccion
			  ,vig_camaras.idpuesto
			  ,vig_puestos.nombre as puesto
			  ,vig_camaras.nombre
			  ,vig_camaras.observacion
			  ,vig_camaras.activo
			  ,vig_camaras.usuarioregistro
			  ,vig_camaras.fecharegistro
		FROM vig_camaras
	    INNER JOIN vig_puestos ON vig_puestos.idpuesto = vig_camaras.idpuesto
	    INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_puestos.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_camaras.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_camaras.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY vig_camaras.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_camaras_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Luis Romero Quintana
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla vig_camaras
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_camaras_mantenimiento] 
@tipo INT,
@idcamara VARCHAR(MAX) = NULL OUTPUT,
@idpuesto INT = 0,
@nombre VARCHAR(250) = " ",
@observacion VARCHAR(MAX) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_camaras VALUES(
					     @idcamara
						,@idpuesto
						,@nombre
						,@observacion
						,@activo
						,@usuarioregistro
						,GETDATE())
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_camaras
						SET idcamara = @idcamara
							,idpuesto = @idpuesto
							,nombre = @nombre
							,observacion = @observacion
							,activo = @activo
						WHERE idcamara = @idcamara
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_camaras WHERE idcamara = @idcamara
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_correspondencia_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_documentos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_correspondencia_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_correspondencia.idcorrespondencia
			  ,terceros.idempresa
			  ,terceros.nombre AS nombre_empresa
			  ,vig_correspondencia.idtipocorrespondencia
			  ,vig_tipos_correspondencia.nombre
			  ,vig_correspondencia.destinatario_idpersonal
			  ,adm_personas_recepcion.paterno as paterno_destinatario
			  ,adm_personas_recepcion.materno as materno_destinatario
			  ,adm_personas_recepcion.nombre as nombre_destinatario
			  ,vig_correspondencia.remitente
			  ,vig_correspondencia.recepcion_fecha
			  ,vig_correspondencia.recepcion_usuario
			  ,vig_correspondencia.recepcion_observacion
			  ,vig_correspondencia.entrega_fecha
			  ,vig_correspondencia.entrega_usuario
			  ,vig_correspondencia.entrega_observacion
			  ,vig_correspondencia.uuid
			  ,vig_correspondencia.activo
		FROM vig_correspondencia
		INNER JOIN adm_personal adm_personal_recepcion ON adm_personal_recepcion.idpersonal = vig_correspondencia.destinatario_idpersonal
		INNER JOIN adm_personas adm_personas_recepcion ON adm_personas_recepcion.idpersona = adm_personal_recepcion.idpersona
		INNER JOIN vig_tipos_correspondencia ON vig_tipos_correspondencia.idtipocorrespondencia = vig_correspondencia.idtipocorrespondencia
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal_recepcion.idempresa
		ORDER BY vig_correspondencia.remitente
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_correspondencia_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_documentos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_correspondencia_lista_idempresa] 
@idempresa INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_correspondencia.idcorrespondencia
			  ,terceros.idempresa
			  ,terceros.nombre AS nombre_empresa
			  ,vig_correspondencia.idtipocorrespondencia
			  ,vig_tipos_correspondencia.nombre
			  ,vig_correspondencia.destinatario_idpersonal
			  ,adm_personas_recepcion.paterno as paterno_destinatario
			  ,adm_personas_recepcion.materno as materno_destinatario
			  ,adm_personas_recepcion.nombre as nombre_destinatario
			  ,vig_correspondencia.remitente
			  ,vig_correspondencia.recepcion_fecha
			  ,vig_correspondencia.recepcion_usuario
			  ,vig_correspondencia.recepcion_observacion
			  ,vig_correspondencia.entrega_fecha
			  ,vig_correspondencia.entrega_usuario
			  ,vig_correspondencia.entrega_observacion
			  ,vig_correspondencia.uuid
			  ,vig_correspondencia.activo
		FROM vig_correspondencia
		INNER JOIN adm_personal adm_personal_recepcion ON adm_personal_recepcion.idpersonal = vig_correspondencia.destinatario_idpersonal
		INNER JOIN adm_personas adm_personas_recepcion ON adm_personas_recepcion.idpersona = adm_personal_recepcion.idpersona
		INNER JOIN vig_tipos_correspondencia ON vig_tipos_correspondencia.idtipocorrespondencia = vig_correspondencia.idtipocorrespondencia
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal_recepcion.idempresa
		WHERE terceros.idempresa = @idempresa
		ORDER BY vig_correspondencia.remitente
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_correspondencia_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla vig_documentos
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_correspondencia_mantenimiento] 
@tipo INT,
@idcorrespondencia INT = NULL OUTPUT,
@idtipocorrespondencia INT = 0,
@destinatario_idpersonal INT = 0,
@remitente VARCHAR(250) = " ",
@recepcion_fecha  DATETIME = "1900-01-01",
@recepcion_usuario VARCHAR(50) = " ",
@recepcion_observacion VARCHAR(250) = " ",
@entrega_fecha  DATETIME = "1900-01-01",
@entrega_usuario VARCHAR(50) = " ",
@entrega_observacion VARCHAR(250) = " ",
@uuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000' OUTPUT,
@activo INT = 1
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_correspondencia VALUES(
						 @idtipocorrespondencia
						,@destinatario_idpersonal
						,@remitente
						,@recepcion_fecha
						,@recepcion_usuario
						,@recepcion_observacion
						,@entrega_fecha
						,@entrega_usuario
						,@entrega_observacion
						,@uuid
						,@activo)

					SET @idcorrespondencia = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_correspondencia
						SET idtipocorrespondencia = @idtipocorrespondencia
							,destinatario_idpersonal = @destinatario_idpersonal
							,remitente = @remitente
							,recepcion_fecha = @recepcion_fecha
							,recepcion_usuario = @recepcion_usuario
							,recepcion_observacion = @recepcion_observacion
							,entrega_fecha = @entrega_fecha
							,entrega_usuario = @entrega_usuario
							,entrega_observacion = @entrega_observacion
							,uuid = @uuid
							,activo = @activo

						WHERE idcorrespondencia = @idcorrespondencia
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_correspondencia WHERE idcorrespondencia = @idcorrespondencia
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_documentos_upload_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_documentos_upload en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_documentos_upload_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_documentos_upload.iddocumentoupload
			  ,vig_documentos_upload.app
			  ,vig_documentos_upload.usuario
			  ,vig_documentos_upload.uuid
			  ,vig_documentos_upload.ruta
			  ,vig_documentos_upload.archivo
			  ,vig_documentos_upload.archivoNuevo
			  ,vig_documentos_upload.carpeta
			  ,vig_documentos_upload.empresa
			  ,vig_documentos_upload.peso
			  ,vig_documentos_upload.extension
			  ,vig_documentos_upload.fieldname
			  ,vig_documentos_upload.originalname
			  ,vig_documentos_upload.encoding
			  ,vig_documentos_upload.mimetype
			  ,vig_documentos_upload.destination
			  ,vig_documentos_upload.filename
			  ,vig_documentos_upload.path
			  ,vig_documentos_upload.size
			  ,vig_documentos_upload.accion
			  ,vig_documentos_upload.usuarioregistro
			  ,vig_documentos_upload.fecharegistro
		FROM vig_documentos_upload
		--INNER JOIN adm_personal ON adm_personal.idpersonal = vig_documentos.idpersonal
		--INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		--INNER JOIN vig_correspondencia ON vig_correspondencia.uuid = vig_documentos_upload.uuid
		ORDER BY vig_documentos_upload.uuid
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_documentos_upload_lista_uuid]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_documentos_upload_uuid en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_documentos_upload_lista_uuid] 
@uuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_documentos_upload.iddocumentoupload
			  ,vig_documentos_upload.app
			  ,vig_documentos_upload.usuario
			  ,vig_documentos_upload.uuid
			  ,vig_documentos_upload.ruta
			  ,vig_documentos_upload.archivo
			  ,vig_documentos_upload.archivoNuevo
			  ,vig_documentos_upload.carpeta
			  ,vig_documentos_upload.empresa
			  ,vig_documentos_upload.peso
			  ,vig_documentos_upload.extension
			  ,vig_documentos_upload.fieldname
			  ,vig_documentos_upload.originalname
			  ,vig_documentos_upload.encoding
			  ,vig_documentos_upload.mimetype
			  ,vig_documentos_upload.destination
			  ,vig_documentos_upload.filename
			  ,vig_documentos_upload.path
			  ,vig_documentos_upload.size
			  ,vig_documentos_upload.accion
			  ,vig_documentos_upload.usuarioregistro
			  ,vig_documentos_upload.fecharegistro
		FROM vig_documentos_upload
		--INNER JOIN adm_personal ON adm_personal.idpersonal = vig_documentos.idpersonal
		--INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		left JOIN vig_correspondencia ON vig_correspondencia.uuid = vig_documentos_upload.uuid
		WHERE vig_documentos_upload.uuid = @uuid
		ORDER BY vig_documentos_upload.uuid
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_incidencias_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 03/10/2023
-- Description:	Lista de la tabla vig_incidencias
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_incidencias_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT 
			   vig_incidencias.idincidencia
			  ,vig_incidencias.idempresa
			  ,terceros.nombre AS empresa
			  ,vig_incidencias.idsede
			  ,sedes.nombre AS sede
			  ,vig_incidencias.idpuesto
			  ,puestos.nombre AS puesto
			  ,vig_incidencias.idtipoincidencia
			  ,adm_tipos_incidencias.nombre as nombretipoincidencia
			  ,vig_incidencias.idusuario
			  ,seg_usuarios.paterno as paterno_usuario
			  ,seg_usuarios.materno as materno_usuario
			  ,seg_usuarios.nombre as nombre_usuario
			  ,vig_incidencias.idpersonal
			  ,adm_personas.paterno as paterno_personal
			  ,adm_personas.materno as materno_personal
			  ,adm_personas.nombre as nombre_personal
			  ,vig_incidencias.nombre
			  ,vig_incidencias.observacion
			  ,vig_incidencias.fechaincidencia
			  ,vig_incidencias.uuid
			  ,vig_incidencias.activo
			  ,vig_incidencias.usuarioregistro
			  ,vig_incidencias.fecharegistro
		FROM vig_incidencias
		INNER JOIN adm_tipos_incidencias ON adm_tipos_incidencias.idtipoincidencia = vig_incidencias.idtipoincidencia
		left JOIN seg_usuarios ON seg_usuarios.idusuario = vig_incidencias.idusuario
		left JOIN adm_personal ON adm_personal.idpersonal = vig_incidencias.idpersonal
		left JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = vig_incidencias.idempresa
		LEFT JOIN adm_empresas_sedes sedes ON sedes.idsede = vig_incidencias.idsede
		LEFT JOIN vig_puestos puestos ON puestos.idpuesto = vig_incidencias.idpuesto
		WHERE CASE
			WHEN @idestado = 2 THEN 1 -- activos e inactivos
			WHEN @idestado = 1 AND vig_incidencias.activo = 1 THEN 1 -- activos
			WHEN @idestado = 0 AND vig_incidencias.activo = 0 THEN 1 -- inactivos
		END = 1
		ORDER BY vig_incidencias.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_incidencias_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 03/10/2023
-- Description:	Lista de la tabla vig_incidencias
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_incidencias_lista_idempresa] 
@idempresa INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT 
			   vig_incidencias.idincidencia
			  ,vig_incidencias.idempresa
			  ,terceros.nombre AS empresa
			  ,vig_incidencias.idsede
			  ,sedes.nombre AS sede
			  ,vig_incidencias.idpuesto
			  ,puestos.nombre AS puesto
			  ,vig_incidencias.idtipoincidencia
			  ,adm_tipos_incidencias.nombre as nombretipoincidencia
			  ,vig_incidencias.idusuario
			  ,seg_usuarios.paterno as paterno_usuario
			  ,seg_usuarios.materno as materno_usuario
			  ,seg_usuarios.nombre as nombre_usuario
			  ,vig_incidencias.idpersonal
			  ,adm_personas.paterno as paterno_personal
			  ,adm_personas.materno as materno_personal
			  ,adm_personas.nombre as nombre_personal
			  ,vig_incidencias.nombre
			  ,vig_incidencias.observacion
			  ,vig_incidencias.fechaincidencia
			  ,vig_incidencias.uuid
			  ,vig_incidencias.activo
			  ,vig_incidencias.usuarioregistro
			  ,vig_incidencias.fecharegistro
		FROM vig_incidencias
		INNER JOIN adm_tipos_incidencias ON adm_tipos_incidencias.idtipoincidencia = vig_incidencias.idtipoincidencia
		left JOIN seg_usuarios ON seg_usuarios.idusuario = vig_incidencias.idusuario
		left JOIN adm_personal ON adm_personal.idpersonal = vig_incidencias.idpersonal
		left JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
	    LEFT JOIN adm_empresas terceros ON terceros.idempresa = vig_incidencias.idempresa
		LEFT JOIN adm_empresas_sedes sedes ON sedes.idsede = vig_incidencias.idsede
		LEFT JOIN vig_puestos puestos ON puestos.idpuesto = vig_incidencias.idpuesto
	    WHERE terceros.idempresa = @idempresa
		ORDER BY vig_incidencias.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_incidencias_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 03/10/2023
-- Description:	Mantenimiento de la tabla vig_incidencias
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_incidencias_mantenimiento] 
@tipo INT,
@idincidencia INT = NULL OUTPUT,
@idempresa INT = 0,
@idsede INT = 0,
@idpuesto INT = 0,
@idtipoincidencia INT = 0,
@idusuario INT = 0,
@idpersonal INT = 0,
@nombre VARCHAR(250) = " ",
@observacion VARCHAR(MAX)  = " ",
@fechaincidencia DATETIME = "1900-01-01",
@uuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000' OUTPUT,
@activo INT = 0,
@usuarioregistro VARCHAR(50)  = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_incidencias VALUES(
						 @idempresa
						,@idsede
						,@idpuesto
						,@idtipoincidencia
						,@idusuario
						,@idpersonal
						,@nombre
						,@observacion
						,@fechaincidencia
						,@uuid
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idincidencia = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_incidencias
						SET		 idempresa = @idempresa
								,idsede = @idsede
								,idpuesto = @idpuesto
								,idtipoincidencia = @idtipoincidencia
								,idusuario = @idusuario
								,idpersonal = @idpersonal
								,nombre = @nombre
								,observacion = @observacion
								,fechaincidencia = @fechaincidencia
								,uuid = @uuid
								,activo = @activo
						WHERE idincidencia = @idincidencia
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_incidencias WHERE idincidencia = @idincidencia
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_activos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_ingresosalida_activos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_activos_lista] 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida_activos.idesactivo
			  ,vig_ingresosalida_activos.ides
			  ,vig_ingresosalida_activos.idtipoactivo
			  ,vig_ingresosalida.idpersonal
			  ,adm_tipos_activos.nombre AS tipoactivo
			  ,vig_ingresosalida_activos.equipo
			  ,vig_ingresosalida_activos.serie
			  ,vig_ingresosalida_activos.modelo
			  ,vig_ingresosalida_activos.marca
			  ,vig_ingresosalida_activos.color
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
		FROM vig_ingresosalida_activos
		INNER JOIN vig_ingresosalida ON vig_ingresosalida.ides = vig_ingresosalida_activos.ides
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = vig_ingresosalida_activos.idtipoactivo
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_activos_lista_equipo]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal_activos por equipo
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_activos_lista_equipo] 
@equipo VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida_activos.idesactivo
		      ,vig_ingresosalida_activos.ides
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.nombre AS area
			  ,adm_tipos_personal.nombre AS tipo
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,vig_ingresosalida_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipoactivo
			  ,vig_ingresosalida_activos.equipo
			  ,vig_ingresosalida_activos.serie
			  ,vig_ingresosalida_activos.modelo
			  ,vig_ingresosalida_activos.marca
			  ,vig_ingresosalida_activos.color
			  ,vig_ingresosalida_activos.salida
		FROM vig_ingresosalida_activos
		INNER JOIN vig_ingresosalida ON vig_ingresosalida.ides = vig_ingresosalida_activos.ides
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = vig_ingresosalida_activos.idtipoactivo
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE vig_ingresosalida_activos.equipo = @equipo
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_activos_lista_ides]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_ingresosalida_activos por ides
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_activos_lista_ides] 
@ides INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
			SELECT vig_ingresosalida_activos.idesactivo
			  ,vig_ingresosalida_activos.ides
			  ,vig_ingresosalida.idpersonal
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,vig_ingresosalida_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipoactivo
			  ,vig_ingresosalida_activos.equipo
			  ,vig_ingresosalida_activos.serie
			  ,vig_ingresosalida_activos.modelo
			  ,vig_ingresosalida_activos.marca
			  ,vig_ingresosalida_activos.color
		FROM vig_ingresosalida_activos
		INNER JOIN vig_ingresosalida ON vig_ingresosalida.ides = vig_ingresosalida_activos.ides
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = vig_ingresosalida_activos.idtipoactivo
		WHERE vig_ingresosalida.ides = @ides
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_activos_lista_idpersonal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_ingresosalida_activos por idpersona
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_activos_lista_idpersonal] 
@idpersonal INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
			SELECT vig_ingresosalida_activos.idesactivo
			  ,vig_ingresosalida_activos.ides
			  ,vig_ingresosalida.idpersonal
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,vig_ingresosalida_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipoactivo
			  ,vig_ingresosalida_activos.equipo
			  ,vig_ingresosalida_activos.serie
			  ,vig_ingresosalida_activos.modelo
			  ,vig_ingresosalida_activos.marca
			  ,vig_ingresosalida_activos.color
		FROM vig_ingresosalida_activos
		INNER JOIN vig_ingresosalida ON vig_ingresosalida.ides = vig_ingresosalida_activos.ides
		LEFT JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		LEFT JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = vig_ingresosalida_activos.idtipoactivo
		WHERE vig_ingresosalida.idpersonal = @idpersonal
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_activos_lista_serie]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla adm_personal_activos por serie
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_activos_lista_serie] 
@serie VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida_activos.idesactivo
			  ,vig_ingresosalida_activos.ides
			  ,adm_personal.idpersonal
		      ,adm_personas.idpersona
			  ,adm_personas.documento
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre AS nombres
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombre
			  ,adm_empresas.nombre AS empresa
			  ,adm_empresas_areas.nombre AS area
			  ,adm_tipos_personal.nombre AS tipo
			  ,ISNULL(terceros.nombre,'') AS tercero
			  ,adm_personal.activo
			  ,adm_personas.foto
			  ,vig_ingresosalida_activos.idtipoactivo
			  ,adm_tipos_activos.nombre AS tipoactivo
			  ,vig_ingresosalida_activos.equipo
			  ,vig_ingresosalida_activos.serie
			  ,vig_ingresosalida_activos.modelo
			  ,vig_ingresosalida_activos.marca
			  ,vig_ingresosalida_activos.color
			  ,vig_ingresosalida_activos.salida
		FROM vig_ingresosalida_activos
		INNER JOIN vig_ingresosalida ON vig_ingresosalida.ides = vig_ingresosalida_activos.ides
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		INNER JOIN adm_personas ON adm_personas.idpersona = adm_personal.idpersona
		INNER JOIN adm_empresas_areas ON adm_empresas_areas.idarea = adm_personal.idarea
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = adm_empresas_areas.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		INNER JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = adm_personal.idtipopersonal
		INNER JOIN adm_tipos_activos ON adm_tipos_activos.idtipoactivo = vig_ingresosalida_activos.idtipoactivo
		LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idtercero
		WHERE vig_ingresosalida_activos.serie = @serie
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre, equipo
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_activos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 14/11/2023
-- Description:	Mantenimiento de la tabla vig_ingresosalida_activos
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_activos_mantenimiento]
@tipo INT,
@idesactivo INT = NULL OUTPUT,
@ides INT = 0,
@idtipoactivo INT = 0,
@equipo VARCHAR(50) = " ",
@serie VARCHAR(50) = " ",
@modelo VARCHAR(50) = " ",
@marca VARCHAR(50) = " ",
@color VARCHAR(50) = " ",
@salida DATETIME = "1900-01-01"

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_ingresosalida_activos VALUES(
						 @ides
						,@idtipoactivo
						,@equipo
						,@serie
						,@modelo
						,@marca
						,@color
						,@salida) 
					SET @idesactivo = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_ingresosalida_activos
						SET 
							 ides = @ides
							,idtipoactivo = @idtipoactivo
							,equipo = @equipo
							,serie = @serie
							,modelo = @modelo
							,marca = @marca
							,color = @color
							,salida = @salida
						WHERE idesactivo = @idesactivo
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_ingresosalida_activos WHERE idesactivo = @idesactivo
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_ingresosalida en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_lista] 

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida.ides
			  ,vig_ingresosalida.idempresa
			  ,terceros.nombre AS empresa
			  ,vig_ingresosalida.idsede
			  ,sedes.nombre AS sede
			  ,vig_ingresosalida.idpuesto
			  ,puestos.nombre AS puesto
			  ,vig_ingresosalida.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipopersonal
			  ,vig_ingresosalida.idpersonal
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.idtipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombres
			  ,vig_ingresosalida.idpersonalvisita
			  ,adm_personas_visita.paterno AS paterno_visita
			  ,adm_personas_visita.materno AS materno_visita
			  ,adm_personas_visita.nombre as nombre_visita
			  ,adm_personas_visita.paterno + ' ' + adm_personas_visita.materno + ' ' + adm_personas_visita.nombre AS nombres_visita
			  ,vig_ingresosalida.ingreso_tiporegistro
			  ,adm_tipos_ingreso.nombre AS nombreingresotiporegistro
			  ,vig_ingresosalida.ingreso_hora
			  ,vig_ingresosalida.ingreso_idsede
			  ,adm_empresas_sedes.nombre AS sede_ingreso
			  ,vig_ingresosalida.ingreso_idvehiculo
			  ,ISNULL(vig_vehiculos.marca,'') AS vehiculo_entrada_marca
			  ,ISNULL(vig_vehiculos.color,'') AS vehiculo_entrada_color
			  ,ISNULL(vig_vehiculos.placa,'') AS vehiculo_entrada_placa
			  ,ISNULL(vig_vehiculos.vencimiento_soat,'') AS vehiculo_entrada_vencimiento_soat
			  ,ISNULL(vig_vehiculos.vencimiento_revision,'') AS vehiculo_entrada_vencimiento_revision
			  ,vig_ingresosalida.ingreso_observacion
			  ,vig_ingresosalida.ingreso_usuario
			  ,vig_ingresosalida.salida_tiporegistro
			  ,adm_tipos_salida.nombre AS nombresalidatiporegistro
			  ,vig_ingresosalida.salida_hora
			  ,vig_ingresosalida.salida_idsede
			  ,ISNULL(adm_empresas_sedes_salida.nombre, '') AS sede_salida
			  ,vig_ingresosalida.salida_idvehiculo
			  ,ISNULL(vig_vehiculos_salida.marca,'') AS vehiculo_salida_marca
			  ,ISNULL(vig_vehiculos_salida.color,'') AS vehiculo_salida_color
			  ,ISNULL(vig_vehiculos_salida.placa,'') AS vehiculo_salida_placa
			  ,ISNULL(vig_vehiculos_salida.vencimiento_soat,'') AS vehiculo_salida_vencimiento_soat
			  ,ISNULL(vig_vehiculos_salida.vencimiento_revision,'') AS vehiculo_salida_vencimiento_revision
			  ,vig_ingresosalida.salida_observacion
			  ,vig_ingresosalida.salida_usuario
			  ,ISNULL(activos.nro,0) AS activos
		FROM vig_ingresosalida
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		LEFT JOIN adm_personal adm_personal_visita ON adm_personal_visita.idpersonal = vig_ingresosalida.idpersonalvisita
		INNER JOIN adm_personas	ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_personas adm_personas_visita ON adm_personas_visita.idpersona = adm_personal_visita.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_ingresosalida.ingreso_idsede
		LEFT JOIN adm_empresas_sedes adm_empresas_sedes_salida ON adm_empresas_sedes_salida.idsede = vig_ingresosalida.salida_idsede
		LEFT JOIN vig_vehiculos ON vig_vehiculos.idvehiculo = vig_ingresosalida.ingreso_idvehiculo
		LEFT JOIN vig_vehiculos vig_vehiculos_salida ON vig_vehiculos_salida.idvehiculo = vig_ingresosalida.salida_idvehiculo
		LEFT JOIN (SELECT ides, COUNT(idesactivo) AS nro FROM vig_ingresosalida_activos GROUP BY ides) activos ON activos.ides = vig_ingresosalida.ides
		LEFT JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = vig_ingresosalida.idtipopersonal
		LEFT JOIN adm_tipos_ingresosalida adm_tipos_ingreso ON adm_tipos_ingreso.idtipoingresosalida = vig_ingresosalida.ingreso_tiporegistro
	    LEFT JOIN adm_tipos_ingresosalida adm_tipos_salida ON adm_tipos_ingreso.idtipoingresosalida = vig_ingresosalida.salida_tiporegistro
		-- LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idempresa
	    LEFT JOIN adm_empresas terceros ON terceros.idempresa = vig_ingresosalida.idempresa
		LEFT JOIN adm_empresas_sedes sedes ON sedes.idsede = vig_ingresosalida.idsede
		LEFT JOIN vig_puestos puestos ON puestos.idpuesto = vig_ingresosalida.idpuesto
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 08/01/2024
-- Description:	Lista de la tabla vig_ingresosalida en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_lista_idempresa] 
@idempresa INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida.ides
			  ,vig_ingresosalida.idempresa
			  ,terceros.nombre AS empresa
			  ,vig_ingresosalida.idsede
			  ,sedes.nombre AS sede
			  ,vig_ingresosalida.idpuesto
			  ,puestos.nombre AS puesto
			  ,vig_ingresosalida.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipopersonal
			  ,vig_ingresosalida.idpersonal
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.idtipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombres
			  ,vig_ingresosalida.idpersonalvisita
			  ,adm_personas_visita.paterno as paterno_visita
			  ,adm_personas_visita.materno as materno_visita
			  ,adm_personas_visita.nombre as nombre_visita
			  ,adm_personas_visita.paterno + ' ' + adm_personas_visita.materno + ' ' + adm_personas_visita.nombre AS nombres_visita
			  ,vig_ingresosalida.ingreso_tiporegistro
			  ,vig_ingresosalida.ingreso_hora
			  ,vig_ingresosalida.ingreso_idsede
			  ,adm_empresas_sedes.nombre AS sede_ingreso
			  ,vig_ingresosalida.ingreso_idvehiculo
			  ,ISNULL(vig_vehiculos.marca,'') AS vehiculo_entrada_marca
			  ,ISNULL(vig_vehiculos.color,'') AS vehiculo_entrada_color
			  ,ISNULL(vig_vehiculos.placa,'') AS vehiculo_entrada_placa
			  ,ISNULL(vig_vehiculos.vencimiento_soat,'') AS vehiculo_entrada_vencimiento_soat
			  ,ISNULL(vig_vehiculos.vencimiento_revision,'') AS vehiculo_entrada_vencimiento_revision
			  ,vig_ingresosalida.ingreso_observacion
			  ,vig_ingresosalida.ingreso_usuario
			  ,vig_ingresosalida.salida_tiporegistro
			  ,vig_ingresosalida.salida_hora
			  ,vig_ingresosalida.salida_idsede
			  ,ISNULL(adm_empresas_sedes_salida.nombre, '') AS sede_salida
			  ,vig_ingresosalida.salida_idvehiculo
			  ,ISNULL(vig_vehiculos_salida.marca,'') AS vehiculo_salida_marca
			  ,ISNULL(vig_vehiculos_salida.color,'') AS vehiculo_salida_color
			  ,ISNULL(vig_vehiculos_salida.placa,'') AS vehiculo_salida_placa
			  ,ISNULL(vig_vehiculos_salida.vencimiento_soat,'') AS vehiculo_salida_vencimiento_soat
			  ,ISNULL(vig_vehiculos_salida.vencimiento_revision,'') AS vehiculo_salida_vencimiento_revision
			  ,vig_ingresosalida.salida_observacion
			  ,vig_ingresosalida.salida_usuario
			  ,ISNULL(activos.nro,0) AS activos
		FROM vig_ingresosalida
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		LEFT JOIN adm_personal adm_personal_visita ON adm_personal_visita.idpersonal = vig_ingresosalida.idpersonalvisita
		INNER JOIN adm_personas	ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_personas adm_personas_visita ON adm_personas_visita.idpersona = adm_personal_visita.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_ingresosalida.ingreso_idsede
		LEFT JOIN adm_empresas_sedes adm_empresas_sedes_salida ON adm_empresas_sedes_salida.idsede = vig_ingresosalida.salida_idsede
		LEFT JOIN vig_vehiculos ON vig_vehiculos.idvehiculo = vig_ingresosalida.ingreso_idvehiculo
		LEFT JOIN vig_vehiculos vig_vehiculos_salida ON vig_vehiculos_salida.idvehiculo = vig_ingresosalida.salida_idvehiculo
		LEFT JOIN (SELECT ides, COUNT(idesactivo) AS nro FROM vig_ingresosalida_activos GROUP BY ides) activos ON activos.ides = vig_ingresosalida.ides
		LEFT JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = vig_ingresosalida.idtipopersonal
		-- LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idempresa
	    LEFT JOIN adm_empresas terceros ON terceros.idempresa = vig_ingresosalida.idempresa
		LEFT JOIN adm_empresas_sedes sedes ON sedes.idsede = vig_ingresosalida.idsede
		LEFT JOIN vig_puestos puestos ON puestos.idpuesto = vig_ingresosalida.idpuesto
	    WHERE terceros.idempresa = @idempresa
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_lista_idempresa_idtipopersonal]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 08/01/2024
-- Description:	Lista de la tabla vig_ingresosalida en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_lista_idempresa_idtipopersonal] 
@idempresa INT = 0,
@idtipopersonal VARCHAR(50) = ''

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida.ides
			  ,vig_ingresosalida.idempresa
			  ,terceros.nombre AS empresa
			  ,vig_ingresosalida.idsede
			  ,sedes.nombre AS sede
			  ,vig_ingresosalida.idpuesto
			  ,puestos.nombre AS puesto
			  ,vig_ingresosalida.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipopersonal
			  ,vig_ingresosalida.idpersonal
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.idtipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombres
			  ,vig_ingresosalida.idpersonalvisita
			  ,adm_personas_visita.paterno as paterno_visita
			  ,adm_personas_visita.materno as materno_visita
			  ,adm_personas_visita.nombre as nombre_visita
			  ,adm_personas_visita.paterno + ' ' + adm_personas_visita.materno + ' ' + adm_personas_visita.nombre AS nombres_visita
			  ,vig_ingresosalida.ingreso_tiporegistro
			  ,vig_ingresosalida.ingreso_hora
			  ,vig_ingresosalida.ingreso_idsede
			  ,adm_empresas_sedes.nombre AS sede_ingreso
			  ,vig_ingresosalida.ingreso_idvehiculo
			  ,ISNULL(vig_vehiculos.marca,'') AS vehiculo_entrada_marca
			  ,ISNULL(vig_vehiculos.color,'') AS vehiculo_entrada_color
			  ,ISNULL(vig_vehiculos.placa,'') AS vehiculo_entrada_placa
			  ,ISNULL(vig_vehiculos.vencimiento_soat,'') AS vehiculo_entrada_vencimiento_soat
			  ,ISNULL(vig_vehiculos.vencimiento_revision,'') AS vehiculo_entrada_vencimiento_revision
			  ,vig_ingresosalida.ingreso_observacion
			  ,vig_ingresosalida.ingreso_usuario
			  ,vig_ingresosalida.salida_tiporegistro
			  ,vig_ingresosalida.salida_hora
			  ,vig_ingresosalida.salida_idsede
			  ,ISNULL(adm_empresas_sedes_salida.nombre, '') AS sede_salida
			  ,vig_ingresosalida.salida_idvehiculo
			  ,ISNULL(vig_vehiculos_salida.marca,'') AS vehiculo_salida_marca
			  ,ISNULL(vig_vehiculos_salida.color,'') AS vehiculo_salida_color
			  ,ISNULL(vig_vehiculos_salida.placa,'') AS vehiculo_salida_placa
			  ,ISNULL(vig_vehiculos_salida.vencimiento_soat,'') AS vehiculo_salida_vencimiento_soat
			  ,ISNULL(vig_vehiculos_salida.vencimiento_revision,'') AS vehiculo_salida_vencimiento_revision
			  ,vig_ingresosalida.salida_observacion
			  ,vig_ingresosalida.salida_usuario
			  ,ISNULL(activos.nro,0) AS activos
		FROM vig_ingresosalida
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		LEFT JOIN adm_personal adm_personal_visita ON adm_personal_visita.idpersonal = vig_ingresosalida.idpersonalvisita
		INNER JOIN adm_personas	ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_personas adm_personas_visita ON adm_personas_visita.idpersona = adm_personal_visita.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_ingresosalida.ingreso_idsede
		LEFT JOIN adm_empresas_sedes adm_empresas_sedes_salida ON adm_empresas_sedes_salida.idsede = vig_ingresosalida.salida_idsede
		LEFT JOIN vig_vehiculos ON vig_vehiculos.idvehiculo = vig_ingresosalida.ingreso_idvehiculo
		LEFT JOIN vig_vehiculos vig_vehiculos_salida ON vig_vehiculos_salida.idvehiculo = vig_ingresosalida.salida_idvehiculo
		LEFT JOIN (SELECT ides, COUNT(idesactivo) AS nro FROM vig_ingresosalida_activos GROUP BY ides) activos ON activos.ides = vig_ingresosalida.ides
		LEFT JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = vig_ingresosalida.idtipopersonal
		-- LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idempresa
	    LEFT JOIN adm_empresas terceros ON terceros.idempresa = vig_ingresosalida.idempresa
		LEFT JOIN adm_empresas_sedes sedes ON sedes.idsede = vig_ingresosalida.idsede
		LEFT JOIN vig_puestos puestos ON puestos.idpuesto = vig_ingresosalida.idpuesto
	    WHERE terceros.idempresa = @idempresa and vig_ingresosalida.idtipopersonal = @idtipopersonal
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_lista_idempresa_idtipopersonal_ingresohora]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JOSE LUIS AUGUSTO ROMERO QUINTANA
-- Create date: 22/03/2024
-- Description:	Lista de la tabla vig_ingresosalida en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_lista_idempresa_idtipopersonal_ingresohora] 
@idempresa INT = 0,
@idtipopersonal VARCHAR(50) = '',
@fechaDesdeIngreso DATETIME = "1900-01-01"

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida.ides
			  ,vig_ingresosalida.idempresa
			  ,terceros.nombre AS empresa
			  ,vig_ingresosalida.idsede
			  ,sedes.nombre AS sede
			  ,vig_ingresosalida.idpuesto
			  ,puestos.nombre AS puesto
			  ,vig_ingresosalida.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipopersonal
			  ,vig_ingresosalida.idpersonal
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.idtipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombres
			  ,vig_ingresosalida.idpersonalvisita
			  ,adm_personas_visita.paterno as paterno_visita
			  ,adm_personas_visita.materno as materno_visita
			  ,adm_personas_visita.nombre as nombre_visita
			  ,adm_personas_visita.paterno + ' ' + adm_personas_visita.materno + ' ' + adm_personas_visita.nombre AS nombres_visita
			  ,vig_ingresosalida.ingreso_tiporegistro
			  ,vig_ingresosalida.ingreso_hora
			  ,vig_ingresosalida.ingreso_idsede
			  ,adm_empresas_sedes.nombre AS sede_ingreso
			  ,vig_ingresosalida.ingreso_idvehiculo
			  ,ISNULL(vig_vehiculos.marca,'') AS vehiculo_entrada_marca
			  ,ISNULL(vig_vehiculos.color,'') AS vehiculo_entrada_color
			  ,ISNULL(vig_vehiculos.placa,'') AS vehiculo_entrada_placa
			  ,ISNULL(vig_vehiculos.vencimiento_soat,'') AS vehiculo_entrada_vencimiento_soat
			  ,ISNULL(vig_vehiculos.vencimiento_revision,'') AS vehiculo_entrada_vencimiento_revision
			  ,vig_ingresosalida.ingreso_observacion
			  ,vig_ingresosalida.ingreso_usuario
			  ,vig_ingresosalida.salida_tiporegistro
			  ,vig_ingresosalida.salida_hora
			  ,vig_ingresosalida.salida_idsede
			  ,ISNULL(adm_empresas_sedes_salida.nombre, '') AS sede_salida
			  ,vig_ingresosalida.salida_idvehiculo
			  ,ISNULL(vig_vehiculos_salida.marca,'') AS vehiculo_salida_marca
			  ,ISNULL(vig_vehiculos_salida.color,'') AS vehiculo_salida_color
			  ,ISNULL(vig_vehiculos_salida.placa,'') AS vehiculo_salida_placa
			  ,ISNULL(vig_vehiculos_salida.vencimiento_soat,'') AS vehiculo_salida_vencimiento_soat
			  ,ISNULL(vig_vehiculos_salida.vencimiento_revision,'') AS vehiculo_salida_vencimiento_revision
			  ,vig_ingresosalida.salida_observacion
			  ,vig_ingresosalida.salida_usuario
			  ,ISNULL(activos.nro,0) AS activos
		FROM vig_ingresosalida
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		LEFT JOIN adm_personal adm_personal_visita ON adm_personal_visita.idpersonal = vig_ingresosalida.idpersonalvisita
		INNER JOIN adm_personas	ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_personas adm_personas_visita ON adm_personas_visita.idpersona = adm_personal_visita.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_ingresosalida.ingreso_idsede
		LEFT JOIN adm_empresas_sedes adm_empresas_sedes_salida ON adm_empresas_sedes_salida.idsede = vig_ingresosalida.salida_idsede
		LEFT JOIN vig_vehiculos ON vig_vehiculos.idvehiculo = vig_ingresosalida.ingreso_idvehiculo
		LEFT JOIN vig_vehiculos vig_vehiculos_salida ON vig_vehiculos_salida.idvehiculo = vig_ingresosalida.salida_idvehiculo
		LEFT JOIN (SELECT ides, COUNT(idesactivo) AS nro FROM vig_ingresosalida_activos GROUP BY ides) activos ON activos.ides = vig_ingresosalida.ides
		LEFT JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = vig_ingresosalida.idtipopersonal
		-- LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idempresa
	    LEFT JOIN adm_empresas terceros ON terceros.idempresa = vig_ingresosalida.idempresa
		LEFT JOIN adm_empresas_sedes sedes ON sedes.idsede = vig_ingresosalida.idsede
		LEFT JOIN vig_puestos puestos ON puestos.idpuesto = vig_ingresosalida.idpuesto
	    WHERE terceros.idempresa = @idempresa and vig_ingresosalida.idtipopersonal = @idtipopersonal and CONVERT(varchar, vig_ingresosalida.ingreso_hora, 23) = @fechaDesdeIngreso
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_lista_ides]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 08/01/2024
-- Description:	Lista de la tabla vig_ingresosalida en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_lista_ides] 
@ides INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_ingresosalida.ides
			  ,vig_ingresosalida.idempresa
			  ,terceros.nombre AS empresa
			  ,vig_ingresosalida.idsede
			  ,sedes.nombre AS sede
			  ,vig_ingresosalida.idpuesto
			  ,puestos.nombre AS puesto
			  ,vig_ingresosalida.idtipopersonal
			  ,adm_tipos_personal.nombre AS tipopersonal
			  ,vig_ingresosalida.idpersonal
			  ,adm_personas.paterno
			  ,adm_personas.materno
			  ,adm_personas.nombre
			  ,adm_personas.idtipodocumento
			  ,adm_personas.documento
			  ,adm_personas.paterno + ' ' + adm_personas.materno + ' ' + adm_personas.nombre AS nombres
			  ,vig_ingresosalida.idpersonalvisita
			  ,adm_personas_visita.paterno as paterno_visita
			  ,adm_personas_visita.materno as materno_visita
			  ,adm_personas_visita.nombre as nombre_visita
			  ,adm_personas_visita.paterno + ' ' + adm_personas_visita.materno + ' ' + adm_personas_visita.nombre AS nombres_visita
			  ,vig_ingresosalida.ingreso_tiporegistro
			  ,adm_tipos_ingreso.nombre AS nombreingresotiporegistro
			  ,vig_ingresosalida.ingreso_hora
			  ,vig_ingresosalida.ingreso_idsede
			  ,adm_empresas_sedes.nombre AS sede_ingreso
			  ,vig_ingresosalida.ingreso_idvehiculo
			  ,ISNULL(vig_vehiculos.marca,'') AS vehiculo_entrada_marca
			  ,ISNULL(vig_vehiculos.color,'') AS vehiculo_entrada_color
			  ,ISNULL(vig_vehiculos.placa,'') AS vehiculo_entrada_placa
			  ,ISNULL(vig_vehiculos.vencimiento_soat,'') AS vehiculo_entrada_vencimiento_soat
			  ,ISNULL(vig_vehiculos.vencimiento_revision,'') AS vehiculo_entrada_vencimiento_revision
			  ,vig_ingresosalida.ingreso_observacion
			  ,vig_ingresosalida.ingreso_usuario
			  ,vig_ingresosalida.salida_tiporegistro
			  ,adm_tipos_salida.nombre AS nombresalidatiporegistro
			  ,vig_ingresosalida.salida_hora
			  ,vig_ingresosalida.salida_idsede
			  ,ISNULL(adm_empresas_sedes_salida.nombre, '') AS sede_salida
			  ,vig_ingresosalida.salida_idvehiculo
			  ,ISNULL(vig_vehiculos_salida.marca,'') AS vehiculo_salida_marca
			  ,ISNULL(vig_vehiculos_salida.color,'') AS vehiculo_salida_color
			  ,ISNULL(vig_vehiculos_salida.placa,'') AS vehiculo_salida_placa
			  ,ISNULL(vig_vehiculos_salida.vencimiento_soat,'') AS vehiculo_salida_vencimiento_soat
			  ,ISNULL(vig_vehiculos_salida.vencimiento_revision,'') AS vehiculo_salida_vencimiento_revision
			  ,vig_ingresosalida.salida_observacion
			  ,vig_ingresosalida.salida_usuario
			  ,ISNULL(activos.nro,0) AS activos
		FROM vig_ingresosalida
		INNER JOIN adm_personal ON adm_personal.idpersonal = vig_ingresosalida.idpersonal
		LEFT JOIN adm_personal adm_personal_visita ON adm_personal_visita.idpersonal = vig_ingresosalida.idpersonalvisita
		INNER JOIN adm_personas	ON adm_personas.idpersona = adm_personal.idpersona
		LEFT JOIN adm_personas adm_personas_visita ON adm_personas_visita.idpersona = adm_personal_visita.idpersona
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_ingresosalida.ingreso_idsede
		LEFT JOIN adm_empresas_sedes adm_empresas_sedes_salida ON adm_empresas_sedes_salida.idsede = vig_ingresosalida.salida_idsede
		LEFT JOIN vig_vehiculos ON vig_vehiculos.idvehiculo = vig_ingresosalida.ingreso_idvehiculo
		LEFT JOIN vig_vehiculos vig_vehiculos_salida ON vig_vehiculos_salida.idvehiculo = vig_ingresosalida.salida_idvehiculo
		LEFT JOIN (SELECT ides, COUNT(idesactivo) AS nro FROM vig_ingresosalida_activos GROUP BY ides) activos ON activos.ides = vig_ingresosalida.ides
		LEFT JOIN adm_tipos_personal ON adm_tipos_personal.idtipopersonal = vig_ingresosalida.idtipopersonal
		LEFT JOIN adm_tipos_ingresosalida adm_tipos_ingreso ON adm_tipos_ingreso.idtipoingresosalida = vig_ingresosalida.ingreso_tiporegistro
	    LEFT JOIN adm_tipos_ingresosalida adm_tipos_salida ON adm_tipos_ingreso.idtipoingresosalida = vig_ingresosalida.salida_tiporegistro
		-- LEFT JOIN adm_empresas terceros ON terceros.idempresa = adm_personal.idempresa
	    LEFT JOIN adm_empresas terceros ON terceros.idempresa = vig_ingresosalida.idempresa
		LEFT JOIN adm_empresas_sedes sedes ON sedes.idsede = vig_ingresosalida.idsede
		LEFT JOIN vig_puestos puestos ON puestos.idpuesto = vig_ingresosalida.idpuesto
	    WHERE vig_ingresosalida.ides = @ides
		ORDER BY adm_personas.paterno, adm_personas.materno, adm_personas.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_ingresosalida_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 10/10/2023
-- Description:	Mantenimiento de la tabla vig_ingresosalida
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_ingresosalida_mantenimiento] 
@tipo INT,
@ides INT = null OUTPUT,
@idempresa INT = 0,
@idsede INT = 0,
@idpuesto INT = 0,
@idtipopersonal INT = 0,
@idpersonal INT = null,
@idpersonalvisita INT = null,
@ingreso_tiporegistro INT = 0,
@ingreso_hora DATETIME = "1900-01-01",
@ingreso_idsede INT = 0,
@ingreso_idvehiculo INT = 0,
@ingreso_observacion VARCHAR(50) = " ",
@ingreso_usuario VARCHAR(50) = " ",
@salida_tiporegistro INT = 0,
@salida_hora DATETIME = "1900-01-01",
@salida_idsede INT = 0,
@salida_idvehiculo INT = 0,
@salida_observacion VARCHAR(100) = " ",
@salida_usuario VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;
--    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_ingresosalida VALUES(
						 @idempresa
						,@idsede
						,@idpuesto
						,@idtipopersonal
						,@idpersonal
						,@idpersonalvisita
						,@ingreso_tiporegistro
						,@ingreso_hora
						,@ingreso_idsede
						,@ingreso_idvehiculo
						,@ingreso_observacion
						,@ingreso_usuario
						,@salida_tiporegistro
						,@salida_hora
						,@salida_idsede
						,@salida_idvehiculo
						,@salida_observacion
						,@salida_usuario
						)

					SET @ides = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_ingresosalida
						SET	 idempresa = @idempresa
							,idsede = @idsede
							,idpuesto = @idpuesto
							,idtipopersonal = @idtipopersonal
						    ,idpersonal = @idpersonal
							,idpersonalvisita = @idpersonalvisita
							,ingreso_tiporegistro = @ingreso_tiporegistro
							,ingreso_hora = @ingreso_hora
							,ingreso_idsede = @ingreso_idsede
							,ingreso_idvehiculo = @ingreso_idvehiculo
							,ingreso_observacion = @ingreso_observacion
							,ingreso_usuario = @ingreso_usuario
							,salida_tiporegistro = @salida_tiporegistro
							,salida_hora = @salida_hora
							,salida_idsede = @salida_idsede
							,salida_idvehiculo = @salida_idvehiculo
							,salida_observacion = @salida_observacion
							,salida_usuario = @salida_usuario
						WHERE ides = @ides
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_ingresosalida WHERE ides = @ides
						END
        COMMIT TRANSACTION;
	IF @@TRANCOUNT > 0
    BEGIN
		ROLLBACK TRANSACTION;
	END

  --  END TRY
  --  BEGIN CATCH
		---- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
  --      IF @@TRANCOUNT > 0
  --      BEGIN
  --          ROLLBACK TRANSACTION;
  --      END

  --      --EXECUTE USP_seg_error_registro;
  --  END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_puestos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_puestos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_puestos_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idpuesto
		      ,adm_empresas.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
		      ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_sedes.direccion
			  ,vig_puestos.nombre
			  ,vig_puestos.activo
			  ,vig_puestos.usuarioregistro
			  ,vig_puestos.fecharegistro
		FROM vig_puestos
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_puestos.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_puestos.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_puestos.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, vig_puestos.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_puestos_lista_idcamara]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Luis Romero Quintana
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_puestos en orden alfabetico por sede
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_puestos_lista_idcamara] 
@idcamara INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idpuesto
		      ,adm_empresas.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
		      ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_sedes.direccion
			  ,vig_camaras.idcamara
			  ,vig_camaras.nombre AS camara
			  ,vig_puestos.nombre
			  ,vig_puestos.activo
			  ,vig_puestos.usuarioregistro
			  ,vig_puestos.fecharegistro
		FROM vig_puestos
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_puestos.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		LEFT JOIN vig_camaras ON vig_camaras.idcamara = vig_puestos.idcamara
		WHERE vig_puestos.idcamara = @idcamara
			AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_puestos.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_puestos.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, vig_puestos.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_puestos_lista_idempresa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_puestos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_puestos_lista_idempresa] 
@idempresa INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idpuesto
		      ,adm_empresas.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
		      ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_sedes.direccion
			  ,vig_puestos.nombre
			  ,vig_puestos.activo
			  ,vig_puestos.usuarioregistro
			  ,vig_puestos.fecharegistro
		FROM vig_puestos
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_puestos.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE adm_empresas_sedes.idempresa = @idempresa
			AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_puestos.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_puestos.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, vig_puestos.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_puestos_lista_idsede]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Lista de la tabla vig_puestos en orden alfabetico por sede
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_puestos_lista_idsede] 
@idsede INT = 0,
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT idpuesto
		      ,adm_empresas.idempresa
			  ,adm_empresas.ruc
			  ,adm_empresas.nombre AS empresa
		      ,adm_empresas_sedes.idsede
			  ,adm_empresas_sedes.nombre AS sede
			  ,adm_empresas_sedes.direccion
			  ,vig_puestos.nombre
			  ,vig_puestos.activo
			  ,vig_puestos.usuarioregistro
			  ,vig_puestos.fecharegistro
		FROM vig_puestos
		INNER JOIN adm_empresas_sedes ON adm_empresas_sedes.idsede = vig_puestos.idsede
		INNER JOIN adm_empresas ON adm_empresas.idempresa = adm_empresas_sedes.idempresa
		WHERE vig_puestos.idsede = @idsede
			AND CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_puestos.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_puestos.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY adm_empresas.nombre, adm_empresas_sedes.nombre, vig_puestos.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_puestos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla vig_puestos
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_puestos_mantenimiento] 
@tipo INT,
@idpuesto INT = NULL OUTPUT,
@idsede INT = 0,
@nombre VARCHAR(50) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_puestos VALUES(
						@idsede
						,@nombre
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idpuesto = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_puestos
						SET idsede = @idsede
							,nombre = @nombre
							,activo = @activo
						WHERE idpuesto = @idpuesto
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_puestos WHERE idpuesto = @idpuesto
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_tipos_correspondencia_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_tipos_documentos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_tipos_correspondencia_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_tipos_correspondencia.idtipocorrespondencia
			  ,vig_tipos_correspondencia.nombre
			  ,vig_tipos_correspondencia.observacion
			  ,vig_tipos_correspondencia.activo
			  ,vig_tipos_correspondencia.usuarioregistro
			  ,vig_tipos_correspondencia.fecharegistro
		FROM vig_tipos_correspondencia
		ORDER BY vig_tipos_correspondencia.nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END

GO
/****** Object:  StoredProcedure [dbo].[USP_vig_tipos_correspondencia_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 15/10/2024
-- Description:	Mantenimiento de la tabla vig_tipos_documentos
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_tipos_correspondencia_mantenimiento] 
@tipo INT,
@idtipocorrespondencia INT = NULL OUTPUT,
@nombre VARCHAR(250) = " ",
@observacion VARCHAR(250) = " ",
@activo INT = 1,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_tipos_correspondencia VALUES(
						 @nombre
						,@observacion
						,@activo
						,@usuarioregistro
						,GETDATE())
					SET @idtipocorrespondencia = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_tipos_correspondencia
						SET  nombre = @nombre
							,observacion = @observacion
							,activo = @activo
							,usuarioregistro = @usuarioregistro
						WHERE idtipocorrespondencia = @idtipocorrespondencia
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_tipos_correspondencia WHERE idtipocorrespondencia = @idtipocorrespondencia
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_vehiculos_lista]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_vehiculos en orden alfabetico
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_vehiculos_lista] 
@idestado INT = 2 -- 1 = Activo, 0 = Inactivo, 2 = Todos

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_vehiculos.idvehiculo
			  ,vig_vehiculos.placa
			  ,vig_vehiculos.marca
			  ,vig_vehiculos.color
			  ,adm_tipos_vehiculos.idtipovehiculo
			  ,adm_tipos_vehiculos.nombre as tipovehiculo
			  ,vig_vehiculos.vencimiento_soat
			  ,vig_vehiculos.vencimiento_revision
			  ,vig_vehiculos.codigo
			  ,vig_vehiculos.observacion
			  ,vig_vehiculos.activo
			  ,vig_vehiculos.usuarioregistro
			  ,vig_vehiculos.fecharegistro
		FROM vig_vehiculos
		INNER JOIN adm_tipos_vehiculos ON adm_tipos_vehiculos.idtipovehiculo = vig_vehiculos.idtipovehiculo
		WHERE CASE
				WHEN @idestado = 2 THEN 1 -- activos e inactivos
				WHEN @idestado = 1 AND vig_vehiculos.activo = 1 THEN 1 -- activos
				WHEN @idestado = 0 AND vig_vehiculos.activo = 0 THEN 1 -- inactivos
			END = 1
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_vehiculos_lista_codigo]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_vehiculos por codigo
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_vehiculos_lista_codigo]
@codigo VARCHAR (10) = ''

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_vehiculos.idvehiculo
			  ,vig_vehiculos.placa
			  ,vig_vehiculos.marca
			  ,vig_vehiculos.color
			  ,adm_tipos_vehiculos.idtipovehiculo
			  ,adm_tipos_vehiculos.nombre as tipovehiculo
			  ,vig_vehiculos.vencimiento_soat
			  ,vig_vehiculos.vencimiento_revision
			  ,vig_vehiculos.codigo
			  ,vig_vehiculos.observacion
			  ,vig_vehiculos.activo
			  ,vig_vehiculos.usuarioregistro
			  ,vig_vehiculos.fecharegistro
		FROM vig_vehiculos
		INNER JOIN adm_tipos_vehiculos ON adm_tipos_vehiculos.idtipovehiculo = vig_vehiculos.idtipovehiculo
		WHERE codigo = @codigo
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_vehiculos_lista_idvehiculo]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_vehiculos por placa
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_vehiculos_lista_idvehiculo]
@idvehiculo INT = 0

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_vehiculos.idvehiculo
			  ,vig_vehiculos.placa
			  ,vig_vehiculos.marca
			  ,vig_vehiculos.color
			  ,adm_tipos_vehiculos.idtipovehiculo
			  ,adm_tipos_vehiculos.nombre as tipovehiculo
			  ,vig_vehiculos.vencimiento_soat
			  ,vig_vehiculos.vencimiento_revision
			  ,vig_vehiculos.codigo
			  ,vig_vehiculos.observacion
			  ,vig_vehiculos.activo
			  ,vig_vehiculos.usuarioregistro
			  ,vig_vehiculos.fecharegistro
		FROM vig_vehiculos
		INNER JOIN adm_tipos_vehiculos ON adm_tipos_vehiculos.idtipovehiculo = vig_vehiculos.idtipovehiculo
		WHERE idvehiculo = @idvehiculo
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_vehiculos_lista_placa]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Lista de la tabla vig_vehiculos por placa
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_vehiculos_lista_placa]
@placa VARCHAR (10) = ''

AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
		SELECT vig_vehiculos.idvehiculo
			  ,vig_vehiculos.placa
			  ,vig_vehiculos.marca
			  ,vig_vehiculos.color
			  ,adm_tipos_vehiculos.idtipovehiculo
			  ,adm_tipos_vehiculos.nombre as tipovehiculo
			  ,vig_vehiculos.vencimiento_soat
			  ,vig_vehiculos.vencimiento_revision
			  ,vig_vehiculos.codigo
			  ,vig_vehiculos.observacion
			  ,vig_vehiculos.activo
			  ,vig_vehiculos.usuarioregistro
			  ,vig_vehiculos.fecharegistro
		FROM vig_vehiculos
		INNER JOIN adm_tipos_vehiculos ON adm_tipos_vehiculos.idtipovehiculo = vig_vehiculos.idtipovehiculo
		WHERE placa = @placa
		ORDER BY nombre
	END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_vig_vehiculos_mantenimiento]    Script Date: 11/04/2024 17:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Romero
-- Create date: 09/10/2023
-- Description:	Mantenimiento de la tabla vig_vehiculos
-- =============================================
CREATE PROCEDURE [dbo].[USP_vig_vehiculos_mantenimiento] 
@tipo INT,
@idvehiculo INT = NULL OUTPUT,
@placa VARCHAR(10) = " ",
@marca VARCHAR(50) = " ",
@color VARCHAR(10) = " ",
@idtipovehiculo INT = 0,
@vencimiento_soat DATETIME = "1900-01-01",
@vencimiento_revision DATETIME = "1900-01-01",
@codigo VARCHAR(10) = " ",
@observacion VARCHAR(100) = " ",
@activo INT = 0,
@usuarioregistro VARCHAR(50) = " "

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
			IF @tipo=1 
				BEGIN
					INSERT INTO vig_vehiculos VALUES(
						 @placa
						,@marca
						,@color
						,@idtipovehiculo
						,@vencimiento_soat
						,@vencimiento_revision
						,@codigo
						,@observacion
						,@activo
						,@usuarioregistro
						,GETDATE())

					SET @idvehiculo = SCOPE_IDENTITY();
				END
			ELSE 
				IF @tipo = 2
					BEGIN
						UPDATE vig_vehiculos
						SET  placa = @placa
							,marca = @marca
							,color = @color
							,idtipovehiculo = @idtipovehiculo
							,vencimiento_soat = @vencimiento_soat
							,vencimiento_revision = @vencimiento_revision
							,codigo = @codigo
							,observacion = @observacion
							,activo = @activo
						WHERE idvehiculo = @idvehiculo
					END
				ELSE 
					IF @tipo = 3
						BEGIN
							DELETE vig_vehiculos WHERE idvehiculo = @idvehiculo
						END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
		-- Revertir cualquier transacción activa o no comprometida antes de insertar información en el registro de errores
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE USP_seg_error_registro;
    END CATCH;
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicador si es obligatorio al area' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adm_empresas_tipos_personal', @level2type=N'COLUMN',@level2name=N'flgarea'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Indicador si es obligatorio el brevete' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'adm_empresas_tipos_personal', @level2type=N'COLUMN',@level2name=N'flgbrevete'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = peatonal, 2= vehicular, 3 = visitante, 4 = transportista' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vig_ingresosalida', @level2type=N'COLUMN',@level2name=N'idtipopersonal'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 = peatonal, 2= vehicular' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'vig_ingresosalida', @level2type=N'COLUMN',@level2name=N'ingreso_tiporegistro'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vt_seg_log_acciones'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vt_seg_log_acciones'
GO
USE [master]
GO
ALTER DATABASE [mmfm] SET  READ_WRITE 
GO

USE [master]
GO
/****** Object:  Database [BOOKFACE]    Script Date: 10/26/2020 10:41:26 PM ******/
CREATE DATABASE [BOOKFACE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BOOKFACE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\BOOKFACE.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BOOKFACE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\BOOKFACE_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [BOOKFACE] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BOOKFACE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BOOKFACE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BOOKFACE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BOOKFACE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BOOKFACE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BOOKFACE] SET ARITHABORT OFF 
GO
ALTER DATABASE [BOOKFACE] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [BOOKFACE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BOOKFACE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BOOKFACE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BOOKFACE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BOOKFACE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BOOKFACE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BOOKFACE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BOOKFACE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BOOKFACE] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BOOKFACE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BOOKFACE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BOOKFACE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BOOKFACE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BOOKFACE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BOOKFACE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BOOKFACE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BOOKFACE] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BOOKFACE] SET  MULTI_USER 
GO
ALTER DATABASE [BOOKFACE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BOOKFACE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BOOKFACE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BOOKFACE] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BOOKFACE] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BOOKFACE] SET QUERY_STORE = OFF
GO
USE [BOOKFACE]
GO
/****** Object:  Schema [Interactions]    Script Date: 10/26/2020 10:41:27 PM ******/
CREATE SCHEMA [Interactions]
GO
/****** Object:  Schema [Person]    Script Date: 10/26/2020 10:41:27 PM ******/
CREATE SCHEMA [Person]
GO
/****** Object:  UserDefinedFunction [Interactions].[Validar_Interacciones_Amigos]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--declare @fechaPredeterminada datetime
--set @fechaPredeterminada = GETDATE()

--exec Person.usp_MaxAmigos @fechaPredeterminada

--********************************************************FUNCIONES************************************************************************

--FUNCION QUE RETORNARÁ 0 SI NO ES AMIGO DEL USUARIO Y 1 SI ES AMIGO DEL USUARIO, PARA VALIDAR QUE UNICAMENTE AMIGOS DEL USUARIO PUEDAN REACCIONAR A SUS PUBLICACIONES
create   function [Interactions].[Validar_Interacciones_Amigos]
			(@id_amigo int, @id_publicacion int, @tipo nvarchar(11))
returns int
as
begin

	declare @validar int,@id_usuario int

	if(@tipo = 'Comentario')
		begin
			select @id_usuario =p.ID_Usuario from Interactions.Publicacion p  where p.ID_Publicacion = @id_publicacion
			select @validar = COUNT(ID_FR) from Person.Amigo where ID_FR = @id_amigo and ID_Usuario = @id_usuario
		end

	if(@tipo = 'Like')
		begin
			select @id_usuario =p.ID_Usuario from Interactions.Publicacion p  where p.ID_Publicacion = @id_publicacion
			select @validar = COUNT(ID_FR) from Person.Amigo where ID_FR = @id_amigo and ID_Usuario = @id_usuario
		end

	return @validar
end
GO
/****** Object:  UserDefinedFunction [Person].[Retornar_MaxAmigos]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--FUNCIONA QUE RETORNA 0 SI EL USUARIO HA LLEGADO AL MAXIMO DE AMIGOS Y NO PUEDE INSERTAR MÁS AMIGOS Y RETORNA 1 SI AUN NO HA LLEGADO AL MAXIMO Y PUEDE AGREGAR MÁS AMIGOS
create   function [Person].[Retornar_MaxAmigos]
(@id_usuario int,@id_amigo int)
returns int
as 
begin

		declare @bool int,
				@total int, 
				@total2 int

		select @total = Total_Maximo_Amigos from Person.Usuario where ID_Usuario = @id_usuario
		select @total2 = COUNT(ID_Usuario) from Person.Amigo where ID_Usuario = @id_usuario

		set @total2 = @total2 +1

		if(@total >= @total2)
			begin
				set @bool = 1
			end
		else
			begin
				set @bool = 0
			end

	return @bool
end
GO
/****** Object:  Table [Interactions].[Comentario]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Interactions].[Comentario](
	[ID_Comentario] [int] NOT NULL,
	[ID_Publicacion] [int] NOT NULL,
	[Estado] [varchar](8) NOT NULL,
	[NumeroCola] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[ID_Amigo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Comentario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Interactions].[Likes]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Interactions].[Likes](
	[ID_Publicacion] [int] NOT NULL,
	[Tipo_Like] [nvarchar](10) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[ID_Amigo] [int] NOT NULL,
	[Estado] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Interactions].[Publicacion]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Interactions].[Publicacion](
	[ID_Publicacion] [int] IDENTITY(1,1) NOT NULL,
	[ID_Usuario] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[IP_Address] [varchar](16) NOT NULL,
	[Tipo_Dispositivo] [int] NOT NULL,
	[Tipo_Publicacion] [int] NOT NULL,
	[Contenido] [nvarchar](max) NOT NULL,
	[Estado] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Publicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Interactions].[Tipo_Dispositivo]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Interactions].[Tipo_Dispositivo](
	[ID_Tipo] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Interactions].[Tipo_Publicacion]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Interactions].[Tipo_Publicacion](
	[ID_Tipo] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Person].[Amigo]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[Amigo](
	[ID_Usuario] [int] NOT NULL,
	[ID_FR] [int] NOT NULL,
	[Fecha_Inicio_Amistad] [date] NOT NULL,
	[Fecha_Fin_Amistad] [date] NULL,
 CONSTRAINT [PK_Amigo] PRIMARY KEY CLUSTERED 
(
	[ID_Usuario] ASC,
	[ID_FR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Person].[Usuario]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Person].[Usuario](
	[ID_Usuario] [int] IDENTITY(1,1) NOT NULL,
	[Primer_Nombre] [nvarchar](20) NOT NULL,
	[Segundo_Nombre] [nvarchar](20) NOT NULL,
	[Primer_Apellido] [nvarchar](20) NOT NULL,
	[Segundo_Apellido] [nvarchar](20) NOT NULL,
	[Correo_Electronico] [nvarchar](50) NOT NULL,
	[Total_Maximo_Amigos] [int] NULL,
	[Fecha_Nacimiento] [date] NOT NULL,
	[Fecha_Creacion_Usuario] [datetime] NULL,
	[Fecha_Fin_Usuario] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (1, 281, N'activo', 1, CAST(N'2020-10-26T22:30:05.057' AS DateTime), 27)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (2, 281, N'activo', 2, CAST(N'2020-10-26T22:30:05.077' AS DateTime), 28)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (3, 281, N'activo', 3, CAST(N'2020-10-26T22:30:05.097' AS DateTime), 28)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (4, 281, N'inactivo', 4, CAST(N'2020-10-26T22:30:05.100' AS DateTime), 27)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (5, 281, N'inactivo', 5, CAST(N'2020-10-26T22:30:05.103' AS DateTime), 27)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (6, 282, N'activo', 1, CAST(N'2020-10-26T22:30:05.117' AS DateTime), 28)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (7, 282, N'activo', 2, CAST(N'2020-10-26T22:30:05.120' AS DateTime), 28)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (8, 282, N'activo', 3, CAST(N'2020-10-26T22:30:05.120' AS DateTime), 27)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (9, 282, N'activo', 3, CAST(N'2020-10-26T22:30:05.123' AS DateTime), 27)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (14, 284, N'activo', 1, CAST(N'2020-10-26T22:30:05.130' AS DateTime), 27)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (15, 284, N'activo', 2, CAST(N'2020-10-26T22:30:05.133' AS DateTime), 28)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (16, 284, N'activo', 3, CAST(N'2020-10-26T22:30:05.133' AS DateTime), 28)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (17, 284, N'activo', 3, CAST(N'2020-10-26T22:30:05.137' AS DateTime), 28)
INSERT [Interactions].[Comentario] ([ID_Comentario], [ID_Publicacion], [Estado], [NumeroCola], [Fecha], [ID_Amigo]) VALUES (18, 284, N'inactivo', 4, CAST(N'2020-10-26T22:30:05.140' AS DateTime), 27)
GO
INSERT [Interactions].[Likes] ([ID_Publicacion], [Tipo_Like], [fecha], [ID_Amigo], [Estado]) VALUES (281, N'Like', CAST(N'2020-10-26T22:32:50.170' AS DateTime), 27, 1)
INSERT [Interactions].[Likes] ([ID_Publicacion], [Tipo_Like], [fecha], [ID_Amigo], [Estado]) VALUES (281, N'Like', CAST(N'2020-10-26T22:32:50.190' AS DateTime), 28, 1)
INSERT [Interactions].[Likes] ([ID_Publicacion], [Tipo_Like], [fecha], [ID_Amigo], [Estado]) VALUES (282, N'Like', CAST(N'2020-10-26T22:33:14.600' AS DateTime), 27, 1)
INSERT [Interactions].[Likes] ([ID_Publicacion], [Tipo_Like], [fecha], [ID_Amigo], [Estado]) VALUES (282, N'Like', CAST(N'2020-10-26T22:33:14.610' AS DateTime), 28, 1)
INSERT [Interactions].[Likes] ([ID_Publicacion], [Tipo_Like], [fecha], [ID_Amigo], [Estado]) VALUES (284, N'Like', CAST(N'2020-10-26T22:34:09.217' AS DateTime), 27, 1)
INSERT [Interactions].[Likes] ([ID_Publicacion], [Tipo_Like], [fecha], [ID_Amigo], [Estado]) VALUES (284, N'Like', CAST(N'2020-10-26T22:34:09.223' AS DateTime), 28, 1)
GO
SET IDENTITY_INSERT [Interactions].[Publicacion] ON 

INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (1, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (2, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (3, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (4, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (5, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (6, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (7, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (8, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (9, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (10, 8, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.8', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (11, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (12, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (13, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (14, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (15, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (16, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (17, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (18, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (19, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (20, 7, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.7', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (21, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (22, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (23, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (24, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (25, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (26, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (27, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (28, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (29, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (30, 1, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.1', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (31, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (32, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (33, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (34, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (35, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (36, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (37, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (38, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (39, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (40, 5, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.5', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (41, 3, CAST(N'2020-10-26T22:07:47.313' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (42, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (43, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (44, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (45, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (46, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (47, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (48, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (49, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (50, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (51, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (52, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (53, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (54, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (55, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (56, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (57, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (58, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (59, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (60, 2, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.2', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (61, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (62, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (63, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (64, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (65, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (66, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (67, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (68, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (69, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (70, 3, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (71, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (72, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (73, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (74, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (75, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (76, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (77, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (78, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (79, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (80, 7, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.7', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (81, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (82, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (83, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (84, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (85, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (86, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (87, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (88, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (89, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (90, 5, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.5', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (91, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (92, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (93, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (94, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (95, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (96, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (97, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (98, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (99, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 2, 1, N'Imagen', 0)
GO
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (100, 6, CAST(N'2020-10-26T22:07:47.317' AS DateTime), N'198.162.15.6', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (101, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (102, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (103, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (104, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (105, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (106, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (107, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (108, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (109, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (110, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (111, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (112, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (113, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (114, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (115, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (116, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (117, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (118, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (119, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (120, 29, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.29', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (121, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (122, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (123, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (124, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (125, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (126, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (127, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (128, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (129, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (130, 10, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.10', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (131, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (132, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (133, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (134, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (135, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (136, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (137, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (138, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (139, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (140, 30, CAST(N'2020-10-26T22:16:18.920' AS DateTime), N'198.162.15.30', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (141, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (142, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (143, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (144, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (145, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (146, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (147, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (148, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (149, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (150, 2, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.2', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (151, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (152, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (153, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (154, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (155, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (156, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (157, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (158, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (159, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (160, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (161, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (162, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (163, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (164, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (165, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (166, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (167, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (168, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (169, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (170, 22, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.22', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (171, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (172, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (173, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (174, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (175, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (176, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (177, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (178, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (179, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (180, 12, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.12', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (181, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (182, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (183, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (184, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (185, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (186, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (187, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (188, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (189, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (190, 30, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.30', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (191, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (192, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (193, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (194, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (195, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (196, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (197, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (198, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (199, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 2, 1, N'Imagen', 0)
GO
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (200, 15, CAST(N'2020-10-26T22:16:18.923' AS DateTime), N'198.162.15.15', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (201, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (202, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (203, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (204, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (205, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (206, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (207, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (208, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (209, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (210, 27, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.27', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (211, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (212, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (213, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (214, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (215, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (216, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (217, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (218, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (219, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (220, 2, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.2', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (221, 3, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.3', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (222, 3, CAST(N'2020-10-26T22:16:18.927' AS DateTime), N'198.162.15.3', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (223, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (224, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (225, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (226, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (227, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (228, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (229, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (230, 3, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.3', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (231, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (232, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (233, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (234, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (235, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (236, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (237, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (238, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (239, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (240, 15, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.15', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (241, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (242, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (243, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (244, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (245, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (246, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (247, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (248, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (249, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (250, 7, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.7', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (251, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (252, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (253, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (254, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (255, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (256, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (257, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (258, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (259, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (260, 20, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.20', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (261, 1, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.1', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (262, 1, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.1', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (263, 1, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.1', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (264, 1, CAST(N'2020-10-26T22:16:18.970' AS DateTime), N'198.162.15.1', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (265, 1, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.1', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (266, 1, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.1', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (267, 1, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.1', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (268, 1, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.1', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (269, 1, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.1', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (270, 1, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.1', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (271, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (272, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (273, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (274, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (275, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (276, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (277, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (278, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (279, 2, CAST(N'2020-10-26T22:16:18.997' AS DateTime), N'198.162.15.2', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (280, 2, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.2', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (281, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (282, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (283, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (284, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (285, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (286, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (287, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (288, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (289, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (290, 24, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.24', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (291, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (292, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (293, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (294, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (295, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (296, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (297, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (298, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (299, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 2, 3, N'Noticia', 0)
GO
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (300, 3, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.3', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (301, 19, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.19', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (302, 19, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.19', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (303, 19, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.19', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (304, 19, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.19', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (305, 19, CAST(N'2020-10-26T22:16:19.000' AS DateTime), N'198.162.15.19', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (306, 19, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.19', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (307, 19, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.19', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (308, 19, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.19', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (309, 19, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.19', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (310, 19, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.19', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (311, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (312, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (313, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (314, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (315, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (316, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (317, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (318, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (319, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (320, 25, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.25', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (321, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (322, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (323, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (324, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (325, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (326, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (327, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (328, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (329, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (330, 16, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.16', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (331, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (332, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (333, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (334, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (335, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (336, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (337, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (338, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (339, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (340, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (341, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (342, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (343, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (344, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (345, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (346, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (347, 23, CAST(N'2020-10-26T22:16:19.027' AS DateTime), N'198.162.15.23', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (348, 23, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.23', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (349, 23, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.23', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (350, 23, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.23', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (351, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (352, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (353, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (354, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (355, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (356, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (357, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (358, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (359, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (360, 30, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.30', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (361, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (362, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (363, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (364, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (365, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (366, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (367, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (368, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (369, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (370, 24, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.24', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (371, 2, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.2', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (372, 2, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.2', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (373, 2, CAST(N'2020-10-26T22:16:19.053' AS DateTime), N'198.162.15.2', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (374, 2, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.2', 3, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (375, 2, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.2', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (376, 2, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.2', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (377, 2, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (378, 2, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.2', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (379, 2, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.2', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (380, 2, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.2', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (381, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (382, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (383, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (384, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (385, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (386, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (387, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (388, 4, CAST(N'2020-10-26T22:16:19.057' AS DateTime), N'198.162.15.4', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (389, 4, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.4', 2, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (390, 4, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.4', 1, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (391, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 2, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (392, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (393, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (394, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 3, 2, N'Post', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (395, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 1, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (396, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 3, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (397, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 1, 1, N'Imagen', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (398, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 2, 3, N'Noticia', 0)
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (399, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 1, 1, N'Imagen', 0)
GO
INSERT [Interactions].[Publicacion] ([ID_Publicacion], [ID_Usuario], [Fecha], [IP_Address], [Tipo_Dispositivo], [Tipo_Publicacion], [Contenido], [Estado]) VALUES (400, 19, CAST(N'2020-10-26T22:16:19.087' AS DateTime), N'198.162.15.19', 2, 1, N'Imagen', 0)
SET IDENTITY_INSERT [Interactions].[Publicacion] OFF
GO
SET IDENTITY_INSERT [Interactions].[Tipo_Dispositivo] ON 

INSERT [Interactions].[Tipo_Dispositivo] ([ID_Tipo], [Nombre]) VALUES (1, N'PC')
INSERT [Interactions].[Tipo_Dispositivo] ([ID_Tipo], [Nombre]) VALUES (2, N'Smartphone')
INSERT [Interactions].[Tipo_Dispositivo] ([ID_Tipo], [Nombre]) VALUES (3, N'Tablet')
SET IDENTITY_INSERT [Interactions].[Tipo_Dispositivo] OFF
GO
SET IDENTITY_INSERT [Interactions].[Tipo_Publicacion] ON 

INSERT [Interactions].[Tipo_Publicacion] ([ID_Tipo], [Nombre]) VALUES (1, N'Imagen')
INSERT [Interactions].[Tipo_Publicacion] ([ID_Tipo], [Nombre]) VALUES (3, N'Noticia')
INSERT [Interactions].[Tipo_Publicacion] ([ID_Tipo], [Nombre]) VALUES (2, N'Post')
SET IDENTITY_INSERT [Interactions].[Tipo_Publicacion] OFF
GO
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (1, 2, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (1, 3, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (1, 4, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (1, 5, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (1, 6, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (1, 7, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (1, 8, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (2, 1, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (3, 1, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (4, 1, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (5, 1, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (6, 1, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (7, 1, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (8, 1, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (22, 23, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (23, 22, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (24, 27, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (24, 28, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (25, 26, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (26, 25, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (27, 24, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (27, 28, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (28, 24, CAST(N'2020-10-26' AS Date), NULL)
INSERT [Person].[Amigo] ([ID_Usuario], [ID_FR], [Fecha_Inicio_Amistad], [Fecha_Fin_Amistad]) VALUES (28, 27, CAST(N'2020-10-26' AS Date), NULL)
GO
SET IDENTITY_INSERT [Person].[Usuario] ON 

INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (1, N'Barrie', N'Haydon', N'Pembry', N'Dearnaly', N'hdearnaly0@weibo.com', 50, CAST(N'2001-05-17' AS Date), CAST(N'2020-10-26T22:04:16.920' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (2, N'Randolph', N'Griffy', N'Saggs', N'Nolte', N'gnolte1@google.cn', 50, CAST(N'1998-11-30' AS Date), CAST(N'2020-10-26T22:04:16.923' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (3, N'Gerri', N'Rinaldo', N'Tripony', N'Lippard', N'rlippard2@opensource.org', 50, CAST(N'1981-09-03' AS Date), CAST(N'2020-10-26T22:04:16.923' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (4, N'Galvin', N'Scotti', N'Libby', N'Morris', N'smorris3@free.fr', 50, CAST(N'1998-04-02' AS Date), CAST(N'2020-10-26T22:04:16.923' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (5, N'Goddart', N'Hinze', N'Berick', N'Setchfield', N'hsetchfield4@shinystat.com', 50, CAST(N'1989-01-19' AS Date), CAST(N'2020-10-26T22:04:16.923' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (6, N'Arni', N'Stacee', N'Eagling', N'Brownsea', N'sbrownsea5@youtu.be', 50, CAST(N'1996-10-18' AS Date), CAST(N'2020-10-26T22:04:16.923' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (7, N'Salem', N'Dore', N'Nurny', N'Bompas', N'dbompas6@bing.com', 50, CAST(N'1992-09-17' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (8, N'Fairleigh', N'Casper', N'Hully', N'Ashcroft', N'cashcroft7@fc2.com', 50, CAST(N'1994-02-22' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (9, N'Dannel', N'Dorey', N'Treven', N'Ponte', N'dponte8@xing.com', 50, CAST(N'1988-05-22' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (10, N'Gunar', N'Sayres', N'Physick', N'Preuvost', N'spreuvost9@tuttocitta.it', 50, CAST(N'1998-01-02' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (11, N'Wilden', N'Kareem', N'Boulsher', N'Downer', N'kdownera@t.co', 50, CAST(N'1984-06-04' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (12, N'Cameron', N'Reynard', N'Stolz', N'Austwick', N'raustwickb@myspace.com', 50, CAST(N'1985-07-11' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (13, N'Ringo', N'Waylen', N'Gunn', N'Quennell', N'wquennellc@discuz.net', 50, CAST(N'1983-12-12' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (14, N'Fidole', N'Kiel', N'Devorill', N'Bothams', N'kbothamsd@narod.ru', 50, CAST(N'1985-03-11' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (15, N'Cassie', N'Darrell', N'Hannah', N'Chetwynd', N'dchetwynde@slideshare.net', 50, CAST(N'1991-07-08' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (16, N'Arthur', N'Carlyle', N'Adlem', N'Coppens', N'ccoppensf@sphinn.com', 50, CAST(N'1985-11-07' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (17, N'Oby', N'Rip', N'Pettiford', N'Diggell', N'rdiggellg@hp.com', 50, CAST(N'1994-05-08' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (18, N'Leroy', N'Neville', N'Priver', N'Craigie', N'ncraigieh@wisc.edu', 50, CAST(N'1993-11-03' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (19, N'Trevor', N'Currie', N'Biasioni', N'DAvaux', N'cdavauxi@goodreads.com', 50, CAST(N'1997-12-09' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (20, N'Vassily', N'Darnall', N'Brayley', N'Thal', N'dthalj@ask.com', 50, CAST(N'1992-01-02' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (21, N'Ivan', N'Diego', N'Arango', N'Saucedo', N'ivand@gmail.com', 50, CAST(N'1998-05-05' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (22, N'Lester', N'Andres', N'Garcφa', N'Aquino', N'lester@gmail.com', 50, CAST(N'1998-05-05' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (23, N'Hector', N'Andres', N'Zetino', N'Aquino', N'hector@gmail.com', 50, CAST(N'1998-05-05' AS Date), CAST(N'2020-10-26T22:04:16.927' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (24, N'Pablo ', N'Javier', N'Garcia', N'Montenegro', N'pablo@gmail.com', 50, CAST(N'1998-07-27' AS Date), CAST(N'2020-10-26T22:04:16.930' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (25, N'Carlos', N'AndrΘs', N'Morales', N'Lara', N'carlos@gmail.com', 50, CAST(N'1998-05-05' AS Date), CAST(N'2020-10-26T22:04:16.930' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (26, N'Carlos', N'Javier', N'Morales', N'Lara', N'carlos1@gmail.com', 50, CAST(N'1998-05-05' AS Date), CAST(N'2020-10-26T22:04:16.930' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (27, N'Sebastian', N'Jared', N'Garcia', N'Zetino', N'sjgz@gmail.com', 50, CAST(N'1998-05-05' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (28, N'Sebastian', N'Jared', N'Garcia', N'Zetino', N'sjgz1@gmail.com', 50, CAST(N'1998-05-05' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (29, N'Jennifer', N'Sucely', N'Fletcher', N'Garcia', N'jensu@webtoon.com', 50, CAST(N'1996-06-15' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (30, N'Carlos', N'Andres', N'Rodriguez', N'Fernandez', N'carro@gmail.com', 50, CAST(N'1997-07-25' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (31, N'Andres', N'Jose', N'Bartmeiden', N'Artiaga', N'bartmeia@gmail.com', 50, CAST(N'1999-08-26' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (32, N'Ivan', N'Jose', N'Arreaga', N'Montes', N'ivam@gmail.com', 50, CAST(N'1994-02-09' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (33, N'Ricardo', N'Esteban', N'Sandoval', N'Mejia', N'resme@correo.com', 50, CAST(N'1995-07-05' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (34, N'Ivania', N'Esperanza', N'Ramirez', N'Meta', N'ivaespe@correo.url.com', 50, CAST(N'1999-07-08' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
INSERT [Person].[Usuario] ([ID_Usuario], [Primer_Nombre], [Segundo_Nombre], [Primer_Apellido], [Segundo_Apellido], [Correo_Electronico], [Total_Maximo_Amigos], [Fecha_Nacimiento], [Fecha_Creacion_Usuario], [Fecha_Fin_Usuario]) VALUES (35, N'Elena', N'Rocio', N'Lopez', N'Melgar', N'elerolo@correo.url.com', 50, CAST(N'1996-09-05' AS Date), CAST(N'2020-10-26T22:04:16.933' AS DateTime), NULL)
SET IDENTITY_INSERT [Person].[Usuario] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Tipo_Dis__75E3EFCFBCBB4649]    Script Date: 10/26/2020 10:41:27 PM ******/
ALTER TABLE [Interactions].[Tipo_Dispositivo] ADD UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Tipo_Pub__75E3EFCFB1070232]    Script Date: 10/26/2020 10:41:27 PM ******/
ALTER TABLE [Interactions].[Tipo_Publicacion] ADD UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Usuario__859478160AF60C8B]    Script Date: 10/26/2020 10:41:27 PM ******/
ALTER TABLE [Person].[Usuario] ADD UNIQUE NONCLUSTERED 
(
	[Correo_Electronico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Interactions].[Likes] ADD  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [Interactions].[Publicacion] ADD  DEFAULT ((0)) FOR [Estado]
GO
ALTER TABLE [Person].[Usuario] ADD  DEFAULT ((50)) FOR [Total_Maximo_Amigos]
GO
ALTER TABLE [Person].[Usuario] ADD  DEFAULT (getdate()) FOR [Fecha_Creacion_Usuario]
GO
ALTER TABLE [Person].[Usuario] ADD  DEFAULT (NULL) FOR [Fecha_Fin_Usuario]
GO
ALTER TABLE [Interactions].[Comentario]  WITH CHECK ADD FOREIGN KEY([ID_Amigo])
REFERENCES [Person].[Usuario] ([ID_Usuario])
GO
ALTER TABLE [Interactions].[Comentario]  WITH CHECK ADD FOREIGN KEY([ID_Publicacion])
REFERENCES [Interactions].[Publicacion] ([ID_Publicacion])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Interactions].[Likes]  WITH CHECK ADD FOREIGN KEY([ID_Amigo])
REFERENCES [Person].[Usuario] ([ID_Usuario])
GO
ALTER TABLE [Interactions].[Likes]  WITH CHECK ADD FOREIGN KEY([ID_Publicacion])
REFERENCES [Interactions].[Publicacion] ([ID_Publicacion])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Interactions].[Publicacion]  WITH CHECK ADD FOREIGN KEY([ID_Usuario])
REFERENCES [Person].[Usuario] ([ID_Usuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Interactions].[Publicacion]  WITH CHECK ADD FOREIGN KEY([Tipo_Publicacion])
REFERENCES [Interactions].[Tipo_Publicacion] ([ID_Tipo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Interactions].[Publicacion]  WITH CHECK ADD FOREIGN KEY([Tipo_Dispositivo])
REFERENCES [Interactions].[Tipo_Dispositivo] ([ID_Tipo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Person].[Amigo]  WITH CHECK ADD FOREIGN KEY([ID_FR])
REFERENCES [Person].[Usuario] ([ID_Usuario])
GO
ALTER TABLE [Person].[Amigo]  WITH CHECK ADD FOREIGN KEY([ID_Usuario])
REFERENCES [Person].[Usuario] ([ID_Usuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [Interactions].[Comentario]  WITH CHECK ADD  CONSTRAINT [Estado] CHECK  (([Estado]='Activo' OR [Estado]='Inactivo'))
GO
ALTER TABLE [Interactions].[Comentario] CHECK CONSTRAINT [Estado]
GO
ALTER TABLE [Interactions].[Likes]  WITH CHECK ADD  CONSTRAINT [TipoLike] CHECK  (([Tipo_Like]='Like' OR [Tipo_Like]='Dislike'))
GO
ALTER TABLE [Interactions].[Likes] CHECK CONSTRAINT [TipoLike]
GO
ALTER TABLE [Person].[Amigo]  WITH CHECK ADD  CONSTRAINT [CHK_Person] CHECK  (([ID_Usuario]<>[ID_FR]))
GO
ALTER TABLE [Person].[Amigo] CHECK CONSTRAINT [CHK_Person]
GO
ALTER TABLE [Person].[Usuario]  WITH CHECK ADD  CONSTRAINT [FECHAS] CHECK  (([Fecha_Fin_Usuario]>=[Fecha_Creacion_Usuario]))
GO
ALTER TABLE [Person].[Usuario] CHECK CONSTRAINT [FECHAS]
GO
ALTER TABLE [Person].[Usuario]  WITH CHECK ADD  CONSTRAINT [my_constraint] CHECK  (([Correo_Electronico] like '%___@___%'))
GO
ALTER TABLE [Person].[Usuario] CHECK CONSTRAINT [my_constraint]
GO
/****** Object:  StoredProcedure [dbo].[usp_Interacciones]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[usp_Interacciones]
@id_amigo int ,@id_publicacion int,@Tipo varchar(10)
as
set transaction isolation level serializable
begin tran
if(@@ERROR = 0)
begin
insert into Interactions.Likes(ID_Publicacion,Tipo_Like,fecha,ID_Amigo) values(@id_publicacion,@Tipo,GETDATE(),@id_amigo)
commit
end

else
begin
rollback
print 'Transaccion fallida.'
end
GO
/****** Object:  StoredProcedure [Interactions].[uspPublicaciones_ComentariosLlenos]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec Person.uspCrecimientoRango '2020-10-20'
--exec Person.uspCrecimiento null

--Número de publicaciones al mes, con el 100% de su capacidad de comentarios llena.
create   procedure [Interactions].[uspPublicaciones_ComentariosLlenos]
as
begin
select MONTH(GETDATE()) as [Mes del anio],P.ID_Publicacion as [Id_Publicacion], COUNT(C.ID_Comentario) as [Cantidad de Comentarios]
from Interactions.Publicacion P
	inner join Interactions.Comentario C on P.ID_Publicacion = C.ID_Publicacion
	group by P.ID_Publicacion
	having (COUNT(C.ID_Comentario) > 3)
end
GO
/****** Object:  StoredProcedure [Interactions].[uspPublicacionesAleatorias]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA GENERAR PUBLICACIONES ALEATORIAS
--RECIBE COMO PARAMETROS LA CANTIDAD DE USUARIOS M A LOS QUE SE QUIEREN GENERAR UNA CANTIDAD DE PUBLICACIONES N
create   procedure [Interactions].[uspPublicacionesAleatorias]
						@usuarios int,
						@publicaciones int
as
begin

	declare @contadorUs int,
			@contadorPub int,
			@id int,
			@ip nvarchar(20),
			@tipoDisp nvarchar(20),
			@tipoPub int,
			@nombreTipoPub nvarchar(20),
			@cantTipoDispExisten int,
			@cantTipoPubExisten int

	set @ip = '198.162.15.'

	--SE DECLARA EL NIVEL DE AISLAMIENTO
	set transaction isolation level read committed
	begin tran

	--SI SE LLEGA A INGRESAR UN VALOR NULO O MENOR O IGUAL A 0 SE LE ASIGNA UN VALOR ALEATORIO ENTRE 1 Y LA CANTIDAD DE USUARIOS MAXIMA QUE EXISTE
	if(@usuarios is null or @usuarios <= 0)
	begin
		declare @cantidadUsuariosExisten int
		select @cantidadUsuariosExisten = count(1) from Person.Usuario

		set @usuarios = FLOOR(RAND()*(@cantidadUsuariosExisten-1+1)+1)
	end
	else --SE VALIDA QUE LA CANTIDAD DE USUARIOS INGRESADOS SEA MENOR O IGUA A LA CANTIDAD DE USUARIOS QUE EXISTEN 
	begin
		--SI LA CANTIDAD DE USUARIOS INGRESADOS ES MAYOR A LA CANTIDAD DE USUARIOS QUE EXISTEN ACTUALMENTE, ENTONCES SE IGUALA A LA CANTIDAD EXISTENTE
		if(@usuarios > (select count(1) from Person.Usuario))
		begin
			select @usuarios = count(1) from Person.Usuario
		end
	end

	--SI SE INGRESA UN VALOR DE PUBLICACIONES NULO O MENOR O IGUAL A 0 SE LE ASIGNAR UN VALOR ALEATORIO ENTRE 1 Y 500
	if(@publicaciones is null or @publicaciones  <= 0)
	begin
		declare @cantidadPublicaciones int

		set @cantidadPublicaciones = FLOOR(RAND()*(500-1+1)+1)
	end

	--LUEGO DE HABER REALIZADO TODAS LAS VALIDACIONES POSIBLES, SE CONTINÚA CON LA CREACION DE PUBLICACIONES
	set @contadorUs = @usuarios
	select @cantTipoDispExisten = count(1) from Interactions.Tipo_Dispositivo
	select @cantTipoPubExisten = count(1) from Interactions.Tipo_Publicacion

	while (@contadorUs > 0)
	begin
		set @id = FLOOR(RAND()*(@usuarios-1+1)+1)

		if exists(select * from Person.Usuario where ID_Usuario = @id)
		begin
			--select ID_Usuario from Person.Usuario where ID_Usuario = @id
			set @contadorPub = @publicaciones

			while(@contadorPub > 0)
			begin
				set @tipoDisp = FLOOR(RAND()*(@cantTipoDispExisten-1+1)+1)
				set @tipoPub = FLOOR(RAND()*(@cantTipoPubExisten-1+1)+1)
				
				if exists(select Nombre from Tipo_Publicacion)
				begin
					select @nombreTipoPub = Nombre from Tipo_Publicacion where ID_Tipo = @tipoPub
				end
				else
				begin
					set @nombreTipoPub = 'Aleatoria'
				end

				insert into Interactions.Publicacion(ID_Usuario, Fecha, IP_Address, Tipo_Dispositivo, Tipo_Publicacion, Contenido, Estado)
				values(@id, GETDATE(), @ip + CONVERT(nvarchar(10), @id), @tipoDisp, @tipoPub, @nombreTipoPub, 0)

				set @contadorPub -= 1
			end
			
			set @contadorUs -= 1
		end
	end

	if(@@ERROR = 0)
	begin
		print 'PUBLICACIONES REALIZADAS'
		commit
	end
	else
	begin
		print 'ERROR DE PROCEDIMIENTO PARA GENERAR PUBLICACIONES ALEATORIAS'

		declare @ultimaPublicacion int
		select @ultimaPublicacion = MAX(ID_Publicacion) from Interactions.Publicacion

		dbcc checkident('Interactions.Publicacion', reseed, @ultimaPublicacion)
		rollback
	end

end
GO
/****** Object:  StoredProcedure [Interactions].[uspPublicacionesImpacto]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Detalle de publicaciones que en algún momento impactaron en el incremento de la cantidad máxima de amigos para un usuario.
create   procedure [Interactions].[uspPublicacionesImpacto]
as
begin
select P.ID_Publicacion ,P.ID_Usuario, P.Contenido, COUNT(Tipo_Like) as 'Total Likes'
from Interactions.Publicacion P
	inner join Interactions.Likes L on (P.ID_Publicacion = L.ID_Publicacion and P.Estado = 1)
	group by P.ID_Publicacion ,P.ID_Usuario, P.Contenido
	having COUNT(Tipo_Like) >= 15
end
GO
/****** Object:  StoredProcedure [Person].[usp_MaxAmigos]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************PROCEDIMIENTOS**********************************************************************


--PROCEDIMIENTO QUE LLENA EL NUMERO DE AMIGOS MAXIMO QUE PUEDE TENER CADA USUARIO
create   procedure [Person].[usp_MaxAmigos]
			@fecha datetime
as
begin

	declare @totalAmigos int,
			@id_pub int, 
			@n_likes int,
			@id_usuario int,
			@fechaActual datetime,
			@anio int,
			@mes int,
			@dia int,
			@hora int,
			@minuto int

	set @fechaActual = GETDATE()
	set	@anio = year(@fechaActual)
	set @mes = MONTH(@fechaActual)
	set @dia = DAY(@fechaActual)
	set @hora = DATEPART(HOUR, @fechaActual)
	set @minuto = DATEPART(MINUTE, @fechaActual)

	if(@anio = year(@fecha) and @mes = month(@fecha) and @dia = day(@fecha) and @hora = DATEPART(HOUR, @fecha) and @minuto = DATEPART(MINUTE, @fecha))
	begin
		--Se crea temporal en la que se filtra que la publicacion tenga un minimo de 15 likes, que la publicacion tengo como estado 0 que significa que esta publicacion no ha tenido un impacto en el crecimiento del maximo de amigos del usuario, ya que no tiene sentido que se actualice a cada rato una publicacion que ya se analizo previamente.
		--Y que filtre cuando solo sean likes y que sean las publicaciones de este usuario
		select P.ID_Publicacion , COUNT(Tipo_Like) as 'Total Likes',P.ID_Usuario,p.Estado
		into Person.PublicacionUsuario2  from Interactions.Publicacion P
		inner join Interactions.Likes L on (P.ID_Publicacion = L.ID_Publicacion and p.Estado = 0)
		group by P.ID_Publicacion ,P.ID_Usuario,p.Estado
		having COUNT(Tipo_Like) >= 15

		declare @estado int
		declare CursorActualizarAmigos cursor
		for select ID_Publicacion,[Total Likes],ID_Usuario,Estado from Person.PublicacionUsuario2 
		open CursorActualizarAmigos
		fetch NEXT FROM CursorActualizarAmigos into @id_pub,@n_likes, @id_usuario,@estado
		while(@@FETCH_STATUS = 0)
		begin
						
			if(@estado = 0)
			begin
				select	@totalAmigos = Total_Maximo_Amigos from Person.Usuario where ID_Usuario = @id_usuario
				set @totalAmigos = @totalAmigos +1
				update Person.Usuario set Total_Maximo_Amigos = @totalAmigos where ID_Usuario = @id_usuario
				update Interactions.Publicacion set Estado = 1 where ID_Publicacion = @id_pub
			end

			fetch NEXT FROM CursorActualizarAmigos into @id_pub,@n_likes, @id_usuario,@estado
		end
		close CursorActualizarAmigos
		Deallocate CursorActualizarAmigos

				
		drop table Person.PublicacionUsuario2

	end
end
GO
/****** Object:  StoredProcedure [Person].[uspCrecimientoRango]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Informes diarios

--PROCEDIMIENTO PARA NUMERO DE USUARIOS NUEVOS ENTRE HOY Y UNA FECHA ESTABLECIDA
create   procedure [Person].[uspCrecimientoRango]
				@fechaAntes date
as
begin
	declare @usuariosAntiguos float,
			@usuariosNuevos float,
			@crecimiento float

	if(@fechaAntes is null)
	begin
		set @fechaAntes = DATEADD(day, -1, getdate())
	end

	select @usuariosAntiguos = count(distinct ID_Usuario)
	from Person.Usuario
	where convert(date,Fecha_Creacion_Usuario) <= convert(date, @fechaAntes) and Fecha_Fin_Usuario is NULL

	select @usuariosNuevos = count(distinct ID_Usuario)
	from Person.Usuario
	where convert(date,Fecha_Creacion_Usuario) > convert(date, @fechaAntes) and Fecha_Fin_Usuario is NULL

	set @crecimiento = @usuariosNuevos/ @usuariosAntiguos

	select count(distinct ID_Usuario) [Total Usuarios], @usuariosNuevos [Usuarios Nuevos], convert(decimal(5,2), @crecimiento) [Crecimiento] 
	from Person.Usuario
end
GO
/****** Object:  StoredProcedure [Person].[uspIngresarUsuario]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PROCEDIMIENTO PARA INSERTAR UN USUARIO INDIVIDUALMENTE
create   procedure [Person].[uspIngresarUsuario]
						@PNombre nvarchar(20),
						@SNombre nvarchar(20),
						@PApellido nvarchar(20),
						@SApellido nvarchar(20),
						@Correo nvarchar(50),
						@MaxAmigos int,
						@FechaNac date,
						@Creacion date,
						@Fin date
as
begin
	begin tran

	--SE CREA UNA CONDICION PARA CADA POSIBILIDAD DE LOS DATOS QUE PUEDEN SER NULL O SE PUEDEN INSERTAR SIN NECESIDAD DE TENER UN VALOR
	if(@MaxAmigos is null and @Creacion is null and @Fin is null)
	begin
		insert into Person.Usuario(Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Correo_Electronico, Fecha_Nacimiento)
		values(@PNombre, @SNombre, @PApellido, @SApellido, @Correo, @FechaNac)
	end
	else if(@Creacion is null and @Fin is null)
	begin
		insert into Person.Usuario(Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Correo_Electronico, Total_Maximo_Amigos, Fecha_Nacimiento)
		values(@PNombre, @SNombre, @PApellido, @SApellido, @Correo, @MaxAmigos, @FechaNac)
	end
	else if(@MaxAmigos is null)
	begin
		insert into Person.Usuario(Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Correo_Electronico, Fecha_Nacimiento, Fecha_Creacion_Usuario, Fecha_Fin_Usuario)
		values(@PNombre, @SNombre, @PApellido, @SApellido, @Correo, @FechaNac, @Creacion, @Fin)
	end
	else if(@Fin is null)
	begin
		insert into Person.Usuario(Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Correo_Electronico, Total_Maximo_Amigos, Fecha_Nacimiento, Fecha_Creacion_Usuario)
		values(@PNombre, @SNombre, @PApellido, @SApellido, @Correo, @MaxAmigos, @FechaNac, @Creacion)
	end
	else
	begin
		insert into Person.Usuario(Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Correo_Electronico, Total_Maximo_Amigos, Fecha_Nacimiento, Fecha_Creacion_Usuario, Fecha_Fin_Usuario)
		values(@PNombre, @SNombre, @PApellido, @SApellido, @Correo, @MaxAmigos, @FechaNac, @Creacion, @Fin)
	end

	if(@@ERROR = 0)
		begin
			commit
		end
	else
		begin
			print 'ERROR DE PROCEDIMIENTO DE INSERCION INDIVIDUAL'
			rollback
		end

end
GO
/****** Object:  StoredProcedure [Person].[uspIngresarUsuariosMasivo]    Script Date: 10/26/2020 10:41:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [Person].[uspIngresarUsuariosMasivo]
as
begin
	begin tran

	--SE CREA LA TABLA TEMPORAL AL QUE SE CARGA LA INFORMACIÓN DE LOS USUARIO
	create table #temp_Usuarios
	(
		ID int,
		PrimerNombre nvarchar(20),
		SegundoNombre nvarchar(20),
		PrimerApellido nvarchar(20),
		SegundoApellido nvarchar(20),
		Correo nvarchar(50),
		Max_Amigos nvarchar(50),
		Nacimiento date,
		Creacion datetime,
		Final datetime
	)

	--SE REALIZA EL BULK INSERT PARA LA TABLA TEMPORAL
	bulk insert #temp_Usuarios
	from 'C:\Users\pabli\Desktop\Repositorios\Base de Datos II\Proyectos_BDII\Proyecto1_BOOKFACE\Ejemplo de Datos de Usuarios.csv'
	with
	(
		FORMAT = 'CSV'
	)

	--SE CREA UN CURSOR PARA QUE POR CADA REGISTRO DE LA TABLA TEMPORAL, SE REALICE UN INSERT EN LA TABLA DE USUARIOS
	--Y SE ACTIVEN LOS TRIGGERS DE INSERT.
	--*****************INICIO CURSOR**************
	declare @PNombre nvarchar(20),
			@SNombre nvarchar(20),
			@PApellido nvarchar(20),
			@SApellido nvarchar(20),
			@Correo nvarchar(50),
			@MaxAmigos int,
			@Fecha_Nacimiento date,
			@Creacion date,
			@Fin date

	declare Cursor_Inserts cursor for
		select PrimerNombre, SegundoNombre, PrimerApellido, SegundoApellido, Correo, Max_Amigos, Nacimiento, Creacion, Final
		from #temp_Usuarios

	open Cursor_Inserts
	fetch next from Cursor_Inserts into @PNombre, @SNombre, @PApellido, @SApellido, @Correo, @MaxAmigos, @Fecha_Nacimiento, @Creacion, @Fin
	while @@fetch_status = 0
		begin
			exec Person.uspIngresarUsuario @PNombre, @SNombre, @PApellido, @SApellido, @Correo, @MaxAmigos, @Fecha_Nacimiento, @Creacion, @Fin

			fetch next from Cursor_Inserts into @PNombre, @SNombre, @PApellido, @SApellido, @Correo, @MaxAmigos, @Fecha_Nacimiento, @Creacion, @Fin
		end

	close Cursor_Inserts
	deallocate Cursor_Inserts
	--********************FIN CURSOR**************

	--SI EXISTE ALGUN ERROR SE IMPRIME, DE LO CONTRARIO SE ENVIA UN MSJ DE USUARIOS INGRESADOS SIN ERROR
	if(@@ERROR = 0)
		begin
			--EN CASO QUE NO HAYA ERROR SE BOTA LA TABLA TEMPORAL Y SE HACE COMMIT A LA TRANSACCION
			drop table #temp_Usuarios
			print 'USUARIOS INGRESADOS'
			commit
		end
	else
		begin
			--EN CASO DE HABER ERROR SE IMPRIME UN MSJ DE ERROR Y ROLLBACK A LA TRANSACCION
			drop table #temp_Usuarios
			print 'ERROR DE PROCEDIMIENTO DE INSERCION MASIVA'
			rollback

			--SE REINICIA EL CONTADOR SEGUN LA CANTIDAD DE REGISTROS QUE YA EXISTIAN
			declare @ultimoID int
			select @ultimoID = MAX(ID_Usuario) from Person.Usuario --select @ultimoID = count(1) from Person.Usuario

			dbcc checkident('Person.Usuario', reseed, @ultimoID)
		end
end
GO
USE [master]
GO
ALTER DATABASE [BOOKFACE] SET  READ_WRITE 
GO

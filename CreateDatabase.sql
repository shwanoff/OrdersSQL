USE [master]
GO
/****** Object:  Database [OrdersDB]    Script Date: 26.09.2018 4:12:32 ******/
CREATE DATABASE [OrdersDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OrdersDB', FILENAME = N'C:\Users\admsh\OrdersDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'OrdersDB_log', FILENAME = N'C:\Users\admsh\OrdersDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [OrdersDB] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OrdersDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OrdersDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [OrdersDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [OrdersDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [OrdersDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [OrdersDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [OrdersDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OrdersDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OrdersDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OrdersDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OrdersDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [OrdersDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [OrdersDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OrdersDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [OrdersDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OrdersDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OrdersDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OrdersDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OrdersDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OrdersDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OrdersDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OrdersDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OrdersDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OrdersDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [OrdersDB] SET  MULTI_USER 
GO
ALTER DATABASE [OrdersDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [OrdersDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OrdersDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OrdersDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [OrdersDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [OrdersDB] SET QUERY_STORE = OFF
GO
USE [OrdersDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [OrdersDB]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 26.09.2018 4:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[client_id] [int] IDENTITY(1,1) NOT NULL,
	[client_name] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[client_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 26.09.2018 4:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[client_id] [int] NOT NULL,
	[order_sum] [money] NOT NULL,
	[order__date] [datetime] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Clients] FOREIGN KEY([client_id])
REFERENCES [dbo].[Clients] ([client_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Clients]
GO
/****** Object:  StoredProcedure [dbo].[GetClientSingleOrder]    Script Date: 26.09.2018 4:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetClientSingleOrder]
AS
BEGIN
	SELECT DISTINCT dbo.Clients.client_name
	FROM dbo.Clients 
	INNER JOIN dbo.Orders ON dbo.Clients.client_id = dbo.Orders.client_id
	WHERE dbo.Orders.order_sum > 50
END
GO
/****** Object:  StoredProcedure [dbo].[GetClientSumOrder]    Script Date: 26.09.2018 4:12:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetClientSumOrder]
AS
BEGIN
	SELECT dbo.Clients.client_name
	FROM dbo.Orders 
	INNER JOIN dbo.Clients ON dbo.Orders.client_id = dbo.Clients.client_id
	GROUP BY dbo.Clients.client_name
	HAVING SUM(dbo.Orders.order_sum) > 100
END
GO
USE [master]
GO
ALTER DATABASE [OrdersDB] SET  READ_WRITE 
GO

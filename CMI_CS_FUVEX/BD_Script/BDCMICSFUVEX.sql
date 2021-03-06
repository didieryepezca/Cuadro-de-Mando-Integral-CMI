USE [master]
GO
/****** Object:  Database [CMI_CS_FUVEX]    Script Date: 7/09/2020 14:04:44 ******/
CREATE DATABASE [CMI_CS_FUVEX]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CMI_CS_FUVEX', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\CMI_CS_FUVEX.mdf' , SIZE = 153600KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CMI_CS_FUVEX_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\CMI_CS_FUVEX_log.ldf' , SIZE = 13217792KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CMI_CS_FUVEX].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CMI_CS_FUVEX] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET ARITHABORT OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET RECOVERY FULL 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET  MULTI_USER 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CMI_CS_FUVEX] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CMI_CS_FUVEX] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [CMI_CS_FUVEX]
GO
/****** Object:  User [OPPLUS\tc1labs]    Script Date: 7/09/2020 14:04:44 ******/
CREATE USER [OPPLUS\tc1labs] FOR LOGIN [OPPLUS\tc1labs] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [OPPLUS\repl_sql]    Script Date: 7/09/2020 14:04:44 ******/
CREATE USER [OPPLUS\repl_sql] FOR LOGIN [OPPLUS\repl_sql] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [OPPLUS\tc1labs]
GO
ALTER ROLE [db_owner] ADD MEMBER [OPPLUS\repl_sql]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMI_CSFUVEX_TODO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 27.07.2020
-- Description:	Stored Procedure Global para sacar todo el CMI de contratacion Sencilla y FUVEX
-- ============================================================================================
CREATE PROCEDURE [dbo].[USP_CMI_CSFUVEX_TODO] 
	(@MES INT, @AÑO INT)

AS

BEGIN
	
DECLARE @FECHA_FIN DATE;

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
				  WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)


---PRINT @FECHA_FIN	

------*****************************************CONTRATACION SENCILLA*************************************************************
-----------------------------------------------------------------------------------------//
EXEC [dbo].[USP_PLD_TC_CONVENIO_RESUMEN_MENSUAL] @MES,@AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD'
EXEC [dbo].[USP_PLD_TC_CONVENIO_RESUMEN_MENSUAL] @MES,@AÑO,'TARJETA DE CREDITO'
EXEC [dbo].[USP_PLD_TC_CONVENIO_RESUMEN_MENSUAL] @MES,@AÑO,'CONVENIO'
----//Tablero del Resumen + % REPROCESOS-DIA + detalle, % FORMALIZACION, datos de tabla pestaña CALIDAD, 
----//PESTAÑA CONTROL: GRAFICOS(Porcentaje Acumulado, Porcentaje de Reproceso Mensual)
----// >> 12 Segundos
---->>SELECT * FROM PLD_TC_CONVENIO 
---->>SELECT * FROM PLD_TC_CONVENIO_DETALLE
---->> tambien se ejecuta EXEC USP_PLD_TC_CONVENIO_CALIDAD @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_CALIDAD
-----------------------------------------------------------------------------------------// 
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS] @MES,@AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS] @MES,@AÑO,'TARJETA DE CREDITO'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS] @MES,@AÑO,'CONVENIO'
----//Tablero del Resumen TIEMPO-OFERTA-APROBADA-UTILES-LAB + detalle, TIEMPO-OFERTA-REGULAR-UTILES-LAB + detalle,
----//PESTAÑA CONTROL: GRAFICOS(Porcentaje Acumulado, Porcentaje de Reproceso Mensual)	
----// >> 10 - 15 Minutos  
---->>SELECT * FROM TB_CS_PERCENTIL
---->>SELECT * FROM PLD_TC_CONVENIO_DETALLE_TIEMPOS
---->>SELECT * FROM PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA 
--->>>>>> FN_CALCULAR_DESEMBOLSO : devuelve la fecha en la que el expediente se registro // Cambie por INNER JOINS 01/08/2020

-----------------------------------------------------------------------------//Se debe cargar el consolidado FULL para sacar los montos
EXEC [dbo].[USP_PLD_TC_CONVENIO_OPERACIONES_MENSUAL] @MES,@AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD'
EXEC [dbo].[USP_PLD_TC_CONVENIO_OPERACIONES_MENSUAL] @MES,@AÑO,'TARJETA DE CREDITO'
EXEC [dbo].[USP_PLD_TC_CONVENIO_OPERACIONES_MENSUAL] @MES,@AÑO,'CONVENIO'
----//PESTAÑA OPERACIONES: *********************** LA MISMA LOGICA PARA LOS MONTOS MENSUALES DEL HISTORICO
----// >> 0 - 5 Segundos
---->>SELECT * FROM PLD_TC_CONVENIO_OPERACIONES
---->>SELECT * FROM PLD_TC_CONVENIO_OPERACIONES_ANUAL // Tambien calcula el anual
---->>SELECT * FROM PLD_TC_CONVENIO_OPERACIONES_GRAPH
 
-----------------------------------------------------------------------------------------//
EXEC [USP_PLD_TC_CONVENIO_OPERACIONES_DESGLOSE] @MES,@AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD'
EXEC [USP_PLD_TC_CONVENIO_OPERACIONES_DESGLOSE] @MES,@AÑO,'TARJETA DE CREDITO'
EXEC [USP_PLD_TC_CONVENIO_OPERACIONES_DESGLOSE] @MES,@AÑO,'CONVENIO'
----//PESTAÑA OPERACIONES: Tablita Desglose de Operaciones
----// >> 0 - 5 Segundos
---->>SELECT * FROM PLD_TC_CONVENIO_OPERACIONES_DESGLOSE

-----------------------------------------------------------------------------------------// PERCENTILES CORREGIDOS PA SIEMPRE XD
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA] @MES,@AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA] @MES,@AÑO,'TARJETA DE CREDITO'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA] @MES,@AÑO,'CONVENIO'
----//PESTAÑA CONTROL: TIEMPOS DE ATENCION POR BANDEJA(Grafico Tiempo de Atencion por Bandeja)
---->>SELECT * FROM TB_CS_PERCENTIL_BANDEJA
---->> 0 segundos

EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES] @MES,@AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD','APROBADO'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES] @MES,@AÑO,'TARJETA DE CREDITO','APROBADO'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES] @MES,@AÑO,'CONVENIO','APROBADO'

EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES] @MES,@AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD','REGULAR'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES] @MES,@AÑO,'TARJETA DE CREDITO', 'REGULAR'
EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES] @MES,@AÑO,'CONVENIO','REGULAR'
----//PESTAÑA CONTROL: TIEMPOS DE ATENCION POR BANDEJA(Grafico Tiempo Oferta Aprobada y Tiempo Oferta Regular)
---->>SELECT * FROM TB_CS_PERCENTIL_BANDEJA WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND FECHA = @FECHA_FIN
---->>AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA+' MES'
---->> 3 segundos
-----------------------------------------------------------------------------------------// PERCENTILES CORREGIDOS PA SIEMPRE XD

EXEC [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_FECHAS] @MES, @AÑO
----//PESTAÑA CONTROL GRAFICOS: Tiempos Atención // Tiempos/Perfil Oferta Aprobada // Tiempos/Perfil Oferta Regular
---->>SELECT * TB_CS_PERCENTIL_PERFIL_BANDEJA
---->> 05 segundos

-----------------------------------------------------------------------------------------//
EXEC USP_PLD_TC_CONVENIO_HISTOGRAMAS_CS 'TC_HISTORAL_LAB_MAX', @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_HISTORAL_LAB_MAX
---->> 0 Segundos
--->>>>>> FN_CALCULAR_DESEMBOLSO : devuelve la fecha en la que el expediente se registro // Cambie por INNER JOINS 01/08/2020

EXEC USP_PLD_TC_CONVENIO_HISTOGRAMAS_CS 'TC_HISTORAL_LAB', @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_HISTORAL_LAB
---->>SELECT * FROM PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH
---->> 5 Segundos
----//PESTAÑA CONTROL: Grafico Histograma de Formalizacion de Prestamo

EXEC USP_PLD_TC_CONVENIO_HISTOGRAMAS_CS_OFERTA 'TC_HISTORAL_LAB', @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH WHERE TIPO IN ('APROBADO','REGULAR')
---->>SELECT * FROM PLD_TC_CONVENIO_REPROCESOS_GRAPH
---->> 1 Segundo
----//PESTAÑA CONTROL: Grafico Histograma Desembolso Oferta Aprobada / Histograma Desembolso Oferta Regular 
----//PESTAÑA CONTROL: Grafico Porcentaje de Reproceso - Diario / Numero de Reprocesos - Diario


EXEC USP_PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS
---->> 1 Segundos
----//PESTAÑA CONTROL: Grafico Histograma de Reprocesos

EXEC USP_PLD_TC_CONVENIO_REPROCESOS_ACUM 'MENSUAL' , @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM
---->>SELECT * FROM PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH
---->> 1 Segundos
----//PESTAÑA CONTROL: Grafico Numero de Reprocesos - Acumulado *** Salen los graficos: Numero de Reprocesos - Acumulado (3 meses)

EXEC USP_TB_CS_CANTIDAD_REPROCESO  @MES, @AÑO, 'DIARIO'
---->>SELECT * FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
---->>SELECT * FROM TB_CS_CANT_REPROCESO_TB_DINAMICA
---->> 03 Minutos
----//PESTAÑA CONTROL: Tabla Dinamica de final
-----------------------------------------------------------------------------------------//
EXEC [dbo].[USP_RS_ACUMULADO] @MES, @AÑO, 'Acumulado'
----//PESTAÑA ACUMULADO : Tabla
---->>SELECT * FROM PLD_TC_CONVENIO_RS_ACUMULADO

------***********************************************FUVEX******************************************************************************
-----------------------------------------------------------------------------------------//
EXEC USP_TB_FUVEX_CANT_OPER_DIARIO @MES, @AÑO
---->>SELECT * FROM TB_FUVEX_RO
---->>SELECT * FROM PLD_TC_CONVENIO WHERE descripcion = 'PORCENTAJE DE REPROCESOS GLOBAL' (PORCENTAJE DE REPROCESOS GLOBAL del RESUMEN CS)
---->> 2 Segundos


EXEC USP_PLD_TC_CONVENIO_PRODUC_GRAPH @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH
----//PESTAÑA PRODUCTIVIDAD: Graficos: Tiempo de Formalizacion Dias Laborales // Tiempo Desembolso Mensual
---->> 2 Segundos


EXEC [dbo].[USP_PLD_TC_CONVENIO_FUNNEL_ACUMULADO] @MES, @AÑO, 'SIN DETALLE'
---->>SELECT * FROM PLD_TC_CONVENIO_FUNNEL_ACUMULADO
----//PESTAÑA PRODUCTIVIDAD -> Opcion Funnel de Operaciones: Graficos Funnel de Operaciones
---->> Tablitas del Funnel de Operaciones :
---->>SELECT * FROM [dbo].[FDIFERENCIAS]
---->>SELECT * FROM [dbo].[FPERFIL_RECHAZO]
---->>SELECT * FROM [dbo].[FMOTIVO]
---->> 4 Segundos

EXEC USP_PLD_TC_CONVENIO_SEGOPERACIONES_PROD @MES, @AÑO
---->>SELECT * FROM PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES
---->>SELECT * FROM PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA
----//PESTAÑA PRODUCTIVIDAD -> Graficos de barra: Tuberia de Contratacion Sencilla y Tablas de Tuberia Seguimiento Operaciones
---->> 2 Minutos
--------------------------------------------------------/// INDICADORES FINALES DE FUVEX DEL TABLERO DEL RESUMEN
EXEC USP_TB_FUVEX_PERCENTIL_FECHAS @MES, @AÑO, 'GLOBAL'
---->>SELECT * FROM TB_FUVEX_PERCENTIL
---->>Saca indicadores de a continuacion para el tablero del Resumen Principal
---->>SELECT * FROM PLD_TC_CONVENIO WHERE descripcion in ('TIEMPO DE FORMALIZACION OF. APROBADA','TIEMPO DE FORMALIZACION OF. REGULAR')
---->> , 'PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA') de PLD y TC
---->> 9 Segundos


EXEC USP_TB_FUVEX_CANTIDAD_DEVUELTO @MES, @AÑO, 'TOTAL'
---->>Saca indicadores de a continuacion para el tablero del Resumen Principal
---->>SELECT * FROM PLD_TC_CONVENIO WHERE descripcion = 'PORCENTAJE REPROCESOS FUVEX'
---->> 5 Segundos


EXEC USP_TB_FUVEX_FUNNEL @MES, @AÑO,'PLD'
EXEC USP_TB_FUVEX_FUNNEL @MES, @AÑO,'TC'
---->>Saca indicadores de para los Funnel de Fuvex
---->>SELECT * FROM TB_FUVEX_FUNNEL

EXEC USP_TB_FUVEX_FUNNEL_ACUMULADO @MES, @AÑO, 'PLD'
EXEC USP_TB_FUVEX_FUNNEL_ACUMULADO @MES, @AÑO, 'TC'
---->>Saca indicadores de a continuacion para el tablero del Resumen Principal
---->>SELECT * FROM PLD_TC_CONVENIO where descripcion = 'PORCENTAJE EN LA FORMALIZACION FUNNEL'
---->> 1 Segundo

------***********************************************GIFOLE******************************************************************************

EXEC [dbo].[USP_TC_GIFOLE_TIEMPOS]  @MES, @AÑO
------>>>SELECT * FROM TB_CS_TC_GIFOLE_PERCENTIL
------>>> PERCENTILES 90 PARA EL TABLERO DEL RESUMEN PRINCIPAL

EXEC USP_TC_GIFOLE_RESUMEN_MENSUAL @MES, @AÑO
------>>>SELECT * FROM PLD_TC_CONVENIO WHERE DESCRIPCION_ESTADO IN // Indicadores: 
------>>>>TIEMPO DE FORMALIZACION TC GIFOLE, % RECHAZO TITULARES, % RECHAZO ADICIONALES, CUMPLIMIENTO DE ANS - EFECTIVIDAD - GIFOLE	
------>>>>EXITO EN LA FORMALIZACION DE OP. GIFOLE	

---------------------// PESTAÑA OPERACIONES: SOLO EN TARJETA DE CREDITO
EXEC USP_TC_OPERACIONES_GIFOLE @MES, @AÑO
------>>>SELECT * FROM TC_GIFOLE_OPERACIONES

EXEC USP_TC_OPERACIONES_DESGLOSE_GIFOLE @MES, @AÑO
------>>>SELECT * FROM TC_GIFOLE_OPERACIONES_DESGLOSE

EXEC [dbo].[USP_TB_GIFOLE_FUNNEL] @MES, @AÑO
------>>>SELECT * FROM TB_GIFOLE_FUNNEL

------------------------------------->> Mail de confirmacion de indicadores
EXEC [dbo].[USP_CONFIRMAR_CMICSFUVEX] @MES, @AÑO
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIRMAR_CMICSFUVEX]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 26/07/2020
-- Description:	Procedure que envia mail para confirmar que todo el cmi fue alimentado...
-- =======================================================================================
CREATE PROCEDURE [dbo].[USP_CONFIRMAR_CMICSFUVEX] (@MES INT, @AÑO INT)

AS


BEGIN

DECLARE @body_mail nVARCHAR(max)='0';
DECLARE @subject_mail VARCHAR(max);
DECLARE @adjunto varchar(max) = '';

DECLARE @fecha_proceso DATE;
SET @fecha_proceso = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)
--DECLARE @MES VARCHAR(max)
--DECLARE @DIA VARCHAR(max)
--DECLARE @AÑO VARCHAR(max) 

--SET @MES=CONVERT(int,LEFT(RIGHT(@FECHA,4),2))
--SET @AÑO =CONVERT(int,'20'+LEFT(@FECHA,2))
--SET @DIA =CONVERT(int,RIGHT(@FECHA,2))


SET @body_mail =  '
<html>
<head>
    <meta name="viewport" content="width=device-width" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Comprobantes</title>
    <style>
          /* -------------------------------------
            GLOBAL RESETS
        ------------------------------------- */
          img {
             border: none;
              -ms-interpolation-mode: bicubic;
              max-width: 100%;
          }

          body {
              background-color: #EFEEED;
              font-family: sans-serif;
              -webkit-font-smoothing: antialiased;
              font-size: 14px;
              line-height: 1.4;
              margin: 0;
              padding: 0;
              -ms-text-size-adjust: 100%;
              -webkit-text-size-adjust: 100%;
          }


          table {
              border-collapse: separate;
              mso-table-lspace: 0pt;
              mso-table-rspace: 0pt;
              width: 100%;
          }

              table td {
                  font-family: sans-serif;
                  font-size: 14px;
                  vertical-align: top;
              }

          /* -------------------------------------
            BODY & CONTAINER
        ------------------------------------- */

          .body {
              background-color: #EFEEED;
              width: 100%;
          }

          /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */
          .container {
              display: block;
              Margin: 0 auto !important;
              /* makes it centered */
              max-width: 580px;
              padding: 10px;
              width: 580px;
          }

          /* This should also be a block element, so that it will fill 100% of the .container */
          .content {
              box-sizing: border-box;
              display: block;
              Margin: 0 auto;
              max-width: 580px;
              padding: 10px;
          }

          /* -------------------------------------
            HEADER, FOOTER, MAIN
        ------------------------------------- */
          .main {
              background: #ffffff;
              border-radius: 3px;
              width: 100%;
          }

          .wrapper {
              box-sizing: border-box;
              padding: 20px;
          }

          .content-block {
              padding-bottom: 10px;
              padding-top: 10px;
          }


          .footer_1 {
              clear: both;
              text-align: center;
              width: 100%;
              background: #007CC5;
          }

              .footer_1 td,
              .footer_1 p,
              .footer_1 span,
              .footer_1 a {
                  color: #ffffff;
                  font-size: 12px;
                  text-align: center;
              }



          .footer_2 {
              clear: both;
              text-align: center;
              width: 100%;
              background: #00509D;
          }

              .footer_2 td,
              .footer_2 p,
              .footer_2 span,
              .footer_2 a {
                  color: #ffffff;
                  font-size: 12px;
                  text-align: center;
                  text-decoration: none;
              }



          .footer {
              clear: both;
              text-align: center;
              width: 100%;
              background: #F4F4F4;
          }

              .footer td,
              .footer p,
              .footer span,
              .footer a {
                  color: #999999;
                  font-size: 12px;
                  text-align: center;
              }

          /* -------------------------------------
            TYPOGRAPHY
        ------------------------------------- */
          h1,
          h2,
          h3,
          h4 {
              color: #00509D;
              font-family: sans-serif;
              font-weight: 400;
              line-height: 1.4;
              margin: 0;
              Margin-bottom: 30px;
          }

          h1 {
              font-size: 35px;
              font-weight: 300;
              text-transform: capitalize;
          }

          p,
          ul,
          ol {
              font-family: sans-serif;
              font-size: 14px;
              font-weight: normal;
              margin: 0;
              Margin-bottom: 15px;
              color: #00509D;
          }

              p li,
              ul li,
              ol li {
                  list-style-position: inside;
                  margin-left: 5px;
              }

          a {
              color: #3498db;
              text-decoration: underline;
          }

          /* -------------------------------------
            BUTTONS
        ------------------------------------- */
          .btn {
              box-sizing: border-box;
              width: 100%;
          }

              .btn > tbody > tr > td {
                  padding-bottom: 15px;
              }

              .btn table {
                  width: auto;
              }

                  .btn table td {
                      background-color: #ffffff;
                      border-radius: 5px;
                      text-align: center;
                  }

              .btn a {
                  background-color: #ffffff;
                  border: solid 1px #3498db;
                  border-radius: 5px;
                  box-sizing: border-box;
                  color: #3498db;
                  cursor: pointer;
                  display: inline-block;
                  font-size: 14px;
                  font-weight: bold;
                  margin: 0;
                  padding: 12px 25px;
                  text-decoration: none;
                  text-transform: capitalize;
              }

          .btn-primary table td {
              background-color: #3498db;
          }

          .btn-primary a {
              background-color: #3498db;
              border-color: #3498db;
              color: #ffffff;
          }

          /* -------------------------------------
            OTHER STYLES THAT MIGHT BE USEFUL
        ------------------------------------- */
          .last {
              margin-bottom: 0;
          }

          .first {
   margin-top: 0;
          }

          .align-center {
              text-align: center;
          }

          .align-right {
              text-align: right;
          }

          .align-left {
              text-align: left;
          }

          .clear {
              clear: both;
          }

          .mt0 {
              margin-top: 0;
          }

          .mb0 {
              margin-bottom: 0;
          }

          .preheader {
              color: transparent;
              display: none;
              height: 0;
              max-height: 0;
              max-width: 0;
              opacity: 0;
              overflow: hidden;
              mso-hide: all;
              visibility: hidden;
              width: 0;
          }

          .powered-by a {
              text-decoration: none;
          }

          hr {
              border: 0;
              border-bottom: 1px solid #f6f6f6;
              Margin: 20px 0;
          }

          /* -------------------------------------
            RESPONSIVE AND MOBILE FRIENDLY STYLES
        ------------------------------------- */


      @media only screen and (max-width: 620px) {
        table[class=body] h1 {
          font-size: 28px !important;
          margin-bottom: 10px !important; }
        table[class=body] p,
        table[class=body] ul,
        table[class=body] ol,
        table[class=body] td,
        table[class=body] span,
        table[class=body] a {
          font-size: 16px !important; }
        table[class=body] .wrapper,
        table[class=body] .article {
          padding: 10px !important; }
        table[class=body] .content {
          padding: 0 !important; }
        table[class=body] .container {
          padding: 0 !important;
          width: 100% !important; }
        table[class=body] .main {
          border-left-width: 0 !important;
          border-radius: 0 !important;
          border-right-width: 0 !important; }
        table[class=body] .btn table {
          width: 100% !important; }
        table[class=body] .btn a {
          width: 100% !important; }
        table[class=body] .img-responsive {
          height: auto !important;
          max-width: 100% !important;
          width: auto !important; }}

      /* -------------------------------------
          PRESERVE THESE STYLES IN THE HEAD
      ------------------------------------- */
      @media all {
        .ExternalClass {
          width: 100%; }
        .ExternalClass,
        .ExternalClass p,
        .ExternalClass span,
        .ExternalClass font,
        .ExternalClass td,
        .ExternalClass div {
          line-height: 100%; }
        .apple-link a {
          color: inherit !important;
          font-family: inherit !important;
          font-size: inherit !important;
          font-weight: inherit !important;
          line-height: inherit !important;
          text-decoration: none !important; }
        .btn-primary table td:hover {
          background-color: #34495e !important; }
        .btn-primary a:hover {
          background-color: #34495e !important;
          border-color: #34495e !important; } }

    </style>
</head>
<body class="">
    <table border="0" cellpadding="0" cellspacing="0" class="body">
        <tr>
            <td>&nbsp;</td>
            <td class="container">
                <div class="content">
                    <!-- START CENTERED WHITE CONTAINER -->
                    <span class="preheader">Alerta CMI CS FUVEX</span>

                    <table class="main">
                        <tr>
                            <td style="text-align: center; vertical-align: middle;">
							
                             <img src="https://www.bbva.com/wp-content/themes/coronita-bbvacom/assets/images/logos/logo-amp.png" width="180" height="50" /> 
                            </td>
                        </tr>
                    </table>

                        <table class="main">
                            <!-- START MAIN CONTENT AREA -->                           

                            <tr>
                                <td class="wrapper">
                                    <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="content-block">
                                                <h2>Estimado(a) : </h2>							
                                               
                                          
                                                <p>
												Se ha actualizado exitosamente el cálculo de indicadores del Cuadro de Mando Integral de Contratación Sencilla hasta la fecha:  <strong>' + CONVERT(VARCHAR,@fecha_proceso) +' </strong>.                                                  													
                                                </p>
												
                                                <br />                                               
                                           
                                                <p>Atentamente.</p>
                                                <p>BBVA - Soporte OPPLUS </p>             
                                                                                            

                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <!-- END MAIN CONTENT AREA -->
                        </table>
                        <!-- START FOOTER -->
                        <div class="footer_1">
                            <table border="0" cellpadding="0" cellspacing="0">

                                <tr>
                                    <td class="content-block"></td>
                                </tr>
                                <tr>
                                    <td class="content-block">
                                        Sigamos conectados
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content-block"></td>
                                </tr>


                            </table>
                        </div>

                        <div class="footer_2">
                            <table border="0" cellpadding="0" cellspacing="0">

                                <tr>
                                    <td class="content-block"></td>
                                    <td class="content-block"></td>
                                    <td class="content-block"></td>

                                </tr>
                                <tr>
                                    <td class="content-block">
                                        <a href="https://www.bbvacontinental.pe/meta/atencion-cliente/">Atención al cliente</a>

                                    </td>
                                    <td class="content-block">
                                        <a href="https://www.bbvacontinental.pe/meta/atencion-cliente/">(01) 595-0000</a>


                                    </td>
                                    <td class="content-block">
                                        <a href="http://www.ubicanosbbvacontinental.pe/">Ubícanos</a>


                                    </td>
                                </tr>

                                <tr>
                                    <td class="content-block"></td>
                                    <td class="content-block"></td>
                                    <td class="content-block"></td>

                                </tr>

                            </table>
                        </div>

                        <div class="footer" style="background-color:#072146">
                            <table border="0" cellpadding="0" cellspacing="0">
                               
                                <tr>
                                    <td class="content-block">                                      
                                        <br />
                                    </td>
                                </tr>
                                
                               <tr>
								<td class="content-block">
                                   
								<img src="https://www.bbva.com/wp-content/themes/coronita-bbvacom/assets/images/comun/bbva_footer_dkt_es.png" width="210" height="54" />      
								
                                      
								</td>
							   </tr>
                                
                                <tr>
                                    <td class="content-block">
                                        <span class="apple-link">Av. República de Panamá 3080 - San Isidro, Lima - Perú.</span><br />
                                        <span>2020 OPPLUS - Operaciones y Servicios Sucursal Perú - Grupo BBVA</span>

                                    </td>
                                </tr>
                               

                                <tr>
                                    <td class="content-block">                                                                                                                  
                                        
                                        <p>________________________________________________________</p>
										
                                        <span> Este correo electrónico fue enviado desde opplus.bbva</span><br />
                                        <span> Av. República de Panamá 3680 Of 101 - San Isidro, Lima - Perú.</span>
                                   


                                    </td>
                                    

                                </tr>
                            </table>
                        </div>

                        <!-- END FOOTER -->
                        <!-- END CENTERED WHITE CONTAINER -->
</div>
            </td>
            <td>&nbsp;</td>
        </tr>
    </table>
</body>
</html>';

SET @subject_mail ='Actualización CMI WEB de Contratacion Sencilla hasta el: ' + CONVERT(VARCHAR,@fecha_proceso)

	EXEC msdb.dbo.Sp_send_dbmail
		@profile_name =  'Soporte Opplus',
		@recipients ='didier.yepez@opplus.bbva.com;raul.ore.huamani@opplus.bbva.com',
		--@recipients='didier.yepez@opplus.bbva.com',
		@body = @body_mail,
		@body_format ='HTML',
		@subject = @subject_mail,
		@importance ='HIGH'
	--@file_attachments=@adjunto

	
	
	PRINT 'CMI Actualizacion hasta el: ' + CONVERT(VARCHAR, @fecha_proceso) 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_FUVEX_SUBPRODUCTO_SUBIR]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 16/04/2020
-- Description:	Procedure para cargar los SUBPRODUCTOS de FUVEX
-- =============================================
CREATE PROCEDURE [dbo].[USP_FUVEX_SUBPRODUCTO_SUBIR]
(@archivo varchar(100))

AS

BEGIN


CREATE TABLE #FUVEX_SUBPRODUCTO_TEMP(	
	[CODIGO] [varchar](20) NULL,
	[NOMBRE] [varchar](100) NULL,	
	[TIPO] [varchar](30) NULL,
)

DECLARE @FILA_BULK_COUNT INT; 
DECLARE @path varchar(100) = '\\172.17.1.51\mp\DATA-CMI-CS\' +@archivo +'.csv' ;
DECLARE @SQL_BULK VARCHAR(MAX)


-------

SET @SQL_BULK = 'BULK INSERT #FUVEX_SUBPRODUCTO_TEMP FROM ''' + @path + ''' WITH
        (
     
        FIELDTERMINATOR = ''¬'',
        ROWTERMINATOR = ''\n''
  
        )'

EXEC (@SQL_BULK)


SET @FILA_BULK_COUNT =  (SELECT @@ROWCOUNT)

IF(@FILA_BULK_COUNT > 0)
	BEGIN

	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('CARGADO',@archivo,GETDATE())

	END
ELSE
	BEGIN

	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('PENDIENTE',@archivo,GETDATE())

	END



INSERT INTO TB_FUVEX_SUBPRODUCTO
SELECT * FROM #FUVEX_SUBPRODUCTO_TEMP

SELECT * FROM TB_FUVEX_SUBPRODUCTO

END
GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONV_EXP_TIEMPOS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 25/05/2020
-- Description:	SP para sacar tiempos de los expedientes, no importa en que bandeja se encuentre, 
				--solamente se considera que hayan sido registrados
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONV_EXP_TIEMPOS] (@MES int,@AÑO int)

AS


BEGIN

DECLARE @FECHA datetime

DECLARE @FECHA_INI datetime
DECLARE @FECHA_MAX datetime

DECLARE @CONTADOR int = 1;
DECLARE @MAX int;

CREATE TABLE #FECHAS
( Id int identity(1,1) NOT NULL PRIMARY KEY,
Fecha varchar(255) NULL,
);
-------------------------------------------------------------
SET @FECHA_INI = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial


SELECT  @FECHA_MAX =(SELECT MAX(FECHA_HORA_ENVIO) 
						FROM TB_CS
						WHERE MONTH (FECHA_HORA_ENVIO) = @MES
						AND YEAR(FECHA_HORA_ENVIO) = @AÑO)
-------------------------------------------------------------						
INSERT INTO #FECHAS (Fecha)
SELECT  DISTINCT (CONVERT(DATE, FECHA_HORA_ENVIO))
FROM TB_CS
where MONTH(CONVERT(DATE, FECHA_HORA_ENVIO)) =  @MES
and  year(CONVERT(DATE, FECHA_HORA_ENVIO)) = @AÑO
ORDER BY 1
-------------------------------------------------------------

-------------------------------------------------------------WHILE FECHAS
SET @MAX = (SELECT COUNT(Id) FROM #FECHAS)

WHILE @CONTADOR <= @MAX

		BEGIN

		SET @FECHA = (SELECT FECHA FROM #FECHAS WHERE Id=@CONTADOR)

		--PRINT 'EJECUTAR PROCEDURE'
		--PRINT CONVERT(DATE,@FECHA)

		EXEC USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO @FECHA, 'PRESTAMO DE LIBRE DISPONIBILIDAD','APROBADO'
		EXEC USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO @FECHA, 'PRESTAMO DE LIBRE DISPONIBILIDAD','REGULAR'

		EXEC USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO @FECHA, 'TARJETA DE CREDITO','APROBADO'
		EXEC USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO @FECHA, 'TARJETA DE CREDITO','REGULAR'

		EXEC USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO @FECHA, 'CONVENIO','APROBADO'
		EXEC USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO @FECHA, 'CONVENIO','REGULAR'



		SET @CONTADOR = @CONTADOR + 1
		END

END

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 25/05/2020
-- Description:	Procedure que hace el trabajo de USP_PLD_CONV_TIEMPOS calcula el tiempo de cada expediente no importa el 
--				estado en el que se encuentre a partir desde que se encuentra registrado.
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONV_EXP_TIEMPOS_CALCULO] (
@FECHA DATETIME,
@NOMBRE_PRODUCTO VARCHAR(100),
@NOMBRE_TIPO_OFERTA VARCHAR(100)
)

AS

BEGIN 


DECLARE @COUNT INT = 1;
DECLARE @COUNT_MAX INT;
DECLARE @NRO_EXPEDIENTE VARCHAR(10);

DECLARE @DIA_ANTERIOR DATETIME = (DATEADD(dd,DATEDIFF(dd,0,GETDATE()),0));
DECLARE @DIA_ANTERIOR_MEDIA_NOCHE DATETIME = (SELECT DATEADD(SECOND, -3, @DIA_ANTERIOR));

CREATE TABLE #EXPS
(
ID INT IDENTITY(1,1) NOT NULL,
EXPD VARCHAR(10) NULL
)


CREATE TABLE #REGISTRADO
(
RPRODUCTO VARCHAR(100) NULL,
ROFERTA VARCHAR(50) NULL,
RPERFIL VARCHAR(100) NULL,
RESTADO VARCHAR(100) NULL,
REXPDIENTE VARCHAR(10) NULL,
RFECHA DATETIME NULL
)


CREATE TABLE #ENPROCESOS
(
PRODUCTO VARCHAR(100) NULL,
OFERTA VARCHAR(50) NULL,
PERFIL VARCHAR(100) NULL,
ESTADO VARCHAR(100) NULL,
EXPEDIENTE VARCHAR(10) NULL,
FECHA DATETIME NULL
)

CREATE TABLE #FINALIZADOS
(
FPRODUCTO VARCHAR(100) NULL,
FOFERTA VARCHAR(50) NULL,
FPERFIL VARCHAR(100) NULL,
FESTADO VARCHAR(100) NULL,
FEXPDIENTE VARCHAR(10) NULL,
FFECHA DATETIME NULL
)

INSERT INTO #EXPS
SELECT DISTINCT NRO_EXPEDIENTE
FROM TB_CS
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA
		AND ESTADO_EXPEDIENTE = 'Expediente Registrado' 
		AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(CONVERT(DATE,@FECHA))
		AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(CONVERT(DATE,@FECHA)) 
		


SET @COUNT_MAX = (SELECT COUNT(ID) FROM #EXPS)
WHILE @COUNT <= @COUNT_MAX

BEGIN

SET @NRO_EXPEDIENTE = (SELECT EXPD FROM #EXPS WHERE ID = @COUNT)

DELETE FROM #REGISTRADO
--------------------------------------------// Hallamos los registrados
INSERT INTO #REGISTRADO
SELECT NOMBRE_PRODUCTO AS PRODUCTO, NOMBRE_TIPO_OFERTA as OFERTA, PERFIL AS PERFIL, ESTADO_EXPEDIENTE AS ESTADO,
NRO_EXPEDIENTE AS EXP_REGISTRADO, FECHA_HORA_ENVIO AS FECHA_INICIAL
FROM  TB_CS  
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA
AND ESTADO_EXPEDIENTE = 'Expediente registrado' 
AND CONVERT(DATE,FECHA_HORA_ENVIO) = CONVERT(DATE,@FECHA)
AND NRO_EXPEDIENTE = @NRO_EXPEDIENTE
------------------------------------------------------------

		IF NOT EXISTS (
						SELECT NOMBRE_PRODUCTO AS PRODUCTO, NOMBRE_TIPO_OFERTA as OFERTA, C.PERFIL AS PERFIL, ESTADO_EXPEDIENTE AS ESTADO,
						NRO_EXPEDIENTE AS EXP_REGISTRADO, FECHA_HORA_ENVIO AS FECHA_INICIAL				
						FROM  TB_CS  C INNER JOIN #REGISTRADO R
						ON C.NRO_EXPEDIENTE = R.REXPDIENTE
						WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA
						AND C.ESTADO_EXPEDIENTE IN ('Desembolsado / En Embose','Cerrado','Rechazado')
						AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(CONVERT(DATE,@FECHA))
						AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(CONVERT(DATE,@FECHA))						
					 )
			BEGIN		

					INSERT INTO #ENPROCESOS

					SELECT RPRODUCTO, ROFERTA, RPERFIL, RESTADO, REXPDIENTE, RFECHA			
					FROM  #REGISTRADO  
					WHERE RPRODUCTO = @NOMBRE_PRODUCTO AND ROFERTA = @NOMBRE_TIPO_OFERTA
					AND RESTADO = 'Expediente registrado' 
					AND CONVERT(DATE,RFECHA) = CONVERT(DATE,@FECHA)				
			
			END
	
		ELSE 

			BEGIN		

			INSERT INTO #FINALIZADOS

			SELECT NOMBRE_PRODUCTO AS PRODUCTO, NOMBRE_TIPO_OFERTA as OFERTA, C.PERFIL AS PERFIL, ESTADO_EXPEDIENTE AS ESTADO,
						NRO_EXPEDIENTE AS EXP_REGISTRADO, FECHA_HORA_ENVIO AS FECHA_INICIAL				
						FROM  TB_CS  C INNER JOIN #REGISTRADO R
						ON C.NRO_EXPEDIENTE = R.REXPDIENTE
						WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA
						AND C.ESTADO_EXPEDIENTE IN ('Desembolsado / En Embose','Cerrado','Rechazado')
						AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(CONVERT(DATE,@FECHA))
						AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(CONVERT(DATE,@FECHA))


			END			
			SET @COUNT = @COUNT + 1
END

	
	--SELECT * FROM #ENPROCESOS  ---------- MUESTRA EXPEDIENTES EN PROCESO
	--SELECT * FROM #FINALIZADOS ---------- MUESTRA EXPEDIENTES FINALIZADOS


----------------------------------------------------------------// Join de Registrados y los que aun no finalizan.
---------------------------------------------------------------------------------------------DIAS LABORALES
--INSERT INTO PLD_TC_CONVENIO_TIEMPOS_EXPEDIENTES

SELECT CONVERT(DATE,FECHA) AS FECHA ,EXPEDIENTE, 
FECHA AS FECHA_REGISTRO, @DIA_ANTERIOR_MEDIA_NOCHE AS MEDIANOCHE,
[dbo].[fn_tiempo_horas] (FECHA,@DIA_ANTERIOR_MEDIA_NOCHE) AS DIFERENCIA,
OFERTA, PRODUCTO
FROM #ENPROCESOS
GROUP BY FECHA, EXPEDIENTE,OFERTA, PRODUCTO
ORDER BY [dbo].[fn_tiempo_horas] (FECHA,@DIA_ANTERIOR_MEDIA_NOCHE) ASC
---------------------------------------------------------------------------------------------DIAS LABORALES
END 


GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_CALIDAD]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas 
-- Create date: 25/03/2020
-- Description: Procedure para llenar la pestaña CALIDAD del CMI de Contratacion Sencilla.
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_CALIDAD]
(@MES INT,
@AÑO INT
)

AS


BEGIN

-------------------------------------// Expedientes Ingresados m1, m2 Ofertas...
DECLARE @EXP_ING_OFAPROBADA_MES1 INT;
DECLARE @EXP_ING_OFREGULAR_MES1 INT;

DECLARE @EXP_ING_OFAPROBADA_MES2 INT;
DECLARE @EXP_ING_OFREGULAR_MES2 INT;
-------------------------------------// Expedientes Rechazados m1, m2 Ofertas...
DECLARE @EXP_RECH_OFAPROBADA_MES1 INT;
DECLARE @EXP_RECH_OFREGULAR_MES1 INT;

DECLARE @EXP_RECH_OFAPROBADA_MES2 INT;
DECLARE @EXP_RECH_OFREGULAR_MES2 INT;
-------------------------------------// Expedientes Desembolsados m1, m2 Ofertas...
DECLARE @EXP_DESEM_OFAPROBADA_MES1 INT;
DECLARE @EXP_DESEM_OFREGULAR_MES1 INT;

DECLARE @EXP_DESEM_OFAPROBADA_MES2 INT;
DECLARE @EXP_DESEM_OFREGULAR_MES2 INT;


DECLARE @fecha_proceso DATE;
SET @fecha_proceso = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)




------------------------------------// WHILE PRODUCTOS
	DECLARE @CONT_P INT = 1;
	DECLARE @CONTMAX_P INT;		
	DECLARE @PRODUCTO_NAME VARCHAR(65);

	DELETE FROM PLD_TC_CONVENIO_CALIDAD WHERE fecha_proceso = @fecha_proceso

	CREATE TABLE #PRODUCTOS
		(	
			cod int identity(1,1) not null,	
			producto varchar(65)			
		)


		insert into #PRODUCTOS
		select distinct NOMBRE_PRODUCTO 
		from TB_CS

		SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)
		WHILE @CONT_P <= @CONTMAX_P
		BEGIN 

		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)	

-------------------------------------------------------------------------------------------- INGRESADOS
		SET @EXP_ING_OFAPROBADA_MES1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Expediente Registrado' 
							AND NOMBRE_TIPO_OFERTA = 'APROBADO'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)))

		SET @EXP_ING_OFAPROBADA_MES2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Expediente Registrado' 
							AND NOMBRE_TIPO_OFERTA = 'APROBADO'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)))

		SET @EXP_ING_OFREGULAR_MES1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Expediente Registrado' 
							AND NOMBRE_TIPO_OFERTA = 'REGULAR'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)))

		SET @EXP_ING_OFREGULAR_MES2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Expediente Registrado' 
							AND NOMBRE_TIPO_OFERTA = 'REGULAR'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)))
-------------------------------------------------------------------------------------------- RECHAZADOS
		SET @EXP_RECH_OFAPROBADA_MES1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='RECHAZADO' 
							AND NOMBRE_TIPO_OFERTA = 'APROBADO'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)))

		SET @EXP_RECH_OFAPROBADA_MES2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='RECHAZADO' 
							AND NOMBRE_TIPO_OFERTA = 'APROBADO'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)))

		SET @EXP_RECH_OFREGULAR_MES1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='RECHAZADO' 
							AND NOMBRE_TIPO_OFERTA = 'REGULAR'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)))

		SET @EXP_RECH_OFREGULAR_MES2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='RECHAZADO' 
							AND NOMBRE_TIPO_OFERTA = 'REGULAR'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)))


-------------------------------------------------------------------------------------------- DESEMBOLSADOS
		SET @EXP_DESEM_OFAPROBADA_MES1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Desembolsado / En Embose' 
							AND NOMBRE_TIPO_OFERTA = 'APROBADO'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)))

		SET @EXP_DESEM_OFAPROBADA_MES2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Desembolsado / En Embose'  
							AND NOMBRE_TIPO_OFERTA = 'APROBADO'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)))

		SET @EXP_DESEM_OFREGULAR_MES1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Desembolsado / En Embose' 
							AND NOMBRE_TIPO_OFERTA = 'REGULAR'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)))

		SET @EXP_DESEM_OFREGULAR_MES2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE)
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
							ESTADO_EXPEDIENTE='Desembolsado / En Embose' 
							AND NOMBRE_TIPO_OFERTA = 'REGULAR'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)))


						

			

			INSERT INTO PLD_TC_CONVENIO_CALIDAD					  	  
			SELECT producto, '1', 'Expedientes Ingresados', fecha_proceso, dia1, dia2, dia3, dia4, dia5, 
				dia6, dia7, dia8, dia9, dia10,dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19,
				dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1,mes2,mes3
			FROM PLD_TC_CONVENIO	  
			WHERE producto = @PRODUCTO_NAME
			AND  descripcion = 'EXP.INGRESADOS'
			AND fecha_proceso = @fecha_proceso

			UNION ALL
			-------

			SELECT
			NOMBRE_PRODUCTO,
			'1.1', 
				'Oferta Aprobada',
			@fecha_proceso AS fecha_proceso,

			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
			END),0) AS '01',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
			END),0) AS '02',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
			END),0) AS '03',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
			END),0) AS '04',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
			END),0) AS '05',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
			END),0) AS '06',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
			END),0) AS '07',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
			END),0) AS '08',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
			END),0) AS '09',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
			END),0) AS '10',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
			END),0) AS '11',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
			END),0) AS '12',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
			END),0) AS '13',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
			END),0) AS '14',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
			END),0) AS '15',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
			END),0) AS '16',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
			END),0) AS '17',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
			END),0) AS '18',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
			END),0) AS '19',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
			END),0) AS '20',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
			END),0) AS '21',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
			END),0) AS '22',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
			END),0) AS '23',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
			END),0) AS '24',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
			END),0) AS '25',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
			END),0) AS '26',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
			END),0) AS '27',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
			END),0) AS '28',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
			END),0) AS '29',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
			END),0) AS '30',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
			END),0) AS '31',									
			ISNULL(@EXP_ING_OFAPROBADA_MES1,0) AS mes1,
			ISNULL(@EXP_ING_OFAPROBADA_MES2,0) AS mes2,
			ISNULL(COUNT(DISTINCT CASE	WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE	END),0) AS mes3							

			FROM TB_CS
			WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
			ESTADO_EXPEDIENTE='Expediente Registrado' 
			AND NOMBRE_TIPO_OFERTA = 'APROBADO'
			AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
			AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO	 
			GROUP BY NOMBRE_PRODUCTO 


			UNION ALL
			-------

			SELECT
			NOMBRE_PRODUCTO,
			'1.2', 
				'Oferta Regular',
			@fecha_proceso AS fecha_proceso,

			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
			END),0) AS '01',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
			END),0) AS '02',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
			END),0) AS '03',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
			END),0) AS '04',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
			END),0) AS '05',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
			END),0) AS '06',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
			END),0) AS '07',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
			END),0) AS '08',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
			END),0) AS '09',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
			END),0) AS '10',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
			END),0) AS '11',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
			END),0) AS '12',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
			END),0) AS '13',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
			END),0) AS '14',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
			END),0) AS '15',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
			END),0) AS '16',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
			END),0) AS '17',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
			END),0) AS '18',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
			END),0) AS '19',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
			END),0) AS '20',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
			END),0) AS '21',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
			END),0) AS '22',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
			END),0) AS '23',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
			END),0) AS '24',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
			END),0) AS '25',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
			END),0) AS '26',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
			END),0) AS '27',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
			END),0) AS '28',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
			END),0) AS '29',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
			END),0) AS '30',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
			END),0) AS '31',
			ISNULL(@EXP_ING_OFREGULAR_MES1,0) AS mes1,
			ISNULL(@EXP_ING_OFREGULAR_MES2,0) AS mes2,
			ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE END),0) AS mes3	

			FROM TB_CS
			WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
			ESTADO_EXPEDIENTE='Expediente registrado' 
			AND NOMBRE_TIPO_OFERTA = 'REGULAR'
			AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
			AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO	 
			GROUP BY NOMBRE_PRODUCTO 


			UNION ALL
			-------


			SELECT producto, '2', 'Expedientes Rechazados', fecha_proceso, dia1, dia2, dia3, dia4, dia5, 
				dia6, dia7, dia8, dia9, dia10,dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19,
				dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1,mes2,mes3
			FROM PLD_TC_CONVENIO	  
			WHERE producto = @PRODUCTO_NAME
			AND  descripcion = 'EXP.RECHAZADOS-TOTAL'
			AND fecha_proceso = @fecha_proceso
	 

			UNION ALL
			-------

			SELECT
			NOMBRE_PRODUCTO,
			'2.1', 
				'Oferta Aprobada',
			@fecha_proceso AS fecha_proceso,

			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
			END),0) AS '01',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
			END),0) AS '02',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
			END),0) AS '03',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
			END),0) AS '04',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
			END),0) AS '05',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
			END),0) AS '06',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
			END),0) AS '07',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
			END),0) AS '08',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
			END),0) AS '09',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
			END),0) AS '10',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
			END),0) AS '11',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
			END),0) AS '12',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
			END),0) AS '13',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
			END),0) AS '14',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
			END),0) AS '15',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
			END),0) AS '16',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
			END),0) AS '17',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
			END),0) AS '18',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
			END),0) AS '19',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
			END),0) AS '20',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
			END),0) AS '21',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
			END),0) AS '22',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
			END),0) AS '23',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
			END),0) AS '24',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
			END),0) AS '25',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
			END),0) AS '26',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
			END),0) AS '27',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
			END),0) AS '28',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
			END),0) AS '29',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
			END),0) AS '30',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
			END),0) AS '31',

			ISNULL(@EXP_RECH_OFAPROBADA_MES1,0) AS mes1,
			ISNULL(@EXP_RECH_OFAPROBADA_MES2,0) AS mes2,
			ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE END),0) AS mes3	

			FROM TB_CS
			WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
			ESTADO_EXPEDIENTE='RECHAZADO' 
			AND NOMBRE_TIPO_OFERTA = 'APROBADO'
			AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
			AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
			GROUP BY NOMBRE_PRODUCTO 

			UNION ALL
			-------

			SELECT
			NOMBRE_PRODUCTO,
			'2.2', 
				'Oferta Regular',
			@fecha_proceso AS fecha_proceso,

			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
			END),0) AS '01',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
			END),0) AS '02',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
			END),0) AS '03',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
			END),0) AS '04',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
			END),0) AS '05',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
			END),0) AS '06',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
			END),0) AS '07',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
			END),0) AS '08',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
			END),0) AS '09',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
			END),0) AS '10',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
			END),0) AS '11',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
			END),0) AS '12',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
			END),0) AS '13',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
			END),0) AS '14',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
			END),0) AS '15',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
			END),0) AS '16',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
			END),0) AS '17',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
			END),0) AS '18',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
			END),0) AS '19',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
			END),0) AS '20',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
			END),0) AS '21',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
			END),0) AS '22',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
			END),0) AS '23',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
			END),0) AS '24',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
			END),0) AS '25',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
			END),0) AS '26',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
			END),0) AS '27',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
			END),0) AS '28',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
			END),0) AS '29',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
			END),0) AS '30',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
			END),0) AS '31',

			ISNULL(@EXP_RECH_OFREGULAR_MES1,0) AS mes1,
			ISNULL(@EXP_RECH_OFREGULAR_MES2,0) AS mes2,
			ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE END),0) AS mes3	

			FROM TB_CS
			WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
			ESTADO_EXPEDIENTE='RECHAZADO' 
			AND NOMBRE_TIPO_OFERTA = 'REGULAR'
			AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
			AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
			GROUP BY NOMBRE_PRODUCTO 


			UNION ALL
			-------

			SELECT producto, '3', 'Expedientes Desembolsados', fecha_proceso, dia1, dia2, dia3, dia4, dia5, 
				dia6, dia7, dia8, dia9, dia10,dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19,
				dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1,mes2,mes3

			FROM PLD_TC_CONVENIO
	  
			WHERE producto = @PRODUCTO_NAME
			AND  descripcion = 'EXP.DESEMBOLSADOS-TOTAL'
			AND fecha_proceso = @fecha_proceso

			UNION ALL
			-------

			SELECT
			NOMBRE_PRODUCTO,
			'3.1', 
				'Oferta Aprobada',
			@fecha_proceso AS fecha_proceso,

			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '01',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '02',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '03',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '04',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '05',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '06',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '07',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '08',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '09',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '10',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '11',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '12',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '13',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '14',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '15',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '16',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '17',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '18',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '19',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '20',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '21',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '22',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '23',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '24',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '25',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '26',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '27',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '28',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '29',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '30',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE ELSE 0
			END),0) AS '31',				

			ISNULL(@EXP_DESEM_OFAPROBADA_MES1,0) AS mes1,
			ISNULL(@EXP_DESEM_OFAPROBADA_MES2,0) AS mes2,
			ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE ELSE 0 END),0) AS mes3

			FROM TB_CS
			WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
			ESTADO_EXPEDIENTE='Desembolsado / En Embose' 
			AND NOMBRE_TIPO_OFERTA = 'APROBADO'
			AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
			AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
			GROUP BY NOMBRE_PRODUCTO 

			UNION ALL
			-------

			SELECT
			NOMBRE_PRODUCTO,
			'3.2', 
				'Oferta Regular',
			@fecha_proceso AS fecha_proceso,

			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
			END),0) AS '01',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
			END),0) AS '02',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
			END),0) AS '03',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
			END),0) AS '04',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
			END),0) AS '05',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
			END),0) AS '06',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
			END),0) AS '07',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
			END),0) AS '08',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
			END),0) AS '09',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
			END),0) AS '10',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
			END),0) AS '11',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
			END),0) AS '12',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
			END),0) AS '13',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
			END),0) AS '14',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
			END),0) AS '15',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
			END),0) AS '16',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
			END),0) AS '17',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
			END),0) AS '18',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
			END),0) AS '19',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
			END),0) AS '20',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
			END),0) AS '21',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
			END),0) AS '22',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
			END),0) AS '23',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
			END),0) AS '24',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
			END),0) AS '25',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
			END),0) AS '26',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
			END),0) AS '27',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
			END),0) AS '28',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
			END),0) AS '29',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
			END),0) AS '30',
			ISNULL(COUNT(DISTINCT CASE
			WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
			END),0) AS '31',

			ISNULL(@EXP_DESEM_OFREGULAR_MES1,0) AS mes1,
			ISNULL(@EXP_DESEM_OFREGULAR_MES2,0) AS mes2,
			ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE ELSE 0 END),0) AS mes3

			FROM TB_CS
			WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
			ESTADO_EXPEDIENTE='Desembolsado / En Embose'
			AND NOMBRE_TIPO_OFERTA = 'REGULAR'
			AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
			AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
			GROUP BY NOMBRE_PRODUCTO

	 SET @CONT_P = @CONT_P+1


	 END

END

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_FUNNEL_ACUMULADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 18/05/2020
-- Description:	Procedure replicado de SARA que calcula el funnel acumulado de los productos PLD,TC,CONVENIO.
-- =============================================
CREATE PROCEDURE  [dbo].[USP_PLD_TC_CONVENIO_FUNNEL_ACUMULADO] (
@MES INT,
@AÑO INT,
@DETALLE VARCHAR(50)
)

AS

BEGIN

DECLARE @FECHA_INICIO DATE;
DECLARE @FECHA_FIN DATE;

------------------------------------// WHILE PRODUCTOS
	DECLARE @CONT_P INT = 1;
	DECLARE @CONTMAX_P INT;		
	DECLARE @PRODUCTO_NAME VARCHAR(65);


set @FECHA_INICIO = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial

set @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) 
						FROM TB_CS
						WHERE MONTH (FECHA_HORA_ENVIO) = @MES
						AND YEAR(FECHA_HORA_ENVIO) = @AÑO)

------------------------------------------------------------------//REPROCESO
DELETE FROM PLD_TC_CONVENIO_FUNNEL_ACUMULADO WHERE fecha_proceso = @FECHA_FIN
------------------------------------------------------------------//REPROCESO

-----------------------------------------------// REGISTRADOS MES DOS ATRAS 
SELECT DISTINCT NRO_EXPEDIENTE AS NRO_EXP, FECHA_HORA_ENVIO AS FECHA_ENVIO, ESTADO_EXPEDIENTE AS ESTADO
INTO #MES_ANTERIOR_DOS
from TB_CS 
where ESTADO_EXPEDIENTE = 'Expediente Registrado'
  and month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
  and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) 
order by NRO_EXPEDIENTE

-----------------------------------------------// REGISTRADOS MES UNO ATRAS 
SELECT DISTINCT NRO_EXPEDIENTE AS NRO_EXP, FECHA_HORA_ENVIO AS FECHA_ENVIO, ESTADO_EXPEDIENTE AS ESTADO
INTO #MES_ANTERIOR
from TB_CS 
where ESTADO_EXPEDIENTE = 'Expediente Registrado'
  and month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
  and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) 
order by NRO_EXPEDIENTE

-----------------------------------------------// REGISTRADOS MES ACTUAL 
SELECT DISTINCT NRO_EXPEDIENTE AS NRO_EXP, FECHA_HORA_ENVIO AS FECHA_ENVIO, ESTADO_EXPEDIENTE AS ESTADO
INTO #EXPEDIENTES_REGISTRADOS
from TB_CS 
where ESTADO_EXPEDIENTE = 'Expediente Registrado'
  and month(FECHA_HORA_ENVIO) = @MES
  and year(FECHA_HORA_ENVIO) = @AÑO 
order by NRO_EXPEDIENTE


CREATE TABLE #PRODUCTOS
		(	
			cod int identity(1,1) not null,	
			producto varchar(65)			
		)
		insert into #PRODUCTOS
		select distinct NOMBRE_PRODUCTO 
		from TB_CS 
		


SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)

IF(@DETALLE = 'SIN DETALLE')
BEGIN

		WHILE @CONT_P <= @CONTMAX_P
		BEGIN

		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)	
	
		--PRINT 'ENTRO'
		--PRINT '--------------------'
		--PRINT @FECHA_INICIO
		--PRINT @FECHA_FIN
		--PRINT '--------------------'
		--print @PRODUCTO_NAME

		--PRINT '--------------------'
		
		insert into PLD_TC_CONVENIO_FUNNEL_ACUMULADO
		-------------------------------------------------------------// MES UNO ATRAS
		select MONTH(DATEADD(MONTH, -2, @FECHA_FIN)), YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) , @PRODUCTO_NAME,
		 'INGRESADOS' , count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR_DOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
			  and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN))  and
			  CS.ESTADO_EXPEDIENTE='Expediente Registrado'
	
		UNION ALL

		select MONTH(DATEADD(MONTH, -2, @FECHA_FIN)), YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'MESA DE CONTROL',  count( distinct NRO_EXPEDIENTE),@FECHA_FIN  
			 from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR_DOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN))  and
			  CS.PERFIL='MESA DE CONTROL'

		UNION ALL

		select MONTH(DATEADD(MONTH, -2, @FECHA_FIN)), YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'ANALISIS Y ALTA', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR_DOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 		
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) and
			  cs.PERFIL='ANALISIS Y ALTA'

		UNION ALL

		select MONTH(DATEADD(MONTH, -2, @FECHA_FIN)), YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'CONTROLLER', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR_DOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and			
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) and
			  PERFIL='CONTROLLER'

		UNION ALL

		select MONTH(DATEADD(MONTH, -2, @FECHA_FIN)), YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'DESEMBOLSO', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR_DOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			
			    month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) and
			  CS.ESTADO_EXPEDIENTE='Desembolsado / En Embose'

		union all

		select MONTH(DATEADD(MONTH, -2, @FECHA_FIN)), YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'RECHAZADOS', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR_DOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and			
			    month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) and
			  ESTADO_EXPEDIENTE='RECHAZADO'

		UNION ALL 


		select MONTH(DATEADD(MONTH, -2, @FECHA_FIN)), YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'REPROCESADOS', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
		from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR_DOS R
		ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
		where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			  
		month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
		and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) and
		accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
		-----------------------------------------------------------// MES DOS ATRAS

		UNION ALL

		-------------------------------------------------------------// MES UNO ATRAS
		select MONTH(DATEADD(MONTH, -1, @FECHA_FIN)), YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) , @PRODUCTO_NAME,
		 'INGRESADOS' , count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
			  and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN))  and
			  CS.ESTADO_EXPEDIENTE='Expediente Registrado'
	
		UNION ALL

		select MONTH(DATEADD(MONTH, -1, @FECHA_FIN)), YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'MESA DE CONTROL',  count( distinct NRO_EXPEDIENTE),@FECHA_FIN  
			 from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN))  and
			  CS.PERFIL='MESA DE CONTROL'

		UNION ALL

		select MONTH(DATEADD(MONTH, -1, @FECHA_FIN)), YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'ANALISIS Y ALTA', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 		
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) and
			  cs.PERFIL='ANALISIS Y ALTA'

		UNION ALL

		select MONTH(DATEADD(MONTH, -1, @FECHA_FIN)), YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'CONTROLLER', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and			
			  month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) and
			  PERFIL='CONTROLLER'

		UNION ALL

		select MONTH(DATEADD(MONTH, -1, @FECHA_FIN)), YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'DESEMBOLSO', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			
			    month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) and
			  CS.ESTADO_EXPEDIENTE='Desembolsado / En Embose'

		union all

		select MONTH(DATEADD(MONTH, -1, @FECHA_FIN)), YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'RECHAZADOS', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and			
			    month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
				and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) and
			  ESTADO_EXPEDIENTE='RECHAZADO'

		UNION ALL 

		select MONTH(DATEADD(MONTH, -1, @FECHA_FIN)), YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) , @PRODUCTO_NAME, 
		'REPROCESADOS', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
		from dbo.TB_CS CS INNER JOIN #MES_ANTERIOR R
		ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
		where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			  
		month(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
		and year(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) and
		accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
		-----------------------------------------------------------// MES UNO ATRAS


		UNION ALL

		-------------------------------------------------------------// MES ACTUAL
		select @MES, @AÑO , @PRODUCTO_NAME,
		 'INGRESADOS' , count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #EXPEDIENTES_REGISTRADOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 
			  month(FECHA_HORA_ENVIO) = @MES
			  and year(FECHA_HORA_ENVIO) = @AÑO and
			  CS.ESTADO_EXPEDIENTE='Expediente Registrado'
	
		UNION ALL

		select @MES, @AÑO , @PRODUCTO_NAME, 
		'MESA DE CONTROL',  count( distinct NRO_EXPEDIENTE),@FECHA_FIN  
			 from dbo.TB_CS CS INNER JOIN #EXPEDIENTES_REGISTRADOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			
			  month(FECHA_HORA_ENVIO) = @MES
				and year(FECHA_HORA_ENVIO) = @AÑO and
			  CS.PERFIL='MESA DE CONTROL'

		UNION ALL

		select @MES, @AÑO , @PRODUCTO_NAME, 
		'ANALISIS Y ALTA', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #EXPEDIENTES_REGISTRADOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 		
			  month(FECHA_HORA_ENVIO) = @MES
				and year(FECHA_HORA_ENVIO) = @AÑO and
			  cs.PERFIL='ANALISIS Y ALTA'

		UNION ALL

		select @MES, @AÑO , @PRODUCTO_NAME, 
		'CONTROLLER', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #EXPEDIENTES_REGISTRADOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and			
			  month(FECHA_HORA_ENVIO) = @MES
				and year(FECHA_HORA_ENVIO) = @AÑO and
			  PERFIL='CONTROLLER'

		UNION ALL

		select @MES, @AÑO , @PRODUCTO_NAME, 
		'DESEMBOLSO', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #EXPEDIENTES_REGISTRADOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			
			    month(FECHA_HORA_ENVIO) = @MES
				and year(FECHA_HORA_ENVIO) = @AÑO and
			  CS.ESTADO_EXPEDIENTE='Desembolsado / En Embose'

		union all

		select @MES, @AÑO , @PRODUCTO_NAME, 
		'RECHAZADOS', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
			  from dbo.TB_CS CS INNER JOIN #EXPEDIENTES_REGISTRADOS R
			  ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
			 
			  where NOMBRE_PRODUCTO= @PRODUCTO_NAME and			
			    month(FECHA_HORA_ENVIO) = @MES
				and year(FECHA_HORA_ENVIO) = @AÑO and
			  ESTADO_EXPEDIENTE='RECHAZADO'

		UNION ALL 


		select @MES, @AÑO , @PRODUCTO_NAME, 
		'REPROCESADOS', count( distinct NRO_EXPEDIENTE),@FECHA_FIN 
		from dbo.TB_CS CS INNER JOIN #EXPEDIENTES_REGISTRADOS R
		ON CS.NRO_EXPEDIENTE = R.NRO_EXP 
		where NOMBRE_PRODUCTO= @PRODUCTO_NAME and 			  
		month(FECHA_HORA_ENVIO) = @MES
		and year(FECHA_HORA_ENVIO) = @AÑO and
		accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
			  -----------------------------------------------------------// MES ACTUAL
			  
			  SET @CONT_P = @CONT_P+1
		END		
END

IF(@DETALLE = 'CON DETALLE') 

BEGIN

		WHILE @CONT_P <= @CONTMAX_P
		BEGIN

		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)	

		--PRINT 'CON DETALLE'
		
		select  @MES AS MES, @AÑO AS AÑO,		
		'INGRESADOS' AS TIPO, NOMBRE_PRODUCTO,
		NRO_EXPEDIENTE,
		B.NOM_OFIC,
		B.NOM_TERRITORIO,		
	    count(distinct NRO_EXPEDIENTE) AS CANTIDAD_EXPEDIENTES
		
		from TB_CS A LEFT JOIN TB_CS_TERRITORIO B
		ON A.CODIGO_OFICINA_GESTORA = B.COD_OFI

		where NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
		CONVERT (date, FECHA_HORA_ENVIO)>= @FECHA_INICIO and 
		CONVERT (date, FECHA_HORA_ENVIO)<= @FECHA_FIN and 
		ESTADO_EXPEDIENTE='Expediente registrado'
		group by NOMBRE_PRODUCTO, NRO_EXPEDIENTE, B.NOM_TERRITORIO,B.NOM_OFIC


		UNION ALL 


		select  @MES AS MES, @AÑO AS AÑO,		
		'MESA DE CONTROL' AS TIPO, NOMBRE_PRODUCTO,
		NRO_EXPEDIENTE,
		B.NOM_OFIC,
		B.NOM_TERRITORIO,		
	    count(distinct NRO_EXPEDIENTE) AS CANTIDAD_EXPEDIENTES
		
		from TB_CS A LEFT JOIN TB_CS_TERRITORIO B
		ON A.CODIGO_OFICINA_GESTORA = B.COD_OFI

		where NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
		CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) >= @FECHA_INICIO and 
			  CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) <= @FECHA_FIN and 
			  CONVERT (date, FECHA_HORA_ENVIO) >= @FECHA_INICIO and 
			  CONVERT (date, FECHA_HORA_ENVIO) <= @FECHA_FIN and 
			  PERFIL='MESA DE CONTROL'
		group by NOMBRE_PRODUCTO, NRO_EXPEDIENTE, B.NOM_TERRITORIO,B.NOM_OFIC


		UNION ALL 


		select  @MES AS MES, @AÑO AS AÑO,		
		'ANALISIS Y ALTA' AS TIPO, NOMBRE_PRODUCTO,
		NRO_EXPEDIENTE,
		B.NOM_OFIC,
		B.NOM_TERRITORIO,		
	    count(distinct NRO_EXPEDIENTE) AS CANTIDAD_EXPEDIENTES
		
		from TB_CS A LEFT JOIN TB_CS_TERRITORIO B
		ON A.CODIGO_OFICINA_GESTORA = B.COD_OFI

		where NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
		CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) >= @FECHA_INICIO and 
			  CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) <= @FECHA_FIN and 
			  CONVERT (date, FECHA_HORA_ENVIO) >= @FECHA_INICIO and 
			  CONVERT (date, FECHA_HORA_ENVIO) <= @FECHA_FIN and 
			  PERFIL='ANALISIS Y ALTA'
		group by NOMBRE_PRODUCTO, NRO_EXPEDIENTE, B.NOM_TERRITORIO,B.NOM_OFIC


		UNION ALL 


		select  @MES AS MES, @AÑO AS AÑO,		
		'CONTROLLER' AS TIPO, NOMBRE_PRODUCTO,
		NRO_EXPEDIENTE,
		B.NOM_OFIC,
		B.NOM_TERRITORIO,		
	    count(distinct NRO_EXPEDIENTE) AS CANTIDAD_EXPEDIENTES
		
		from TB_CS A LEFT JOIN TB_CS_TERRITORIO B
		ON A.CODIGO_OFICINA_GESTORA = B.COD_OFI

		where NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
		CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) >= @FECHA_INICIO and 
			  CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) <= @FECHA_FIN and 
			  CONVERT (date, FECHA_HORA_ENVIO) >= @FECHA_INICIO and 
			  CONVERT (date, FECHA_HORA_ENVIO) <= @FECHA_FIN and 
			  PERFIL='CONTROLLER'
		group by NOMBRE_PRODUCTO, NRO_EXPEDIENTE, B.NOM_TERRITORIO,B.NOM_OFIC


		UNION ALL 


		select  @MES AS MES, @AÑO AS AÑO,		
		'DESEMBOLSO' AS TIPO, NOMBRE_PRODUCTO,
		NRO_EXPEDIENTE,
		B.NOM_OFIC,
		B.NOM_TERRITORIO,		
	    count(distinct NRO_EXPEDIENTE) AS CANTIDAD_EXPEDIENTES
		
		from TB_CS A LEFT JOIN TB_CS_TERRITORIO B
		ON A.CODIGO_OFICINA_GESTORA = B.COD_OFI

		where NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
		CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) >= @FECHA_INICIO and 
			  CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) <= @FECHA_FIN and 
			  CONVERT (date, FECHA_HORA_ENVIO) >= @FECHA_INICIO and 
			  CONVERT (date, FECHA_HORA_ENVIO) <= @FECHA_FIN and 
			  ESTADO_EXPEDIENTE='Desembolsado / En Embose'
		group by NOMBRE_PRODUCTO, NRO_EXPEDIENTE, B.NOM_TERRITORIO,B.NOM_OFIC


		UNION ALL 


		select  @MES AS MES, @AÑO AS AÑO,		
		'RECHAZADOS' AS TIPO, NOMBRE_PRODUCTO,
		NRO_EXPEDIENTE,
		B.NOM_OFIC,
		B.NOM_TERRITORIO,		
	    count(distinct NRO_EXPEDIENTE) AS CANTIDAD_EXPEDIENTES
		
		from TB_CS A LEFT JOIN TB_CS_TERRITORIO B
		ON A.CODIGO_OFICINA_GESTORA = B.COD_OFI

		where NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
		CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) >= @FECHA_INICIO and 
			  CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) <= @FECHA_FIN and 
			  CONVERT (date, FECHA_HORA_ENVIO) >= @FECHA_INICIO and 
			  CONVERT (date, FECHA_HORA_ENVIO) <= @FECHA_FIN and 
			  ESTADO_EXPEDIENTE='RECHAZADO'
		group by NOMBRE_PRODUCTO, NRO_EXPEDIENTE, B.NOM_TERRITORIO,B.NOM_OFIC



		UNION ALL 


		select  @MES AS MES, @AÑO AS AÑO,		
		'REPROCESADOS' AS TIPO, NOMBRE_PRODUCTO,
		NRO_EXPEDIENTE,
		B.NOM_OFIC,
		B.NOM_TERRITORIO,		
	    count(distinct NRO_EXPEDIENTE) AS CANTIDAD_EXPEDIENTES
		
		from TB_CS A LEFT JOIN TB_CS_TERRITORIO B
		ON A.CODIGO_OFICINA_GESTORA = B.COD_OFI

		where NOMBRE_PRODUCTO = @PRODUCTO_NAME AND
		CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) >= @FECHA_INICIO and 
			  CONVERT (date, dbo.FN_CALCULAR_FUNNEL(NRO_EXPEDIENTE)) <= @FECHA_FIN and 
			  CONVERT (date, FECHA_HORA_ENVIO) >= @FECHA_INICIO and 
			  CONVERT (date, FECHA_HORA_ENVIO) <= @FECHA_FIN and 
			  accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
		group by NOMBRE_PRODUCTO, NRO_EXPEDIENTE, B.NOM_TERRITORIO,B.NOM_OFIC

		SET @CONT_P = @CONT_P+1
		END		

END
-----SELECT * FROM PLD_TC_CONVENIO_FUNNEL_ACUMULADO

END



GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_HISTOGRAMAS_CS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 2020/02/04
-- Description:	Procedure para sacar los histogramas de Desembolso Mensual
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_HISTOGRAMAS_CS]
(
@tipo varchar(500),
@MES int,
@AÑO int
)
AS
BEGIN

DECLARE @fecha_ini DATE;
DECLARE @fecha_FIN DATE;

set @fecha_ini = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial

set @fecha_FIN = (SELECT MAX(FECHA_HORA_ENVIO) 
						FROM TB_CS
						WHERE MONTH (FECHA_HORA_ENVIO) = @MES
						AND YEAR(FECHA_HORA_ENVIO) = @AÑO)


if @tipo='TC_HISTORAL_LAB_MAX' 

	BEGIN
		--PRINT @fecha_ini
		--PRINT @fecha_FIN

	--****************REPROCESAR*****************************
	DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_MAX
	WHERE FECHA = @fecha_FIN

	PRINT 'DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_MAX
	WHERE FECHA = ' + CONVERT(VARCHAR,@fecha_FIN) + ' '
	--****************REPROCESAR*****************************

	SELECT NRO_EXPEDIENTE, FECHA_HORA_ENVIO
	INTO #CALCULAR_DESEMBOLSO  --------->>> Reemplaza FN.CALCULAR_DESEMBOLSO
	FROM TB_CS
	WHERE ESTADO_EXPEDIENTE = 'Expediente Registrado'
	--and CONVERT (date, FECHA_HORA_ENVIO)>=@fecha_ini --->>> PORSIACA LOS HISTOGRAMAS SEAN DEL MES 
	--and CONVERT (date, FECHA_HORA_ENVIO)<=@fecha_FIN


		insert into PLD_TC_CONVENIO_HISTORAL_LAB_MAX
		SELECT 
		NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA, 
		MAX (CEILING ([dbo].[fn_tiempo_horas] (D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO))),
		@fecha_FIN
		from  TB_CS C INNER JOIN #CALCULAR_DESEMBOLSO D
		ON C.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
		WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE')
		AND ACCION!='GRABAR' 
		and   CONVERT (date, C.FECHA_HORA_ENVIO)>=  @fecha_ini
		and   CONVERT (date, C.FECHA_HORA_ENVIO)<=  @fecha_FIN
		--and NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD' and NOMBRE_TIPO_OFERTA = 'APROBADO'
		group by NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA
		ORDER BY NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA


		DROP TABLE #CALCULAR_DESEMBOLSO

	END

if @tipo='TC_HISTORAL_LAB' 

	BEGIN

	--considera asi los dias
	--0 a 1.00000 es un 1 día
	--1.001 a 1.99999 es 2 dias
	--2.00 a 2.9999 es 3 dias

	--ceiling(x): redondea hacia arriba el argumento "x". Ejemplo:
	-- select ceiling(12.34);
	--retorna 13.
	---floor(x): redondea hacia abajo el argumento "x". Ejemplo:
	-- select floor(12.34);
	--retorna 12.

	--****************REPROCESAR*****************************
			--DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB
			--WHERE FECHA = @fecha_FIN

			--PRINT 'DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB
			--WHERE FECHA = ' + CONVERT(VARCHAR,@fecha_FIN) + ''
	--****************REPROCESAR*****************************


	SELECT NRO_EXPEDIENTE, FECHA_HORA_ENVIO
	INTO #CALCULAR_DESEMBOLSO2  --------->>> Reemplaza FN.CALCULAR_DESEMBOLSO
	FROM TB_CS
	WHERE ESTADO_EXPEDIENTE = 'Expediente Registrado'


	insert into PLD_TC_CONVENIO_HISTORAL_LAB
	select 
	NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA, CONVERT(date,C.FECHA_HORA_ENVIO),
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) = 1 then 1 end) as '1',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) in (2) then 1 end) as '2',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) in (3) then 1 end) as '3',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) in (4) then 1 end) as '4',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) in (5) then 1 end) as '5',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) =6 then 1 end) as '6',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) =7 then 1 end) as '7',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) =8 then 1 end) as '8',
	count(case when ceiling([dbo].[fn_tiempo_horas](D.FECHA_HORA_ENVIO,C.FECHA_HORA_ENVIO)) >=9 then 1 end) as '9',
	@fecha_FIN

	from  TB_CS C INNER JOIN #CALCULAR_DESEMBOLSO2 D
	ON C.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
	WHERE ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE'	AND ACCION!='GRABAR' 
	and   CONVERT (date, C.FECHA_HORA_ENVIO)>=@fecha_ini
	and   CONVERT (date, C.FECHA_HORA_ENVIO)<=@fecha_FIN
	----and NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD' 
	----and NOMBRE_TIPO_OFERTA = 'APROBADO'
	group by NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA, CONVERT (date, C.FECHA_HORA_ENVIO)
	ORDER BY NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA, CONVERT (date, C.FECHA_HORA_ENVIO)

-----------------------------------------------------------------
-----------------------------------------------------------------//GRAFICOS
DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH
WHERE FECHA = @fecha_FIN
------------------------------------// WHILE OFERTAS
	DECLARE @CONT_O INT = 1;
	DECLARE @CONTMAX_O INT;	
	DECLARE @ID_O INT = 1; 
	DECLARE @OFERTA_NAME VARCHAR(65);

	------------------------------------// WHILE PRODUCTOS
	DECLARE @CONT_P INT = 1;
	DECLARE @CONTMAX_P INT;	
	DECLARE @ID_P INT = 1; 
	DECLARE @PRODUCTO_NAME VARCHAR(65);
	------------------------------------// WHILLE CALCULOS
	DECLARE @TOTALF INT;

	DECLARE @CONT INT = 1;
	DECLARE @CONTMAX INT;	
	DECLARE @ID_INCREMENTO INT = 1; 

		
CREATE TABLE #PRODUCTOS
		(	
			cod int identity(1,1) not null,	
			producto varchar(65)			
		)

CREATE TABLE #OFERTAS
		(
			cod_of int identity(1,1) not null,
			nombre_oferta varchar(65)
		)

INSERT INTO #OFERTAS
values ('MES')


SET @CONTMAX_O  = (SELECT COUNT(cod_of) FROM #OFERTAS);	
--//-------------------------------------------------------- WHILE PARA PRODUCTOS

WHILE @CONT_O <= @CONTMAX_O

	BEGIN

	SET @OFERTA_NAME = (SELECT nombre_oferta FROM #OFERTAS WHERE cod_of=@CONT_O) 

				insert into #PRODUCTOS
				select distinct NOMBRE_PRODUCTO 
				from PLD_TC_CONVENIO_HISTORAL_LAB
	
				SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)

				WHILE @CONT_P <= @CONTMAX_P

				BEGIN 

				SET @CONT = 1;		
				SET @ID_INCREMENTO = 1; 
				SET @TOTALF = 0;

				SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)	

				--//--------------------------------------------------------
				CREATE TABLE #F
				(
					id int identity(1,1) not null,	
					nomb_prod varchar(65),
					tipo varchar(30),
					rango varchar(50),
					F int,
					FT int
				)			
						--------------------------------------------//NOMBRE_PRODUCTO, RANGO, F, FT
				insert into #F
				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '0-1' AS RANGO,						
				ISNULL(SUM(dia1),0) AS F,	
				ISNULL(SUM(dia1),0) AS FT
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN 
				GROUP BY NOMBRE_PRODUCTO

				UNION ALL			

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '1-2' AS RANGO,			
				ISNULL(SUM(dia2),0) AS F, 			
				ISNULL(SUM(dia1) + SUM(dia2),0) AS FT			

				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				GROUP BY NOMBRE_PRODUCTO

				UNION ALL

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '2-3' AS RANGO,			
				ISNULL(SUM(dia3),0) AS F, 					
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3),0) AS FT			
						
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				GROUP BY NOMBRE_PRODUCTO

				UNION ALL 

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '3-4' AS RANGO,			
				ISNULL(SUM(dia4),0) AS F, 		
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3) + SUM(dia4) ,0) AS FT				
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				GROUP BY NOMBRE_PRODUCTO


				UNION ALL 

				select  
				NOMBRE_PRODUCTO,  @OFERTA_NAME, '4-5' AS RANGO,			
				ISNULL(SUM(dia5),0) AS F,
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3) + SUM(dia4) + SUM(dia5) ,0) AS FT				 			
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				GROUP BY NOMBRE_PRODUCTO


				UNION ALL 

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '5-6' AS RANGO,			
				ISNULL(SUM(dia6),0) AS F, 		
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3) + SUM(dia4) + SUM(dia5) + SUM(dia6) ,0) AS FT			
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				GROUP BY NOMBRE_PRODUCTO

			
						-------------------------------------------------------------SELECT * FROM #F	
						---------------------------------------------------------------		
					SET @TOTALF = (SELECT sum(F) FROM #F)				

					CREATE TABLE #H
					(	
						idh int identity(1,1) not null,	
						H decimal(10,2)			
					)
					--//--------------------------------------------------------
					CREATE TABLE #HT
					(	
						idht int identity(1,1) not null,	
						HT decimal(10,2)			
					)
					CREATE TABLE #HTF
					(	
						idhtf int identity(1,1) not null,	
						HTF decimal(10,2)		
					)
					-----------------//
					CREATE TABLE #H_FINAL
					(	
						idfinal int identity(1,1) not null,	
						hfinal decimal(10,2),
						htffinal decimal(10,2)			
					)
				----------------------------------------------------//H

				SET @CONTMAX = (SELECT COUNT(id) FROM #F)

				WHILE @CONT <= @CONTMAX
		
					BEGIN

						SET @ID_INCREMENTO = (SELECT id FROM #F WHERE Id=@CONT)

								insert into #H
								select cast(F * 100/ ISNULL(NULLIF(CONVERT(DECIMAL(10,2),@TOTALF),0),1) AS decimal (18,2)) AS PORCENTAJE
								from #F 
								where id = @ID_INCREMENTO
								group by F		
				
						SET @CONT=@CONT+1
					END	
		
				--//--------------------------------------  HT

				SET  @ID_INCREMENTO = 1;
				SET	 @CONT = 1;

				----PRINT CONVERT(VARCHAR, @CONT) + ' ---------- CONTADOR'

				WHILE @CONT <= 5
				
					BEGIN
						SET @ID_INCREMENTO = (SELECT idh FROM #H WHERE idh=@CONT)

								insert into #HT					
								select sum(case when idh  <= @ID_INCREMENTO  then ISNULL(NULLIF(H,0),1) else 0 end)
								from #H				
				
						SET @CONT=@CONT+1
					END		

					insert into #HTF
					select HT
					from #HT
					union all
					select sum(h)
					from #H 			
			
					--------------------------------// 
					--select * from #H 		
					--select * from #HT 		
					--select * from #HTF
					--------------------------------// 

					INSERT INTO #H_FINAL
					SELECT H, HTF
					FROM #H	FULL OUTER JOIN #HTF
					ON #H.idh = #HTF.idhtf

					--------------------------------// UNION DE F + H_FINAL

					insert into PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH
					SELECT #F.nomb_prod, #F.tipo, #F.rango, #F.F,#F.FT, #H_FINAL.hfinal, #H_FINAL.htffinal, @fecha_FIN
					FROM #F	FULL OUTER JOIN #H_FINAL
					ON #F.id = #H_FINAL.idfinal			
					---------------------------------------------------------------
					---------------------------------------------------------------			
					drop table #F
					drop table #H
					drop table #HT
					drop table #HTF
					drop table #H_FINAL

				SET @CONT_P = @CONT_P+1
			END -- END WHILE PRODUCTOS
			
			SET @CONT_O = @CONT_O+1
		END -- END WHILE OFERTAS

	END -- END IF (@tipo='TC_HISTORAL_LAB')


END -- end procedure

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_HISTOGRAMAS_CS_OFERTA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 2020/02/10
-- Description:	Procedure para sacar los histogramas de Desembolso, Oferta Aprobada y Oferta Regular.
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_HISTOGRAMAS_CS_OFERTA] 
(
@tipo varchar(500),
@MES int,
@AÑO int
)
AS

BEGIN

DECLARE @fecha_ini DATE;
DECLARE @fecha_FIN DATE;

set @fecha_ini = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial

set @fecha_FIN = (SELECT MAX(FECHA_HORA_ENVIO) 
						FROM TB_CS						
						WHERE MONTH (FECHA_HORA_ENVIO) = @MES
						AND YEAR(FECHA_HORA_ENVIO) = @AÑO)



if @tipo='TC_HISTORAL_LAB_MAX' 

	BEGIN
		PRINT @fecha_ini
		PRINT @fecha_FIN

		----****************REPROCESAR*****************************
		--	DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_MAX
		--	WHERE FECHA = @fecha_FIN

		--	PRINT 'DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_MAX
		--	WHERE FECHA = ' + CONVERT(VARCHAR,@fecha_FIN) + ' '
		----****************REPROCESAR*****************************


	
	END


if @tipo='TC_HISTORAL_LAB' 

	BEGIN

	----****************REPROCESAR*****************************
			DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH
			WHERE FECHA = @fecha_FIN and TIPO IN ('APROBADO','REGULAR')					

			DELETE FROM  PLD_TC_CONVENIO_REPROCESOS_GRAPH
			WHERE fecha_proceso = @fecha_FIN

			--PRINT 'DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH
			--WHERE FECHA = ' + CONVERT(VARCHAR,@fecha_FIN) + ' AND OFERTAS APROBADO Y REGULAR'
	----****************REPROCESAR*****************************
	------considera asi los dias
	------0 a 1.00000 es un 1 día
	------1.001 a 1.99999 es 2 dias
	------2.00 a 2.9999 es 3 dias

	------ceiling(x): redondea hacia arriba el argumento "x". Ejemplo:
	------ select ceiling(12.34);
	------retorna 13.
	-------floor(x): redondea hacia abajo el argumento "x". Ejemplo:
	------ select floor(12.34);
	------retorna 12.
-----------------------------------------------------------------
-----------------------------------------------------------------//GRAFICOS
------------------------------------// WHILE OFERTAS
	DECLARE @CONT_O INT = 1;
	DECLARE @CONTMAX_O INT;	
	DECLARE @ID_O INT = 1; 
	DECLARE @OFERTA_NAME VARCHAR(65);

	------------------------------------// WHILE PRODUCTOS
	DECLARE @CONT_P INT = 1;
	DECLARE @CONTMAX_P INT;	
	DECLARE @ID_P INT = 1; 
	DECLARE @PRODUCTO_NAME VARCHAR(65);
	------------------------------------// WHILE CALCULOS
	DECLARE @TOTALF INT;

	DECLARE @CONT INT = 1;
	DECLARE @CONTMAX INT;	
	DECLARE @ID_INCREMENTO INT = 1; 

		
CREATE TABLE #PRODUCTOS
		(	
			cod int identity(1,1) not null,	
			producto varchar(65)			
		)

CREATE TABLE #OFERTAS
		(
			cod_of int identity(1,1) not null,
			nombre_oferta varchar(65)
		)

INSERT INTO #OFERTAS
values ('APROBADO')


INSERT INTO #OFERTAS
values ('REGULAR')


SET @CONTMAX_O  = (SELECT COUNT(cod_of) FROM #OFERTAS);	
--//-------------------------------------------------------- WHILE PARA PRODUCTOS

WHILE @CONT_O <= @CONTMAX_O

	BEGIN

	SET @OFERTA_NAME = (SELECT nombre_oferta FROM #OFERTAS WHERE cod_of=@CONT_O) 

				insert into #PRODUCTOS
				select distinct NOMBRE_PRODUCTO 
				from PLD_TC_CONVENIO_HISTORAL_LAB
	
				SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)

				WHILE @CONT_P <= @CONTMAX_P

					BEGIN 

					SET @CONT = 1;		
					SET @ID_INCREMENTO = 1; 
					SET @TOTALF = 0;

					SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)	

					--//--------------------------------------------------------
					CREATE TABLE #F
					(
						id int identity(1,1) not null,	
						nomb_prod varchar(65),
						tipo varchar(30),
						rango varchar(50),
						F int,
						FT int
					)			
						--------------------------------------------//NOMBRE_PRODUCTO, RANGO, F, FT
				insert into #F

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '0-1' AS RANGO,						
				ISNULL(SUM(dia1),0) AS F,	
				ISNULL(SUM(dia1),0) AS FT
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN 
				AND NOMBRE_TIPO_OFERTA = @OFERTA_NAME
				GROUP BY NOMBRE_PRODUCTO

				UNION ALL			

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '1-2' AS RANGO,			
				ISNULL(SUM(dia2),0) AS F, 			
				ISNULL(SUM(dia1) + SUM(dia2),0) AS FT			

				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				AND NOMBRE_TIPO_OFERTA = @OFERTA_NAME
				GROUP BY NOMBRE_PRODUCTO

				UNION ALL

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '2-3' AS RANGO,			
				ISNULL(SUM(dia3),0) AS F, 					
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3),0) AS FT			

				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				AND NOMBRE_TIPO_OFERTA = @OFERTA_NAME
				GROUP BY NOMBRE_PRODUCTO

				UNION ALL 

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '3-4' AS RANGO,			
				ISNULL(SUM(dia4),0) AS F, 		
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3) + SUM(dia4) ,0) AS FT				
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				AND NOMBRE_TIPO_OFERTA = @OFERTA_NAME
				GROUP BY NOMBRE_PRODUCTO


				UNION ALL 

				select  
				NOMBRE_PRODUCTO,  @OFERTA_NAME, '4-5' AS RANGO,			
				ISNULL(SUM(dia5),0) AS F,
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3) + SUM(dia4) + SUM(dia5) ,0) AS FT				 			
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				AND NOMBRE_TIPO_OFERTA = @OFERTA_NAME
				GROUP BY NOMBRE_PRODUCTO


				UNION ALL 

				select  
				NOMBRE_PRODUCTO, @OFERTA_NAME,  '5-6' AS RANGO,			
				ISNULL(SUM(dia6),0) AS F, 		
				ISNULL(SUM(dia1) + SUM(dia2) + SUM(dia3) + SUM(dia4) + SUM(dia5) + SUM(dia6) ,0) AS FT			
			
				FROM PLD_TC_CONVENIO_HISTORAL_LAB
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND FECHA = @fecha_FIN
				AND NOMBRE_TIPO_OFERTA = @OFERTA_NAME
				GROUP BY NOMBRE_PRODUCTO
							
					---------------------------------------SELECT * FROM #F	
					-----------------------------------------		
				SET @TOTALF = (SELECT sum(F) FROM #F)				

				CREATE TABLE #H
				(	
					idh int identity(1,1) not null,	
					H decimal(10,2)			
				)
				--//--------------------------------------------------------
				CREATE TABLE #HT
				(	
					idht int identity(1,1) not null,	
					HT decimal(10,2)			
				)
				CREATE TABLE #HTF
				(	
					idhtf int identity(1,1) not null,	
					HTF decimal(10,2)		
				)
				-----------------//
				CREATE TABLE #H_FINAL
				(	
					idfinal int identity(1,1) not null,	
					hfinal decimal(10,2),
					htffinal decimal(10,2)			
				)

				----------------------------------------------------//H

			SET @CONTMAX = (SELECT COUNT(id) FROM #F)
			WHILE @CONT <= @CONTMAX		
				BEGIN
					SET @ID_INCREMENTO = (SELECT id FROM #F WHERE Id=@CONT)

					insert into #H
					select cast(F * 100/ ISNULL(NULLIF(CONVERT(DECIMAL(10,2),@TOTALF),0),1) AS decimal (18,2)) AS PORCENTAJE
					from #F 
					where id = @ID_INCREMENTO
					group by F		
				
					SET @CONT=@CONT+1
				END	
		
				--//--------------------------------------  HT

				SET  @ID_INCREMENTO = 1;
				SET	 @CONT = 1;

				----PRINT CONVERT(VARCHAR, @CONT) + ' ---------- CONTADOR'

				WHILE @CONT <= 5
				
				BEGIN
					SET @ID_INCREMENTO = (SELECT idh FROM #H WHERE idh=@CONT)

							insert into #HT					
							select sum(case when idh  <= @ID_INCREMENTO  then ISNULL(NULLIF(H,0),1) else 0 end)
							from #H				
				
					SET @CONT=@CONT+1
				END		

				insert into #HTF
				select HT
				from #HT
				union all
				select sum(h)
				from #H 			
			
				--------------------------------// 
				--select * from #H 		
				--select * from #HT 		
				--select * from #HTF
				--------------------------------// 

				INSERT INTO #H_FINAL
				SELECT H, HTF
				FROM #H	FULL OUTER JOIN #HTF
				ON #H.idh = #HTF.idhtf

				--------------------------------// UNION DE F + H_FINAL

				insert into PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH
				SELECT #F.nomb_prod, #F.tipo, #F.rango, #F.F,#F.FT, #H_FINAL.hfinal, #H_FINAL.htffinal, @fecha_FIN
				FROM #F	FULL OUTER JOIN #H_FINAL
				ON #F.id = #H_FINAL.idfinal
			
				---------------------------------------------------------------
				---------------------------------------------------------------	
				drop table #F
				drop table #H
				drop table #HT
				drop table #HTF
				drop table #H_FINAL

---------------------------------//DIAGRAMA CONTROL: PORCENTAJE DE REPROCESO DIARIO				
DELETE FROM PLD_TC_CONVENIO_REPROCESOS_GRAPH
WHERE nombre_producto = @PRODUCTO_NAME
AND fecha_proceso = @fecha_FIN

		;with Reprocesos as (
			SELECT 
				   dia1 as dia1,
				   dia2 as dia2,
				   dia3 as dia3,
				   dia4 as dia4,
				   dia5 as dia5,
				   dia6 as dia6,
				   dia7 as dia7,
				   dia8 as dia8,
				   dia9 as dia9, 
				   dia10 as dia10,
				   dia11 as dia11,
				   dia12 as dia12,
				   dia13 as dia13,
				   dia14 as dia14,
				   dia15 as dia15,
				   dia16 as dia16,
				   dia17 as dia17,
				   dia18 as dia18,
				   dia19 as dia19,
				   dia20 as dia20,
				   dia21 as dia21,
				   dia22 as dia22,      
				   dia23 as dia23,      
				   dia24 as dia24,      
				   dia25 as dia25,      
				   dia26 as dia26,      
				   dia27 as dia27,      
				   dia28 as dia28,      
				   dia29 as dia29,      
				   dia30 as dia30,      
				   dia31 as dia31      
				        
			  from PLD_TC_CONVENIO
			  WHERE producto = @PRODUCTO_NAME
			AND descripcion = '% REPROCESOS-DIA'
			AND fecha_proceso = @fecha_FIN
			)
insert into PLD_TC_CONVENIO_REPROCESOS_GRAPH
SELECT  @PRODUCTO_NAME as nombre_producto, dias, valor_dias, 50 as valorObjetivo, 
		@fecha_FIN as fecha_proceso
  FROM Reprocesos
	unpivot (valor_dias for dias in (dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,
	dia14, dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,dia25,dia26,dia27,dia28,dia29,dia30,dia31)) as U


	---------------------------------//DIAGRAMA CONTROL: CANTIDAD DE REPROCESO DIARIO (TOTAL)
DELETE FROM PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH
WHERE nombre_producto = @PRODUCTO_NAME
AND CONVERT(DATE,fecha_proceso) = CONVERT(DATE, @fecha_FIN)

			;with ReprocesosCant as (
			SELECT 
				   dia1 as dia1,
				   dia2 as dia2,
				   dia3 as dia3,
				   dia4 as dia4,
				   dia5 as dia5,
				   dia6 as dia6,
				   dia7 as dia7,
				   dia8 as dia8,
				   dia9 as dia9, 
				   dia10 as dia10,
				   dia11 as dia11,
				   dia12 as dia12,
				   dia13 as dia13,
				   dia14 as dia14,
				   dia15 as dia15,
				   dia16 as dia16,
				   dia17 as dia17,
				   dia18 as dia18,
				   dia19 as dia19,
				   dia20 as dia20,
				   dia21 as dia21,
				   dia22 as dia22,      
				   dia23 as dia23,      
				   dia24 as dia24,      
				   dia25 as dia25,      
				   dia26 as dia26,      
				   dia27 as dia27,      
				   dia28 as dia28,      
				   dia29 as dia29,      
				   dia30 as dia30,      
				   dia31 as dia31      
				        
			  from PLD_TC_CONVENIO
			  WHERE producto = @PRODUCTO_NAME
			AND descripcion = 'EXP.REPROCESOS-TOTAL'
			AND fecha_proceso = @fecha_FIN
			)

insert into PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH
SELECT  @PRODUCTO_NAME as nombre_producto, dias, valor_dias, 50 as valorObjetivo, 
		@fecha_FIN as fecha_proceso
  FROM ReprocesosCant
	unpivot (valor_dias for dias in (dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,
	dia14, dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,dia25,dia26,dia27,dia28,dia29,dia30,dia31)) as O


				SET @CONT_P = @CONT_P+1
			END -- END WHILE PRODUCTOS
			
			SET @CONT_O = @CONT_O+1
		END -- END WHILE OFERTAS

		DELETE FROM PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH 
		WHERE NOMBRE_PRODUCTO IS NULL

	END -- END IF (@tipo='TC_HISTORAL_LAB')

END

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 2020/02/10
-- Description:	Procedure para contar y sacar la cantidad de reprocesados y sacar los graficos de pareto de reprocesos.
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS] 
(
@MES int,
@AÑO int
)
AS

BEGIN


DECLARE @fecha_ini DATE;
DECLARE @fecha_FIN DATE;

	--------------------------------// WHILE PRODUCTOS
	DECLARE @CONT_P INT = 1;
	DECLARE @CONTMAX_P INT;	
	DECLARE @ID_P INT = 1; 
	DECLARE @PRODUCTO_NAME VARCHAR(65);


	------------------------------------// WHILE CALCULOS
	DECLARE @TOTALF INT;

	DECLARE @CONT INT = 1;
	DECLARE @CONTMAX INT;	
	DECLARE @ID_INCREMENTO INT = 1; 	



	CREATE TABLE #PRODUCTOS
		(	
			cod int identity(1,1) not null,	
			producto varchar(65)			
		)

	CREATE TABLE #resultados_reprocesos(
			[codigo] [int] IDENTITY(1,1) NOT NULL,
			[producto] [varchar](40) NULL,
			[cant_reprocesos] [int] NULL,
			[cant_expedientes] [int] NULL
		) 


set @fecha_ini = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial

set @fecha_FIN = (SELECT MAX(FECHA_HORA_ENVIO) 
						FROM TB_CS
						WHERE MONTH (FECHA_HORA_ENVIO) = @MES
						AND YEAR(FECHA_HORA_ENVIO) = @AÑO)


----****************REPROCESAR*****************************
DELETE FROM [PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS]
WHERE FECHA = @fecha_FIN

PRINT 'DELETE FROM [PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS]
WHERE FECHA = ' + CONVERT(VARCHAR,@fecha_FIN) + ' '
----****************REPROCESAR*******************************

------------------------------------// WHILE PRODUCTOS
insert into #PRODUCTOS
select distinct NOMBRE_PRODUCTO 
from PLD_TC_CONVENIO_HISTORAL_LAB


SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)
WHILE @CONT_P <= @CONTMAX_P

	BEGIN

	SET @CONT = 1;		
	SET @ID_INCREMENTO = 1; 
	SET @TOTALF = 0;

	SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)	
	-----------------------------/////

	select nro_expediente as nro_expediente, FECHA_HORA_ENVIO
	into #parte1
	from TB_CS	 
	where NOMBRE_PRODUCTO = @PRODUCTO_NAME and	 	 
	ESTADO_EXPEDIENTE='Expediente registrado' 
	and month(FECHA_HORA_ENVIO) = @MES
	and year(FECHA_HORA_ENVIO) = @AÑO

	 ---------------------------/////

	select distinct c.nro_expediente as expediente,c.NOMBRE_PRODUCTO as producto,
	count(c.NRO_EXPEDIENTE) AS REPROCESOS
	into #parte2
	FROM TB_CS c INNER JOIN #parte1 p
	on c.NRO_EXPEDIENTE = p.nro_expediente	 
	where CONVERT (DATE,p.FECHA_HORA_ENVIO) = CONVERT (DATE,C.FECHA_HORA_ENVIO)
	and ACCION IN ('devolver','no_conforme','OBSERVAR_VERIFICACION', 'SOLICITAR_ACTUALIZACION_SCORING', 'APROBADO_CON_MOD_OBS')
	and month(C.FECHA_HORA_ENVIO) = @MES
	and year(C.FECHA_HORA_ENVIO) = @AÑO
	and c.NOMBRE_PRODUCTO = @PRODUCTO_NAME
	GROUP BY c.NRO_EXPEDIENTE, CONVERT(DATE,p.FECHA_HORA_ENVIO), c.NOMBRE_PRODUCTO
	ORDER BY REPROCESOS 

	  ---------------------------/////
	 
	insert into #resultados_reprocesos
	select  producto, reprocesos as 'Cantidad reprocesos' , 
	count(reprocesos) as 'Cantidad de Expedientes'
	from #parte2
	group by reprocesos, producto
	order by 1,2
	
	drop table #parte1
	drop table #parte2

	---------------------------/////
		CREATE TABLE #F
		(
			id int identity(1,1) not null,	
			nomb_prod varchar(65),			
			rango varchar(50),
			F int,
			FT int
		)	


		---------------------------/////
		INSERT INTO #F
		select  
		------ROW_NUMBER() OVER(ORDER BY cant_reprocesos) as col,
		producto,  cant_reprocesos,						
		ISNULL(cant_expedientes,0) AS F,	
		ISNULL(sum(cant_expedientes) over (order by cant_reprocesos asc),0) AS FT
									
		FROM #resultados_reprocesos

		WHERE producto = @PRODUCTO_NAME					
		GROUP BY producto,cant_expedientes,cant_reprocesos						

			SET @TOTALF = (SELECT sum(F) FROM #F WHERE nomb_prod = @PRODUCTO_NAME)				
						
							
			CREATE TABLE #H
			(	
				idh int identity(1,1) not null,	
				H decimal(10,2)			
			)
			--//--------------------------------------------------------
			CREATE TABLE #HT
			(	
				idht int identity(1,1) not null,	
				HT decimal(10,2)			
			)
			CREATE TABLE #HTF
			(	
				idhtf int identity(1,1) not null,	
				HTF decimal(10,2)		
			)
			-----------------//
			CREATE TABLE #H_FINAL
			(	
				idfinal int identity(1,1) not null,	
				hfinal decimal(10,2),
				htffinal decimal(10,2)			
			)

		---------------------------------------------------//H
		SET @CONTMAX = (SELECT COUNT(id) FROM #F)

		WHILE @CONT <= @CONTMAX
		
			BEGIN

				SET @ID_INCREMENTO = (SELECT id FROM #F WHERE Id=@CONT)

				insert into #H
				select cast(F * 100/ ISNULL(NULLIF(CONVERT(DECIMAL(10,2),@TOTALF),0),1) AS decimal (18,2)) AS PORCENTAJE
				from #F 
				where id = @ID_INCREMENTO
				group by F		
				
				SET @CONT=@CONT+1
			END	
			----------------------------------------  HT
			SET  @ID_INCREMENTO = 1;
			SET	 @CONT = 1;

				----PRINT CONVERT(VARCHAR, @CONT) + ' ---------- CONTADOR'

				WHILE @CONT <= 5				
					BEGIN
						SET @ID_INCREMENTO = (SELECT idh FROM #H WHERE idh=@CONT)

						insert into #HT					
						select sum(case when idh  <= @ID_INCREMENTO  then ISNULL(NULLIF(H,0),1) else 0 end)
						from #H				
				
						SET @CONT=@CONT+1
					END		

			insert into #HTF
			select HT
			from #HT
			union all
			select sum(h)
			from #H 			
			
			--------------------------------// 
			--------select * from #H 		
			--------select * from #HT 		
			--------select * from #HTF
			--------------------------------// 

			INSERT INTO #H_FINAL
			SELECT H, HTF
			FROM #H	FULL OUTER JOIN #HTF
			ON #H.idh = #HTF.idhtf

			--------------------------------// UNION DE F + H_FINAL

			insert into PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS

			SELECT #F.nomb_prod, #F.rango, #F.F,#F.FT, #H_FINAL.hfinal, #H_FINAL.htffinal, @fecha_FIN

			FROM #F	FULL OUTER JOIN #H_FINAL
			ON #F.id = #H_FINAL.idfinal
			
			---------------------------------------------------------------
			---------------------------------------------------------------

			drop table #F
			drop table #H
			drop table #HT
			drop table #HTF
			drop table #H_FINAL

		SET @CONT_P = @CONT_P+1
	END



	DELETE FROM PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS WHERE NOMBRE_PRODUCTO IS NULL
    UPDATE PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS 
	SET HT  = 100
	WHERE HT IS NULL AND FECHA = @fecha_FIN
	----select * from PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS
END

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_OPERACIONES_DESGLOSE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 06/02/2020
-- Description:	SACAR TABLITA DESGLOSE DE OPERACIONES (Desglose de Ofertas)
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_OPERACIONES_DESGLOSE] 
(
@MES INT,
@AÑO INT,
@PRODUCTO varchar(150)
)
AS
BEGIN

DECLARE @FECHA_FIN DATE;

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

--****************REPROCESAR*****************************
DELETE FROM PLD_TC_CONVENIO_OPERACIONES_DESGLOSE
WHERE producto = @PRODUCTO AND fecha_proceso = @FECHA_FIN

PRINT 'DELETE FROM PLD_TC_CONVENIO_OPERACIONES_DESGLOSE WHERE producto = ' +  @PRODUCTO + ' 
AND fecha_proceso = ' + CONVERT(VARCHAR,@FECHA_FIN) + ' '
--****************REPROCESAR*****************************


CREATE TABLE #DESGLOSE_TEMP(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[producto] [varchar](150) NULL,
	[descripcion] [varchar](150) NULL,	
	[fecha_proceso] [date] NULL,	
	[monto] [decimal](18, 2) NULL,
	[monto_porcentaje] [decimal](18, 2) NULL,
	[operaciones] [decimal](18, 2) NULL,
	[operaciones_porcentaje] [decimal](18, 2) NULL	
)

CREATE TABLE #DESGLOSE_TEMP2(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[producto] [varchar](150) NULL,
	[descripcion] [varchar](150) NULL,	
	[fecha_proceso] [date] NULL,	
	[monto] [decimal](18, 2) NULL,
	[monto_porcentaje] [decimal](18, 2) NULL,
	[operaciones] [decimal](18, 2) NULL,
	[operaciones_porcentaje] [decimal](18, 2) NULL	
)


INSERT INTO #DESGLOSE_TEMP(producto,descripcion,fecha_proceso,monto,monto_porcentaje,operaciones,operaciones_porcentaje)

SELECT	@PRODUCTO,
	'OFERTA-APROBADA' AS descripcion,
	@FECHA_FIN AS fecha_proceso,		
	ISNULL(SUM(CASE WHEN F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS monto,
	0,
	ISNULL(COUNT(DISTINCT F.NRO_EXPEDIENTE),0),
	0			   

FROM TB_CS_CONSOLIDADO_FULL F INNER JOIN TB_CS L
	ON F.NRO_EXPEDIENTE = L.NRO_EXPEDIENTE
WHERE L.NOMBRE_PRODUCTO = @PRODUCTO
AND L.ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
AND F.TIPO_OFERTA = 'APROBADO'
AND MONTH(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @MES
AND YEAR(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @AÑO
--	GROUP BY CONVERT(DATE,FECHA_HORA_ENVIO)


			UNION ALL


SELECT	@PRODUCTO,
		'OFERTA-REGULAR' AS descripcion,
		@FECHA_FIN AS fecha_proceso,		
		ISNULL(SUM(CASE WHEN F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS monto,
		0,
		ISNULL(COUNT(DISTINCT F.NRO_EXPEDIENTE),0),
		0				   

FROM TB_CS_CONSOLIDADO_FULL F INNER JOIN TB_CS L
	ON F.NRO_EXPEDIENTE = L.NRO_EXPEDIENTE
WHERE L.NOMBRE_PRODUCTO = @PRODUCTO
AND L.ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
AND F.TIPO_OFERTA = 'REGULAR'
AND MONTH(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @MES
AND YEAR(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @AÑO
-------	GROUP BY CONVERT(DATE,FECHA_HORA_ENVIO)

			UNION ALL
			

SELECT		@PRODUCTO,
			'TOTAL' AS descripcion,
			@FECHA_FIN AS fecha_proceso,		
			ISNULL(SUM(CASE WHEN F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS monto,
			100,
			ISNULL(COUNT(DISTINCT F.NRO_EXPEDIENTE),0),
			100			   

FROM TB_CS_CONSOLIDADO_FULL F INNER JOIN TB_CS L
	ON F.NRO_EXPEDIENTE = L.NRO_EXPEDIENTE
WHERE L.NOMBRE_PRODUCTO = @PRODUCTO
AND L.ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
AND MONTH(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @MES
AND YEAR(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @AÑO
--	GROUP BY CONVERT(DATE,FECHA_HORA_ENVIO)


--SELECT * FROM #DESGLOSE_TEMP

------------------------// cálculo de porcentajes
INSERT INTO #DESGLOSE_TEMP2	

	--// OFERTA APROBADA
	SELECT	a.producto,a.descripcion,a.fecha_proceso,a.monto,
			cast (a.monto/ISNULL(NULLIF(b.monto,0),0) as decimal(18,2)) * 100 AS monto_porcentaje,
			a.operaciones,
			cast (a.operaciones/ISNULL(NULLIF(b.operaciones,0),0)  as decimal(18,2)) * 100 AS operaciones_porcentaje
						
			
			FROM #DESGLOSE_TEMP a LEFT JOIN  #DESGLOSE_TEMP b
			ON a.codigo = 1	WHERE b.codigo = 3

			UNION ALL

	--// OFERTA REGULAR
	SELECT	a.producto,a.descripcion,a.fecha_proceso,a.monto,
			cast (a.monto/ISNULL(NULLIF(b.monto,0),0) as decimal(18,2)) * 100 AS monto_porcentaje,
			a.operaciones,
			cast (a.operaciones/ISNULL(NULLIF(b.operaciones,0),0) as decimal(18,2)) * 100 AS operaciones_porcentaje					
			
			FROM #DESGLOSE_TEMP a LEFT JOIN  #DESGLOSE_TEMP b
			ON a.codigo = 2	WHERE b.codigo = 3


			UNION ALL


	--// TOTAL
	SELECT	a.producto,'TOTAL',a.fecha_proceso,			
			cast (a.monto+ISNULL(NULLIF(b.monto,0),0) as decimal(18,2)) AS monto,
			100,
			cast (a.operaciones+ISNULL(NULLIF(b.operaciones,0),0) as decimal(18,2)) AS operaciones,
			100		
			FROM #DESGLOSE_TEMP a LEFT JOIN  #DESGLOSE_TEMP b
			ON a.codigo = 2	WHERE b.codigo = 1

--//INSERTANDO EN TABLA			
INSERT INTO PLD_TC_CONVENIO_OPERACIONES_DESGLOSE(producto,descripcion,fecha_proceso,monto,monto_porcentaje,operaciones,operaciones_porcentaje)
SELECT producto,descripcion,fecha_proceso,monto,monto_porcentaje,operaciones,operaciones_porcentaje
FROM #DESGLOSE_TEMP2

------SELECT * FROM PLD_TC_CONVENIO_OPERACIONES_DESGLOSE
------SELECT * FROM #DESGLOSE_TEMP2

END

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_OPERACIONES_MENSUAL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 06/02/2020
-- Description:	Saca las operaciones del CMI de Consumo,
--				y tambien saca la data necesaria para los gráficos
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_OPERACIONES_MENSUAL] 
(
@MES INT,
@AÑO INT,
@PRODUCTO varchar(150)
)
AS
BEGIN

DECLARE @FECHA_GLOBAL DATE;
DECLARE @FECHA_FIN DATE;

DECLARE @PROMEDIO_ANUAL DECIMAL(10,2);

SET @FECHA_GLOBAL = (SELECT DATEFROMPARTS (@AÑO , @MES , 01))

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

----****************REPROCESAR*****************************
DELETE FROM PLD_TC_CONVENIO_OPERACIONES
WHERE producto = @PRODUCTO AND fecha_proceso = @FECHA_FIN

PRINT 'DELETE FROM PLD_TC_CONVENIO_OPERACIONES WHERE producto = ' +  @PRODUCTO + ' 
AND fecha_proceso = ' + CONVERT(VARCHAR,@FECHA_FIN) + ' '
-----****************REPROCESAR*****************************
-----****************REPROCESAR****GRAFICOS*****************

DELETE FROM PLD_TC_CONVENIO_OPERACIONES_GRAPH
WHERE producto = @PRODUCTO AND fecha_proceso = @FECHA_FIN

PRINT 'DELETE FROM PLD_TC_CONVENIO_OPERACIONES_GRAPH WHERE producto = ' +  @PRODUCTO + ' 
AND fecha_proceso = ' + CONVERT(VARCHAR,@FECHA_FIN) + ' '
-----****************REPROCESAR*****************************

CREATE TABLE #OPERACIONES_ANUAL(	
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[enero] [decimal](18, 2) NULL,
	[febrero] [decimal](18, 2) NULL,
	[marzo] [decimal](18, 2) NULL,
	[abril] [decimal](18, 2) NULL,
	[mayo] [decimal](18, 2) NULL,
	[junio] [decimal](18, 2) NULL,
	[julio] [decimal](18, 2) NULL,
	[agosto] [decimal](18, 2) NULL,
	[setiembre] [decimal](18, 2) NULL,
	[octubre] [decimal](18, 2) NULL,
	[noviembre] [decimal](18, 2) NULL,
	[diciembre] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL,
	[promedio] [decimal](18, 2) NULL
)
----------------------->>>>>>>>
CREATE TABLE #OPERACIONES_TEMP(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL
)


INSERT INTO #OPERACIONES_TEMP
--------------------------------------------
SELECT	 @PRODUCTO,
		'EXP.FORMALIZADOS' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
	END),0) AS '02',					
	ISNULL(COUNT(DISTINCT CASE			
	WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
	END),0) AS '03',					
	ISNULL(COUNT(DISTINCT CASE			
	WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
	END),0) AS '04',					
	ISNULL(COUNT(DISTINCT CASE			
	WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
	END),0) AS '05',					
	ISNULL(COUNT(DISTINCT CASE			
	WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
	END),0) AS '06',					
	ISNULL(COUNT(DISTINCT CASE			
	WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
	END),0) AS '07',					
	ISNULL(COUNT(DISTINCT CASE			
	WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
	END),0) AS '08',					
	ISNULL(COUNT(DISTINCT CASE			
	WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
	END),0) AS '31',
	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE
	END),0) AS total

	FROM TB_CS 			

	WHERE NOMBRE_PRODUCTO = @PRODUCTO
	AND ESTADO_EXPEDIENTE = 'Desembolsado / En Embose'	
	AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
	AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO

UNION ALL

SELECT	 @PRODUCTO,
		'MONTO-FORMALIZADO' AS descripcion_estado, 	    
		@FECHA_FIN AS fecha_proceso,
-------*Solo en los casos donde el importe aprobado es 0, se suma el solicitado. y sino se toma el monto que aparece en aprobado.
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 1 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 1 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '01',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 2 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 2 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '02',					
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 3 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 3 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '03',				
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 4 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 4 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '04',					
ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_ENVIO) = 5 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 5 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '05',					
ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_ENVIO) = 6 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 6 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '06',					
ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_ENVIO) = 7 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 7 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '07',					
ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_ENVIO) = 8 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 8 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '08',					
ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_ENVIO) = 9 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 9 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '09',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 10 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 10 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '10',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 11 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 11 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '11',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 12 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 12 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '12',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 13 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 13 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '13',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 14 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 14 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '14',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 15 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 15 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '15',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 16 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 16 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '16',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 17 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 17 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '17',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 18 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 18 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '18',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 19 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 19 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '19',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 20 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 20 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '20',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 21 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 21 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '21',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 22 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 22 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '22',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 23 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 23 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '23',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 24 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 24 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '24',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 25 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 25 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '25',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 26 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 26 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '26',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 27 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 27 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '27',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 28 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 28 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '28',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 29 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 29 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '29',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 30 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 30 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '30',
ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_ENVIO) = 31 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN DAY(FECHA_HORA_ENVIO) = 31 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS '31',
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS total

FROM TB_CS_CONSOLIDADO_FULL F INNER JOIN TB_CS L
		ON F.NRO_EXPEDIENTE = L.NRO_EXPEDIENTE
WHERE L.NOMBRE_PRODUCTO = @PRODUCTO
AND L.ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
	AND MONTH(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @MES
	AND YEAR(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @AÑO	
	
	
	---- Ajustes 21/07/2020
-----------------------------------------------------------------------------------------
--- DIVISION DE MONTOS FORMALIZADOS ENTRE LA CANTIDAD DE EXPEDIENTES FORMALIZADOS 
	SELECT	 @PRODUCTO as producto,
			'TICKET PROMEDIO' AS descripcion_estado, 	    
			@FECHA_FIN AS fecha_proceso,

			-- Si la division no se puede entre 0 pone NULL con NULLIF, y luego quitamos el NULL con ISNULL y en vez de 0 Ponemos 1 para que divida entre 1

		cast(a.dia1/ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
		cast(a.dia2/ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02', 
		cast(a.dia3/ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
		cast(a.dia4/ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
		cast(a.dia5/ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
		cast(a.dia6/ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
		cast(a.dia7/ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
		cast(a.dia8/ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
		cast(a.dia9/ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
		cast(a.dia10/ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
		cast(a.dia11/ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
		cast(a.dia12/ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
		cast(a.dia13/ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
		cast(a.dia14/ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
		cast(a.dia15/ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
		cast(a.dia16/ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
		cast(a.dia17/ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
		cast(a.dia18/ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
		cast(a.dia19/ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
		cast(a.dia20/ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
		cast(a.dia21/ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
		cast(a.dia22/ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
		cast(a.dia23/ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
		cast(a.dia24/ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
		cast(a.dia25/ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
		cast(a.dia26/ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
		cast(a.dia27/ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
		cast(a.dia28/ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
		cast(a.dia29/ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
		cast(a.dia30/ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
		cast(a.dia31/ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
		cast(a.total/ISNULL(NULLIF(b.total,0),1) as decimal(18,2)) as total		
				
		INTO #TICKET_PROMEDIO

		FROM #OPERACIONES_TEMP a LEFT JOIN #OPERACIONES_TEMP b
		ON a.codigo = 2	WHERE b.codigo = 1

INSERT INTO #OPERACIONES_TEMP(producto,descripcion_estado,fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, total)
SELECT producto,descripcion_estado,fecha_proceso,[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31], total
FROM #TICKET_PROMEDIO

INSERT INTO PLD_TC_CONVENIO_OPERACIONES(producto,descripcion_estado,fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, total)
SELECT producto,descripcion_estado,fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, total
FROM #OPERACIONES_TEMP


---- TO TABLA GRAFICOS (foreach)
INSERT INTO PLD_TC_CONVENIO_OPERACIONES_GRAPH(producto, descripcion_estado, fecha_proceso, dia_nombre, cantidad_monto)

	SELECT @PRODUCTO AS producto, 
			'MONTO-FORMALIZADO' AS descripcion_estado,
			@FECHA_FIN AS fecha_proceso,			
			CONVERT(VARCHAR,DATEPART(DAY,CONVERT(DATE,FECHA_HORA_ENVIO ))) AS dia_nombre,
			SUM(CASE WHEN F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END) AS cantidad_monto   
	FROM TB_CS_CONSOLIDADO_FULL F INNER JOIN TB_CS L
		ON F.NRO_EXPEDIENTE = L.NRO_EXPEDIENTE
	WHERE L.NOMBRE_PRODUCTO = @PRODUCTO
	AND L.ESTADO_EXPEDIENTE = 'Desembolsado / En Embose'	
	AND MONTH(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @MES
	AND YEAR(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @AÑO
	GROUP BY CONVERT(DATE,FECHA_HORA_ENVIO)	

	UNION ALL

	SELECT	@PRODUCTO AS producto, 
			'EXP.FORMALIZADOS' AS descripcion_estado,	
			@FECHA_FIN AS fecha_proceso,			
			CONVERT(VARCHAR,DATEPART(DAY,CONVERT(DATE,FECHA_HORA_ENVIO ))) AS dia_nombre,
			COUNT(DISTINCT NRO_EXPEDIENTE) AS cantidad_monto
	FROM TB_CS 	WHERE NOMBRE_PRODUCTO = @PRODUCTO
	AND ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 	
	AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
	AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
	GROUP BY CONVERT(DATE,FECHA_HORA_ENVIO )

	UNION ALL

	SELECT	 @PRODUCTO AS producto, 
			'TICKET-PROMEDIO' AS descripcion_estado,	
			@FECHA_FIN AS fecha_proceso,			
			CONVERT(VARCHAR,DATEPART(DAY,CONVERT(DATE,FECHA_HORA_ENVIO ))) AS dia_nombre,
			SUM(CASE WHEN F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END)/COUNT(DISTINCT F.NRO_EXPEDIENTE) AS cantidad_monto
	FROM TB_CS_CONSOLIDADO_FULL F INNER JOIN TB_CS L
			ON F.NRO_EXPEDIENTE = L.NRO_EXPEDIENTE
	WHERE L.NOMBRE_PRODUCTO = @PRODUCTO
	AND L.ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 	
	AND MONTH(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @MES
	AND YEAR(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @AÑO
	GROUP BY CONVERT(DATE,FECHA_HORA_ENVIO )


	------------------------------------------------------//TABLA DESGLOZE
	-------SELECT * FROM PLD_TC_CONVENIO_OPERACIONES

	----------------------------------------------- *** RESUMEN ANUAL **** -----------------------------------------------------------

INSERT INTO #OPERACIONES_ANUAL
------------------------------------------
SELECT	 @PRODUCTO,
		'EXP.FORMALIZADOS' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,		
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE END),0) AS enero,
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE END),0) AS febrero,						
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE END),0) AS marzo,						
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE END),0) AS abril,						
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE END),0) AS mayo,							
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE END),0) AS junio,						
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE END),0) AS julio,						
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE END),0) AS agosto,						
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE END),0) AS setiembre,
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE END),0) AS octubre,
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE END),0) AS noviembre,
		ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE END),0) AS diciembre,	
		ISNULL(COUNT(DISTINCT CASE WHEN YEAR(FECHA_HORA_ENVIO) = @AÑO THEN NRO_EXPEDIENTE END),0) AS total,
		ISNULL(COUNT(DISTINCT CASE WHEN YEAR(FECHA_HORA_ENVIO) = @AÑO THEN NRO_EXPEDIENTE END)/12,0) as promedio	
		
		FROM TB_CS
		WHERE NOMBRE_PRODUCTO = @PRODUCTO
		AND ESTADO_EXPEDIENTE = 'Desembolsado / En Embose'	
		AND YEAR(FECHA_HORA_ENVIO) = @AÑO	

	UNION ALL

SELECT	 @PRODUCTO,
		'MONTO-FORMALIZADO' AS descripcion_estado, 	    
		@FECHA_FIN AS fecha_proceso,
-------*Solo en los casos donde el importe aprobado es 0, se suma el solicitado. y sino se toma el monto que aparece en aprobado.
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = 1 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 1 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS enero,
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = 2 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 2 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS febrero,					
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = 3 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 3 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS marzo,				
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = 4 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 4 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS abril,					
ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_ENVIO) = 5 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 5 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS mayo,					
ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_ENVIO) = 6 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 6 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS junio,					
ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_ENVIO) = 7 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 7 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS julio,					
ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_ENVIO) = 8 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 8 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS agosto,					
ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_ENVIO) = 9 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 9 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS setiembre,
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = 10 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 10 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS octubre,
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = 11 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 11 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS noviembre,
ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_ENVIO) = 12 AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN MONTH(FECHA_HORA_ENVIO) = 12 AND F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS diciembre,
ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_ENVIO) = @AÑO AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END),0) AS total,
ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_ENVIO) = @AÑO AND F.IMPORTE_APROBADO = 0 THEN F.IMPORTE_SOLICITADO WHEN F.IMPORTE_APROBADO != 0 THEN F.IMPORTE_APROBADO END)/12,0) AS promedio

FROM TB_CS_CONSOLIDADO_FULL F INNER JOIN TB_CS L
		ON F.NRO_EXPEDIENTE = L.NRO_EXPEDIENTE
WHERE L.NOMBRE_PRODUCTO = @PRODUCTO
AND L.ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 	
AND YEAR(CONVERT(DATE,L.FECHA_HORA_ENVIO)) = @AÑO	



	SELECT	 @PRODUCTO as producto,
			'TICKET PROMEDIO' AS descripcion_estado, 	    
			@FECHA_FIN AS fecha_proceso,

			-- Si la division no se puede entre 0 pone NULL con NULLIF, y luego quitamos el NULL con ISNULL y en vez de 0 Ponemos 1 para que divida entre 1
		cast(a.enero/ISNULL(NULLIF(b.enero,0),1) as decimal(18,2))  AS enero, 
		cast(a.febrero/ISNULL(NULLIF(b.febrero,0),1) as decimal(18,2)) AS febrero, 
		cast(a.marzo/ISNULL(NULLIF(b.marzo,0),1) as decimal(18,2)) AS marzo,
		cast(a.abril/ISNULL(NULLIF(b.abril,0),1) as decimal(18,2)) AS abril,
		cast(a.mayo/ISNULL(NULLIF(b.mayo,0),1) as decimal(18,2)) AS mayo,
		cast(a.junio/ISNULL(NULLIF(b.junio,0),1) as decimal(18,2)) AS junio,
		cast(a.julio/ISNULL(NULLIF(b.julio,0),1) as decimal(18,2)) AS julio,
		cast(a.agosto/ISNULL(NULLIF(b.agosto,0),1) as decimal(18,2)) AS agosto,
		cast(a.setiembre/ISNULL(NULLIF(b.setiembre,0),1) as decimal(18,2)) AS setiembre,
		cast(a.octubre/ISNULL(NULLIF(b.octubre,0),1) as decimal(18,2)) AS octubre,
		cast(a.noviembre/ISNULL(NULLIF(b.noviembre,0),1) as decimal(18,2)) AS noviembre,
		cast(a.diciembre/ISNULL(NULLIF(b.diciembre,0),1) as decimal(18,2)) AS diciembre,		
		cast(a.total/ISNULL(NULLIF(b.total,0),1) as decimal(18,2)) as total,		
		cast(a.promedio/ISNULL(NULLIF(b.promedio,0),1) as decimal(18,2)) as promedio	
				
		INTO #TICKET_PROMEDIO_ANUAL

		FROM #OPERACIONES_ANUAL a LEFT JOIN #OPERACIONES_ANUAL b
		ON a.codigo = 2	WHERE b.codigo = 1

INSERT INTO PLD_TC_CONVENIO_OPERACIONES_ANUAL(producto, descripcion_estado,fecha_proceso,enero,febrero,marzo,abril,mayo,junio,julio,agosto,setiembre,octubre,noviembre,diciembre,total,promedio)
SELECT producto,descripcion_estado, fecha_proceso,enero,febrero,marzo,abril,mayo,junio,julio,agosto,setiembre,octubre,noviembre,diciembre,total,promedio
FROM #OPERACIONES_ANUAL

INSERT INTO PLD_TC_CONVENIO_OPERACIONES_ANUAL
SELECT * FROM #TICKET_PROMEDIO_ANUAL

-------->>>SELECT * FROM PLD_TC_CONVENIO_OPERACIONES_ANUAL


END


GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_PRODUC_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 15/05/2020
-- Description:	PROCEDURE PARA SACAR DATA PARA LOS GRAFICOS DE PESTAÑA PRODUCTIVIDAD.
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_PRODUC_GRAPH] (@MES INT,@AÑO INT)

AS

BEGIN

DECLARE @fecha_proceso DATE;

------------------------------------// WHILE OFERTAS
DECLARE @CONT_O INT = 1;
DECLARE @CONTMAX_O INT;
DECLARE @OFERTA_NAME VARCHAR(65);

------------------------------------// WHILE PRODUCTOS
DECLARE @CONT_P INT = 1;
DECLARE @CONTMAX_P INT;	
DECLARE @PRODUCTO_NAME VARCHAR(65);

SET @fecha_proceso = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)
	
DELETE FROM PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH 
WHERE fecha_proceso = @fecha_proceso

CREATE TABLE #PRODUCTOS
		(	
			cod int identity(1,1) not null,	
			producto varchar(65)			
		)

INSERT INTO #PRODUCTOS
SELECT DISTINCT NOMBRE_PRODUCTO FROM TB_CS

--//-------------------------------------------------------- WHILE PARA PRODUCTOS Y OFERTAS

SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)
	WHILE @CONT_P <= @CONTMAX_P
		BEGIN 
		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)

		-----PRINT @PRODUCTO_NAME			
				
				INSERT INTO PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH
				
				SELECT NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				CASE WHEN DAY(FECHA) = 1  THEN '1' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 2  THEN '2'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 3  THEN '3'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 4  THEN '4'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 5  THEN '5'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 6  THEN '6'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 7  THEN '7'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 8  THEN '8'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 9  THEN '9'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 10 THEN '10' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 11 THEN '11' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 12 THEN '12' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 13 THEN '13' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 14 THEN '14' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 15 THEN '15' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 16 THEN '16' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 17 THEN '17' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 18 THEN '18' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 19 THEN '19' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 20 THEN '20' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 21 THEN '21' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)  
				WHEN DAY(FECHA) = 22 THEN '22' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 23 THEN '23' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 24 THEN '24' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 25 THEN '25' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 26 THEN '26' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 27 THEN '27' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 28 THEN '28' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 29 THEN '29' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 30 THEN '30' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 31 THEN '31' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)	END	AS DIA,
				FECHA,
				@fecha_proceso AS FECHA_PROCESO

				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'APROBADO' AND TIPO = 'DÍAS ÚTILES'
				AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO						

				UNION ALL

				SELECT NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				CASE WHEN DAY(FECHA) = 1  THEN '1' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 2  THEN '2'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 3  THEN '3'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 4  THEN '4'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 5  THEN '5'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 6  THEN '6'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 7  THEN '7'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 8  THEN '8'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 9  THEN '9'  + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 10 THEN '10' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 11 THEN '11' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 12 THEN '12' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 13 THEN '13' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 14 THEN '14' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 15 THEN '15' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 16 THEN '16' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 17 THEN '17' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 18 THEN '18' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 19 THEN '19' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 20 THEN '20' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 21 THEN '21' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)  
				WHEN DAY(FECHA) = 22 THEN '22' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 23 THEN '23' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 24 THEN '24' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 25 THEN '25' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 26 THEN '26' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 27 THEN '27' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 28 THEN '28' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 29 THEN '29' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 30 THEN '30' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)
				WHEN DAY(FECHA) = 31 THEN '31' + '/' + SUBSTRING(DATENAME(MONTH,FECHA),1,3)	END	AS DIA,
				FECHA,
				@fecha_proceso AS FECHA_PROCESO			

				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'REGULAR' AND TIPO = 'DÍAS ÚTILES'
				AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO
				
				UNION ALL
				
				--------------------------------------------------------- GRAFICO DE BARRAS MES ACTUAL
				SELECT NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				'T. Oferta Aprobada' AS DIA,
				CONVERT(DATE,FECHA),
				@fecha_proceso AS FECHA_PROCESO		
				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'APROBADO-MES' AND TIPO = 'DÍAS ÚTILES'
				AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO

				UNION ALL

				SELECT NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				'T. Oferta Regular' AS DIA,
				CONVERT(DATE,FECHA),
				@fecha_proceso AS FECHA_PROCESO
				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'REGULAR-MES' AND TIPO = 'DÍAS ÚTILES'
				AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO
				------------------------------------------------------- GRAFICO DE BARRAS MES ACTUAL

				UNION ALL 
				------------------------------------------------------- GRAFICO DE BARRAS 1 MES ATRAS
				SELECT TOP 1 NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				SUBSTRING(DATENAME(MONTH,FECHA),1,3) + '/' + CONVERT(VARCHAR,YEAR(DATEADD(MONTH, -1, @fecha_proceso))) AS DIA,
				CONVERT(DATE,FECHA),
				@fecha_proceso AS FECHA_PROCESO
				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'APROBADO-MES' AND TIPO = 'DÍAS ÚTILES' AND
				MONTH(FECHA) = MONTH(DATEADD(MONTH, -1, @fecha_proceso)) 	
				AND PERCENTIL = (SELECT mes2 FROM PLD_TC_CONVENIO 
								 WHERE producto = @PRODUCTO_NAME
								 AND descripcion = 'TIEMPO-OFERTA-APROBADA-UTILES-LAB'
								 and fecha_proceso = @fecha_proceso)

				UNION ALL

				SELECT TOP 1 NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				SUBSTRING(DATENAME(MONTH,FECHA),1,3) + '/' + CONVERT(VARCHAR,YEAR(DATEADD(MONTH, -1, @fecha_proceso)))  AS DIA,
				CONVERT(DATE,FECHA),
				@fecha_proceso AS FECHA_PROCESO
				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'REGULAR-MES' AND TIPO = 'DÍAS ÚTILES' AND
				MONTH(FECHA) = MONTH(DATEADD(MONTH, -1, @fecha_proceso)) 
				AND PERCENTIL = (SELECT mes2 FROM PLD_TC_CONVENIO 
								 WHERE producto = @PRODUCTO_NAME
								 AND descripcion = 'TIEMPO-OFERTA-REGULAR-UTILES-LAB'
								 and fecha_proceso = @fecha_proceso)

				----------------------------------------------------- GRAFICO DE BARRAS 1 MES ATRAS

				UNION ALL 
				------------------------------------------------------- GRAFICO DE BARRAS 2 MESES ATRAS
				SELECT TOP 1 NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				SUBSTRING(DATENAME(MONTH,FECHA),1,3) + '/' + CONVERT(VARCHAR,YEAR(DATEADD(MONTH, -2, @fecha_proceso))) AS DIA,
				CONVERT(DATE,FECHA),
				@fecha_proceso AS FECHA_PROCESO				

				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'APROBADO-MES' AND TIPO = 'DÍAS ÚTILES' AND
				MONTH(FECHA) = MONTH(DATEADD(MONTH, -2, @fecha_proceso)) 	
				AND PERCENTIL = (SELECT mes1 FROM PLD_TC_CONVENIO 
								 WHERE producto = @PRODUCTO_NAME
								 AND descripcion = 'TIEMPO-OFERTA-APROBADA-UTILES-LAB'
								 and fecha_proceso = @fecha_proceso)

				UNION ALL

				SELECT TOP 1 NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA,  TIPO, PERCENTIL, 
				SUBSTRING(DATENAME(MONTH,FECHA),1,3) + '/' + CONVERT(VARCHAR,YEAR(DATEADD(MONTH, -2, @fecha_proceso)))  AS DIA,
				CONVERT(DATE,FECHA),
				@fecha_proceso AS FECHA_PROCESO				

				FROM TB_CS_PERCENTIL 
				WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME
				AND NOMBRE_TIPO_OFERTA = 'REGULAR-MES' AND TIPO = 'DÍAS ÚTILES' AND
				MONTH(FECHA) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))
				AND PERCENTIL = (SELECT mes1 FROM PLD_TC_CONVENIO 
								 WHERE producto = @PRODUCTO_NAME
								 AND descripcion = 'TIEMPO-OFERTA-REGULAR-UTILES-LAB'
								 and fecha_proceso = @fecha_proceso) 
				------------------------------------------------------- GRAFICO DE BARRAS 2 MESES ATRAS				
		
	SET @CONT_P = @CONT_P+1
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_REPROCESOS_ACUM]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 2020/02/17
-- Description:	Procedure que inserta en PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM 
--------------- para sacar cantidad acumuladas de reprocesos por mes.
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_REPROCESOS_ACUM]
(
@tipo varchar(500),
@MES int,
@AÑO int
)

AS

BEGIN

DECLARE @fecha_ini DATE;
DECLARE @fecha_FIN DATE;

set @fecha_ini = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial

set @fecha_FIN = (SELECT CONVERT(DATE,MAX(FECHA_HORA_ENVIO)) 
						FROM TB_CS						
						WHERE MONTH (FECHA_HORA_ENVIO) = @MES
						AND YEAR(FECHA_HORA_ENVIO) = @AÑO)

------------------------------------// WHILE PRODUCTOS MES ACTUAL
DECLARE @CONT_P INT = 1;
DECLARE @CONTMAX_P INT;	
DECLARE @ID_P INT = 1; 
DECLARE @PRODUCTO_NAME VARCHAR(65);


CREATE TABLE #PRODUCTOS
(cod int identity(1,1) not null,	
producto varchar(65))


insert into #PRODUCTOS
select distinct NOMBRE_PRODUCTO 
from TB_CS
-----WHERE NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD'


IF @tipo = 'DIARIO'

BEGIN
DELETE FROM PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM

INSERT PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM
SELECT  @tipo ,  'REPROCESO' AS 'TIPO', 
CONVERT (DATE,[dbo].[FN_CALCULAR_FUNNEL](NRO_EXPEDIENTE)) as 'FECHA_INGRESO', 
[NOMBRE_PRODUCTO] , 
[NOMBRE_TIPO_OFERTA] ,
T.TERRITORIO, 
T.OFICINA, 
'INGRESADOS EN EL DIA' ,
count(distinct(NRO_EXPEDIENTE)) AS 'REPROCESOS' , NRO_EXPEDIENTE
FROM TB_CS C
INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
WHERE CONVERT (DATE,[dbo].[FN_CALCULAR_FUNNEL](NRO_EXPEDIENTE)) = CONVERT (DATE,FECHA_HORA_ENVIO)
and accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
and CONVERT (DATE,[dbo].[FN_CALCULAR_FUNNEL](NRO_EXPEDIENTE)) >= @fecha_ini
and CONVERT (DATE,[dbo].[FN_CALCULAR_FUNNEL](NRO_EXPEDIENTE)) <= @fecha_FIN
group  by  CONVERT (DATE,[dbo].[FN_CALCULAR_FUNNEL](NRO_EXPEDIENTE)) , [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA], T.TERRITORIO , T.OFICINA , NRO_EXPEDIENTE

union all

SELECT  @tipo , 'REPROCESO' AS 'TIPO', 
CONVERT (DATE,FECHA_HORA_ENVIO) as 'FECHA_REPROCESO', 
[NOMBRE_PRODUCTO] , 
[NOMBRE_TIPO_OFERTA] ,
T.TERRITORIO, 
T.OFICINA, 
'TOTAL' ,
count(distinct(NRO_EXPEDIENTE)) AS 'REPROCESOS','' 
FROM TB_CS C
INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
WHERE 
accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
and CONVERT (DATE,FECHA_HORA_ENVIO) >= @fecha_ini
and CONVERT (DATE,FECHA_HORA_ENVIO) <= @fecha_FIN
group  by  convert(date,FECHA_HORA_ENVIO) , [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA],  T.TERRITORIO , T.OFICINA

UNION ALL

select  @tipo , 'PROCESADOS',
convert(date,FECHA_HORA_ENVIO), 
[NOMBRE_PRODUCTO] , 
[NOMBRE_TIPO_OFERTA] ,
T.TERRITORIO, 
T.OFICINA, 
'TOTAL' , 
COUNT(distinct nro_expediente) ,''
FROM TB_CS C
INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
where estado_expediente != 'Cerrado'
and convert(date,FECHA_HORA_ENVIO) >= @fecha_ini
and convert(date,FECHA_HORA_ENVIO) <= @fecha_FIN
group  by  convert(date,FECHA_HORA_ENVIO) , [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA],  T.TERRITORIO , T.OFICINA
ORDER BY 2,3,5,1,4

END

IF @tipo = 'MENSUAL'

BEGIN
--------------------------------------------------//// REPROCESOS MENSUAL TOTAL

--****************REPROCESAR*****************************

DELETE FROM PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM
WHERE CONVERT(DATE,FECHA_INGRESO) = CONVERT(DATE,@fecha_FIN)

DELETE FROM PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH
WHERE convert(date,fecha_proceso) = convert(date,@fecha_FIN)

--****************REPROCESAR*****************************

INSERT INTO PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM
-----------------------------------------//// MES DOS ATRAS
SELECT  @tipo AS PERIODO,'REPROCESO' AS TIPO, 
DATEADD(MONTH, -2, @fecha_FIN), 
[NOMBRE_PRODUCTO] , 
[NOMBRE_TIPO_OFERTA] ,
T.TERRITORIO, 
T.OFICINA, 
'TOTAL' ,
count(distinct(NRO_EXPEDIENTE)) AS 'REPROCESOS','' 
FROM TB_CS C INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
WHERE 
accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
and MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @fecha_FIN))
and YEAR(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @fecha_FIN))
GROUP BY MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)), [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA],  T.TERRITORIO , T.OFICINA

UNION ALL
-----------------------------------------//// MES UNO ATRAS
SELECT  @tipo AS PERIODO,'REPROCESO' AS TIPO, 
DATEADD(MONTH, -1, @fecha_FIN), 
[NOMBRE_PRODUCTO] , 
[NOMBRE_TIPO_OFERTA] ,
T.TERRITORIO, 
T.OFICINA, 
'TOTAL' ,
count(distinct(NRO_EXPEDIENTE)) AS 'REPROCESOS','' 
FROM TB_CS C INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
WHERE 
accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
and MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @fecha_FIN))
and YEAR(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @fecha_FIN))
GROUP BY MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)), [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA],  T.TERRITORIO , T.OFICINA

UNION ALL
-----------------------------------------//// MES ACTUAL
SELECT  @tipo AS PERIODO,'REPROCESO' AS TIPO, 
@fecha_FIN, 
[NOMBRE_PRODUCTO] , 
[NOMBRE_TIPO_OFERTA] ,
T.TERRITORIO, 
T.OFICINA, 
'TOTAL' ,
count(distinct(NRO_EXPEDIENTE)) AS 'REPROCESOS','' 
FROM TB_CS C INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
WHERE 
accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
and MONTH(FECHA_HORA_ENVIO) = @MES
and YEAR (FECHA_HORA_ENVIO) = @AÑO
GROUP BY MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)), [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA],  T.TERRITORIO , T.OFICINA

--------------------------------------------------//// REPROCESOS MENSUAL TOTAL

SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)

	WHILE @CONT_P <= @CONTMAX_P
		BEGIN 
		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)
		
		------//Insertar data del mes actual -2 en tabla que ira a gráficos con fecha de consulta @fecha_fin
		insert into PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH

		SELECT NOMBRE_PRODUCTO, CONCAT(MONTH(CONVERT(DATE,FECHA_INGRESO)),'/',CONVERT(VARCHAR,YEAR(FECHA_INGRESO))) AS MES_ANIO,
				SUM(REPROCESOS) AS VALORY, @fecha_FIN AS FECHA_PROCESO
		FROM PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM
		WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND 
		CONVERT(DATE,FECHA_INGRESO) = CONVERT(DATE,DATEADD(MONTH, -2, @fecha_FIN))
		GROUP BY NOMBRE_PRODUCTO,FECHA_INGRESO	 

		SET @CONT_P = @CONT_P+1
	END	

	SET @CONT_P = 1;

	WHILE @CONT_P <= @CONTMAX_P
		BEGIN 

		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)		
		----------------//Insertar data del mes actual -1 en tabla que ira a gráficos con fecha de consulta @fecha_fin
		insert into PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH

		SELECT NOMBRE_PRODUCTO, CONCAT(MONTH(CONVERT(DATE,FECHA_INGRESO)),'/',CONVERT(VARCHAR,YEAR(FECHA_INGRESO))) AS MES_ANIO,
				SUM(REPROCESOS) AS VALORY, @fecha_FIN AS FECHA_PROCESO
		FROM PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM
		WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND 
		CONVERT(DATE,FECHA_INGRESO) = CONVERT(DATE,DATEADD(MONTH, -1, @fecha_FIN))
		GROUP BY NOMBRE_PRODUCTO,FECHA_INGRESO

		SET @CONT_P = @CONT_P+1
	END
	
	SET @CONT_P = 1;	


	WHILE @CONT_P <= @CONTMAX_P
		BEGIN 


		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)
		
		---------------------//Insertar data del mes actual en tabla que ira a gráficos
		insert into PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH

		SELECT NOMBRE_PRODUCTO, CONCAT(MONTH(CONVERT(DATE,FECHA_INGRESO)),'/',CONVERT(VARCHAR,YEAR(FECHA_INGRESO))) AS MES_ANIO,
				SUM(REPROCESOS) AS VALORY, @fecha_FIN AS FECHA_PROCESO
		FROM PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM
		WHERE NOMBRE_PRODUCTO = @PRODUCTO_NAME AND 
		CONVERT(DATE,FECHA_INGRESO) = @fecha_FIN 		
		GROUP BY NOMBRE_PRODUCTO,FECHA_INGRESO


		SET @CONT_P = @CONT_P+1
	END
	


END

END


GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_RESUMEN_MENSUAL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 06/02/2020 .51
-- Description:	Crea el resumen mensual, además saca detalle de reprocesos diario con nro_expediente.		
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_RESUMEN_MENSUAL] 
(
@MES INT,
@AÑO INT,
@PRODUCTO varchar(150)
)
AS
---------------------------------- RESUMEN DE PRODUCTOS
---------------------------------- Variables para los 3 meses
DECLARE @FECHA_GLOBAL DATE;

DECLARE @EXP_DESEMBOLSADOS_M1 INT;
DECLARE @EXP_DESEMBOLSADOS_M2 INT;

DECLARE @EXP_INGRESADOS_ACUMULADOS DECIMAL(18,2);
DECLARE @EXP_REPROCESADOS_DIA_ACUMULADO DECIMAL(18,2);
DECLARE @EXP_DESEMBOLSADOS_FUNNEL DECIMAL(18,2);

DECLARE @EXP_INGRESADOS_ACUMULADOS_M2 DECIMAL(18,2);
DECLARE @EXP_REPROCESADOS_DIA_ACUMULADO_M2 DECIMAL(18,2);
DECLARE @EXP_DESEMBOLSADOS_FUNNEL_M2 DECIMAL(18,2);

DECLARE @EXP_INGRESADOS_ACUMULADOS_M1 DECIMAL(18,2);
DECLARE @EXP_REPROCESADOS_DIA_ACUMULADO_M1 DECIMAL(18,2);
DECLARE @EXP_DESEMBOLSADOS_FUNNEL_M1 DECIMAL(18,2);

----------------------------------------------------------
DECLARE @VO_TIEMPO_FORM_OFERT_APROBADA DECIMAL(18,2);
DECLARE @VO_TIEMPO_FORM_OFERT_REGULAR DECIMAL(18,2);
DECLARE @VO_PORCENT_REPROCESO DECIMAL(18,2);
DECLARE @VO_EXITO_FUNNEL DECIMAL(18,2);


--DECLARE @FECHA_OPERATIVA DATE;
DECLARE @FECHA_FIN DATE;

SET @FECHA_GLOBAL = (SELECT DATEFROMPARTS (@AÑO , @MES , 01))

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)
-----------------------------------------------------------
IF @PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD' OR @PRODUCTO = 'TARJETA DE CREDITO'

	BEGIN 
		--SET @VO_TIEMPO_FORM_OFERT_APROBADA = 1;
		--SET @VO_TIEMPO_FORM_OFERT_REGULAR = 4.5;
		SET @VO_PORCENT_REPROCESO = 50;
		SET @VO_EXITO_FUNNEL = 50;
	END

ELSE

	BEGIN 
		--SET @VO_TIEMPO_FORM_OFERT_APROBADA = 1;
		--SET @VO_TIEMPO_FORM_OFERT_REGULAR = 3;
		SET @VO_PORCENT_REPROCESO = 60;
		SET @VO_EXITO_FUNNEL = 70;
	END

BEGIN


--****************REPROCESAR*****************************
DELETE FROM PLD_TC_CONVENIO
WHERE producto = @PRODUCTO AND fecha_proceso = @FECHA_FIN
PRINT 'Delete from PLD_TC_CONVENIO resumen primera parte hasta  % Reprocesos (Dia)'
-------------------------------------------------
--****************************** REPROCESAR DETALLES Y TIEMPOS
DELETE FROM PLD_TC_CONVENIO_DETALLE
WHERE producto = @PRODUCTO AND fecha_proceso = @FECHA_FIN
AND descripcion IN ('EXP.REPROCESADO-DIA')

PRINT 'DELETE FROM PLD_TC_CONVENIO_DETALLE WHERE producto = ' +  @PRODUCTO + ' 
AND fecha_proceso = ' + CONVERT(VARCHAR,@FECHA_FIN) + ' 
AND descripcion IN (EXP.REPROCESADO-DIA)' 
--****************REPROCESAR*****************************



--------------------------------------TEMP DESEMBOLSADOS DIA
SELECT count(distinct NRO_EXPEDIENTE) AS 'CANT', NRO_EXPEDIENTE, FECHA_HORA_ENVIO
INTO #CS_DESEM_DIA
from TB_CS 
where NOMBRE_PRODUCTO = @PRODUCTO
AND ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
GROUP BY NRO_EXPEDIENTE, FECHA_HORA_ENVIO
--------------------------------------TEMP RECHAZADOS REGISTRAOS DIA
SELECT count(distinct NRO_EXPEDIENTE) AS 'CANT', NRO_EXPEDIENTE, FECHA_HORA_ENVIO
INTO #CS_RECHAZADOS_DIA
from TB_CS 
where NOMBRE_PRODUCTO = @PRODUCTO
AND ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
GROUP BY NRO_EXPEDIENTE, FECHA_HORA_ENVIO

--------------------------------------TEMP DESEMBOLSADOS FUNNEL - FUNNEL ACUMULADO MES 3
SELECT count(distinct NRO_EXPEDIENTE) AS 'CANT', NRO_EXPEDIENTE, FECHA_HORA_ENVIO
INTO #CS_DESEM_FUNNEL
from TB_CS 
where NOMBRE_PRODUCTO = @PRODUCTO
AND ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO
GROUP BY NRO_EXPEDIENTE, FECHA_HORA_ENVIO


--------------------------------------TEMP DESEMBOLSADOS FUNNEL - FUNNEL ACUMULADO MES 2 
SELECT COUNT(DISTINCT NRO_EXPEDIENTE) AS 'CANT', NRO_EXPEDIENTE, FECHA_HORA_ENVIO
INTO #CS_DESEM_FUNNEL_2
from TB_CS 
where NOMBRE_PRODUCTO = @PRODUCTO
AND ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(FECHA_HORA_ENVIO) =  MONTH(DATEADD(MONTH, -1, @FECHA_GLOBAL))
AND YEAR(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_GLOBAL))
GROUP BY NRO_EXPEDIENTE, FECHA_HORA_ENVIO


----------------------------------------TEMP DESEMBOLSADOS FUNNEL - FUNNEL ACUMULADO MES 1 
SELECT COUNT(DISTINCT NRO_EXPEDIENTE) AS 'CANT', NRO_EXPEDIENTE, FECHA_HORA_ENVIO
INTO #CS_DESEM_FUNNEL_1
from TB_CS 
where NOMBRE_PRODUCTO = @PRODUCTO
AND ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(FECHA_HORA_ENVIO) =  MONTH(DATEADD(MONTH, -2, @FECHA_GLOBAL))
AND YEAR(FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_GLOBAL))
GROUP BY NRO_EXPEDIENTE, FECHA_HORA_ENVIO


-------------------------------------------------------------PARA CALCULAR % MES 3
SET @EXP_INGRESADOS_ACUMULADOS = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE) AS CANTIDAD 
										 FROM TB_CS
										 WHERE NOMBRE_PRODUCTO = @PRODUCTO AND
										 ESTADO_EXPEDIENTE='Expediente registrado'
										 AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
										 AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

SET @EXP_REPROCESADOS_DIA_ACUMULADO =  (SELECT COUNT(DISTINCT T.NRO_EXPEDIENTE) AS CANTIDAD
											FROM TB_CS C INNER JOIN #CS_DESEM_FUNNEL T
											ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE  
											WHERE NOMBRE_PRODUCTO= @PRODUCTO and 
											MONTH(C.FECHA_HORA_ENVIO) = @MES AND
											YEAR(C.FECHA_HORA_ENVIO) = @AÑO AND	
											accion in ('SOLICITAR_ACTUALIZACION_SCORING' ,
											'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION'))


SET @EXP_DESEMBOLSADOS_FUNNEL = (SELECT COUNT(DISTINCT T.NRO_EXPEDIENTE) AS CANTIDAD 
											FROM TB_CS C INNER JOIN #CS_DESEM_FUNNEL T
											ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE  
											WHERE NOMBRE_PRODUCTO = @PRODUCTO
											AND ESTADO_EXPEDIENTE='Desembolsado / En Embose'
											AND MONTH(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @MES
											AND YEAR(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @AÑO)

-------------------------------------------------------------PARA CALCULAR % MES 2

SET @EXP_INGRESADOS_ACUMULADOS_M2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE) AS CANTIDAD 
										 FROM TB_CS
										 WHERE NOMBRE_PRODUCTO = @PRODUCTO AND
										 ESTADO_EXPEDIENTE='Expediente registrado'
										 AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @FECHA_GLOBAL))
										 AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @FECHA_GLOBAL)))



SET @EXP_REPROCESADOS_DIA_ACUMULADO_M2 =  (SELECT COUNT(DISTINCT T.NRO_EXPEDIENTE) AS CANTIDAD
											FROM TB_CS C INNER JOIN #CS_DESEM_FUNNEL_2 T
											ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE  
											WHERE NOMBRE_PRODUCTO= @PRODUCTO and 
											MONTH(C.FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_GLOBAL))
											AND	YEAR(C.FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -1, @FECHA_GLOBAL)) AND	
											accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 
											'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION'))


SET @EXP_DESEMBOLSADOS_FUNNEL_M2 = (SELECT COUNT(DISTINCT T.NRO_EXPEDIENTE) AS CANTIDAD 
											FROM TB_CS C INNER JOIN #CS_DESEM_FUNNEL_2 T
											ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE  
											WHERE NOMBRE_PRODUCTO = @PRODUCTO
											AND ESTADO_EXPEDIENTE='Desembolsado / En Embose'
											AND MONTH(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -1, @FECHA_GLOBAL))
											AND YEAR(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @FECHA_GLOBAL)))

---------------------------------------------------------------PARA CALCULAR % MES 1

SET @EXP_INGRESADOS_ACUMULADOS_M1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE) AS CANTIDAD 
										 FROM TB_CS
										 WHERE NOMBRE_PRODUCTO = @PRODUCTO AND
										 ESTADO_EXPEDIENTE='Expediente registrado'
										 AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @FECHA_GLOBAL))
										 AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @FECHA_GLOBAL)))



SET @EXP_REPROCESADOS_DIA_ACUMULADO_M1 =  (SELECT COUNT(DISTINCT T.NRO_EXPEDIENTE) AS CANTIDAD
											FROM TB_CS C INNER JOIN #CS_DESEM_FUNNEL_1 T
											ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE  
											WHERE NOMBRE_PRODUCTO= @PRODUCTO and 
											MONTH(C.FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_GLOBAL)) AND
											YEAR(C.FECHA_HORA_ENVIO) = YEAR(DATEADD(MONTH, -2, @FECHA_GLOBAL)) AND	
											accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 
											'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION'))


SET @EXP_DESEMBOLSADOS_FUNNEL_M1 = (SELECT COUNT(DISTINCT T.NRO_EXPEDIENTE) AS CANTIDAD 
											FROM TB_CS C INNER JOIN #CS_DESEM_FUNNEL_1 T
											ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE  
											WHERE NOMBRE_PRODUCTO = @PRODUCTO
											AND ESTADO_EXPEDIENTE='Desembolsado / En Embose'
											AND MONTH(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = MONTH(DATEADD(MONTH, -2, @FECHA_GLOBAL))
											AND YEAR(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @FECHA_GLOBAL)))

-------------------------------------- TEMP REPROCESOS DIA
SELECT NRO_EXPEDIENTE, FECHA_HORA_ENVIO AS FECHA_INGRESO
INTO #CS_REPROCESO_DIA
from TB_CS C INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
where  ESTADO_EXPEDIENTE='Expediente registrado' 
AND NOMBRE_PRODUCTO = @PRODUCTO
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO
GROUP BY NRO_EXPEDIENTE,FECHA_HORA_ENVIO

-------------------------------------------------------------
CREATE TABLE #RESUMEN(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion] [varchar](150) NULL,
	[valor_objetivo] [decimal](18,2) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[mes1] [int] NULL,	
	[mes2] [int] NULL,
	[mes3] [int] NULL
)
------------------------------------------------------------------------------- EXPEDIENTES DESEMBOLSADOS TOTAL MES 1 Y 2
SET @EXP_DESEMBOLSADOS_M1 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE) 
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO
							AND ESTADO_EXPEDIENTE='Desembolsado / En Embose'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) =  MONTH(DATEADD(MONTH, -2, @FECHA_GLOBAL))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -2, @FECHA_GLOBAL)))

SET @EXP_DESEMBOLSADOS_M2 = (SELECT COUNT(DISTINCT NRO_EXPEDIENTE) 
							FROM TB_CS
							WHERE NOMBRE_PRODUCTO = @PRODUCTO
							AND ESTADO_EXPEDIENTE='Desembolsado / En Embose'
							AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) =  MONTH(DATEADD(MONTH, -1, @FECHA_GLOBAL))
							AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = YEAR(DATEADD(MONTH, -1, @FECHA_GLOBAL)))

INSERT INTO #RESUMEN
----------------------------------- EXPEDIENTES INGRESADOS OK
SELECT	@PRODUCTO,	'EXP.INGRESADOS' AS DESCRIPCION,0, @FECHA_FIN AS fecha_proceso,

ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE END),0) AS '01',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE END),0) AS '02',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE END),0) AS '03',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE END),0) AS '04',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE END),0) AS '05',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE END),0) AS '06',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE END),0) AS '07',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE END),0) AS '08',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE END),0) AS '09',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE END),0) AS '10',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE END),0) AS '11',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE END),0) AS '12',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE END),0) AS '13',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE END),0) AS '14',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE END),0) AS '15',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE END),0) AS '16',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE END),0) AS '17',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE END),0) AS '18',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE END),0) AS '19',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE END),0) AS '20',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE END),0) AS '21',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE END),0) AS '22',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE END),0) AS '23',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE END),0) AS '24',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE END),0) AS '25',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE END),0) AS '26',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE END),0) AS '27',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE END),0) AS '28',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE END),0) AS '29',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE END),0) AS '30',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE END),0) AS '31',
ISNULL(@EXP_INGRESADOS_ACUMULADOS_M1,0) AS mes1,
ISNULL(@EXP_INGRESADOS_ACUMULADOS_M2,0) AS mes2,
ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE	END),0) AS mes3	

FROM TB_CS
WHERE NOMBRE_PRODUCTO = @PRODUCTO AND
ESTADO_EXPEDIENTE='Expediente registrado'	
AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
	 

UNION ALL
	 
------------------ EXPEDIENTES INGRESADOS ACUMULADOS OK 
SELECT	@PRODUCTO, 'EXP.INGRESADOS-ACUM' AS DESCRIPCION,  0, @FECHA_FIN AS 'FECHA PROCESO',

ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 1 THEN NRO_EXPEDIENTE	END),0) AS '01',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 2 THEN NRO_EXPEDIENTE	END),0) AS '02',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 3 THEN NRO_EXPEDIENTE	END),0) AS '03',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 4 THEN NRO_EXPEDIENTE	END),0) AS '04',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 5 THEN NRO_EXPEDIENTE	END),0) AS '05',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 6 THEN NRO_EXPEDIENTE END),0) AS '06',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 7 THEN NRO_EXPEDIENTE	END),0) AS '07',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 8 THEN NRO_EXPEDIENTE	END),0) AS '08',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 9 THEN NRO_EXPEDIENTE	END),0) AS '09',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 10 THEN NRO_EXPEDIENTE END),0) AS '10',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 11 THEN NRO_EXPEDIENTE END),0) AS '11',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 12 THEN NRO_EXPEDIENTE END),0) AS '12',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 13 THEN NRO_EXPEDIENTE END),0) AS '13',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 14 THEN NRO_EXPEDIENTE END),0) AS '14',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 15 THEN NRO_EXPEDIENTE END),0) AS '15',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 16 THEN NRO_EXPEDIENTE END),0) AS '16',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 17 THEN NRO_EXPEDIENTE END),0) AS '17',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 18 THEN NRO_EXPEDIENTE END),0) AS '18',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 19 THEN NRO_EXPEDIENTE END),0) AS '19',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 20 THEN NRO_EXPEDIENTE END),0) AS '20',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 21 THEN NRO_EXPEDIENTE END),0) AS '21',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 22 THEN NRO_EXPEDIENTE END),0) AS '22',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 23 THEN NRO_EXPEDIENTE END),0) AS '23',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 24 THEN NRO_EXPEDIENTE END),0) AS '24',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 25 THEN NRO_EXPEDIENTE END),0) AS '25',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 26 THEN NRO_EXPEDIENTE END),0) AS '26',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 27 THEN NRO_EXPEDIENTE END),0) AS '27',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 28 THEN NRO_EXPEDIENTE END),0) AS '28',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 29 THEN NRO_EXPEDIENTE END),0) AS '29',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 30 THEN NRO_EXPEDIENTE END),0) AS '30',
ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) <= 31 THEN NRO_EXPEDIENTE END),0) AS '31',
0,
0,
0	
FROM TB_CS
WHERE NOMBRE_PRODUCTO = @PRODUCTO AND
ESTADO_EXPEDIENTE='Expediente registrado'
AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
	 

	 UNION ALL 

------------------------ EXPEDIENTES PROCESADOS OK
	 
	 SELECT
	  @PRODUCTO,	  
      'EXP.PROCESADOS' AS DESCRIPCION,   
	  0,
	  @FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
	END),0) AS '31',
	0,
	0,
	0	

	FROM TB_CS
	where NOMBRE_PRODUCTO = @PRODUCTO
		AND estado_expediente != 'Cerrado' 	
		 AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
		 AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
		 			 
	 UNION ALL 


	 ------------------EXPEDIENTES DESEMBOLSADOS (TOTAL) OK
	 
	 SELECT @PRODUCTO,
      'EXP.DESEMBOLSADOS-TOTAL' AS DESCRIPCION,   
	  0,
	  @FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
	END),0) AS '31',

	ISNULL(@EXP_DESEMBOLSADOS_M1,0) AS 'mes1',
	ISNULL(@EXP_DESEMBOLSADOS_M2,0) AS 'mes2',
	ISNULL(COUNT(DISTINCT CASE	WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE	END),0) AS '31'		

	FROM TB_CS
	where NOMBRE_PRODUCTO = @PRODUCTO
		 AND ESTADO_EXPEDIENTE='Desembolsado / En Embose' 	
		   AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
	       AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO


	UNION ALL
	------------------EXPEDIENTES DESEMBOLSADOS ACUMULADOS (PESTAÑA ACUMULADO) OK	 

	 SELECT @PRODUCTO,
      'EXP.DESEMBOLSADOS-ACUMULADO' AS DESCRIPCION,   
	  0,
	  @FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 1 THEN NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 2 THEN NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 3 THEN NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 4 THEN NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 5 THEN NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 6 THEN NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 7 THEN NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 8 THEN NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 9 THEN NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 10 THEN NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 11 THEN NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 12 THEN NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 13 THEN NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 14 THEN NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 15 THEN NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 16 THEN NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 17 THEN NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 18 THEN NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 19 THEN NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 20 THEN NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 21 THEN NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 22 THEN NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 23 THEN NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 24 THEN NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 25 THEN NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 26 THEN NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 27 THEN NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 28 THEN NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 29 THEN NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 30 THEN NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 31 THEN NRO_EXPEDIENTE
	END),0) AS '31',

	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) THEN NRO_EXPEDIENTE
	END),0) AS '31',
	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) THEN NRO_EXPEDIENTE
	END),0) AS '31',
	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE
	END),0) AS '31'		

	FROM TB_CS
	where NOMBRE_PRODUCTO = @PRODUCTO
		 AND ESTADO_EXPEDIENTE='Desembolsado / En Embose' 	
		   AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
	       AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO

   UNION ALL 

--------------------- EXPEDIENTES DESEMBOLSADOS(DIA) OK

SELECT @PRODUCTO,
      'EXP.DESEMBOLSADOS-DIA' AS DESCRIPCION,   
	  0,
	  @FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 1 THEN T.NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 2 THEN T.NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 3 THEN T.NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 4 THEN T.NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 5 THEN T.NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 6 THEN T.NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 7 THEN T.NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 8 THEN T.NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 9 THEN T.NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 10 THEN T.NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 11 THEN T.NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 12 THEN T.NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 13 THEN T.NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 14 THEN T.NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 15 THEN T.NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 16 THEN T.NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 17 THEN T.NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 18 THEN T.NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 19 THEN T.NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 20 THEN T.NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 21 THEN T.NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 22 THEN T.NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 23 THEN T.NRO_EXPEDIENTE
	END),0) AS '23',	
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 24 THEN T.NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 25 THEN T.NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 26 THEN T.NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 27 THEN T.NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 28 THEN T.NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 29 THEN T.NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 30 THEN T.NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 31 THEN T.NRO_EXPEDIENTE
	END),0) AS '31',
	0,
	0,
	0	

FROM TB_CS C INNER JOIN #CS_DESEM_DIA T
ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE AND 
	convert(date,C.FECHA_HORA_ENVIO) = convert(date,T.FECHA_HORA_ENVIO)
WHERE NOMBRE_PRODUCTO = @PRODUCTO
AND ESTADO_EXPEDIENTE='Desembolsado / En Embose' 
 AND MONTH(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @MES
 AND YEAR(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @AÑO

	UNION ALL 
		
 --------------------EXPEDIENTES DESEMBOLSADOS(FUNNEL) OK

SELECT
		@PRODUCTO,
      'EXP.DESEMBOLSADOS-FUNNEL' AS DESCRIPCION,	
	  0 AS VO,
	  @FECHA_FIN AS 'FECHA PROCESO',


	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 1 THEN T.NRO_EXPEDIENTE 
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 2 THEN T.NRO_EXPEDIENTE 
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 3 THEN T.NRO_EXPEDIENTE 
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 4 THEN T.NRO_EXPEDIENTE 
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 5 THEN T.NRO_EXPEDIENTE 
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 6 THEN T.NRO_EXPEDIENTE 
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 7 THEN T.NRO_EXPEDIENTE 
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 8 THEN T.NRO_EXPEDIENTE 
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 9 THEN T.NRO_EXPEDIENTE 
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 10 THEN T.NRO_EXPEDIENTE 
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 11 THEN T.NRO_EXPEDIENTE 
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 12 THEN T.NRO_EXPEDIENTE 
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 13 THEN T.NRO_EXPEDIENTE 
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 14 THEN T.NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 15 THEN T.NRO_EXPEDIENTE 
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 16 THEN T.NRO_EXPEDIENTE 
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 17 THEN T.NRO_EXPEDIENTE 
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 18 THEN T.NRO_EXPEDIENTE 
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 19 THEN T.NRO_EXPEDIENTE 
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 20 THEN T.NRO_EXPEDIENTE 
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 21 THEN T.NRO_EXPEDIENTE 
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 22 THEN T.NRO_EXPEDIENTE 
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 23 THEN T.NRO_EXPEDIENTE 
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 24 THEN T.NRO_EXPEDIENTE 
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 25 THEN T.NRO_EXPEDIENTE 
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 26 THEN T.NRO_EXPEDIENTE 
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 27 THEN T.NRO_EXPEDIENTE 
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 28 THEN T.NRO_EXPEDIENTE 
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 29 THEN T.NRO_EXPEDIENTE 
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 30 THEN T.NRO_EXPEDIENTE 
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) <= 31 THEN T.NRO_EXPEDIENTE 
	END),0) AS '31',
	0,
	0,
	0
	FROM TB_CS C INNER JOIN #CS_DESEM_FUNNEL T
	ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE  
	WHERE NOMBRE_PRODUCTO = @PRODUCTO
	AND ESTADO_EXPEDIENTE='Desembolsado / En Embose'
	AND MONTH(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @MES
	AND YEAR(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @AÑO


UNION ALL 
 --------------------------- EXPEDIENTES RECHAZADOS (TOTAL) OK

 SELECT  @PRODUCTO,
      'EXP.RECHAZADOS-TOTAL' AS DESCRIPCION,  
	  0, 
	  @FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
	END),0) AS '31',

	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) THEN NRO_EXPEDIENTE
	END),0) AS 'mes1',
	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) THEN NRO_EXPEDIENTE
	END),0) AS 'mes2',
	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN NRO_EXPEDIENTE
	END),0) AS 'mes3'	
	
	FROM TB_CS
	WHERE ESTADO_EXPEDIENTE='RECHAZADO' AND NOMBRE_PRODUCTO = @PRODUCTO
	 AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
	 AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO


UNION ALL 

 --------------------------- EXPEDIENTES RECHAZADOS (DIA) OK

SELECT @PRODUCTO,
      'EXP.RECHAZADOS-DIA' AS DESCRIPCION,   
	  0,
	  @FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 1 THEN T.NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 2 THEN T.NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 3 THEN T.NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 4 THEN T.NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 5 THEN T.NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 6 THEN T.NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 7 THEN T.NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 8 THEN T.NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 9 THEN T.NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 10 THEN T.NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 11 THEN T.NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 12 THEN T.NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 13 THEN T.NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 14 THEN T.NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 15 THEN T.NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 16 THEN T.NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 17 THEN T.NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 18 THEN T.NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 19 THEN T.NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 20 THEN T.NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 21 THEN T.NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 22 THEN T.NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 23 THEN T.NRO_EXPEDIENTE
	END),0) AS '23',	
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 24 THEN T.NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 25 THEN T.NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 26 THEN T.NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 27 THEN T.NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 28 THEN T.NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 29 THEN T.NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 30 THEN T.NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(C.FECHA_HORA_ENVIO) = 31 THEN T.NRO_EXPEDIENTE
	END),0) AS '31',
	0,
	0,
	0	

	FROM TB_CS C INNER JOIN #CS_RECHAZADOS_DIA T
ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE AND 
	convert(date,C.FECHA_HORA_ENVIO) = convert(date,T.FECHA_HORA_ENVIO)
WHERE NOMBRE_PRODUCTO = @PRODUCTO
AND ESTADO_EXPEDIENTE='RECHAZADO' 
 AND MONTH(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @MES
 AND YEAR(CONVERT(DATE,C.FECHA_HORA_ENVIO)) = @AÑO

UNION ALL 
 --------------------------- REPROCESOS TOTAL OK
 
SELECT  @PRODUCTO,
      'EXP.REPROCESOS-TOTAL' AS DESCRIPCION,
	  0,   
	  @FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN NRO_EXPEDIENTE
	END),0) AS '31',
	0,
	0,
	0
FROM TB_CS C
INNER JOIN TB_PYMES_TERRITORIO T 
ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
WHERE NOMBRE_PRODUCTO = @PRODUCTO AND
accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
 AND MONTH(FECHA_HORA_ENVIO) = @MES
 AND YEAR(FECHA_HORA_ENVIO) = @AÑO  

UNION ALL  
 
 --------------------------- REPROCESOS DIA OK
SELECT @PRODUCTO,
'EXP.REPROCESOS-DIA' AS DESCRIPCION, 
0,  
@FECHA_FIN AS 'FECHA PROCESO',

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 1 THEN T.NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN T.NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 3 THEN T.NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 4 THEN T.NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 5 THEN T.NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 6 THEN T.NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 7 THEN T.NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 8 THEN T.NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 9 THEN T.NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 10 THEN T.NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 11 THEN T.NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 12 THEN T.NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 13 THEN T.NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 14 THEN T.NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 15 THEN T.NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 16 THEN T.NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 17 THEN T.NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 18 THEN T.NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 19 THEN T.NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 20 THEN T.NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 21 THEN T.NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 22 THEN T.NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 23 THEN T.NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 24 THEN T.NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 25 THEN T.NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 26 THEN T.NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 27 THEN T.NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 28 THEN T.NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 29 THEN T.NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 30 THEN T.NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) = 31 THEN T.NRO_EXPEDIENTE
	END),0) AS '31',

	ISNULL(@EXP_REPROCESADOS_DIA_ACUMULADO_M1,0) AS mes1,
	ISNULL(@EXP_REPROCESADOS_DIA_ACUMULADO_M2,0) AS mes2,
	ISNULL(COUNT(DISTINCT CASE WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN T.NRO_EXPEDIENTE END),0) AS mes3	

FROM TB_CS C INNER JOIN #CS_REPROCESO_DIA T 
ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE
WHERE accion IN ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
 AND MONTH(FECHA_HORA_ENVIO) = @MES
 AND YEAR(FECHA_HORA_ENVIO) = @AÑO

 UNION ALL

--------------------------- REPROCESOS DIA ACUMULADO (PESTAÑA ACUMULADO) OK

 SELECT @PRODUCTO,
'EXP.REPROCESOS-DIA-ACUMULADO' AS DESCRIPCION, 
0,  
@FECHA_FIN AS fecha_proceso,

	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 1 THEN T.NRO_EXPEDIENTE
	END),0) AS '01',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 2 THEN T.NRO_EXPEDIENTE
	END),0) AS '02',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 3 THEN T.NRO_EXPEDIENTE
	END),0) AS '03',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 4 THEN T.NRO_EXPEDIENTE
	END),0) AS '04',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 5 THEN T.NRO_EXPEDIENTE
	END),0) AS '05',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 6 THEN T.NRO_EXPEDIENTE
	END),0) AS '06',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 7 THEN T.NRO_EXPEDIENTE
	END),0) AS '07',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 8 THEN T.NRO_EXPEDIENTE
	END),0) AS '08',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 9 THEN T.NRO_EXPEDIENTE
	END),0) AS '09',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 10 THEN T.NRO_EXPEDIENTE
	END),0) AS '10',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 11 THEN T.NRO_EXPEDIENTE
	END),0) AS '11',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 12 THEN T.NRO_EXPEDIENTE
	END),0) AS '12',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 13 THEN T.NRO_EXPEDIENTE
	END),0) AS '13',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 14 THEN T.NRO_EXPEDIENTE
	END),0) AS '14',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 15 THEN T.NRO_EXPEDIENTE
	END),0) AS '15',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 16 THEN T.NRO_EXPEDIENTE
	END),0) AS '16',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 17 THEN T.NRO_EXPEDIENTE
	END),0) AS '17',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 18 THEN T.NRO_EXPEDIENTE
	END),0) AS '18',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 19 THEN T.NRO_EXPEDIENTE
	END),0) AS '19',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 20 THEN T.NRO_EXPEDIENTE
	END),0) AS '20',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 21 THEN T.NRO_EXPEDIENTE
	END),0) AS '21',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 22 THEN T.NRO_EXPEDIENTE
	END),0) AS '22',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 23 THEN T.NRO_EXPEDIENTE
	END),0) AS '23',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 24 THEN T.NRO_EXPEDIENTE
	END),0) AS '24',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 25 THEN T.NRO_EXPEDIENTE
	END),0) AS '25',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 26 THEN T.NRO_EXPEDIENTE
	END),0) AS '26',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 27 THEN T.NRO_EXPEDIENTE
	END),0) AS '27',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 28 THEN T.NRO_EXPEDIENTE
	END),0) AS '28',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 29 THEN T.NRO_EXPEDIENTE
	END),0) AS '29',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 30 THEN T.NRO_EXPEDIENTE
	END),0) AS '30',
	ISNULL(COUNT(DISTINCT CASE
	WHEN DAY(FECHA_HORA_ENVIO) <= 31 THEN T.NRO_EXPEDIENTE
	END),0) AS '31',

	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) THEN T.NRO_EXPEDIENTE
	END),0) AS mes1,
	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) THEN T.NRO_EXPEDIENTE
	END),0) AS mes2,
	ISNULL(COUNT(DISTINCT CASE
	WHEN MONTH(FECHA_HORA_ENVIO) = @MES THEN T.NRO_EXPEDIENTE
	END),0) AS mes3	

FROM TB_CS C INNER JOIN #CS_REPROCESO_DIA T 
ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE
AND convert(date,C.FECHA_HORA_ENVIO) = convert(date,T.FECHA_INGRESO)
WHERE accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
 AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
 AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO
----------------------------------------------% DE FORMALIZACION

SELECT  @PRODUCTO AS PRODUCTO,
		 '% FORMALIZACION' AS DESCRIPCION,
		 @VO_EXITO_FUNNEL AS VO,
		@FECHA_FIN AS fecha_proceso,
---- Si la division no se puede entre 0 pone NULL con NULLIF, y luego quitamos el NULL
---- con ISNULL y en vez de 0 Ponemos 1 para que divida entre 1

		cast (a.dia1*100./ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
		cast (a.dia2*100./ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02', 
		cast (a.dia3*100./ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
		cast (a.dia4*100./ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
		cast (a.dia5*100./ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
		cast (a.dia6*100./ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
		cast (a.dia7*100./ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
		cast (a.dia8*100./ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
		cast (a.dia9*100./ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
		cast (a.dia10*100./ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
		cast (a.dia11*100./ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
		cast (a.dia12*100./ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
		cast (a.dia13*100./ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
		cast (a.dia14*100./ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
		cast (a.dia15*100./ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
		cast (a.dia16*100./ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
		cast (a.dia17*100./ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
		cast (a.dia18*100./ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
		cast (a.dia19*100./ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
		cast (a.dia20*100./ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
		cast (a.dia21*100./ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
		cast (a.dia22*100./ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
		cast (a.dia23*100./ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
		cast (a.dia24*100./ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
		cast (a.dia25*100./ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
		cast (a.dia26*100./ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
		cast (a.dia27*100./ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
		cast (a.dia28*100./ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
		cast (a.dia29*100./ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
		cast (a.dia30*100./ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
		cast (a.dia31*100./ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
		(@EXP_DESEMBOLSADOS_FUNNEL_M1/ISNULL(NULLIF(@EXP_INGRESADOS_ACUMULADOS_M1,0),1))* 100 AS 'mes1',
		(@EXP_DESEMBOLSADOS_FUNNEL_M2/ISNULL(NULLIF(@EXP_INGRESADOS_ACUMULADOS_M2,0),1)) * 100 AS 'mes2',
		(@EXP_DESEMBOLSADOS_FUNNEL/ISNULL(NULLIF(@EXP_INGRESADOS_ACUMULADOS,0),1)) * 100 AS 'mes3' -- (EXP. DESEMBOLSADOS FUNNEL / EXP. INGRESADOS ACUMULADOS)


		INTO #PORCENTAJE_FORMALIZACION
		FROM #RESUMEN a LEFT JOIN #RESUMEN b
		ON a.codigo = 7	WHERE b.codigo = 2
-------------------------------------% DE REPROCESOS (TOTAL) = EXP. REPROCESOS TOTAL/EXPEDIENTES PROCESADOS
		SELECT  @PRODUCTO AS PRODUCTO,
		'% REPROCESOS-TOTAL' AS DESCRIPCION,
		0 AS VO,
		@FECHA_FIN AS fecha_proceso,

---- Si la division no se puede entre 0 pone NULL con NULLIF,
---- y luego quitamos el NULL con ISNULL y en vez de 0 Ponemos 1 para que divida entre 1

		cast (a.dia1*100./ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
		cast (a.dia2*100./ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02',
		cast (a.dia3*100./ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
		cast (a.dia4*100./ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
		cast (a.dia5*100./ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
		cast (a.dia6*100./ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
		cast (a.dia7*100./ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
		cast (a.dia8*100./ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
		cast (a.dia9*100./ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
		cast (a.dia10*100./ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
		cast (a.dia11*100./ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
		cast (a.dia12*100./ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
		cast (a.dia13*100./ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
		cast (a.dia14*100./ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
		cast (a.dia15*100./ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
		cast (a.dia16*100./ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
		cast (a.dia17*100./ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
		cast (a.dia18*100./ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
		cast (a.dia19*100./ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
		cast (a.dia20*100./ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
		cast (a.dia21*100./ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
		cast (a.dia22*100./ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
		cast (a.dia23*100./ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
		cast (a.dia24*100./ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
		cast (a.dia25*100./ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
		cast (a.dia26*100./ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
		cast (a.dia27*100./ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
		cast (a.dia28*100./ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
		cast (a.dia29*100./ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
		cast (a.dia30*100./ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
		cast (a.dia31*100./ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
		0 AS 'mes1',
		0 AS 'mes2',
		0 AS 'mes3'


		INTO #PORCENTAJE_REPROCESOS_TOTAL
		FROM #RESUMEN a LEFT JOIN #RESUMEN b
		ON a.codigo = 9	WHERE b.codigo = 3
------------------------------% DE REPROCESOS DIA = EXP.REPROCESOS-DIA /EXP.INGRESADOS

	SELECT  @PRODUCTO AS PRODUCTO,
		'% REPROCESOS-DIA' AS DESCRIPCION,
		@VO_PORCENT_REPROCESO AS VO,
		@FECHA_FIN AS fecha_proceso,

---- Si la division no se puede entre 0 pone NULL con NULLIF, 
---- y luego quitamos el NULL con ISNULL y en vez de 0 Ponemos 1 para que divida entre 1

		cast (a.dia1*100./ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
		cast (a.dia2*100./ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02',
		cast (a.dia3*100./ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
		cast (a.dia4*100./ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
		cast (a.dia5*100./ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
		cast (a.dia6*100./ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
		cast (a.dia7*100./ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
		cast (a.dia8*100./ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
		cast (a.dia9*100./ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
		cast (a.dia10*100./ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
		cast (a.dia11*100./ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
		cast (a.dia12*100./ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
		cast (a.dia13*100./ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
		cast (a.dia14*100./ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
		cast (a.dia15*100./ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
		cast (a.dia16*100./ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
		cast (a.dia17*100./ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
		cast (a.dia18*100./ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
		cast (a.dia19*100./ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
		cast (a.dia20*100./ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
		cast (a.dia21*100./ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
		cast (a.dia22*100./ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
		cast (a.dia23*100./ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
		cast (a.dia24*100./ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
		cast (a.dia25*100./ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
		cast (a.dia26*100./ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
		cast (a.dia27*100./ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
		cast (a.dia28*100./ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
		cast (a.dia29*100./ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
		cast (a.dia30*100./ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
		cast (a.dia31*100./ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
		cast (a.mes1*100./ISNULL(NULLIF(b.mes1,0),1) as decimal(18,2)) AS 'mes1',
		cast (a.mes2*100./ISNULL(NULLIF(b.mes2,0),1) as decimal(18,2)) AS 'mes2',
		cast (a.mes3*100./ISNULL(NULLIF(b.mes3,0),1) as decimal(18,2)) AS 'mes3'

		INTO #PORCENTAJE_REPROCESOS_DIA
		FROM #RESUMEN a LEFT JOIN #RESUMEN b
		ON a.codigo = 11 WHERE b.codigo = 1

----------------DETALLE DE EXP.REPROCESOS (DIA)

INSERT INTO PLD_TC_CONVENIO_DETALLE(expediente, fecha, producto, descripcion, fecha_proceso)
SELECT DISTINCT(T.NRO_EXPEDIENTE) AS expediente,
CONVERT(DATE,T.FECHA_INGRESO) as fecha,
@PRODUCTO AS producto,
'EXP.REPROCESADO-DIA' AS descripcion,
@FECHA_FIN AS fecha_proceso
FROM TB_CS C INNER JOIN #CS_REPROCESO_DIA T 
ON C.NRO_EXPEDIENTE = T.NRO_EXPEDIENTE
AND convert(date,C.FECHA_HORA_ENVIO) = convert(date,T.FECHA_INGRESO)
WHERE accion in ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
	AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
	AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO



--------------** DETALLE DE TIEMPOS OFERTA APROBADA EN DIAS UTILES LAB

--SELECT NRO_EXPEDIENTE AS NRO_EXPEDIENTE,FECHA_HORA_ENVIO AS FECHA_FINAL
--INTO #TEMP1
--FROM  TB_CS
--WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE')
--AND ACCION!='GRABAR'
--AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
--AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO 
--AND NOMBRE_PRODUCTO = @PRODUCTO
--and NOMBRE_TIPO_OFERTA = 'APROBADO'


--SELECT NRO_EXPEDIENTE AS NRO_EXPEDIENTE,FECHA_HORA_ENVIO AS FECHA_FINAL
--INTO #TEMP2
--FROM  TB_CS
--WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE')
--AND ACCION!='GRABAR'
--AND MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES
--AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO 
--AND NOMBRE_PRODUCTO = @PRODUCTO
--and NOMBRE_TIPO_OFERTA = 'REGULAR'


------------------------------// DROPEO
DROP TABLE #CS_DESEM_DIA
DROP TABLE #CS_DESEM_FUNNEL
DROP TABLE #CS_DESEM_FUNNEL_2
DROP TABLE #CS_DESEM_FUNNEL_1
DROP TABLE #CS_RECHAZADOS_DIA
DROP TABLE #CS_REPROCESO_DIA

-------------DROP TABLE #TEMP1
------------DROP TABLE #TEMP2

------------ Insertamos Expedientes en PLD de #Resumen
------------ select * from #RESUMEN
INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31,mes1,mes2,mes3)
SELECT producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31,mes1,mes2,mes3	
FROM #RESUMEN

------------Insertamos % de formalizacion en PLD  de #PORCENTAJE_FORMALIZACION  

INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31,mes1,mes2,mes3)
SELECT PRODUCTO,DESCRIPCION,VO, FECHA_PROCESO, 
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[mes1],[mes2],[mes3]
FROM #PORCENTAJE_FORMALIZACION

------------Insertamos porcentajes reproceso  TOTAL en PLD de formalizacion de ##PORCENTAJE_REPROCESOS_TOTAL  

INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31,mes1,mes2,mes3)
SELECT PRODUCTO, DESCRIPCION,VO, FECHA_PROCESO, 
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[mes1],[mes2],[mes3]
FROM #PORCENTAJE_REPROCESOS_TOTAL


------------Insertamos porcentajes reproceso  DIA en PLD de formalizacion de ##PORCENTAJE_REPROCESOS_TOTAL  

INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31,mes1,mes2,mes3)
SELECT PRODUCTO, DESCRIPCION, VO, FECHA_PROCESO, 
[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[mes1],[mes2],[mes3]
FROM #PORCENTAJE_REPROCESOS_DIA


------- DATOS PARA PESTAÑA CALIDAD
EXEC USP_PLD_TC_CONVENIO_CALIDAD @MES , @AÑO

-------SELECT * FROM PLD_TC_CONVENIO

END

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_SEGOPERACIONES_PROD]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 25/06/2020
-- Description:	Procedure que saca el seguimiento de operaciones para la tuberia
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_SEGOPERACIONES_PROD]  (@MES int,@AÑO int)

AS


BEGIN

DECLARE @PROD varchar(50)

DECLARE @FECHA_INI datetime
DECLARE @FECHA_MAX datetime

DECLARE @CONTADOR int = 1;
DECLARE @MAX int;


-------------------------------------------------------------
SET @FECHA_INI = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial


-----FECHA_PROCESO
SET @FECHA_MAX = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)
-------------------------------------------------------------	
----------------------------------------------------REPROCESAR
DELETE FROM PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES
WHERE MONTH(FECHA) = @MES and YEAR(FECHA) = @AÑO

DELETE FROM PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA
WHERE fecha_proceso = @FECHA_MAX
----------------------------------------------------
CREATE TABLE #PRODUCTOS
( Id int identity(1,1) NOT NULL PRIMARY KEY,
PRODUCTO varchar(100) NULL,
);
					
INSERT INTO #PRODUCTOS
SELECT DISTINCT NOMBRE_PRODUCTO
FROM TB_CS
-------------------------------------------------------------WHILE FECHAS
SET @MAX = (SELECT COUNT(Id) FROM #PRODUCTOS)

WHILE @CONTADOR <= @MAX

		BEGIN

		SET @PROD = (SELECT PRODUCTO FROM #PRODUCTOS WHERE Id=@CONTADOR)	

		EXEC [dbo].[USP_PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES] @MES, @AÑO, @PROD

		SET @CONTADOR = @CONTADOR + 1
		END		
		----SELECT * FROM PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA
END
GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 24/06/2020
-- Description:	Procedure replica para calcular la tuberia de TB_CS
-- ===============================================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES](
@MES INT,
@AÑO INT,
@PRODUCTO NVARCHAR(50)
)
AS

BEGIN


DECLARE @FECHA_FIN date;

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)


SELECT DISTINCT
NRO_EXPEDIENTE,
ESTADO_EXPEDIENTE,
PERFIL,
ACCION,
NOMBRE_PRODUCTO,
NOMBRE_TIPO_OFERTA,
FECHA_HORA_LLEGADA,
FECHA_HORA_ENVIO,
TIEMPO_COLA_TC,
TIEMPO_PROCESO_TP,
ANS,
OBSERVACION,
CODIGO_OFICINA_GESTORA,
CODIGO_OFICINA_USUARIO,
CODIGO_TERRITORIO_GESTORA,
CODIGO_TERRITORIO_USUARIO 

INTO #TB_CS_ALTAS_1_PRODUCTO
from TB_CS
where NOMBRE_PRODUCTO= @PRODUCTO
and year(CONVERT (date, FECHA_HORA_ENVIO))= @AÑO
and month(CONVERT (date, FECHA_HORA_ENVIO))=@MES 
and ESTADO_EXPEDIENTE='Expediente registrado'
order by NRO_EXPEDIENTE


select DISTINCT
A.NRO_EXPEDIENTE,
A.ESTADO_EXPEDIENTE,
A.PERFIL,
A.ACCION,
A.NOMBRE_PRODUCTO,
A.NOMBRE_TIPO_OFERTA,
A.FECHA_HORA_LLEGADA,
A.FECHA_HORA_ENVIO,
A.TIEMPO_COLA_TC,
A.TIEMPO_PROCESO_TP,
A.ANS,
A.OBSERVACION,
A.CODIGO_OFICINA_GESTORA,
A.CODIGO_OFICINA_USUARIO,
A.CODIGO_TERRITORIO_GESTORA,
A.CODIGO_TERRITORIO_USUARIO

INTO #TB_CS_ALTAS_2_PRODUCTO
from TB_CS A
INNER JOIN #TB_CS_ALTAS_1_PRODUCTO B
ON A.NRO_EXPEDIENTE = B.NRO_EXPEDIENTE
where A.NOMBRE_PRODUCTO= @PRODUCTO
and year ( CONVERT (date, A.FECHA_HORA_ENVIO))= @AÑO
and month ( CONVERT (date, A.FECHA_HORA_ENVIO))=@MES
and year ( CONVERT (date, A.FECHA_HORA_LLEGADA))= @AÑO 
and month ( CONVERT (date, A.FECHA_HORA_LLEGADA))=@MES 
and A.ESTADO_EXPEDIENTE='Desembolsado / En Embose'
order by NRO_EXPEDIENTE


select DISTINCT
A.NRO_EXPEDIENTE,
A.ESTADO_EXPEDIENTE,
A.PERFIL,
A.ACCION,
A.NOMBRE_PRODUCTO,
A.NOMBRE_TIPO_OFERTA,
A.FECHA_HORA_LLEGADA,
A.FECHA_HORA_ENVIO,
A.TIEMPO_COLA_TC,
A.TIEMPO_PROCESO_TP,
A.ANS,
A.OBSERVACION,
A.CODIGO_OFICINA_GESTORA,
A.CODIGO_OFICINA_USUARIO,
A.CODIGO_TERRITORIO_GESTORA,
A.CODIGO_TERRITORIO_USUARIO 

INTO #TB_CS_ALTAS_3_PRODUCTO
from TB_CS A
INNER JOIN #TB_CS_ALTAS_1_PRODUCTO B
ON A.NRO_EXPEDIENTE = B.NRO_EXPEDIENTE
where A.NOMBRE_PRODUCTO= @PRODUCTO
and year ( CONVERT (date, A.FECHA_HORA_ENVIO))= @AÑO
and month ( CONVERT (date, A.FECHA_HORA_ENVIO))=@MES
and year ( CONVERT (date, A.FECHA_HORA_LLEGADA))= @AÑO 
and month ( CONVERT (date, A.FECHA_HORA_LLEGADA))=@MES
and A.ESTADO_EXPEDIENTE!='Desembolsado / En Embose'
and A.ESTADO_EXPEDIENTE='Cerrado'
order by NRO_EXPEDIENTE


select A.* 
INTO #TB_CS_ALTAS_4_PRODUCTO
from #TB_CS_ALTAS_1_PRODUCTO A
LEFT JOIN #TB_CS_ALTAS_2_PRODUCTO B
ON  A.NRO_EXPEDIENTE = B.NRO_EXPEDIENTE
LEFT JOIN #TB_CS_ALTAS_3_PRODUCTO C
ON  A.NRO_EXPEDIENTE = C.NRO_EXPEDIENTE
WHERE  B.NRO_EXPEDIENTE IS NULL AND C.NRO_EXPEDIENTE IS NULL
ORDER BY A.NRO_EXPEDIENTE

INSERT INTO PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES
SELECT 
@PRODUCTO as producto, A.NRO_EXPEDIENTE as expediente, 
[dbo].[FN_TB_CS_ULTIMO_ESTADO] (A.NRO_EXPEDIENTE) AS ultimo_estado, 
D.NOM_TERRITORIO as territorio, 
D.NOM_OFIC AS oficina, 
[dbo].[FN_TB_CS_EJECUTIVO](A.NRO_EXPEDIENTE) AS ejecutivo,
[dbo].[FN_TB_CS_ULTIMA_FECHA] (A.NRO_EXPEDIENTE) AS ultima_fecha, 
[dbo].[FN_TB_CS_PLAZO]([dbo].[FN_TB_CS_ULTIMA_FECHA] (A.NRO_EXPEDIENTE)) AS plazo,
@FECHA_FIN as fecha_proceso


FROM #TB_CS_ALTAS_4_PRODUCTO A
LEFT JOIN [dbo].[TB_CS_TERRITORIO] D
ON A.CODIGO_OFICINA_USUARIO= D.COD_OFI
WHERE [dbo].[FN_TB_CS_ULTIMO_ESTADO] (A.NRO_EXPEDIENTE) != 'FINALIZADO'
group by 
A.NRO_EXPEDIENTE, 
[dbo].[FN_TB_CS_ULTIMO_ESTADO_TEMP] (A.NRO_EXPEDIENTE), 
D.NOM_TERRITORIO, 
D.NOM_OFIC, 
D.NOM_TERRITORIO, 
D.NOM_OFIC,
[dbo].[FN_TB_CS_EJECUTIVO](A.NRO_EXPEDIENTE),
[dbo].[FN_TB_CS_ULTIMA_FECHA] (A.NRO_EXPEDIENTE), 
[dbo].[FN_TB_CS_PLAZO](CONVERT(DATE,[dbo].[FN_TB_CS_ULTIMA_FECHA] (A.NRO_EXPEDIENTE))) 

--select * from PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES
CREATE TABLE #TAREAS
(
BANDEJA varchar(50),
CANTIDAD INT
)

INSERT INTO #TAREAS VALUES('FORMALIZADOR',0)
INSERT INTO #TAREAS VALUES('CONTROLLER',0)
INSERT INTO #TAREAS VALUES('RIESGOS SUPERIOR',0)
INSERT INTO #TAREAS VALUES('ANALISTA DE RIESGOS',0)
INSERT INTO #TAREAS VALUES('ANALISIS Y ALTA',0)
INSERT INTO #TAREAS VALUES('SUB GERENTE OFICINA',0)
INSERT INTO #TAREAS VALUES('MESA DE CONTROL',0)
INSERT INTO #TAREAS VALUES('EJECUTIVO',0)

CREATE TABLE #FINALES
(
TIPO varchar(50),
TAREA VARCHAR(50),
TOTAL INT,
FECHA DATE
)

INSERT INTO #FINALES
SELECT tipo, tarea, SUM(CASE WHEN tarea = 'FORMALIZADOR' THEN 1   					
							WHEN tarea = 'CONTROLLER' THEN 1
							WHEN tarea = 'RIESGOS SUPERIOR' THEN 1
							WHEN tarea = 'ANALISTA DE RIESGOS' THEN 1
							WHEN tarea = 'ANALISIS Y ALTA' THEN 1
							WHEN tarea = 'SUB GERENTE OFICINA' THEN 1
							WHEN tarea = 'MESA DE CONTROL' THEN 1
							WHEN tarea = 'EJECUTIVO' THEN 1 
							else 0 END) as total,
						@FECHA_FIN AS fecha_proceso			

FROM PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES
WHERE tipo = @PRODUCTO
AND MONTH(fecha) = @MES and YEAR(fecha) = @AÑO
GROUP BY tipo, tarea


insert into PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA
select * from #FINALES
UNION ALL
select @PRODUCTO, BANDEJA , CANTIDAD, @FECHA_FIN
FROM #TAREAS
WHERE BANDEJA NOT IN (SELECT tarea from #FINALES)


DROP TABLE #FINALES
DROP TABLE #TAREAS

END
GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS]
(@MES INT,@AÑO INT,@PRODUCTO VARCHAR(100))

AS

BEGIN

DECLARE @VO_TIEMPO_FORM_OFERT_APROBADA DECIMAL(18,2);
DECLARE @VO_TIEMPO_FORM_OFERT_REGULAR DECIMAL(18,2);


---------FECHA-PROCESO----------
DECLARE @FECHA_PROCESO DATE;
DECLARE @FEC_RESUMEN_PLD date;
------------------------------FECHAS ULTIMOS 3 MESES
DECLARE @M1 INT;
DECLARE @A1 INT;

DECLARE @M2 INT;
DECLARE @A2 INT;

DECLARE @M3 INT;
DECLARE @A3 INT;
-----------------------------------VALORES PERCENTIL 3 ULTIMOS MESES
DECLARE @PERCENTIL_APROBADO_M1 DECIMAL(18,2);
DECLARE @PERCENTIL_REGULAR_M1 DECIMAL(18,2);

DECLARE @PERCENTIL_APROBADO_M2 DECIMAL(18,2);
DECLARE @PERCENTIL_REGULAR_M2 DECIMAL(18,2);

DECLARE @PERCENTIL_APROBADO_M3 DECIMAL(18,2);
DECLARE @PERCENTIL_REGULAR_M3 DECIMAL(18,2);


-----------------// WHILE PARA LOS TIEMPOS
DECLARE @FECHA datetime
DECLARE @CONTADOR int = 1;
DECLARE @MAX1 int;

-----FECHA_PROCESO
SET @FEC_RESUMEN_PLD = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)


----------------------//REPROCESAR TIEMPOS PERCENTIL MES
DELETE FROM TB_CS_PERCENTIL 
WHERE NOMBRE_PRODUCTO = @PRODUCTO 
AND NOMBRE_TIPO_OFERTA = 'APROBADO-MES'
AND MONTH(FECHA) = @MES
AND YEAR(FECHA) = @AÑO

DELETE FROM TB_CS_PERCENTIL 
WHERE NOMBRE_PRODUCTO = @PRODUCTO 
AND NOMBRE_TIPO_OFERTA = 'REGULAR-MES'
AND MONTH(FECHA) = @MES
AND YEAR(FECHA) = @AÑO


----------------------//REPROCESO DETALLE DE TIEMPOS CMI MENSUAL EN TABLERO RESUMEN
DELETE FROM PLD_TC_CONVENIO_DETALLE_TIEMPOS
WHERE nombre_producto = @PRODUCTO 
AND nombre_tipo_oferta = 'APROBADO'
AND CONVERT(date, fecha_proceso) = CONVERT(date, @FEC_RESUMEN_PLD)

DELETE FROM PLD_TC_CONVENIO_DETALLE_TIEMPOS
WHERE nombre_producto = @PRODUCTO 
AND nombre_tipo_oferta = 'REGULAR'
AND CONVERT(date, fecha_proceso) = CONVERT(date, @FEC_RESUMEN_PLD)


----------------------//REPROCESO DETALLE DE TIEMPOS DE EXPEDIENTE POR BANDEJAS
DELETE FROM PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA
WHERE nombre_producto = @PRODUCTO 
AND CONVERT(date, fecha_proceso) = CONVERT(date, @FEC_RESUMEN_PLD)


CREATE TABLE #FEC1
( Id int identity(1,1) NOT NULL PRIMARY KEY,
  Fecha varchar(255) NULL,
);

INSERT #FEC1 (Fecha)
SELECT DISTINCT(CONVERT(DATE,FECHA_HORA_ENVIO))
FROM TB_CS
WHERE MONTH (CONVERT(DATE, FECHA_HORA_ENVIO)) = @MES
and YEAR(CONVERT(DATE, FECHA_HORA_ENVIO)) = @AÑO
ORDER BY 1
--select * from #FEC1


SET @MAX1 = (SELECT COUNT(Id) FROM #FEC1)
WHILE @CONTADOR <= @MAX1
BEGIN
	SET @FECHA = (SELECT FECHA FROM #FEC1 WHERE Id=@CONTADOR)

	EXEC [dbo].[USP_TB_CS_PERCENTIL]  @FECHA , @PRODUCTO , 'REGULAR' 
	EXEC [dbo].[USP_TB_CS_PERCENTIL]  @FECHA , @PRODUCTO , 'APROBADO' 

	SET @CONTADOR=@CONTADOR+1
END


---------------------------------------------------------------------
SET @M1 = (SELECT MONTH(DATEADD(MONTH, -2, @FEC_RESUMEN_PLD))) 
SET @A1 = (SELECT YEAR(DATEADD(MONTH, -2, @FEC_RESUMEN_PLD))) 

SET @M2 = (SELECT MONTH(DATEADD(MONTH, -1, @FEC_RESUMEN_PLD)))
SET @A2 = (SELECT YEAR(DATEADD(MONTH, -1, @FEC_RESUMEN_PLD))) 

SET @M3 = (SELECT MONTH(@FEC_RESUMEN_PLD)) 
SET @A3 = (SELECT YEAR(@FEC_RESUMEN_PLD))

--SELECT @M1, @A1, @M2, @A2, @M3, @A3

-------------------------------PERCENTILES DE LOS 3 MESES----------------------------------------
EXEC USP_TB_CS_PERCENTIL_MES_OFERTA  @M1, @A1, @PRODUCTO, 'APROBADO'
EXEC USP_TB_CS_PERCENTIL_MES_OFERTA  @M1, @A1, @PRODUCTO, 'REGULAR'

EXEC USP_TB_CS_PERCENTIL_MES_OFERTA  @M2, @A2, @PRODUCTO, 'APROBADO'
EXEC USP_TB_CS_PERCENTIL_MES_OFERTA  @M2, @A2, @PRODUCTO, 'REGULAR'

EXEC USP_TB_CS_PERCENTIL_MES_OFERTA @M3, @A3, @PRODUCTO, 'APROBADO'
EXEC USP_TB_CS_PERCENTIL_MES_OFERTA @M3, @A3, @PRODUCTO, 'REGULAR'

----------------------------PERCENTIL MENSUAL 
SET @PERCENTIL_APROBADO_M1 = (SELECT TOP 1 MAX(PERCENTIL) 
							from TB_CS_PERCENTIL 
							WHERE MONTH(FECHA) = @M1 AND YEAR(FECHA) = @A1 AND
							NOMBRE_PRODUCTO = @PRODUCTO AND
							NOMBRE_TIPO_OFERTA = 'APROBADO-MES' AND
							TIPO = 'DÍAS ÚTILES')
SET @PERCENTIL_REGULAR_M1 = (SELECT TOP 1 MAX(PERCENTIL) 
							from TB_CS_PERCENTIL 
							WHERE MONTH(FECHA) = @M1 AND YEAR(FECHA) = @A1 AND
							NOMBRE_PRODUCTO = @PRODUCTO AND
							NOMBRE_TIPO_OFERTA = 'REGULAR-MES' AND
							TIPO = 'DÍAS ÚTILES')

SET @PERCENTIL_APROBADO_M2 = (SELECT TOP 1 MAX(PERCENTIL) 
							from TB_CS_PERCENTIL 
							WHERE MONTH(FECHA) = @M2 AND YEAR(FECHA) = @A2 AND
							NOMBRE_PRODUCTO = @PRODUCTO AND
							NOMBRE_TIPO_OFERTA = 'APROBADO-MES' AND
							TIPO = 'DÍAS ÚTILES')
SET @PERCENTIL_REGULAR_M2 = (SELECT TOP 1 MAX(PERCENTIL) 
							from TB_CS_PERCENTIL 
							WHERE	MONTH(FECHA) = @M2 AND YEAR(FECHA) = @A2 AND
							NOMBRE_PRODUCTO = @PRODUCTO AND
							NOMBRE_TIPO_OFERTA = 'REGULAR-MES' AND
							TIPO = 'DÍAS ÚTILES')

SET @PERCENTIL_APROBADO_M3 = (SELECT TOP 1 MAX(PERCENTIL) 
							from TB_CS_PERCENTIL
							WHERE MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO AND
							NOMBRE_PRODUCTO = @PRODUCTO AND
							NOMBRE_TIPO_OFERTA = 'APROBADO-MES' AND
							TIPO = 'DÍAS ÚTILES')
SET @PERCENTIL_REGULAR_M3 = (SELECT TOP 1 MAX(PERCENTIL) 
							from TB_CS_PERCENTIL 
							WHERE MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO AND
							NOMBRE_PRODUCTO = @PRODUCTO AND
							NOMBRE_TIPO_OFERTA = 'REGULAR-MES' AND
							TIPO = 'DÍAS ÚTILES')
----------------------------------------------------------------------------------------------------------------------------


--****************REPROCESAR**********************************
DELETE FROM PLD_TC_CONVENIO
WHERE producto = @PRODUCTO AND fecha_proceso = @FEC_RESUMEN_PLD
and descripcion IN ('TIEMPO-OFERTA-APROBADA-DIAS-CALEN',
					 'TIEMPO-OFERTA-REGULAR-DIAS-CALEN',
					 'TIEMPO-OFERTA-APROBADA-UTILES-LAB',
					 'TIEMPO-OFERTA-REGULAR-UTILES-LAB')

PRINT 'DELETE FROM PLD_TC_CONVENIO WHERE producto = '+  @PRODUCTO + ' AND fecha_proceso = ' + 
CONVERT(VARCHAR,@FEC_RESUMEN_PLD) + ' and descripcion IN (TIEMPO-OFERTA-APROBADA-DIAS-CALEN,
					 TIEMPO-OFERTA-REGULAR-DIAS-CALEN,
					 TIEMPO-OFERTA-APROBADA-UTILES-LAB,
					 TIEMPO-OFERTA-REGULAR-UTILES-LAB) '

IF @PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD' OR @PRODUCTO = 'TARJETA DE CREDITO'

	BEGIN 
		SET @VO_TIEMPO_FORM_OFERT_APROBADA = 1;
		SET @VO_TIEMPO_FORM_OFERT_REGULAR = 4.5;
		--SET @VO_PORCENT_REPROCESO = 50;
		--SET @VO_EXITO_FUNNEL = 50;
	END

ELSE

	BEGIN 
		SET @VO_TIEMPO_FORM_OFERT_APROBADA = 1;
		SET @VO_TIEMPO_FORM_OFERT_REGULAR = 3;
		--SET @VO_PORCENT_REPROCESO = 60;
		--SET @VO_EXITO_FUNNEL = 70;
	END
-----------------------------------------------------------
BEGIN

----INSERTAR EN TABLA PLD_TC_CONVENIO (RESUMEN MENSUAL)
INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1, mes2, mes3)
SELECT 
		@PRODUCTO,
		'TIEMPO-DESEMBOLSO-DIAS-CALEN', 
		0,
		@FEC_RESUMEN_PLD,
		SUM(ISNULL(CASE WHEN DAY(FECHA)=1 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=2 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=3 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=4 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=5 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=6 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=7 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=8 THEN PERCENTIL END,0)), 
		SUM(ISNULL(CASE WHEN DAY(FECHA)=9 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=10 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=11 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=12 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=13 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=14 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=15 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=16 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=17 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=18 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=19 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=20 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=21 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=22 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=23 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=24 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=25 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=26 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=27 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=28 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=29 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=30 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=31 THEN PERCENTIL END,0)),
		0,
		0,		
		0

		FROM TB_CS_PERCENTIL
		WHERE 	
			MONTH(CONVERT(DATE,FECHA)) = @MES
		AND YEAR(CONVERT(DATE,FECHA)) = @AÑO
		AND	NOMBRE_PRODUCTO = @PRODUCTO
		AND NOMBRE_TIPO_OFERTA = 'DÍA' AND TIPO = 'DÍAS CALENDARIO'	
		GROUP BY NOMBRE_PRODUCTO


		UNION ALL


		SELECT 
			@PRODUCTO,
			'TIEMPO-OFERTA-APROBADA-DIAS-CALEN', 
			0,
		@FEC_RESUMEN_PLD,
		SUM(ISNULL(CASE WHEN DAY(FECHA)=1 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=2 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=3 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=4 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=5 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=6 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=7 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=8 THEN PERCENTIL END,0)), 
		SUM(ISNULL(CASE WHEN DAY(FECHA)=9 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=10 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=11 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=12 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=13 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=14 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=15 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=16 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=17 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=18 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=19 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=20 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=21 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=22 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=23 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=24 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=25 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=26 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=27 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=28 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=29 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=30 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=31 THEN PERCENTIL END,0)),
		0,
		0,
		0	

		FROM TB_CS_PERCENTIL
		WHERE 	
			MONTH(CONVERT(DATE,FECHA)) = @MES
		AND YEAR(CONVERT(DATE,FECHA)) = @AÑO
		AND	NOMBRE_PRODUCTO = @PRODUCTO
		AND NOMBRE_TIPO_OFERTA = 'APROBADO' AND TIPO = 'DÍAS CALENDARIO'	
		GROUP BY NOMBRE_PRODUCTO


		UNION ALL

				
		SELECT 
			@PRODUCTO,
			'TIEMPO-OFERTA-REGULAR-DIAS-CALEN',
			0,			 
		@FEC_RESUMEN_PLD,
		SUM(ISNULL(CASE WHEN DAY(FECHA)=1 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=2 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=3 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=4 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=5 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=6 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=7 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=8 THEN PERCENTIL END,0)), 
		SUM(ISNULL(CASE WHEN DAY(FECHA)=9 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=10 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=11 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=12 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=13 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=14 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=15 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=16 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=17 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=18 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=19 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=20 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=21 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=22 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=23 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=24 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=25 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=26 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=27 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=28 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=29 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=30 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=31 THEN PERCENTIL END,0)),
		0,
		0,
		0		

		FROM TB_CS_PERCENTIL
		WHERE 
			MONTH(CONVERT(DATE,FECHA)) = @MES
		AND YEAR(CONVERT(DATE,FECHA)) = @AÑO
		AND	NOMBRE_PRODUCTO = @PRODUCTO
		AND NOMBRE_TIPO_OFERTA = 'REGULAR' AND TIPO = 'DÍAS CALENDARIO'	
		GROUP BY NOMBRE_PRODUCTO


		UNION ALL


		SELECT 
			@PRODUCTO,
			'TIEMPO-DESEMBOLSO-UTILES-LAB', 
			0,
		@FEC_RESUMEN_PLD,
		SUM(ISNULL(CASE WHEN DAY(FECHA)=1 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=2 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=3 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=4 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=5 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=6 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=7 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=8 THEN PERCENTIL END,0)), 
		SUM(ISNULL(CASE WHEN DAY(FECHA)=9 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=10 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=11 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=12 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=13 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=14 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=15 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=16 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=17 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=18 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=19 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=20 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=21 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=22 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=23 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=24 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=25 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=26 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=27 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=28 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=29 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=30 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=31 THEN PERCENTIL END,0)),
		0,
		0,
		0		

		FROM TB_CS_PERCENTIL
		WHERE 		
			MONTH(CONVERT(DATE,FECHA)) = @MES
		AND YEAR(CONVERT(DATE,FECHA)) = @AÑO
		AND	NOMBRE_PRODUCTO = @PRODUCTO
		AND NOMBRE_TIPO_OFERTA = 'DÍA' AND TIPO = 'DÍAS ÚTILES'	
		GROUP BY NOMBRE_PRODUCTO


		UNION ALL


		SELECT 
			@PRODUCTO,
			'TIEMPO-OFERTA-APROBADA-UTILES-LAB', 
			@VO_TIEMPO_FORM_OFERT_APROBADA,
		@FEC_RESUMEN_PLD,
		SUM(ISNULL(CASE WHEN DAY(FECHA)=1 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=2 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=3 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=4 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=5 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=6 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=7 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=8 THEN PERCENTIL END,0)), 
		SUM(ISNULL(CASE WHEN DAY(FECHA)=9 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=10 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=11 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=12 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=13 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=14 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=15 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=16 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=17 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=18 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=19 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=20 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=21 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=22 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=23 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=24 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=25 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=26 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=27 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=28 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=29 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=30 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=31 THEN PERCENTIL END,0)),
		ISNULL(@PERCENTIL_APROBADO_M1,0),
		ISNULL(@PERCENTIL_APROBADO_M2,0),
		ISNULL(@PERCENTIL_APROBADO_M3,0)				

		FROM TB_CS_PERCENTIL
		WHERE 		
			MONTH(CONVERT(DATE,FECHA)) = @MES
		AND YEAR(CONVERT(DATE,FECHA)) = @AÑO
		AND	NOMBRE_PRODUCTO = @PRODUCTO
		AND NOMBRE_TIPO_OFERTA = 'APROBADO' AND TIPO = 'DÍAS ÚTILES'	
		GROUP BY NOMBRE_PRODUCTO


		UNION ALL


		SELECT 
			@PRODUCTO,
			'TIEMPO-OFERTA-REGULAR-UTILES-LAB', 
			@VO_TIEMPO_FORM_OFERT_REGULAR,
		@FEC_RESUMEN_PLD,
		SUM(ISNULL(CASE WHEN DAY(FECHA)=1 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=2 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=3 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=4 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=5 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=6 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=7 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=8 THEN PERCENTIL END,0)), 
		SUM(ISNULL(CASE WHEN DAY(FECHA)=9 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=10 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=11 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=12 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=13 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=14 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=15 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=16 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=17 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=18 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=19 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=20 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=21 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=22 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=23 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=24 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=25 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=26 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=27 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=28 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=29 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=30 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=31 THEN PERCENTIL END,0)),
		ISNULL(@PERCENTIL_REGULAR_M1,0),
		ISNULL(@PERCENTIL_REGULAR_M2,0),
		ISNULL(@PERCENTIL_REGULAR_M3,0)		

		FROM TB_CS_PERCENTIL
		WHERE	
			MONTH(CONVERT(DATE,FECHA)) = @MES
		AND YEAR(CONVERT(DATE,FECHA)) = @AÑO	
		AND	NOMBRE_PRODUCTO = @PRODUCTO
		AND NOMBRE_TIPO_OFERTA = 'REGULAR' AND TIPO = 'DÍAS ÚTILES'	
		GROUP BY NOMBRE_PRODUCTO

END

END


GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 30/07/2020 PROCEDURE CLAVE, QUE SACA LOS EXPEDIENTES QUE SE REGISTRARON EN EL MES Y SE DESEMBOLSARON EN EL MES,
	----------------- CALCULA EL TIEMPO POR CADA BANDEJA LUEGO SUMA LOS TIEMPOS DE CADA BANDEJA Y SACA SU PERCENTIL
-- Description:	Tiempos de Atencion por Bandeja
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA] 
@MES INT,
@AÑO INT,
@NOMBRE_PRODUCTO VARCHAR(100)

AS
BEGIN
-------------- PERCENTILES - MES --------
DECLARE @BANDEJA VARCHAR(50);
DECLARE @FECHA_FIN DATETIME;
DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

----------- Contador
DECLARE @MAX1 int;
DECLARE @CONTADOR int = 1;
-----------------------------------------------------
SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

------------------------------------------------------
--****************REPROCESAR*****************************
DELETE FROM TB_CS_PERCENTIL_BANDEJA
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND 
CONVERT(DATE,FECHA) = CONVERT(DATE,@FECHA_FIN)
AND NOMBRE_TIPO_OFERTA = 'MES'

PRINT 'DELETE FROM TB_CS_PERCENTIL_BANDEJA WHERE producto = ' +  @NOMBRE_PRODUCTO + ' 
AND fecha_proceso = ' + CONVERT(VARCHAR,@FECHA_FIN) + ' '
--****************REPROCESAR*****************************


CREATE TABLE #TB_CS_PERCENTIL_BANDEJA(
FECHA_FIN DATE,
PERCENTIL DECIMAL(10,2),
PRODUCTO VARCHAR(35),
NOMBRE_TIPO_OFERTA VARCHAR(10),
TIPO VARCHAR(20),
BANDEJA VARCHAR(20)
)


--CREATE TABLE #EXPEDIENTES_PROCESO(
--EXPEDIENTE VARCHAR(10),
--FECHA_HORA_LLEGADA DATETIME,
--FECHA_HORA_ENVIO DATETIME,
--PERFIL VARCHAR(20)

--)

CREATE TABLE #EXPEDIENTES_DISTINTOS_REGISTRADOS(
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,	
	[EXPEDIENTE] [varchar](100) NULL)

CREATE TABLE #BANDEJAS
( Id int identity(1,1) NOT NULL,
  Bandeja varchar(255) NULL,
);
--------//MESA DE CONTROL, 'ANALISIS Y ALTA', CONTROLLER, FORMALIZADOR, EJECUTIVO, ETC
insert into #BANDEJAS(Bandeja) values ('ANALISIS Y ALTA')
insert into #BANDEJAS(Bandeja) values ('ANALISTA DE RIESGOS')
insert into #BANDEJAS(Bandeja) values ('CONTROLLER')
insert into #BANDEJAS(Bandeja) values ('EJECUTIVO')
insert into #BANDEJAS(Bandeja) values ('FORMALIZADOR')
insert into #BANDEJAS(Bandeja) values ('MESA DE CONTROL')
insert into #BANDEJAS(Bandeja) values ('RIESGOS SUPERIOR')
insert into #BANDEJAS(Bandeja) values ('SUB GERENTE OFICINA')

---------------// Para hallar los desembolsados
INSERT INTO #EXPEDIENTES_DISTINTOS_REGISTRADOS
SELECT NRO_EXPEDIENTE
FROM TB_CS 
WHERE  ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SELECT NRO_EXPEDIENTE, C.FECHA_HORA_ENVIO AS FECHA_FIN
INTO #REGISTRADOS_DESEMBOLSADOS
FROM  TB_CS C INNER JOIN #EXPEDIENTES_DISTINTOS_REGISTRADOS R
ON C.NRO_EXPEDIENTE = R.EXPEDIENTE
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO
AND ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SET @MAX1 = (SELECT COUNT(Id) FROM #BANDEJAS)
WHILE @CONTADOR <= @MAX1
BEGIN
		SET @BANDEJA = (SELECT Bandeja FROM #BANDEJAS WHERE Id=@CONTADOR)
				
			--INSERT INTO #EXPEDIENTES_PROCESO
			SELECT D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA,C.FECHA_HORA_ENVIO, PERFIL
			INTO #EXPEDIENTES_PROCESO
			FROM TB_CS C INNER JOIN #REGISTRADOS_DESEMBOLSADOS D
					ON C.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
			WHERE C.NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
			AND C.PERFIL=@BANDEJA						
			AND MONTH(C.FECHA_HORA_ENVIO) = @MES	
			AND YEAR(C.FECHA_HORA_ENVIO) = @AÑO 
			GROUP BY D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA, C.FECHA_HORA_ENVIO, C.PERFIL
			ORDER BY PERFIL
		
				
			-------------------------------------------------------------
			-------------------- DIAS LAB

			SELECT ROW_NUMBER() OVER(ORDER BY SUM([dbo].[fn_tiempo_horas] (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) ) AS NUM,
			SUM([dbo].[fn_tiempo_horas] (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS TIE,				
			0 as CAL
			INTO #PARTE1
			FROM #EXPEDIENTES_PROCESO
			WHERE PERFIL = @BANDEJA
			GROUP BY NRO_EXPEDIENTE, PERFIL	
			-------------------------------------------------------
			------------SELECT * FROM #PARTE1
			---------------------------------------------------
			select @COUNT =  COUNT(*) from #PARTE1

			IF @COUNT = 1 
			BEGIN 
			SET  @PERCENTIL =    1
			END 
			ELSE 
			BEGIN 
			SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;   
			END

			SELECT @LAB=  TIE FROM  #PARTE1
			WHERE  NUM= convert ( int , floor(@PERCENTIL)) 
			---------------------------------------------------------------
			---------------------- DIAS CALENDARIO

			SELECT  ROW_NUMBER() OVER(ORDER BY SUM([dbo].FN_TIEMPO_CALEN (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) ) AS NUMERO,
			0 AS TIEMPO,
			SUM([dbo].FN_TIEMPO_CALEN (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS CALCULO

			INTO #PARTE2
			FROM #EXPEDIENTES_PROCESO
			WHERE PERFIL = @BANDEJA
			GROUP BY NRO_EXPEDIENTE, PERFIL	
			------------------------------------------------------------

			SELECT @CAL =  CALCULO FROM  #PARTE2
			WHERE  NUMERO = convert ( int , floor(@PERCENTIL)) 

			INSERT INTO TB_CS_PERCENTIL_BANDEJA
			--INSERT INTO #TB_CS_PERCENTIL_BANDEJA
			VALUES (@FECHA_FIN ,  @LAB,@NOMBRE_PRODUCTO,'MES' ,'DÍAS ÚTILES', @BANDEJA)


			INSERT INTO TB_CS_PERCENTIL_BANDEJA
			--INSERT INTO #TB_CS_PERCENTIL_BANDEJA
			VALUES (@FECHA_FIN ,  @CAL,@NOMBRE_PRODUCTO,'MES' ,'DÍAS CALENDARIO',@BANDEJA)


			------------- DROPEO
							
			DROP TABLE #EXPEDIENTES_PROCESO			
			DROP TABLE #PARTE1
			DROP TABLE #PARTE2				

		SET @CONTADOR=@CONTADOR+1
	END
	

	----

END


GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 06/02/2020
-- Description:	Tiempos de Atencion por Bandeja / Ofertas APROBADA y REGULAR
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_BANDEJA_OFERTA_MES] 
@MES INT,
@AÑO INT,
@NOMBRE_PRODUCTO VARCHAR(100),
@NOMBRE_TIPO_OFERTA VARCHAR(100)
AS
BEGIN


------------------ contador para hallar los desembolsados
DECLARE @COUNTWHILE INT = 1;
DECLARE @COUNTWHILE_MAX INT;
DECLARE @NRO_EXPEDIENTE VARCHAR(10);

-------------- PERCENTILES - MES --------
DECLARE @BANDEJA VARCHAR(50);
DECLARE @FECHA_FIN DATETIME;
DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

----------- Contador
DECLARE @MAX1 int;
DECLARE @CONTADOR int = 1;
-----------------------------------------------------------
SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)
-----------------------------------------------------------
--****************REPROCESAR*****************************
DELETE FROM TB_CS_PERCENTIL_BANDEJA
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND FECHA = @FECHA_FIN
AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA+' MES'

PRINT 'DELETE FROM TB_CS_PERCENTIL_BANDEJA WHERE producto = ' +  @NOMBRE_PRODUCTO + ' 
AND fecha_proceso = ' + CONVERT(VARCHAR,@FECHA_FIN) + '
AND NOMBRE_TIPO_OFERTA = ' + (@NOMBRE_TIPO_OFERTA)+' MES'  
--****************REPROCESAR*****************************


CREATE TABLE #EXPEDIENTES_DISTINTOS_REGISTRADOS(
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,	
	[EXPEDIENTE] [varchar](100) NULL)

CREATE TABLE #BANDEJAS
( Id int identity(1,1) NOT NULL,
  Bandeja varchar(255) NULL,
);
--------//MESA DE CONTROL, 'ANALISIS Y ALTA', CONTROLLER, FORMALIZADOR, EJECUTIVO, ETC
insert into #BANDEJAS(Bandeja) values ('ANALISIS Y ALTA')
insert into #BANDEJAS(Bandeja) values ('ANALISTA DE RIESGOS')
insert into #BANDEJAS(Bandeja) values ('CONTROLLER')
insert into #BANDEJAS(Bandeja) values ('EJECUTIVO')
insert into #BANDEJAS(Bandeja) values ('FORMALIZADOR')
insert into #BANDEJAS(Bandeja) values ('MESA DE CONTROL')
insert into #BANDEJAS(Bandeja) values ('RIESGOS SUPERIOR')
insert into #BANDEJAS(Bandeja) values ('SUB GERENTE OFICINA')

---------------// Para hallar los desembolsados
INSERT INTO #EXPEDIENTES_DISTINTOS_REGISTRADOS
SELECT NRO_EXPEDIENTE
FROM TB_CS 
WHERE  ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SELECT NRO_EXPEDIENTE, C.FECHA_HORA_ENVIO AS FECHA_FIN
INTO #REGISTRADOS_DESEMBOLSADOS
FROM  TB_CS C INNER JOIN #EXPEDIENTES_DISTINTOS_REGISTRADOS R
ON C.NRO_EXPEDIENTE = R.EXPEDIENTE
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO
AND ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SET @MAX1 = (SELECT COUNT(Id) FROM #BANDEJAS)
WHILE @CONTADOR <= @MAX1
BEGIN
		SET @BANDEJA = (SELECT Bandeja FROM #BANDEJAS WHERE Id=@CONTADOR)
				
				--INSERT INTO #EXPEDIENTES_PROCESO
				SELECT D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA,C.FECHA_HORA_ENVIO, PERFIL
				INTO #EXPEDIENTES_PROCESO
				FROM TB_CS C INNER JOIN #REGISTRADOS_DESEMBOLSADOS D
						ON C.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
				WHERE C.NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
				AND C.PERFIL=@BANDEJA
				AND C.NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA						
				AND MONTH(C.FECHA_HORA_ENVIO) = @MES	
				AND YEAR(C.FECHA_HORA_ENVIO) = @AÑO 
				GROUP BY D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA, C.FECHA_HORA_ENVIO, C.PERFIL, C.NOMBRE_TIPO_OFERTA
				ORDER BY PERFIL
		
				
				-------------------------------------------------------------
				-------------------- DIAS LAB

				SELECT ROW_NUMBER() OVER(ORDER BY SUM([dbo].[fn_tiempo_horas] (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) ) AS NUM,
				SUM([dbo].[fn_tiempo_horas] (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS TIE,				
				0 as CAL
				INTO #PARTE1
				FROM #EXPEDIENTES_PROCESO
				WHERE PERFIL = @BANDEJA 
				GROUP BY NRO_EXPEDIENTE, PERFIL	
				
				-------------------------------------------------------
				------------SELECT * FROM #PARTE1
				---------------------------------------------------
				select @COUNT =  COUNT(*) from #PARTE1

				IF @COUNT = 1 
				BEGIN 
				SET  @PERCENTIL =    1
				END 
				ELSE 
				BEGIN 
				SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;   
				END

				SELECT @LAB=  TIE FROM  #PARTE1
				WHERE  NUM= convert ( int , floor(@PERCENTIL)) 
				---------------------------------------------------------------
				---------------------- DIAS CALENDARIO

				SELECT  ROW_NUMBER() OVER(ORDER BY SUM([dbo].FN_TIEMPO_CALEN (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) ) AS NUMERO,
				0 AS TIEMPO,
				SUM([dbo].FN_TIEMPO_CALEN (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS CALCULO

				INTO #PARTE2
				FROM #EXPEDIENTES_PROCESO
				WHERE PERFIL = @BANDEJA
				GROUP BY NRO_EXPEDIENTE, PERFIL	

				----------------------------------------------------------

				SELECT @CAL =  CALCULO FROM  #PARTE2
				WHERE  NUMERO = convert ( int , floor(@PERCENTIL)) 



				INSERT INTO TB_CS_PERCENTIL_BANDEJA
				VALUES (@FECHA_FIN ,  @LAB,@NOMBRE_PRODUCTO,UPPER (@NOMBRE_TIPO_OFERTA)+' MES' ,'DÍAS ÚTILES', @BANDEJA)


				INSERT INTO TB_CS_PERCENTIL_BANDEJA
				VALUES (@FECHA_FIN ,  @CAL,@NOMBRE_PRODUCTO,UPPER (@NOMBRE_TIPO_OFERTA)+' MES' ,'DÍAS CALENDARIO',@BANDEJA)


				----------- DROPEO
				DROP TABLE #EXPEDIENTES_PROCESO			
				DROP TABLE #PARTE1
				DROP TABLE #PARTE2	

		SET @CONTADOR=@CONTADOR+1
END


END

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_MES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 30/07/2020 PROCEDURE CLAVE, QUE SACA LOS EXPEDIENTES QUE SE REGISTRARON EN EL MES Y SE DESEMBOLSARON EN EL MES,
	----------------- CALCULA EL TIEMPO POR CADA BANDEJA LUEGO SUMA LOS TIEMPOS DE CADA BANDEJA Y SACA SU PERCENTIL
-- Description:	Tiempos de Atencion por PERFIL EVERIS, OFICINA, RIESGOS
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_MES](
@MES INT,
@AÑO INT,
@NOMBRE_PRODUCTO VARCHAR(100),
@BANDEJA VARCHAR(100)
)
AS

BEGIN 

DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

DECLARE @FECHA_FIN DATE;

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS WHERE
				MONTH(CONVERT(date, FECHA_HORA_ENVIO))= @MES
				and YEAR(CONVERT(date, FECHA_HORA_ENVIO))= @AÑO)


CREATE TABLE #TB_CS_PERCENTIL_PERFIL_BANDEJA(
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[FECHA] [datetime] NULL,
	[PERCENTIL] [decimal](10, 3) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL,
	[PERFIL] [varchar](100) NULL
) ON [PRIMARY]

CREATE TABLE #EXPEDIENTES_DISTINTOS_REGISTRADOS(
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,	
	[EXPEDIENTE] [varchar](100) NULL)

---------------// Para hallar los desembolsados
INSERT INTO #EXPEDIENTES_DISTINTOS_REGISTRADOS
SELECT NRO_EXPEDIENTE
FROM TB_CS 
WHERE  ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SELECT NRO_EXPEDIENTE, C.FECHA_HORA_ENVIO AS FECHA_FIN
INTO #REGISTRADOS_DESEMBOLSADOS
FROM  TB_CS C INNER JOIN #EXPEDIENTES_DISTINTOS_REGISTRADOS R
ON C.NRO_EXPEDIENTE = R.EXPEDIENTE
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO
AND ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SELECT D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA,C.FECHA_HORA_ENVIO, PERFIL
			INTO #EXPEDIENTES_PROCESO
			FROM TB_CS C INNER JOIN #REGISTRADOS_DESEMBOLSADOS D
					ON C.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
			WHERE C.NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 							
			AND MONTH(C.FECHA_HORA_ENVIO) = @MES	
			AND YEAR(C.FECHA_HORA_ENVIO) = @AÑO 
			GROUP BY D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA, C.FECHA_HORA_ENVIO, C.PERFIL
			ORDER BY PERFIL
 
------------------------------------------------------------// DIAS UTILES
SELECT NRO_EXPEDIENTE AS NRO_EXPEDIENTE, p.PERFIL AS PERFIL, sum ([dbo].[fn_tiempo_horas] (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS TIEMPO
into #diasutiles
FROM #EXPEDIENTES_PROCESO P inner join TB_CS_BANDEJA b
on p.PERFIL = b.BANDEJA
WHERE B.PERFIL = @BANDEJA
group by NRO_EXPEDIENTE,p.PERFIL
------------------------------------------
select 
ROW_NUMBER() OVER(ORDER BY TIEMPO) AS NUM,
TIEMPO  as TIE,
0 as CAL
INTO #PARTE1
FROM #diasutiles


select @COUNT =  COUNT(NUM) from #PARTE1
SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;   

SELECT @LAB=  TIE FROM  #PARTE1
WHERE  NUM= convert ( int , floor(@PERCENTIL)) 


----------------------------------------------------------// DIAS CALENDARIO
SELECT NRO_EXPEDIENTE AS NRO_EXPEDIENTE, 
p.PERFIL AS PERFIL, sum([dbo].FN_TIEMPO_CALEN (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS TIEMPO_CALENDARIO
into #diascalendario
FROM #EXPEDIENTES_PROCESO p inner join TB_CS_BANDEJA b
on p.PERFIL = b.BANDEJA
WHERE B.PERFIL = @BANDEJA
group by NRO_EXPEDIENTE,p.PERFIL


----------------------------------------
SELECT ROW_NUMBER() OVER(ORDER BY TIEMPO_CALENDARIO) AS NUM,
0  as TIE,
TIEMPO_CALENDARIO as CAL
INTO #PARTE2
FROM #diascalendario


SELECT @CAL = CAL
FROM  #PARTE2
WHERE  NUM = convert(int, floor(@PERCENTIL))

INSERT INTO TB_CS_PERCENTIL_PERFIL_BANDEJA
----INSERT INTO #TB_CS_PERCENTIL_PERFIL_BANDEJA
VALUES (@FECHA_FIN ,  @LAB,@NOMBRE_PRODUCTO,'MES' ,'DÍAS ÚTILES' , @BANDEJA + '-PERFIL')

INSERT INTO TB_CS_PERCENTIL_PERFIL_BANDEJA
----INSERT INTO #TB_CS_PERCENTIL_PERFIL_BANDEJA
VALUES (@FECHA_FIN ,  @CAL,@NOMBRE_PRODUCTO,'MES' ,'DÍAS CALENDARIO', @BANDEJA + '-PERFIL')

drop table #EXPEDIENTES_DISTINTOS_REGISTRADOS
drop table #diasutiles
drop table #diascalendario
drop table #PARTE1
drop table #PARTE2

--SELECT * FROM #TB_CS_PERCENTIL_PERFIL_BANDEJA

END 
GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 06/03/2020 Se realizaron las modificaciones para que ejecute mas rapido
-- Description:	Procedure para sacar percentil de bandeja oferta mes.
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES](
@MES INT,
@AÑO INT,
@NOMBRE_PRODUCTO VARCHAR(100),
@NOMBRE_TIPO_OFERTA VARCHAR(100),
@BANDEJA VARCHAR(100)
)

AS

BEGIN 

DECLARE @COUNTWHILE INT = 1;
DECLARE @COUNTWHILE_MAX INT;
DECLARE @NRO_EXPEDIENTE VARCHAR(10);


DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

DECLARE @FECHA_FIN DATE;

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS WHERE
				MONTH(CONVERT(date, FECHA_HORA_ENVIO))= @MES
				and YEAR(CONVERT(date, FECHA_HORA_ENVIO))= @AÑO)


CREATE TABLE #EXPEDIENTES_DISTINTOS_REGISTRADOS(
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,	
	[EXPEDIENTE] [varchar](100) NULL)

CREATE TABLE #TB_CS_PERCENTIL_PERFIL_BANDEJA(
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[FECHA] [datetime] NULL,
	[PERCENTIL] [decimal](10, 3) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL,
	[PERFIL] [varchar](100) NULL
) ON [PRIMARY]


---------------// Para hallar los desembolsados
INSERT INTO #EXPEDIENTES_DISTINTOS_REGISTRADOS
SELECT NRO_EXPEDIENTE
FROM TB_CS 
WHERE  ESTADO_EXPEDIENTE = 'Expediente Registrado'
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SELECT NRO_EXPEDIENTE, C.FECHA_HORA_ENVIO AS FECHA_FIN
INTO #REGISTRADOS_DESEMBOLSADOS
FROM  TB_CS C INNER JOIN #EXPEDIENTES_DISTINTOS_REGISTRADOS R
ON C.NRO_EXPEDIENTE = R.EXPEDIENTE
WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO
AND ESTADO_EXPEDIENTE = 'Desembolsado / En Embose' 
AND MONTH(FECHA_HORA_ENVIO) = @MES
AND YEAR(FECHA_HORA_ENVIO) = @AÑO


SELECT D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA,C.FECHA_HORA_ENVIO, PERFIL
INTO #EXPEDIENTES_PROCESO
FROM TB_CS C INNER JOIN #REGISTRADOS_DESEMBOLSADOS D
		ON C.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
WHERE C.NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO			
AND C.NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA						
AND MONTH(C.FECHA_HORA_ENVIO) = @MES	
AND YEAR(C.FECHA_HORA_ENVIO) = @AÑO 
GROUP BY D.NRO_EXPEDIENTE, C.FECHA_HORA_LLEGADA, C.FECHA_HORA_ENVIO, C.PERFIL, C.NOMBRE_TIPO_OFERTA
ORDER BY PERFIL


--SELECT * FROM #CALCULO
--ORDER BY NRO_EXPEDIENTE
----------------------------------------------------------// DIAS UTILES
SELECT NRO_EXPEDIENTE AS NRO_EXPEDIENTE, p.PERFIL AS PERFIL, 
SUM([dbo].[fn_tiempo_horas] (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS TIEMPO
into #diasutiles
FROM #EXPEDIENTES_PROCESO p inner join TB_CS_BANDEJA b
on p.PERFIL = b.BANDEJA
WHERE B.PERFIL = @BANDEJA
group by NRO_EXPEDIENTE,p.PERFIL
---------------------------------------------------
select 
ROW_NUMBER() OVER(ORDER BY TIEMPO) AS NUM,
TIEMPO  as TIE,
0 as CAL
INTO #PARTE1
FROM #diasutiles


select @COUNT =  COUNT(NUM) from #PARTE1
SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;   

SELECT @LAB=  TIE FROM  #PARTE1
WHERE  NUM= convert ( int , floor(@PERCENTIL))
----------------------------------------------------------// DIAS CALENDARIO
SELECT NRO_EXPEDIENTE AS NRO_EXPEDIENTE, 
p.PERFIL AS PERFIL, 
SUM([dbo].FN_TIEMPO_CALEN (FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO)) AS TIEMPO_CALENDARIO
into #diascalendario
FROM #EXPEDIENTES_PROCESO p inner join TB_CS_BANDEJA b
on p.PERFIL = b.BANDEJA
WHERE B.PERFIL = @BANDEJA
group by NRO_EXPEDIENTE,P.PERFIL

------------------------------------------------------------
SELECT ROW_NUMBER() OVER(ORDER BY TIEMPO_CALENDARIO) AS NUM,
0  as TIE,
TIEMPO_CALENDARIO as CAL
INTO #PARTE2
FROM #diascalendario


SELECT @CAL = CAL
FROM  #PARTE2
WHERE  NUM = convert(int, floor(@PERCENTIL))

--INSERT INTO #TB_CS_PERCENTIL_PERFIL_BANDEJA
INSERT INTO [TB_CS_PERCENTIL_PERFIL_BANDEJA]
VALUES (@FECHA_FIN ,  @LAB,@NOMBRE_PRODUCTO, UPPER (@NOMBRE_TIPO_OFERTA)+ ' MES' ,'DÍAS ÚTILES' , @BANDEJA + '-PERFIL')

--INSERT INTO #TB_CS_PERCENTIL_PERFIL_BANDEJA
INSERT INTO [TB_CS_PERCENTIL_PERFIL_BANDEJA]
VALUES (@FECHA_FIN ,  @CAL,@NOMBRE_PRODUCTO,UPPER (@NOMBRE_TIPO_OFERTA) +' MES' ,'DÍAS CALENDARIO', @BANDEJA + '-PERFIL')

drop table #EXPEDIENTES_DISTINTOS_REGISTRADOS
DROP TABLE #EXPEDIENTES_PROCESO
drop table #diasutiles
drop table #diascalendario
drop table #PARTE1
drop table #PARTE2

--SELECT * FROM #TB_CS_PERCENTIL_PERFIL_BANDEJA


END  

GO
/****** Object:  StoredProcedure [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_FECHAS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 06/02/2020
-- Description:	Tiempos de Atencion por Perfil de Bandeja (EVERIS, OFICINA, RIESGOS)
-- =============================================
CREATE PROCEDURE [dbo].[USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_FECHAS] 
@MES INT,
@AÑO INT 
AS

BEGIN  -- BEGIN

DECLARE @fecha_proceso DATE;
SET @fecha_proceso = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

DECLARE @BANDEJA VARCHAR(100)

------------------------------------------------------
--****************REPROCESAR*****************************
DELETE FROM TB_CS_PERCENTIL_PERFIL_BANDEJA
WHERE CONVERT(DATE,FECHA) = CONVERT(DATE,@fecha_proceso)

--PRINT 'DELETE FROM TB_CS_PERCENTIL_PERFIL_BANDEJA
--WHERE FECHA = @FECHA_MAX = ' + CONVERT(VARCHAR,@FECHA_MAX) + ' '
--****************REPROCESAR*****************************


DECLARE CBAND CURSOR FOR
SELECT distinct(PERFIL)
FROM TB_CS_BANDEJA
open CBAND
	
fetch next from CBAND into @BANDEJA
while @@fetch_status=0
begin								
						
--print @BANDEJA				
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_MES @MES , @AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD',@BANDEJA
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_MES @MES , @AÑO,'TARJETA DE CREDITO',@BANDEJA												
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_MES @MES , @AÑO,'CONVENIO',@BANDEJA	
												
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES @MES, @AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD', 'REGULAR' , @BANDEJA
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES @MES, @AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD', 'APROBADO' , @BANDEJA

EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES @MES, @AÑO,'TARJETA DE CREDITO', 'APROBADO', @BANDEJA
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES @MES, @AÑO,'TARJETA DE CREDITO', 'REGULAR', @BANDEJA				
												
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES @MES, @AÑO,'CONVENIO', 'APROBADO', @BANDEJA
EXEC [dbo].USP_PLD_TC_CONVENIO_TIEMPOS_PERFIL_BANDEJA_OFERTA_MES @MES, @AÑO,'CONVENIO', 'REGULAR', @BANDEJA					
											
								
---
fetch next from CBAND into @BANDEJA
end
close CBAND
deallocate CBAND

END 

GO
/****** Object:  StoredProcedure [dbo].[USP_RS_ACUMULADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 04/05/2020
-- Description:	Procedure para sacar en lo posible la pestaña del resumen acumulado 
-- =============================================
CREATE PROCEDURE [dbo].[USP_RS_ACUMULADO] 
(@MES INT,
@AÑO INT,
@EFECTIVIDAD VARCHAR(30)
)

AS

BEGIN

DECLARE @fecha_proceso DATE;
SET @fecha_proceso = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)
-------------------------------------------------------------------------
DELETE FROM PLD_TC_CONVENIO_RS_ACUMULADO
WHERE fecha_proceso = @fecha_proceso
-------------------------------------------------------------------------

--*************************************************************************************************** PLD

IF @EFECTIVIDAD != 'Efectividad'
	
BEGIN
	

SELECT * 
INTO #EXPEDIENTES_CALIDAD
FROM PLD_TC_CONVENIO_CALIDAD
WHERE producto = 'PRESTAMO DE LIBRE DISPONIBILIDAD' AND
descripcion_estado in ('Expedientes Ingresados','Expedientes Rechazados', 'Expedientes Desembolsados') AND
fecha_proceso = @fecha_proceso

ALTER TABLE #EXPEDIENTES_CALIDAD DROP COLUMN codigo
----------------------------------------------------------------------
----------///************************************************************************************** PRESTAMO DE LIBRE DISPONIBILIDAD
INSERT INTO PLD_TC_CONVENIO_RS_ACUMULADO

SELECT * 
FROM #EXPEDIENTES_CALIDAD 

UNION ALL

SELECT producto, '4' AS nro,'Expedientes Reprocesados' AS descripcion_estado, fecha_proceso AS fecha_proceso, 
dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,dia14,dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,
dia25,dia26,dia27,dia28,dia29,dia30,dia31,mes1,mes2,mes3
FROM PLD_TC_CONVENIO
WHERE producto = 'PRESTAMO DE LIBRE DISPONIBILIDAD' AND
descripcion = 'EXP.REPROCESOS-DIA' AND fecha_proceso = @fecha_proceso

-----------------------------------------///------

 UNION ALL	

----------INSERT INTO PLD_TC_CONVENIO_RS_ACUMULADO

	SELECT producto, '6' AS nro,'Reprocesos Acumulados' AS descripcion_estado, fecha_proceso AS fecha_proceso, 
dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,dia14,dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,
dia25,dia26,dia27,dia28,dia29,dia30,dia31,mes1,mes2,mes3
FROM PLD_TC_CONVENIO
WHERE producto = 'PRESTAMO DE LIBRE DISPONIBILIDAD' AND
descripcion = 'EXP.REPROCESOS-DIA-ACUMULADO' AND fecha_proceso = @fecha_proceso

UNION ALL 

	SELECT producto, '7' AS nro,'Desembolsos Acumulados' AS descripcion_estado, fecha_proceso AS fecha_proceso, 
dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,dia14,dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,
dia25,dia26,dia27,dia28,dia29,dia30,dia31,mes1,mes2,mes3
FROM PLD_TC_CONVENIO
WHERE producto = 'PRESTAMO DE LIBRE DISPONIBILIDAD' AND
descripcion = 'EXP.DESEMBOLSADOS-ACUMULADO' AND fecha_proceso = @fecha_proceso


----------///************************************************************************************** TARJETA DE CREDITO

--------UNION ALL


--------SELECT * FROM PLD_TC_CONVENIO_CALIDAD WHERE producto = 'TARJETA DE CREDITO' ORDER BY nro

SELECT * 
INTO #EXPEDIENTES_CALIDAD_TC
FROM PLD_TC_CONVENIO_CALIDAD
WHERE producto = 'TARJETA DE CREDITO' AND
descripcion_estado in ('Expedientes Ingresados','Oferta Aprobada','Expedientes Rechazados', 'Oferta Regular','Expedientes Desembolsados') 
AND fecha_proceso = @fecha_proceso

ALTER TABLE #EXPEDIENTES_CALIDAD_TC DROP COLUMN codigo
--------------------------------------------------------------------

INSERT INTO PLD_TC_CONVENIO_RS_ACUMULADO

SELECT * 
FROM #EXPEDIENTES_CALIDAD_TC 

UNION ALL


SELECT producto, '4' AS nro,'Expedientes Reprocesados' AS descripcion_estado, fecha_proceso AS fecha_proceso, 
dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,dia14,dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,
dia25,dia26,dia27,dia28,dia29,dia30,dia31,mes1,mes2,mes3
FROM PLD_TC_CONVENIO
WHERE producto = 'TARJETA DE CREDITO' AND
descripcion = 'EXP.REPROCESOS-DIA' AND fecha_proceso = @fecha_proceso


UNION ALL


	SELECT producto, '6' AS nro,'Reprocesos Acumulados' AS descripcion_estado, fecha_proceso AS fecha_proceso, 
dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,dia14,dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,
dia25,dia26,dia27,dia28,dia29,dia30,dia31,mes1,mes2,mes3
FROM PLD_TC_CONVENIO
WHERE producto = 'TARJETA DE CREDITO' AND
descripcion = 'EXP.REPROCESOS-DIA-ACUMULADO' AND fecha_proceso = @fecha_proceso

UNION ALL 

	SELECT producto, '7' AS nro,'Desembolsos Acumulados' AS descripcion_estado, fecha_proceso AS fecha_proceso, 
dia1,dia2,dia3,dia4,dia5,dia6,dia7,dia8,dia9,dia10,dia11,dia12,dia13,dia14,dia15,dia16,dia17,dia18,dia19,dia20,dia21,dia22,dia23,dia24,
dia25,dia26,dia27,dia28,dia29,dia30,dia31,mes1,mes2,mes3
FROM PLD_TC_CONVENIO
WHERE producto = 'TARJETA DE CREDITO' AND
descripcion = 'EXP.DESEMBOLSADOS-ACUMULADO' AND fecha_proceso = @fecha_proceso


	END

ELSE

	BEGIN
	PRINT 'ES DISTINTO'
	END

-------SELECT * FROM PLD_TC_CONVENIO_RS_ACUMULADO

--*************************************************************************************************** 

END

GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_CANTIDAD_REPROCESO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 10/03/2020
-- Description:	Procedure para sacar cantidad de reprocesos diario, para la tabla dinámica
-- =============================================
CREATE PROCEDURE [dbo].[USP_TB_CS_CANTIDAD_REPROCESO]
(
@MES INT,
@AÑO INT,
@TIPO varchar(20)
)
AS


BEGIN -- START BEGIN PROCEDURE

DECLARE @FECHA_INI DATE;
DECLARE @FECHA_FIN date;

DECLARE @CONTADOR INT = 1;
DECLARE @CONTADOR_MAX INT;

DECLARE @CONTADOR_TIPO INT = 1;
DECLARE @CONTADOR_MAX_TIPO INT;

DECLARE @NOMBRE_TERRITORIO VARCHAR(100);
DECLARE @NOMBRE_TIPO VARCHAR(50);


CREATE TABLE #TIPOS
(
	codigo_t int identity(1,1),
	nombre_tipo varchar(50) not null
)
INSERT INTO #TIPOS
SELECT DISTINCT tipo
FROM TB_CS_CANTIDAD_REPROCESO_DIARIO


CREATE TABLE #TERRITORIOS_PLD_TC
(
	codigo int identity(1,1),
	nombre varchar(150) not null
)
INSERT INTO #TERRITORIOS_PLD_TC
SELECT DISTINCT TERRITORIO 
FROM TB_PYMES_TERRITORIO 
WHERE SUBSTRING(TERRITORIO,1,2) = 'GT'

CREATE TABLE #TERRITORIOS_CONVENIO
(
	codigo int identity(1,1),
	nombre varchar(150) not null
)
INSERT INTO #TERRITORIOS_CONVENIO
SELECT DISTINCT TERRITORIO 
FROM TB_PYMES_TERRITORIO 
WHERE TERRITORIO in ('GT CALLAO SAN MIGUEL', 'GT LIMA CENTRO', 'GT NORTE', 'GT NORTE CHICO', 'GT MIRAFLORES',
'GT ORIENTE', 'GT SURCO -  LA MOLINA', 'FUVEX' )

SET @FECHA_INI = (SELECT DATEFROMPARTS (@AÑO , @MES , 01))

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

IF @tipo = 'DIARIO'

		BEGIN

		DELETE FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
		WHERE convert(date,fecha_proceso) = convert(date,@FECHA_FIN)


		SELECT NRO_EXPEDIENTE, FECHA_HORA_ENVIO AS FECHA_INGRESO
		INTO #CALCULAR_DESEMBOLSO  --------->>> Reemplaza FN.CALCULAR_DESEMBOLSO
		FROM TB_CS
		WHERE ESTADO_EXPEDIENTE = 'Expediente Registrado' 
		--AND NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD'
		and CONVERT(DATE,FECHA_HORA_ENVIO) >= @FECHA_INI
		and CONVERT(DATE,FECHA_HORA_ENVIO) <= @FECHA_FIN
		-------------------------------------------

		SELECT CONVERT(DATE,CD.FECHA_INGRESO) AS FECHA_INGRESO,
		NOMBRE_PRODUCTO,NOMBRE_TIPO_OFERTA, CS.NRO_EXPEDIENTE,CODIGO_OFICINA_GESTORA
		--, ACCION, ESTADO_EXPEDIENTE, PERFIL
		
		INTO #REPROCESOS
		FROM TB_CS CS INNER JOIN #CALCULAR_DESEMBOLSO CD
		ON CS.NRO_EXPEDIENTE = CD.NRO_EXPEDIENTE
		WHERE ACCION IN ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
		-- and NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD'		
		and MONTH(CONVERT(DATE,CS.FECHA_HORA_ENVIO)) = @MES
		and YEAR(CONVERT(DATE,CS.FECHA_HORA_ENVIO)) = @AÑO
		GROUP BY CONVERT(DATE,CD.FECHA_INGRESO), NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA, CS.NRO_EXPEDIENTE, CODIGO_OFICINA_GESTORA
		ORDER BY CONVERT(DATE,CD.FECHA_INGRESO)
		


		INSERT INTO TB_CS_CANTIDAD_REPROCESO_DIARIO
		SELECT  @TIPO,  'REPROCESO' AS 'TIPO', 
		R.FECHA_INGRESO as 'FECHA_INGRESO', 
		[NOMBRE_PRODUCTO] , 
		[NOMBRE_TIPO_OFERTA] ,
		T.TERRITORIO, 
		T.OFICINA, 
		'INGRESADOS EN EL DIA',
		count(distinct(R.NRO_EXPEDIENTE)) AS 'REPROCESOS' , R.NRO_EXPEDIENTE, @FECHA_FIN
		FROM #REPROCESOS R INNER JOIN TB_PYMES_TERRITORIO T 
		ON R.CODIGO_OFICINA_GESTORA = T.COD_OFI		
		WHERE MONTH(CONVERT(DATE,R.FECHA_INGRESO)) = @MES
		and YEAR(CONVERT(DATE,R.FECHA_INGRESO)) = @AÑO		
		GROUP BY R.FECHA_INGRESO,NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA, T.TERRITORIO , T.OFICINA , R.NRO_EXPEDIENTE
		


		UNION ALL

		SELECT  @tipo, 'REPROCESO' AS 'TIPO', 
		CONVERT (DATE,FECHA_HORA_ENVIO) as 'FECHA_REPROCESO', 
		[NOMBRE_PRODUCTO], 
		[NOMBRE_TIPO_OFERTA],
		T.TERRITORIO, 
		T.OFICINA, 
		'TOTAL',
		count(distinct(NRO_EXPEDIENTE)) AS 'REPROCESOS','' ,@FECHA_FIN
		FROM TB_CS C INNER JOIN TB_PYMES_TERRITORIO T 
		ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
		WHERE 
		ACCION IN ('SOLICITAR_ACTUALIZACION_SCORING' , 'APROBADO_CON_MOD_OBS','devolver','no_conforme','OBSERVAR_VERIFICACION')
		and MONTH(CONVERT (DATE,FECHA_HORA_ENVIO)) = @MES
		and YEAR(CONVERT (DATE,FECHA_HORA_ENVIO)) = @AÑO
		group  by  convert(date,FECHA_HORA_ENVIO) , [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA],  T.TERRITORIO , T.OFICINA

		UNION ALL

		select  @tipo , 'PROCESADOS',
		convert(date,FECHA_HORA_ENVIO), 
		[NOMBRE_PRODUCTO] , 
		[NOMBRE_TIPO_OFERTA] ,
		T.TERRITORIO, 
		T.OFICINA, 
		'TOTAL' , 
		COUNT(distinct nro_expediente) ,'', @FECHA_FIN
		FROM TB_CS C INNER JOIN TB_PYMES_TERRITORIO T 
		ON C.CODIGO_OFICINA_GESTORA = T.COD_OFI
		where estado_expediente != 'Cerrado'
		and MONTH(CONVERT (DATE,FECHA_HORA_ENVIO)) = @MES
		and YEAR(CONVERT (DATE,FECHA_HORA_ENVIO)) = @AÑO
		group  by  convert(date,FECHA_HORA_ENVIO) , [NOMBRE_PRODUCTO], [NOMBRE_TIPO_OFERTA],  T.TERRITORIO , T.OFICINA
		ORDER BY 2,3,5,1,4	
		


		----------->>SELECT * FROM TB_CS_CANTIDAD_REPROCESO_DIARIO

		-------------------------------------------------------------------------------///// TABLA DINAMICA 
		-------------------------------------------------------- TOTALES POR TERRITORIO\\\\	
	DELETE FROM TB_CS_CANT_REPROCESO_TB_DINAMICA 
	WHERE fecha_proceso = @FECHA_FIN

	SET @CONTADOR_MAX_TIPO = (SELECT COUNT(codigo_t) FROM #TIPOS)
			WHILE @CONTADOR_TIPO <= @CONTADOR_MAX_TIPO
			BEGIN

			SET @NOMBRE_TIPO = (SELECT nombre_tipo FROM #TIPOS WHERE codigo_t=@CONTADOR_TIPO)
		--------------------------------------------------------------------// TERRITORIOS PLD 
		------------------------------------/* TOTALES */////////////////////////////
			
			SET @CONTADOR_MAX = (SELECT COUNT(codigo) FROM #TERRITORIOS_PLD_TC)
			WHILE @CONTADOR <= @CONTADOR_MAX
			BEGIN								----- START WHILE TERRITORIOS

			SET @NOMBRE_TERRITORIO = (SELECT nombre FROM #TERRITORIOS_PLD_TC WHERE codigo=@CONTADOR)	
				
					
			INSERT INTO TB_CS_CANT_REPROCESO_TB_DINAMICA
			SELECT
			'PRESTAMO DE LIBRE DISPONIBILIDAD' AS [producto],
			'AMBAS' AS [nombre_tipo_oferta], 
				territorio as territorio,
			'TODAS' AS oficina,
			'TOTAL' as resultado,
			@NOMBRE_TIPO as tipo,

			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 1 THEN reprocesos else 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 2 THEN reprocesos else 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 3 THEN reprocesos else 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 4 THEN reprocesos else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 5 THEN reprocesos else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 6 THEN reprocesos else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 7 THEN reprocesos else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 8 THEN reprocesos else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 9 THEN reprocesos else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 10 THEN reprocesos else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 11 THEN reprocesos else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 12 THEN reprocesos else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 13 THEN reprocesos else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 14 THEN reprocesos else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 15 THEN reprocesos else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 16 THEN reprocesos else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 17 THEN reprocesos else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 18 THEN reprocesos else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 19 THEN reprocesos else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 20 THEN reprocesos else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 21 THEN reprocesos else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 22 THEN reprocesos else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 23 THEN reprocesos else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 24 THEN reprocesos else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 25 THEN reprocesos else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 26 THEN reprocesos else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 27 THEN reprocesos else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 28 THEN reprocesos else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 29 THEN reprocesos else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 30 THEN reprocesos else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 31 THEN reprocesos else 0 END),0) AS dia31,	
			ISNULL(SUM(CASE WHEN MONTH(CONVERT(DATE,fecha_ingreso)) = @MES THEN reprocesos else 0 END),0) AS total, 			
			@FECHA_FIN as fecha_proceso																			

			FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
			WHERE NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD'
			AND	territorio = @NOMBRE_TERRITORIO AND tipo = @NOMBRE_TIPO
			AND resul = 'TOTAL' 
			AND MONTH(CONVERT(DATE,fecha_ingreso)) = @MES
			AND YEAR(CONVERT(DATE,fecha_ingreso)) = @AÑO
			group by nombre_producto, territorio, tipo, resul	
					
			-------------------------------------------------///////////////////////DESGLOSE
			UNION ALL
					
			SELECT
			'PRESTAMO DE LIBRE DISPONIBILIDAD' AS [producto],
			nombre_tipo_oferta AS [nombre_tipo_oferta], 
				territorio as territorio,
				oficina AS oficina,
			'INGRESADOS EN EL DIA' as resultado,
			tipo as tipo,

			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 1 THEN reprocesos else 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 2 THEN reprocesos else 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 3 THEN reprocesos else 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 4 THEN reprocesos else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 5 THEN reprocesos else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 6 THEN reprocesos else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 7 THEN reprocesos else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 8 THEN reprocesos else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 9 THEN reprocesos else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 10 THEN reprocesos else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 11 THEN reprocesos else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 12 THEN reprocesos else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 13 THEN reprocesos else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 14 THEN reprocesos else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 15 THEN reprocesos else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 16 THEN reprocesos else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 17 THEN reprocesos else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 18 THEN reprocesos else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 19 THEN reprocesos else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 20 THEN reprocesos else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 21 THEN reprocesos else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 22 THEN reprocesos else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 23 THEN reprocesos else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 24 THEN reprocesos else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 25 THEN reprocesos else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 26 THEN reprocesos else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 27 THEN reprocesos else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 28 THEN reprocesos else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 29 THEN reprocesos else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 30 THEN reprocesos else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 31 THEN reprocesos else 0 END),0) AS dia31,	
			ISNULL(SUM(CASE WHEN MONTH(CONVERT(DATE,fecha_ingreso)) = @MES THEN reprocesos else 0 END),0) AS total, 			
			@FECHA_FIN as fecha_proceso																			

			FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
			WHERE NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD'
			AND	territorio = @NOMBRE_TERRITORIO 
			AND tipo = @NOMBRE_TIPO -----REPROCESO -----PROCESADOS
			AND resul = 'TOTAL' 
			AND MONTH(CONVERT(DATE,fecha_ingreso)) = @MES
			AND YEAR(CONVERT(DATE,fecha_ingreso)) = @AÑO
			group by nombre_producto, nombre_tipo_oferta, territorio,oficina, tipo, resul						
				
				 	
			SET @CONTADOR = @CONTADOR + 1
			END ------ END WHILE TERRITORIOS

			--------------------------------------------------------------------// TERRITORIOS TARJETA DE CREDITO
			------------------------------------/* TOTALES */////////////////////////////
			SET @CONTADOR = 1;


			SET @CONTADOR_MAX = (SELECT COUNT(codigo) FROM #TERRITORIOS_PLD_TC)
			WHILE @CONTADOR <= @CONTADOR_MAX
			BEGIN								----- START WHILE TERRITORIOS

			SET @NOMBRE_TERRITORIO = (SELECT nombre FROM #TERRITORIOS_PLD_TC WHERE codigo=@CONTADOR)	
				
					
			INSERT INTO TB_CS_CANT_REPROCESO_TB_DINAMICA
			SELECT
			'TARJETA DE CREDITO' AS [producto],
			'AMBAS' AS [nombre_tipo_oferta], 
			territorio as territorio,
			'TODAS' AS oficina,
			'TOTAL' as resultado,
			@NOMBRE_TIPO as tipo,

			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 1 THEN reprocesos else 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 2 THEN reprocesos else 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 3 THEN reprocesos else 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 4 THEN reprocesos else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 5 THEN reprocesos else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 6 THEN reprocesos else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 7 THEN reprocesos else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 8 THEN reprocesos else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 9 THEN reprocesos else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 10 THEN reprocesos else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 11 THEN reprocesos else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 12 THEN reprocesos else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 13 THEN reprocesos else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 14 THEN reprocesos else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 15 THEN reprocesos else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 16 THEN reprocesos else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 17 THEN reprocesos else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 18 THEN reprocesos else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 19 THEN reprocesos else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 20 THEN reprocesos else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 21 THEN reprocesos else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 22 THEN reprocesos else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 23 THEN reprocesos else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 24 THEN reprocesos else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 25 THEN reprocesos else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 26 THEN reprocesos else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 27 THEN reprocesos else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 28 THEN reprocesos else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 29 THEN reprocesos else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 30 THEN reprocesos else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 31 THEN reprocesos else 0 END),0) AS dia31,	
			ISNULL(SUM(CASE WHEN MONTH(CONVERT(DATE,fecha_ingreso)) = @MES THEN reprocesos else 0 END),0) AS total,			
			@FECHA_FIN as fecha_proceso																			

			FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
			WHERE NOMBRE_PRODUCTO = 'TARJETA DE CREDITO'
			AND	territorio = @NOMBRE_TERRITORIO 
			AND tipo = @NOMBRE_TIPO ----- REPROCESO -----PROCESADOS
			AND resul = 'TOTAL' 
			AND MONTH(CONVERT(DATE,fecha_ingreso)) = @MES
			AND YEAR(CONVERT(DATE,fecha_ingreso)) = @AÑO
			group by nombre_producto, territorio, tipo, resul					
					
			-------------------------------------------------///////////////////////DESGLOSE
			UNION ALL

			SELECT
			'TARJETA DE CREDITO' AS [producto],
			nombre_tipo_oferta AS [nombre_tipo_oferta], 
				territorio as territorio,
				oficina AS oficina,
			'INGRESADOS EN EL DIA' as resultado,
			tipo as tipo,

			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 1 THEN reprocesos else 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 2 THEN reprocesos else 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 3 THEN reprocesos else 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 4 THEN reprocesos else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 5 THEN reprocesos else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 6 THEN reprocesos else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 7 THEN reprocesos else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 8 THEN reprocesos else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 9 THEN reprocesos else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 10 THEN reprocesos else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 11 THEN reprocesos else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 12 THEN reprocesos else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 13 THEN reprocesos else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 14 THEN reprocesos else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 15 THEN reprocesos else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 16 THEN reprocesos else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 17 THEN reprocesos else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 18 THEN reprocesos else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 19 THEN reprocesos else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 20 THEN reprocesos else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 21 THEN reprocesos else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 22 THEN reprocesos else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 23 THEN reprocesos else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 24 THEN reprocesos else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 25 THEN reprocesos else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 26 THEN reprocesos else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 27 THEN reprocesos else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 28 THEN reprocesos else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 29 THEN reprocesos else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 30 THEN reprocesos else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 31 THEN reprocesos else 0 END),0) AS dia31,	
			ISNULL(SUM(CASE WHEN MONTH(CONVERT(DATE,fecha_ingreso)) = @MES THEN reprocesos else 0 END),0) AS total, 			
			@FECHA_FIN as fecha_proceso 

			FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
			WHERE NOMBRE_PRODUCTO = 'TARJETA DE CREDITO'
			AND	territorio = @NOMBRE_TERRITORIO  --------@NOMBRE_TERRITORIO 
			AND tipo = @NOMBRE_TIPO-------@NOMBRE_TIPO
			AND resul = 'TOTAL'
			AND MONTH(CONVERT(DATE,fecha_ingreso)) = @MES
			AND YEAR(CONVERT(DATE,fecha_ingreso)) = @AÑO
			group by nombre_producto, nombre_tipo_oferta, territorio,oficina, tipo, resul					
				
				 	
			SET @CONTADOR = @CONTADOR + 1
			END --------- END WHILE TERRITORIOS


			--------------------------------------------------------------------// TERRITORIOS CONVENIO
			------------------------------------/* TOTALES */////////////////////////////

			SET @CONTADOR = 1;


			SET @CONTADOR_MAX = (SELECT COUNT(codigo) FROM #TERRITORIOS_CONVENIO)
			WHILE @CONTADOR <= @CONTADOR_MAX
			BEGIN								----- START WHILE TERRITORIOS

			SET @NOMBRE_TERRITORIO = (SELECT nombre FROM #TERRITORIOS_CONVENIO WHERE codigo=@CONTADOR)					
					
			INSERT INTO TB_CS_CANT_REPROCESO_TB_DINAMICA
			SELECT
			'CONVENIO' AS [producto],
			'AMBAS' AS [nombre_tipo_oferta], 
				territorio as territorio,
			'TODAS' AS oficina,
			'TOTAL' as resultado,
			@NOMBRE_TIPO as tipo,

			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 1 THEN reprocesos else 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 2 THEN reprocesos else 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 3 THEN reprocesos else 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 4 THEN reprocesos else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 5 THEN reprocesos else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 6 THEN reprocesos else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 7 THEN reprocesos else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 8 THEN reprocesos else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 9 THEN reprocesos else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 10 THEN reprocesos else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 11 THEN reprocesos else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 12 THEN reprocesos else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 13 THEN reprocesos else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 14 THEN reprocesos else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 15 THEN reprocesos else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 16 THEN reprocesos else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 17 THEN reprocesos else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 18 THEN reprocesos else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 19 THEN reprocesos else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 20 THEN reprocesos else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 21 THEN reprocesos else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 22 THEN reprocesos else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 23 THEN reprocesos else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 24 THEN reprocesos else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 25 THEN reprocesos else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 26 THEN reprocesos else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 27 THEN reprocesos else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 28 THEN reprocesos else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 29 THEN reprocesos else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 30 THEN reprocesos else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 31 THEN reprocesos else 0 END),0) AS dia31,	
			ISNULL(SUM(CASE WHEN MONTH(CONVERT(DATE,fecha_ingreso)) = @MES THEN reprocesos else 0 END),0) AS total, 			
			@FECHA_FIN as fecha_proceso																			

			FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
			WHERE NOMBRE_PRODUCTO = 'CONVENIO'
			AND	territorio = @NOMBRE_TERRITORIO AND tipo = @NOMBRE_TIPO
			AND resul = 'TOTAL' 
			AND MONTH(CONVERT(DATE,fecha_ingreso)) = @MES
			AND YEAR(CONVERT(DATE,fecha_ingreso)) = @AÑO
			group by nombre_producto, territorio, tipo, resul

			-----------------------------------------------///////////////////////DESGLOSE

			UNION ALL			

			SELECT
			'CONVENIO' AS [producto],
			nombre_tipo_oferta AS [nombre_tipo_oferta], 
				territorio as territorio,
				oficina AS oficina,
			'INGRESADOS EN EL DIA' as resultado,
			tipo as tipo,

			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 1 THEN reprocesos else 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 2 THEN reprocesos else 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 3 THEN reprocesos else 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 4 THEN reprocesos else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 5 THEN reprocesos else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 6 THEN reprocesos else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 7 THEN reprocesos else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 8 THEN reprocesos else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 9 THEN reprocesos else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 10 THEN reprocesos else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 11 THEN reprocesos else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 12 THEN reprocesos else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 13 THEN reprocesos else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 14 THEN reprocesos else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 15 THEN reprocesos else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 16 THEN reprocesos else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 17 THEN reprocesos else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 18 THEN reprocesos else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 19 THEN reprocesos else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 20 THEN reprocesos else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 21 THEN reprocesos else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 22 THEN reprocesos else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 23 THEN reprocesos else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 24 THEN reprocesos else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 25 THEN reprocesos else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 26 THEN reprocesos else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 27 THEN reprocesos else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 28 THEN reprocesos else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 29 THEN reprocesos else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 30 THEN reprocesos else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,fecha_ingreso)) = 31 THEN reprocesos else 0 END),0) AS dia31,	
			ISNULL(SUM(CASE WHEN MONTH(CONVERT(DATE,fecha_ingreso)) = @MES THEN reprocesos else 0 END),0) AS total, 			
			@FECHA_FIN as fecha_proceso																			

			FROM TB_CS_CANTIDAD_REPROCESO_DIARIO
			WHERE NOMBRE_PRODUCTO = 'CONVENIO'
			AND	territorio = @NOMBRE_TERRITORIO 
			AND tipo = @NOMBRE_TIPO
			AND resul = 'TOTAL' 
			AND MONTH(CONVERT(DATE,fecha_ingreso)) = @MES
			AND YEAR(CONVERT(DATE,fecha_ingreso)) = @AÑO
			group by nombre_producto, nombre_tipo_oferta, territorio,oficina, tipo, resul										
				 	
			SET @CONTADOR = @CONTADOR + 1
			END ------ END WHILE TERRITORIOS

			SET @CONTADOR = 1;


	SET @CONTADOR_TIPO = @CONTADOR_TIPO + 1	
	END ---------- END WHILE TIPOS (REPROCESO, PROCESO)

END ---------- END IF

	------------SELECT * FROM TB_CS_CANT_REPROCESO_TB_DINAMICA

END ------------ END BEGIN PROCEDURE
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_FILTRO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TB_CS_FILTRO]
AS

BEGIN

--DELETE FROM TB_CS_TEMPORAL

CREATE TABLE #TB_CS_TEMPORAL(
	[NRO_EXPEDIENTE] [varchar](20) NULL,
	[ESTADO_EXPEDIENTE] [varchar](100) NULL,
	[PERFIL] [varchar](100) NULL,
	[ACCION] [varchar](100) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[FECHA_HORA_LLEGADA] [datetime] NULL,
	[FECHA_HORA_ENVIO] [datetime] NULL,
	[TIEMPO_COLA_TC] [decimal](10, 3) NULL,
	[TIEMPO_PROCESO_TP] [decimal](10, 3) NULL,
	[ANS] [bigint] NULL,
	[OBSERVACION] [nvarchar](600) NULL,
	[CODIGO_OFICINA_GESTORA] [varchar](50) NULL,
	[CODIGO_OFICINA_USUARIO] [varchar](10) NULL,
	[CODIGO_TERRITORIO_GESTORA] [varchar](10) NULL,
	[CODIGO_TERRITORIO_USUARIO] [varchar](10) NULL
)



INSERT INTO #TB_CS_TEMPORAL
SELECT 
NRO_EXPEDIENTE,
ESTADO_EXPEDIENTE,
PERFIL,
ACCION,
NOMBRE_PRODUCTO,
NOMBRE_TIPO_OFERTA,
FECHA_HORA_LLEGADA,
FECHA_HORA_ENVIO,
TIEMPO_COLA_TC,
TIEMPO_PROCESO_TP,
ANS,
OBSERVACION,
CODIGO_OFICINA_GESTORA,
CODIGO_OFICINA_USUARIO,
CODIGO_TERRITORIO_GESTORA,
CODIGO_TERRITORIO_USUARIO 
FROM TB_CS
GROUP BY NRO_EXPEDIENTE,
ESTADO_EXPEDIENTE,
PERFIL,
ACCION,
NOMBRE_PRODUCTO,
NOMBRE_TIPO_OFERTA,
FECHA_HORA_LLEGADA,
FECHA_HORA_ENVIO,
TIEMPO_COLA_TC,
TIEMPO_PROCESO_TP,
ANS,
OBSERVACION,
CODIGO_OFICINA_GESTORA,
CODIGO_OFICINA_USUARIO,
CODIGO_TERRITORIO_GESTORA,
CODIGO_TERRITORIO_USUARIO 
ORDER BY NRO_EXPEDIENTE, FECHA_HORA_LLEGADA DESC

DELETE FROM TB_CS

INSERT INTO TB_CS


SELECT * FROM #TB_CS_TEMPORAL


END


GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_PERCENTIL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 06/03/2020
-- Description:	Percentiles 'TIEMPO-OFERTA-APROBADA-UTILES-LAB' y 'TIEMPO-OFERTA-REGULAR-UTILES-LAB', demora poquisimo
-- ==================================================================================================================
CREATE PROCEDURE  [dbo].[USP_TB_CS_PERCENTIL] (
@FECHA DATETIME,
@NOMBRE_PRODUCTO VARCHAR(100),
@NOMBRE_TIPO_OFERTA VARCHAR(100)
)

AS

BEGIN 

DECLARE @COUNTWHILE INT = 1; 
DECLARE @COUNTWHILEMAX INT = 1; 
DECLARE @EXPEDIENTE VARCHAR(10);


DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;
DECLARE @FECHA_MAX DATE;


SELECT @FECHA_MAX =(SELECT MAX(FECHA_HORA_ENVIO) 
						FROM TB_CS
						WHERE MONTH (FECHA_HORA_ENVIO) = MONTH(@FECHA)
						AND YEAR(FECHA_HORA_ENVIO) = YEAR(@FECHA))

-----------------------------------------------------------------------------------------------REPROCESAR
DELETE FROM TB_CS_PERCENTIL 
WHERE FECHA = @FECHA and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA
---------------------------------------------------------------------------------------------------------
CREATE TABLE #TB_CS_PERCENTIL(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FECHA] [datetime] NULL,
	[PERCENTIL] [decimal](10, 2) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL
) 
CREATE TABLE #TB_CS_PER(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NUM] [int] NULL,
	[TIE] [decimal](10, 3) NULL,
	[CAL] [decimal](10, 3) NULL
)
----------------------------------------------- PARA EL WHILE DEL DETALLE DE TIEMPOS DE CADA EXPEDIENTE POR BANDEJA
CREATE TABLE #CALCULAR_DESEMBOLSO
( CODIGO INT IDENTITY(1,1) NOT NULL,
  NRO_EXP VARCHAR(10),
  FECHA_ENVIO DATETIME
)
----------------------------------------------------------------------------
select  @COUNT =  COUNT(ID)
from  TB_CS
WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE')
AND ACCION!='GRABAR' 
and   CONVERT (date, FECHA_HORA_ENVIO)=  CONVERT (date, @FECHA )
and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
and NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA
----------------------------------------------------------------------------
if @COUNT=1
	begin 
	set @PERCENTIL = 1 
	end 
else 
	begin 
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;
	end 
---------------------------------------------------------------------------------------------DIAS LABORALES
INSERT INTO #TB_CS_PER
select 
ROW_NUMBER() OVER(ORDER BY [dbo].[fn_tiempo_horas] (dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO)) AS Row,
[dbo].[fn_tiempo_horas](dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO),
[dbo].FN_TIEMPO_CALEN(dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO)
from  TB_CS
WHERE (ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE') 
AND ACCION!='GRABAR' 
and CONVERT (date, FECHA_HORA_ENVIO)=   CONVERT (date,@FECHA )
and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
and NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA


-------SELECT * FROM #TB_CS_PER


SELECT @CAL=  [CAL] FROM  #TB_CS_PER
WHERE  NUM= convert ( int , @PERCENTIL) 

SELECT @LAB=  [TIE] FROM  #TB_CS_PER
WHERE  NUM= convert ( int , (@PERCENTIL) )

-----SELECT @LAB


------INSERT INTO #TB_CS_PERCENTIL
INSERT INTO TB_CS_PERCENTIL
VALUES (@FECHA ,  @LAB,@NOMBRE_PRODUCTO,@NOMBRE_TIPO_OFERTA ,'DÍAS ÚTILES' )

-----INSERT INTO #TB_CS_PERCENTIL
INSERT INTO TB_CS_PERCENTIL
VALUES (@FECHA ,  @CAL,@NOMBRE_PRODUCTO,@NOMBRE_TIPO_OFERTA ,'DÍAS CALENDARIO')


-----------------------------///[dbo].[FN_CALCULAR_DESEMBOLSO]>> Devuelve la fecha en la que se registro el expediente pero demora mas
----------------------------/// entonces hago lo siguiente:
INSERT INTO #CALCULAR_DESEMBOLSO
SELECT NRO_EXPEDIENTE, FECHA_HORA_ENVIO
FROM TB_CS
WHERE (ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE') 
	AND ACCION!='GRABAR' 	
and CONVERT(date, FECHA_HORA_ENVIO) = CONVERT(date, @FECHA )
and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA


INSERT INTO PLD_TC_CONVENIO_DETALLE_TIEMPOS(nro_expediente, tiempo, perfil, nombre_producto, 
nombre_tipo_oferta, fecha_hora_envio, tipo, fecha_proceso)
--------------** DETALLE DE TIEMPOS OFERTAS EN DIAS UTILES LAB
	SELECT DISTINCT D.NRO_EXP, 
	[dbo].[fn_tiempo_horas] (C.FECHA_HORA_ENVIO,D.FECHA_ENVIO) AS TIEMPO,
	PERFIL,
	NOMBRE_PRODUCTO AS nombre_producto, 
	NOMBRE_TIPO_OFERTA AS nombre_tipo_oferta,			
	CONVERT(DATE,C.FECHA_HORA_ENVIO) AS FECHA,
	'UTILES-LAB' AS tipo,
	@FECHA_MAX AS fecha_proceso	
	
	FROM  TB_CS C INNER JOIN #CALCULAR_DESEMBOLSO D
	ON C.NRO_EXPEDIENTE = D.NRO_EXP
	WHERE (ESTADO_EXPEDIENTE='Expediente Registrado')	
	--AND MONTH(FECHA_HORA_ENVIO) = MONTH(@FECHA)
	--AND YEAR(FECHA_HORA_ENVIO) = YEAR(@FECHA)
	AND NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
	AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA	
	ORDER BY TIEMPO
	
--	------------------------------------------------------------------// DETALLE DE TIEMPOS DE CADA EXPEDIENTE POR BANDEJA
	SET @COUNTWHILEMAX = (SELECT COUNT(NRO_EXP) FROM #CALCULAR_DESEMBOLSO) 

	WHILE (@COUNTWHILE <= @COUNTWHILEMAX)
	BEGIN

	SET @EXPEDIENTE = (SELECT NRO_EXP FROM #CALCULAR_DESEMBOLSO WHERE CODIGO = @COUNTWHILE)	

	INSERT INTO PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA
	SELECT C.NRO_EXPEDIENTE,FECHA_HORA_LLEGADA, C.FECHA_HORA_ENVIO,
		 SUM([dbo].[fn_tiempo_horas] (FECHA_HORA_LLEGADA,C.FECHA_HORA_ENVIO)) AS TIEMPO,	PERFIL,  @NOMBRE_PRODUCTO,
		 @NOMBRE_TIPO_OFERTA, @FECHA_MAX
	FROM  TB_CS C INNER JOIN #CALCULAR_DESEMBOLSO D
	ON C.NRO_EXPEDIENTE = D.NRO_EXP
	WHERE C.NRO_EXPEDIENTE = @EXPEDIENTE
	AND NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
	AND NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA	
	GROUP BY NRO_EXPEDIENTE, FECHA_HORA_ENVIO, FECHA_HORA_LLEGADA,PERFIL
	

	SET @COUNTWHILE = @COUNTWHILE  + 1;
	END
	--------SELECT * FROM #PLD_TC_CONVENIO_DETALLE_TIEMPOS ORDER BY NRO_EXPEDIENTE
	--------SELECT * FROM #PLD_TC_CONVENIO_DETALLE_TIEMPOS_BDJA ORDER BY nro_expediente

	--DROP TABLE #EXPEDIENTES
	--DROP TABLE #TB_CS_PER
	--DROP TABLE #CALCULAR_DESEMBOLSO

END 







GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_PERCENTIL_DIA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_TB_CS_PERCENTIL_DIA] (
@FECHA DATETIME,
@NOMBRE_PRODUCTO VARCHAR(100))

AS

BEGIN 


DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5) = 0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

CREATE TABLE #TB_CS_PERCENTIL(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FECHA] [datetime] NULL,
	[PERCENTIL] [decimal](10, 2) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL
) ON [PRIMARY]

CREATE TABLE #TB_CS_PER(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NUM] [int] NULL,
	[TIE] [decimal](10, 3) NULL,
	[CAL] [decimal](10, 3) NULL
) ON [PRIMARY]


select @COUNT =  COUNT(*)
from  TB_CS
WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE') 
AND ACCION!='GRABAR' 
and   CONVERT (date, FECHA_HORA_ENVIO)=   CONVERT (date, @FECHA )
and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO

set @COUNT = @COUNT  
SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;   

--//////////////////////////////////////////////////////////////////////////////
--///////////////////DIAS LABORABLES////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////

INSERT INTO #TB_CS_PER
select 
ROW_NUMBER() OVER(ORDER BY [dbo].[fn_tiempo_horas] (  dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO)  ) AS Row,
[dbo].[fn_tiempo_horas] (  dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO) ,
[dbo].FN_TIEMPO_CALEN  (  dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO)
from  TB_CS
WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE') 

AND ACCION!='GRABAR' 
and   CONVERT (date, FECHA_HORA_ENVIO)=   CONVERT (date, @FECHA )
and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 


SELECT @LAB=  [TIE] FROM  #TB_CS_PER
WHERE  NUM= convert ( int , ceiling(@PERCENTIL)) 

SELECT @CAL=  [CAL] FROM  #TB_CS_PER
WHERE  NUM= convert ( int , ceiling(@PERCENTIL)) 

SELECT * FROM #TB_CS_PER
SELECT @LAB
SELECT @CAL


----INSERT INTO #TB_CS_PERCENTIL
--INSERT INTO TB_CS_PERCENTIL
--VALUES (@FECHA ,  @LAB,@NOMBRE_PRODUCTO,'DÍA' ,'DÍAS ÚTILES' 
--)

----INSERT INTO #TB_CS_PERCENTIL
--INSERT INTO TB_CS_PERCENTIL
--VALUES (@FECHA ,  @CAL,@NOMBRE_PRODUCTO,'DÍA' ,'DÍAS CALENDARIO')

		--SELECT * FROM TB_CS_PERCENTIL 
		--WHERE 
		--NOMBRE_PRODUCTO = 'PRESTAMO DE LIBRE DISPONIBILIDAD'
		--AND NOMBRE_TIPO_OFERTA = 'DÍA' AND TIPO = 'DÍAS CALENDARIO'
		--ORDER BY FECHA ASC
END 







GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_PERCENTIL_FECHAS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NO LO SE - Replicado por Didier Yepez Cabanillas
-- Create date: Alguna fecha del 2017
-- Description:	Procedure para sacar percentiles
-- =============================================
CREATE PROCEDURE [dbo].[USP_TB_CS_PERCENTIL_FECHAS]
(
@MES int,
@AÑO int,
@TIPO VARCHAR(100)
)

AS

BEGIN  -- BEGIN


DECLARE @Fecha datetime
DECLARE @BANDEJA VARCHAR(100)
DECLARE @FECHA_INI datetime
DECLARE @FECHA_MAX datetime

DECLARE @CONTADOR int = 1;
DECLARE @MAX1 int;

CREATE TABLE #FEC1
( Id int identity(1,1) NOT NULL PRIMARY KEY,
Fecha varchar(255) NULL,
);

SET @FECHA_INI = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial


SELECT @FECHA_MAX =(SELECT MAX(FECHA_HORA_ENVIO) 
						FROM TB_CS
						WHERE MONTH (FECHA_HORA_ENVIO) = @MES
						AND YEAR(FECHA_HORA_ENVIO) = @AÑO)

IF @TIPO = 'BANDEJA'
	BEGIN
			DELETE   FROM [dbo].[TB_CS_PERCENTIL_BANDEJA]
	END 
ELSE 
BEGIN

    DELETE FROM [dbo].[TB_CS_PERCENTIL]	WHERE MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO		

    EXEC [USP_TB_CS_PERCENTIL_MES] @FECHA_INI , @FECHA_MAX, 'PRESTAMO DE LIBRE DISPONIBILIDAD' 
    EXEC [USP_TB_CS_PERCENTIL_MES] @FECHA_INI , @FECHA_MAX, 'TARJETA DE CREDITO' 

    --NO SALEN RESULTADOS
    EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @MES , @AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD' , 'APROBADO'
    EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @MES , @AÑO,'PRESTAMO DE LIBRE DISPONIBILIDAD' , 'REGULAR'
    EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @MES , @AÑO,'TARJETA DE CREDITO' , 'REGULAR'
    EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @MES , @AÑO,'TARJETA DE CREDITO' , 'APROBADO'
    EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @MES , @AÑO,'CONVENIO' , 'REGULAR'
    EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @MES , @AÑO,'CONVENIO' , 'APROBADO'

END 



INSERT #FEC1 (Fecha)
SELECT  
DISTINCT (CONVERT(DATE, FECHA_HORA_ENVIO))
FROM TB_CS
where 
MONTH(CONVERT(DATE, FECHA_HORA_ENVIO)) =  @MES
and  year (CONVERT(DATE, FECHA_HORA_ENVIO)) = @AÑO
ORDER BY 1

SET @MAX1 = (SELECT COUNT(Id) FROM #FEC1)
WHILE @CONTADOR <= @MAX1

BEGIN -- 

SET @FECHA = (SELECT FECHA FROM #FEC1 WHERE Id=@CONTADOR)

IF @TIPO = 'GLOBAL'
		BEGIN		
		
						
		EXEC [dbo].[USP_TB_CS_PERCENTIL]  @Fecha , 'PRESTAMO DE LIBRE DISPONIBILIDAD' , 'REGULAR' 
		EXEC [dbo].[USP_TB_CS_PERCENTIL]  @Fecha , 'PRESTAMO DE LIBRE DISPONIBILIDAD' , 'APROBADO' 
		EXEC [dbo].[USP_TB_CS_PERCENTIL]  @Fecha , 'TARJETA DE CREDITO' , 'REGULAR' 
		EXEC [dbo].[USP_TB_CS_PERCENTIL]  @Fecha , 'TARJETA DE CREDITO' , 'APROBADO' 
		EXEC [dbo].[USP_TB_CS_PERCENTIL]  @Fecha , 'CONVENIO' , 'REGULAR' 
		EXEC [dbo].[USP_TB_CS_PERCENTIL]  @Fecha , 'CONVENIO' , 'APROBADO' 					

		---------------------------------------------------// No son necesarios, no aparecen en ningun lado. 21-07-2020
		----EXEC [USP_TB_CS_PERCENTIL_DIA] @Fecha , 'PRESTAMO DE LIBRE DISPONIBILIDAD'
		----EXEC [USP_TB_CS_PERCENTIL_DIA] @Fecha , 'TARJETA DE CREDITO' 
		----EXEC [USP_TB_CS_PERCENTIL_DIA] @Fecha , 'CONVENIO' 
		
		END 


ELSE 
	BEGIN
		BEGIN -- CBAND  

				DECLARE CBAND CURSOR FOR
				SELECT BANDEJA
				FROM TB_CS_BANDEJA
				open CBAND
				fetch next from CBAND into @BANDEJA
				while @@fetch_status=0

					begin            

						IF CONVERT (DATE, @Fecha ) =  CONVERT (DATE, @FECHA_MAX )
						BEGIN
                      
                    
						EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @FECHA_INI , @FECHA_MAX,'PRESTAMO DE LIBRE DISPONIBILIDAD' , 'APROBADO'
						EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @FECHA_INI , @FECHA_MAX,'CONVENIO' , 'APROBADO'
						EXEC [USP_TB_CS_PERCENTIL_MES_OFERTA] @FECHA_INI , @FECHA_MAX,'TARJETA DE CREDITO' , 'APROBADO'

						END

					fetch next from CBAND into @BANDEJA

					end

				close CBAND
				deallocate CBAND
			END -- CBAND  cOficina

	END
		
SET @CONTADOR=@CONTADOR+1

END -- CURSOR FECHAS

END -- END BEGIN PRINCIPAL





GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_PERCENTIL_MES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================
-- Author:		NO LO SE - Replicado por Didier Yepez Cabanillas
-- Create date: Alguna fecha del 2017
-- Description:	Procedure para sacar percentiles del mes demora alrededor de 9 minutos para sacar de un mes entero
-- ===============================================================================================================

CREATE PROCEDURE  [dbo].[USP_TB_CS_PERCENTIL_MES] (
@FECHA DATETIME,
@FECHA_FIN DATETIME,
@NOMBRE_PRODUCTO VARCHAR(100)
)
AS
BEGIN 

DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

DELETE FROM TB_CS_PERCENTIL 
WHERE FECHA = @FECHA_FIN and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
AND NOMBRE_TIPO_OFERTA = 'MES'

PRINT ('DELETE FROM TB_CS_PERCENTIL WHERE FECHA =' +convert(varchar,@FECHA_FIN) + '
 and NOMBRE_PRODUCTO = ' + @NOMBRE_PRODUCTO + ' AND NOMBRE_TIPO_OFERTA = MES'  )

select 
ROW_NUMBER() OVER(ORDER BY [dbo].[fn_tiempo_horas] (  dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO)  ) AS NUM,
[dbo].[fn_tiempo_horas] (  dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO) as TIE ,
0 as CAL
INTO #PARTE1
from  TB_CS
WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE') 
AND ACCION!='GRABAR' 
and   CONVERT (date, FECHA_HORA_ENVIO)>=   CONVERT (date, @FECHA )
and   CONVERT (date, FECHA_HORA_ENVIO)<=   CONVERT (date, @FECHA_FIN )
AND NOMBRE_PRODUCTO=@NOMBRE_PRODUCTO

select @COUNT =  COUNT(*) from #PARTE1
SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;   
SELECT @LAB=  TIE FROM  #PARTE1
WHERE  NUM= convert ( int , floor(@PERCENTIL)) 
--------------------

select 
ROW_NUMBER() OVER(ORDER BY [dbo].[fn_tiempo_horas] (  dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO)  ) AS NUM,
0 as TIE ,
[dbo].FN_TIEMPO_CALEN  (  dbo.FN_CALCULAR_DESEMBOLSO(NRO_EXPEDIENTE),FECHA_HORA_ENVIO) as CAL
INTO #PARTE2
from  TB_CS
WHERE ( ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE') 
AND ACCION!='GRABAR' 
and   CONVERT (date, FECHA_HORA_ENVIO)>=   CONVERT (date, @FECHA )
and   CONVERT (date, FECHA_HORA_ENVIO)<=   CONVERT (date, @FECHA_FIN )
AND NOMBRE_PRODUCTO=@NOMBRE_PRODUCTO


SELECT @CAL=  CAL FROM  #PARTE2
WHERE  NUM= convert ( int , floor(@PERCENTIL)) 

--select * from #PARTE1
--select * from #PARTE2

--SELECT @CAL
--SELECT @LAB

INSERT INTO TB_CS_PERCENTIL
VALUES (@FECHA_FIN ,  @LAB,@NOMBRE_PRODUCTO,'MES' ,'DÍAS ÚTILES' 
)
INSERT INTO TB_CS_PERCENTIL
VALUES (@FECHA_FIN ,  @CAL,@NOMBRE_PRODUCTO,'MES' ,'DÍAS CALENDARIO')

drop table #PARTE1
drop table #PARTE2

END 

GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_PERCENTIL_MES_OFERTA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NO LO SE - Replicado por Didier Yepez Cabanillas
-- Create date: Alguna fecha del 2017
-- Description:	Procedure para sacar percentiles DEL MES
-- =============================================
CREATE  PROCEDURE  [dbo].[USP_TB_CS_PERCENTIL_MES_OFERTA] (
@MES INT,
@AÑO INT,
@NOMBRE_PRODUCTO VARCHAR(100),
@NOMBRE_TIPO_OFERTA VARCHAR(100)
)
AS

BEGIN 

DECLARE @FECHA_FIN DATETIME;
DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;


SET @FECHA_FIN = (SELECT MAX(CONVERT(DATE,FECHA_HORA_ENVIO)) 
					FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)
--
----fn_tiempo_horas devuelve la cantidad de horas
----FN_CALCULAR_DESEMBOLSO devuelve la fecha/hora en la que se registro el expediente

SELECT DISTINCT NRO_EXPEDIENTE AS NRO_EXPEDIENTE,FECHA_HORA_ENVIO AS FECHA_FINAL
			INTO #DESEMBOLSADOS1
			FROM  TB_CS
			WHERE (ESTADO_EXPEDIENTE='DESEMBOLSADO / EN EMBOSE')
			AND ACCION!='GRABAR'
			AND MONTH(FECHA_HORA_ENVIO) = @MES	
			AND YEAR(FECHA_HORA_ENVIO) = @AÑO 
			AND NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO
			and NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA

			--------------------------------------->>>>>

			SELECT DISTINCT C.NRO_EXPEDIENTE, MIN(FECHA_HORA_ENVIO) AS FECHA_INICIAL, D.FECHA_FINAL
			INTO #PROCESO
			FROM TB_CS C INNER JOIN #DESEMBOLSADOS1 D
			ON C.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
			WHERE NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO
			AND C.ESTADO_EXPEDIENTE = 'Expediente Registrado'
			AND C.NOMBRE_TIPO_OFERTA = @NOMBRE_TIPO_OFERTA
			GROUP BY C.NRO_EXPEDIENTE, D.FECHA_FINAL
			
---------------------- DIAS UTILES
SELECT 
ROW_NUMBER() OVER(ORDER BY [dbo].[fn_tiempo_horas] (FECHA_INICIAL,FECHA_FINAL)) AS NUM,
[dbo].[fn_tiempo_horas] (FECHA_INICIAL,FECHA_FINAL) as TIE,
0 as CAL
INTO #PARTE1
FROM  #PROCESO

select @COUNT =  COUNT(NUM) from #PARTE1

IF @COUNT = 1 
BEGIN 
SET  @PERCENTIL =    1
END 
ELSE 
BEGIN 
SET  @PERCENTIL =     90.0 * (@COUNT) /100.0;   
END


SELECT @LAB=  TIE FROM  #PARTE1
WHERE  NUM= convert ( int , floor(@PERCENTIL)) 

-------------------- DIAS CALENDARIO
select 
ROW_NUMBER() OVER(ORDER BY [dbo].[fn_tiempo_horas] (FECHA_INICIAL,FECHA_FINAL)) AS NUM,
0 as TIE,
[dbo].FN_TIEMPO_CALEN(FECHA_INICIAL,FECHA_FINAL) as CAL
INTO #PARTE2
FROM  #PROCESO

SELECT @CAL=  TIE FROM  #PARTE2
WHERE NUM = convert (int, floor(@PERCENTIL)) 



INSERT INTO TB_CS_PERCENTIL
VALUES (@FECHA_FIN ,  @LAB,@NOMBRE_PRODUCTO,@NOMBRE_TIPO_OFERTA + '-MES' ,'DÍAS ÚTILES')

INSERT INTO TB_CS_PERCENTIL
VALUES (@FECHA_FIN ,  @CAL,@NOMBRE_PRODUCTO,@NOMBRE_TIPO_OFERTA + '-MES' ,'DÍAS CALENDARIO')



INSERT INTO PLD_TC_CONVENIO_DETALLE_TIEMPOS(nro_expediente, tiempo, perfil, nombre_producto, nombre_tipo_oferta, 
fecha_hora_envio, tipo, fecha_proceso)
--------->>>>>> FN_CALCULAR_DESEMBOLSO : devuelve la fecha en la que el expediente se registro
--------------** REPROCESO DETALLE DE TIEMPOS PARA PERCENTIL MES OFERTAS EN DIAS UTILES LAB
	SELECT NRO_EXPEDIENTE, [dbo].[fn_tiempo_horas] (FECHA_INICIAL,FECHA_FINAL) AS TIEMPO,
	'EJECUTIVO',
	@NOMBRE_PRODUCTO AS nombre_producto, 
	@NOMBRE_TIPO_OFERTA AS nombre_tipo_oferta,			
	FECHA_INICIAL AS fecha_hora_envio,
	@NOMBRE_TIPO_OFERTA + '-MES' AS tipo,
	@FECHA_FIN AS fecha_proceso	

	FROM  #PROCESO 
	
----------- DROPEO
DROP TABLE #DESEMBOLSADOS1
DROP TABLE #PROCESO
DROP TABLE #PARTE1
DROP TABLE #PARTE2

END 





GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_SUBIR]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 01/02/2020
-- Description:	Procedure para cargar la base de consumo CS
-- =============================================

CREATE PROCEDURE  [dbo].[USP_TB_CS_SUBIR] 
( 
@archivo varchar(150)
)
AS

BEGIN

DECLARE @DIA VARCHAR(10)  = '0'
DECLARE @MES VARCHAR(10)  = '0'
DECLARE @ANO VARCHAR(10) = '0'

DECLARE @FECHA_INI DATE  = NULL
DECLARE @FECHA_FIN DATE = NULL


--SELECT @DIA= SUBSTRING (@archivo1, 1 ,2)
--SELECT @MES= SUBSTRING (@archivo1, 3 ,2)
--SELECT @ANO= SUBSTRING (@archivo1, 5 ,4)

--SET @FECHA_INI = CONVERT ( DATE ,@ANO +'/'+   @MES  +'/'+ '01')
--SET @FECHA_FIN = CONVERT ( DATE ,@ANO +'/'+   @MES  +'/'+ @DIA)

--DELETE FROM TB_CS_TEMP;

CREATE TABLE #TB_CS_TEMP(
	[NRO_EXPEDIENTE] [varchar](20) NULL,
	[NUMERO_REGISTRO] [varchar](20) NULL,
	[USUARIO_ACTUAL] [varchar](100) NULL,
	[ESTADO_EXPEDIENTE] [varchar](100) NULL,
	[CODIGO_ESTADO] [varchar](10) NULL,
	[PERFIL] [varchar](100) NULL,
	[TAREA] [varchar](100) NULL,
	[ACCION] [varchar](100) NULL,
	[CODIGO_PRODUCTO] [varchar](10) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[CODIGO_SUB_PRODUCTO] [varchar](10) NULL,
	[NOMBRE_SUB_PRODUCTO] [varchar](100) NULL,
	[CODIGO_OFICINA_USUARIO] [varchar](10) NULL,
	[NOMBRE_OFICINA_USUARIO] [varchar](100) NULL,
	[CODIGO_TERRITORIO_USUARIO] [varchar](10) NULL,
	[NOMBRE_TERRITORIO_USUARIO] [varchar](100) NULL,
	[CODIGO_OFICINA_GESTORA] [varchar](10) NULL,
	[NOMBRE_OFICINA_GESTORA] [varchar](100) NULL,
	[CODIGO_TERRITORIO_GESTORA] [varchar](10) NULL,
	[NOMBRE_TERRITORIO_GESTORA] [varchar](100) NULL,
	[FECHA_HORA_LLEGADA] [varchar](100) NULL,
	[FECHA_HORA_INICIO_TRABAJO] [varchar](100) NULL,
	[FECHA_HORA_ENVIO] [varchar](100) NULL,
	[TIEMPO_EJECUCION_TE] [decimal](10, 3) NULL,
	[TIEMPO_COLA_TC] [decimal](10, 3) NULL,
	[TIEMPO_PROCESO_TP] [decimal](10, 3) NULL,
	[CUMPLIO_ANS] [varchar](5) NULL,
	[FLAG_DEVOLUCION] [varchar](5) NULL,
	[FLAG_RETRAER] [varchar](5) NULL,
	[TERMINAL] [varchar](50) NULL,
	[OBSERVACION] [nvarchar](600) NULL,
	[MOTIVO_DEVOLUCION_RECHAZO] [nvarchar](600) NULL,
	[COMENTARIO_DEVOLUCION_RECHAZO] [nvarchar](600) NULL,
	[ANS] [bigint] NULL
) 


DECLARE @path1 varchar(50) = '\\172.17.1.51\mp\DATA-CMI-CS\' +@archivo +'.csv' ;
DECLARE @SQL_BULK VARCHAR(MAX);

DECLARE @FILA_BULK_COUNT INT; 


-------

SET @SQL_BULK = 'BULK INSERT #TB_CS_TEMP FROM ''' + @path1 + ''' WITH
        (
     
        FIELDTERMINATOR = ''¬'',
        ROWTERMINATOR = ''\n''
  
        )'

EXEC (@SQL_BULK)


SET @FILA_BULK_COUNT =  (SELECT @@ROWCOUNT)

 

IF(@FILA_BULK_COUNT > 1)
	BEGIN
	
	print CONVERT (VARCHAR,@FILA_BULK_COUNT) + ' FILAS INSERTADAS '
	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('CARGADO',@archivo,GETDATE())

	END
ELSE
	BEGIN

	print 'NINGUNA  FILA INSERTADA'
	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('ERROR',@archivo,GETDATE())

	END



INSERT INTO TB_CS
SELECT 
NRO_EXPEDIENTE,
ESTADO_EXPEDIENTE,
PERFIL,
ACCION,
NOMBRE_PRODUCTO,
NOMBRE_TIPO_OFERTA,
CONVERT(Datetime, FECHA_HORA_LLEGADA,120),
CONVERT(Datetime, FECHA_HORA_ENVIO,120),
TIEMPO_COLA_TC,
TIEMPO_PROCESO_TP,
ANS,
OBSERVACION, 
CODIGO_OFICINA_GESTORA, 
CODIGO_OFICINA_USUARIO, 
CODIGO_TERRITORIO_GESTORA, 
CODIGO_TERRITORIO_USUARIO
FROM #TB_CS_TEMP


EXEC USP_TB_CS_FILTRO

END
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_SUBIR_CONSOLIDADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_TB_CS_SUBIR_CONSOLIDADO] 
( 
@archivo varchar(150)
)
AS

BEGIN

DECLARE @FILA_BULK_COUNT INT; 

DELETE FROM TB_CS_CONSOLIDADO;

CREATE TABLE #CONSOLIDADO_TEMP(
[NUMERO_EXPEDIENTE] [nvarchar](255) NULL,
[CORRELATIVO_ESTADO] [nvarchar](255) NULL,
[CODIGO_OFICINA] [nvarchar](255) NULL,
[EJECUTIVO] [nvarchar](255) NULL,
[FLUJO_VIP] [nvarchar](100) NULL,	
) ON [PRIMARY]

DECLARE @path1 varchar(100) = '\\172.17.1.51\mp\DATA-CMI-CS\' +@archivo +'.csv' ;
DECLARE @SQL_BULK VARCHAR(MAX)		
-------
SET @SQL_BULK = 'BULK INSERT #CONSOLIDADO_TEMP FROM ''' + @path1 + ''' WITH
	(
     
	FIELDTERMINATOR = ''¬'',
	ROWTERMINATOR = ''\n''
  
	)'
EXEC (@SQL_BULK)

SET @FILA_BULK_COUNT =  (SELECT @@ROWCOUNT)

IF(@FILA_BULK_COUNT > 0)
BEGIN
INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('CARGADO',@archivo,GETDATE())
END
ELSE
BEGIN
INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('PENDIENTE',@archivo,GETDATE())
END

----------------
PRINT 'BULK INSERT #CONSOLIDADO_TEMP ;'
INSERT INTO TB_CS_CONSOLIDADO
SELECT NUMERO_EXPEDIENTE, CORRELATIVO_ESTADO, CODIGO_OFICINA, EJECUTIVO, FLUJO_VIP
FROM #CONSOLIDADO_TEMP		
PRINT 'INSERT INTO TB_CS_CONSOLIDADO FROM #CONSOLIDADO_TEMP ;'


END

GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_SUBIR_CONSOLIDADO_FULL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_TB_CS_SUBIR_CONSOLIDADO_FULL]
( 
@archivo varchar(50),
@mes int,
@año int
)
AS

BEGIN

CREATE TABLE #TB_CS_CONSOLIDADO_FULL(
	[NRO_EXPEDIENTE] [varchar](20) NULL,
	[COD_SEGMENTO_CLIENTE] [varchar](20) NULL,
	[DESC_SEGMENTO_CLIENTE] [varchar](20) NULL,
	[CORRELATIVO_ESTADO] [varchar](10) NULL,
	[NOMBRE_ESTADO] [varchar](30) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[COD_USUARIO_CREACION] [varchar](20) NULL,
	[NOMBRE_USUARIO_CREACION] [varchar](100) NULL,
	[FECHA_CREACION] [varchar](50) NULL,
	[CORRELATIVO_OFICINA] [varchar](20) NULL,
	[CODIGO_OFICINA] [varchar](20) NULL,
	[NOMBRE_OFICINA] [varchar](100) NULL,
	[CODIGO_GARANTIA] [varchar](20) NULL,
	[DESCRIPCION_GARANTIA] [varchar](100) NULL,
	[CORRELATIVO_SUBPRODUCTO] [varchar](20) NULL,
	[NOMBRE_SUBPRODUCTO] [varchar](100) NULL,
	[CORRELATIVO_CLIENTE] [varchar](100) NULL,
	[APELLIDO_PATERNO_CLIENTE] [varchar](50) NULL,
	[APELLIDO_MATERNO_CLIENTE] [varchar](50) NULL,
	[NOMBRES_CLIENTE] [varchar](100) NULL,
	[TIPO_DOCUMENTO_IDENTIDAD] [varchar](50) NULL,
	[NUMERO_DOCUMENTO_IDENTIDAD] [varchar](50) NULL,
	[TIPO_CLIENTE] [varchar](30) NULL,
	[INGRESO_NETO_MENSUAL] [decimal](18, 2) NULL,
	[ESTADO_CIVIL] [varchar](20) NULL,
	[PERSONA_EXPUSTA_PUBLICA] [varchar](20) NULL,
	[PAGO_HABIENTE] [varchar](10) NULL,
	[SUBROGADO] [varchar](10) NULL,
	[TIPO_OFERTA] [varchar](20) NULL,
	[FLUJO_VIP] [varchar](10) NULL,
	[MONEDA_IMPORTE_SOLICITADO] [varchar](5) NULL,
	[IMPORTE_SOLICITADO] [decimal](18, 2) NULL,
	[MONEDA_IMPORTE_APROBADO] [varchar](5) NULL,
	[IMPORTE_APROBADO] [decimal](18, 2) NULL,
	[PLAZO_SOLICITADO] [varchar](5) NULL,
	[PLAZO_APROBADO] [varchar](5) NULL,
	[TIPO_RESOLUCION] [varchar](50) NULL,
	[CODIGO_PREEVALUADOR] [varchar](50) NULL,
	[CODIGO_RVGL] [varchar](50) NULL,
	[LINEA_CONSUMO] [decimal](18, 2) NULL,
	[RIESGO_CLIENTE_GRUPAL] [decimal](18, 2) NULL,
	[PORCENTAJE_ENDEUDAMIENTO] [decimal](18, 2) NULL,
	[CODIGO_CONTRATO] [varchar](50) NULL,
	[GRUPO_BURO] [varchar](10) NULL,
	[CLASIFICACION_SBS_TITULAR] [varchar](10) NULL,
	[CLASIFICACION_BANCO_TITULAR] [varchar](10) NULL,
	[CLASIFICACION_SBS_CONYUGE] [varchar](10) NULL,
	[CLASIFICACION_BANCO_CONYUGE] [varchar](10) NULL,
	[SCORING] [varchar](20) NULL,
	[TASA_ESPECIAL] [varchar](10) NULL,
	[FLAG_VERIF_DOMICILIARIA] [varchar](10) NULL,
	[ESTADO_VERIF_DOMICILIARIA] [varchar](20) NULL,
	[FLAG_VERIF_LABORAL] [varchar](10) NULL,
	[ESTADO_VERIF_LABORAL] [varchar](10) NULL,
	[FLAG_DPS] [varchar](10) NULL,
	[ESTADO_DPS] [varchar](10) NULL,
	[MODIFICAR_TASA] [varchar](10) NULL,
	[MODIFICAR_SCORING] [varchar](10) NULL,
	[INDICADOR_DELEGACION] [varchar](10) NULL,
	[INDICADOR_EXCLUSION_DELEGACION] [varchar](10) NULL,
	[NIVEL_COMPLEJIDAD] [varchar](10) NULL,
	[NRO_DEVOLUCIONES] [varchar](10) NULL,
	[CODIGO_USUARIO_ACTUAL] [varchar](10) NULL	
) ON [PRIMARY]


DECLARE @MES_FILE VARCHAR(10)  = '0'
DECLARE @ANO_FILE VARCHAR(10) = '0'

SET @MES_FILE= SUBSTRING (@archivo, 3 ,2)
SET @ANO_FILE= SUBSTRING (@archivo, 5 ,4)

DECLARE @path varchar(100) = '\\172.17.1.51\mp\DATA-CMI-CS\' +@archivo +'.csv' ;
DECLARE @SQL_BULK VARCHAR(MAX)
DECLARE @FILA_BULK_COUNT INT; 


DELETE FROM TB_CS_CONSOLIDADO_FULL
WHERE MONTH(FECHA_CREACION) = @mes
AND YEAR(FECHA_CREACION) = @año
-------------------------------------------------------

SET @SQL_BULK = 'BULK INSERT #TB_CS_CONSOLIDADO_FULL FROM ''' + @path + ''' WITH
        (

		FIRSTROW = 5,
        FIELDTERMINATOR = ''¬'',
        ROWTERMINATOR = ''\n''
  
        )'

EXEC (@SQL_BULK)


SET @FILA_BULK_COUNT =  (SELECT @@ROWCOUNT)

IF(@FILA_BULK_COUNT > 0)
	BEGIN

	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('CARGADO',@archivo,GETDATE())

	END
ELSE
	BEGIN

	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('PENDIENTE',@archivo,GETDATE())

	END
PRINT '--------SE INSERTO EN TEMPORAL MES: ' + @MES_FILE +' '+ 'AÑO: ' + @ANO_FILE



----------DELETE FROM TB_CS_CONSOLIDADO_FULL 
----------		WHERE MONTH(CONVERT(DATE,FECHA_CREACION)) = @MES_FILE 
----------		   AND YEAR(CONVERT(DATE,FECHA_CREACION)) = @ANO_FILE
----------PRINT '--------SE ELIMINO MES: ' + @MES_FILE +' '+ 'AÑO: ' + @ANO_FILE
----------SELECT * FROM TB_CS_CONSOLIDADO_FULL

INSERT INTO TB_CS_CONSOLIDADO_FULL 

SELECT 
NRO_EXPEDIENTE,COD_SEGMENTO_CLIENTE, DESC_SEGMENTO_CLIENTE, CORRELATIVO_ESTADO, NOMBRE_ESTADO, NOMBRE_PRODUCTO, 
COD_USUARIO_CREACION, NOMBRE_USUARIO_CREACION, CONVERT(DATETIME,SUBSTRING(FECHA_CREACION, 1 ,19),103) AS FECHA_CREACION,
CORRELATIVO_OFICINA, CODIGO_OFICINA, NOMBRE_OFICINA, CODIGO_GARANTIA, DESCRIPCION_GARANTIA, CORRELATIVO_SUBPRODUCTO,
NOMBRE_SUBPRODUCTO, CORRELATIVO_CLIENTE, APELLIDO_PATERNO_CLIENTE,APELLIDO_MATERNO_CLIENTE, NOMBRES_CLIENTE, 
TIPO_DOCUMENTO_IDENTIDAD, NUMERO_DOCUMENTO_IDENTIDAD, TIPO_CLIENTE, INGRESO_NETO_MENSUAL, ESTADO_CIVIL, 
PERSONA_EXPUSTA_PUBLICA, PAGO_HABIENTE, SUBROGADO, TIPO_OFERTA, FLUJO_VIP, MONEDA_IMPORTE_SOLICITADO, IMPORTE_SOLICITADO, 
MONEDA_IMPORTE_APROBADO, IMPORTE_APROBADO, PLAZO_SOLICITADO, PLAZO_APROBADO, TIPO_RESOLUCION, CODIGO_PREEVALUADOR,
CODIGO_RVGL, LINEA_CONSUMO, RIESGO_CLIENTE_GRUPAL, PORCENTAJE_ENDEUDAMIENTO, CODIGO_CONTRATO, GRUPO_BURO,
CLASIFICACION_SBS_TITULAR, CLASIFICACION_BANCO_TITULAR, CLASIFICACION_SBS_CONYUGE, CLASIFICACION_BANCO_CONYUGE,
SCORING, TASA_ESPECIAL, FLAG_VERIF_DOMICILIARIA, ESTADO_VERIF_DOMICILIARIA, FLAG_VERIF_LABORAL,
ESTADO_VERIF_LABORAL, FLAG_DPS, ESTADO_DPS, MODIFICAR_TASA, MODIFICAR_SCORING, INDICADOR_DELEGACION, 
INDICADOR_EXCLUSION_DELEGACION, NIVEL_COMPLEJIDAD, NRO_DEVOLUCIONES, CODIGO_USUARIO_ACTUAL, ''
FROM #TB_CS_CONSOLIDADO_FULL


--PRINT '--------SE INSERTO EN TABLA MES: ' + @MES_FILE +' '+ 'AÑO: ' + @ANO_FILE


END
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_TC_ADICIONAL_GIFOLE_SUBIR]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 21/08/2020
-- Description:	Procedure para subir GIFOLE TC ADICIONAL
-- =============================================
CREATE PROCEDURE  [dbo].[USP_TB_CS_TC_ADICIONAL_GIFOLE_SUBIR] (@archivo varchar(30), @MES INT, @AÑO INT)

AS

BEGIN

--DECLARE @DIA VARCHAR(10)  = '0'
--DECLARE @MES VARCHAR(10)  = '0'
--DECLARE @ANO VARCHAR(10) = '0'

DECLARE @FECHA_INI DATE  = NULL
DECLARE @FECHA_FIN DATE = NULL

--SELECT @DIA= SUBSTRING (@archivo1, 1 ,2)
--SELECT @MES= SUBSTRING (@archivo1, 3 ,2)
--SELECT @ANO= SUBSTRING (@archivo1, 5 ,4)

--SET @FECHA_INI = CONVERT ( DATE ,@ANO +'/'+   @MES  +'/'+ '01')
--SET @FECHA_FIN = CONVERT ( DATE ,@ANO +'/'+   @MES  +'/'+ @DIA)

DELETE FROM TB_CS_TC_ADICIONAL_GIFOLE
WHERE MONTH(FECHA_HORA_REGISTRO) = @MES
AND YEAR(FECHA_HORA_REGISTRO) = @AÑO


CREATE TABLE #TC_GIFOLE_ADICIONAL(	
	[CODIGO_CENTRAL] [varchar](20) NULL,
	[NOMBRES] [varchar](200) NULL,
	[FECHA_HORA_REGISTRO] [varchar](20) NULL,
	[TARJETA] [varchar](100) NULL,
	[ESTADO] [varchar](30) NULL,
	[FECHA_HORA_MODIFICACION] [varchar](20) NULL,
	[CANAL] [varchar](30) NULL
)

DECLARE @path varchar(150) = '\\172.17.1.51\mp\DATA-CMI-CS\' +@archivo +'.csv' ;
DECLARE @SQL_BULK VARCHAR(MAX)


------------------------------------//
SET @SQL_BULK = 'BULK INSERT #TC_GIFOLE_ADICIONAL FROM ''' + @path + ''' WITH
        (
		FIRSTROW = 2,
        FIELDTERMINATOR = ''¬'',
        ROWTERMINATOR = ''\n''  
        )'

EXEC (@SQL_BULK)
------------------------------------//

DELETE FROM #TC_GIFOLE_ADICIONAL 
WHERE CANAL = 'ZONA_PUB'

INSERT INTO TB_CS_TC_ADICIONAL_GIFOLE
SELECT CODIGO_CENTRAL, NOMBRES,  CONVERT(DATETIME, FECHA_HORA_REGISTRO,103), TARJETA, ESTADO, 
CONVERT(DATETIME,FECHA_HORA_MODIFICACION,103),CANAL
FROM #TC_GIFOLE_ADICIONAL

--SELECT *
--FROM #CALCULO_TIEMPOS

INSERT INTO [dbo].[TB_HISTORIAL_CARGAS_CSV](estado, archivo, fecha)
values ('CARGADO', @archivo, GETDATE())

DELETE FROM TB_CS_TC_ADICIONAL_GIFOLE WHERE CODIGO_CENTRAL IS NULL

----SELECT * 
----FROM TB_CS_TC_ADICIONAL_GIFOLE


END
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_CS_TC_GIFOLE_SUBIR]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 17/06/2020
-- Description:	Procedure para hacer filtros y cargar data a la base de TC de contratos realizados por internet.
-- =============================================
CREATE PROCEDURE  [dbo].[USP_TB_CS_TC_GIFOLE_SUBIR](@archivo varchar(30), @MES int, @ANO int)
AS

BEGIN

--DECLARE @DIA VARCHAR(10)  = '0'
--DECLARE @MES VARCHAR(10)  = '0'
--DECLARE @ANO VARCHAR(10) = '0'

DECLARE @FECHA_INI DATE  = NULL
DECLARE @FECHA_FIN DATE = NULL


--SELECT @DIA= SUBSTRING (@archivo1, 1 ,2)
--SELECT @MES= SUBSTRING (@archivo1, 3 ,2)
--SELECT @ANO= SUBSTRING (@archivo1, 5 ,4)

--SET @FECHA_INI = CONVERT ( DATE ,@ANO +'/'+   @MES  +'/'+ '01')
--SET @FECHA_FIN = CONVERT ( DATE ,@ANO +'/'+   @MES  +'/'+ @DIA)


DELETE FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_REGISTRO) = @MES
AND YEAR(FECHA_HORA_REGISTRO) = @ANO


CREATE TABLE #TC_GIFOLE(	
	[NRO_DOCUMENTO] [varchar](20) NULL,
	[NOMBRES] [varchar](200) NULL,
	[FECHA_HORA_REGISTRO] [varchar](20) NULL,
	[TARJETA] [varchar](80) NULL,
	[ESTADO] [varchar](80) NULL,
	[FECHA_HORA_MODIFICACION] [varchar](20) NULL,
	[CANAL] [varchar](50) NULL,
	[MONTO] [varchar](20) NULL
)



DECLARE @path varchar(150) = '\\172.17.1.51\mp\DATA-CMI-CS\' +@archivo +'.csv' ;
DECLARE @SQL_BULK VARCHAR(MAX)


------------------------------------//
SET @SQL_BULK = 'BULK INSERT #TC_GIFOLE FROM ''' + @path + ''' WITH
        (
		FIRSTROW = 2,
        FIELDTERMINATOR = ''¬'',
        ROWTERMINATOR = ''\n''
  
        )'

EXEC (@SQL_BULK)
------------------------------------//

DELETE FROM #TC_GIFOLE 
WHERE CANAL = 'ZONA_PUB' 

INSERT INTO TB_CS_TC_GIFOLE
SELECT NRO_DOCUMENTO, NOMBRES,  CONVERT(DATETIME, FECHA_HORA_REGISTRO,103), TARJETA, ESTADO, 
CONVERT(DATETIME,FECHA_HORA_MODIFICACION,103),CANAL, MONTO
FROM #TC_GIFOLE


delete from TB_CS_TC_GIFOLE where FECHA_HORA_REGISTRO IS NULL

INSERT INTO [dbo].[TB_HISTORIAL_CARGAS_CSV](estado, archivo, fecha)
values ('CARGADO', @archivo, GETDATE())

----SELECT * 
----FROM TB_CS_TC_GIFOLE


END
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_CANT_OPER_DIARIO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------- =============================================
------- Author:		Didier Yepez Cabanillas
------- Create date: 17/04/2020
------- Description: Procedure Cantidad de operaciones diarias de pestañas de CALIDAD
------- =============================================
CREATE PROCEDURE [dbo].[USP_TB_FUVEX_CANT_OPER_DIARIO]
 (@MES INT, 
 @AÑO INT )

AS

BEGIN

DECLARE @fecha_proceso DATE;

DECLARE @CONT_P INT = 1;
DECLARE @CONTMAX_P INT;		
DECLARE @PRODUCTO_NAME VARCHAR(65);


--------------------------/////////// PLD
DECLARE @EXP_INGRESADOS_MES1 INT;
DECLARE @EXP_INGRESADOS_MES2 INT;

DECLARE @EXP_OFAPROBADA_MES1 INT;
DECLARE @EXP_OFAPROBADA_MES2 INT;

DECLARE @EXP_OFREGULAR_MES1 INT;
DECLARE @EXP_OFREGULAR_MES2 INT;

DECLARE @EXP_RECHAZADO_MES1 INT;
DECLARE @EXP_RECHAZADO_MES2 INT;

DECLARE @EXP_RECHAZADO_AP_MES1 INT;
DECLARE @EXP_RECHAZADO_AP_MES2 INT;

DECLARE @EXP_RECHAZADO_RE_MES1 INT;
DECLARE @EXP_RECHAZADO_RE_MES2 INT;

DECLARE @EXP_DESEMBOLSADO_MES1 INT;
DECLARE @EXP_DESEMBOLSADO_MES2 INT;

DECLARE @EXP_DESEMBOLSADO_AP_MES1 INT;
DECLARE @EXP_DESEMBOLSADO_AP_MES2 INT;

DECLARE @EXP_DESEMBOLSADO_RE_MES1 INT;
DECLARE @EXP_DESEMBOLSADO_RE_MES2 INT;
--------------------------/////////// TARJETAS

DECLARE @T_EXP_INGRESADOS_MES1 INT;
DECLARE @T_EXP_INGRESADOS_MES2 INT;

DECLARE @T_EXP_INGR_FISICO_MES1 INT;
DECLARE @T_EXP_INGR_FISICO_MES2 INT;

DECLARE @T_EXP_INGR_PAPERLESS_MES1 INT;
DECLARE @T_EXP_INGR_PAPERLESS_MES2 INT;

DECLARE @T_EXP_RECHAZADOS_MES1 INT;
DECLARE @T_EXP_RECHAZADOS_MES2 INT;

DECLARE @T_EXP_RECH_FISICO_MES1 INT;
DECLARE @T_EXP_RECH_FISICO_MES2 INT;

DECLARE @T_EXP_RECH_PAPERLESS_MES1 INT;
DECLARE @T_EXP_RECH_PAPERLESS_MES2 INT;

DECLARE @T_DESEMBOLSADOS_MES1 INT;
DECLARE @T_DESEMBOLSADOS_MES2 INT;

DECLARE @T_DESEMBOLSADOS_FISICO_MES1 INT;
DECLARE @T_DESEMBOLSADOS_FISICO_MES2 INT;
		   
DECLARE @T_DESEMBOLSADOS_PAPERLESS_MES1 INT;
DECLARE @T_DESEMBOLSADOS_PAPERLESS_MES2 INT;

--------------------------/////////// PARTE FINAL REPROCESOS TOTAL

DECLARE @PLD_REPROCESOS_TOTAL_M1 INT;
DECLARE @PLD_REPROCESOS_TOTAL_M2 INT;

DECLARE @TC_REPROCESOS_TOTAL_M1 INT;
DECLARE @TC_REPROCESOS_TOTAL_M2 INT;


SET @fecha_proceso = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(FECHA_HORA_ENVIO) = @MES	
					AND YEAR(FECHA_HORA_ENVIO) = @AÑO)


DELETE FROM PLD_TC_CONVENIO WHERE descripcion = 'PORCENTAJE DE REPROCESOS GLOBAL'
AND fecha_proceso = @fecha_proceso

----------------------------------------------------------------------////EXP INGRESADOS.
SET @EXP_INGRESADOS_MES1 = (SELECT COUNT(F.NRO_DE_SOLICITUD)
						FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
						ON F.COD_SUB_PRODUCTO = FS.CODIGO
						WHERE MONTH(FECHA_DE_REGISTRO) = MONTH(DATEADD(MONTH, -2, @fecha_proceso)) 
						and YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -2, @fecha_proceso))  
						AND  FS.TIPO = 'PLD'
						GROUP BY F.PRODUCTO)

SET @EXP_INGRESADOS_MES2 = (SELECT COUNT(F.NRO_DE_SOLICITUD)
						FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
						ON F.COD_SUB_PRODUCTO = FS.CODIGO
						WHERE MONTH(FECHA_DE_REGISTRO) = MONTH(DATEADD(MONTH, -1, @fecha_proceso)) 
						and YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -1, @fecha_proceso))  
						AND  FS.TIPO = 'PLD'
						GROUP BY F.PRODUCTO)
----------------------------------------------------------------------////OFERTA APROBADA
SET @EXP_OFAPROBADA_MES1 =	(SELECT COUNT(F.NRO_DE_SOLICITUD)
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(FECHA_DE_REGISTRO) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))  
							and YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 
							AND  FS.TIPO = 'PLD' AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
							GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

SET @EXP_OFAPROBADA_MES2 =	(SELECT COUNT(F.NRO_DE_SOLICITUD)
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(FECHA_DE_REGISTRO) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))  
							and YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 
							AND  FS.TIPO = 'PLD' AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
							GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)
----------------------------------------------------------------------////OFERTA REGULAR
SET @EXP_OFREGULAR_MES1 = (SELECT COUNT(F.NRO_DE_SOLICITUD) 
						FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
						ON F.COD_SUB_PRODUCTO = FS.CODIGO
						WHERE MONTH(FECHA_DE_REGISTRO) =  MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
						and YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -2, @fecha_proceso))  
						AND  FS.TIPO = 'PLD' AND F.MODALIDAD_DE_VENTA = 'REGULAR'
						GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

SET @EXP_OFREGULAR_MES2 = (SELECT COUNT(F.NRO_DE_SOLICITUD) 
						FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
						ON F.COD_SUB_PRODUCTO = FS.CODIGO
						WHERE MONTH(FECHA_DE_REGISTRO) =  MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
						and YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -1, @fecha_proceso))  
						AND  FS.TIPO = 'PLD' AND F.MODALIDAD_DE_VENTA = 'REGULAR'
						GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)
----------------------------------------------------------------------////EXPEDIENTES RECHAZADOS

SET @EXP_RECHAZADO_MES1 = (SELECT COUNT(F.NRO_DE_SOLICITUD)
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(FECHA_DE_ESTADO) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))  
							and YEAR(FECHA_DE_ESTADO) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 
							AND FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'RECHAZADO'
							GROUP BY F.PRODUCTO)

SET @EXP_RECHAZADO_MES2 = (SELECT COUNT(F.NRO_DE_SOLICITUD)
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(FECHA_DE_ESTADO) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))  
							and YEAR(FECHA_DE_ESTADO) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 
							AND FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'RECHAZADO'
							GROUP BY F.PRODUCTO)
----------------------------------------------------------------------////EXPEDIENTES RECHAZADOS OF.APROBADA
SET @EXP_RECHAZADO_AP_MES1 = (SELECT COUNT(F.NRO_DE_SOLICITUD) 
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(FECHA_DE_ESTADO) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
							and YEAR(FECHA_DE_ESTADO) = YEAR(DATEADD(MONTH, -2, @fecha_proceso))  
							AND FS.TIPO = 'PLD'  		
							AND F.ESTADO_ACTUAL = 'RECHAZADO'
							AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
							GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

SET @EXP_RECHAZADO_AP_MES2 =  (SELECT COUNT(F.NRO_DE_SOLICITUD) 
							 FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							 ON F.COD_SUB_PRODUCTO = FS.CODIGO
							 WHERE MONTH(FECHA_DE_ESTADO) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))
							 and YEAR(FECHA_DE_ESTADO) = YEAR(DATEADD(MONTH, -1, @fecha_proceso))  
							 AND FS.TIPO = 'PLD'  		
							 AND F.ESTADO_ACTUAL = 'RECHAZADO'
							 AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
							 GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

----------------------------------------------------------------------////EXPEDIENTES RECHZADOS OF.REGULAR
SET @EXP_RECHAZADO_RE_MES1 = (SELECT COUNT(F.NRO_DE_SOLICITUD)  
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso)) 
							and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 
							AND FS.TIPO = 'PLD'  		
							AND F.ESTADO_ACTUAL = 'RECHAZADO'
							AND F.MODALIDAD_DE_VENTA = 'REGULAR'
							GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

SET @EXP_RECHAZADO_RE_MES2 = (SELECT COUNT(F.NRO_DE_SOLICITUD)  
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso)) 
							and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 
							AND FS.TIPO = 'PLD'  		
							AND F.ESTADO_ACTUAL = 'RECHAZADO'
							AND F.MODALIDAD_DE_VENTA = 'REGULAR'
							GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

----------------------------------------------------------------------////EXPEDIENTES DESEMBOLSADOS

SET @EXP_DESEMBOLSADO_MES1 = (SELECT COUNT(F.NRO_DE_SOLICITUD)  
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(CONVERT(date,F.FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso)) 
							and YEAR(CONVERT(date,F.FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 
							AND FS.TIPO = 'PLD'  		
							AND F.ESTADO_ACTUAL = 'FORMALIZADO'
							GROUP BY F.PRODUCTO)

SET @EXP_DESEMBOLSADO_MES2 = (SELECT COUNT(F.NRO_DE_SOLICITUD)  
								FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
								ON F.COD_SUB_PRODUCTO = FS.CODIGO
								WHERE MONTH(CONVERT(date,F.FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))  
								and YEAR(CONVERT(date,F.FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 
								AND FS.TIPO = 'PLD'  		
								AND F.ESTADO_ACTUAL = 'FORMALIZADO'
								GROUP BY F.PRODUCTO)
----------------------------------------------------------------------////EXPEDIENTES DESEMBOLSADOS APROBADOS
SET @EXP_DESEMBOLSADO_AP_MES1 =  (SELECT COUNT(F.NRO_DE_SOLICITUD)
									FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
									ON F.COD_SUB_PRODUCTO = FS.CODIGO
									WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))  
									and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 
									AND  FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'FORMALIZADO'
									AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
									GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

SET @EXP_DESEMBOLSADO_AP_MES2 = (SELECT COUNT(F.NRO_DE_SOLICITUD)
									FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
									ON F.COD_SUB_PRODUCTO = FS.CODIGO
									WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))  
									and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 
									AND  FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'FORMALIZADO'
									AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
									GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

----------------------------------------------------------------------////EXPEDIENTES DESEMBOLSADOS REGULAR
SET @EXP_DESEMBOLSADO_RE_MES1 =  (SELECT COUNT(F.NRO_DE_SOLICITUD)
									FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
									ON F.COD_SUB_PRODUCTO = FS.CODIGO
									WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))  
									and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 
									AND  FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'FORMALIZADO'
									AND F.MODALIDAD_DE_VENTA = 'REGULAR'
									GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)

SET @EXP_DESEMBOLSADO_RE_MES2 = (SELECT COUNT(F.NRO_DE_SOLICITUD)
									FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
									ON F.COD_SUB_PRODUCTO = FS.CODIGO
									WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))  
									and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 
									AND  FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'FORMALIZADO'
									AND F.MODALIDAD_DE_VENTA = 'REGULAR'
									GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA)
------------******************************** TARJETAS ********************************************************
SET @T_EXP_INGRESADOS_MES1 = (SELECT COUNT(NRO_DE_SOLICITUD)
							FROM TB_FUVEX 
							WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
							and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
							AND PRODUCTO = 'TARJETAS'
							GROUP BY PRODUCTO)

SET @T_EXP_INGRESADOS_MES2 = (SELECT COUNT(NRO_DE_SOLICITUD)
							FROM TB_FUVEX 
							WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
							and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
							AND PRODUCTO = 'TARJETAS'
							GROUP BY PRODUCTO)


SET @T_EXP_INGR_FISICO_MES1 =(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS' 
								AND FUERZA_DE_VENTA =  'COMCORP SAC' -- fisico
								GROUP BY PRODUCTO, FECHA_DE_REGISTRO)	

SET @T_EXP_INGR_FISICO_MES2=(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS' 
								AND FUERZA_DE_VENTA =  'COMCORP SAC' -- fisico
								GROUP BY PRODUCTO, FECHA_DE_REGISTRO)	


SET @T_EXP_INGR_PAPERLESS_MES1 =(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
								  AND PRODUCTO = 'TARJETAS' 
								AND FUERZA_DE_VENTA !=  'COMCORP SAC' ---------------- parpeless
								GROUP BY PRODUCTO)		

SET @T_EXP_INGR_PAPERLESS_MES2 =(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
								   AND PRODUCTO = 'TARJETAS' 
								AND FUERZA_DE_VENTA !=  'COMCORP SAC' ---------------- parpeless
								GROUP BY PRODUCTO)		


SET @T_EXP_RECHAZADOS_MES1 = (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'RECHAZADO')

SET @T_EXP_RECHAZADOS_MES2 = (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
								 AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'RECHAZADO')

SET @T_EXP_RECH_FISICO_MES1 =(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'RECHAZADO'
								AND  TIPO_DE_CAPTACION != 'PAPERLESS') -- FISICO

SET @T_EXP_RECH_FISICO_MES2 =(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'RECHAZADO'
								AND  TIPO_DE_CAPTACION != 'PAPERLESS') -- FISICO



SET @T_EXP_RECH_PAPERLESS_MES1 = (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'RECHAZADO' AND 
								TIPO_DE_CAPTACION = 'PAPERLESS')

SET @T_EXP_RECH_PAPERLESS_MES2 =(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'RECHAZADO' AND 
								TIPO_DE_CAPTACION = 'PAPERLESS')



SET @T_DESEMBOLSADOS_MES1 = (SELECT COUNT(NRO_DE_SOLICITUD)
							FROM TB_FUVEX 
							WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
							and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
							AND PRODUCTO = 'TARJETAS'
							AND ESTADO_ACTUAL = 'FORMALIZADO'
							GROUP BY PRODUCTO)

SET @T_DESEMBOLSADOS_MES2 =	(SELECT COUNT(NRO_DE_SOLICITUD)
							FROM TB_FUVEX 
							WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
							and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
							AND PRODUCTO = 'TARJETAS'
							AND ESTADO_ACTUAL = 'FORMALIZADO'
							GROUP BY PRODUCTO)



SET @T_DESEMBOLSADOS_FISICO_MES1= (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'FORMALIZADO' AND FUERZA_DE_VENTA = 'COMCORP SAC' -- FISICO
								GROUP BY PRODUCTO)

SET @T_DESEMBOLSADOS_FISICO_MES2=(SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX 
								WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
								AND PRODUCTO = 'TARJETAS'
								AND ESTADO_ACTUAL = 'FORMALIZADO' AND FUERZA_DE_VENTA = 'COMCORP SAC' -- FISICO
								GROUP BY PRODUCTO)


SET @T_DESEMBOLSADOS_PAPERLESS_MES1 = (SELECT COUNT(NRO_DE_SOLICITUD)
									FROM TB_FUVEX 
									WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
									and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
									AND PRODUCTO = 'TARJETAS'
									AND ESTADO_ACTUAL = 'FORMALIZADO' 
									AND FUERZA_DE_VENTA != 'COMCORP SAC' --------- PAPERLESS
									GROUP BY PRODUCTO)

SET @T_DESEMBOLSADOS_PAPERLESS_MES2 = (SELECT COUNT(NRO_DE_SOLICITUD)
									FROM TB_FUVEX 
									WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
									and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
									AND PRODUCTO = 'TARJETAS'
									AND ESTADO_ACTUAL = 'FORMALIZADO' 
									AND FUERZA_DE_VENTA != 'COMCORP SAC' --------- PAPERLESS
									GROUP BY PRODUCTO)		
---------------------------------------------------------------------------------------------------------------//
----------------------------------//FUVEX REPROCESOS TOTAL PLD

SET @PLD_REPROCESOS_TOTAL_M1 = (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX AS FU	INNER JOIN TB_FUVEX_SUBPRODUCTO AS SU
								ON FU.COD_SUB_PRODUCTO=SU.CODIGO
								WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
									and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 		
								AND SU.TIPO = 'PLD'
								AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM', 'RECHAZADO'))

SET @PLD_REPROCESOS_TOTAL_M2 = (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX AS FU	INNER JOIN TB_FUVEX_SUBPRODUCTO AS SU
								ON FU.COD_SUB_PRODUCTO=SU.CODIGO
								WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
									and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 		
								AND SU.TIPO = 'PLD'
								AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM', 'RECHAZADO'))

----------------------------------//FUVEX REPROCESOS TOTAL TC

SET @TC_REPROCESOS_TOTAL_M1 = (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX
								WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @fecha_proceso))   
								and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @fecha_proceso)) 	
								AND PRODUCTO = 'TARJETAS' 
								AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM','RECHAZADO'))

SET @TC_REPROCESOS_TOTAL_M2 = (SELECT COUNT(NRO_DE_SOLICITUD)
								FROM TB_FUVEX
								WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @fecha_proceso))   
								AND YEAR(CONVERT(date,FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @fecha_proceso)) 	
								AND PRODUCTO = 'TARJETAS' 
								AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM','RECHAZADO'))

CREATE TABLE #PRODUCTOS
(	
cod int identity(1,1) not null,	
producto varchar(65)			
)
	---------------------------------------------------------------///////// reproceso
DELETE FROM [dbo].[TB_FUVEX_RO] WHERE [fecha_proceso] = @fecha_proceso

		---------------------------------------------------------------///////// PLD
		 INSERT INTO TB_FUVEX_RO

         SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'1' AS nro, 					
		'Expedientes Ingresados' AS descripcion_estado,	
		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_INGRESADOS_MES1,0) AS mes1,
		ISNULL(@EXP_INGRESADOS_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3
			
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 
		AND  FS.TIPO = 'PLD'
		GROUP BY F.PRODUCTO

		UNION ALL

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'1.1' AS nro, 					
		'Oferta Aprobada' AS descripcion_estado,		
		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_OFAPROBADA_MES1,0) AS mes1,
		ISNULL(@EXP_OFAPROBADA_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3																			  
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 
		AND  FS.TIPO = 'PLD' AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
		GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA

		UNION ALL

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'1.2' AS nro, 					
		'Oferta Regular' AS descripcion_estado,			
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_OFREGULAR_MES1,0) AS mes1,
		ISNULL(@EXP_OFREGULAR_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 
		AND  FS.TIPO = 'PLD' AND F.MODALIDAD_DE_VENTA = 'REGULAR'
		GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA		
		
		UNION ALL 

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'2' AS nro, 					
		'Expedientes Rechazados' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_RECHAZADO_MES1,0) AS mes1,
		ISNULL(@EXP_RECHAZADO_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 
		AND FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'RECHAZADO'
		GROUP BY F.PRODUCTO

		UNION ALL 

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'2.1' AS nro, 					
		'Oferta Aprobada' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_RECHAZADO_AP_MES1,0) AS mes1,
		ISNULL(@EXP_RECHAZADO_AP_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 
		AND FS.TIPO = 'PLD'  		
		AND F.ESTADO_ACTUAL = 'RECHAZADO'
		AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
		GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA

		UNION ALL 

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'2.2' AS nro, 					
		'Oferta Regular' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_RECHAZADO_RE_MES1,0) AS mes1,
		ISNULL(@EXP_RECHAZADO_RE_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3
			
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 
		AND FS.TIPO = 'PLD'  		
		AND F.ESTADO_ACTUAL = 'RECHAZADO'
		AND F.MODALIDAD_DE_VENTA = 'REGULAR'
		GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA

		UNION ALL 

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'3' AS nro, 					
		'Expedientes Desembolsados' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_DESEMBOLSADO_MES1,0) AS mes1,
		ISNULL(@EXP_DESEMBOLSADO_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3		
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,F.FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,F.FECHA_DE_ESTADO)) = @AÑO 
		AND FS.TIPO = 'PLD'  		
		AND F.ESTADO_ACTUAL = 'FORMALIZADO'
		GROUP BY F.PRODUCTO

		UNION ALL

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'3.1' AS nro, 					
		'Oferta Aprobada' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_DESEMBOLSADO_AP_MES1,0) AS mes1,
		ISNULL(@EXP_DESEMBOLSADO_AP_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3		
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 
		AND  FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'FORMALIZADO'
		AND F.MODALIDAD_DE_VENTA = 'APROBADOS'
		GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA

		UNION ALL

		SELECT
		'PRESTAMO DE LIBRE DISPONIBILIDAD' AS producto,
		'3.2' AS nro, 					
		'Oferta Regular' AS descripcion_estado,			
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@EXP_DESEMBOLSADO_RE_MES1,0) AS mes1,
		ISNULL(@EXP_DESEMBOLSADO_RE_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
		ON F.COD_SUB_PRODUCTO = FS.CODIGO
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 
		AND  FS.TIPO = 'PLD' AND F.ESTADO_ACTUAL = 'FORMALIZADO'
		AND F.MODALIDAD_DE_VENTA = 'REGULAR'
		GROUP BY F.PRODUCTO, F.MODALIDAD_DE_VENTA

		UNION ALL
		---------------------------------------------------------------///////// TARJETAS			

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'1' AS nro, 					
		'Expedientes Ingresados' AS descripcion_estado,			
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_EXP_INGRESADOS_MES1,0) AS mes1,
		ISNULL(@T_EXP_INGRESADOS_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX 
		WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 		
        AND PRODUCTO = 'TARJETAS'
		GROUP BY PRODUCTO

		UNION ALL

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'1.1' AS nro, 					
		'Fisico' AS descripcion_estado,			
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_EXP_INGR_FISICO_MES1,0) AS mes1,
		ISNULL(@T_EXP_INGR_FISICO_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX 
		WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 		
        AND PRODUCTO = 'TARJETAS' 
		AND FUERZA_DE_VENTA =  'COMCORP SAC' -- fisico
		GROUP BY PRODUCTO, FECHA_DE_REGISTRO	

		UNION ALL

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'1.2' AS nro, 					
		'Parpeless' AS descripcion_estado,	
		@fecha_proceso as fecha_proceso,

		------------ISNULL(COUNT(DISTINCT CASE WHEN DAY(FECHA_HORA_ENVIO) = 2 THEN NRO_EXPEDIENTE END),0) AS '02',
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_EXP_INGR_PAPERLESS_MES1,0) AS mes1,
		ISNULL(@T_EXP_INGR_PAPERLESS_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX 
		WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 		
        AND PRODUCTO = 'TARJETAS' 
		AND FUERZA_DE_VENTA !=  'COMCORP SAC' ---------------- parpeless
		GROUP BY PRODUCTO		
		
		UNION ALL

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'2' AS nro, 					
		'Expedientes Rechazados' AS descripcion_estado,		
		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10  THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11  THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12  THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13  THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14  THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15  THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16  THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17  THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18  THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19  THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20  THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21  THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22  THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23  THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24  THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25  THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26  THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27  THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28  THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29  THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30  THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31  THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_EXP_RECHAZADOS_MES1,0) AS mes1,
		ISNULL(@T_EXP_RECHAZADOS_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 		
		AND PRODUCTO = 'TARJETAS'
		AND ESTADO_ACTUAL = 'RECHAZADO'


		UNION ALL 


		SELECT
		'TARJETA DE CREDITO' AS producto,
		'2.1' AS nro, 					
		'Fisico' AS descripcion_estado,		
		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10  THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11  THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12  THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13  THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14  THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15  THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16  THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17  THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18  THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19  THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20  THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21  THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22  THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23  THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24  THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25  THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26  THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27  THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28  THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29  THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30  THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31  THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_EXP_RECH_FISICO_MES1,0) AS mes1,
		ISNULL(@T_EXP_RECH_FISICO_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3
			
						
		FROM TB_FUVEX
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 		
		AND PRODUCTO = 'TARJETAS'
		AND ESTADO_ACTUAL = 'RECHAZADO'
		AND  TIPO_DE_CAPTACION != 'PAPERLESS' -- FISICO

		UNION ALL 

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'2.2' AS nro, 					
		'Paperless' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_EXP_RECH_PAPERLESS_MES1,0) AS mes1,
		ISNULL(@T_EXP_RECH_PAPERLESS_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 		
		AND PRODUCTO = 'TARJETAS'
		AND ESTADO_ACTUAL = 'RECHAZADO' AND 
		TIPO_DE_CAPTACION = 'PAPERLESS'

		UNION ALL 

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'3' AS nro, 					
		'Expedientes Desembolsados' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,	
						
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_DESEMBOLSADOS_MES1,0) AS mes1,
		ISNULL(@T_DESEMBOLSADOS_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3
			
						
		FROM TB_FUVEX
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 		
		AND PRODUCTO = 'TARJETAS'
		AND ESTADO_ACTUAL = 'FORMALIZADO'
		GROUP BY PRODUCTO

		UNION ALL 

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'3.1' AS nro, 					
		'Fisico' AS descripcion_estado,			
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_DESEMBOLSADOS_FISICO_MES1,0) AS mes1,
		ISNULL(@T_DESEMBOLSADOS_FISICO_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 		
		AND PRODUCTO = 'TARJETAS'
		AND ESTADO_ACTUAL = 'FORMALIZADO' AND FUERZA_DE_VENTA = 'COMCORP SAC' -- FISICO
		GROUP BY PRODUCTO

		UNION ALL 

		SELECT
		'TARJETA DE CREDITO' AS producto,
		'3.2' AS nro, 					
		'Parperless' AS descripcion_estado,		
		@fecha_proceso as fecha_proceso,
					
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10  THEN 1 else 0 END),0) AS dia10,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11  THEN 1 else 0 END),0) AS dia11,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12  THEN 1 else 0 END),0) AS dia12,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13  THEN 1 else 0 END),0) AS dia13,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14  THEN 1 else 0 END),0) AS dia14,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15  THEN 1 else 0 END),0) AS dia15,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16  THEN 1 else 0 END),0) AS dia16,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17  THEN 1 else 0 END),0) AS dia17,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18  THEN 1 else 0 END),0) AS dia18,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19  THEN 1 else 0 END),0) AS dia19,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20  THEN 1 else 0 END),0) AS dia20,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21  THEN 1 else 0 END),0) AS dia21,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22  THEN 1 else 0 END),0) AS dia22,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23  THEN 1 else 0 END),0) AS dia23,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24  THEN 1 else 0 END),0) AS dia24,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25  THEN 1 else 0 END),0) AS dia25,
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26  THEN 1 else 0 END),0) AS dia26,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27  THEN 1 else 0 END),0) AS dia27,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28  THEN 1 else 0 END),0) AS dia28,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29  THEN 1 else 0 END),0) AS dia29,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30  THEN 1 else 0 END),0) AS dia30,	
		ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31  THEN 1 else 0 END),0) AS dia31,	

		ISNULL(@T_DESEMBOLSADOS_PAPERLESS_MES1,0) AS mes1,
		ISNULL(@T_DESEMBOLSADOS_PAPERLESS_MES2,0) AS mes2,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3			
						
		FROM TB_FUVEX
		WHERE MONTH(CONVERT(date,FECHA_DE_ESTADO)) = @MES 
		and YEAR(CONVERT(date,FECHA_DE_ESTADO)) = @AÑO 		
		AND PRODUCTO = 'TARJETAS'
		AND ESTADO_ACTUAL = 'FORMALIZADO' 
		AND FUERZA_DE_VENTA != 'COMCORP SAC' --------- PAPERLESS
		GROUP BY PRODUCTO
		--------------------------------------------// MOSTRAMOS
		----------------SELECT * FROM TB_FUVEX_RO

		
	-------------***//  Para sacar el indicador global del porcentaje de reprocesos pestaña RESUMEN //**---------------

insert into #PRODUCTOS VALUES ('PRESTAMO DE LIBRE DISPONIBILIDAD')
insert into #PRODUCTOS VALUES ('TARJETA DE CREDITO')

SET @CONTMAX_P = (SELECT COUNT(cod) FROM #PRODUCTOS)

	WHILE @CONT_P <= @CONTMAX_P
		BEGIN 


		SET @PRODUCTO_NAME = (SELECT producto FROM #PRODUCTOS WHERE cod=@CONT_P)

CREATE TABLE #FUVEX_REPROCESOS_TOTAL(	
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,	
	[mes1] [decimal](18, 2) NULL,		
	[mes2] [decimal](18, 2) NULL,		
	[mes3] [decimal](18, 2) NULL	
)
------------------////
CREATE TABLE #PARTE1(	
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[mes1] [decimal](18, 2) NULL,		
	[mes2] [decimal](18, 2) NULL,		
	[mes3] [decimal](18, 2) NULL	
	)
	------------------////

CREATE TABLE #SUMAS(	
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[mes1] [decimal](18, 2) NULL,		
	[mes2] [decimal](18, 2) NULL,		
	[mes3] [decimal](18, 2) NULL	
	)
		------------------------------------------------------------//SUMAS PARTE 1
		select * 
		into #REPROCESOS_PLD_CS				
		from PLD_TC_CONVENIO 
		where producto = @PRODUCTO_NAME
		and descripcion = 'EXP.REPROCESOS-DIA'
		and fecha_proceso = @fecha_proceso

		alter table #REPROCESOS_PLD_CS  drop column codigo, producto, descripcion, valor_objetivo,fecha_proceso;

		IF(@PRODUCTO_NAME = 'PRESTAMO DE LIBRE DISPONIBILIDAD')
		BEGIN
			INSERT INTO #FUVEX_REPROCESOS_TOTAL
			SELECT 					
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10 THEN 1 else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11 THEN 1 else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12 THEN 1 else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13 THEN 1 else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14 THEN 1 else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15 THEN 1 else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16 THEN 1 else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17 THEN 1 else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18 THEN 1 else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19 THEN 1 else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20 THEN 1 else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21 THEN 1 else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22 THEN 1 else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23 THEN 1 else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24 THEN 1 else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25 THEN 1 else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26 THEN 1 else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27 THEN 1 else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28 THEN 1 else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29 THEN 1 else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30 THEN 1 else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31 THEN 1 else 0 END),0) AS dia31,
			ISNULL(@PLD_REPROCESOS_TOTAL_M1,0) AS mes1,
			ISNULL(@PLD_REPROCESOS_TOTAL_M2,0) AS mes2,
			ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3

			FROM TB_FUVEX AS FU	INNER JOIN TB_FUVEX_SUBPRODUCTO AS SU
			ON FU.COD_SUB_PRODUCTO=SU.CODIGO
			WHERE MONTH(FECHA_DE_ESTADO) = @MES
			AND YEAR(FECHA_DE_ESTADO) = @AÑO
			AND SU.TIPO = 'PLD'
			AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM', 'RECHAZADO')
		END

		ELSE

			BEGIN

			INSERT INTO #FUVEX_REPROCESOS_TOTAL
			SELECT 					
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 1 THEN 1 ELSE 0 END),0) AS dia1,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 2 THEN 1 ELSE 0 END),0) AS dia2,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 3 THEN 1 ELSE 0 END),0) AS dia3,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 4 THEN 1 else 0 END),0) AS dia4,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 5 THEN 1 else 0 END),0) AS dia5,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 6 THEN 1 else 0 END),0) AS dia6,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 7 THEN 1 else 0 END),0) AS dia7,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 8 THEN 1 else 0 END),0) AS dia8,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 9 THEN 1 else 0 END),0) AS dia9,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 10  THEN 1 else 0 END),0) AS dia10,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 11  THEN 1 else 0 END),0) AS dia11,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 12  THEN 1 else 0 END),0) AS dia12,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 13  THEN 1 else 0 END),0) AS dia13,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 14  THEN 1 else 0 END),0) AS dia14,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 15  THEN 1 else 0 END),0) AS dia15,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 16  THEN 1 else 0 END),0) AS dia16,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 17  THEN 1 else 0 END),0) AS dia17,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 18  THEN 1 else 0 END),0) AS dia18,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 19  THEN 1 else 0 END),0) AS dia19,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 20  THEN 1 else 0 END),0) AS dia20,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 21  THEN 1 else 0 END),0) AS dia21,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 22  THEN 1 else 0 END),0) AS dia22,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 23  THEN 1 else 0 END),0) AS dia23,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 24  THEN 1 else 0 END),0) AS dia24,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 25  THEN 1 else 0 END),0) AS dia25,
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 26  THEN 1 else 0 END),0) AS dia26,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 27  THEN 1 else 0 END),0) AS dia27,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 28  THEN 1 else 0 END),0) AS dia28,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 29  THEN 1 else 0 END),0) AS dia29,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 30  THEN 1 else 0 END),0) AS dia30,	
			ISNULL(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_ESTADO)) = 31  THEN 1 else 0 END),0) AS dia31,
			ISNULL(@TC_REPROCESOS_TOTAL_M1,0) AS mes1,
			ISNULL(@TC_REPROCESOS_TOTAL_M2,0) AS mes2,
			ISNULL(SUM(CASE WHEN MONTH(FECHA_DE_ESTADO) = @MES THEN 1 else 0 end),0)  as mes3
			FROM TB_FUVEX
			WHERE MONTH(FECHA_DE_ESTADO) = @MES
			AND YEAR(FECHA_DE_ESTADO) = @AÑO
			AND PRODUCTO = 'TARJETAS' 
			AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM','RECHAZADO')
				
			END

		insert into #PARTE1
		select * from #REPROCESOS_PLD_CS
		union all
		select * from #FUVEX_REPROCESOS_TOTAL

		-------------------/// SUMAS PARTE 2
		select * 
		INTO #INGRESADOS_PLD_FUVEX
		from TB_FUVEX_RO
		where producto = @PRODUCTO_NAME 
		and descripcion_estado = 'Expedientes Ingresados'
		and fecha_proceso = @fecha_proceso

		alter table #INGRESADOS_PLD_FUVEX drop column codigo, producto, nro, descripcion_estado,fecha_proceso;	

		select * 
		into #INGRESADOS_PLD_CS				
		from PLD_TC_CONVENIO where producto = @PRODUCTO_NAME
		and descripcion = 'EXP.INGRESADOS'
		and fecha_proceso = @fecha_proceso

		alter table #INGRESADOS_PLD_CS  drop column codigo, producto, descripcion, valor_objetivo,fecha_proceso;

CREATE TABLE #PARTE2(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[mes1] [decimal](18, 2) NULL,		
	[mes2] [decimal](18, 2) NULL,		
	[mes3] [decimal](18, 2) NULL	
	)

		insert into #PARTE2
		select * from #INGRESADOS_PLD_FUVEX
		union all
		select * from #INGRESADOS_PLD_CS

		-----select * from #PARTE2			
		INSERT INTO #SUMAS 	
		select 
		a.dia1+b.dia1 AS '01', 
		a.dia2+b.dia2 AS '02', 
		a.dia3+b.dia3 AS '03',
		a.dia4+b.dia4 AS '04',
		a.dia5+b.dia5 AS '05',
		a.dia6+b.dia6 AS '06',
		a.dia7+b.dia7 AS '07',
		a.dia8+b.dia8 AS '08',
		a.dia9+b.dia9 AS '09',
		a.dia10+b.dia10 AS '10',
		a.dia11+b.dia11 AS '11',
		a.dia12+b.dia12 AS '12',
		a.dia13+b.dia13 AS '13',
		a.dia14+b.dia14 AS '14',
		a.dia15+b.dia15 AS '15',
		a.dia16+b.dia16 AS '16',
		a.dia17+b.dia17 AS '17',
		a.dia18+b.dia18 AS '18',
		a.dia19+b.dia19 AS '19',
		a.dia20+b.dia20 AS '20',
		a.dia21+b.dia21 AS '21',
		a.dia22+b.dia22 AS '22',
		a.dia23+b.dia23 AS '23',
		a.dia24+b.dia24 AS '24',
		a.dia25+b.dia25 AS '25',
		a.dia26+b.dia26 AS '26',
		a.dia27+b.dia27 AS '27',
		a.dia28+b.dia28 AS '28',
		a.dia29+b.dia29 AS '29',
		a.dia30+b.dia30 AS '30',
		a.dia31+b.dia31 AS '31',
		a.mes1+b.mes1 AS 'mes1',
		a.mes2+b.mes2 AS 'mes2',
		a.mes3+b.mes3 AS 'mes3'
		
		from #PARTE1 a LEFT JOIN #PARTE1 b
		ON a.codigo = 1	WHERE b.codigo = 2

		INSERT INTO #SUMAS 	
		SELECT	
		a.dia1+b.dia1 AS '01', 
		a.dia2+b.dia2 AS '02', 
		a.dia3+b.dia3 AS '03',
		a.dia4+b.dia4 AS '04',
		a.dia5+b.dia5 AS '05',
		a.dia6+b.dia6 AS '06',
		a.dia7+b.dia7 AS '07',
		a.dia8+b.dia8 AS '08',
		a.dia9+b.dia9 AS '09',
		a.dia10+b.dia10 AS '10',
		a.dia11+b.dia11 AS '11',
		a.dia12+b.dia12 AS '12',
		a.dia13+b.dia13 AS '13',
		a.dia14+b.dia14 AS '14',
		a.dia15+b.dia15 AS '15',
		a.dia16+b.dia16 AS '16',
		a.dia17+b.dia17 AS '17',
		a.dia18+b.dia18 AS '18',
		a.dia19+b.dia19 AS '19',
		a.dia20+b.dia20 AS '20',
		a.dia21+b.dia21 AS '21',
		a.dia22+b.dia22 AS '22',
		a.dia23+b.dia23 AS '23',
		a.dia24+b.dia24 AS '24',
		a.dia25+b.dia25 AS '25',
		a.dia26+b.dia26 AS '26',
		a.dia27+b.dia27 AS '27',
		a.dia28+b.dia28 AS '28',
		a.dia29+b.dia29 AS '29',
		a.dia30+b.dia30 AS '30',
		a.dia31+b.dia31 AS '31',
		a.mes1+b.mes1 AS 'mes1',
		a.mes2+b.mes2 AS 'mes2',
		a.mes3+b.mes3 AS 'mes3'	

		FROM #PARTE2 a LEFT JOIN #PARTE2 b
		ON a.codigo = 1	WHERE b.codigo = 2

		-----select * from #PARTE1
		-----select * from #PARTE2
		-----SELECT * FROM #SUMAS
		INSERT INTO PLD_TC_CONVENIO
		SELECT  @PRODUCTO_NAME AS PRODUCTO,
		 'PORCENTAJE DE REPROCESOS GLOBAL' AS DESCRIPCION,
		 25 AS VO,
		@fecha_proceso AS fecha_proceso,
		
		----Si la division no se puede entre 0 pone NULL con NULLIF, y luego quitamos el NULL con ISNULL y 
		----en vez de 0 Ponemos 1 para que divida entre 1

		cast(a.dia1/ISNULL(NULLIF(b.dia1,0),1)* 100 as decimal(18,2))  AS '01', 
		cast(a.dia2/ISNULL(NULLIF(b.dia2,0),1)* 100 as decimal(18,2)) AS '02', 
		cast(a.dia3/ISNULL(NULLIF(b.dia3,0),1)* 100 as decimal(18,2)) AS '03',
		cast(a.dia4/ISNULL(NULLIF(b.dia4,0),1)* 100 as decimal(18,2)) AS '04',
		cast(a.dia5/ISNULL(NULLIF(b.dia5,0),1)* 100 as decimal(18,2)) AS '05',
		cast(a.dia6/ISNULL(NULLIF(b.dia6,0),1)* 100 as decimal(18,2)) AS '06',
		cast(a.dia7/ISNULL(NULLIF(b.dia7,0),1)* 100 as decimal(18,2)) AS '07',
		cast(a.dia8/ISNULL(NULLIF(b.dia8,0),1)* 100 as decimal(18,2)) AS '08',
		cast(a.dia9/ISNULL(NULLIF(b.dia9,0),1)* 100 as decimal(18,2)) AS '09',
		cast(a.dia10/ISNULL(NULLIF(b.dia10,0),1)* 100 as decimal(18,2)) AS '10',
		cast(a.dia11/ISNULL(NULLIF(b.dia11,0),1)* 100 as decimal(18,2)) AS '11',
		cast(a.dia12/ISNULL(NULLIF(b.dia12,0),1)* 100 as decimal(18,2)) AS '12',
		cast(a.dia13/ISNULL(NULLIF(b.dia13,0),1)* 100 as decimal(18,2)) AS '13',
		cast(a.dia14/ISNULL(NULLIF(b.dia14,0),1)* 100 as decimal(18,2)) AS '14',
		cast(a.dia15/ISNULL(NULLIF(b.dia15,0),1)* 100 as decimal(18,2)) AS '15',
		cast(a.dia16/ISNULL(NULLIF(b.dia16,0),1)* 100 as decimal(18,2)) AS '16',
		cast(a.dia17/ISNULL(NULLIF(b.dia17,0),1)* 100 as decimal(18,2)) AS '17',
		cast(a.dia18/ISNULL(NULLIF(b.dia18,0),1)* 100 as decimal(18,2)) AS '18',
		cast(a.dia19/ISNULL(NULLIF(b.dia19,0),1)* 100 as decimal(18,2)) AS '19',
		cast(a.dia20/ISNULL(NULLIF(b.dia20,0),1)* 100 as decimal(18,2)) AS '20',
		cast(a.dia21/ISNULL(NULLIF(b.dia21,0),1)* 100 as decimal(18,2)) AS '21',
		cast(a.dia22/ISNULL(NULLIF(b.dia22,0),1)* 100 as decimal(18,2)) AS '22',
		cast(a.dia23/ISNULL(NULLIF(b.dia23,0),1)* 100 as decimal(18,2)) AS '23',
		cast(a.dia24/ISNULL(NULLIF(b.dia24,0),1)* 100 as decimal(18,2)) AS '24',
		cast(a.dia25/ISNULL(NULLIF(b.dia25,0),1)* 100 as decimal(18,2)) AS '25',
		cast(a.dia26/ISNULL(NULLIF(b.dia26,0),1)* 100 as decimal(18,2)) AS '26',
		cast(a.dia27/ISNULL(NULLIF(b.dia27,0),1)* 100 as decimal(18,2)) AS '27',
		cast(a.dia28/ISNULL(NULLIF(b.dia28,0),1)* 100 as decimal(18,2)) AS '28',
		cast(a.dia29/ISNULL(NULLIF(b.dia29,0),1)* 100 as decimal(18,2)) AS '29',
		cast(a.dia30/ISNULL(NULLIF(b.dia30,0),1)* 100 as decimal(18,2)) AS '30',
		cast(a.dia31/ISNULL(NULLIF(b.dia31,0),1)* 100 as decimal(18,2)) AS '31',
		cast(a.mes1/ISNULL(NULLIF(b.mes1,0),1)* 100 as decimal(18,2)) AS 'mes1',
		cast(a.mes2/ISNULL(NULLIF(b.mes2,0),1)* 100 as decimal(18,2)) AS 'mes2',
		cast(a.mes3/ISNULL(NULLIF(b.mes3,0),1)* 100 as decimal(18,2)) AS 'mes3'

		FROM #SUMAS a LEFT JOIN #SUMAS b
		ON a.codigo = 1	WHERE b.codigo = 2


		DROP TABLE #REPROCESOS_PLD_CS
		DROP TABLE #FUVEX_REPROCESOS_TOTAL
		DROP TABLE #INGRESADOS_PLD_CS
		DROP TABLE #INGRESADOS_PLD_FUVEX
		DROP TABLE #PARTE1
		DROP TABLE #PARTE2
		DROP TABLE #SUMAS

		SET @CONT_P = @CONT_P+1

		END ------------- END WHILE PRODUCTOS
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_CANTIDAD_DEVUELTO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TB_FUVEX_CANTIDAD_DEVUELTO]
(@MES int,
@AÑO int,
@TIPO VARCHAR(50))

AS

BEGIN

DECLARE @FECHA_FIN DATE;

SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) 
					FROM TB_CS 
					WHERE MONTH(FECHA_HORA_ENVIO) = @MES	
					AND YEAR(FECHA_HORA_ENVIO) = @AÑO)

CREATE TABLE #DEVUELTOS
(
	codigo int identity(1,1) not null,
	producto varchar(100),
	fecha_estado date,
	estado_actual varchar(100),
	cant_devueltos int
)
CREATE TABLE #DEVUELTOS2
(
	codigo int identity(1,1) not null,
	producto varchar(100),
	fecha_estado date,	
	cant_devueltos int
)

CREATE TABLE #PLD(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](50) NULL,
	[descripcion_estado] [varchar](50) NULL,	
	[dia1] [decimal](10,2) NULL,
	[dia2] [decimal](10,2) NULL,
	[dia3] [decimal](10,2) NULL,
	[dia4] [decimal](10,2) NULL,
	[dia5] [decimal](10,2) NULL,
	[dia6] [decimal](10,2) NULL,
	[dia7] [decimal](10,2) NULL,
	[dia8] [decimal](10,2) NULL,
	[dia9] [decimal](10,2) NULL,
	[dia10] [decimal](10,2) NULL,
	[dia11] [decimal](10,2) NULL,
	[dia12] [decimal](10,2) NULL,
	[dia13] [decimal](10,2) NULL,
	[dia14] [decimal](10,2) NULL,
	[dia15] [decimal](10,2) NULL,
	[dia16] [decimal](10,2) NULL,
	[dia17] [decimal](10,2) NULL,
	[dia18] [decimal](10,2) NULL,
	[dia19] [decimal](10,2) NULL,
	[dia20] [decimal](10,2) NULL,
	[dia21] [decimal](10,2) NULL,
	[dia22] [decimal](10,2) NULL,
	[dia23] [decimal](10,2) NULL,
	[dia24] [decimal](10,2) NULL,
	[dia25] [decimal](10,2) NULL,
	[dia26] [decimal](10,2) NULL,
	[dia27] [decimal](10,2) NULL,
	[dia28] [decimal](10,2) NULL,
	[dia29] [decimal](10,2) NULL,
	[dia30] [decimal](10,2) NULL,
	[dia31] [decimal](10,2) NULL,
	[mes1] [decimal](10,2) NULL,		
	[mes2] [decimal](10,2) NULL,
	[mes3] [decimal](10,2) NULL
)

CREATE TABLE #TC(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](50) NULL,
	[descripcion_estado] [varchar](50) NULL,	
	[dia1] [decimal](10,2) NULL,
	[dia2] [decimal](10,2) NULL,
	[dia3] [decimal](10,2) NULL,
	[dia4] [decimal](10,2) NULL,
	[dia5] [decimal](10,2) NULL,
	[dia6] [decimal](10,2) NULL,
	[dia7] [decimal](10,2) NULL,
	[dia8] [decimal](10,2) NULL,
	[dia9] [decimal](10,2) NULL,
	[dia10] [decimal](10,2) NULL,
	[dia11] [decimal](10,2) NULL,
	[dia12] [decimal](10,2) NULL,
	[dia13] [decimal](10,2) NULL,
	[dia14] [decimal](10,2) NULL,
	[dia15] [decimal](10,2) NULL,
	[dia16] [decimal](10,2) NULL,
	[dia17] [decimal](10,2) NULL,
	[dia18] [decimal](10,2) NULL,
	[dia19] [decimal](10,2) NULL,
	[dia20] [decimal](10,2) NULL,
	[dia21] [decimal](10,2) NULL,
	[dia22] [decimal](10,2) NULL,
	[dia23] [decimal](10,2) NULL,
	[dia24] [decimal](10,2) NULL,
	[dia25] [decimal](10,2) NULL,
	[dia26] [decimal](10,2) NULL,
	[dia27] [decimal](10,2) NULL,
	[dia28] [decimal](10,2) NULL,
	[dia29] [decimal](10,2) NULL,
	[dia30] [decimal](10,2) NULL,
	[dia31] [decimal](10,2) NULL,
	[mes1] [decimal](10,2) NULL,		
	[mes2] [decimal](10,2) NULL,
	[mes3] [decimal](10,2) NULL	
)

IF @TIPO = 'TOTAL'

BEGIN

-----------------------------------------------------//REPROCESAR
DELETE FROM PLD_TC_CONVENIO
WHERE  descripcion = 'PORCENTAJE REPROCESOS FUVEX'
and fecha_proceso = @FECHA_FIN
-----------------------------------------------------//REPROCESAR



INSERT INTO #DEVUELTOS
-----------------------------------------------------//MES 1
SELECT 'TC' AS 'PRODUCTO' , FECHA_DE_ESTADO, ESTADO_ACTUAL, COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS 
FROM TB_FUVEX
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN))
AND PRODUCTO = 'TARJETAS' 
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM','RECHAZADO')
GROUP BY FECHA_DE_ESTADO, ESTADO_ACTUAL

UNION ALL

SELECT 'PLD' , FU.FECHA_DE_ESTADO,FU.ESTADO_ACTUAL,COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS 
FROM TB_FUVEX AS FU
INNER JOIN TB_FUVEX_SUBPRODUCTO AS SU
ON FU.COD_SUB_PRODUCTO=SU.CODIGO
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN))
AND SU.TIPO = 'PLD'
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM', 'RECHAZADO')
GROUP BY FECHA_DE_ESTADO,FU.ESTADO_ACTUAL


UNION ALL
-----------------------------------------------------//MES 2
SELECT 'TC' AS 'PRODUCTO' , FECHA_DE_ESTADO, ESTADO_ACTUAL, COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS 
FROM TB_FUVEX
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN))
AND PRODUCTO = 'TARJETAS' 
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM','RECHAZADO')
GROUP BY FECHA_DE_ESTADO, ESTADO_ACTUAL

UNION ALL

SELECT 'PLD' , FU.FECHA_DE_ESTADO,FU.ESTADO_ACTUAL,COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS 
FROM TB_FUVEX AS FU
INNER JOIN TB_FUVEX_SUBPRODUCTO AS SU
ON FU.COD_SUB_PRODUCTO=SU.CODIGO
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN))
AND SU.TIPO = 'PLD'
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM', 'RECHAZADO')
GROUP BY FECHA_DE_ESTADO,FU.ESTADO_ACTUAL


UNION ALL
-----------------------------------------------------//MES 3
SELECT 'TC' AS 'PRODUCTO' , FECHA_DE_ESTADO, ESTADO_ACTUAL, COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS 
FROM TB_FUVEX
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) =  @MES
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = @AÑO
AND PRODUCTO = 'TARJETAS' 
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM','RECHAZADO')
GROUP BY FECHA_DE_ESTADO, ESTADO_ACTUAL

UNION ALL

SELECT 'PLD' , FU.FECHA_DE_ESTADO,FU.ESTADO_ACTUAL,COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS 
FROM TB_FUVEX AS FU
INNER JOIN TB_FUVEX_SUBPRODUCTO AS SU
ON FU.COD_SUB_PRODUCTO=SU.CODIGO
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) =  @MES
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = @AÑO
AND SU.TIPO = 'PLD'
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM', 'RECHAZADO')
GROUP BY FECHA_DE_ESTADO,FU.ESTADO_ACTUAL
ORDER BY 2,1,3

--select * from #DEVUELTOS
------------------------------------------------------------------** DEVUELTOS 2//

INSERT INTO #DEVUELTOS2
-----------------------------------------------------//MES 1
SELECT 'PLD' as PRODUCTO, FECHA_DE_ESTADO, COUNT(*) 
FROM TB_FUVEX F FULL OUTER JOIN  TB_FUVEX_SUBPRODUCTO S
ON S.CODIGO = F.COD_SUB_PRODUCTO
WHERE MONTH(F.FECHA_DE_ESTADO)=  MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
AND YEAR(F.FECHA_DE_ESTADO) =   YEAR(DATEADD(MONTH, -2, @FECHA_FIN))
AND S.TIPO = 'PLD'
GROUP BY F.FECHA_DE_ESTADO

UNION ALL

SELECT 'TC' as PRODUCTO, FECHA_DE_ESTADO, COUNT(*) 
FROM TB_FUVEX F 
WHERE MONTH(F.FECHA_DE_ESTADO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))
AND YEAR(F.FECHA_DE_ESTADO) =   YEAR(DATEADD(MONTH, -2, @FECHA_FIN))
AND F.PRODUCTO = 'TARJETAS'
GROUP BY F.FECHA_DE_ESTADO

UNION ALL

-----------------------------------------------------//MES 2
SELECT 'PLD' as PRODUCTO, FECHA_DE_ESTADO, COUNT(*) 
FROM TB_FUVEX F FULL OUTER JOIN  TB_FUVEX_SUBPRODUCTO S
ON S.CODIGO = F.COD_SUB_PRODUCTO
WHERE MONTH(F.FECHA_DE_ESTADO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) 
AND YEAR(F.FECHA_DE_ESTADO) =   YEAR(DATEADD(MONTH, -1, @FECHA_FIN))
AND S.TIPO = 'PLD'
GROUP BY F.FECHA_DE_ESTADO

UNION ALL

SELECT 'TC' as PRODUCTO, FECHA_DE_ESTADO, COUNT(*) 
FROM TB_FUVEX F 
WHERE MONTH(F.FECHA_DE_ESTADO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) 
AND YEAR(F.FECHA_DE_ESTADO) =   YEAR(DATEADD(MONTH, -1, @FECHA_FIN))
AND F.PRODUCTO = 'TARJETAS'
GROUP BY F.FECHA_DE_ESTADO


UNION ALL

-----------------------------------------------------//MES 3
SELECT 'PLD' as PRODUCTO, FECHA_DE_ESTADO, COUNT(*) 
FROM TB_FUVEX F FULL OUTER JOIN  TB_FUVEX_SUBPRODUCTO S
ON S.CODIGO = F.COD_SUB_PRODUCTO
WHERE MONTH(F.FECHA_DE_ESTADO) = @MES 
AND YEAR(F.FECHA_DE_ESTADO) = @AÑO AND S.TIPO = 'PLD'
GROUP BY F.FECHA_DE_ESTADO

UNION ALL

SELECT 'TC' as PRODUCTO, FECHA_DE_ESTADO, COUNT(*) 
FROM TB_FUVEX F 
WHERE MONTH(F.FECHA_DE_ESTADO) = @MES 
AND YEAR(F.FECHA_DE_ESTADO) = @AÑO AND F.PRODUCTO = 'TARJETAS'
GROUP BY F.FECHA_DE_ESTADO

--------------------------------------------------------------------------------//////
------SELECT * FROM #DEVUELTOS2

INSERT INTO #PLD
SELECT 'PLD' as producto,'Expedientes Reprocesos(total)' as descripcion,
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 1 THEN cant_devueltos END),0) AS "01",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 2 THEN cant_devueltos END),0) AS "02",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 3 THEN cant_devueltos END),0) AS "03",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 4 THEN cant_devueltos END),0) AS "04",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 5 THEN cant_devueltos END),0) AS "05",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 6 THEN cant_devueltos END),0) AS "06",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 7 THEN cant_devueltos END),0) AS "07",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 8 THEN cant_devueltos END),0) AS "08",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 9 THEN cant_devueltos END),0) AS "09",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 10  THEN cant_devueltos END),0) AS "10",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 11 THEN cant_devueltos END),0) AS "11",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 12 THEN cant_devueltos END),0) AS "12",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 13 THEN cant_devueltos END),0) AS "13",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 14 THEN cant_devueltos END),0) AS "14",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 15 THEN cant_devueltos END),0) AS "15",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 16 THEN cant_devueltos END),0) AS "16",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 17 THEN cant_devueltos END),0) AS "17",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 18 THEN cant_devueltos END),0) AS "18",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 19 THEN cant_devueltos END),0) AS "19",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 20 THEN cant_devueltos END),0) AS "20",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 21 THEN cant_devueltos END),0) AS "21",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 22 THEN cant_devueltos END),0) AS "22",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 23 THEN cant_devueltos END),0) AS "23",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 24 THEN cant_devueltos END),0) AS "24",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 25 THEN cant_devueltos END),0) AS "25",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 26 THEN cant_devueltos END),0) AS "26",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 27 THEN cant_devueltos END),0) AS "27",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 28 THEN cant_devueltos END),0) AS "28",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 29 THEN cant_devueltos END),0) AS "29",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 30 THEN cant_devueltos END),0) AS "30",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 31 THEN cant_devueltos END),0) AS "31",	
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes1",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes2",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = @MES THEN cant_devueltos END),0) AS "mes3"
 
FROM #DEVUELTOS
WHERE producto = 'PLD' AND estado_actual IN ('DEVUELTO A FV','DEVUELTO POR CPM')

UNION ALL

SELECT 'PLD' as producto , 'Expedientes Procesados' as descripcion,
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 1 THEN cant_devueltos END),0) AS "01",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 2 THEN cant_devueltos END),0) AS "02",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 3 THEN cant_devueltos END),0) AS "03",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 4 THEN cant_devueltos END),0) AS "04",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 5 THEN cant_devueltos END),0) AS "05",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 6 THEN cant_devueltos END),0) AS "06",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 7 THEN cant_devueltos END),0) AS "07",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 8 THEN cant_devueltos END),0) AS "08",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 9 THEN cant_devueltos END),0) AS "09",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 10  THEN cant_devueltos END),0) AS "10",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 11 THEN cant_devueltos END),0) AS "11",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 12 THEN cant_devueltos END),0) AS "12",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 13 THEN cant_devueltos END),0) AS "13",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 14 THEN cant_devueltos END),0) AS "14",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 15 THEN cant_devueltos END),0) AS "15",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 16 THEN cant_devueltos END),0) AS "16",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 17 THEN cant_devueltos END),0) AS "17",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 18 THEN cant_devueltos END),0) AS "18",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 19 THEN cant_devueltos END),0) AS "19",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 20 THEN cant_devueltos END),0) AS "20",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 21 THEN cant_devueltos END),0) AS "21",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 22 THEN cant_devueltos END),0) AS "22",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 23 THEN cant_devueltos END),0) AS "23",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 24 THEN cant_devueltos END),0) AS "24",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 25 THEN cant_devueltos END),0) AS "25",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 26 THEN cant_devueltos END),0) AS "26",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 27 THEN cant_devueltos END),0) AS "27",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 28 THEN cant_devueltos END),0) AS "28",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 29 THEN cant_devueltos END),0) AS "29",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 30 THEN cant_devueltos END),0) AS "30",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 31 THEN cant_devueltos END),0) AS "31",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes1",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes2",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = @MES THEN cant_devueltos END),0) AS "mes3"	
 
FROM #DEVUELTOS2
WHERE producto = 'PLD'
-----------------------------------------------------------------------------------------
INSERT INTO #TC
SELECT 'TC' as producto,'Expedientes Reprocesos(total)' as descripcion,
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 1 THEN cant_devueltos END),0) AS "01",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 2 THEN cant_devueltos END),0) AS "02",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 3 THEN cant_devueltos END),0) AS "03",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 4 THEN cant_devueltos END),0) AS "04",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 5 THEN cant_devueltos END),0) AS "05",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 6 THEN cant_devueltos END),0) AS "06",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 7 THEN cant_devueltos END),0) AS "07",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 8 THEN cant_devueltos END),0) AS "08",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 9 THEN cant_devueltos END),0) AS "09",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 10  THEN cant_devueltos END),0) AS "10",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 11 THEN cant_devueltos END),0) AS "11",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 12 THEN cant_devueltos END),0) AS "12",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 13 THEN cant_devueltos END),0) AS "13",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 14 THEN cant_devueltos END),0) AS "14",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 15 THEN cant_devueltos END),0) AS "15",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 16 THEN cant_devueltos END),0) AS "16",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 17 THEN cant_devueltos END),0) AS "17",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 18 THEN cant_devueltos END),0) AS "18",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 19 THEN cant_devueltos END),0) AS "19",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 20 THEN cant_devueltos END),0) AS "20",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 21 THEN cant_devueltos END),0) AS "21",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 22 THEN cant_devueltos END),0) AS "22",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 23 THEN cant_devueltos END),0) AS "23",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 24 THEN cant_devueltos END),0) AS "24",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 25 THEN cant_devueltos END),0) AS "25",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 26 THEN cant_devueltos END),0) AS "26",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 27 THEN cant_devueltos END),0) AS "27",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 28 THEN cant_devueltos END),0) AS "28",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 29 THEN cant_devueltos END),0) AS "29",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 30 THEN cant_devueltos END),0) AS "30",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 31 THEN cant_devueltos END),0) AS "31",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes1",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes2",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = @MES THEN cant_devueltos END),0) AS "mes3"	
 
FROM #DEVUELTOS
WHERE producto = 'TC' AND estado_actual IN ('DEVUELTO A FV','DEVUELTO POR CPM')

UNION ALL

SELECT 'TC' as producto , 'Expedientes Procesados' as descripcion,
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 1 THEN cant_devueltos END),0) AS "01",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 2 THEN cant_devueltos END),0) AS "02",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 3 THEN cant_devueltos END),0) AS "03",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 4 THEN cant_devueltos END),0) AS "04",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 5 THEN cant_devueltos END),0) AS "05",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 6 THEN cant_devueltos END),0) AS "06",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 7 THEN cant_devueltos END),0) AS "07",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 8 THEN cant_devueltos END),0) AS "08",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 9 THEN cant_devueltos END),0) AS "09",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 10  THEN cant_devueltos END),0) AS "10",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 11 THEN cant_devueltos END),0) AS "11",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 12 THEN cant_devueltos END),0) AS "12",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 13 THEN cant_devueltos END),0) AS "13",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 14 THEN cant_devueltos END),0) AS "14",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 15 THEN cant_devueltos END),0) AS "15",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 16 THEN cant_devueltos END),0) AS "16",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 17 THEN cant_devueltos END),0) AS "17",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 18 THEN cant_devueltos END),0) AS "18",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 19 THEN cant_devueltos END),0) AS "19",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 20 THEN cant_devueltos END),0) AS "20",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 21 THEN cant_devueltos END),0) AS "21",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 22 THEN cant_devueltos END),0) AS "22",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 23 THEN cant_devueltos END),0) AS "23",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 24 THEN cant_devueltos END),0) AS "24",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 25 THEN cant_devueltos END),0) AS "25",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 26 THEN cant_devueltos END),0) AS "26",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 27 THEN cant_devueltos END),0) AS "27",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 28 THEN cant_devueltos END),0) AS "28",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 29 THEN cant_devueltos END),0) AS "29",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 30 THEN cant_devueltos END),0) AS "30",
 IsNull(SUM (CASE  WHEN  DAY (fecha_estado) = 31 THEN cant_devueltos END),0) AS "31",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes1",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) THEN cant_devueltos END),0) AS "mes2",
 IsNull(SUM (CASE  WHEN  MONTH (fecha_estado) = @MES THEN cant_devueltos END),0) AS "mes3"	
 
FROM #DEVUELTOS2
WHERE producto = 'TC'

-------------------------------------------/// % DE REPROCESOS AL TABLERO DEL RESUMEN
INSERT INTO PLD_TC_CONVENIO
SELECT  'PRESTAMO DE LIBRE DISPONIBILIDAD' AS PRODUCTO,
		 'PORCENTAJE REPROCESOS FUVEX' AS DESCRIPCION,
		 10 AS VO,
		@FECHA_FIN AS fecha_proceso,
		CAST(a.dia1/ISNULL(NULLIF(b.dia1,0),1) * 100 as decimal(18,2)) AS  '01', 
		CAST(a.dia2/ISNULL(NULLIF(b.dia2,0),1) * 100 as decimal(18,2)) AS '02', 
		CAST(a.dia3/ISNULL(NULLIF(b.dia3,0),1) * 100 as decimal(18,2)) AS '03',
		CAST(a.dia4/ISNULL(NULLIF(b.dia4,0),1) * 100 as decimal(18,2)) AS '04',
		CAST(a.dia5/ISNULL(NULLIF(b.dia5,0),1) * 100 as decimal(18,2)) AS '05',
		CAST(a.dia6/ISNULL(NULLIF(b.dia6,0),1) * 100 as decimal(18,2)) AS '06',
		CAST(a.dia7/ISNULL(NULLIF(b.dia7,0),1) * 100 as decimal(18,2)) AS '07',
		CAST(a.dia8/ISNULL(NULLIF(b.dia8,0),1) * 100 as decimal(18,2)) AS '08',
		CAST(a.dia9/ISNULL(NULLIF(b.dia9,0),1) * 100 as decimal(18,2)) AS '09',
		CAST(a.dia10/ISNULL(NULLIF(b.dia10,0),1) * 100 as decimal(18,2)) AS '10',
		CAST(a.dia11/ISNULL(NULLIF(b.dia11,0),1) * 100 as decimal(18,2)) AS '11',
		CAST(a.dia12/ISNULL(NULLIF(b.dia12,0),1) * 100 as decimal(18,2)) AS '12',
		CAST(a.dia13/ISNULL(NULLIF(b.dia13,0),1) * 100 as decimal(18,2)) AS '13',
		CAST(a.dia14/ISNULL(NULLIF(b.dia14,0),1) * 100 as decimal(18,2)) AS '14',
		CAST(a.dia15/ISNULL(NULLIF(b.dia15,0),1) * 100 as decimal(18,2)) AS '15',
		CAST(a.dia16/ISNULL(NULLIF(b.dia16,0),1) * 100 as decimal(18,2)) AS '16',
		CAST(a.dia17/ISNULL(NULLIF(b.dia17,0),1) * 100 as decimal(18,2)) AS '17',
		CAST(a.dia18/ISNULL(NULLIF(b.dia18,0),1) * 100 as decimal(18,2)) AS '18',
		CAST(a.dia19/ISNULL(NULLIF(b.dia19,0),1) * 100 as decimal(18,2)) AS '19',
		CAST(a.dia20/ISNULL(NULLIF(b.dia20,0),1) * 100 as decimal(18,2)) AS '20',
		CAST(a.dia21/ISNULL(NULLIF(b.dia21,0),1) * 100 as decimal(18,2)) AS '21',
		CAST(a.dia22/ISNULL(NULLIF(b.dia22,0),1) * 100 as decimal(18,2)) AS '22',
		CAST(a.dia23/ISNULL(NULLIF(b.dia23,0),1) * 100 as decimal(18,2)) AS '23',
		CAST(a.dia24/ISNULL(NULLIF(b.dia24,0),1) * 100 as decimal(18,2)) AS '24',
		CAST(a.dia25/ISNULL(NULLIF(b.dia25,0),1) * 100 as decimal(18,2)) AS '25',
		CAST(a.dia26/ISNULL(NULLIF(b.dia26,0),1) * 100 as decimal(18,2)) AS '26',
		CAST(a.dia27/ISNULL(NULLIF(b.dia27,0),1) * 100 as decimal(18,2)) AS '27',
		CAST(a.dia28/ISNULL(NULLIF(b.dia28,0),1) * 100 as decimal(18,2)) AS '28',
		CAST(a.dia29/ISNULL(NULLIF(b.dia29,0),1) * 100 as decimal(18,2)) AS '29',
		CAST(a.dia30/ISNULL(NULLIF(b.dia30,0),1) * 100 as decimal(18,2)) AS '30',
		CAST(a.dia31/ISNULL(NULLIF(b.dia31,0),1) * 100 as decimal(18,2)) AS '31',
		CAST(a.mes1/ISNULL(NULLIF(b.mes1,0),1) * 100 as decimal(18,2)) AS 'mes1',
		CAST(a.mes2/ISNULL(NULLIF(b.mes2,0),1) * 100 as decimal(18,2)) AS 'mes2',
		CAST(a.mes3/ISNULL(NULLIF(b.mes3,0),1) * 100 as decimal(18,2)) AS 'mes3'

		FROM #PLD a LEFT JOIN #PLD b
		ON a.codigo = 1	WHERE b.codigo = 2


		UNION ALL


SELECT  'TARJETA DE CREDITO' AS PRODUCTO,
		 'PORCENTAJE REPROCESOS FUVEX' AS DESCRIPCION,
		 10 AS VO,
		@FECHA_FIN AS fecha_proceso,
		CAST(a.dia1/ISNULL(NULLIF(b.dia1,0),1) * 100 as decimal(18,2)) AS  '01', 
		CAST(a.dia2/ISNULL(NULLIF(b.dia2,0),1) * 100 as decimal(18,2)) AS '02', 
		CAST(a.dia3/ISNULL(NULLIF(b.dia3,0),1) * 100 as decimal(18,2)) AS '03',
		CAST(a.dia4/ISNULL(NULLIF(b.dia4,0),1) * 100 as decimal(18,2)) AS '04',
		CAST(a.dia5/ISNULL(NULLIF(b.dia5,0),1) * 100 as decimal(18,2)) AS '05',
		CAST(a.dia6/ISNULL(NULLIF(b.dia6,0),1) * 100 as decimal(18,2)) AS '06',
		CAST(a.dia7/ISNULL(NULLIF(b.dia7,0),1) * 100 as decimal(18,2)) AS '07',
		CAST(a.dia8/ISNULL(NULLIF(b.dia8,0),1) * 100 as decimal(18,2)) AS '08',
		CAST(a.dia9/ISNULL(NULLIF(b.dia9,0),1) * 100 as decimal(18,2)) AS '09',
		CAST(a.dia10/ISNULL(NULLIF(b.dia10,0),1) * 100 as decimal(18,2)) AS '10',
		CAST(a.dia11/ISNULL(NULLIF(b.dia11,0),1) * 100 as decimal(18,2)) AS '11',
		CAST(a.dia12/ISNULL(NULLIF(b.dia12,0),1) * 100 as decimal(18,2)) AS '12',
		CAST(a.dia13/ISNULL(NULLIF(b.dia13,0),1) * 100 as decimal(18,2)) AS '13',
		CAST(a.dia14/ISNULL(NULLIF(b.dia14,0),1) * 100 as decimal(18,2)) AS '14',
		CAST(a.dia15/ISNULL(NULLIF(b.dia15,0),1) * 100 as decimal(18,2)) AS '15',
		CAST(a.dia16/ISNULL(NULLIF(b.dia16,0),1) * 100 as decimal(18,2)) AS '16',
		CAST(a.dia17/ISNULL(NULLIF(b.dia17,0),1) * 100 as decimal(18,2)) AS '17',
		CAST(a.dia18/ISNULL(NULLIF(b.dia18,0),1) * 100 as decimal(18,2)) AS '18',
		CAST(a.dia19/ISNULL(NULLIF(b.dia19,0),1) * 100 as decimal(18,2)) AS '19',
		CAST(a.dia20/ISNULL(NULLIF(b.dia20,0),1) * 100 as decimal(18,2)) AS '20',
		CAST(a.dia21/ISNULL(NULLIF(b.dia21,0),1) * 100 as decimal(18,2)) AS '21',
		CAST(a.dia22/ISNULL(NULLIF(b.dia22,0),1) * 100 as decimal(18,2)) AS '22',
		CAST(a.dia23/ISNULL(NULLIF(b.dia23,0),1) * 100 as decimal(18,2)) AS '23',
		CAST(a.dia24/ISNULL(NULLIF(b.dia24,0),1) * 100 as decimal(18,2)) AS '24',
		CAST(a.dia25/ISNULL(NULLIF(b.dia25,0),1) * 100 as decimal(18,2)) AS '25',
		CAST(a.dia26/ISNULL(NULLIF(b.dia26,0),1) * 100 as decimal(18,2)) AS '26',
		CAST(a.dia27/ISNULL(NULLIF(b.dia27,0),1) * 100 as decimal(18,2)) AS '27',
		CAST(a.dia28/ISNULL(NULLIF(b.dia28,0),1) * 100 as decimal(18,2)) AS '28',
		CAST(a.dia29/ISNULL(NULLIF(b.dia29,0),1) * 100 as decimal(18,2)) AS '29',
		CAST(a.dia30/ISNULL(NULLIF(b.dia30,0),1) * 100 as decimal(18,2)) AS '30',
		CAST(a.dia31/ISNULL(NULLIF(b.dia31,0),1) * 100 as decimal(18,2)) AS '31',
		CAST(a.mes1/ISNULL(NULLIF(b.mes1,0),1) * 100 as decimal(18,2)) AS 'mes1',
		CAST(a.mes2/ISNULL(NULLIF(b.mes2,0),1) * 100 as decimal(18,2)) AS 'mes2',
		CAST(a.mes3/ISNULL(NULLIF(b.mes3,0),1) * 100 as decimal(18,2)) AS 'mes3'		

		FROM #TC a LEFT JOIN #TC b
		ON a.codigo = 1	WHERE b.codigo = 2		

END

IF @TIPO = 'INGRESADOS'

BEGIN


--INSERT INTO #INGRESADOS
SELECT 'TC' AS 'PRODUCTO' , FECHA_DE_REGISTRO, ESTADO_ACTUAL, COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS FROM TB_FUVEX
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) =  @MES
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = @AÑO
AND PRODUCTO = 'TARJETAS' 
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM','RECHAZADO')
GROUP BY FECHA_DE_REGISTRO, ESTADO_ACTUAL

union all

SELECT 'PLD' , FU.FECHA_DE_REGISTRO,FU.ESTADO_ACTUAL,COUNT(NRO_DE_SOLICITUD) AS DEVUELTOS FROM TB_FUVEX AS FU
INNER JOIN TB_FUVEX_SUBPRODUCTO AS SU
ON FU.COD_SUB_PRODUCTO=SU.CODIGO
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) =  @MES
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = @AÑO
AND SU.TIPO = 'PLD'
AND ESTADO_ACTUAL IN ('DEVUELTO A FV','DEVUELTO POR CPM', 'RECHAZADO')
GROUP BY FECHA_DE_REGISTRO,FU.ESTADO_ACTUAL
ORDER BY 2,1,3


----select * from #INGRESADOS order by fecha_registro

END

END

GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_FUNNEL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 24/08/2020
-- Description:	Replica para sacar el Funnel DE fuvex
-- =============================================
CREATE PROCEDURE  [dbo].[USP_TB_FUVEX_FUNNEL] (
@MES INT,
@AÑO INT,
@PRODUCTO VARCHAR(20)
)

as

begin

DECLARE @FECHA_FIN DATE;
SET @FECHA_FIN = (SELECT CONVERT(DATE,MAX(FECHA_HORA_ENVIO)) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)


IF @PRODUCTO = 'TC'
BEGIN

DELETE FROM TB_FUVEX_FUNNEL
WHERE FECHA_PROCESO = @FECHA_FIN
AND PRODUCTO = 'TC'

INSERT INTO TB_FUVEX_FUNNEL

SELECT @PRODUCTO ,'INGRESADOS', count (producto),@FECHA_FIN
  FROM TB_FUVEX 
  where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 

  AND PRODUCTO = 'TARJETAS'

UNION ALL

 SELECT @PRODUCTO ,'RECHAZADOS', count (producto),@FECHA_FIN
  FROM TB_FUVEX 
   where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 
  AND ESTADO_ACTUAL = 'RECHAZADO'
  AND PRODUCTO = 'TARJETAS'

  UNION ALL

SELECT @PRODUCTO ,'EN TRANSITO', count (producto),@FECHA_FIN
   FROM TB_FUVEX
  where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 
  AND ESTADO_ACTUAL! = 'REGISTRADO' and ESTADO_ACTUAL! = 'FORMALIZADO' and ESTADO_ACTUAL! = 'RECHAZADO'
  and PRODUCTO = 'TARJETAS'

  UNION ALL


--  SELECT 'FINALIZADOS', count (producto)
--  FROM TB_FUVEX
--  where CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
--  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
--  AND ESTADO_ACTUAL = 'FORMALIZADO' AND PRODUCTO = 'TARJETAS'

  --MODIFICACION 20/09/2019
SELECT @PRODUCTO ,'FINALIZADOS', count (producto) ,@FECHA_FIN  
  FROM TB_FUVEX
  where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 
  AND CONVERT(date,FECHA_DE_ESTADO) <= @FECHA_FIN 
  AND ESTADO_ACTUAL = 'FORMALIZADO' AND PRODUCTO = 'TARJETAS'
  END
 
 IF @PRODUCTO = 'PLD'
 BEGIN

DELETE FROM TB_FUVEX_FUNNEL
WHERE FECHA_PROCESO = @FECHA_FIN
AND PRODUCTO = 'PLD'

 INSERT INTO TB_FUVEX_FUNNEL

SELECT @PRODUCTO ,'INGRESADOS', count (producto),@FECHA_FIN
  FROM TB_FUVEX F
  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
  where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 
  and FS.TIPO = 'PLD'

UNION ALL

 SELECT @PRODUCTO ,'RECHAZADOS', count (producto),@FECHA_FIN
  FROM TB_FUVEX F
  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
  where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 
  AND ESTADO_ACTUAL = 'RECHAZADO'
  AND FS.TIPO = 'PLD'

  UNION ALL

SELECT @PRODUCTO ,'EN TRANSITO', count (producto),@FECHA_FIN
   FROM TB_FUVEX F
  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
  where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 
  AND ESTADO_ACTUAL! = 'REGISTRADO' and ESTADO_ACTUAL! = 'FORMALIZADO' and ESTADO_ACTUAL! = 'RECHAZADO'
  and FS.TIPO = 'PLD'

  UNION ALL

SELECT @PRODUCTO ,'FINALIZADOS', count (producto),@FECHA_FIN
  FROM TB_FUVEX F
  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
  where month(FECHA_DE_REGISTRO) = @MES
  AND YEAR(FECHA_DE_REGISTRO) = @AÑO 
  AND ESTADO_ACTUAL = 'FORMALIZADO' 
  AND FS.TIPO = 'PLD'
  

  END

  ----------------------------------DETALLE--------------------------------------------

----IF @PRODUCTO = 'TC'

----SELECT 'INGRESADOS', NRO_DE_SOLICITUD, (producto), FUERZA_DE_VENTA
----  FROM TB_FUVEX 
----  where CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 

----  AND PRODUCTO = 'TARJETAS'

----UNION ALL

---- SELECT 'RECHAZADOS', NRO_DE_SOLICITUD, (producto), FUERZA_DE_VENTA
----  FROM TB_FUVEX 
----  where CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
----  AND ESTADO_ACTUAL = 'RECHAZADO'
----  AND PRODUCTO = 'TARJETAS'

----  UNION ALL

----SELECT 'EN TRANSITO', NRO_DE_SOLICITUD,  (producto), FUERZA_DE_VENTA
----   FROM TB_FUVEX
----  where CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
----  AND ESTADO_ACTUAL! = 'REGISTRADO' and ESTADO_ACTUAL! = 'FORMALIZADO' and ESTADO_ACTUAL! = 'RECHAZADO'
----  and PRODUCTO = 'TARJETAS'

----  UNION ALL

----SELECT 'FINALIZADOS', NRO_DE_SOLICITUD,  (producto), FUERZA_DE_VENTA
----  FROM TB_FUVEX
----  where CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
----  AND ESTADO_ACTUAL = 'FORMALIZADO' AND PRODUCTO = 'TARJETAS'

----  IF @PRODUCTO = 'PLD'

----SELECT 'INGRESADOS', NRO_DE_SOLICITUD,  (producto), FUERZA_DE_VENTA
----  FROM TB_FUVEX F
----  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
----  where 
----  CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
----  and FS.TIPO = 'PLD'

----UNION ALL

---- SELECT 'RECHAZADOS', NRO_DE_SOLICITUD,  (producto), FUERZA_DE_VENTA
----  FROM TB_FUVEX F
----  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
----  where 
----  CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
----  AND ESTADO_ACTUAL = 'RECHAZADO'
----  AND FS.TIPO = 'PLD'

----  UNION ALL

----SELECT 'EN TRANSITO', NRO_DE_SOLICITUD,  (producto), FUERZA_DE_VENTA
----   FROM TB_FUVEX F
----  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
----  where 
----  CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
----  AND ESTADO_ACTUAL! = 'REGISTRADO' and ESTADO_ACTUAL! = 'FORMALIZADO' and ESTADO_ACTUAL! = 'RECHAZADO'
----  and FS.TIPO = 'PLD'

----  UNION ALL

----SELECT 'FINALIZADOS', NRO_DE_SOLICITUD,  (producto), FUERZA_DE_VENTA
----  FROM TB_FUVEX F
----  inner join TB_FUVEX_SUBPRODUCTO FS on F.COD_SUB_PRODUCTO = FS.CODIGO
----  where
----  CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO 
----  AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECHA_FIN 
----  AND ESTADO_ACTUAL = 'FORMALIZADO' 
----  AND FS.TIPO = 'PLD'


END ---- >> END FINAL

GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_FUNNEL_ACUMULADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_TB_FUVEX_FUNNEL_ACUMULADO] (
@MES INT,
@AÑO INT,
@PRODUCTO VARCHAR(50)
)

as

begin

DECLARE @COUNT INT = 1;
DECLARE @COUNTMAX INT;
DECLARE @FECFINWHILE DATE;

DECLARE @FECHA_INICIO DATE;
DECLARE @FECHA_FIN DATE;

--------------------------------------------////
DECLARE @TC_ING_ACUMULADO_M1 INT;
DECLARE @TC_ING_ACUMULADO_M2 INT;

DECLARE @TC_FINALIZADOS_M1 INT;
DECLARE @TC_FINALIZADOS_M2 INT;
--------------------------------------------////
DECLARE @PLD_ING_ACUMULADO_M1 INT;
DECLARE @PLD_ING_ACUMULADO_M2 INT;

DECLARE @PLD_FINALIZADOS_M1 INT;
DECLARE @PLD_FINALIZADOS_M2 INT;



SET @FECHA_INICIO = (SELECT DATEFROMPARTS (@AÑO , @MES , 01))
SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) 
					FROM TB_CS 
					WHERE MONTH(FECHA_HORA_ENVIO) = @MES	
					AND YEAR(FECHA_HORA_ENVIO) = @AÑO)



-------------------------------------------------------->>>>> PLD
SET @PLD_FINALIZADOS_M1 = (SELECT COUNT(PRODUCTO)
							FROM TB_FUVEX F  INNER JOIN TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) 
							AND YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN))
							AND ESTADO_ACTUAL = 'FORMALIZADO' 
							AND FS.TIPO = 'PLD')

SET @PLD_FINALIZADOS_M2 = (SELECT COUNT(PRODUCTO)
							FROM TB_FUVEX F  INNER JOIN TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) 
							AND YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN))
							AND ESTADO_ACTUAL = 'FORMALIZADO' 
							AND FS.TIPO = 'PLD')
---------------------------------------------
SET @PLD_ING_ACUMULADO_M1  = (SELECT COUNT(NRO_DE_SOLICITUD)
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE 
							MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) and
							YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) 		
							AND  FS.TIPO = 'PLD'
							GROUP BY F.PRODUCTO)

SET @PLD_ING_ACUMULADO_M2  = (SELECT COUNT(NRO_DE_SOLICITUD)
							FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
							ON F.COD_SUB_PRODUCTO = FS.CODIGO
							WHERE 
							MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) and
							YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) 		
							AND  FS.TIPO = 'PLD'
							GROUP BY F.PRODUCTO)

-------------------------------------------------------->>>>> TARJETA DE CREDITO

SET @TC_ING_ACUMULADO_M1 =(SELECT COUNT(NRO_DE_SOLICITUD)
						FROM TB_FUVEX 
						WHERE 
						MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN)) and
						YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) 		
						AND PRODUCTO = 'TARJETAS' 
						GROUP BY PRODUCTO)

SET @TC_ING_ACUMULADO_M2 =(SELECT COUNT(NRO_DE_SOLICITUD)
						FROM TB_FUVEX 
						WHERE 
						MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN)) and
						YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) 		
						AND PRODUCTO = 'TARJETAS' 
						GROUP BY PRODUCTO)

------------------------------------------------------------
SET @TC_FINALIZADOS_M1 = (SELECT count(producto)
						FROM TB_FUVEX
						WHERE MONTH(FECHA_DE_REGISTRO) = MONTH(DATEADD(MONTH, -2, @FECHA_FIN))  
						AND YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -2, @FECHA_FIN)) 
						AND ESTADO_ACTUAL = 'FORMALIZADO' AND PRODUCTO = 'TARJETAS')

SET @TC_FINALIZADOS_M2 =(SELECT count(producto)
						FROM TB_FUVEX
						WHERE MONTH(FECHA_DE_REGISTRO) = MONTH(DATEADD(MONTH, -1, @FECHA_FIN))  
						AND YEAR(FECHA_DE_REGISTRO) = YEAR(DATEADD(MONTH, -1, @FECHA_FIN)) 
						AND ESTADO_ACTUAL = 'FORMALIZADO' AND PRODUCTO = 'TARJETAS')



CREATE TABLE #FECHASWHILE
(	codigo int identity(1,1) not null,			
	fecha date)

CREATE TABLE #FINALIZADOS_PLD
(
	codigo int identity(1,1) not null,		
	estado_actual varchar(100),	
	cantidad int,
	fechafin date,
)

CREATE TABLE #PLD(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](50) NULL,
	[descripcion_estado] [varchar](50) NULL,	
	[dia1] [decimal](10,2) NULL,
	[dia2] [decimal](10,2) NULL,
	[dia3] [decimal](10,2) NULL,
	[dia4] [decimal](10,2) NULL,
	[dia5] [decimal](10,2) NULL,
	[dia6] [decimal](10,2) NULL,
	[dia7] [decimal](10,2) NULL,
	[dia8] [decimal](10,2) NULL,
	[dia9] [decimal](10,2) NULL,
	[dia10] [decimal](10,2) NULL,
	[dia11] [decimal](10,2) NULL,
	[dia12] [decimal](10,2) NULL,
	[dia13] [decimal](10,2) NULL,
	[dia14] [decimal](10,2) NULL,
	[dia15] [decimal](10,2) NULL,
	[dia16] [decimal](10,2) NULL,
	[dia17] [decimal](10,2) NULL,
	[dia18] [decimal](10,2) NULL,
	[dia19] [decimal](10,2) NULL,
	[dia20] [decimal](10,2) NULL,
	[dia21] [decimal](10,2) NULL,
	[dia22] [decimal](10,2) NULL,
	[dia23] [decimal](10,2) NULL,
	[dia24] [decimal](10,2) NULL,
	[dia25] [decimal](10,2) NULL,
	[dia26] [decimal](10,2) NULL,
	[dia27] [decimal](10,2) NULL,
	[dia28] [decimal](10,2) NULL,
	[dia29] [decimal](10,2) NULL,
	[dia30] [decimal](10,2) NULL,
	[dia31] [decimal](10,2) NULL,
	[mes1] [decimal](10,2) NULL,		
	[mes2] [decimal](10,2) NULL,
	[mes3] [decimal](10,2) NULL
)


CREATE TABLE #FINALIZADOS_TC
(	codigo int identity(1,1) not null,		
	estado_actual varchar(100),	
	cantidad int,
	fechafin date,)

CREATE TABLE #TC(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](50) NULL,
	[descripcion_estado] [varchar](50) NULL,	
	[dia1] [decimal](10,2) NULL,
	[dia2] [decimal](10,2) NULL,
	[dia3] [decimal](10,2) NULL,
	[dia4] [decimal](10,2) NULL,
	[dia5] [decimal](10,2) NULL,
	[dia6] [decimal](10,2) NULL,
	[dia7] [decimal](10,2) NULL,
	[dia8] [decimal](10,2) NULL,
	[dia9] [decimal](10,2) NULL,
	[dia10] [decimal](10,2) NULL,
	[dia11] [decimal](10,2) NULL,
	[dia12] [decimal](10,2) NULL,
	[dia13] [decimal](10,2) NULL,
	[dia14] [decimal](10,2) NULL,
	[dia15] [decimal](10,2) NULL,
	[dia16] [decimal](10,2) NULL,
	[dia17] [decimal](10,2) NULL,
	[dia18] [decimal](10,2) NULL,
	[dia19] [decimal](10,2) NULL,
	[dia20] [decimal](10,2) NULL,
	[dia21] [decimal](10,2) NULL,
	[dia22] [decimal](10,2) NULL,
	[dia23] [decimal](10,2) NULL,
	[dia24] [decimal](10,2) NULL,
	[dia25] [decimal](10,2) NULL,
	[dia26] [decimal](10,2) NULL,
	[dia27] [decimal](10,2) NULL,
	[dia28] [decimal](10,2) NULL,
	[dia29] [decimal](10,2) NULL,
	[dia30] [decimal](10,2) NULL,
	[dia31] [decimal](10,2) NULL,
	[mes1] [decimal](10,2) NULL,		
	[mes2] [decimal](10,2) NULL,
	[mes3] [decimal](10,2) NULL	
)				


INSERT INTO #FECHASWHILE
SELECT DISTINCT FECHA_DE_ESTADO
FROM TB_FUVEX
WHERE FECHA_DE_ESTADO <= @FECHA_FIN
ORDER BY FECHA_DE_ESTADO


SET @COUNTMAX = (SELECT COUNT(codigo) FROM #FECHASWHILE);

IF @PRODUCTO = 'TC'

BEGIN


----------------------------------------------------------//REPROCESO
DELETE FROM PLD_TC_CONVENIO 
WHERE descripcion = 'PORCENTAJE EN LA FORMALIZACION FUNNEL'
and producto = 'TARJETA DE CREDITO'
AND fecha_proceso = @FECHA_FIN
----------------------------------------------------------//REPROCESO


WHILE @COUNT <= @COUNTMAX
BEGIN 	
	SET @FECFINWHILE = (SELECT fecha FROM #FECHASWHILE WHERE codigo = @COUNT)

	INSERT INTO #FINALIZADOS_TC
	SELECT 'FINALIZADOS', count (producto), @FECFINWHILE
	FROM TB_FUVEX
	where CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO
	AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECFINWHILE
	AND CONVERT(DATE,FECHA_DE_ESTADO) <= @FECFINWHILE
	AND ESTADO_ACTUAL = 'FORMALIZADO' AND PRODUCTO = 'TARJETAS'
  

  	SET @COUNT = @COUNT + 1;
 END

  
 INSERT INTO #TC
 SELECT 'TC' as producto,'Expedientes Desembolsados(Funnel)' as descripcion,
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 1 THEN cantidad END),0) AS "01",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 2 THEN cantidad END),0) AS "02",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 3 THEN cantidad END),0) AS "03",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 4 THEN cantidad END),0) AS "04",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 5 THEN cantidad END),0) AS "05",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 6 THEN cantidad END),0) AS "06",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 7 THEN cantidad END),0) AS "07",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 8 THEN cantidad END),0) AS "08",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 9 THEN cantidad END),0) AS "09",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 10 THEN cantidad END),0) AS "10",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 11 THEN cantidad END),0) AS "11",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 12 THEN cantidad END),0) AS "12",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 13 THEN cantidad END),0) AS "13",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 14 THEN cantidad END),0) AS "14",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 15 THEN cantidad END),0) AS "15",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 16 THEN cantidad END),0) AS "16",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 17 THEN cantidad END),0) AS "17",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 18 THEN cantidad END),0) AS "18",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 19 THEN cantidad END),0) AS "19",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 20 THEN cantidad END),0) AS "20",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 21 THEN cantidad END),0) AS "21",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 22 THEN cantidad END),0) AS "22",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 23 THEN cantidad END),0) AS "23",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 24 THEN cantidad END),0) AS "24",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 25 THEN cantidad END),0) AS "25",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 26 THEN cantidad END),0) AS "26",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 27 THEN cantidad END),0) AS "27",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 28 THEN cantidad END),0) AS "28",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 29 THEN cantidad END),0) AS "29",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 30 THEN cantidad END),0) AS "30",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 31 THEN cantidad END),0) AS "31",	
 IsNull(@TC_FINALIZADOS_M1,0) AS "mes1",
 IsNull(@TC_FINALIZADOS_M2,0) AS "mes2",
 IsNull(SUM (CASE  WHEN  fechafin = @FECHA_FIN THEN cantidad END),0) AS "mes3" 
FROM #FINALIZADOS_TC

UNION ALL

 SELECT 'TC' as producto,'Expedientes Ingresados (Acumulado)' as descripcion,
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 1 THEN 1 END),0) AS dia1,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 2 THEN 1 END),0) AS dia2,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 3 THEN 1 END),0) AS dia3,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 4  THEN 1 END),0) AS dia4,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 5  THEN 1 END),0) AS dia5,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 6  THEN 1 END),0) AS dia6,
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 7  THEN 1 END),0) AS dia7,
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 8  THEN 1 END),0) AS dia8,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 9  THEN 1 END),0) AS dia9,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 10  THEN 1 END),0) AS dia10,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 11  THEN 1 END),0) AS dia11,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 12  THEN 1 END),0) AS dia12,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 13  THEN 1 END),0) AS dia13,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 14  THEN 1 END),0) AS dia14,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 15  THEN 1 END),0) AS dia15,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 16  THEN 1 END),0) AS dia16,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 17  THEN 1 END),0) AS dia17,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 18  THEN 1 END),0) AS dia18,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 19  THEN 1 END),0) AS dia19,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 20  THEN 1 END),0) AS dia20,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 21  THEN 1 END),0) AS dia21,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 22  THEN 1 END),0) AS dia22,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 23  THEN 1 END),0) AS dia23,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 24  THEN 1 END),0) AS dia24,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 25  THEN 1 END),0) AS dia25,
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 26  THEN 1 END),0) AS dia26,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 27  THEN 1 END),0) AS dia27,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 28  THEN 1 END),0) AS dia28,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 29  THEN 1 END),0) AS dia29,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 30  THEN 1 END),0) AS dia30,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 31  THEN 1 END),0) AS dia31,

IsNull(@TC_ING_ACUMULADO_M1,0) AS mes1,
IsNull(@TC_ING_ACUMULADO_M2,0) AS mes2,
IsNull(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3			
						
FROM TB_FUVEX 
WHERE 
MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 		
AND PRODUCTO = 'TARJETAS' 
GROUP BY PRODUCTO
		
------------------------SELECT * FROM #TC

------------------------------------- // PORCENTAJE FORMALIZACION DE OPERACIONES EN EL FUNNEL (TABLERO DEL RESUMEN)
INSERT INTO PLD_TC_CONVENIO 
SELECT  'TARJETA DE CREDITO' AS PRODUCTO,
		 'PORCENTAJE EN LA FORMALIZACION FUNNEL' AS DESCRIPCION,
		 70 AS VO,
		@FECHA_FIN AS fecha_proceso,
		CAST(a.dia1/ISNULL(NULLIF(b.dia1,0),1) * 100 as decimal(18,2)) AS  '01', 
		CAST(a.dia2/ISNULL(NULLIF(b.dia2,0),1) * 100 as decimal(18,2)) AS '02', 
		CAST(a.dia3/ISNULL(NULLIF(b.dia3,0),1) * 100 as decimal(18,2)) AS '03',
		CAST(a.dia4/ISNULL(NULLIF(b.dia4,0),1) * 100 as decimal(18,2)) AS '04',
		CAST(a.dia5/ISNULL(NULLIF(b.dia5,0),1) * 100 as decimal(18,2)) AS '05',
		CAST(a.dia6/ISNULL(NULLIF(b.dia6,0),1) * 100 as decimal(18,2)) AS '06',
		CAST(a.dia7/ISNULL(NULLIF(b.dia7,0),1) * 100 as decimal(18,2)) AS '07',
		CAST(a.dia8/ISNULL(NULLIF(b.dia8,0),1) * 100 as decimal(18,2)) AS '08',
		CAST(a.dia9/ISNULL(NULLIF(b.dia9,0),1) * 100 as decimal(18,2)) AS '09',
		CAST(a.dia10/ISNULL(NULLIF(b.dia10,0),1) * 100 as decimal(18,2)) AS '10',
		CAST(a.dia11/ISNULL(NULLIF(b.dia11,0),1) * 100 as decimal(18,2)) AS '11',
		CAST(a.dia12/ISNULL(NULLIF(b.dia12,0),1) * 100 as decimal(18,2)) AS '12',
		CAST(a.dia13/ISNULL(NULLIF(b.dia13,0),1) * 100 as decimal(18,2)) AS '13',
		CAST(a.dia14/ISNULL(NULLIF(b.dia14,0),1) * 100 as decimal(18,2)) AS '14',
		CAST(a.dia15/ISNULL(NULLIF(b.dia15,0),1) * 100 as decimal(18,2)) AS '15',
		CAST(a.dia16/ISNULL(NULLIF(b.dia16,0),1) * 100 as decimal(18,2)) AS '16',
		CAST(a.dia17/ISNULL(NULLIF(b.dia17,0),1) * 100 as decimal(18,2)) AS '17',
		CAST(a.dia18/ISNULL(NULLIF(b.dia18,0),1) * 100 as decimal(18,2)) AS '18',
		CAST(a.dia19/ISNULL(NULLIF(b.dia19,0),1) * 100 as decimal(18,2)) AS '19',
		CAST(a.dia20/ISNULL(NULLIF(b.dia20,0),1) * 100 as decimal(18,2)) AS '20',
		CAST(a.dia21/ISNULL(NULLIF(b.dia21,0),1) * 100 as decimal(18,2)) AS '21',
		CAST(a.dia22/ISNULL(NULLIF(b.dia22,0),1) * 100 as decimal(18,2)) AS '22',
		CAST(a.dia23/ISNULL(NULLIF(b.dia23,0),1) * 100 as decimal(18,2)) AS '23',
		CAST(a.dia24/ISNULL(NULLIF(b.dia24,0),1) * 100 as decimal(18,2)) AS '24',
		CAST(a.dia25/ISNULL(NULLIF(b.dia25,0),1) * 100 as decimal(18,2)) AS '25',
		CAST(a.dia26/ISNULL(NULLIF(b.dia26,0),1) * 100 as decimal(18,2)) AS '26',
		CAST(a.dia27/ISNULL(NULLIF(b.dia27,0),1) * 100 as decimal(18,2)) AS '27',
		CAST(a.dia28/ISNULL(NULLIF(b.dia28,0),1) * 100 as decimal(18,2)) AS '28',
		CAST(a.dia29/ISNULL(NULLIF(b.dia29,0),1) * 100 as decimal(18,2)) AS '29',
		CAST(a.dia30/ISNULL(NULLIF(b.dia30,0),1) * 100 as decimal(18,2)) AS '30',
		CAST(a.dia31/ISNULL(NULLIF(b.dia31,0),1) * 100 as decimal(18,2)) AS '31',
		CAST(a.mes1/ISNULL(NULLIF(b.mes1,0),1) * 100 as decimal(18,2)) AS 'mes1',
		CAST(a.mes2/ISNULL(NULLIF(b.mes2,0),1) * 100 as decimal(18,2)) AS 'mes2',
		CAST(a.mes3/ISNULL(NULLIF(b.mes3,0),1) * 100 as decimal(18,2)) AS 'mes3'

		FROM #TC a LEFT JOIN #TC b
		ON a.codigo = 1	WHERE b.codigo = 2



END
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

IF @PRODUCTO = 'PLD'
BEGIN


----------------------------------------------------------//REPROCESO
DELETE FROM PLD_TC_CONVENIO 
WHERE descripcion = 'PORCENTAJE EN LA FORMALIZACION FUNNEL'
and producto = 'PRESTAMO DE LIBRE DISPONIBILIDAD'
AND fecha_proceso = @FECHA_FIN
----------------------------------------------------------//REPROCESO



WHILE @COUNT <= @COUNTMAX
BEGIN 
	
	SET @FECFINWHILE = (SELECT fecha FROM #FECHASWHILE WHERE codigo = @COUNT)


	INSERT INTO #FINALIZADOS_PLD
	SELECT 'FINALIZADOS',  count (producto),@FECFINWHILE
	FROM TB_FUVEX F  INNER JOIN TB_FUVEX_SUBPRODUCTO FS 
	ON F.COD_SUB_PRODUCTO = FS.CODIGO
	WHERE CONVERT(date,FECHA_DE_REGISTRO) >= @FECHA_INICIO
	AND CONVERT(date,FECHA_DE_REGISTRO) <= @FECFINWHILE
	AND CONVERT(date,FECHA_DE_ESTADO) <= @FECFINWHILE
	AND ESTADO_ACTUAL = 'FORMALIZADO' 
	AND FS.TIPO = 'PLD'
	 


	 SET @COUNT = @COUNT + 1;
 END


 

INSERT INTO #PLD
 SELECT 'PLD' as producto,'Expedientes Desembolsados(Funnel)' as descripcion,
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 1 THEN cantidad END),0) AS "01",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 2 THEN cantidad END),0) AS "02",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 3 THEN cantidad END),0) AS "03",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 4 THEN cantidad END),0) AS "04",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 5 THEN cantidad END),0) AS "05",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 6 THEN cantidad END),0) AS "06",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 7 THEN cantidad END),0) AS "07",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 8 THEN cantidad END),0) AS "08",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 9 THEN cantidad END),0) AS "09",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 10 THEN cantidad END),0) AS "10",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 11 THEN cantidad END),0) AS "11",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 12 THEN cantidad END),0) AS "12",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 13 THEN cantidad END),0) AS "13",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 14 THEN cantidad END),0) AS "14",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 15 THEN cantidad END),0) AS "15",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 16 THEN cantidad END),0) AS "16",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 17 THEN cantidad END),0) AS "17",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 18 THEN cantidad END),0) AS "18",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 19 THEN cantidad END),0) AS "19",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 20 THEN cantidad END),0) AS "20",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 21 THEN cantidad END),0) AS "21",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 22 THEN cantidad END),0) AS "22",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 23 THEN cantidad END),0) AS "23",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 24 THEN cantidad END),0) AS "24",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 25 THEN cantidad END),0) AS "25",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 26 THEN cantidad END),0) AS "26",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 27 THEN cantidad END),0) AS "27",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 28 THEN cantidad END),0) AS "28",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 29 THEN cantidad END),0) AS "29",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 30 THEN cantidad END),0) AS "30",
 IsNull(SUM (CASE  WHEN  DAY (fechafin) = 31 THEN cantidad END),0) AS "31",	
 IsNull(@PLD_FINALIZADOS_M1,0) AS "mes1",
 IsNull(@PLD_FINALIZADOS_M2,0) AS "mes2",
 IsNull(SUM(CASE  WHEN (fechafin) = @FECHA_FIN THEN cantidad END),0) AS "mes3" 
FROM #FINALIZADOS_PLD

UNION ALL

SELECT
'PLD' AS producto,'Expedientes Ingresados(Acumulado)' AS descripcion,				
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 1 THEN 1 END),0) AS dia1,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 2 THEN 1 END),0) AS dia2,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 3 THEN 1 END),0) AS dia3,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 4  THEN 1 END),0) AS dia4,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 5  THEN 1 END),0) AS dia5,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 6  THEN 1 END),0) AS dia6,
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 7  THEN 1 END),0) AS dia7,
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 8  THEN 1 END),0) AS dia8,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 9  THEN 1 END),0) AS dia9,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 10  THEN 1 END),0) AS dia10,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 11  THEN 1 END),0) AS dia11,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 12  THEN 1 END),0) AS dia12,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 13  THEN 1 END),0) AS dia13,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 14  THEN 1 END),0) AS dia14,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 15  THEN 1 END),0) AS dia15,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 16  THEN 1 END),0) AS dia16,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 17  THEN 1 END),0) AS dia17,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 18  THEN 1 END),0) AS dia18,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 19  THEN 1 END),0) AS dia19,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 20  THEN 1 END),0) AS dia20,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 21  THEN 1 END),0) AS dia21,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 22  THEN 1 END),0) AS dia22,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 23  THEN 1 END),0) AS dia23,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 24  THEN 1 END),0) AS dia24,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 25  THEN 1 END),0) AS dia25,
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 26  THEN 1 END),0) AS dia26,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 27  THEN 1 END),0) AS dia27,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 28  THEN 1 END),0) AS dia28,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 29  THEN 1 END),0) AS dia29,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 30  THEN 1 END),0) AS dia30,	
IsNull(SUM(CASE WHEN DAY(CONVERT(DATE,FECHA_DE_REGISTRO)) <= 31  THEN 1 END),0) AS dia31,	

IsNull(@PLD_ING_ACUMULADO_M1,0) AS mes1,
IsNull(@PLD_ING_ACUMULADO_M2,0) AS mes2,
IsNull(SUM(CASE WHEN MONTH(FECHA_DE_REGISTRO) = @MES THEN 1 else 0 end),0)  as mes3		
						
FROM TB_FUVEX F  inner join TB_FUVEX_SUBPRODUCTO FS 
ON F.COD_SUB_PRODUCTO = FS.CODIGO
WHERE 
MONTH(CONVERT(date,FECHA_DE_REGISTRO)) = @MES 
and YEAR(CONVERT(date,FECHA_DE_REGISTRO)) = @AÑO 
AND  FS.TIPO = 'PLD'
GROUP BY F.PRODUCTO

--------------------select * from #PLD
------------------------------------- // PORCENTAJE FORMALIZACION DE OPERACIONES EN EL FUNNEL (TABLERO DEL RESUMEN)
INSERT INTO PLD_TC_CONVENIO 
SELECT  'PRESTAMO DE LIBRE DISPONIBILIDAD' AS PRODUCTO,
		 'PORCENTAJE EN LA FORMALIZACION FUNNEL' AS DESCRIPCION,
		 70 AS VO,
		@FECHA_FIN AS fecha_proceso,
		CAST(a.dia1/ISNULL(NULLIF(b.dia1,0),1) * 100 as decimal(18,2)) AS  '01', 
		CAST(a.dia2/ISNULL(NULLIF(b.dia2,0),1) * 100 as decimal(18,2)) AS '02', 
		CAST(a.dia3/ISNULL(NULLIF(b.dia3,0),1) * 100 as decimal(18,2)) AS '03',
		CAST(a.dia4/ISNULL(NULLIF(b.dia4,0),1) * 100 as decimal(18,2)) AS '04',
		CAST(a.dia5/ISNULL(NULLIF(b.dia5,0),1) * 100 as decimal(18,2)) AS '05',
		CAST(a.dia6/ISNULL(NULLIF(b.dia6,0),1) * 100 as decimal(18,2)) AS '06',
		CAST(a.dia7/ISNULL(NULLIF(b.dia7,0),1) * 100 as decimal(18,2)) AS '07',
		CAST(a.dia8/ISNULL(NULLIF(b.dia8,0),1) * 100 as decimal(18,2)) AS '08',
		CAST(a.dia9/ISNULL(NULLIF(b.dia9,0),1) * 100 as decimal(18,2)) AS '09',
		CAST(a.dia10/ISNULL(NULLIF(b.dia10,0),1) * 100 as decimal(18,2)) AS '10',
		CAST(a.dia11/ISNULL(NULLIF(b.dia11,0),1) * 100 as decimal(18,2)) AS '11',
		CAST(a.dia12/ISNULL(NULLIF(b.dia12,0),1) * 100 as decimal(18,2)) AS '12',
		CAST(a.dia13/ISNULL(NULLIF(b.dia13,0),1) * 100 as decimal(18,2)) AS '13',
		CAST(a.dia14/ISNULL(NULLIF(b.dia14,0),1) * 100 as decimal(18,2)) AS '14',
		CAST(a.dia15/ISNULL(NULLIF(b.dia15,0),1) * 100 as decimal(18,2)) AS '15',
		CAST(a.dia16/ISNULL(NULLIF(b.dia16,0),1) * 100 as decimal(18,2)) AS '16',
		CAST(a.dia17/ISNULL(NULLIF(b.dia17,0),1) * 100 as decimal(18,2)) AS '17',
		CAST(a.dia18/ISNULL(NULLIF(b.dia18,0),1) * 100 as decimal(18,2)) AS '18',
		CAST(a.dia19/ISNULL(NULLIF(b.dia19,0),1) * 100 as decimal(18,2)) AS '19',
		CAST(a.dia20/ISNULL(NULLIF(b.dia20,0),1) * 100 as decimal(18,2)) AS '20',
		CAST(a.dia21/ISNULL(NULLIF(b.dia21,0),1) * 100 as decimal(18,2)) AS '21',
		CAST(a.dia22/ISNULL(NULLIF(b.dia22,0),1) * 100 as decimal(18,2)) AS '22',
		CAST(a.dia23/ISNULL(NULLIF(b.dia23,0),1) * 100 as decimal(18,2)) AS '23',
		CAST(a.dia24/ISNULL(NULLIF(b.dia24,0),1) * 100 as decimal(18,2)) AS '24',
		CAST(a.dia25/ISNULL(NULLIF(b.dia25,0),1) * 100 as decimal(18,2)) AS '25',
		CAST(a.dia26/ISNULL(NULLIF(b.dia26,0),1) * 100 as decimal(18,2)) AS '26',
		CAST(a.dia27/ISNULL(NULLIF(b.dia27,0),1) * 100 as decimal(18,2)) AS '27',
		CAST(a.dia28/ISNULL(NULLIF(b.dia28,0),1) * 100 as decimal(18,2)) AS '28',
		CAST(a.dia29/ISNULL(NULLIF(b.dia29,0),1) * 100 as decimal(18,2)) AS '29',
		CAST(a.dia30/ISNULL(NULLIF(b.dia30,0),1) * 100 as decimal(18,2)) AS '30',
		CAST(a.dia31/ISNULL(NULLIF(b.dia31,0),1) * 100 as decimal(18,2)) AS '31',
		CAST(a.mes1/ISNULL(NULLIF(b.mes1,0),1) * 100 as decimal(18,2)) AS 'mes1',
		CAST(a.mes2/ISNULL(NULLIF(b.mes2,0),1) * 100 as decimal(18,2)) AS 'mes2',
		CAST(a.mes3/ISNULL(NULLIF(b.mes3,0),1) * 100 as decimal(18,2)) AS 'mes3'

		FROM #PLD a LEFT JOIN #PLD b
		ON a.codigo = 1	WHERE b.codigo = 2

END

END
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_PERCENTIL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_TB_FUVEX_PERCENTIL] (
@FECHA DATE,
@MODALIDAD_DE_VENTA VARCHAR(100),
@TIPO VARCHAR(100),
@PAPERLESS VARCHAR(100)

)
AS

BEGIN 

DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.0
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

IF @TIPO = 'PLD' 
BEGIN

																	
	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE ,
	0  as CAL
	INTO #PARTE1
	FROM [dbo].[TB_FUVEX] f	inner join TB_FUVEX_SUBPRODUCTO s
	ON f.COD_SUB_PRODUCTO=s.CODIGO
	WHERE f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA and s.TIPO=@TIPO
	AND	CASE WHEN TIPO_DE_CAPTACION = 'PAPERLESS' THEN 'PAPERLESS' ELSE 'FISICO' END = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT(date, FECHA_DE_ESTADO) = CONVERT(date,@FECHA)


	select @COUNT = count(*) from #PARTE1
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;  


	SELECT @LAB=  [TIE] FROM  #PARTE1
	WHERE  NUM = convert(int, @PERCENTIL) 

	-----------------------------------------------------------------------------

	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  (  FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as CAL
	INTO #PARTE2
	FROM [dbo].[TB_FUVEX] f	inner join TB_FUVEX_SUBPRODUCTO s
	on f.COD_SUB_PRODUCTO=s.CODIGO
	where	f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA and s.TIPO=@TIPO and 
	case when TIPO_DE_CAPTACION =  'PAPERLESS' then 'PAPERLESS'	else 'FISICO' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT (date , FECHA_DE_ESTADO) = CONVERT (date ,@FECHA)

	SELECT @CAL=  [CAL] FROM  #PARTE2
	WHERE  NUM= convert ( int , @PERCENTIL) 

	DROP TABLE #PARTE1
	DROP TABLE #PARTE2 

END


IF @TIPO = 'TC' 
BEGIN

	SELECT ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE ,
	0  as CAL
	INTO #PARTE3
	FROM [dbo].[TB_FUVEX] f
	where
	f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA and 
	PRODUCTO='TARJETAS'
	and CONVERT (date , FECHA_DE_ESTADO) = CONVERT (date ,@FECHA)
	and case when FUERZA_DE_VENTA = 'COMCORP SAC' then 'FISICO'	else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	------------------------------------------------------
	select @COUNT = count(*) from #PARTE3
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;  

	SELECT @LAB=  [TIE] FROM  #PARTE3
	WHERE  NUM= convert ( int , @PERCENTIL) 
	-------------------------------------------------------

	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  (  FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as CAL
	INTO #PARTE4
	FROM [dbo].[TB_FUVEX] f
	where
	f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA and 
	PRODUCTO='TARJETAS'
	and CONVERT (date , FECHA_DE_ESTADO) = CONVERT (date ,@FECHA)
	and case when FUERZA_DE_VENTA =  'COMCORP SAC' then 'FISICO' else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	-------------------------------------------------------
	SELECT @CAL=  [CAL] FROM  #PARTE4
	WHERE  NUM= convert ( int , ceiling(@PERCENTIL)) 
	--------------------------------------------------------
	DROP TABLE #PARTE3
	DROP TABLE #PARTE4 

END 



if @COUNT>0 
begin 
	INSERT INTO TB_FUVEX_PERCENTIL
	VALUES (@FECHA ,  @LAB+1,@TIPO ,@MODALIDAD_DE_VENTA ,@PAPERLESS ,'DÍAS ÚTILES' , 'DIARIO')

	INSERT INTO TB_FUVEX_PERCENTIL
	VALUES (@FECHA ,  @CAL+1,@TIPO,@MODALIDAD_DE_VENTA , @PAPERLESS ,'DÍAS CALENDARIO' , 'DIARIO')

end 
else

begin 
	INSERT INTO TB_FUVEX_PERCENTIL
	VALUES (@FECHA ,  0,@TIPO ,@MODALIDAD_DE_VENTA ,@PAPERLESS ,'DÍAS ÚTILES' , 'DIARIO')

	INSERT INTO TB_FUVEX_PERCENTIL
	VALUES (@FECHA ,  0,@TIPO,@MODALIDAD_DE_VENTA , @PAPERLESS ,'DÍAS CALENDARIO' , 'DIARIO')

end  

END 



GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_PERCENTIL_DIA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_TB_FUVEX_PERCENTIL_DIA] (
@FECHA DATE,
@MODALIDAD_DE_VENTA VARCHAR(100),
@TIPO VARCHAR(100),
@PAPERLESS VARCHAR(100)

)
AS

BEGIN 

DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.1
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @LAB_2 DECIMAL(10,2) = 0.0;

DECLARE @CAL DECIMAL(10,2) = 0.0;
DECLARE @CAL_2 DECIMAL(10,2) = 0.0;

DECLARE @RES_1 DECIMAL(10,2) = 0.0;
DECLARE @RES_2 DECIMAL(10,2) = 0.0;

iF @TIPO = 'PLD' 
BEGIN

																	
	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE,
	0  as CAL
	INTO #PARTE1
	FROM [dbo].[TB_FUVEX] f
	inner join TB_FUVEX_SUBPRODUCTO s
	on f.COD_SUB_PRODUCTO=s.CODIGO
	where s.TIPO=@TIPO and 
	CASE WHEN TIPO_DE_CAPTACION =  'PAPERLESS' then 'PAPERLESS'	 else 'FISICO' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT (date , FECHA_DE_ESTADO) = CONVERT (date ,@FECHA)


	select @COUNT = count(*) from #PARTE1
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;  


	SELECT @LAB=  [TIE] FROM  #PARTE1
	WHERE  NUM= convert ( int , @PERCENTIL) 


	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  (  FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as CAL
	INTO #PARTE2
	FROM [dbo].[TB_FUVEX] f inner join TB_FUVEX_SUBPRODUCTO s
	on f.COD_SUB_PRODUCTO=s.CODIGO
	where s.TIPO=@TIPO	and 
	CASE WHEN TIPO_DE_CAPTACION =  'PAPERLESS' then 'PAPERLESS'	else 'FISICO' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT (date , FECHA_DE_ESTADO) = CONVERT (date ,@FECHA)

	SELECT @CAL=  [CAL] FROM  #PARTE2
	WHERE  NUM= convert ( int , @PERCENTIL) 


	DROP TABLE #PARTE1
DROP TABLE #PARTE2 


END


iF @TIPO = 'TC' 
BEGIN

	SELECT ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE ,
	0  as CAL
	INTO #PARTE3
	FROM [dbo].[TB_FUVEX] 
	where PRODUCTO='TARJETAS'
	and CONVERT (date , FECHA_DE_ESTADO) = CONVERT (date ,@FECHA)
	and CASE WHEN FUERZA_DE_VENTA =  'COMCORP SAC'  then 'FISICO' else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'


	select @COUNT = count(*) from #PARTE3
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;  


	SELECT @LAB=  [TIE] FROM  #PARTE3
	WHERE  NUM= convert ( int , @PERCENTIL) 

	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  (  FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as CAL
	INTO #PARTE4
	FROM [dbo].[TB_FUVEX] f
	where PRODUCTO='TARJETAS' and CONVERT (date , FECHA_DE_ESTADO) = CONVERT (date ,@FECHA)
	and case when FUERZA_DE_VENTA = 'COMCORP SAC' then 'FISICO' else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'



	SELECT @CAL=  [CAL] FROM  #PARTE4
	WHERE  NUM= convert ( int , ceiling(@PERCENTIL)) 

	DROP TABLE #PARTE3
DROP TABLE #PARTE4 

END 


if @COUNT>0 
begin

INSERT INTO TB_FUVEX_PERCENTIL
VALUES (@FECHA ,  @LAB+1,@TIPO ,'' ,@PAPERLESS ,'DÍAS ÚTILES' , 'DIARIO')

INSERT INTO TB_FUVEX_PERCENTIL
VALUES (@FECHA ,  @CAL+1,@TIPO,'' , @PAPERLESS ,'DÍAS CALENDARIO','DIARIO')


end

else 

begin

INSERT INTO TB_FUVEX_PERCENTIL
VALUES (@FECHA , 0,@TIPO ,'' ,@PAPERLESS ,'DÍAS ÚTILES' , 'DIARIO')

INSERT INTO TB_FUVEX_PERCENTIL
VALUES (@FECHA , 0,@TIPO,'' , @PAPERLESS ,'DÍAS CALENDARIO','DIARIO')


end


END 


GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_PERCENTIL_FECHAS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TB_FUVEX_PERCENTIL_FECHAS]
(@MES int,
@AÑO int,
@TIPO VARCHAR(100))

AS
BEGIN  -- BEGIN

DECLARE @Fecha datetime
DECLARE @BANDEJA VARCHAR(100)
DECLARE	@FECHA_INI datetime
DECLARE @FECHA_MAX datetime

----------------------------------------------->>>> PLD
DECLARE @PERCENTIL_M1_AP DECIMAL(10,2);
DECLARE @PERCENTIL_M2_AP DECIMAL(10,2);
DECLARE @PERCENTIL_M3_AP DECIMAL(10,2);

DECLARE @PERCENTIL_M1_RE DECIMAL(10,2);
DECLARE @PERCENTIL_M2_RE DECIMAL(10,2);
DECLARE @PERCENTIL_M3_RE DECIMAL(10,2);

DECLARE @PERCENTIL_M1_PAPERLES_AP DECIMAL(10,2);
DECLARE @PERCENTIL_M2_PAPERLES_AP DECIMAL(10,2);
DECLARE @PERCENTIL_M3_PAPERLES_AP DECIMAL(10,2);

----------------------------------------------->>>> TC
DECLARE @TC_PERCENTIL_M1_OFAP DECIMAL(10,2);
DECLARE @TC_PERCENTIL_M2_OFAP DECIMAL(10,2);
DECLARE @TC_PERCENTIL_M3_OFAP DECIMAL(10,2);


DECLARE @TC_PERCEN_PAPER_M1_OFAP DECIMAL(10,2);
DECLARE @TC_PERCEN_PAPER_M2_OFAP DECIMAL(10,2);
DECLARE @TC_PERCEN_PAPER_M3_OFAP DECIMAL(10,2);

DECLARE @FECHA_PROCESO DATE;

SET @FECHA_PROCESO = (SELECT CONVERT(DATE,MAX(FECHA_HORA_ENVIO)) 
					  FROM TB_CS 
					  WHERE MONTH(FECHA_HORA_ENVIO) = @MES	
					  AND YEAR(FECHA_HORA_ENVIO) = @AÑO)

----------------------------------------------------->>> REPROCESO RESUMEN
DELETE FROM PLD_TC_CONVENIO
WHERE fecha_proceso = @FECHA_PROCESO
AND descripcion IN ('TIEMPO DE FORMALIZACION OF. APROBADA',
					'TIEMPO DE FORMALIZACION OF. REGULAR',
					 'PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA')
------------------------------------->>>>>
DELETE FROM TB_FUVEX_PERCENTIL
WHERE MONTH(FECHA) = @MES AND YEAR(FECHA ) =  @AÑO
------------------------------------->>>>>

--------------------------------------------->>>> PERCENTIL MENSUAL
SET @FECHA_INI = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -------- armo mi primer dia
SELECT @FECHA_MAX= MAX(FECHA_DE_ESTADO)
FROM TB_FUVEX
WHERE MONTH(FECHA_DE_ESTADO) =  @MES AND 
YEAR(FECHA_DE_ESTADO) =  @AÑO
-----------------------------------------

	EXEC [USP_TB_FUVEX_PERCENTIL_MES] @FECHA_INI, @FECHA_MAX,'TC','FISICO'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES] @FECHA_INI, @FECHA_MAX,'TC','PAPERLESS'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES] @FECHA_INI, @FECHA_MAX,'PLD','FISICO'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES] @FECHA_INI, @FECHA_MAX,'PLD','PAPERLESS'
	-----------------------------------------------------<

	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'APROBADOS' ,'PLD','FISICO'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'REGULAR' ,'PLD','FISICO'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'APROBADOS' ,'PLD','PAPERLESS'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'REGULAR' ,'PLD','PAPERLESS'

	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'APROBADOS','TC','FISICO'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'REGULAR','TC','FISICO'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'APROBADOS','TC','PAPERLESS'
	EXEC [USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] @FECHA_INI, @FECHA_MAX, 'REGULAR','TC','PAPERLESS'
--------------------------------------------->>>> PERCENTIL MENSUAL

DECLARE cFECHAS CURSOR FOR
SELECT  
DISTINCT (  CONVERT ( DATE, FECHA_DE_ESTADO))
FROM TB_FUVEX
where MONTH(CONVERT(DATE, FECHA_DE_ESTADO)) =  @MES
and  YEAR (CONVERT(DATE, FECHA_DE_ESTADO)) = @AÑO
ORDER BY 1				

	BEGIN -- CURSOR  cFECHAS

		open cFECHAS
	
		fetch next from cFECHAS into @Fecha
		while @@fetch_status=0
		begin				
		--------print  @Fecha

		IF @TIPO = 'GLOBAL'
				BEGIN
					
				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'APROBADOS' ,'PLD','FISICO'
				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'REGULAR' ,'PLD','FISICO'
				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'APROBADOS' ,'PLD','PAPERLESS'
				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'REGULAR' ,'PLD','PAPERLESS'

				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'APROBADOS' ,'TC','FISICO'
				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'REGULAR' ,'TC','FISICO'
				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'APROBADOS' ,'TC','PAPERLESS'
				EXEC [USP_TB_FUVEX_PERCENTIL] @Fecha, 'REGULAR' ,'TC','PAPERLESS'

				EXEC [USP_TB_FUVEX_PERCENTIL_DIA] @Fecha, '' ,'TC','FISICO'
				EXEC [USP_TB_FUVEX_PERCENTIL_DIA] @Fecha, '' ,'TC','PAPERLESS'
				EXEC [USP_TB_FUVEX_PERCENTIL_DIA] @Fecha, '' ,'PLD','FISICO'
				EXEC [USP_TB_FUVEX_PERCENTIL_DIA] @Fecha, '' ,'PLD','PAPERLESS'

				END 		

		---
		fetch next from cFECHAS into @Fecha
		end
		close cFECHAS
		deallocate cFECHAS

		END -- CURSOR  cOficina

	----SELECT FECHA, PERCENTIL, NOMBRE_PRODUCTO, NOMBRE_TIPO_OFERTA, PAPERLESS, TIPO , FRECUENCIA  
	----FROM TB_FUVEX_PERCENTIL
	----WHERE MONTH(FECHA) =  @MES AND YEAR(FECHA) = @AÑO
-------------------------------------------------------------------------------//TIEMPO DE FORMALIZACION OF. APROBADA MESES
SET @PERCENTIL_M1_AP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES' 
					AND FRECUENCIA = 'MES'
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -2, @FECHA_PROCESO)) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -2, @FECHA_PROCESO))))

SET @PERCENTIL_M2_AP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' 
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -1, @FECHA_PROCESO)) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -1, @FECHA_PROCESO))))

SET @PERCENTIL_M3_AP = (select PERCENTIL from TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' AND FECHA = @FECHA_MAX)
-------------------------------------------------------------------------------//TIEMPO DE FORMALIZACION OF. REGULAR MESES
SET @PERCENTIL_M1_RE = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'REGULAR' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES'  
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -2, @FECHA_PROCESO)) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -2, @FECHA_PROCESO))))

SET @PERCENTIL_M2_RE = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'REGULAR' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' 
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -1, @FECHA_PROCESO)) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -1, @FECHA_PROCESO))))

SET @PERCENTIL_M3_RE = (SELECT PERCENTIL FROM TB_FUVEX_PERCENTIL 
						WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
						AND NOMBRE_TIPO_OFERTA = 'REGULAR' AND TIPO = 'DÍAS ÚTILES'
						AND	FRECUENCIA = 'MES' AND FECHA = @FECHA_MAX)

-------------------------------------------------------------------------------//PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA

SET @PERCENTIL_M1_PAPERLES_AP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'PAPERLESS'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES'   
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -2, @FECHA_PROCESO)) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -2, @FECHA_PROCESO))))

SET @PERCENTIL_M2_PAPERLES_AP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'PAPERLESS'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' 
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -1, @FECHA_PROCESO))) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -1, @FECHA_PROCESO)))

SET @PERCENTIL_M3_PAPERLES_AP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'PAPERLESS'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND	FRECUENCIA = 'MES' AND FECHA = @FECHA_MAX)

---------------------------------------------------// TARJETA DE CREDITO
-------------------------------------------------------------------------------//'TIEMPO DE FORMALIZACION OF. APROBADA'
SET @TC_PERCENTIL_M1_OFAP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' 
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -2, @FECHA_PROCESO))) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -2, @FECHA_PROCESO)))

SET @TC_PERCENTIL_M2_OFAP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' 
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
					WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -1, @FECHA_PROCESO))) 
					AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -1, @FECHA_PROCESO)))		

SET @TC_PERCENTIL_M3_OFAP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'FISICO'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND	FRECUENCIA = 'MES' AND FECHA = @FECHA_MAX)



-------------------------------------------------------------------------------//'PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA'

SET @TC_PERCEN_PAPER_M1_OFAP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'PAPERLESS'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES' 
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
								WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -2, @FECHA_PROCESO))) 
								AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -2, @FECHA_PROCESO)))		

SET @TC_PERCEN_PAPER_M2_OFAP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'PAPERLESS'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' 
					AND FECHA = (SELECT MAX(FECHA) FROM TB_FUVEX_PERCENTIL
								WHERE MONTH(FECHA) = MONTH(DATEADD(MONTH, -1, @FECHA_PROCESO))) 
								AND YEAR(FECHA) = YEAR(DATEADD(MONTH, -1, @FECHA_PROCESO)))		

SET @TC_PERCEN_PAPER_M3_OFAP = (SELECT percentil
					FROM TB_FUVEX_PERCENTIL
					WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'PAPERLESS'
					AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
					AND FRECUENCIA = 'MES' AND FECHA = @FECHA_MAX)		
------------------------------------------------------------------------------------------------------------------------------
				
	
------------------- // INSERTAMOS REGISTROS FUVEX (FISICO y PAPERLESS) PARA SER VISUALIZADOS EN EL TABLERO DEL RESUMEN PLD Y TC 

INSERT INTO PLD_TC_CONVENIO
SELECT 'PRESTAMO DE LIBRE DISPONIBILIDAD', 'TIEMPO DE FORMALIZACION OF. APROBADA', 4 as valor_objetivo, @FECHA_PROCESO,
 IsNull(SUM (CASE WHEN DAY(fecha) = 1 THEN percentil END),0) AS "01",
 IsNull(SUM (CASE WHEN DAY(fecha) = 2 THEN percentil END),0) AS "02",
 IsNull(SUM (CASE WHEN DAY(fecha) = 3 THEN percentil END),0) AS "03",
 IsNull(SUM (CASE WHEN DAY(fecha) = 4 THEN percentil END),0) AS "04",
 IsNull(SUM (CASE WHEN DAY(fecha) = 5 THEN percentil END),0) AS "05",
 IsNull(SUM (CASE WHEN DAY(fecha) = 6 THEN percentil END),0) AS "06",
 IsNull(SUM (CASE WHEN DAY(fecha) = 7 THEN percentil END),0) AS "07",
 IsNull(SUM (CASE WHEN DAY(fecha) = 8 THEN percentil END),0) AS "08",
 IsNull(SUM (CASE WHEN DAY(fecha) = 9 THEN percentil END),0) AS "09",
 IsNull(SUM (CASE WHEN DAY(fecha) = 10 THEN percentil END),0) AS "10",
 IsNull(SUM (CASE WHEN DAY(fecha) = 11 THEN percentil END),0) AS "11",
 IsNull(SUM (CASE WHEN DAY(fecha) = 12 THEN percentil END),0) AS "12",
 IsNull(SUM (CASE WHEN DAY(fecha) = 13 THEN percentil END),0) AS "13",
 IsNull(SUM (CASE WHEN DAY(fecha) = 14 THEN percentil END),0) AS "14",
 IsNull(SUM (CASE WHEN DAY(fecha) = 15 THEN percentil END),0) AS "15",
 IsNull(SUM (CASE WHEN DAY(fecha) = 16 THEN percentil END),0) AS "16",
 IsNull(SUM (CASE WHEN DAY(fecha) = 17 THEN percentil END),0) AS "17",
 IsNull(SUM (CASE WHEN DAY(fecha) = 18 THEN percentil END),0) AS "18",
 IsNull(SUM (CASE WHEN DAY(fecha) = 19 THEN percentil END),0) AS "19",
 IsNull(SUM (CASE WHEN DAY(fecha) = 20 THEN percentil END),0) AS "20",
 IsNull(SUM (CASE WHEN DAY(fecha) = 21 THEN percentil END),0) AS "21",
 IsNull(SUM (CASE WHEN DAY(fecha) = 22 THEN percentil END),0) AS "22",
 IsNull(SUM (CASE WHEN DAY(fecha) = 23 THEN percentil END),0) AS "23",
 IsNull(SUM (CASE WHEN DAY(fecha) = 24 THEN percentil END),0) AS "24",
 IsNull(SUM (CASE WHEN DAY(fecha) = 25 THEN percentil END),0) AS "25",
 IsNull(SUM (CASE WHEN DAY(fecha) = 26 THEN percentil END),0) AS "26",
 IsNull(SUM (CASE WHEN DAY(fecha) = 27 THEN percentil END),0) AS "27",
 IsNull(SUM (CASE WHEN DAY(fecha) = 28 THEN percentil END),0) AS "28",
 IsNull(SUM (CASE WHEN DAY(fecha) = 29 THEN percentil END),0) AS "29",
 IsNull(SUM (CASE WHEN DAY(fecha) = 30 THEN percentil END),0) AS "30",
 IsNull(SUM (CASE WHEN DAY(fecha) = 31 THEN percentil END),0) AS "31",
 				
ISNULL(@PERCENTIL_M1_AP,0) AS mes1,
ISNULL(@PERCENTIL_M2_AP,0) AS mes2,
ISNULL(@PERCENTIL_M3_AP,0) AS mes3	 

FROM TB_FUVEX_PERCENTIL
WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES'
AND FRECUENCIA = 'DIARIO' 
AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO


UNION ALL 

	
SELECT 'PRESTAMO DE LIBRE DISPONIBILIDAD', 'TIEMPO DE FORMALIZACION OF. REGULAR', 4 as valor_objetivo, @FECHA_PROCESO,
IsNull(SUM (CASE  WHEN  DAY (fecha) = 1 THEN percentil END),0) AS "01",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 2 THEN percentil END),0) AS "02",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 3 THEN percentil END),0) AS "03",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 4 THEN percentil END),0) AS "04",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 5 THEN percentil END),0) AS "05",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 6 THEN percentil END),0) AS "06",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 7 THEN percentil END),0) AS "07",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 8 THEN percentil END),0) AS "08",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 9 THEN percentil END),0) AS "09",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 10 THEN percentil END),0) AS "10",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 11 THEN percentil END),0) AS "11",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 12 THEN percentil END),0) AS "12",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 13 THEN percentil END),0) AS "13",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 14 THEN percentil END),0) AS "14",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 15 THEN percentil END),0) AS "15",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 16 THEN percentil END),0) AS "16",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 17 THEN percentil END),0) AS "17",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 18 THEN percentil END),0) AS "18",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 19 THEN percentil END),0) AS "19",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 20 THEN percentil END),0) AS "20",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 21 THEN percentil END),0) AS "21",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 22 THEN percentil END),0) AS "22",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 23 THEN percentil END),0) AS "23",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 24 THEN percentil END),0) AS "24",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 25 THEN percentil END),0) AS "25",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 26 THEN percentil END),0) AS "26",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 27 THEN percentil END),0) AS "27",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 28 THEN percentil END),0) AS "28",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 29 THEN percentil END),0) AS "29",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 30 THEN percentil END),0) AS "30",
IsNull(SUM (CASE  WHEN  DAY (fecha) = 31 THEN percentil END),0) AS "31", 				
ISNULL(@PERCENTIL_M1_RE,0) AS mes1,
ISNULL(@PERCENTIL_M2_RE,0) AS mes2,
ISNULL(@PERCENTIL_M3_RE,0) AS mes3	 

FROM TB_FUVEX_PERCENTIL
WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'FISICO'
AND NOMBRE_TIPO_OFERTA = 'REGULAR' AND TIPO = 'DÍAS ÚTILES' 
AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO

UNION ALL

SELECT 'PRESTAMO DE LIBRE DISPONIBILIDAD', 'PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA', 4 as valor_objetivo, @FECHA_PROCESO,
IsNull(SUM (CASE WHEN DAY (fecha) = 1 THEN percentil END),0) AS "01",
IsNull(SUM (CASE WHEN DAY (fecha) = 2 THEN percentil END),0) AS "02",
IsNull(SUM (CASE WHEN DAY (fecha) = 3 THEN percentil END),0) AS "03",
IsNull(SUM (CASE WHEN DAY (fecha) = 4 THEN percentil END),0) AS "04",
IsNull(SUM (CASE WHEN DAY (fecha) = 5 THEN percentil END),0) AS "05",
IsNull(SUM (CASE WHEN DAY (fecha) = 6 THEN percentil END),0) AS "06",
IsNull(SUM (CASE WHEN DAY (fecha) = 7 THEN percentil END),0) AS "07",
IsNull(SUM (CASE WHEN DAY (fecha) = 8 THEN percentil END),0) AS "08",
IsNull(SUM (CASE WHEN DAY (fecha) = 9 THEN percentil END),0) AS "09",
IsNull(SUM (CASE WHEN DAY (fecha) = 10 THEN percentil END),0) AS "10",
IsNull(SUM (CASE WHEN DAY (fecha) = 11 THEN percentil END),0) AS "11",
IsNull(SUM (CASE WHEN DAY (fecha) = 12 THEN percentil END),0) AS "12",
IsNull(SUM (CASE WHEN DAY (fecha) = 13 THEN percentil END),0) AS "13",
IsNull(SUM (CASE WHEN DAY (fecha) = 14 THEN percentil END),0) AS "14",
IsNull(SUM (CASE WHEN DAY (fecha) = 15 THEN percentil END),0) AS "15",
IsNull(SUM (CASE WHEN DAY (fecha) = 16 THEN percentil END),0) AS "16",
IsNull(SUM (CASE WHEN DAY (fecha) = 17 THEN percentil END),0) AS "17",
IsNull(SUM (CASE WHEN DAY (fecha) = 18 THEN percentil END),0) AS "18",
IsNull(SUM (CASE WHEN DAY (fecha) = 19 THEN percentil END),0) AS "19",
IsNull(SUM (CASE WHEN DAY (fecha) = 20 THEN percentil END),0) AS "20",
IsNull(SUM (CASE WHEN DAY (fecha) = 21 THEN percentil END),0) AS "21",
IsNull(SUM (CASE WHEN DAY (fecha) = 22 THEN percentil END),0) AS "22",
IsNull(SUM (CASE WHEN DAY (fecha) = 23 THEN percentil END),0) AS "23",
IsNull(SUM (CASE WHEN DAY (fecha) = 24 THEN percentil END),0) AS "24",
IsNull(SUM (CASE WHEN DAY (fecha) = 25 THEN percentil END),0) AS "25",
IsNull(SUM (CASE WHEN DAY (fecha) = 26 THEN percentil END),0) AS "26",
IsNull(SUM (CASE WHEN DAY (fecha) = 27 THEN percentil END),0) AS "27",
IsNull(SUM (CASE WHEN DAY (fecha) = 28 THEN percentil END),0) AS "28",
IsNull(SUM (CASE WHEN DAY (fecha) = 29 THEN percentil END),0) AS "29",
IsNull(SUM (CASE WHEN DAY (fecha) = 30 THEN percentil END),0) AS "30",
IsNull(SUM (CASE WHEN DAY (fecha) = 31 THEN percentil END),0) AS "31",
 				
ISNULL(@PERCENTIL_M1_PAPERLES_AP,0) AS mes1,
ISNULL(@PERCENTIL_M2_PAPERLES_AP,0) AS mes2,
ISNULL(@PERCENTIL_M3_PAPERLES_AP,0) AS mes3	 

FROM TB_FUVEX_PERCENTIL
WHERE NOMBRE_PRODUCTO = 'PLD' AND PAPERLESS = 'PAPERLESS'
AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES' 
AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO

UNION ALL 

SELECT 'TARJETA DE CREDITO', 'TIEMPO DE FORMALIZACION OF. APROBADA', 4 as valor_objetivo, @FECHA_PROCESO,
IsNull(SUM (CASE WHEN DAY(fecha) = 1 THEN percentil END),0) AS "01",
IsNull(SUM (CASE WHEN DAY(fecha) = 2 THEN percentil END),0) AS "02",
IsNull(SUM (CASE WHEN DAY(fecha) = 3 THEN percentil END),0) AS "03",
IsNull(SUM (CASE WHEN DAY(fecha) = 4 THEN percentil END),0) AS "04",
IsNull(SUM (CASE WHEN DAY(fecha) = 5 THEN percentil END),0) AS "05",
IsNull(SUM (CASE WHEN DAY(fecha) = 6 THEN percentil END),0) AS "06",
IsNull(SUM (CASE WHEN DAY(fecha) = 7 THEN percentil END),0) AS "07",
IsNull(SUM (CASE WHEN DAY(fecha) = 8 THEN percentil END),0) AS "08",
IsNull(SUM (CASE WHEN DAY(fecha) = 9 THEN percentil END),0) AS "09",
IsNull(SUM (CASE WHEN DAY(fecha) = 10 THEN percentil END),0) AS "10",
IsNull(SUM (CASE WHEN DAY(fecha) = 11 THEN percentil END),0) AS "11",
IsNull(SUM (CASE WHEN DAY(fecha) = 12 THEN percentil END),0) AS "12",
IsNull(SUM (CASE WHEN DAY(fecha) = 13 THEN percentil END),0) AS "13",
IsNull(SUM (CASE WHEN DAY(fecha) = 14 THEN percentil END),0) AS "14",
IsNull(SUM (CASE WHEN DAY(fecha) = 15 THEN percentil END),0) AS "15",
IsNull(SUM (CASE WHEN DAY(fecha) = 16 THEN percentil END),0) AS "16",
IsNull(SUM (CASE WHEN DAY(fecha) = 17 THEN percentil END),0) AS "17",
IsNull(SUM (CASE WHEN DAY(fecha) = 18 THEN percentil END),0) AS "18",
IsNull(SUM (CASE WHEN DAY(fecha) = 19 THEN percentil END),0) AS "19",
IsNull(SUM (CASE WHEN DAY(fecha) = 20 THEN percentil END),0) AS "20",
IsNull(SUM (CASE WHEN DAY(fecha) = 21 THEN percentil END),0) AS "21",
IsNull(SUM (CASE WHEN DAY(fecha) = 22 THEN percentil END),0) AS "22",
IsNull(SUM (CASE WHEN DAY(fecha) = 23 THEN percentil END),0) AS "23",
IsNull(SUM (CASE WHEN DAY(fecha) = 24 THEN percentil END),0) AS "24",
IsNull(SUM (CASE WHEN DAY(fecha) = 25 THEN percentil END),0) AS "25",
IsNull(SUM (CASE WHEN DAY(fecha) = 26 THEN percentil END),0) AS "26",
IsNull(SUM (CASE WHEN DAY(fecha) = 27 THEN percentil END),0) AS "27",
IsNull(SUM (CASE WHEN DAY(fecha) = 28 THEN percentil END),0) AS "28",
IsNull(SUM (CASE WHEN DAY(fecha) = 29 THEN percentil END),0) AS "29",
IsNull(SUM (CASE WHEN DAY(fecha) = 30 THEN percentil END),0) AS "30",
IsNull(SUM (CASE WHEN DAY(fecha) = 31 THEN percentil END),0) AS "31",
 				
ISNULL(@TC_PERCENTIL_M1_OFAP,0) AS mes1,
ISNULL(@TC_PERCENTIL_M2_OFAP,0) AS mes2,
ISNULL(@TC_PERCENTIL_M3_OFAP,0) AS mes3	 

FROM TB_FUVEX_PERCENTIL
WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'FISICO'
AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES' 
AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO


UNION ALL 

SELECT 'TARJETA DE CREDITO', 'PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA', 4 as valor_objetivo, @FECHA_PROCESO,
IsNull(SUM (CASE WHEN DAY(fecha) = 1 THEN percentil END),0) AS "01",
IsNull(SUM (CASE WHEN DAY(fecha) = 2 THEN percentil END),0) AS "02",
IsNull(SUM (CASE WHEN DAY(fecha) = 3 THEN percentil END),0) AS "03",
IsNull(SUM (CASE WHEN DAY(fecha) = 4 THEN percentil END),0) AS "04",
IsNull(SUM (CASE WHEN DAY(fecha) = 5 THEN percentil END),0) AS "05",
IsNull(SUM (CASE WHEN DAY(fecha) = 6 THEN percentil END),0) AS "06",
IsNull(SUM (CASE WHEN DAY(fecha) = 7 THEN percentil END),0) AS "07",
IsNull(SUM (CASE WHEN DAY(fecha) = 8 THEN percentil END),0) AS "08",
IsNull(SUM (CASE WHEN DAY(fecha) = 9 THEN percentil END),0) AS "09",
IsNull(SUM (CASE WHEN DAY(fecha) = 10 THEN percentil END),0) AS "10",
IsNull(SUM (CASE WHEN DAY(fecha) = 11 THEN percentil END),0) AS "11",
IsNull(SUM (CASE WHEN DAY(fecha) = 12 THEN percentil END),0) AS "12",
IsNull(SUM (CASE WHEN DAY(fecha) = 13 THEN percentil END),0) AS "13",
IsNull(SUM (CASE WHEN DAY(fecha) = 14 THEN percentil END),0) AS "14",
IsNull(SUM (CASE WHEN DAY(fecha) = 15 THEN percentil END),0) AS "15",
IsNull(SUM (CASE WHEN DAY(fecha) = 16 THEN percentil END),0) AS "16",
IsNull(SUM (CASE WHEN DAY(fecha) = 17 THEN percentil END),0) AS "17",
IsNull(SUM (CASE WHEN DAY(fecha) = 18 THEN percentil END),0) AS "18",
IsNull(SUM (CASE WHEN DAY(fecha) = 19 THEN percentil END),0) AS "19",
IsNull(SUM (CASE WHEN DAY(fecha) = 20 THEN percentil END),0) AS "20",
IsNull(SUM (CASE WHEN DAY(fecha) = 21 THEN percentil END),0) AS "21",
IsNull(SUM (CASE WHEN DAY(fecha) = 22 THEN percentil END),0) AS "22",
IsNull(SUM (CASE WHEN DAY(fecha) = 23 THEN percentil END),0) AS "23",
IsNull(SUM (CASE WHEN DAY(fecha) = 24 THEN percentil END),0) AS "24",
IsNull(SUM (CASE WHEN DAY(fecha) = 25 THEN percentil END),0) AS "25",
IsNull(SUM (CASE WHEN DAY(fecha) = 26 THEN percentil END),0) AS "26",
IsNull(SUM (CASE WHEN DAY(fecha) = 27 THEN percentil END),0) AS "27",
IsNull(SUM (CASE WHEN DAY(fecha) = 28 THEN percentil END),0) AS "28",
IsNull(SUM (CASE WHEN DAY(fecha) = 29 THEN percentil END),0) AS "29",
IsNull(SUM (CASE WHEN DAY(fecha) = 30 THEN percentil END),0) AS "30",
IsNull(SUM (CASE WHEN DAY(fecha) = 31 THEN percentil END),0) AS "31",
 				
ISNULL(@TC_PERCEN_PAPER_M1_OFAP,0) AS mes1,
ISNULL(@TC_PERCEN_PAPER_M1_OFAP,0) AS mes2,
ISNULL(@TC_PERCEN_PAPER_M3_OFAP,0) AS mes3	 

FROM TB_FUVEX_PERCENTIL
WHERE NOMBRE_PRODUCTO = 'TC' AND PAPERLESS = 'PAPERLESS'
	AND NOMBRE_TIPO_OFERTA = 'APROBADOS' AND TIPO = 'DÍAS ÚTILES' 
	AND MONTH(FECHA) = @MES AND YEAR(FECHA) = @AÑO

END -- END BEGIN
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_PERCENTIL_MES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[USP_TB_FUVEX_PERCENTIL_MES] 
(@FECHA DATETIME,
@FECHA_FIN DATETIME,
@TIPO VARCHAR(100),
@PAPERLESS VARCHAR(100)
)

AS

BEGIN 

DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)  =0.0
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

IF @TIPO = 'PLD' 
BEGIN

	--------------------------------------------/// DIAS UTILES																	
	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE ,
	0  as CAL
	INTO #PARTE1
	FROM [dbo].[TB_FUVEX] f
	inner join TB_FUVEX_SUBPRODUCTO s
	on f.COD_SUB_PRODUCTO=s.CODIGO
	where
	s.TIPO=@TIPO
	and	case when TIPO_DE_CAPTACION =  'PAPERLESS' then 'PAPERLESS'	 else 'FISICO' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT (date , FECHA_DE_ESTADO) >= CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)


	select @COUNT = count(*) from #PARTE1
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;  


	SELECT @LAB=  [TIE] FROM  #PARTE1
	WHERE  NUM= convert ( int , @PERCENTIL) 

	--------------------------------------------/// DIAS CALENDARIO
	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  (  FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as CAL
	INTO #PARTE2
	FROM [dbo].[TB_FUVEX] f
	inner join TB_FUVEX_SUBPRODUCTO s
	on f.COD_SUB_PRODUCTO=s.CODIGO
	where
	s.TIPO=@TIPO
	and 
	case when TIPO_DE_CAPTACION =  'PAPERLESS' then 'PAPERLESS'	else 'FISICO' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT (date , FECHA_DE_ESTADO) >= CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)

	SELECT @CAL=  [CAL] FROM  #PARTE2
	WHERE  NUM= convert ( int , @PERCENTIL) 
		
	DROP TABLE #PARTE1
	DROP TABLE #PARTE2 

END


IF @TIPO = 'TC' 
BEGIN
	--------------------------------------------/// DIAS UTILES
	SELECT ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE ,
	0  as CAL
	INTO #PARTE3
	FROM [dbo].[TB_FUVEX] f
	where
	PRODUCTO='TARJETAS'
	and CONVERT (date , FECHA_DE_ESTADO) >=  CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)
	and case when FUERZA_DE_VENTA =  'COMCORP SAC'  then 'FISICO' else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'


	select @COUNT = count(*) from #PARTE3
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0  ;  


	SELECT @LAB=  [TIE] FROM  #PARTE3
	WHERE  NUM= convert ( int , @PERCENTIL) 
	
	--------------------------------------------/// DIAS CALENDARIO
	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  (  FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as CAL
	INTO #PARTE4
	FROM [dbo].[TB_FUVEX] f
	where PRODUCTO='TARJETAS'
	and CONVERT (date , FECHA_DE_ESTADO) >=  CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)
	and case when FUERZA_DE_VENTA =  'COMCORP SAC'  then 'FISICO' else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'

	SELECT @CAL=  [CAL] FROM  #PARTE4
	WHERE  NUM= convert ( int , ceiling(@PERCENTIL)) 

	DROP TABLE #PARTE3
	DROP TABLE #PARTE4 

END 

if @COUNT>0 
	begin 
		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN ,  @LAB+1,@TIPO ,'' ,@PAPERLESS ,'DÍAS ÚTILES' , 'MES')

		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN ,  @CAL+1,@TIPO,'' , @PAPERLESS ,'DÍAS CALENDARIO' , 'MES')
	end 
	else 
	begin 
		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN , 0,@TIPO ,'' ,@PAPERLESS ,'DÍAS ÚTILES' , 'MES')

		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN , 0,@TIPO,'' , @PAPERLESS ,'DÍAS CALENDARIO' , 'MES')

	end 
END 


GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Replicado por Didier Yepez Cabanillas 
-- Create date: 09/08/2020
-- Description:	Procedure para sacar percentil mensual de FUVEX con oferta APROBADA o REGULAR y tipos FISICO PAPERLESS...
-- =============================================
CREATE PROCEDURE  [dbo].[USP_TB_FUVEX_PERCENTIL_MES_MODALIDAD] (
@FECHA DATETIME,
@FECHA_FIN DATETIME,
@MODALIDAD_DE_VENTA VARCHAR(100),
@TIPO VARCHAR(100),
@PAPERLESS VARCHAR(100)
)

AS

BEGIN 

DECLARE @COUNT DECIMAL(10,2) = 0.0;
DECLARE @PERCENTIL numeric(10,5)=0.0
DECLARE @LAB DECIMAL(10,2) = 0.0;
DECLARE @CAL DECIMAL(10,2) = 0.0;

IF @TIPO = 'PLD' 
BEGIN

																	
	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE ,
	0  as CAL
	INTO #PARTE1
	FROM [dbo].[TB_FUVEX] f
	inner join TB_FUVEX_SUBPRODUCTO s
	on f.COD_SUB_PRODUCTO=s.CODIGO
	where
	s.TIPO=@TIPO
	and case 
		when TIPO_DE_CAPTACION =  'PAPERLESS' then 'PAPERLESS'	 else 'FISICO' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT (date , FECHA_DE_ESTADO) >= CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)
	and f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA  


	select @COUNT = count(*) from #PARTE1
	SET  @PERCENTIL =     90.0 * (@COUNT) /100.0 ;  


	SELECT @LAB=  [TIE] FROM  #PARTE1
	WHERE  NUM= convert ( int , @PERCENTIL) 

	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  (  FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as CAL
	INTO #PARTE2
	FROM [dbo].[TB_FUVEX] f	inner join TB_FUVEX_SUBPRODUCTO s
	on f.COD_SUB_PRODUCTO=s.CODIGO
	where s.TIPO=@TIPO
	and  case when TIPO_DE_CAPTACION =  'PAPERLESS' then 'PAPERLESS' else 'FISICO' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and CONVERT (date , FECHA_DE_ESTADO) >= CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)
	and f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA  

	SELECT @CAL=  [CAL] FROM  #PARTE2
	WHERE  NUM= convert ( int , @PERCENTIL) 


	DROP TABLE #PARTE1
	DROP TABLE #PARTE2 
END


iF @TIPO = 'TC' 
BEGIN

	SELECT ROW_NUMBER() OVER(ORDER BY  [dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	[dbo].[fn_tiempo_horas] ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO )  as  TIE ,
	0  as CAL
	INTO #PARTE3
	FROM [dbo].[TB_FUVEX] f
	where
	PRODUCTO='TARJETAS'
	and CONVERT (date , FECHA_DE_ESTADO) >=  CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)
	and 
	case  when FUERZA_DE_VENTA =  'COMCORP SAC'  then 'FISICO' else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA  


	select @COUNT = count(*) from #PARTE3
	SET  @PERCENTIL =  90.0 * (@COUNT) /100.0;   

	SELECT @LAB=  [TIE] FROM  #PARTE3
	WHERE  NUM= convert ( int , @PERCENTIL) 


	SELECT 
	ROW_NUMBER() OVER(ORDER BY  [dbo].FN_TIEMPO_CALEN ( FECHA_DE_REGISTRO , FECHA_DE_ESTADO ) ) AS NUM,
	0  as TIE,
	[dbo].FN_TIEMPO_CALEN  ( FECHA_DE_REGISTRO, FECHA_DE_ESTADO )  as CAL
	INTO #PARTE4
	FROM [dbo].[TB_FUVEX] f
	where
	PRODUCTO='TARJETAS'
	and CONVERT (date , FECHA_DE_ESTADO) >=  CONVERT (date ,@FECHA)
	and CONVERT (date , FECHA_DE_ESTADO) <= CONVERT (date ,@FECHA_FIN)
	and case when FUERZA_DE_VENTA =  'COMCORP SAC'  then 'FISICO' else 'PAPERLESS' end = @PAPERLESS
	and ESTADO_ACTUAL='FORMALIZADO'
	and f.MODALIDAD_DE_VENTA=@MODALIDAD_DE_VENTA 


	SELECT @CAL=  [CAL] FROM  #PARTE4
	WHERE  NUM= convert ( int , ceiling(@PERCENTIL)) 

	DROP TABLE #PARTE3
	DROP TABLE #PARTE4 

END 

if @COUNT>0 
	begin 
		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN ,  @LAB+1,@TIPO ,@MODALIDAD_DE_VENTA ,@PAPERLESS ,'DÍAS ÚTILES' , 'MES')

		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN ,  @CAL+1,@TIPO,@MODALIDAD_DE_VENTA , @PAPERLESS ,'DÍAS CALENDARIO' , 'MES')

	end 
	else 
	begin 
		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN ,  0,@TIPO ,@MODALIDAD_DE_VENTA ,@PAPERLESS ,'DÍAS ÚTILES' , 'MES')

		INSERT INTO TB_FUVEX_PERCENTIL
		VALUES (@FECHA_FIN ,  0,@TIPO,@MODALIDAD_DE_VENTA , @PAPERLESS ,'DÍAS CALENDARIO' , 'MES')
	end 
END 

GO
/****** Object:  StoredProcedure [dbo].[USP_TB_FUVEX_SUBIR]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 16/04/2020
-- Description: Stored Procedure para cargar bases de FUVEX
-- =============================================


CREATE PROCEDURE [dbo].[USP_TB_FUVEX_SUBIR]
( 
@archivo varchar(150),
@mes int,
@año int
)
AS

BEGIN


DELETE FROM TB_FUVEX

CREATE TABLE #TB_FUVEX_TEMP(
	[CLIENTE_NEGATIVO] [varchar](20) NULL,
	[CR] [varchar](100) NULL,
	[VD] [varchar](30) NULL,
	[VL] [varchar](30) NULL,
	[FUERZA_DE_VENTA] [varchar](100) NULL,
	[MODALIDAD_DE_VENTA] [varchar](30) NULL,
	[COD_PRODUCTO] [varchar](20) NULL,
	[PRODUCTO] [varchar](30) NULL,
	[COD_SUB_PRODUCTO] [varchar](15) NULL,
	[SUB_PRODUCTO] [varchar](100) NULL,
	[ADICIONAL] [varchar](100) NULL,
	[NRO_DE_SOLICITUD] [varchar](30) NULL,
	[DOI] [varchar](30) NULL,
	[AP_PATERNO] [varchar](60) NULL,
	[AP_MATERNO] [varchar](60) NULL,
	[NOMBRE_CLIENTE] [varchar](60) NULL,
	[DIRECCION_CLIENTE] [varchar](100) NULL,
	[TELEFONO_CLIENTE] [varchar](30) NULL,
	[CELULAR_CLIENTE] [varchar](30) NULL,
	[ORIGEN] [varchar](100) NULL,
	[FECHA_RVGL] [varchar](100) NULL,
	[FECHA_DE_REGISTRO] [varchar](100) NULL,
	[FECHA_DE_ESTADO] [varchar](100) NULL,
	[ESTADO_ACTUAL] [varchar](30) NULL,
	[MONEDA_SOLICITADA] [varchar](10) NULL,
	[MONTO_SOLICITADO] [varchar](100) NULL,
	[MONEDA_APROBADA] [varchar](10) NULL,
	[MONTO_APROBADO] [varchar](100) NULL,
	[FECHA_FORMALIZ_OPER] [varchar](100) NULL,
	[FECHA_ESTADO_COMISION] [varchar](100) NULL,
	[ESTADO_DE_COMISION] [varchar](15) NULL,
	[FECHA_ESTADO_ALTAMIRA] [varchar](100) NULL,
	[ESTADO_DE_ALTAMIRA] [varchar](50) NULL,
	[PROPIEDAD_DE_PRODUCTO] [varchar](100) NULL,
	[NRO_CONTRATO] [varchar](50) NULL,
	[CODIGO_DE_JEFE] [varchar](20) NULL,
	[JEFE] [varchar](100) NULL,
	[CODIGO_DE_EJECUTIVO] [varchar](10) NULL,
	[EJECUTIVO] [varchar](100) NULL,
	[COD_OFICINA_ASIGNADA] [varchar](100) NULL,
	[OBSERVACIONES] [ntext] NULL,
	[ULTIMA_PERSONA_ATENDIO] [varchar](100) NULL,
	[RESPONSABLE_ACTUAL] [varchar](100) NULL,
	[CLIENTE_VIP] [varchar](10) NULL,
	[PAGO_DE_HABERES] [varchar](10) NULL,
	[TIPO_DE_CAPTACION] [varchar](55) NULL,
	[CANAL_DE_VENTA] [varchar](100) NULL,
	[COLECTIVO] [varchar](100) NULL,
	[OBS_RIESGOS] [varchar](100) NULL,
	[FONDO_APERTURADO] [varchar](100) NULL,
	[ORIGEN_DE_FONDO] [varchar](100) NULL,
	[PROCEDENCIA_DE_FONDOS] [varchar](100) NULL,
	[SEGMENTO_PROMOTOR] [varchar](100) NULL,
	[CLIENTE] [varchar](10) NULL,
	[RAZON_SOCIAL] [varchar](900) NULL,
	[RUC] [varchar](20) NULL,
	[PREMIO_CTS] [varchar](100) NULL,
	[RUC_BD] [varchar](100) NULL,
	[SUB_PRODUCTO2] [nvarchar](100) NULL,
	[DEALER] [varchar](100) NULL,
	[VENDEDOR] [varchar](100) NULL,
	[MARCA] [varchar](100) NULL,
	[EVENTO] [varchar](max) NULL
)


DECLARE @FILA_BULK_COUNT INT; 
DECLARE @path1 varchar(100) = '\\172.17.1.51\mp\DATA-CMI-CS\' +@archivo +'.csv' ;
DECLARE @SQL_BULK VARCHAR(MAX)
-------

SET @SQL_BULK = 'BULK INSERT #TB_FUVEX_TEMP FROM ''' + @path1 + ''' WITH
        (
     
        FIELDTERMINATOR = ''¬'',
        ROWTERMINATOR = ''\n''
  
        )'

EXEC (@SQL_BULK)


SET @FILA_BULK_COUNT =  (SELECT @@ROWCOUNT)

IF(@FILA_BULK_COUNT > 0)
	BEGIN

	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('CARGADO',@archivo,GETDATE())

	END
ELSE
	BEGIN

	INSERT INTO TB_HISTORIAL_CARGAS_CSV VALUES ('PENDIENTE',@archivo,GETDATE())

	END



DELETE FROM TB_FUVEX
WHERE MONTH(FECHA_DE_ESTADO) = @mes AND
		 YEAR(FECHA_DE_ESTADO) = @año

INSERT INTO TB_FUVEX
SELECT 
	RTRIM(LTRIM( FUERZA_DE_VENTA)),
	RTRIM(LTRIM(MODALIDAD_DE_VENTA)),
	RTRIM(LTRIM(PRODUCTO)),
	RTRIM(LTRIM(COD_SUB_PRODUCTO)),
	RTRIM(LTRIM(SUB_PRODUCTO)),
	RTRIM(LTRIM(NRO_DE_SOLICITUD)),
	RTRIM(LTRIM(DOI)),
	RTRIM(LTRIM(FECHA_DE_REGISTRO)),
	RTRIM(LTRIM(FECHA_DE_ESTADO)),
	RTRIM(LTRIM(ESTADO_ACTUAL)),
	RTRIM(LTRIM(FECHA_FORMALIZ_OPER)),
	RTRIM(LTRIM(FECHA_ESTADO_COMISION)),
	RTRIM(LTRIM(FECHA_ESTADO_ALTAMIRA)),
	RTRIM(LTRIM(ESTADO_DE_ALTAMIRA)),
	RTRIM(LTRIM(TIPO_DE_CAPTACION)),
	RTRIM(LTRIM(CANAL_DE_VENTA)),
	RTRIM(LTRIM(SUB_PRODUCTO2))
	FROM #TB_FUVEX_TEMP

END
GO
/****** Object:  StoredProcedure [dbo].[USP_TB_GIFOLE_FUNNEL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 04/09/2020
-- Description:	Procedure para sacar el funnel de Gifole, expedientes INGRESOS y FORMALIZADOS
-- =============================================
CREATE PROCEDURE [dbo].[USP_TB_GIFOLE_FUNNEL]
	(@MES INT, @AÑO INT)
AS
BEGIN

DECLARE @FECHA_FIN DATE;
SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)	
------------------------------>>> REPROCESO
DELETE FROM TB_GIFOLE_FUNNEL
WHERE FECHA_PROCESO = @FECHA_FIN
------------------------------>>> REPROCESO

CREATE TABLE #FECHAS_REGISTRO_REALES
(codigo int identity(1,1),
base varchar(20),
fecha_real_registro datetime,
expediente varchar(10))

CREATE TABLE #FORMALIZADOS
(codigo int identity(1,1),
base varchar(30),
cantidad int)

--------------------------------------------------------------------------// INGRESOS
INSERT INTO #FECHAS_REGISTRO_REALES
SELECT 'TITULARES', (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
		WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
		NRO_DOCUMENTO
FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_REGISTRO) = @MES AND YEAR(FECHA_HORA_REGISTRO) = @AÑO
	  
UNION ALL

SELECT 'ADICIONALES', (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
		WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
		CODIGO_CENTRAL
FROM TB_CS_TC_ADICIONAL_GIFOLE
WHERE MONTH(FECHA_HORA_REGISTRO) = @MES AND YEAR(FECHA_HORA_REGISTRO) = @AÑO


------------------------------------------------------------------------/// #FORMALIZADOS	 
INSERT INTO #FORMALIZADOS
SELECT 'TITULARES FORMALIZADOS', COUNT(NRO_DOCUMENTO)
FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')

UNION ALL

SELECT 'ADICIONALES FORMALIZADOS', COUNT(CODIGO_CENTRAL)
FROM TB_CS_TC_ADICIONAL_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')


--------------------------------------->>>
INSERT INTO TB_GIFOLE_FUNNEL
SELECT 'TARJETA DE CREDITO', 'INGRESOS', ISNULL(COUNT(CASE WHEN MONTH(fecha_real_registro) = @MES THEN expediente END),0) AS cantidad,@FECHA_FIN
FROM #FECHAS_REGISTRO_REALES
WHERE MONTH(fecha_real_registro) = @MES AND YEAR(fecha_real_registro) = @AÑO

UNION ALL

SELECT 'TARJETA DE CREDITO', 'FORMALIZADOS', ISNULL(SUM(cantidad),0) AS cantidad,@FECHA_FIN
FROM #FORMALIZADOS

END

GO
/****** Object:  StoredProcedure [dbo].[USP_TC_GIFOLE_RESUMEN_MENSUAL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 27/08/2020
-- Description:	Calculo de indicadores Tarjetas de Credito Titulares y Adicionales (GIFOLE)
-- =============================================
CREATE PROCEDURE [dbo].[USP_TC_GIFOLE_RESUMEN_MENSUAL] 
	-- Add the parameters for the stored procedure here
	(@MES INT, @AÑO INT)
AS

BEGIN

DECLARE @FECHA_FIN DATE;
SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

CREATE TABLE #INGRESOS_RECHAZOS(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)

CREATE TABLE #CUMPLEN_ANS_GO(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)

	CREATE TABLE #PROCESADO_APROBADOSAUTO(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)	

	CREATE TABLE #A_CALCULAR_FORMALIZACION(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)	

CREATE TABLE #PRE_CALCULO_ANS(	
	[DNI_CC] [VARCHAR](10) NULL,
	[BASE] [VARCHAR](20) NULL,
	[FECHA_REAL_REGISTRO] [datetime] NULL,	
	[FECHA_HORA_MODIFICACION] [datetime] NULL,	
	[FECHA] [date],
)

INSERT INTO #INGRESOS_RECHAZOS
SELECT	 'TARJETA DE CREDITO',
		'INGRESOS TITULARES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_REGISTRO) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_REGISTRO) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_REGISTRO) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_REGISTRO) = @MES THEN 1 END),0) AS total

	FROM TB_CS_TC_GIFOLE 			

	WHERE MONTH(FECHA_HORA_REGISTRO) = @MES
	  AND YEAR(FECHA_HORA_REGISTRO) = @AÑO
	  
	UNION ALL

	SELECT	 'TARJETA DE CREDITO',
		'INGRESOS ADICIONALES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_REGISTRO) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_REGISTRO) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_REGISTRO) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_REGISTRO) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_REGISTRO) = @MES THEN 1 END),0) AS total

	FROM TB_CS_TC_ADICIONAL_GIFOLE 			

	WHERE MONTH(FECHA_HORA_REGISTRO) = @MES
	  AND YEAR(FECHA_HORA_REGISTRO) = @AÑO


	  UNION ALL

	  SELECT 'TARJETA DE CREDITO',
		'RECHAZOS TITULARES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS total

	FROM TB_CS_TC_GIFOLE 			

	WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO = 'RECHAZADO'

	  UNION ALL


	SELECT	 'TARJETA DE CREDITO',
		'RECHAZOS ADICIONALES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS total

	FROM TB_CS_TC_ADICIONAL_GIFOLE 			

	WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO = 'RECHAZADO'	  

INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1, mes2, mes3)
	  SELECT  'TARJETA DE CREDITO',
		 '% RECHAZO TITULARES' AS DESCRIPCION,
		 8 AS VO,
		@FECHA_FIN AS fecha_proceso,

		CAST(a.dia1*100./ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
		CAST(a.dia2*100./ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02', 
		CAST(a.dia3*100./ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
		CAST(a.dia4*100./ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
		CAST(a.dia5*100./ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
		CAST(a.dia6*100./ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
		CAST(a.dia7*100./ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
		CAST(a.dia8*100./ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
		CAST(a.dia9*100./ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
		CAST(a.dia10*100./ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
		CAST(a.dia11*100./ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
		CAST(a.dia12*100./ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
		CAST(a.dia13*100./ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
		CAST(a.dia14*100./ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
		CAST(a.dia15*100./ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
		CAST(a.dia16*100./ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
		CAST(a.dia17*100./ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
		CAST(a.dia18*100./ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
		CAST(a.dia19*100./ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
		CAST(a.dia20*100./ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
		CAST(a.dia21*100./ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
		CAST(a.dia22*100./ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
		CAST(a.dia23*100./ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
		CAST(a.dia24*100./ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
		CAST(a.dia25*100./ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
		CAST(a.dia26*100./ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
		CAST(a.dia27*100./ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
		CAST(a.dia28*100./ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
		CAST(a.dia29*100./ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
		CAST(a.dia30*100./ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
		CAST(a.dia31*100./ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
		0,
		0,
		CAST(a.total*100./ISNULL(NULLIF(b.total,0),1) as decimal(18,2)) AS 'total'
				
		FROM #INGRESOS_RECHAZOS a LEFT JOIN  #INGRESOS_RECHAZOS b
		ON a.codigo = 3	WHERE b.codigo = 1
		
		UNION ALL

		SELECT  'TARJETA DE CREDITO',
		 '% RECHAZO ADICIONALES' AS DESCRIPCION,
		 27 AS VO,
		@FECHA_FIN AS fecha_proceso,

		CAST(a.dia1*100./ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
		CAST(a.dia2*100./ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02', 
		CAST(a.dia3*100./ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
		CAST(a.dia4*100./ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
		CAST(a.dia5*100./ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
		CAST(a.dia6*100./ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
		CAST(a.dia7*100./ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
		CAST(a.dia8*100./ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
		CAST(a.dia9*100./ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
		CAST(a.dia10*100./ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
		CAST(a.dia11*100./ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
		CAST(a.dia12*100./ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
		CAST(a.dia13*100./ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
		CAST(a.dia14*100./ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
		CAST(a.dia15*100./ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
		CAST(a.dia16*100./ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
		CAST(a.dia17*100./ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
		CAST(a.dia18*100./ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
		CAST(a.dia19*100./ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
		CAST(a.dia20*100./ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
		CAST(a.dia21*100./ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
		CAST(a.dia22*100./ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
		CAST(a.dia23*100./ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
		CAST(a.dia24*100./ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
		CAST(a.dia25*100./ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
		CAST(a.dia26*100./ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
		CAST(a.dia27*100./ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
		CAST(a.dia28*100./ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
		CAST(a.dia29*100./ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
		CAST(a.dia30*100./ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
		CAST(a.dia31*100./ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
		0,
		0,
		CAST(a.total*100./ISNULL(NULLIF(b.total,0),1) as decimal(18,2)) AS 'total'
				
		FROM #INGRESOS_RECHAZOS a LEFT JOIN  #INGRESOS_RECHAZOS b
		ON a.codigo = 4	WHERE b.codigo = 2

-------------------------------------------------------------------------------// CALCULO CUMPLIMIENTO ANS - TC GIFOLE

INSERT INTO #PRE_CALCULO_ANS
SELECT NRO_DOCUMENTO, 'TITULARES',
	   (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
			 WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
			 FECHA_HORA_MODIFICACION, CONVERT(DATE,FECHA_HORA_MODIFICACION)
FROM  TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')

UNION ALL

SELECT CODIGO_CENTRAL,'ADICIONALES',
	   (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
			 WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
			 FECHA_HORA_MODIFICACION, CONVERT(DATE,FECHA_HORA_MODIFICACION)
FROM TB_CS_TC_ADICIONAL_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')


SELECT DNI_CC, FECHA_REAL_REGISTRO AS FECHA_REAL_REGISTRO, FECHA_HORA_MODIFICACION AS FECHA_HORA_MODIFICACION,
DATEDIFF(HOUR, FECHA_REAL_REGISTRO, FECHA_HORA_MODIFICACION) AS EFECTIVIDAD, FECHA AS FECHA
INTO #PRE_ANS	
FROM #PRE_CALCULO_ANS


SELECT DNI_CC, FECHA_REAL_REGISTRO, FECHA_HORA_MODIFICACION, EFECTIVIDAD, 
(CASE WHEN EFECTIVIDAD < 24 THEN 'SI CUMPLE' ELSE 'NO CUMPLE' END) AS CUMPLE_ANS, FECHA
INTO #CUMPLE_ANS
FROM #PRE_ANS
ORDER BY FECHA


INSERT INTO #CUMPLEN_ANS_GO
SELECT 'TARJETA DE CREDITO' as producto,
		'CUMPLEN ANS' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA) = 1 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 2 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA) = 3 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA) = 4 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 5 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 6 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 7 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 8 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 9 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 10 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 11 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 12 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 13 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 14 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 15 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 16 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 17 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 18 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 19 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 20 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 21 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 22 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 23 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 24 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 25 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 26 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 27 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 28 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 29 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 30 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 31 AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA) = @MES AND CUMPLE_ANS = 'SI CUMPLE' THEN 1 END),0) AS total
	
	FROM #CUMPLE_ANS

	UNION ALL

	SELECT 'TARJETA DE CREDITO' as producto,
		'TODO' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA) = 1  THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 2  THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA) = 3  THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA) = 4  THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 5  THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 6  THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 7  THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 8  THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 9  THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 10  THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 11  THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 12  THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 13  THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 14  THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 15  THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 16  THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 17  THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 18  THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 19  THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 20  THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 21  THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 22  THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 23  THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 24  THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 25  THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 26  THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 27  THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 28  THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 29  THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 30  THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA) = 31  THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA) = @MES  THEN 1 END),0) AS total	
	FROM #CUMPLE_ANS		
	
	
INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1, mes2, mes3)
	SELECT  'TARJETA DE CREDITO',
	 'CUMPLIMIENTO DE ANS - EFECTIVIDAD - GIFOLE' AS DESCRIPCION,
	 95 AS VO,
	@FECHA_FIN AS fecha_proceso,
	
	CAST(a.dia1*100./ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
	CAST(a.dia2*100./ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02', 
	CAST(a.dia3*100./ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
	CAST(a.dia4*100./ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
	CAST(a.dia5*100./ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
	CAST(a.dia6*100./ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
	CAST(a.dia7*100./ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
	CAST(a.dia8*100./ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
	CAST(a.dia9*100./ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
	CAST(a.dia10*100./ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
	CAST(a.dia11*100./ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
	CAST(a.dia12*100./ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
	CAST(a.dia13*100./ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
	CAST(a.dia14*100./ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
	CAST(a.dia15*100./ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
	CAST(a.dia16*100./ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
	CAST(a.dia17*100./ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
	CAST(a.dia18*100./ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
	CAST(a.dia19*100./ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
	CAST(a.dia20*100./ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
	CAST(a.dia21*100./ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
	CAST(a.dia22*100./ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
	CAST(a.dia23*100./ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
	CAST(a.dia24*100./ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
	CAST(a.dia25*100./ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
	CAST(a.dia26*100./ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
	CAST(a.dia27*100./ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
	CAST(a.dia28*100./ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
	CAST(a.dia29*100./ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
	CAST(a.dia30*100./ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
	CAST(a.dia31*100./ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
	0,
	0,
	CAST(a.total*100./ISNULL(NULLIF(b.total,0),1) as decimal(18,2)) AS 'total'
		
	FROM #CUMPLEN_ANS_GO a LEFT JOIN  #CUMPLEN_ANS_GO b
	ON a.codigo = 1	WHERE b.codigo = 2

-------------------------------------------------------------------------------// EXITO EN LA FORMALIZACION DE OPERACIONES
	
	INSERT INTO #PROCESADO_APROBADOSAUTO

	SELECT	'TARJETA DE CREDITO',
		'PROCESADOS TITULARES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS total
	
	FROM TB_CS_TC_GIFOLE		

	WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')

	  UNION ALL

	  SELECT	'TARJETA DE CREDITO',
		'PROCESADOS ADICIONALES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE	WHEN DAY(FECHA_HORA_MODIFICACION) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE	WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS total
	
	FROM TB_CS_TC_ADICIONAL_GIFOLE  			

	WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  



	INSERT INTO #A_CALCULAR_FORMALIZACION
	SELECT  'TARJETA DE CREDITO' as producto,
	 'EXPEDIENTES INGRESADOS GIFOLE' AS descripcion,	 
	@FECHA_FIN AS fecha_proceso,
	
	a.dia1 + b.dia1   AS '01', 
	a.dia2 + b.dia2  AS '02', 
	a.dia3 + b.dia3  AS '03',
	a.dia4 + b.dia4  AS '04',
	a.dia5 + b.dia5  AS '05',
	a.dia6 + b.dia6  AS '06',
	a.dia7 + b.dia7  AS '07',
	a.dia8 + b.dia8  AS '08',
	a.dia9 + b.dia9  AS '09',
	a.dia10 + b.dia10  AS '10',
	a.dia11 + b.dia11  AS '11',
	a.dia12 + b.dia12  AS '12',
	a.dia13 + b.dia13  AS '13',
	a.dia14 + b.dia14  AS '14',
	a.dia15 + b.dia15  AS '15',
	a.dia16 + b.dia16  AS '16',
	a.dia17 + b.dia17  AS '17',
	a.dia18 + b.dia18  AS '18',
	a.dia19 + b.dia19  AS '19',
	a.dia20 + b.dia20  AS '20',
	a.dia21 + b.dia21  AS '21',
	a.dia22 + b.dia22  AS '22',
	a.dia23 + b.dia23  AS '23',
	a.dia24 + b.dia24  AS '24',
	a.dia25 + b.dia25  AS '25',
	a.dia26 + b.dia26  AS '26',
	a.dia27 + b.dia27  AS '27',
	a.dia28 + b.dia28  AS '28',
	a.dia29 + b.dia29  AS '29',
	a.dia30 + b.dia30  AS '30',
	a.dia31 + b.dia31  AS '31',
	a.total + b.total  AS 'total'

	FROM #INGRESOS_RECHAZOS a LEFT JOIN  #INGRESOS_RECHAZOS b
	ON a.codigo = 1	WHERE b.codigo = 2

	UNION ALL

	SELECT  'TARJETA DE CREDITO' as producto,
	 'EXPEDIENTES PROCESADOS GIFOLE' AS descripcion,	 
	@FECHA_FIN AS fecha_proceso,
	
	a.dia1 + b.dia1   AS '01', 
	a.dia2 + b.dia2  AS '02', 
	a.dia3 + b.dia3  AS '03',
	a.dia4 + b.dia4  AS '04',
	a.dia5 + b.dia5  AS '05',
	a.dia6 + b.dia6  AS '06',
	a.dia7 + b.dia7  AS '07',
	a.dia8 + b.dia8  AS '08',
	a.dia9 + b.dia9  AS '09',
	a.dia10 + b.dia10  AS '10',
	a.dia11 + b.dia11  AS '11',
	a.dia12 + b.dia12  AS '12',
	a.dia13 + b.dia13  AS '13',
	a.dia14 + b.dia14  AS '14',
	a.dia15 + b.dia15  AS '15',
	a.dia16 + b.dia16  AS '16',
	a.dia17 + b.dia17  AS '17',
	a.dia18 + b.dia18  AS '18',
	a.dia19 + b.dia19  AS '19',
	a.dia20 + b.dia20  AS '20',
	a.dia21 + b.dia21  AS '21',
	a.dia22 + b.dia22  AS '22',
	a.dia23 + b.dia23  AS '23',
	a.dia24 + b.dia24  AS '24',
	a.dia25 + b.dia25  AS '25',
	a.dia26 + b.dia26  AS '26',
	a.dia27 + b.dia27  AS '27',
	a.dia28 + b.dia28  AS '28',
	a.dia29 + b.dia29  AS '29',
	a.dia30 + b.dia30  AS '30',
	a.dia31 + b.dia31  AS '31',
	a.total + b.total  AS 'total'	

	FROM #PROCESADO_APROBADOSAUTO a LEFT JOIN  #PROCESADO_APROBADOSAUTO b
	ON a.codigo = 1	WHERE b.codigo = 2
	

INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1, mes2, mes3)
	SELECT  'TARJETA DE CREDITO',
	 'EXITO EN LA FORMALIZACION DE OP. GIFOLE' AS DESCRIPCION,
	 95 AS VO,
	@FECHA_FIN AS fecha_proceso,
	
	CAST(a.dia1*100./ISNULL(NULLIF(b.dia1,0),1) as decimal(18,2))  AS '01', 
	CAST(a.dia2*100./ISNULL(NULLIF(b.dia2,0),1) as decimal(18,2)) AS '02', 
	CAST(a.dia3*100./ISNULL(NULLIF(b.dia3,0),1) as decimal(18,2)) AS '03',
	CAST(a.dia4*100./ISNULL(NULLIF(b.dia4,0),1) as decimal(18,2)) AS '04',
	CAST(a.dia5*100./ISNULL(NULLIF(b.dia5,0),1) as decimal(18,2)) AS '05',
	CAST(a.dia6*100./ISNULL(NULLIF(b.dia6,0),1) as decimal(18,2)) AS '06',
	CAST(a.dia7*100./ISNULL(NULLIF(b.dia7,0),1) as decimal(18,2)) AS '07',
	CAST(a.dia8*100./ISNULL(NULLIF(b.dia8,0),1) as decimal(18,2)) AS '08',
	CAST(a.dia9*100./ISNULL(NULLIF(b.dia9,0),1) as decimal(18,2)) AS '09',
	CAST(a.dia10*100./ISNULL(NULLIF(b.dia10,0),1) as decimal(18,2)) AS '10',
	CAST(a.dia11*100./ISNULL(NULLIF(b.dia11,0),1) as decimal(18,2)) AS '11',
	CAST(a.dia12*100./ISNULL(NULLIF(b.dia12,0),1) as decimal(18,2)) AS '12',
	CAST(a.dia13*100./ISNULL(NULLIF(b.dia13,0),1) as decimal(18,2)) AS '13',
	CAST(a.dia14*100./ISNULL(NULLIF(b.dia14,0),1) as decimal(18,2)) AS '14',
	CAST(a.dia15*100./ISNULL(NULLIF(b.dia15,0),1) as decimal(18,2)) AS '15',
	CAST(a.dia16*100./ISNULL(NULLIF(b.dia16,0),1) as decimal(18,2)) AS '16',
	CAST(a.dia17*100./ISNULL(NULLIF(b.dia17,0),1) as decimal(18,2)) AS '17',
	CAST(a.dia18*100./ISNULL(NULLIF(b.dia18,0),1) as decimal(18,2)) AS '18',
	CAST(a.dia19*100./ISNULL(NULLIF(b.dia19,0),1) as decimal(18,2)) AS '19',
	CAST(a.dia20*100./ISNULL(NULLIF(b.dia20,0),1) as decimal(18,2)) AS '20',
	CAST(a.dia21*100./ISNULL(NULLIF(b.dia21,0),1) as decimal(18,2)) AS '21',
	CAST(a.dia22*100./ISNULL(NULLIF(b.dia22,0),1) as decimal(18,2)) AS '22',
	CAST(a.dia23*100./ISNULL(NULLIF(b.dia23,0),1) as decimal(18,2)) AS '23',
	CAST(a.dia24*100./ISNULL(NULLIF(b.dia24,0),1) as decimal(18,2)) AS '24',
	CAST(a.dia25*100./ISNULL(NULLIF(b.dia25,0),1) as decimal(18,2)) AS '25',
	CAST(a.dia26*100./ISNULL(NULLIF(b.dia26,0),1) as decimal(18,2)) AS '26',
	CAST(a.dia27*100./ISNULL(NULLIF(b.dia27,0),1) as decimal(18,2)) AS '27',
	CAST(a.dia28*100./ISNULL(NULLIF(b.dia28,0),1) as decimal(18,2)) AS '28',
	CAST(a.dia29*100./ISNULL(NULLIF(b.dia29,0),1) as decimal(18,2)) AS '29',
	CAST(a.dia30*100./ISNULL(NULLIF(b.dia30,0),1) as decimal(18,2)) AS '30',
	CAST(a.dia31*100./ISNULL(NULLIF(b.dia31,0),1) as decimal(18,2)) AS '31',
	0,
	0,
	CAST(a.total*100./ISNULL(NULLIF(b.total,0),1) as decimal(18,2)) AS 'total'
	
	FROM #A_CALCULAR_FORMALIZACION a LEFT JOIN  #A_CALCULAR_FORMALIZACION b
	ON a.codigo = 2	WHERE b.codigo = 1	
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TC_GIFOLE_TIEMPOS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 17/06/2020
-- Description:	Procedure que saca los percentiles de todas las fechas halladas de mes dado y año dados
-- =============================================
CREATE PROCEDURE [dbo].[USP_TC_GIFOLE_TIEMPOS] (@MES int,@AÑO int)

AS

BEGIN

DECLARE @FECHA datetime
DECLARE @FECHA_INI datetime
DECLARE @FECHA_MAX datetime

DECLARE @PERCENTIL_MES_ACTUAL decimal(10,2);

DECLARE @CONTADOR int = 1;
DECLARE @MAX int;
---------------------------------------------------------------------------------------------REPROCESAR
DELETE FROM TB_CS_TC_GIFOLE_PERCENTIL 
WHERE MONTH(FECHA) = @MES and YEAR(FECHA) = @AÑO
-------------------------------------------------------------------------------------------------------
CREATE TABLE #FECHAS
( Id int identity(1,1) NOT NULL PRIMARY KEY,
Fecha varchar(255) NULL,
);
-------------------------------------------------------------
SET @FECHA_INI = (SELECT DATEFROMPARTS (@AÑO , @MES , 01)) -- armo mi primer dia
--set @fecha_FIN = EOMONTH(@fecha_ini) -- ultimo dia del mes segun mi fecha inicial

SELECT @FECHA_MAX =(SELECT MAX(FECHA_HORA_REGISTRO) 
						FROM TB_CS_TC_GIFOLE
						WHERE MONTH (FECHA_HORA_REGISTRO) = @MES
						AND YEAR(FECHA_HORA_REGISTRO) = @AÑO)
-------------------------------------------------------------						
INSERT INTO #FECHAS (Fecha)
SELECT DISTINCT (CONVERT(DATE, FECHA_HORA_REGISTRO))
FROM TB_CS_TC_GIFOLE
where MONTH(CONVERT(DATE, FECHA_HORA_REGISTRO)) =  @MES
and  year(CONVERT(DATE, FECHA_HORA_REGISTRO)) = @AÑO
ORDER BY 1
-------------------------------------------------------------
-------------------------------------------------------------WHILE FECHAS
SET @MAX = (SELECT COUNT(Id) FROM #FECHAS)

WHILE @CONTADOR <= @MAX
		BEGIN
		SET @FECHA = (SELECT FECHA FROM #FECHAS WHERE Id=@CONTADOR)		
		
		-----PRINT  CONVERT(DATE,@fecha)
		EXEC USP_TC_GIFOLE_TIEMPOS_CALCULO @FECHA

		SET @CONTADOR = @CONTADOR + 1
		END	
		------SELECT * FROM TB_CS_TC_GIFOLE_PERCENTIL
		------WHERE MONTH(FECHA) = @MES and YEAR(FECHA) = @AÑO
		------ORDER BY FECHA

------------------------------------------------//PERCENTIL MES
EXEC USP_TC_GIFOLE_TIEMPOS_CALCULO_MES @MES, @AÑO
		
SET @PERCENTIL_MES_ACTUAL = (SELECT PERCENTIL FROM TB_CS_TC_GIFOLE_PERCENTIL_MES WHERE MES = @MES AND ANIO = @AÑO)
------------------------------------------------//PERCENTIL MES

---INSERTAR EN TABLA PLD_TC_CONVENIO (RESUMEN MENSUAL)
INSERT INTO PLD_TC_CONVENIO (producto,descripcion,valor_objetivo, fecha_proceso, dia1, dia2, dia3, dia4, dia5, dia6, dia7, dia8, dia9, dia10, dia11, dia12, dia13, dia14, dia15, dia16, dia17, dia18, dia19, dia20, dia21, dia22, dia23, dia24, dia25, dia26, dia27, dia28, dia29, dia30, dia31, mes1, mes2, mes3)
SELECT 
		'TARJETA DE CREDITO',
		'TIEMPO DE FORMALIZACION TC GIFOLE', 
		1 AS 'Valor Objetivo',
		@FECHA_MAX,
		SUM(ISNULL(CASE WHEN DAY(FECHA)=1 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=2 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=3 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=4 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=5 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=6 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=7 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=8 THEN PERCENTIL END,0)), 
		SUM(ISNULL(CASE WHEN DAY(FECHA)=9 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=10 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=11 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=12 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=13 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=14 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=15 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=16 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=17 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=18 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=19 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=20 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=21 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=22 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=23 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=24 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=25 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=26 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=27 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=28 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=29 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=30 THEN PERCENTIL END,0)),
		SUM(ISNULL(CASE WHEN DAY(FECHA)=31 THEN PERCENTIL END,0)),
		0,
		0,		
		@PERCENTIL_MES_ACTUAL

		FROM TB_CS_TC_GIFOLE_PERCENTIL
		WHERE MONTH(FECHA) = @MES
		AND YEAR(FECHA) = @AÑO
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TC_GIFOLE_TIEMPOS_CALCULO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 17/06/2020
-- Description:	Procedure que saca el percentil dada una fecha de tiempos de tarjetaS de credito tramitadas por internet
-- =============================================
CREATE PROCEDURE [dbo].[USP_TC_GIFOLE_TIEMPOS_CALCULO] (@FECHA DATE)
AS
BEGIN

DECLARE @COUNT INT;
DECLARE @COUNT_TITULARES INT;
DECLARE @COUNT_ADICIONALES INT;
DECLARE @PERCENTIL numeric(10,5) = 0.1
DECLARE @CAL DECIMAL(10,2) = 0.0;

CREATE TABLE #REAL_FECHAS_CALCULO(	
	[DNI_CC] [VARCHAR](10) NULL,
	[BASE] [VARCHAR](20) NULL,
	[FECHA_REAL_REGISTRO] [datetime] NULL,	
	[FECHA_HORA_MODIFICACION] [datetime] NULL	
)
CREATE TABLE #GIFOLE_PERCENTIL(	
	[FECHA] [date] NULL,
	[PERCENTIL] [decimal](10, 2) NULL
)
CREATE TABLE #TIEMPOS(
	[ID] int identity(1,1) NOT NULL,	
	[TIEMPOS] [decimal](10, 3) NULL	
) 
--------------------------------//
SELECT  @COUNT_TITULARES =  COUNT(ID)
FROM  TB_CS_TC_GIFOLE
WHERE CONVERT (date, FECHA_HORA_MODIFICACION)=  CONVERT (date, @FECHA)
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 

SELECT @COUNT_ADICIONALES =  COUNT(ID)
FROM  TB_CS_TC_ADICIONAL_GIFOLE
WHERE CONVERT (date, FECHA_HORA_MODIFICACION)=  CONVERT (date, @FECHA)
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 


SET @COUNT = @COUNT_TITULARES + @COUNT_ADICIONALES;


if @COUNT=1
begin 
	set @PERCENTIL = 1 
end 
else 

begin 
	SET @PERCENTIL = 90.0 * (@COUNT) /100.0;
end 

INSERT INTO #REAL_FECHAS_CALCULO
SELECT NRO_DOCUMENTO, 'TITULARES',
	   (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
			 WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
			 FECHA_HORA_MODIFICACION
FROM  TB_CS_TC_GIFOLE
WHERE CONVERT(date,FECHA_HORA_MODIFICACION) = CONVERT (date, @FECHA)
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 
--AND NRO_DOCUMENTO = '25631587'

UNION ALL

SELECT CODIGO_CENTRAL,'ADICIONALES',
	   (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
			 WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
			 FECHA_HORA_MODIFICACION
FROM TB_CS_TC_ADICIONAL_GIFOLE
WHERE CONVERT(date,FECHA_HORA_MODIFICACION) = CONVERT (date, @FECHA)
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 


INSERT INTO #TIEMPOS
SELECT CAST(DATEDIFF(SECOND, FECHA_REAL_REGISTRO , FECHA_HORA_MODIFICACION)/86400.0 AS DECIMAL(10,4)) AS TIEMPO
FROM  #REAL_FECHAS_CALCULO
ORDER BY TIEMPO


SET @PERCENTIL = FLOOR(@PERCENTIL)

SELECT @CAL = TIEMPOS FROM #TIEMPOS
WHERE ID = CONVERT(INT,@PERCENTIL)


INSERT INTO TB_CS_TC_GIFOLE_PERCENTIL (FECHA,PERCENTIL)
--INSERT INTO #GIFOLE_PERCENTIL(FECHA,PERCENTIL)
VALUES (@FECHA, @CAL)

--SELECT * FROM #REAL_FECHAS_CALCULO
--SELECT * FROM #TIEMPOS
--SELECT CONVERT(INT,@PERCENTIL) as 'ID_PERC_POSICION'
--SELECT * FROM #GIFOLE_PERCENTIL

DROP TABLE #REAL_FECHAS_CALCULO
DROP TABLE #TIEMPOS
DROP TABLE #GIFOLE_PERCENTIL



END
GO
/****** Object:  StoredProcedure [dbo].[USP_TC_GIFOLE_TIEMPOS_CALCULO_MES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Didier Yépez Cabanillas
-- Create date: 19/06/2020
-- Description:	Procedure que saca el percentil de TC GIFOLE de un mes dado
-- =============================================
CREATE PROCEDURE [dbo].[USP_TC_GIFOLE_TIEMPOS_CALCULO_MES] (@MES INT, @ANO INT)

AS

BEGIN


DECLARE @COUNT INT;
DECLARE @COUNT_TITULARES INT;
DECLARE @COUNT_ADICIONALES INT;
DECLARE @PERCENTIL numeric(10,5) = 0.1
DECLARE @CAL DECIMAL(10,3) = 0.0;

DELETE FROM TB_CS_TC_GIFOLE_PERCENTIL_MES
WHERE MES = @MES AND ANIO = @ANO


CREATE TABLE #REAL_FECHAS_CALCULO(	
	[DNI_CC] [VARCHAR](10) NULL,
	[BASE] [VARCHAR](20) NULL,
	[FECHA_REAL_REGISTRO] [datetime] NULL,	
	[FECHA_HORA_MODIFICACION] [datetime] NULL	
)
CREATE TABLE #GIFOLE_PERCENTIL(	
	[MES] [int],
	[ANIO] [int],
	[PERCENTIL] [decimal](10, 3) NULL
)
CREATE TABLE #TIEMPOS(
	[ID] int identity(1,1) NOT NULL,	
	[TIEMPOS] [decimal](10, 3) NULL	
) 

--------------------------------//
--------------------------------//
SELECT  @COUNT_TITULARES =  COUNT(ID)
FROM  TB_CS_TC_GIFOLE
WHERE MONTH(CONVERT (date, FECHA_HORA_MODIFICACION))=  @MES
AND YEAR(CONVERT (date, FECHA_HORA_MODIFICACION))=  @ANO
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 


SELECT @COUNT_ADICIONALES =  COUNT(ID)
FROM  TB_CS_TC_ADICIONAL_GIFOLE
WHERE MONTH(CONVERT (date, FECHA_HORA_MODIFICACION))=  @MES
AND YEAR(CONVERT (date, FECHA_HORA_MODIFICACION))=  @ANO
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 

SET @COUNT = @COUNT_TITULARES + @COUNT_ADICIONALES;


SELECT  @COUNT =  COUNT(ID)
FROM  TB_CS_TC_GIFOLE
WHERE MONTH(CONVERT (date, FECHA_HORA_MODIFICACION))=  @MES
AND YEAR(CONVERT (date, FECHA_HORA_MODIFICACION))=  @ANO


if @COUNT=1
begin 
	set @PERCENTIL = 1 
end 
else 
begin 
	SET @PERCENTIL = 90.0 * (@COUNT) /100.0;
end 


INSERT INTO #REAL_FECHAS_CALCULO
SELECT NRO_DOCUMENTO, 'TITULARES',
	   (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
			 WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
			 FECHA_HORA_MODIFICACION
FROM  TB_CS_TC_GIFOLE
WHERE MONTH(CONVERT (date, FECHA_HORA_MODIFICACION))=  @MES
AND YEAR(CONVERT (date, FECHA_HORA_MODIFICACION))=  @ANO
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 
-----AND NRO_DOCUMENTO = '25631587'

UNION ALL

SELECT CODIGO_CENTRAL,'ADICIONALES',
	   (CASE WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Saturday' THEN DATEADD(DD,2,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +2, FECHA_HORA_REGISTRO), 2))) 
			 WHEN DATENAME(dw, FECHA_HORA_REGISTRO)='Sunday' THEN DATEADD(DD,1,DATEADD(hh, 9, DATEADD(dd, DATEDIFF(dd, +1, FECHA_HORA_REGISTRO), 1))) ELSE FECHA_HORA_REGISTRO END) AS FECHA_REAL_REGISTRO,
			 FECHA_HORA_MODIFICACION
FROM TB_CS_TC_ADICIONAL_GIFOLE
WHERE MONTH(CONVERT (date, FECHA_HORA_MODIFICACION))=  @MES
AND YEAR(CONVERT (date, FECHA_HORA_MODIFICACION))=  @ANO
AND ESTADO IN ('PROCESADO','PROCESADO NO ENVIO CORREO','APROBADO AUTO') 


INSERT INTO #TIEMPOS
SELECT CAST(DATEDIFF(SECOND, FECHA_REAL_REGISTRO , FECHA_HORA_MODIFICACION)/86400.0 AS DECIMAL(10,4)) AS TIEMPO
FROM  #REAL_FECHAS_CALCULO
ORDER BY TIEMPO


SET @PERCENTIL = FLOOR(@PERCENTIL)

SELECT @CAL = TIEMPOS FROM #TIEMPOS
WHERE ID = CONVERT(INT,@PERCENTIL)


INSERT INTO TB_CS_TC_GIFOLE_PERCENTIL_MES(MES,ANIO,PERCENTIL)
----INSERT INTO #GIFOLE_PERCENTIL(MES,ANIO,PERCENTIL)
VALUES (@MES,@ANO, @CAL)

----SELECT * FROM #REAL_FECHAS_CALCULO
----SELECT * FROM #TIEMPOS
----SELECT CONVERT(INT,@PERCENTIL) AS 'ID_PERC_POSICION'
----SELECT * FROM #GIFOLE_PERCENTIL

DROP TABLE #REAL_FECHAS_CALCULO
DROP TABLE #GIFOLE_PERCENTIL
DROP TABLE #TIEMPOS


---SELECT * FROM TB_CS_TC_GIFOLE_PERCENTIL_MES

END


GO
/****** Object:  StoredProcedure [dbo].[USP_TC_OPERACIONES_DESGLOSE_GIFOLE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 01/09/2020
-- Description:	Procedure para calcular el desglose de las operaciones GIFOLE
-- =============================================
CREATE PROCEDURE [dbo].[USP_TC_OPERACIONES_DESGLOSE_GIFOLE]
	(@MES INT, @AÑO INT)
AS
BEGIN


DECLARE @FECHA_FIN DATE;
SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

DELETE FROM TC_GIFOLE_OPERACIONES_DESGLOSE
WHERE fecha_proceso = @FECHA_FIN

CREATE TABLE #MONTOS(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](30) NULL,		
	[monto] [decimal](18, 2) NULL	
)

CREATE TABLE #PORCENTAJE_MONTOS(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[porcentaje] [decimal](18, 2) NULL	
)

CREATE TABLE #PORCENTAJE_OPERACIONES(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[porcentaje] [decimal](18, 2) NULL	
)

CREATE TABLE #TOTAL_OPERACIONES(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[operaciones] [decimal](18, 2) NULL	
)

CREATE TABLE #EXPEDIENTES_PROCESADOS(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[descripcion] [varchar](30) NULL,	
	[cantidad] [int] NULL	
)

CREATE TABLE #PARTE1(
	[codigo] [int] IDENTITY(1,1) NOT NULL,	
	[descripcion] [varchar](30) NULL,		
	[monto] [int] NULL,	
	[monto_porcentaje] [decimal](18, 2) NULL )


CREATE TABLE #PARTE2(
	[codigo] [int] IDENTITY(1,1) NOT NULL,		
	[operaciones] [int] NULL,	
	[operaciones_porcentaje] [decimal](18, 2) NULL	
)


----------------------------------------------------------/// MONTOS DE BASE TITULARES
INSERT INTO #MONTOS 

SELECT 'BANCA POR INTERNET' as CANAL, ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN MONTO END),0) AS MONTO_TOTAL
FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')
	  AND CANAL = 'BANCA POR INTERNET'

	  UNION ALL

SELECT 'BMMOVIL' as CANAL, ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN MONTO END),0) AS MONTO_TOTAL
FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')
	  AND CANAL = 'BMMOVIL'

	  UNION ALL

SELECT 'BMOVILWB' as CANAL, ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN MONTO END),0) AS MONTO_TOTAL
FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')
	  AND CANAL = 'BMOVILWB'

	  UNION ALL

SELECT 'ZONA_PUB' as CANAL, ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN MONTO END),0) AS MONTO_TOTAL
FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')
	  AND CANAL = 'ZONA_PUB'

	  UNION ALL

SELECT 'TOTAL' as CANAL, ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN MONTO END),0) AS MONTO_TOTAL
FROM TB_CS_TC_GIFOLE
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')
	  
	  

INSERT INTO #PORCENTAJE_MONTOS
SELECT cast(a.monto/ISNULL(NULLIF(b.monto,0),0) as decimal(18,2)) * 100 AS monto_porcentaje	
		
FROM #MONTOS a LEFT JOIN  #MONTOS b
ON a.codigo = 1	WHERE b.codigo = 5

UNION ALL	

SELECT cast(a.monto/ISNULL(NULLIF(b.monto,0),0) as decimal(18,2)) * 100 AS monto_porcentaje	
			
FROM #MONTOS a LEFT JOIN  #MONTOS b
ON a.codigo = 2	WHERE b.codigo = 5		

UNION ALL		
			
SELECT cast(a.monto/ISNULL(NULLIF(b.monto,0),0) as decimal(18,2)) * 100 AS monto_porcentaje	
			
FROM #MONTOS a LEFT JOIN  #MONTOS b
ON a.codigo = 3	WHERE b.codigo = 5
			
UNION ALL	

SELECT cast(a.monto/ISNULL(NULLIF(b.monto,0),0) as decimal(18,2)) * 100 AS monto_porcentaje	
			
FROM #MONTOS a LEFT JOIN  #MONTOS b
ON a.codigo = 4	WHERE b.codigo = 5	

UNION ALL	

SELECT 100		


INSERT INTO #PARTE1
select m.descripcion, m.monto, pm.porcentaje 
from #MONTOS m LEFT JOIN #PORCENTAJE_MONTOS pm
ON m.codigo = pm.codigo
----------------------------------------------------------/// EXPEDIENTES PROCESADOS DE TITULARES Y ADICIONALES
INSERT INTO #EXPEDIENTES_PROCESADOS
SELECT	'PROCESADOS BCA INTERNET' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'BANCA POR INTERNET'

UNION ALL

SELECT	'PROCESADOS BMMOVIL' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'BMMOVIL'
	  
UNION ALL

SELECT	'PROCESADOS BMOVILWB' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'BMOVILWB'


	  UNION ALL

SELECT	'PROCESADOS ZONA_PUB' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'ZONA_PUB'

	  	  UNION ALL

SELECT	'PROCESADOS TOTAL' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')

	  UNION ALL

SELECT	'PROCESADOS BCA INTERNET' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_ADICIONAL_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'BANCA POR INTERNET'

UNION ALL

SELECT	'PROCESADOS BMMOVIL' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_ADICIONAL_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'BMMOVIL'
	  
UNION ALL

SELECT	'PROCESADOS BMOVILWB' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_ADICIONAL_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'BMOVILWB'

	  UNION ALL

SELECT	'PROCESADOS ZONA_PUB' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_ADICIONAL_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  
	  AND CANAL = 'ZONA_PUB'

	  	  UNION ALL

SELECT	'PROCESADOS TOTAL' AS descripcion_estado,
		ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS EXP_PROCESADOS

FROM TB_CS_TC_ADICIONAL_GIFOLE 
WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')
	  

-----------------------------------// Cantidad de Operaciones TITULARES + ADICIONALES
INSERT INTO #TOTAL_OPERACIONES
 SELECT SUM(cantidad) 
	FROM #EXPEDIENTES_PROCESADOS 
	WHERE descripcion = 'PROCESADOS BCA INTERNET'

	UNION ALL

SELECT SUM(cantidad) 
	FROM #EXPEDIENTES_PROCESADOS 
	WHERE descripcion = 'PROCESADOS BMMOVIL'

		UNION ALL

SELECT SUM(cantidad) 
	FROM #EXPEDIENTES_PROCESADOS 
	WHERE descripcion = 'PROCESADOS BMOVILWB'

			UNION ALL

SELECT SUM(cantidad) 
	FROM #EXPEDIENTES_PROCESADOS 
	WHERE descripcion = 'PROCESADOS ZONA_PUB'
	
			UNION ALL

SELECT SUM(cantidad) 
	FROM #EXPEDIENTES_PROCESADOS 
	WHERE descripcion = 'PROCESADOS TOTAL'


	---------select * from #TOTAL_OPERACIONES

INSERT INTO #PORCENTAJE_OPERACIONES
SELECT cast(a.operaciones/ISNULL(NULLIF(b.operaciones,0),0) as decimal(10,4)) * 100  AS op_porcentaje	
		
FROM #TOTAL_OPERACIONES a LEFT JOIN  #TOTAL_OPERACIONES b
ON a.codigo = 1	WHERE b.codigo = 5

UNION ALL	

SELECT cast(a.operaciones/ISNULL(NULLIF(b.operaciones,0),0) as decimal(18,2)) * 100 AS op_porcentaje	
			
FROM #TOTAL_OPERACIONES a LEFT JOIN  #TOTAL_OPERACIONES b
ON a.codigo = 2	WHERE b.codigo = 5		

UNION ALL		
			
SELECT cast(a.operaciones/ISNULL(NULLIF(b.operaciones,0),0) as decimal(18,2)) * 100 AS op_porcentaje	
			
FROM #TOTAL_OPERACIONES a LEFT JOIN  #TOTAL_OPERACIONES b
ON a.codigo = 3	WHERE b.codigo = 5
			
UNION ALL	

SELECT cast(a.operaciones/ISNULL(NULLIF(b.operaciones,0),0) as decimal(18,2)) * 100 AS op_porcentaje	
			
FROM #TOTAL_OPERACIONES a LEFT JOIN  #TOTAL_OPERACIONES b
ON a.codigo = 4	WHERE b.codigo = 5	

UNION ALL	

SELECT 100	

INSERT INTO #PARTE2
select o.operaciones, p.porcentaje 
from #TOTAL_OPERACIONES o LEFT JOIN #PORCENTAJE_OPERACIONES p
ON o.codigo = p.codigo


INSERT INTO TC_GIFOLE_OPERACIONES_DESGLOSE
select 'TARJETA DE CREDITO',  p1.descripcion, @FECHA_FIN, p1.monto,p1.monto_porcentaje, p2.operaciones, p2.operaciones_porcentaje 
from #PARTE1 p1 LEFT JOIN #PARTE2 p2
ON p1.codigo = p2.codigo

END

GO
/****** Object:  StoredProcedure [dbo].[USP_TC_OPERACIONES_GIFOLE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 31/08/2020
-- Description:	Procedure para calcular las operaciones de GIFOLE
-- =============================================
CREATE PROCEDURE [dbo].[USP_TC_OPERACIONES_GIFOLE] 
	(@MES int, @AÑO INT)
AS
BEGIN

DECLARE @FECHA_FIN DATE;
SET @FECHA_FIN = (SELECT MAX(FECHA_HORA_ENVIO) FROM TB_CS 
					WHERE MONTH(CONVERT(DATE,FECHA_HORA_ENVIO)) = @MES	
					AND YEAR(CONVERT(DATE,FECHA_HORA_ENVIO)) = @AÑO)

--------------------------------->>> REPROCESO OPERACIONES MENSUAL
DELETE FROM TC_GIFOLE_OPERACIONES
WHERE fecha_proceso = @FECHA_FIN

--------------------------------->>> REPROCESO OPERACIONES ANUAL
DELETE FROM TC_GIFOLE_OPERACIONES_ANUAL
WHERE fecha_proceso = @FECHA_FIN

-----------------------------------------------------------------///
	CREATE TABLE #PROCESADO_APROBADOSAUTO(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)	

	CREATE TABLE #CALCULO_TICKET_PROMEDIO(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)

	CREATE TABLE #TICKET_PROMEDIO(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)

	CREATE TABLE #FINALGIFOLE(	
	[codigo] [int] NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL)
	---------------------------------------------------------// GIFOLE ANUAL
	CREATE TABLE #PROCESADOS_ANUAL(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,	
	[enero] [decimal](18, 2) NULL,
	[febrero] [decimal](18, 2) NULL,
	[marzo] [decimal](18, 2) NULL,
	[abril] [decimal](18, 2) NULL,
	[mayo] [decimal](18, 2) NULL,
	[junio] [decimal](18, 2) NULL,
	[julio] [decimal](18, 2) NULL,
	[agosto] [decimal](18, 2) NULL,
	[setiembre] [decimal](18, 2) NULL,
	[octubre] [decimal](18, 2) NULL,
	[noviembre] [decimal](18, 2) NULL,
	[diciembre] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL,
	[promedio] [decimal](18, 2) NULL)

	CREATE TABLE #TICKET_ANUAL(
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,	
	[enero] [decimal](18, 2) NULL,
	[febrero] [decimal](18, 2) NULL,
	[marzo] [decimal](18, 2) NULL,
	[abril] [decimal](18, 2) NULL,
	[mayo] [decimal](18, 2) NULL,
	[junio] [decimal](18, 2) NULL,
	[julio] [decimal](18, 2) NULL,
	[agosto] [decimal](18, 2) NULL,
	[setiembre] [decimal](18, 2) NULL,
	[octubre] [decimal](18, 2) NULL,
	[noviembre] [decimal](18, 2) NULL,
	[diciembre] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL,
	[promedio] [decimal](18, 2) NULL)

	CREATE TABLE #OPGIFOLE_ANUAL(		
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[enero] [decimal](18, 2) NULL,
	[febrero] [decimal](18, 2) NULL,
	[marzo] [decimal](18, 2) NULL,
	[abril] [decimal](18, 2) NULL,
	[mayo] [decimal](18, 2) NULL,
	[junio] [decimal](18, 2) NULL,
	[julio] [decimal](18, 2) NULL,
	[agosto] [decimal](18, 2) NULL,
	[setiembre] [decimal](18, 2) NULL,
	[octubre] [decimal](18, 2) NULL,
	[noviembre] [decimal](18, 2) NULL,
	[diciembre] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL,
	[promedio] [decimal](18, 2) NULL
)
------------------------------------------------------//COMIENZO OPERACIONES MENSUAL EN CURSO
	INSERT INTO #PROCESADO_APROBADOSAUTO
	SELECT	'TARJETA DE CREDITO',
		'PROCESADOS TITULARES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS total
	
	FROM TB_CS_TC_GIFOLE		

	WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')

	  UNION ALL

	  SELECT	'TARJETA DE CREDITO',
		'PROCESADOS ADICIONALES' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS '01',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS '04',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS '05',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS '06',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS '07',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS '08',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS '09',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS '10',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS '11',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS '12',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 13 THEN 1 END),0) AS '13',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 14 THEN 1 END),0) AS '14',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 15 THEN 1 END),0) AS '15',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 16 THEN 1 END),0) AS '16',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 17 THEN 1 END),0) AS '17',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 18 THEN 1 END),0) AS '18',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 19 THEN 1 END),0) AS '19',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 20 THEN 1 END),0) AS '20',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 21 THEN 1 END),0) AS '21',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 22 THEN 1 END),0) AS '22',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 23 THEN 1 END),0) AS '23',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 24 THEN 1 END),0) AS '24',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 25 THEN 1 END),0) AS '25',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 26 THEN 1 END),0) AS '26',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 27 THEN 1 END),0) AS '27',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 28 THEN 1 END),0) AS '28',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 29 THEN 1 END),0) AS '29',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 30 THEN 1 END),0) AS '30',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 31 THEN 1 END),0) AS '31',
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN 1 END),0) AS total
	
	FROM TB_CS_TC_ADICIONAL_GIFOLE  			

	WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  

	  -----------------------------------------------/// suma de procesados titulares y adicionales
	  INSERT INTO #CALCULO_TICKET_PROMEDIO
	  SELECT  'TARJETA DE CREDITO' as producto,
	 'EXPEDIENTES FORMALIZADOS GIFOLE' AS descripcion,	 
	@FECHA_FIN AS fecha_proceso,
	
	a.dia1 + b.dia1   AS '01', 
	a.dia2 + b.dia2  AS '02', 
	a.dia3 + b.dia3  AS '03',
	a.dia4 + b.dia4  AS '04',
	a.dia5 + b.dia5  AS '05',
	a.dia6 + b.dia6  AS '06',
	a.dia7 + b.dia7  AS '07',
	a.dia8 + b.dia8  AS '08',
	a.dia9 + b.dia9  AS '09',
	a.dia10 + b.dia10  AS '10',
	a.dia11 + b.dia11  AS '11',
	a.dia12 + b.dia12  AS '12',
	a.dia13 + b.dia13  AS '13',
	a.dia14 + b.dia14  AS '14',
	a.dia15 + b.dia15  AS '15',
	a.dia16 + b.dia16  AS '16',
	a.dia17 + b.dia17  AS '17',
	a.dia18 + b.dia18  AS '18',
	a.dia19 + b.dia19  AS '19',
	a.dia20 + b.dia20  AS '20',
	a.dia21 + b.dia21  AS '21',
	a.dia22 + b.dia22  AS '22',
	a.dia23 + b.dia23  AS '23',
	a.dia24 + b.dia24  AS '24',
	a.dia25 + b.dia25  AS '25',
	a.dia26 + b.dia26  AS '26',
	a.dia27 + b.dia27  AS '27',
	a.dia28 + b.dia28  AS '28',
	a.dia29 + b.dia29  AS '29',
	a.dia30 + b.dia30  AS '30',
	a.dia31 + b.dia31  AS '31',
	a.total + b.total  AS 'total'	

	FROM #PROCESADO_APROBADOSAUTO a LEFT JOIN  #PROCESADO_APROBADOSAUTO b
	ON a.codigo = 1	WHERE b.codigo = 2

	UNION ALL

	SELECT	'TARJETA DE CREDITO' as producto,
		'MONTO FORMALIZADO GIFOLE' AS descripcion_estado, 	    
		 @FECHA_FIN AS fecha_proceso,
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 1 THEN MONTO END),0) AS '01',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 2 THEN MONTO END),0) AS '02',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 3 THEN MONTO END),0) AS '03',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 4 THEN MONTO END),0) AS '04',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 5 THEN MONTO END),0) AS '05',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 6 THEN MONTO END),0) AS '06',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 7 THEN MONTO END),0) AS '07',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 8 THEN MONTO END),0) AS '08',					
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 9 THEN MONTO END),0) AS '09',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 10 THEN MONTO END),0) AS '10',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 11 THEN MONTO END),0) AS '11',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 12 THEN MONTO END),0) AS '12',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 13 THEN MONTO END),0) AS '13',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 14 THEN MONTO END),0) AS '14',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 15 THEN MONTO END),0) AS '15',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 16 THEN MONTO END),0) AS '16',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 17 THEN MONTO END),0) AS '17',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 18 THEN MONTO END),0) AS '18',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 19 THEN MONTO END),0) AS '19',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 20 THEN MONTO END),0) AS '20',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 21 THEN MONTO END),0) AS '21',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 22 THEN MONTO END),0) AS '22',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 23 THEN MONTO END),0) AS '23',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 24 THEN MONTO END),0) AS '24',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 25 THEN MONTO END),0) AS '25',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 26 THEN MONTO END),0) AS '26',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 27 THEN MONTO END),0) AS '27',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 28 THEN MONTO END),0) AS '28',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 29 THEN MONTO END),0) AS '29',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 30 THEN MONTO END),0) AS '30',
	ISNULL(SUM(CASE WHEN DAY(FECHA_HORA_MODIFICACION) = 31 THEN MONTO END),0) AS '31',
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = @MES THEN MONTO END),0) AS total
	
	FROM TB_CS_TC_GIFOLE		

	WHERE MONTH(FECHA_HORA_MODIFICACION) = @MES
	  AND YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')

	  INSERT INTO #TICKET_PROMEDIO
	  SELECT  'TARJETA DE CREDITO',
	 'TICKET PROMEDIO GIFOLE' AS DESCRIPCION,		 
	@FECHA_FIN Aha_proceso,
	CAST(a.dia1/ISNULL(NULLIF(b.dia1,0),1) as decimal(10,2))  AS '01', 
	CAST(a.dia2/ISNULL(NULLIF(b.dia2,0),1) as decimal(10,2)) AS '02', 
	CAST(a.dia3/ISNULL(NULLIF(b.dia3,0),1) as decimal(10,2)) AS '03',
	CAST(a.dia4/ISNULL(NULLIF(b.dia4,0),1) as decimal(10,2)) AS '04',
	CAST(a.dia5/ISNULL(NULLIF(b.dia5,0),1) as decimal(10,2)) AS '05',
	CAST(a.dia6/ISNULL(NULLIF(b.dia6,0),1) as decimal(10,2)) AS '06',
	CAST(a.dia7/ISNULL(NULLIF(b.dia7,0),1) as decimal(10,2)) AS '07',
	CAST(a.dia8/ISNULL(NULLIF(b.dia8,0),1) as decimal(10,2)) AS '08',
	CAST(a.dia9/ISNULL(NULLIF(b.dia9,0),1) as decimal(10,2)) AS '09',
	CAST(a.dia10/ISNULL(NULLIF(b.dia10,0),1) as decimal(10,2)) AS '10',
	CAST(a.dia11/ISNULL(NULLIF(b.dia11,0),1) as decimal(10,2)) AS '11',
	CAST(a.dia12/ISNULL(NULLIF(b.dia12,0),1) as decimal(10,2)) AS '12',
	CAST(a.dia13/ISNULL(NULLIF(b.dia13,0),1) as decimal(10,2)) AS '13',
	CAST(a.dia14/ISNULL(NULLIF(b.dia14,0),1) as decimal(10,2)) AS '14',
	CAST(a.dia15/ISNULL(NULLIF(b.dia15,0),1) as decimal(10,2)) AS '15',
	CAST(a.dia16/ISNULL(NULLIF(b.dia16,0),1) as decimal(10,2)) AS '16',
	CAST(a.dia17/ISNULL(NULLIF(b.dia17,0),1) as decimal(10,2)) AS '17',
	CAST(a.dia18/ISNULL(NULLIF(b.dia18,0),1) as decimal(10,2)) AS '18',
	CAST(a.dia19/ISNULL(NULLIF(b.dia19,0),1) as decimal(10,2)) AS '19',
	CAST(a.dia20/ISNULL(NULLIF(b.dia20,0),1) as decimal(10,2)) AS '20',
	CAST(a.dia21/ISNULL(NULLIF(b.dia21,0),1) as decimal(10,2)) AS '21',
	CAST(a.dia22/ISNULL(NULLIF(b.dia22,0),1) as decimal(10,2)) AS '22',
	CAST(a.dia23/ISNULL(NULLIF(b.dia23,0),1) as decimal(10,2)) AS '23',
	CAST(a.dia24/ISNULL(NULLIF(b.dia24,0),1) as decimal(10,2)) AS '24',
	CAST(a.dia25/ISNULL(NULLIF(b.dia25,0),1) as decimal(10,2)) AS '25',
	CAST(a.dia26/ISNULL(NULLIF(b.dia26,0),1) as decimal(10,2)) AS '26',
	CAST(a.dia27/ISNULL(NULLIF(b.dia27,0),1) as decimal(10,2)) AS '27',
	CAST(a.dia28/ISNULL(NULLIF(b.dia28,0),1) as decimal(10,2)) AS '28',
	CAST(a.dia29/ISNULL(NULLIF(b.dia29,0),1) as decimal(10,2)) AS '29',
	CAST(a.dia30/ISNULL(NULLIF(b.dia30,0),1) as decimal(10,2)) AS '30',
	CAST(a.dia31/ISNULL(NULLIF(b.dia31,0),1) as decimal(10,2)) AS '31',		
	CAST(a.total/ISNULL(NULLIF(b.total,0),1) as decimal(10,2)) AS 'total'
			
	FROM #CALCULO_TICKET_PROMEDIO a LEFT JOIN  #CALCULO_TICKET_PROMEDIO b
	ON a.codigo = 2	WHERE b.codigo = 1	    

	INSERT INTO #FINALGIFOLE
	SELECT * FROM #CALCULO_TICKET_PROMEDIO
	UNION ALL
	SELECT * FROM #TICKET_PROMEDIO

	ALTER TABLE #FINALGIFOLE
	DROP COLUMN codigo 

	INSERT INTO TC_GIFOLE_OPERACIONES ----/// INSERTAR OPS DEL MES EN CURSO....
	SELECT * FROM #FINALGIFOLE


----------------------------------*** GIFOLE RESUMEN ANUAL **** -----------------------------------------------------------
INSERT INTO #PROCESADOS_ANUAL
SELECT	'TARJETA DE CREDITO',
		'PROCESADOS TITULARES' AS descripcion_estado, 	 

	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS ene,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS feb,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS mar,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS abr,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS may,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS jun,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS jul,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS ago,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS seti,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS oct,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS nov,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS dic,
	ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_MODIFICACION) = @AÑO THEN 1 END),0) AS total,
	ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_MODIFICACION) = @AÑO THEN 1 END)/12,0) AS promedio
	
	FROM TB_CS_TC_GIFOLE		

	WHERE YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')

	  UNION ALL

	  SELECT	'TARJETA DE CREDITO',
		'PROCESADOS ADICIONALES' AS descripcion_estado,   

	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 1 THEN 1 END),0) AS ene,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 2 THEN 1 END),0) AS feb,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 3 THEN 1 END),0) AS mar,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 4 THEN 1 END),0) AS abr,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 5 THEN 1 END),0) AS may,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 6 THEN 1 END),0) AS jun,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 7 THEN 1 END),0) AS jul,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 8 THEN 1 END),0) AS ago,					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 9 THEN 1 END),0) AS seti,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 10 THEN 1 END),0) AS oct,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 11 THEN 1 END),0) AS nov,
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 12 THEN 1 END),0) AS dic,
	ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_MODIFICACION) = @AÑO THEN 1 END),0) AS total, 
	ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_MODIFICACION) = @AÑO THEN 1 END)/12,0) AS promedio	
	
	FROM TB_CS_TC_ADICIONAL_GIFOLE  			

	WHERE YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')  


	INSERT INTO #TICKET_ANUAL
	SELECT  'TARJETA DE CREDITO' as producto,
	'EXPEDIENTES FORMALIZADOS GIFOLE ANUAL' AS descripcion,
		
	a.enero + b.enero   AS '01', 
	a.febrero + b.febrero  AS '02', 
	a.marzo + b.marzo  AS '03',
	a.abril + b.abril  AS '04',
	a.mayo + b.mayo  AS '05',
	a.junio + b.junio  AS '06',
	a.julio + b.julio  AS '07',
	a.julio + b.julio  AS '08',
	a.setiembre + b.setiembre  AS '09',
	a.octubre + b.octubre  AS '10',
	a.noviembre + b.noviembre  AS '11',
	a.diciembre + b.diciembre  AS '12',
	a.total + b.total  AS 'total',
	a.promedio + b.promedio  AS 'prom'	

	FROM #PROCESADOS_ANUAL a LEFT JOIN  #PROCESADOS_ANUAL b
	ON a.codigo = 1	WHERE b.codigo = 2

	UNION ALL

	SELECT	'TARJETA DE CREDITO' as producto,
		'MONTO FORMALIZADO GIFOLE ANUAL' AS descripcion_estado,     
		 
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 1 THEN MONTO END),0) AS '01',
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 2 THEN MONTO END),0) AS '02',					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 3 THEN MONTO END),0) AS '03',					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 4 THEN MONTO END),0) AS '04',					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 5 THEN MONTO END),0) AS '05',					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 6 THEN MONTO END),0) AS '06',					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 7 THEN MONTO END),0) AS '07',					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 8 THEN MONTO END),0) AS '08',					
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 9 THEN MONTO END),0) AS '09',
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 10 THEN MONTO END),0) AS '10',
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 11 THEN MONTO END),0) AS '11',
	ISNULL(SUM(CASE WHEN MONTH(FECHA_HORA_MODIFICACION) = 12 THEN MONTO END),0) AS '12',	
	ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_MODIFICACION) = @AÑO THEN MONTO END),0) AS total,
	ISNULL(SUM(CASE WHEN YEAR(FECHA_HORA_MODIFICACION) = @AÑO THEN MONTO END)/12,0) AS promedio
	
	FROM TB_CS_TC_GIFOLE		

	WHERE YEAR(FECHA_HORA_MODIFICACION) = @AÑO
	  AND ESTADO IN ('PROCESADO', 'APROBADO AUTO')
	  

	SELECT 'TARJETA DE CREDITO' as producto,
	'TICKET PROMEDIO GIFOLE ANUAL' AS descripcion_estado,     

		-- Si la division no se puede entre 0 pone NULL con NULLIF, y luego quitamos el NULL con ISNULL y en vez de 0 Ponemos 1 para que divida entre 1
	cast(a.enero/ISNULL(NULLIF(b.enero,0),1) as decimal(18,2))  AS enero, 
	cast(a.febrero/ISNULL(NULLIF(b.febrero,0),1) as decimal(18,2)) AS febrero, 
	cast(a.marzo/ISNULL(NULLIF(b.marzo,0),1) as decimal(18,2)) AS marzo,
	cast(a.abril/ISNULL(NULLIF(b.abril,0),1) as decimal(18,2)) AS abril,
	cast(a.mayo/ISNULL(NULLIF(b.mayo,0),1) as decimal(18,2)) AS mayo,
	cast(a.junio/ISNULL(NULLIF(b.junio,0),1) as decimal(18,2)) AS junio,
	cast(a.julio/ISNULL(NULLIF(b.julio,0),1) as decimal(18,2)) AS julio,
	cast(a.agosto/ISNULL(NULLIF(b.agosto,0),1) as decimal(18,2)) AS agosto,
	cast(a.setiembre/ISNULL(NULLIF(b.setiembre,0),1) as decimal(18,2)) AS setiembre,
	cast(a.octubre/ISNULL(NULLIF(b.octubre,0),1) as decimal(18,2)) AS octubre,
	cast(a.noviembre/ISNULL(NULLIF(b.noviembre,0),1) as decimal(18,2)) AS noviembre,
	cast(a.diciembre/ISNULL(NULLIF(b.diciembre,0),1) as decimal(18,2)) AS diciembre,		
	cast(a.total/ISNULL(NULLIF(b.total,0),1) as decimal(18,2)) as total,		
	cast(a.promedio/ISNULL(NULLIF(b.promedio,0),1) as decimal(18,2)) as promedio	
				
	INTO #TICKET_PROMEDIO_ANUAL

	FROM #TICKET_ANUAL a LEFT JOIN #TICKET_ANUAL b
	ON a.codigo = 2	WHERE b.codigo = 1


	INSERT INTO #OPGIFOLE_ANUAL
	SELECT producto, descripcion_estado, @FECHA_FIN, enero, febrero, marzo, abril, mayo, junio, julio, agosto, setiembre,
	octubre, noviembre, diciembre, total, promedio
	FROM #TICKET_ANUAL

	UNION ALL

	SELECT producto, descripcion_estado, @FECHA_FIN, enero, febrero, marzo, abril, mayo, junio, julio, agosto, setiembre,
	octubre, noviembre, diciembre, total, promedio
	FROM #TICKET_PROMEDIO_ANUAL
	
	INSERT INTO TC_GIFOLE_OPERACIONES_ANUAL
	SELECT * FROM #OPGIFOLE_ANUAL
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TIEMPOS_X_BANDEJA_DETALLE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Didier Yepez Cabanillas
-- Create date: 09/06/2020
-- Description:	Tiempos de Atencion por Bandeja para Raul Oré
-- =============================================
CREATE PROCEDURE [dbo].[USP_TIEMPOS_X_BANDEJA_DETALLE]
( 
@NOMBRE_PRODUCTO VARCHAR(100),
@FECHA_INICIO DATE,
@FECHA_FIN DATE

)

AS


BEGIN
-------------- PERCENTILES - MES --------
DECLARE @BANDEJA VARCHAR(50);----- Contador
DECLARE @MAX1 int;
DECLARE @CONTADOR int = 1;
-------------------------------------------------------------------

CREATE TABLE #PARTE1
(
  codigo int identity(1,1) NOT NULL PRIMARY KEY,
  producto varchar(100) NULL,
  fecha date NULL,
  expediente varchar(20) NULL,
  bandeja varchar(50) NULL,
  tiempo decimal(10,2) 
  
);


CREATE TABLE #EMBOSES
(
  COD int identity(1,1) NOT NULL PRIMARY KEY,
  NRO_EXPEDIENTE varchar(100) NULL,
  FECHA_FINAL date NULL 
  
);


CREATE TABLE #REGISTRADOS
(
  COD int identity(1,1) NOT NULL PRIMARY KEY,
  NRO_EXPEDIENTE varchar(100) NULL,
  
  
);


CREATE TABLE #BANDEJAS
( Id int identity(1,1) NOT NULL PRIMARY KEY,
  Bandeja varchar(255) NULL,
);

INSERT #BANDEJAS (Bandeja) VALUES ('MESA DE CONTROL')
INSERT #BANDEJAS (Bandeja) VALUES ('ANALISIS Y ALTA')
INSERT #BANDEJAS (Bandeja) VALUES ('CONTROLLER')
INSERT #BANDEJAS (Bandeja) VALUES ('FORMALIZADOR')
INSERT #BANDEJAS (Bandeja) VALUES ('EJECUTIVO')
INSERT #BANDEJAS (Bandeja) VALUES ('SUB GERENTE OFICINA')
INSERT #BANDEJAS (Bandeja) VALUES ('ANALISTA DE RIESGOS')
INSERT #BANDEJAS (Bandeja) VALUES ('RIESGOS SUPERIOR')

SET @MAX1 = (SELECT COUNT(Id) FROM #BANDEJAS)

WHILE @CONTADOR <= @MAX1


BEGIN
		SET @BANDEJA = (SELECT Bandeja FROM #BANDEJAS WHERE Id=@CONTADOR)


				insert into #EMBOSES

				SELECT NRO_EXPEDIENTE AS NRO_EXPEDIENTE,FECHA_HORA_ENVIO AS FECHA_FINAL							
							FROM  TB_CS
							WHERE [dbo].[FN_TB_CS_BUSCAR_ESTADO](NRO_EXPEDIENTE, 'DESEMBOLSADO / EN EMBOSE' )='SI'
							--AND NRO_EXPEDIENTE='279463'
							--AND ACCION!='GRABAR'
							AND (CONVERT(DATE,FECHA_HORA_ENVIO)) >= @FECHA_INICIO	
							AND (CONVERT(DATE,FECHA_HORA_ENVIO)) <= @FECHA_FIN 
							and NOMBRE_PRODUCTO = @NOMBRE_PRODUCTO 
							AND PERFIL=@BANDEJA
				------------------------------------------------------------------------



				INSERT INTO #REGISTRADOS
				SELECT
				CS.NRO_EXPEDIENTE AS NRO_EXPEDIENTE				

				FROM  TB_CS CS INNER JOIN #EMBOSES D 
				ON CS.NRO_EXPEDIENTE = D.NRO_EXPEDIENTE
				WHERE  ESTADO_EXPEDIENTE IN ('EXPEDIENTE REGISTRADO')	
				GROUP BY CS.NRO_EXPEDIENTE


				
				-------------------- DIAS LAB

				INSERT INTO #PARTE1
				SELECT C.NOMBRE_PRODUCTO AS PRODUCTO, C.FECHA_HORA_ENVIO AS FECHA,
				 E.NRO_EXPEDIENTE AS EXPEDIENTE, C.PERFIL AS BANDEJA,
				SUM([dbo].[fn_tiempo_horas] (C.FECHA_HORA_LLEGADA,C.FECHA_HORA_ENVIO)) AS TIEMPO					

				FROM #REGISTRADOS E INNER JOIN TB_CS C
				ON E.NRO_EXPEDIENTE = C.NRO_EXPEDIENTE				
				WHERE PERFIL=@BANDEJA
				GROUP BY C.FECHA_HORA_ENVIO,E.NRO_EXPEDIENTE, c.PERFIL, C.NOMBRE_PRODUCTO		

				

		SET @CONTADOR=@CONTADOR+1
END

SELECT producto, fecha, expediente, bandeja, tiempo
FROM #PARTE1
order by fecha

END

GO
/****** Object:  UserDefinedFunction [dbo].[DiasLaborables]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DiasLaborables]
(
    @fch_ini DATETIME,
    @fch_fin DATETIME
)
RETURNS DECIMAL(6,1)
AS 
BEGIN
 
DECLARE @TotalDias  DECIMAL(6,1) --Con esta variable calculamos cuantos dias "normales" hay en el rango de fechas
DECLARE @DiasNoLaborables INT --Con esta variable acumulamos los dias no laborables
--DECLARE @DiasFeriados SMALLINT --Total dias feriados entre el rango de fechas
DECLARE @Cnt INT --esta variable nos sirve de contador para saber cuando lleguemos al ultimo dia del rango
DECLARE @EvalDate DATETIME --esta variable es la que comparamos para saber si el dia que esta calculando es sábado o domingo
 
SET @Cnt = 0
SET @DiasNoLaborables = 0
 
--Calculamos cuantos dias normales hay en el rango de fechas
SELECT @TotalDias = DATEDIFF(HOUR,@fch_ini,@fch_fin) / 24.0--Se maneja diferencia de dias a nivel horas
 
--SELECT @DiasFeriados = COUNT(1) FROM tb_feriados WHERE fec_fer >= @fch_ini AND fec_fer <= @fch_fin
 
WHILE @Cnt < @TotalDias 
BEGIN 
    SELECT @EvalDate = @fch_ini + @Cnt 
 
    IF datepart(DW,@EvalDate) = 1
    BEGIN 
        SET @DiasNoLaborables = @DiasNoLaborables + 1 
    END
 
    SET @Cnt = @Cnt + 1 
END 
 
--RETURN (@TotalDias - @DiasNoLaborables - @DiasFeriados) 
RETURN (@TotalDias - @DiasNoLaborables) 
 
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_CALCULAR_DESEMBOLSO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FN_CALCULAR_DESEMBOLSO](
@NRO_EXPEDIENTE VARCHAR(20))
RETURNS datetime
AS
BEGIN 

DECLARE @Desembolso datetime ;
DECLARE @registrado    datetime
DECLARE @count   int; 


--select  @Desembolso = FECHA_HORA_ENVIO
--from TB_CS 
--where NRO_EXPEDIENTE=@NRO_EXPEDIENTE and  ESTADO_EXPEDIENTE!='DESEMBOLSADO / EN EMBOSE'


   
   		select  @count = count(ID)
		from TB_CS 
		where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
		--ARAUJO
		and  ESTADO_EXPEDIENTE='EXPEDIENTE REGISTRADO';


		if @count>0  
			begin 
					select  @registrado = FECHA_HORA_ENVIO
					--FECHA_HORA_LLEGADA
					from TB_CS 
					where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
					--ARAUJO
					and  ESTADO_EXPEDIENTE='EXPEDIENTE REGISTRADO';
			end 
		else 
			begin 
		
					SET @registrado=NULL
			end




RETURN @registrado

END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_CALCULAR_FUNNEL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_CALCULAR_FUNNEL](
@NRO_EXPEDIENTE VARCHAR(20))
RETURNS datetime
AS
BEGIN 

DECLARE @Desembolso datetime ;
DECLARE @registrado    datetime
DECLARE @count   int; 

  		select  @count = count(ID)
		from TB_CS 
		where NRO_EXPEDIENTE=@NRO_EXPEDIENTE and  ESTADO_EXPEDIENTE='Expediente Registrado';


		if @count>0  
			begin 
					select  @registrado = FECHA_HORA_ENVIO
					from TB_CS 
					where NRO_EXPEDIENTE=@NRO_EXPEDIENTE and  ESTADO_EXPEDIENTE='Expediente Registrado';
			end 
		else 
			begin 
		
					SET @registrado=NULL
			end

RETURN @registrado

END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_BANDEJA_OFERTA_SUM]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_TB_CS_BANDEJA_OFERTA_SUM](

@PERFIL VARCHAR(50),
@TIPO VARCHAR(50),
@NRO_EXPEDIENTE VARCHAR(20),
@OFERTA VARCHAR(50)
)

RETURNS DECIMAL(10,3)
AS
BEGIN 

DECLARE @Desembolso datetime ;
DECLARE @registrado  DECIMAL(10,3)
DECLARE @count   int; 


--select  @Desembolso = FECHA_HORA_ENVIO
--from TB_CS 
--where NRO_EXPEDIENTE=@NRO_EXPEDIENTE and  ESTADO_EXPEDIENTE!='DESEMBOLSADO / EN EMBOSE'
   
   		select  @count = count(ID)
		from TB_CS 
		where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
		AND  PERFIL= @PERFIL


		if @count>0  
			begin 
					
					IF @TIPO='LAB'
						BEGIN 
						select  @registrado = sum ([dbo].[fn_tiempo_horas] (  FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO) )
						from TB_CS 
						where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
						AND  PERFIL= @PERFIL
						AND NOMBRE_TIPO_OFERTA=@OFERTA
						
						END
					ELSE
						BEGIN 
						select  @registrado = sum ([dbo].FN_TIEMPO_CALEN (  FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO) )
						from TB_CS 
						where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
						AND  PERFIL= @PERFIL
						AND NOMBRE_TIPO_OFERTA=@OFERTA
						END
			end 
		else 
			begin 
		
					SET @registrado=0
			end

RETURN @registrado

END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_BANDEJA_SUM]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_TB_CS_BANDEJA_SUM](

@PERFIL VARCHAR(50),
@TIPO VARCHAR(50),
@NRO_EXPEDIENTE VARCHAR(20)
--@OFERTA VARCHAR(50)
)

RETURNS DECIMAL(10,3)
AS
BEGIN 

DECLARE @Desembolso datetime ;
DECLARE @registrado  DECIMAL(10,3)
DECLARE @count   int; 


--select  @Desembolso = FECHA_HORA_ENVIO
--from TB_CS 
--where NRO_EXPEDIENTE=@NRO_EXPEDIENTE and  ESTADO_EXPEDIENTE!='DESEMBOLSADO / EN EMBOSE'


   
   		select  @count = count(ID)
		from TB_CS 
		where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
		AND  PERFIL= @PERFIL

		if @count>0  
			begin 
					
					IF @TIPO='LAB'
						BEGIN 
						select  @registrado = sum ([dbo].[fn_tiempo_horas] (  FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO) )
						from TB_CS 
						where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
						AND  PERFIL= @PERFIL
						
						END
					ELSE
						BEGIN 
						select  @registrado = sum ([dbo].FN_TIEMPO_CALEN (  FECHA_HORA_LLEGADA,FECHA_HORA_ENVIO) )
						from TB_CS 
						where NRO_EXPEDIENTE=@NRO_EXPEDIENTE 
						AND  PERFIL= @PERFIL
						END
			end 
		else 
			begin 
		
					SET @registrado=0
			end

RETURN @registrado

END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_BUSCAR_ESTADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_TB_CS_BUSCAR_ESTADO] 
  (@NUM_SOL VARCHAR(20) ,
   @ESTADO VARCHAR(50)
   )

  RETURNS VARCHAR (15)

  AS
  BEGIN

  DECLARE @COUNT INT;
  DECLARE @RESPUESTA VARCHAR (5);

  -- cuenta toditas, faltan filtros
 SELECT  @COUNT = COUNT(ID) 
 FROM TB_CS
 WHERE
 ESTADO_EXPEDIENTE = @ESTADO
 AND NRO_EXPEDIENTE = @NUM_SOL 

 IF @COUNT=0
 BEGIN 
 SET @RESPUESTA='NO'
 END 
 ELSE 
  BEGIN 
 SET @RESPUESTA='SI'
 END 

RETURN @RESPUESTA

END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_EJECUTIVO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE FUNCTION [dbo].[FN_TB_CS_EJECUTIVO] (
 @EXPEDIENTE VARCHAR (255)
  )
  RETURNS VARCHAR (15)
  AS
  BEGIN

  DECLARE @COUNT INT;
  DECLARE @EJECUTIVO VARCHAR (255);
  DECLARE @EJECUTIVO2 VARCHAR (255);

	SELECT @COUNT= COUNT(B.NUMERO_EXPEDIENTE) FROM TB_CS A
	INNER JOIN  TB_CS_CONSOLIDADO B
	ON  A.NRO_EXPEDIENTE = B.NUMERO_EXPEDIENTE
	WHERE A.NRO_EXPEDIENTE = @EXPEDIENTE
	GROUP BY A.NRO_EXPEDIENTE

	SELECT @EJECUTIVO2 = EJECUTIVO FROM TB_CS_CONSOLIDADO
	WHERE NUMERO_EXPEDIENTE = @EXPEDIENTE
	GROUP BY EJECUTIVO

 IF @COUNT > 0
 BEGIN 
 SET @EJECUTIVO=@EJECUTIVO2
 END
 ELSE 
 BEGIN 
 SET @EJECUTIVO=''
 END 

RETURN @EJECUTIVO

END


GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_FECHA_DESEMBOLSO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_TB_CS_FECHA_DESEMBOLSO](
@NRO_EXPEDIENTE VARCHAR(20))
RETURNS datetime
AS
BEGIN 

DECLARE @Desembolso datetime ;
DECLARE @count   int; 

  		select  @count = count(ID)
		from TB_CS 
		where NRO_EXPEDIENTE=@NRO_EXPEDIENTE and  ESTADO_EXPEDIENTE='Desembolsado / En Embose';


		if @count>0  
			begin 
					select  @Desembolso = FECHA_HORA_ENVIO
					from TB_CS 
					where NRO_EXPEDIENTE=@NRO_EXPEDIENTE and  ESTADO_EXPEDIENTE='Desembolsado / En Embose';
			end 
		else 
			begin 
		
					SET @Desembolso=NULL
			end

RETURN @Desembolso

END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_PLAZO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE FUNCTION [dbo].[FN_TB_CS_PLAZO] (
  @FECHA_HORA_ENVIO DATETIME
  )
  RETURNS VARCHAR (15)
  AS
  BEGIN

  DECLARE @DIAS DECIMAL(6,2);
  DECLARE @NUMERO DECIMAL(6,2);
  DECLARE @RESPUESTA VARCHAR (255);

 
-- SELECT @DIAS = [dbo].[DiasLaborables](@FECHA_HORA_ENVIO,GETDATE())
 
-- IF CONVERT(DATE,@FECHA_HORA_ENVIO) >= ( DATEADD (day, -3, getdate()))
-- BEGIN 
-- SET @RESPUESTA='DENTRO DE PLAZO'
-- END 
-- ELSE 
-- BEGIN 
-- SET @RESPUESTA='FUERA DE PLAZO'
-- END 

--RETURN @RESPUESTA

--END

 IF DATEPART(weekday, GETDATE()) = 1 OR DATEPART(weekday, GETDATE()) = 2
 BEGIN 
 SET @NUMERO=3
 END 
 ELSE 
 BEGIN 
 SET @NUMERO=2
 END 
 
 SELECT @DIAS = CEILING([dbo].[DiasLaborables](CONVERT(DATE,@FECHA_HORA_ENVIO),CONVERT(DATE,GETDATE())))
 
 IF @NUMERO > @DIAS
 BEGIN 
 SET @RESPUESTA='DENTRO DE PLAZO'
 END 
 ELSE 
 BEGIN 
 SET @RESPUESTA='FUERA DE PLAZO'
 END 

RETURN @RESPUESTA

END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_ULTIMA_FECHA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FN_TB_CS_ULTIMA_FECHA] (
@nro_expediente as varchar(20)
 )
returns datetime

begin

declare @ultima_fecha datetime

select top(1) @ultima_fecha =([FECHA_HORA_ENVIO])
from TB_CS
where [NRO_EXPEDIENTE] = @nro_expediente
order by [FECHA_HORA_ENVIO] desc 

return @ultima_fecha

end

GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_ULTIMO_ESTADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE function [dbo].[FN_TB_CS_ULTIMO_ESTADO] (
@nro_expediente as varchar(20)
 )
returns varchar(100)

begin

declare @ultimo_bandeja varchar(100)
declare @ultima_fecha date
declare @estado varchar (100)

select @ultima_fecha = [dbo].[FN_TB_CS_ULTIMA_FECHA] (@nro_expediente)

select @estado=count(ESTADO_EXPEDIENTE)from TB_CS
where [NRO_EXPEDIENTE] = @nro_expediente 
and convert(date,[FECHA_HORA_ENVIO]) = @ultima_fecha
and ESTADO_EXPEDIENTE in ('Cerrado', 'Resuelto' , 'Rechazado' , 'Desembolsado / En Embose' , 'Desembolso del pr?stamo')

If @estado = 0 


begin

select top(1) @ultimo_bandeja=(PERFIL) from TB_CS
where [NRO_EXPEDIENTE] = @nro_expediente
order by [FECHA_HORA_ENVIO] desc 

end

else 

begin 

set  @ultimo_bandeja = 'FINALIZADO'

end

return @ultimo_bandeja


end
GO
/****** Object:  UserDefinedFunction [dbo].[FN_TB_CS_ULTIMO_ESTADO_TEMP]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[FN_TB_CS_ULTIMO_ESTADO_TEMP] (
@nro_expediente as varchar(20)
 )
returns varchar(100)

begin

declare @ultimo_bandeja varchar(100)
declare @ultima_fecha date
declare @estado varchar (100)

select @ultima_fecha = [dbo].[FN_TB_CS_ULTIMA_FECHA] (@nro_expediente)

select @estado=count(ESTADO_EXPEDIENTE)from TB_CS
where [NRO_EXPEDIENTE] = @nro_expediente 
and convert(date,[FECHA_HORA_ENVIO]) = @ultima_fecha
and ESTADO_EXPEDIENTE in ('Cerrado', 'Resuelto' , 'Rechazado' , 'Desembolsado / En Embose' , 'Desembolso del pr?stamo')

If @estado = 0 


begin

select top(1) @ultimo_bandeja=(C.BANDEJA_LLEGADA)FROM TB_CS A
INNER JOIN TB_CS_CONSOLIDADO B
ON A.NRO_EXPEDIENTE = B.NUMERO_EXPEDIENTE
INNER JOIN TB_CS_ESTANDAR_BANDEJA C
ON B.CORRELATIVO_ESTADO = C.CODIGO
INNER JOIN TB_CS_TERRITORIO D
ON B.CODIGO_OFICINA = D.COD_OFI
where [NRO_EXPEDIENTE] = @nro_expediente
order by [FECHA_HORA_ENVIO] desc 

end

else 

begin 

set  @ultimo_bandeja = 'FINALIZADO'

end

return @ultimo_bandeja


end
GO
/****** Object:  UserDefinedFunction [dbo].[FN_TIEMPO_CALEN]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [dbo].[FN_TIEMPO_CALEN] ( @fecha_inicio datetime , @fecha_final datetime)
RETURNS DECIMAL (10,3)
AS
BEGIN

DECLARE @hora decimal (10,2) = 0;




	select @hora = DATEDIFF (MINUTE, @fecha_inicio,@fecha_final) 
	
	return ((@hora) /60 )/24


ENd

GO
/****** Object:  UserDefinedFunction [dbo].[fn_tiempo_horas]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_tiempo_horas]( @fecha_inicio datetime , @fecha_final datetime)
RETURNS DECIMAL (10,3)
AS
BEGIN
DECLARE @i INT = 0;
DECLARE @i2 INT = 0;
select @i2 = DATEDIFF (day, @fecha_inicio,@fecha_final)  ; 
DECLARE @FERIADO INT = 0;
DECLARE @Dias INT = 0;

DECLARE @Dias2 INT = 0;
DECLARE @hora decimal (10,2) = 0;

WHILE @i <= @i2
  BEGIn;


  	  --select @FERIADO = COUNT(id) FROM tb_feriados T WHERE  T.fec_fer= convert(date ,@fecha_inicio+@i) ;

	IF @FERIADO > 0
		BEGIN 
		set @Dias = @Dias + 1440  ;
		END

	 ELSE 	
		BEGIN 
			IF upper ( DATENAME (dw, @fecha_inicio+@i) )='SUNDAY'
				BEGIN 
				SET @Dias = @Dias + 1440  ;
				END
			IF upper ( DATENAME (dw, @fecha_inicio+@i) )='SATURDAY'
				BEGIN 
					IF CONVERT( DATE,@fecha_inicio) = CONVERT( DATE, @fecha_final)
						BEGIN
						set @Dias = @Dias + 0  ;
						END
					ELSE 
						BEGIn
						set @Dias = @Dias + 720  ;
						END 
				END
		END


	-------------------------------------------------------------------
	  -- IF @FERIADO != 0  or upper ( DATENAME (dw, @fecha_inicio+@i) )='SUNDAY'
			--   begiN 

			--   set @Dias = @Dias + 1440  ;

	   
			--   end

	  -- IF @FERIADO != 0  or upper ( DATENAME (dw, @fecha_inicio+@i) )='SATURDAY'
			--   begiN 




			--   IF CONVERT( DATE,@fecha_inicio) = CONVERT( DATE, @fecha_final)
			--   BEGIN
			--   set @Dias = @Dias + 0  ;
			--   --end 
	   
			--   END
			--   ELSE 
			--   BEGIN
			--	set @Dias = @Dias + 720  ;
			--   END 
			--END
			
			set @i = @i +1  

		
	END --while 

		

	--return (@Dias  )  /24 ;
	select @hora = DATEDIFF (MINUTE, @fecha_inicio,@fecha_final) 
	
	return (((@hora-  @Dias) /60)  )/24


END

GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetRoleClaims]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](450) NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[Apellidos] [nvarchar](max) NULL,
	[Codigo] [nvarchar](max) NULL,
	[Nombres] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserTokens]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FDIFERENCIAS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FDIFERENCIAS](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](100) NULL,
	[bandeja] [varchar](50) NULL,
	[resta] [int] NULL,
	[porcentaje] [decimal](10, 2) NULL,
	[rechazados] [int] NULL,
	[enproceso] [int] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FMOTIVO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FMOTIVO](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[id_perfil] [int] NULL,
	[perfil] [varchar](50) NULL,
	[motivo] [varchar](50) NULL,
	[qty] [int] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FPERFIL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FPERFIL](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[id_diferencia] [int] NULL,
	[perfil] [varchar](50) NULL,
	[qty] [int] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FPERFIL_RECHAZO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[FPERFIL_RECHAZO](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_diferencia] [int] NULL,
	[perfil] [varchar](50) NULL,
	[perfil_rechazo] [varchar](50) NULL,
	[qty] [int] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion] [varchar](150) NULL,
	[valor_objetivo] [decimal](18, 2) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[mes1] [decimal](18, 2) NULL,
	[mes2] [decimal](18, 2) NULL,
	[mes3] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_CALIDAD]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_CALIDAD](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](100) NULL,
	[nro] [varchar](5) NULL,
	[descripcion_estado] [varchar](100) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[mes1] [decimal](18, 2) NULL,
	[mes2] [decimal](18, 2) NULL,
	[mes3] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_CALIDAD_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_CALIDAD_GRAPH](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia_nombre] [varchar](10) NULL,
	[valor] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_DETALLE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_DETALLE](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[expediente] [varchar](50) NULL,
	[fecha] [datetime] NULL,
	[producto] [varchar](50) NULL,
	[descripcion] [varchar](150) NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_DETALLE_TIEMPOS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_DETALLE_TIEMPOS](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[nro_expediente] [varchar](50) NULL,
	[tiempo] [decimal](10, 2) NULL,
	[perfil] [varchar](50) NULL,
	[nombre_producto] [varchar](50) NULL,
	[nombre_tipo_oferta] [varchar](50) NULL,
	[fecha_hora_envio] [datetime] NULL,
	[tipo] [varchar](50) NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[nro_expediente] [varchar](50) NULL,
	[fecha_hora_llegada] [datetime] NULL,
	[fecha_hora_envio] [datetime] NULL,
	[tiempo] [decimal](10, 3) NULL,
	[bandeja] [varchar](50) NULL,
	[nombre_producto] [varchar](50) NULL,
	[oferta] [varchar](50) NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_FUNNEL_ACUMULADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_FUNNEL_ACUMULADO](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[mes] [int] NULL,
	[ano] [int] NULL,
	[producto] [varchar](100) NULL,
	[tipo] [varchar](100) NULL,
	[cantidad] [int] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NUM] [varchar](100) NULL,
	[F] [int] NULL,
	[FT] [int] NULL,
	[H] [decimal](10, 2) NULL,
	[HT] [decimal](10, 2) NULL,
	[FECHA] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_HISTORAL_LAB]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_HISTORAL_LAB](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[FECHA_HORA_ENVIO] [datetime] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[FECHA] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[TIPO] [varchar](20) NULL,
	[RANGO] [varchar](100) NULL,
	[F] [int] NULL,
	[FT] [int] NULL,
	[H] [decimal](10, 2) NULL,
	[HT] [decimal](10, 2) NULL,
	[FECHA] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_HISTORAL_LAB_MAX]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_HISTORAL_LAB_MAX](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[Cantidad_Expedientes] [int] NULL,
	[FECHA] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_OPERACIONES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_OPERACIONES](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_OPERACIONES_ANUAL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_OPERACIONES_ANUAL](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[enero] [decimal](18, 2) NULL,
	[febrero] [decimal](18, 2) NULL,
	[marzo] [decimal](18, 2) NULL,
	[abril] [decimal](18, 2) NULL,
	[mayo] [decimal](18, 2) NULL,
	[junio] [decimal](18, 2) NULL,
	[julio] [decimal](18, 2) NULL,
	[agosto] [decimal](18, 2) NULL,
	[setiembre] [decimal](18, 2) NULL,
	[octubre] [decimal](18, 2) NULL,
	[noviembre] [decimal](18, 2) NULL,
	[diciembre] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL,
	[promedio] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_OPERACIONES_DESGLOSE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_OPERACIONES_DESGLOSE](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[monto] [decimal](18, 2) NULL,
	[monto_porcentaje] [decimal](18, 2) NULL,
	[operaciones] [decimal](18, 2) NULL,
	[operaciones_porcentaje] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_OPERACIONES_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_OPERACIONES_GRAPH](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia_nombre] [varchar](10) NULL,
	[cantidad_monto] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](150) NULL,
	[oferta] [varchar](150) NULL,
	[tipo] [varchar](150) NULL,
	[percentil] [decimal](18, 2) NULL,
	[dia_nombre] [varchar](30) NULL,
	[fecha] [date] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_REPROCESOS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_REPROCESOS](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[nro_expediente] [varchar](10) NULL,
	[nombre_producto] [varchar](50) NULL,
	[reprocesos] [int] NULL,
	[FECHA_INGRESO] [date] NULL,
	[FECHA] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[nombre_producto] [varchar](50) NULL,
	[mes_anio] [varchar](10) NULL,
	[valory] [int] NULL,
	[fecha_proceso] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_REPROCESOS_CANT_ACUM](
	[CODIGO] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PERIODO] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL,
	[FECHA_INGRESO] [varchar](100) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TERRITORIO] [varchar](100) NULL,
	[OFICINA] [varchar](100) NULL,
	[RESUL] [varchar](100) NULL,
	[REPROCESOS] [int] NULL,
	[NRO_EXPEDIENTE] [varchar](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[nombre_producto] [varchar](50) NULL,
	[dia] [varchar](10) NULL,
	[valory] [decimal](10, 2) NULL,
	[valor_objetivo] [decimal](10, 2) NULL,
	[fecha_proceso] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_REPROCESOS_GRAPH]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_REPROCESOS_GRAPH](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[nombre_producto] [varchar](50) NULL,
	[dia] [varchar](10) NULL,
	[valory] [decimal](10, 2) NULL,
	[valor_objetivo] [decimal](10, 2) NULL,
	[fecha_proceso] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_RS_ACUMULADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_RS_ACUMULADO](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](100) NULL,
	[nro] [varchar](5) NULL,
	[descripcion_estado] [varchar](100) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[mes1] [decimal](18, 2) NULL,
	[mes2] [decimal](18, 2) NULL,
	[mes3] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [varchar](100) NULL,
	[nro_expediente] [varchar](100) NULL,
	[tarea] [varchar](100) NULL,
	[nom_territorio] [varchar](100) NULL,
	[nom_oficina] [varchar](100) NULL,
	[ejecutivo] [varchar](100) NULL,
	[fecha] [datetime] NULL,
	[plazo] [varchar](100) NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](50) NULL,
	[bandeja] [varchar](50) NULL,
	[total] [int] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PLD_TC_CONVENIO_TIEMPOS_EXPEDIENTES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLD_TC_CONVENIO_TIEMPOS_EXPEDIENTES](
	[FECHA] [date] NULL,
	[EXPEDIENTE] [varchar](20) NULL,
	[FECHA_REGISTRO] [datetime] NULL,
	[FECHA_HORA_MEDIANOCHE] [datetime] NULL,
	[DIFERENCIA_TIEMPO] [decimal](10, 2) NULL,
	[OFERTA] [varchar](20) NULL,
	[PRODUCTO] [varchar](40) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NRO_EXPEDIENTE] [varchar](20) NULL,
	[ESTADO_EXPEDIENTE] [varchar](100) NULL,
	[PERFIL] [varchar](100) NULL,
	[ACCION] [varchar](100) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[FECHA_HORA_LLEGADA] [datetime] NULL,
	[FECHA_HORA_ENVIO] [datetime] NULL,
	[TIEMPO_COLA_TC] [decimal](10, 3) NULL,
	[TIEMPO_PROCESO_TP] [decimal](10, 3) NULL,
	[ANS] [bigint] NULL,
	[OBSERVACION] [nvarchar](600) NULL,
	[CODIGO_OFICINA_GESTORA] [varchar](50) NULL,
	[CODIGO_OFICINA_USUARIO] [varchar](10) NULL,
	[CODIGO_TERRITORIO_GESTORA] [varchar](10) NULL,
	[CODIGO_TERRITORIO_USUARIO] [varchar](10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_BANDEJA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_BANDEJA](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BANDEJA] [varchar](50) NULL,
	[PERFIL] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_CANT_REPROCESO_TB_DINAMICA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_CANT_REPROCESO_TB_DINAMICA](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](50) NULL,
	[nombre_tipo_oferta] [varchar](50) NULL,
	[territorio] [varchar](150) NULL,
	[oficina] [varchar](150) NULL,
	[resultado] [varchar](150) NULL,
	[tipo] [varchar](50) NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[total] [int] NULL,
	[fecha_proceso] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_CANTIDAD_REPROCESO_DIARIO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_CANTIDAD_REPROCESO_DIARIO](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[periodo] [varchar](100) NULL,
	[tipo] [varchar](100) NULL,
	[fecha_ingreso] [varchar](100) NULL,
	[nombre_producto] [varchar](100) NULL,
	[nombre_tipo_oferta] [varchar](100) NULL,
	[territorio] [varchar](100) NULL,
	[oficina] [varchar](100) NULL,
	[resul] [varchar](100) NULL,
	[reprocesos] [int] NULL,
	[nro_expediente] [varchar](30) NULL,
	[fecha_proceso] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_CONSOLIDADO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_CS_CONSOLIDADO](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NUMERO_EXPEDIENTE] [nvarchar](255) NULL,
	[CORRELATIVO_ESTADO] [nvarchar](255) NULL,
	[CODIGO_OFICINA] [nvarchar](255) NULL,
	[EJECUTIVO] [nvarchar](255) NULL,
	[FLUJO_VIP] [nvarchar](100) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TB_CS_CONSOLIDADO_FULL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_CONSOLIDADO_FULL](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NRO_EXPEDIENTE] [varchar](20) NULL,
	[COD_SEGMENTO_CLIENTE] [varchar](20) NULL,
	[DESC_SEGMENTO_CLIENTE] [varchar](20) NULL,
	[CORRELATIVO_ESTADO] [varchar](10) NULL,
	[NOMBRE_ESTADO] [varchar](30) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[COD_USUARIO_CREACION] [varchar](20) NULL,
	[NOMBRE_USUARIO_CREACION] [varchar](100) NULL,
	[FECHA_CREACION] [datetime] NULL,
	[CORRELATIVO_OFICINA] [varchar](20) NULL,
	[CODIGO_OFICINA] [varchar](20) NULL,
	[NOMBRE_OFICINA] [varchar](100) NULL,
	[CODIGO_GARANTIA] [varchar](20) NULL,
	[DESCRIPCION_GARANTIA] [varchar](100) NULL,
	[CORRELATIVO_SUBPRODUCTO] [varchar](20) NULL,
	[NOMBRE_SUBPRODUCTO] [varchar](100) NULL,
	[CORRELATIVO_CLIENTE] [varchar](100) NULL,
	[APELLIDO_PATERNO_CLIENTE] [varchar](50) NULL,
	[APELLIDO_MATERNO_CLIENTE] [varchar](50) NULL,
	[NOMBRES_CLIENTE] [varchar](100) NULL,
	[TIPO_DOCUMENTO_IDENTIDAD] [varchar](50) NULL,
	[NUMERO_DOCUMENTO_IDENTIDAD] [varchar](50) NULL,
	[TIPO_CLIENTE] [varchar](30) NULL,
	[INGRESO_NETO_MENSUAL] [decimal](18, 2) NULL,
	[ESTADO_CIVIL] [varchar](20) NULL,
	[PERSONA_EXPUSTA_PUBLICA] [varchar](20) NULL,
	[PAGO_HABIENTE] [varchar](10) NULL,
	[SUBROGADO] [varchar](10) NULL,
	[TIPO_OFERTA] [varchar](20) NULL,
	[FLUJO_VIP] [varchar](10) NULL,
	[MONEDA_IMPORTE_SOLICITADO] [varchar](5) NULL,
	[IMPORTE_SOLICITADO] [decimal](18, 2) NULL,
	[MONEDA_IMPORTE_APROBADO] [varchar](5) NULL,
	[IMPORTE_APROBADO] [decimal](18, 2) NULL,
	[PLAZO_SOLICITADO] [varchar](5) NULL,
	[PLAZO_APROBADO] [varchar](5) NULL,
	[TIPO_RESOLUCION] [varchar](50) NULL,
	[CODIGO_PREEVALUADOR] [varchar](50) NULL,
	[CODIGO_RVGL] [varchar](50) NULL,
	[LINEA_CONSUMO] [decimal](18, 2) NULL,
	[RIESGO_CLIENTE_GRUPAL] [decimal](18, 2) NULL,
	[PORCENTAJE_ENDEUDAMIENTO] [decimal](18, 2) NULL,
	[CODIGO_CONTRATO] [varchar](50) NULL,
	[GRUPO_BURO] [varchar](10) NULL,
	[CLASIFICACION_SBS_TITULAR] [varchar](10) NULL,
	[CLASIFICACION_BANCO_TITULAR] [varchar](10) NULL,
	[CLASIFICACION_SBS_CONYUGE] [varchar](10) NULL,
	[CLASIFICACION_BANCO_CONYUGE] [varchar](10) NULL,
	[SCORING] [varchar](20) NULL,
	[TASA_ESPECIAL] [varchar](10) NULL,
	[FLAG_VERIF_DOMICILIARIA] [varchar](10) NULL,
	[ESTADO_VERIF_DOMICILIARIA] [varchar](20) NULL,
	[FLAG_VERIF_LABORAL] [varchar](10) NULL,
	[ESTADO_VERIF_LABORAL] [varchar](10) NULL,
	[FLAG_DPS] [varchar](10) NULL,
	[ESTADO_DPS] [varchar](10) NULL,
	[MODIFICAR_TASA] [varchar](10) NULL,
	[MODIFICAR_SCORING] [varchar](10) NULL,
	[INDICADOR_DELEGACION] [varchar](10) NULL,
	[INDICADOR_EXCLUSION_DELEGACION] [varchar](10) NULL,
	[NIVEL_COMPLEJIDAD] [varchar](10) NULL,
	[NRO_DEVOLUCIONES] [varchar](10) NULL,
	[CODIGO_USUARIO_ACTUAL] [varchar](10) NULL,
	[SIN_DELEGACION_OFICINA] [varchar](10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_ESTANDAR_BANDEJA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_CS_ESTANDAR_BANDEJA](
	[CODIGO] [nvarchar](5) NULL,
	[BANDEJA_LLEGADA] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TB_CS_PERCENTIL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_PERCENTIL](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FECHA] [datetime] NULL,
	[PERCENTIL] [decimal](10, 2) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_PERCENTIL_BANDEJA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_PERCENTIL_BANDEJA](
	[CODIGO] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FECHA] [datetime] NULL,
	[PERCENTIL] [decimal](10, 3) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL,
	[PERFIL] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_PERCENTIL_PERFIL_BANDEJA]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_PERCENTIL_PERFIL_BANDEJA](
	[CODIGO] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FECHA] [datetime] NULL,
	[PERCENTIL] [decimal](10, 3) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL,
	[PERFIL] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_TC_ADICIONAL_GIFOLE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_TC_ADICIONAL_GIFOLE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CODIGO_CENTRAL] [varchar](20) NULL,
	[NOMBRES] [varchar](200) NULL,
	[FECHA_HORA_REGISTRO] [datetime] NULL,
	[TARJETA] [varchar](100) NULL,
	[ESTADO] [varchar](30) NULL,
	[FECHA_HORA_MODIFICACION] [datetime] NULL,
	[CANAL] [varchar](30) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_TC_GIFOLE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_CS_TC_GIFOLE](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NRO_DOCUMENTO] [varchar](20) NULL,
	[NOMBRES] [varchar](200) NULL,
	[FECHA_HORA_REGISTRO] [datetime] NULL,
	[TARJETA] [varchar](40) NULL,
	[ESTADO] [varchar](40) NULL,
	[FECHA_HORA_MODIFICACION] [datetime] NULL,
	[CANAL] [varchar](30) NULL,
	[MONTO] [decimal](10, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_CS_TC_GIFOLE_PERCENTIL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_CS_TC_GIFOLE_PERCENTIL](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FECHA] [date] NULL,
	[PERCENTIL] [decimal](10, 2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TB_CS_TC_GIFOLE_PERCENTIL_MES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_CS_TC_GIFOLE_PERCENTIL_MES](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MES] [int] NULL,
	[ANIO] [int] NULL,
	[PERCENTIL] [decimal](10, 3) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TB_CS_TERRITORIO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_CS_TERRITORIO](
	[COD_OFI] [nvarchar](5) NULL,
	[NOM_OFIC] [nvarchar](100) NULL,
	[COD_TERRITORIO] [nvarchar](5) NULL,
	[NOM_TERRITORIO] [nvarchar](100) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TB_FUVEX]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_FUVEX](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FUERZA_DE_VENTA] [varchar](100) NULL,
	[MODALIDAD_DE_VENTA] [varchar](30) NULL,
	[PRODUCTO] [varchar](30) NULL,
	[COD_SUB_PRODUCTO] [varchar](15) NULL,
	[SUB_PRODUCTO] [varchar](100) NULL,
	[NRO_DE_SOLICITUD] [varchar](30) NULL,
	[DOI] [varchar](30) NULL,
	[FECHA_DE_REGISTRO] [varchar](100) NULL,
	[FECHA_DE_ESTADO] [varchar](100) NULL,
	[ESTADO_ACTUAL] [varchar](30) NULL,
	[FECHA_FORMALIZ_OPER] [varchar](100) NULL,
	[FECHA_ESTADO_COMISION] [varchar](100) NULL,
	[FECHA_ESTADO_ALTAMIRA] [varchar](100) NULL,
	[ESTADO_DE_ALTAMIRA] [varchar](50) NULL,
	[TIPO_DE_CAPTACION] [varchar](55) NULL,
	[CANAL_DE_VENTA] [varchar](100) NULL,
	[SUB_PRODUCTO2] [nvarchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_FUVEX_FUNNEL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_FUVEX_FUNNEL](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[PRODUCTO] [varchar](100) NULL,
	[DESCRIPCION] [varchar](100) NULL,
	[CANTIDAD] [int] NULL,
	[FECHA_PROCESO] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_FUVEX_PERCENTIL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_FUVEX_PERCENTIL](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[FECHA] [date] NULL,
	[PERCENTIL] [decimal](10, 2) NULL,
	[NOMBRE_PRODUCTO] [varchar](100) NULL,
	[NOMBRE_TIPO_OFERTA] [varchar](100) NULL,
	[PAPERLESS] [varchar](100) NULL,
	[TIPO] [varchar](100) NULL,
	[FRECUENCIA] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_FUVEX_RO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_FUVEX_RO](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[producto] [varchar](100) NULL,
	[nro] [varchar](5) NULL,
	[descripcion_estado] [varchar](100) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [int] NULL,
	[dia2] [int] NULL,
	[dia3] [int] NULL,
	[dia4] [int] NULL,
	[dia5] [int] NULL,
	[dia6] [int] NULL,
	[dia7] [int] NULL,
	[dia8] [int] NULL,
	[dia9] [int] NULL,
	[dia10] [int] NULL,
	[dia11] [int] NULL,
	[dia12] [int] NULL,
	[dia13] [int] NULL,
	[dia14] [int] NULL,
	[dia15] [int] NULL,
	[dia16] [int] NULL,
	[dia17] [int] NULL,
	[dia18] [int] NULL,
	[dia19] [int] NULL,
	[dia20] [int] NULL,
	[dia21] [int] NULL,
	[dia22] [int] NULL,
	[dia23] [int] NULL,
	[dia24] [int] NULL,
	[dia25] [int] NULL,
	[dia26] [int] NULL,
	[dia27] [int] NULL,
	[dia28] [int] NULL,
	[dia29] [int] NULL,
	[dia30] [int] NULL,
	[dia31] [int] NULL,
	[mes1] [int] NULL,
	[mes2] [int] NULL,
	[mes3] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_FUVEX_SUBPRODUCTO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_FUVEX_SUBPRODUCTO](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CODIGO] [varchar](50) NULL,
	[NOMBRE] [varchar](100) NULL,
	[TIPO] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_GIFOLE_FUNNEL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_GIFOLE_FUNNEL](
	[CODIGO] [int] IDENTITY(1,1) NOT NULL,
	[PRODUCTO] [varchar](100) NULL,
	[DESCRIPCION] [varchar](100) NULL,
	[CANTIDAD] [int] NULL,
	[FECHA_PROCESO] [date] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_HISTORIAL_CARGAS_CSV]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_HISTORIAL_CARGAS_CSV](
	[codigo] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[estado] [varchar](50) NULL,
	[archivo] [varchar](max) NULL,
	[fecha] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TB_PYMES_TERRITORIO]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_PYMES_TERRITORIO](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[COD_OFI] [float] NULL,
	[OFICINA] [nvarchar](255) NULL,
	[TERRITORIO] [nvarchar](255) NULL,
	[AMBITO] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TC_GIFOLE_OPERACIONES]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TC_GIFOLE_OPERACIONES](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[dia1] [decimal](18, 2) NULL,
	[dia2] [decimal](18, 2) NULL,
	[dia3] [decimal](18, 2) NULL,
	[dia4] [decimal](18, 2) NULL,
	[dia5] [decimal](18, 2) NULL,
	[dia6] [decimal](18, 2) NULL,
	[dia7] [decimal](18, 2) NULL,
	[dia8] [decimal](18, 2) NULL,
	[dia9] [decimal](18, 2) NULL,
	[dia10] [decimal](18, 2) NULL,
	[dia11] [decimal](18, 2) NULL,
	[dia12] [decimal](18, 2) NULL,
	[dia13] [decimal](18, 2) NULL,
	[dia14] [decimal](18, 2) NULL,
	[dia15] [decimal](18, 2) NULL,
	[dia16] [decimal](18, 2) NULL,
	[dia17] [decimal](18, 2) NULL,
	[dia18] [decimal](18, 2) NULL,
	[dia19] [decimal](18, 2) NULL,
	[dia20] [decimal](18, 2) NULL,
	[dia21] [decimal](18, 2) NULL,
	[dia22] [decimal](18, 2) NULL,
	[dia23] [decimal](18, 2) NULL,
	[dia24] [decimal](18, 2) NULL,
	[dia25] [decimal](18, 2) NULL,
	[dia26] [decimal](18, 2) NULL,
	[dia27] [decimal](18, 2) NULL,
	[dia28] [decimal](18, 2) NULL,
	[dia29] [decimal](18, 2) NULL,
	[dia30] [decimal](18, 2) NULL,
	[dia31] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TC_GIFOLE_OPERACIONES_ANUAL]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TC_GIFOLE_OPERACIONES_ANUAL](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion_estado] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[enero] [decimal](18, 2) NULL,
	[febrero] [decimal](18, 2) NULL,
	[marzo] [decimal](18, 2) NULL,
	[abril] [decimal](18, 2) NULL,
	[mayo] [decimal](18, 2) NULL,
	[junio] [decimal](18, 2) NULL,
	[julio] [decimal](18, 2) NULL,
	[agosto] [decimal](18, 2) NULL,
	[setiembre] [decimal](18, 2) NULL,
	[octubre] [decimal](18, 2) NULL,
	[noviembre] [decimal](18, 2) NULL,
	[diciembre] [decimal](18, 2) NULL,
	[total] [decimal](18, 2) NULL,
	[promedio] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TC_GIFOLE_OPERACIONES_DESGLOSE]    Script Date: 7/09/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TC_GIFOLE_OPERACIONES_DESGLOSE](
	[codigo] [int] IDENTITY(1,1) NOT NULL,
	[producto] [varchar](150) NULL,
	[descripcion] [varchar](150) NULL,
	[fecha_proceso] [date] NULL,
	[monto] [decimal](18, 2) NULL,
	[monto_porcentaje] [decimal](18, 2) NULL,
	[operaciones] [decimal](18, 2) NULL,
	[operaciones_porcentaje] [decimal](18, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetRoleClaims_RoleId]    Script Date: 7/09/2020 14:04:49 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId] ON [dbo].[AspNetRoleClaims]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [RoleNameIndex]    Script Date: 7/09/2020 14:04:49 ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[NormalizedName] ASC
)
WHERE ([NormalizedName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetUserClaims_UserId]    Script Date: 7/09/2020 14:04:49 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetUserLogins_UserId]    Script Date: 7/09/2020 14:04:49 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AspNetUserRoles_RoleId]    Script Date: 7/09/2020 14:04:49 ******/
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [EmailIndex]    Script Date: 7/09/2020 14:04:49 ******/
CREATE NONCLUSTERED INDEX [EmailIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UserNameIndex]    Script Date: 7/09/2020 14:04:49 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[NormalizedUserName] ASC
)
WHERE ([NormalizedUserName] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetRoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetRoleClaims] CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserTokens]  WITH CHECK ADD  CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserTokens] CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId]
GO
USE [master]
GO
ALTER DATABASE [CMI_CS_FUVEX] SET  READ_WRITE 
GO

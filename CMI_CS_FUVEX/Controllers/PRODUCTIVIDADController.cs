using System;
using System.Collections.Generic;
using System.Linq;
//using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

using CMI_CS_FUVEX.Models.Entities;
using CMI_CS_FUVEX.Data.DataAccess;
using System.Globalization;

using CMI_CS_FUVEX.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Hosting;


namespace CMI_CS_FUVEX.Controllers
{
    public class PRODUCTIVIDADController : Controller
    {
        private IHostingEnvironment hostingEnv;
        private readonly UserManager<ApplicationUser> userManager;

        public PRODUCTIVIDADController(IHostingEnvironment hostingEnv, UserManager<ApplicationUser> userManager)
        {
            this.hostingEnv = hostingEnv;
            this.userManager = userManager;
        }
        public IActionResult Index()
        {
            try { var user = userManager.GetUserAsync(User).Result.Codigo; ViewBag.Usuario = user; }
            catch (NullReferenceException e) { var ex = e.Message; }

            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string ano = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string encabezadoMes1 = "";
            string encabezadoMes2 = "";
            string encabezadoMes3 = "";

            encabezadoMes1 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes2 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes3 = Convert.ToDateTime(vGlobal.fecha).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;

            ViewBag.mes1 = encabezadoMes1;
            ViewBag.mes2 = encabezadoMes2;
            ViewBag.mes3 = encabezadoMes3; 
                 

            return View();
        }


        public IActionResult FunnelOperaciones()
        {
            try { var user = userManager.GetUserAsync(User).Result.Codigo; ViewBag.Usuario = user; }
            catch (NullReferenceException e) { var ex = e.Message; }

            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string ano = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string encabezadoMes1 = "";
            string encabezadoMes2 = "";
            string encabezadoMes3 = "";

            encabezadoMes1 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes2 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes3 = Convert.ToDateTime(vGlobal.fecha).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;

            ViewBag.mes1 = encabezadoMes1;
            ViewBag.mes2 = encabezadoMes2;
            ViewBag.mes3 = encabezadoMes3;

            return View();
        }



        public List<PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH> FunMostrarGrafico(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.TraerGraficosProductividad(fechag, nombre).ToList();

            return model;

        }

        public List<PLD_TC_CONVENIO_FUNNEL_ACUMULADO> FunMostrarFunnelAcumulado(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            int mes = Convert.ToDateTime(vGlobal.fecha).Month;

            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;
            
            var model = da.TraerFunnelAcumuladoGrafico(fechag, nombre).ToList();

            //ViewBag.ingresados = da.TraerFunnelAcumuladoGrafico(fechag, nombre).
            //    Where(c => c.producto == nombre && c.tipo == "INGRESADOS" && c.fecha_proceso == fechag && c.mes == mes).Select(c => c.cantidad);

            return model;

        }


        public string GetDiferenciasDataCount(string producto_nombre, string bandeja)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            ContSencDA da = new ContSencDA();

            var model = da.GetDiferencia(producto_nombre, bandeja, fechag).Count();

            return model.ToString();
        }

        public List<FDIFERENCIAS> GetDiferenciasData(string producto_nombre, string bandeja)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            ContSencDA da = new ContSencDA();

            var model = da.GetDiferencia(producto_nombre, bandeja, fechag).ToList();

            return model;
        }

        public List<FPERFIL_RECHAZO> GetPerfilesData(int id)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            ContSencDA da = new ContSencDA();

            var model = da.GetPerfilesRechazo(id).ToList();

            return model;
        }       


        public string FunGrabarDesgloseFunnel(string vCadPerfilRechazo, string producto, string perfil, int resta,
            decimal porcentaje, int rechazados, int proceso)
        {

            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            //------------------------------------ DIFERENCIAS
            FDIFERENCIAS dif = new FDIFERENCIAS();

            dif.producto = producto;
            dif.bandeja = perfil;
            dif.resta = resta;
            dif.porcentaje = porcentaje;
            dif.rechazados = rechazados;
            dif.enproceso = proceso;
            dif.fecha_proceso = fechag;

            var difInsert = da.InsertDiferencia(dif);            

            //------------------------------------ PERFILES QUE RECHAZAN

            string[] valores;

            foreach (var word in vCadPerfilRechazo.Split('}'))
            {
                FPERFIL_RECHAZO perfo = new FPERFIL_RECHAZO();

                valores = word.Split('|');

                perfo.id_diferencia = dif.id;
                perfo.perfil = valores[0];
                perfo.perfil_rechazo = valores[1];
                perfo.qty = Convert.ToInt16(valores[2]);
                perfo.fecha_proceso = fechag;               

                var perfinsert = da.InsertPerfil(perfo);

            }  
            //ViewBag.CodigoCalidad = cal.codigo;
            
           return "INSERTO";
          
        }


        public string FunActualizarDesgloseFunnel(string vCadPerfilRechazo, int id, int resta,
            decimal porcentaje, int rechazados, int proceso)
        {

            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            //------------------------------------ DIFERENCIAS
            FDIFERENCIAS dif = new FDIFERENCIAS();

            dif.id = id;
            dif.resta = resta;
            dif.porcentaje = porcentaje;
            dif.rechazados = rechazados;
            dif.enproceso = proceso;           

            var difUpdate = da.UpdateDiferencia(dif);

            //------------------------------------ PERFILES QUE RECHAZAN

            string[] valores;

            foreach (var word in vCadPerfilRechazo.Split('}'))
            {
                FPERFIL_RECHAZO perfo = new FPERFIL_RECHAZO();

                valores = word.Split('|');

                perfo.id = Convert.ToInt16(valores[0]);
                perfo.perfil = valores[1];
                perfo.qty = Convert.ToInt16(valores[2]);                

                var perfupdt = da.UpdatePerfil(perfo);

            }
            //ViewBag.CodigoCalidad = cal.codigo;

            return "ACTUALIZO";

        }


        public string GetMotivosDataCount(int idperfil)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            ContSencDA da = new ContSencDA();

            var model = da.GetMotivos(idperfil).Count();

            return model.ToString();
        }



        public string FunGrabarMotivos(string vCadMotivo)
        {

            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            //------------------------------------ MOTIVOS DE CADA PERFIL QUE RECHAZAN

            string[] valores;

            foreach (var word in vCadMotivo.Split('}'))
            {
                FMOTIVO motivo = new FMOTIVO();

                valores = word.Split('|');

                motivo.id_perfil = Convert.ToInt16(valores[0]);
                motivo.perfil = valores[1];
                motivo.motivo = valores[2];
                motivo.qty = Convert.ToInt16(valores[3]);
                motivo.fecha_proceso = fechag;

                var motivoInsert = da.InsertMotivo(motivo);

            }
            //ViewBag.CodigoCalidad = cal.codigo;

            return "INSERTO";

        }

        public List<FMOTIVO> GetMotivosData(int idperfil)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            ContSencDA da = new ContSencDA();

            var model = da.GetMotivos(idperfil).ToList();

            return model;
        }

        public string FunActualizarMotivos(string vCadMotivoUpdate)
        {

            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
         
            //------------------------------------ MOTIVOS QUE RECHAZAN

            string[] valores;

            foreach (var word in vCadMotivoUpdate.Split('}'))
            {
                FMOTIVO motivo = new FMOTIVO();

                valores = word.Split('|');

                motivo.id = Convert.ToInt16(valores[0]);              
                motivo.qty = Convert.ToInt16(valores[1]);
                motivo.fecha_proceso = fechag;


                var motivoUpd = da.UpdateMotivo(motivo);

            }
            //ViewBag.CodigoCalidad = cal.codigo;

            return "ACTUALIZO";

        }

        public IActionResult TuberiaCS()
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string ano = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string encabezadoMes1 = "";
            string encabezadoMes2 = "";
            string encabezadoMes3 = "";

            encabezadoMes1 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes2 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes3 = Convert.ToDateTime(vGlobal.fecha).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;

            ViewBag.mes1 = encabezadoMes1;
            ViewBag.mes2 = encabezadoMes2;
            ViewBag.mes3 = encabezadoMes3;

            return View();
        }

        public IActionResult TuberiaTC()
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string ano = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string encabezadoMes1 = "";
            string encabezadoMes2 = "";
            string encabezadoMes3 = "";

            encabezadoMes1 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes2 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes3 = Convert.ToDateTime(vGlobal.fecha).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;

            ViewBag.mes1 = encabezadoMes1;
            ViewBag.mes2 = encabezadoMes2;
            ViewBag.mes3 = encabezadoMes3;

            return View();
        }

        public IActionResult TuberiaConv()
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string ano = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string encabezadoMes1 = "";
            string encabezadoMes2 = "";
            string encabezadoMes3 = "";

            encabezadoMes1 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes2 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes3 = Convert.ToDateTime(vGlobal.fecha).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;

            ViewBag.mes1 = encabezadoMes1;
            ViewBag.mes2 = encabezadoMes2;
            ViewBag.mes3 = encabezadoMes3;

            return View();
        }


        public List<PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA> FunMostrarTuberia(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            int mes = Convert.ToDateTime(vGlobal.fecha).Month;

            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarTuberia(fechag, nombre).ToList();            

            return model;

        }


        public List<PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES> FunTraerSeguimientoOperaciones(string nombre)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            //int mes = Convert.ToDateTime(vGlobal.fecha).Month;

            var da = new ContSencDA();            

            var model = da.GetSeguimientoOperaciones(fechag, nombre).ToList();

            return model;

        }


        public List<TB_FUVEX_PERCENTIL> FunTraerFuvexPercentiles(int mes, int anio, string producto, 
            string paperless,string tipo)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            //int mes = Convert.ToDateTime(vGlobal.fecha).Month;

            var da = new ContSencDA();

            var model = da.TraerFuvexPercentiles(mes,anio,producto,paperless,tipo).ToList();

            return model;

        }

        public IActionResult FunnelOperacionesFuvex()
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string ano = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string encabezadoMes1 = "";
            string encabezadoMes2 = "";
            string encabezadoMes3 = "";

            encabezadoMes1 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes2 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes3 = Convert.ToDateTime(vGlobal.fecha).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;

            ViewBag.mes1 = encabezadoMes1;
            ViewBag.mes2 = encabezadoMes2;
            ViewBag.mes3 = encabezadoMes3;

            return View();
        }

        public List<TB_FUVEX_FUNNEL> FunTraerFunnelFuvex(string nombre)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            //int mes = Convert.ToDateTime(vGlobal.fecha).Month;

            var da = new ContSencDA();

            var model = da.TraerFuvexFunnel(fechag, nombre).ToList();

            return model;

        }


        public IActionResult FunnelOperacionesGifole()
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string ano = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            string encabezadoMes1 = "";
            string encabezadoMes2 = "";
            string encabezadoMes3 = "";

            encabezadoMes1 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes2 = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;
            encabezadoMes3 = Convert.ToDateTime(vGlobal.fecha).ToString("MMMM", CultureInfo.CreateSpecificCulture("es")) + "-" + ano;

            ViewBag.mes1 = encabezadoMes1;
            ViewBag.mes2 = encabezadoMes2;
            ViewBag.mes3 = encabezadoMes3;

            return View();
        }

        public List<TB_GIFOLE_FUNNEL> FunTraeFunnelGifole(string nombre)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            //int mes = Convert.ToDateTime(vGlobal.fecha).Month;

            var da = new ContSencDA();

            var model = da.TraerGifoleFunnel(fechag, nombre).ToList();

            return model;

        }



    }
}
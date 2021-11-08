using System;
using System.Collections.Generic;
using System.Linq;
//using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
//using CMI_CS_FUVEX.Data;

using CMI_CS_FUVEX.Data.DataAccess;
using CMI_CS_FUVEX.Models.Entities;


using CMI_CS_FUVEX.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Hosting;


namespace CMI_CS_FUVEX.Controllers
{
    public class PLD_TC_CONVENIOController : Controller
    {
        private IHostingEnvironment hostingEnv;
        private readonly UserManager<ApplicationUser> userManager;

        public PLD_TC_CONVENIOController(IHostingEnvironment hostingEnv, UserManager<ApplicationUser> userManager)
        {
            this.hostingEnv = hostingEnv;
            this.userManager = userManager;
        }

        public IActionResult Index(string nombre, string tipo, string txtTras)
        {
            try { var user = userManager.GetUserAsync(User).Result.Codigo; ViewBag.Usuario = user; }
            catch (NullReferenceException e) { var ex = e.Message; }

            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            ViewBag.txtTras = txtTras;
            ViewBag.nombre = nombre;
            ViewBag.tipo = tipo;           

            return View();
        }

        public List<PLD_TC_CONVENIO> FunListarCS(string nombre, string tipo, string trans)
        {
            string vMes = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            string vAno = Convert.ToDateTime(vGlobal.fecha).Year.ToString();
            string vDia = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            //--------------- 
            //ViewBag.DAY = vGlobal.dia;
            //ViewBag.MES = vGlobal.mes;
            //ViewBag.YEAR = vGlobal.ano;

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);// Convert.ToDateTime(vGlobal.dia + "/" + vGlobal.mes + "/" + vGlobal.ano);         
            var da = new ContSencDA();

            var model_Global = da.Cs_Listar(fechag, tipo, nombre).ToList();
            return model_Global;

        }
        public List<PLD_TC_CONVENIO> FunListarFUVEX(string nombre, string tipo, string trans)
        {
            string vMes = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            string vAno = Convert.ToDateTime(vGlobal.fecha).Year.ToString();
            string vDia = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            //--------------- 
            //ViewBag.DAY = vGlobal.dia;
            //ViewBag.MES = vGlobal.mes;
            //ViewBag.YEAR = vGlobal.ano;

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);// Convert.ToDateTime(vGlobal.dia + "/" + vGlobal.mes + "/" + vGlobal.ano);         
            var da = new ContSencDA();

            var model_Global = da.Fuvex_Listar(fechag, tipo, nombre).ToList();
            return model_Global;

        }

        public List<PLD_TC_CONVENIO> FunListarGifole(string nombre, string tipo, string trans)
        {
            string vMes = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            string vAno = Convert.ToDateTime(vGlobal.fecha).Year.ToString();
            string vDia = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            //--------------- 
            //ViewBag.DAY = vGlobal.dia;
            //ViewBag.MES = vGlobal.mes;
            //ViewBag.YEAR = vGlobal.ano;

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);// Convert.ToDateTime(vGlobal.dia + "/" + vGlobal.mes + "/" + vGlobal.ano);         
            var da = new ContSencDA();

            var model_Global = da.Gifole_Listar(fechag, tipo, nombre).ToList();
            return model_Global;

        }


        public IActionResult Resumen_Detalle(DateTime fecha_proceso, string nombre, int MES = 0, int YEAR = 0, int DAY = 0) 
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            var da = new ContSencDA();

            DateTime fecha = Convert.ToDateTime(DAY + "/" + MES + "/" + YEAR);

            var model = da.ListaDetalle_Reprocesados(fecha_proceso, fecha, nombre);

            return View(model);
        }


        public IActionResult Resumen_Detalle_Tiempos(string nombre, string oferta, string tipo, decimal percentil, int MES = 0, int YEAR = 0, int DAY = 0)
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            var da = new ContSencDA();

            DateTime fecha = Convert.ToDateTime(DAY + "/" + MES + "/" + YEAR);
            
            ViewBag.mesdata= MES;
            ViewBag.aniodata = YEAR;
            ViewBag.diadata = DAY;

            var model = da.ListaDetalle_Tiempos(fecha, nombre, oferta, tipo);

            decimal perc  = model.Where(p => p.tiempo == percentil).Select(e => e.tiempo).FirstOrDefault();
            
            ViewBag.percentil = perc;

            return View(model);
        }


        public IActionResult Resumen_Detalle_Tiempos_Bandejas(string expediente, string producto,string oferta, int MES = 0, int YEAR = 0, int DAY = 0)
        {
           
            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            var model = da.ListarDetalleTiempoExpedienteXBbja(fechag, expediente);

            ViewBag.producto = producto;
            ViewBag.oferta = oferta;
            ViewBag.MES = MES;
            ViewBag.YEAR = YEAR;
            ViewBag.DAY = DAY;


            return View(model);
        }

        public IActionResult UpdateIndicadores(int codigo)
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            var da = new ContSencDA();

            var model = da.GetIndicadoresResumen(codigo);

            return View(model);
        }


        [HttpPost]
        public IActionResult UpdateIndicadores(PLD_TC_CONVENIO res)
        {
            var da = new ContSencDA();

            var model = da.UpdateIndicadoresResumen(res);

            if (model > 0)
            {
                return RedirectToAction("Index");
            }
            else
            {
                return View(res);
            }
        }


    }
}
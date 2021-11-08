using System;
using System.Collections.Generic;
using System.Linq;
//using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

using CMI_CS_FUVEX.Models.Entities;
using CMI_CS_FUVEX.Data.DataAccess;

using CMI_CS_FUVEX.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Hosting;

namespace CMI_CS_FUVEX.Controllers
{
    public class ACUMULADOController : Controller
    {

        private IHostingEnvironment hostingEnv;
        private readonly UserManager<ApplicationUser> userManager;

        public ACUMULADOController(IHostingEnvironment hostingEnv, UserManager<ApplicationUser> userManager)
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


            return View();
        }

        public List<PLD_TC_CONVENIO_RS_ACUMULADO> FunLoadResumenAcumulado(string nombre, string tipo)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarRSacumulado(fechag, tipo, nombre).ToList();

            return model;

        }


        public string FunGrabarAcumulados(string producto, string numero_item, string descripcion_estado,
            decimal dia1, decimal dia2, decimal dia3, decimal dia4, decimal dia5, decimal dia6, decimal dia7, decimal dia8,
            decimal dia9, decimal dia10, decimal dia11, decimal dia12, decimal dia13, decimal dia14, decimal dia15,
            decimal dia16, decimal dia17, decimal dia18, decimal dia19, decimal dia20, decimal dia21, decimal dia22,
            decimal dia23, decimal dia24, decimal dia25, decimal dia26, decimal dia27, decimal dia28, decimal dia29, decimal dia30, decimal dia31,
            decimal mes1, decimal mes2, decimal mes3, int vCodigo, string vAccion)
        {

            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            PLD_TC_CONVENIO_RS_ACUMULADO acum = new PLD_TC_CONVENIO_RS_ACUMULADO();

            acum.producto = producto;
            acum.nro = numero_item;
            acum.descripcion_estado = descripcion_estado;
            acum.fecha_proceso = fechag;
            acum.dia1 = dia1;
            acum.dia2 = dia2;
            acum.dia3 = dia3;
            acum.dia4 = dia4;
            acum.dia5 = dia5;
            acum.dia6 = dia6;
            acum.dia7 = dia7;
            acum.dia8 = dia8;
            acum.dia9 = dia9;
            acum.dia10 = dia10;
            acum.dia11 = dia11;
            acum.dia12 = dia12;
            acum.dia13 = dia13;
            acum.dia14 = dia14;
            acum.dia15 = dia15;
            acum.dia16 = dia16;
            acum.dia17 = dia17;
            acum.dia18 = dia18;
            acum.dia19 = dia19;
            acum.dia20 = dia20;
            acum.dia21 = dia21;
            acum.dia22 = dia22;
            acum.dia23 = dia23;
            acum.dia24 = dia24;
            acum.dia25 = dia25;
            acum.dia26 = dia26;
            acum.dia27 = dia27;
            acum.dia28 = dia28;
            acum.dia29 = dia29;
            acum.dia30 = dia30;
            acum.dia31 = dia31;
            acum.mes1 = mes1;
            acum.mes2 = mes2;
            acum.mes3 = mes3;

            if (vAccion != "null")
            {
                acum.codigo = vCodigo;
                var calupdate = da.UpdateRegistroAcumulado(acum);
            }
            else
            {
                var calidadInsert = da.InsertAcumulados(acum);               
            }

            //ViewBag.CodigoCalidad = cal.codigo;

            if (vAccion != "null")
            {
                return "ACTUALIZO";
            }
            else
            {
                return "INSERTO";
            }
        }






    }
}
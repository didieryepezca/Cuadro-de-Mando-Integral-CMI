using System;
using System.Collections.Generic;
using System.Linq;
//using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Globalization;

using CMI_CS_FUVEX.Models.Entities;
using CMI_CS_FUVEX.Data.DataAccess;


using CMI_CS_FUVEX.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Hosting;

namespace CMI_CS_FUVEX.Controllers
{
    public class CALIDADController : Controller
    {
        private IHostingEnvironment hostingEnv;
        private readonly UserManager<ApplicationUser> userManager;

        public CALIDADController(IHostingEnvironment hostingEnv, UserManager<ApplicationUser> userManager)
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



        public List<PLD_TC_CONVENIO_CALIDAD> FunListarCalidad(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarPestañaCalidad(fechag, tipo, nombre).ToList();

            return model;

        }

        public string FunGrabarANS(string vCad, string producto, string numero_item, string descripcion_estado, 
            decimal dia1, decimal dia2, decimal dia3, decimal dia4, decimal dia5, decimal dia6, decimal dia7, decimal dia8, 
            decimal dia9, decimal dia10, decimal dia11, decimal dia12, decimal dia13, decimal dia14, decimal dia15,
            decimal dia16, decimal dia17, decimal dia18, decimal dia19, decimal dia20, decimal dia21, decimal dia22,
            decimal dia23, decimal dia24, decimal dia25, decimal dia26, decimal dia27, decimal dia28, decimal dia29, decimal dia30, decimal dia31,
            decimal mes1, decimal mes2, decimal mes3, int vCodigo, string vAccion)
        {

            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            if (descripcion_estado == "ANS - Efectividad")
            {
                //Borramos el registro anterior de la pestaña Resumen antes de ingresar el nuevo.
                var resold = da.DeleteRegistroResumen(producto, descripcion_estado, fechag);

                PLD_TC_CONVENIO resum = new PLD_TC_CONVENIO();

                resum.producto = producto;
                resum.descripcion = "ANS - Efectividad";
                resum.valor_objetivo = 80;
                resum.fecha_proceso = fechag;
                resum.dia1 = dia1;
                resum.dia2 = dia2;
                resum.dia3 = dia3;
                resum.dia4 = dia4;
                resum.dia5 = dia5;
                resum.dia6 = dia6;
                resum.dia7 = dia7;
                resum.dia8 = dia8;
                resum.dia9 = dia9;
                resum.dia10 = dia10;
                resum.dia11 = dia11;
                resum.dia12 = dia12;
                resum.dia13 = dia13;
                resum.dia14 = dia14;
                resum.dia15 = dia15;
                resum.dia16 = dia16;
                resum.dia17 = dia17;
                resum.dia18 = dia18;
                resum.dia19 = dia19;
                resum.dia20 = dia20;
                resum.dia21 = dia21;
                resum.dia22 = dia22;
                resum.dia23 = dia23;
                resum.dia24 = dia24;
                resum.dia25 = dia25;
                resum.dia26 = dia26;
                resum.dia27 = dia27;
                resum.dia28 = dia28;
                resum.dia29 = dia29;
                resum.dia30 = dia30;
                resum.dia31 = dia31;
                resum.mes1 = mes1;
                resum.mes2 = mes2;
                resum.mes3 = mes3;

                var resnew = da.InsertRegistroResumen(resum);
                    
            }           

                PLD_TC_CONVENIO_CALIDAD cal = new PLD_TC_CONVENIO_CALIDAD();

                cal.producto = producto;
                cal.nro = numero_item;
                cal.descripcion_estado = descripcion_estado;
                cal.fecha_proceso = fechag;
                cal.dia1 = dia1;
                cal.dia2 = dia2;
                cal.dia3 = dia3;
                cal.dia4 = dia4;
                cal.dia5 = dia5;
                cal.dia6 = dia6;
                cal.dia7 = dia7;
                cal.dia8 = dia8;
                cal.dia9 = dia9;
                cal.dia10 = dia10;
                cal.dia11 = dia11;
                cal.dia12 = dia12;
                cal.dia13 = dia13;
                cal.dia14 = dia14;
                cal.dia15 = dia15;
                cal.dia16 = dia16;
                cal.dia17 = dia17;
                cal.dia18 = dia18;
                cal.dia19 = dia19;
                cal.dia20 = dia20;
                cal.dia21 = dia21;
                cal.dia22 = dia22;
                cal.dia23 = dia23;
                cal.dia24 = dia24;
                cal.dia25 = dia25;
                cal.dia26 = dia26;
                cal.dia27 = dia27;
                cal.dia28 = dia28;
                cal.dia29 = dia29;
                cal.dia30 = dia30;
                cal.dia31 = dia31;
                cal.mes1 = mes1;
                cal.mes2 = mes2;
                cal.mes3 = mes3;            

            if (vAccion != "null")
            {
                cal.codigo = vCodigo;
                var calupdate = da.UpdateRegistroCalidad(cal);
            }
            else {
                var calidadInsert = da.InsertCalidad(cal);

                string[] valores;

                foreach (var word in vCad.Split('}'))
                {
                    PLD_TC_CONVENIO_CALIDAD_GRAPH cal_graph = new PLD_TC_CONVENIO_CALIDAD_GRAPH();

                    valores = word.Split('|');

                    cal_graph.producto = valores[0];
                    cal_graph.descripcion_estado = valores[1];
                    cal_graph.fecha_proceso = fechag;
                    cal_graph.dia_nombre = valores[2];
                    cal_graph.valor = Convert.ToDecimal(valores[3]);

                    var calGrafico = da.InsertCalidadPuntosGrafico(cal_graph);

                }
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

        public List<PLD_TC_CONVENIO_CALIDAD_GRAPH> FunCalidadGraficos(string nombre, string estado)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();           


            var model = da.ListarCalidadGraficos(fechag, nombre, estado).ToList();

            return model;

        }

        public string GetFiabilidadDataCount(string nombre, string descripcion)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            ContSencDA da = new ContSencDA();

            var model = da.GetFiabilidades(fechag, nombre, descripcion).Count();

            return model.ToString();
        }
        public List<PLD_TC_CONVENIO_CALIDAD_GRAPH> FunCalidadFiabilidadData(string nombre, string estado)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();


            var model = da.ListarCalidadFiabilidadGraficos(fechag, nombre, estado).ToList();

            return model;

        }
        public string FunGrabarFiabilidad(string vCadFiabilidad) 
        {
            var da = new ContSencDA();

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);

            string[] valores;

            foreach (var word in vCadFiabilidad.Split('}'))
            {
                PLD_TC_CONVENIO_CALIDAD_GRAPH cal_graph = new PLD_TC_CONVENIO_CALIDAD_GRAPH();

                valores = word.Split('|');

                cal_graph.producto = valores[0];
                cal_graph.descripcion_estado = valores[1];
                cal_graph.fecha_proceso = fechag;
                cal_graph.dia_nombre = valores[3];
                cal_graph.valor = Convert.ToDecimal(valores[4]);

                var calGrafico = da.InsertCalidadPuntosGrafico(cal_graph);

            }

            return "GRABO";
        }

        public IActionResult UpdateDatoFiabilidad(int codigo)
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            var da = new ContSencDA();

            var model = da.GetDatoFiabilidad(codigo);

            return View(model);
        }

        [HttpPost]
        public IActionResult UpdateDatoFiabilidad(PLD_TC_CONVENIO_CALIDAD_GRAPH fiab)
        {
            var da = new ContSencDA();

            var model = da.UpdateDatoFiabilidad(fiab);

            if (model > 0)
            {
                return RedirectToAction("Index");
            }
            else
            {             
                return View(fiab);
            }
        }



        public List<TB_FUVEX_RO> FunFuvexRO(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarFuvexRO(fechag, tipo, nombre).ToList();

            return model;

        }




    }
}
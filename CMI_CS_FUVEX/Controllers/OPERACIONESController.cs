using System;
using System.Collections.Generic;
using System.Linq;
//using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
//using Newtonsoft.Json;
using CMI_CS_FUVEX.Models.Entities;
using CMI_CS_FUVEX.Data.DataAccess;

namespace CMI_CS_FUVEX.Controllers
{
    public class OPERACIONESController : Controller
    {
        public IActionResult Index(string nombre, string tipo, string txtTras)
        {
            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            ViewBag.txtTras = txtTras;
            ViewBag.nombre = nombre;
            ViewBag.tipo = tipo;           

            return View();
        }

        public List<PLD_TC_CONVENIO_OPERACIONES> FunListarOperaciones(string nombre, string tipo, string trans) 
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            var model = da.CS_ListarOperaciones(fechag, tipo, nombre).ToList();

            return model;
        }

        public List<TC_GIFOLE_OPERACIONES> FunListarOperacionesGifole(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            var model = da.ListarGifole_Operaciones(fechag, tipo, nombre).ToList();

            return model;

        }

        public List<PLD_TC_CONVENIO_OPERACIONES_ANUAL> FunListarOperacionesAnual(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            var model = da.CS_ListarOperacionesAnual(fechag, tipo, nombre).ToList();

            return model;
        }

        public List<TC_GIFOLE_OPERACIONES_ANUAL> FunListarOperacionesAnualGifole(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            var model = da.Gifole_ListarOperacionesAnual(fechag, tipo, nombre).ToList();

            return model;
        }

        public List<PLD_TC_CONVENIO_OPERACIONES_GRAPH> FunListarOperacionesGrafico(string nombre, string tipo, string trans) 
        {

            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            var da = new ContSencDA();
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);            


            
            var modelGraph = da.CS_ListarOperaciones_Graph(fechag, tipo, nombre).ToList();

            //------------- Lista de datapoints                       
            //List<DataPoint> dataPointsd1 = new List<DataPoint>();

            //foreach (var grafico in modelGraph)
            //{

            //    DataPoint x1 = new DataPoint(grafico.dia_nombre, Convert.ToDouble(grafico.cantidad_monto));
            //    dataPointsd1.Add(x1);
            //}         

            //ViewBag.dataPointsDAYS = JsonConvert.SerializeObject(dataPointsd1);           

            return modelGraph;
        }

        public List<PLD_TC_CONVENIO_OPERACIONES_DESGLOSE> FunListarOperacionesDesglose(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            var model = da.CS_ListarOperaciones_Desglose(fechag, tipo, nombre).ToList();

            return model;

        }

        public List<TC_GIFOLE_OPERACIONES_DESGLOSE> FunListarOperacionesDesgloseGifole(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            var model = da.Gifole_ListarOperaciones_Desglose(fechag, tipo, nombre).ToList();

            return model;

        }

        


    }
}

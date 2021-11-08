using System;
using System.Collections.Generic;
using System.Linq;
//using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

using CMI_CS_FUVEX.Models.Entities;
using CMI_CS_FUVEX.Data.DataAccess;

namespace CMI_CS_FUVEX.Controllers
{
    public class CONTROLController : Controller
    {
        public IActionResult Index(string nombre, string tipo, string txtTras)
        {

            ViewBag.MESUNO = Convert.ToDateTime(vGlobal.fecha).AddMonths(-2).Month.ToString();
            ViewBag.MESDOS = Convert.ToDateTime(vGlobal.fecha).AddMonths(-1).Month.ToString();

            ViewBag.DAY = Convert.ToDateTime(vGlobal.fecha).Day.ToString();
            ViewBag.MES = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            ViewBag.YEAR = Convert.ToDateTime(vGlobal.fecha).Year.ToString();

            ViewBag.txtTras = txtTras;
            ViewBag.nombre = nombre;
            ViewBag.tipo = tipo;

            return View();
        }


        public List<TB_CS_PERCENTIL_BANDEJA> FunListarBandeja(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarTiemposBandeja(fechag, tipo, nombre).ToList();

            return model;

        }

        public List<TB_CS_PERCENTIL_PERFIL_BANDEJA> FunListarPerfilBandeja(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarTiemposPerfilBandeja(fechag, tipo, nombre).ToList();

            return model;

        }


        public List<PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH> FunListarHistogramas(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarHistogramas(fechag, tipo, nombre).ToList();

            return model;

        }



        public List<PLD_TC_CONVENIO_REPROCESOS_GRAPH> FunListarPorcentajeReprocesos(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarPorcentajesReprocesos(fechag, tipo, nombre).ToList();

            return model;

        }



        public List<PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS> FunListarHistogramasReprocesos(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarHistReprocesos(fechag, tipo, nombre).ToList();

            return model;

        }


        public List<PLD_TC_CONVENIO> FunListarCS(string nombre, string tipo, string trans)
        {
            string vMes = Convert.ToDateTime(vGlobal.fecha).Month.ToString();
            string vAno = Convert.ToDateTime(vGlobal.fecha).Year.ToString();
            string vDia = Convert.ToDateTime(vGlobal.fecha).Day.ToString();      

            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            // Convert.ToDateTime(vGlobal.dia + "/" + vGlobal.mes + "/" + vGlobal.ano);         
            var da = new ContSencDA();
          
            var model_Global = da.Cs_Listar(fechag, tipo, nombre).ToList();
            return model_Global;
          
        }




        public List<PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH> FunListarCantidadReprocesos(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarCantidadReprocesos(fechag, tipo, nombre).ToList();

            return model;

        }


        public List<PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH> FunListarReprocesosAcum(string nombre, string tipo, string trans)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarReprocesosAcumulado(fechag, tipo, nombre).ToList();

            return model;

        }


        public List<TB_CS_CANT_REPROCESO_TB_DINAMICA> FunListarTablaDinamica(string nombre, string tipo, string resul, string sector)
        {
            DateTime fechag = Convert.ToDateTime(vGlobal.fecha);
            var da = new ContSencDA();

            ViewBag.NombreProducto = nombre;

            var model = da.ListarTablaDinamicaTotales(fechag, tipo, nombre, resul, sector ).ToList();

            return model;

        }




    }
}
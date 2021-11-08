using System;
//using System.Collections.Generic;
//using System.Diagnostics;
//using System.Linq;
//using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using CMI_CS_FUVEX.Models.Entities;

namespace CMI_CS_FUVEX.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View();
        }


        public string funActualizarFecha(string fecha)
        {
            string[] cadena = fecha.Split('-');

            string mes = cadena[1];
            string ano = cadena[0];
            string dia = cadena[2];

            //if (mes == DateTime.Now.Month.ToString())
            //{
            //    dia = DateTime.Now.Day.ToString();
            //}
            //else
            //{

            //    DateTime x = Convert.ToDateTime(ano + "-" + mes + "-" + "01");
            //    dia = x.AddMonths(1).AddDays(-1).Day.ToString();
            //}

            vGlobal.fecha = Convert.ToDateTime(ano + "-" + mes + "-" + dia).ToString();

            ViewBag.fecha = vGlobal.fecha;

            return ano + "-" + mes + "-01";
        }
    }
}

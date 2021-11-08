using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class vGlobal
    {
        public static String fecha = DateTime.Now.ToString("yyyy-MM-dd");

        //public static string fecha = DateTime.Parse("2019-10-31").ToString();

        public static int dia = DateTime.Now.Day;
        public static int mes = DateTime.Now.Month;
        public static int ano = DateTime.Now.Year;

    }
}

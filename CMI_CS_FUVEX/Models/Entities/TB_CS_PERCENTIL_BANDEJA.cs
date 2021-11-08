using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class TB_CS_PERCENTIL_BANDEJA
    {
        [Key]
        public int CODIGO { get; set; }
        public DateTime FECHA { get; set; }
        public decimal PERCENTIL { get; set; }
        public string NOMBRE_PRODUCTO { get; set; }
        public string NOMBRE_TIPO_OFERTA { get; set; }
        public string TIPO { get; set; }
        public string PERFIL { get; set; }
    }
}

using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH
    {
        [Key]
        public int codigo { get; set; }
        public string NOMBRE_PRODUCTO { get; set; }
        public string TIPO { get; set; }
        public string RANGO { get; set; }
        public int F { get; set; }
        public int FT { get; set; }
        public decimal H { get; set; }
        public decimal HT { get; set; }
        public DateTime FECHA { get; set; }
    }
}

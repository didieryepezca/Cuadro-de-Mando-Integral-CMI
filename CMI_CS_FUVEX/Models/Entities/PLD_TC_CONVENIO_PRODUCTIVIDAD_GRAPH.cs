using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH
    {
        [Key]
        public int codigo { get; set; }
        public string producto { get; set; }
        public string oferta { get; set; }
        public string tipo { get; set; }
        public decimal percentil { get; set; }
        public string dia_nombre { get; set; }
        public DateTime fecha { get; set; }
        public DateTime fecha_proceso { get; set; }
    }
}

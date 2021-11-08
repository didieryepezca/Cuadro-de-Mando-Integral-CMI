using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_CALIDAD_GRAPH
    {
        [Key]
        public int codigo { get; set; }
        public string producto { get; set; }
        public string descripcion_estado { get; set; }
        public DateTime fecha_proceso { get; set; }
        public string dia_nombre { get; set; }
        public decimal valor { get; set; }
    }
}

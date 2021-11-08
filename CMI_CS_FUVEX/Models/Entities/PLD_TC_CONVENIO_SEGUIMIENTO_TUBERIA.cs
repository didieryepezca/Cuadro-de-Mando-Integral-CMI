using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA
    {
        [Key]
        public int codigo { get; set; }
        public string producto { get; set; }
        public string bandeja { get; set; }
        public int total { get; set; }
        public DateTime fecha_proceso { get; set; }
    }
}

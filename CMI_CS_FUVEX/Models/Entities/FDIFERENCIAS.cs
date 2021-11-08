using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
namespace CMI_CS_FUVEX.Models.Entities
{
    public class FDIFERENCIAS
    {
        [Key]
        public int id { get; set; }
        public string producto { get; set; }
        public string bandeja { get; set; }
        public int resta { get; set; }
        public decimal porcentaje { get; set; }
        public int rechazados { get; set; }
        public int enproceso { get; set; }
        public DateTime fecha_proceso { get; set; }
    }
}

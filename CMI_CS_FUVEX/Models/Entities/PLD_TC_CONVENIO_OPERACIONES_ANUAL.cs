using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_OPERACIONES_ANUAL
    {
        [Key]
        public int codigo { get; set; }
        public string producto { get; set; }
        public string descripcion_estado { get; set; }
        public DateTime fecha_proceso { get; set; }
        public decimal enero { get; set; }
        public decimal febrero { get; set; }
        public decimal marzo { get; set; }
        public decimal abril { get; set; }
        public decimal mayo { get; set; }
        public decimal junio { get; set; }
        public decimal julio { get; set; }
        public decimal agosto { get; set; }
        public decimal setiembre { get; set; }
        public decimal octubre { get; set; }
        public decimal noviembre { get; set; }
        public decimal diciembre { get; set; }
        public decimal total { get; set; }
        public decimal promedio { get; set; }
    }
}

using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES
    {
        [Key]
        public int codigo { get; set; }
        public string tipo { get; set; }
        public string nro_expediente { get; set; }
        public string tarea { get; set; }
        public string nom_territorio { get; set; }
        public string nom_oficina { get; set; }
        public string ejecutivo { get; set; }        
        public DateTime fecha { get; set; }
        public string plazo { get; set; }
        public DateTime fecha_proceso { get; set; }
    }
}

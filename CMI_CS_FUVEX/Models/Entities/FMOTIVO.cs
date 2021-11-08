using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class FMOTIVO
    {
        [Key]
        public int id { get; set; }
        public int id_perfil { get; set; }
        public string perfil { get; set; }
        public string motivo { get; set; }
        public int qty { get; set; }
        public DateTime fecha_proceso { get; set; }
    }
}

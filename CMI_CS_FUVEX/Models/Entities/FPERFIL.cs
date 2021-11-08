using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class FPERFIL
    {
        [Key]
        public int id { get; set; }
        public int id_diferencia { get; set; }
        public string perfil { get; set; }
        public int qty { get; set; }
        public DateTime fecha_proceso { get; set; }
    }
}

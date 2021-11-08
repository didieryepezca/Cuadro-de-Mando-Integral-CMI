using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_DETALLE_TIEMPOS
    {

        [Key]
        public int codigo { get; set; }
        public string nro_expediente { get; set; }
        public decimal tiempo { get; set; }
        public string perfil { get; set; }
        public string nombre_producto { get; set; }
        public string nombre_tipo_oferta { get; set; }
        public DateTime fecha_hora_envio { get; set; }
        public string tipo { get; set; }        
        public DateTime fecha_proceso { get; set; }
    }
}

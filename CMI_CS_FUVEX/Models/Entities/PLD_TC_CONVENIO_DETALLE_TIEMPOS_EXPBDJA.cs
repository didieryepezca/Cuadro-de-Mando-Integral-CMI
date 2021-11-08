using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA
    {
        [Key]
        public int codigo { get; set; }
        public string nro_expediente { get; set; }
        public DateTime fecha_hora_llegada { get; set; }
        public DateTime fecha_hora_envio { get; set; }
        public decimal tiempo { get; set; }
        public string bandeja { get; set; }
        public string nombre_producto { get; set; }
        public string oferta { get; set; }
        public DateTime fecha_proceso { get; set; }

    }
}

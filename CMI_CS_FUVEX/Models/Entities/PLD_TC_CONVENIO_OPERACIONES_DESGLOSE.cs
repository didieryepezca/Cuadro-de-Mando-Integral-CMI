using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;


namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_OPERACIONES_DESGLOSE
    {

        [Key]
        public int codigo { get; set; }
        public string producto { get; set; }
        public string descripcion { get; set; }
        public DateTime fecha_proceso { get; set; }
        public decimal monto { get; set; }
        public decimal monto_porcentaje { get; set; }
        public decimal operaciones { get; set; }
        public decimal operaciones_porcentaje { get; set; }

    }
}

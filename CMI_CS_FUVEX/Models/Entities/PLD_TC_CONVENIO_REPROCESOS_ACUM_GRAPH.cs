using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;



namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH
    {

        [Key]
        public int codigo { get; set; }
        public string nombre_producto { get; set; }
        public string mes_anio { get; set; }
        public int valory { get; set; }        
        public DateTime fecha_proceso { get; set; }
    }
}

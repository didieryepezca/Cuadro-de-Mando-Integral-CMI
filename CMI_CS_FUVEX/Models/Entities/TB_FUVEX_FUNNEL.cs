using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class TB_FUVEX_FUNNEL
    {
        [Key]
        public int CODIGO { get; set; }
        public string PRODUCTO { get; set; }
        public string DESCRIPCION { get; set; }
        public int CANTIDAD { get; set; }
        public DateTime FECHA_PROCESO { get; set; }
    }

}

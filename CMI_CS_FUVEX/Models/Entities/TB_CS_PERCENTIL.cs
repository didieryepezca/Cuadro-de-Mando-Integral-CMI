using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class TB_CS_PERCENTIL
    {
        [Key]
        public int codigo { get; set; }
        public string producto { get; set; }
        public string descripcion { get; set; }
        public decimal valor_objetivo { get; set; }
        
    }
}

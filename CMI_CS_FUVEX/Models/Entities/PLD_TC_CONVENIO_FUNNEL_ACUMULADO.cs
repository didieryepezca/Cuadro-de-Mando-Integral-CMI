﻿using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CMI_CS_FUVEX.Models.Entities
{
    public class PLD_TC_CONVENIO_FUNNEL_ACUMULADO
    {
        [Key]
        public int codigo { get; set; }
        public int mes { get; set; }
        public int ano { get; set; }
        public string producto { get; set; }        
        public string tipo { get; set; }
        public int cantidad { get; set; }      
        public DateTime fecha_proceso { get; set; }
    }
}

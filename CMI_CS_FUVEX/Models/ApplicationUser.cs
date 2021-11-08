using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CMI_CS_FUVEX.Models
{
    public class ApplicationUser: IdentityUser
    {
        public String Nombres { get; set; }

        public String Apellidos { get; set; }

        [Display(Name = "Código")]
        public String Codigo { get; set; }
    }
}

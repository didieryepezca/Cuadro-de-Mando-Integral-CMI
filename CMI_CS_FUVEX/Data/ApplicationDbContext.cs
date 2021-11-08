using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

using CMI_CS_FUVEX.Models;
using CMI_CS_FUVEX.Models.Entities;

namespace CMI_CS_FUVEX.Data
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public ApplicationDbContext()
        {

            Database.SetCommandTimeout(1500000);

        }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);
            // Customize the ASP.NET Identity model and override the defaults if needed.
            // For example, you can rename the ASP.NET Identity table names and more.
            // Add your customizations after calling base.OnModelCreating(builder);
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionBuilder)
        {
            optionBuilder.UseSqlServer("Server=172.17.1.51;" +
                    "Database=CMI_CS_FUVEX;" +
                    "Trusted_Connection=True;" +
                    "MultipleActiveResultSets=True;" +
                    "Connection Timeout=60000");
        }
        public DbSet<PLD_TC_CONVENIO> PLD_TC_CONVENIO { get; set; }
        public DbSet<PLD_TC_CONVENIO_DETALLE> PLD_TC_CONVENIO_DETALLE { get; set; }
        public DbSet<PLD_TC_CONVENIO_OPERACIONES> PLD_TC_CONVENIO_OPERACIONES { get; set; }
        public DbSet<PLD_TC_CONVENIO_OPERACIONES_ANUAL> PLD_TC_CONVENIO_OPERACIONES_ANUAL { get; set; }
        public DbSet<PLD_TC_CONVENIO_OPERACIONES_GRAPH> PLD_TC_CONVENIO_OPERACIONES_GRAPH { get; set; }
        public DbSet<PLD_TC_CONVENIO_OPERACIONES_DESGLOSE> PLD_TC_CONVENIO_OPERACIONES_DESGLOSE { get; set; }
        public DbSet<PLD_TC_CONVENIO_DETALLE_TIEMPOS> PLD_TC_CONVENIO_DETALLE_TIEMPOS { get; set; }
        public DbSet<PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA> PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA { get; set; }        
        public DbSet<TB_CS_PERCENTIL_BANDEJA> TB_CS_PERCENTIL_BANDEJA { get; set; }
        public DbSet<TB_CS_PERCENTIL_PERFIL_BANDEJA> TB_CS_PERCENTIL_PERFIL_BANDEJA { get; set; }
        public DbSet<PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH> PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH { get; set; }
        public DbSet<PLD_TC_CONVENIO_REPROCESOS_GRAPH> PLD_TC_CONVENIO_REPROCESOS_GRAPH { get; set; }
        public DbSet<PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS> PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS { get; set; }
        public DbSet<PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH> PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH { get; set; }
        public DbSet<PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH> PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH { get; set; }
        public DbSet<TB_CS_CANT_REPROCESO_TB_DINAMICA> TB_CS_CANT_REPROCESO_TB_DINAMICA { get; set; }
        public DbSet<PLD_TC_CONVENIO_CALIDAD> PLD_TC_CONVENIO_CALIDAD { get; set; }
        public DbSet<PLD_TC_CONVENIO_CALIDAD_GRAPH> PLD_TC_CONVENIO_CALIDAD_GRAPH { get; set; }
        public DbSet<TB_FUVEX_RO> TB_FUVEX_RO { get; set; }
        public DbSet<PLD_TC_CONVENIO_RS_ACUMULADO> PLD_TC_CONVENIO_RS_ACUMULADO { get; set; }
        public DbSet<PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH> PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH { get; set; }
        public DbSet<PLD_TC_CONVENIO_FUNNEL_ACUMULADO> PLD_TC_CONVENIO_FUNNEL_ACUMULADO { get; set; }
        public DbSet<FDIFERENCIAS> FDIFERENCIAS { get; set; }        
        public DbSet<FPERFIL> FPERFIL { get; set; }
        public DbSet<FMOTIVO> FMOTIVO { get; set; }
        public DbSet<FPERFIL_RECHAZO> FPERFIL_RECHAZO { get; set; }
        public DbSet<PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA> PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA { get; set; }
        public DbSet<PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES> PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES { get; set; }
        public DbSet<TB_FUVEX_PERCENTIL> TB_FUVEX_PERCENTIL { get; set; }
        public DbSet<TB_FUVEX_FUNNEL> TB_FUVEX_FUNNEL { get; set; }
        public DbSet<TC_GIFOLE_OPERACIONES> TC_GIFOLE_OPERACIONES { get; set; }
        public DbSet<TC_GIFOLE_OPERACIONES_DESGLOSE> TC_GIFOLE_OPERACIONES_DESGLOSE { get; set; }
        public DbSet<TC_GIFOLE_OPERACIONES_ANUAL> TC_GIFOLE_OPERACIONES_ANUAL { get; set; }
        public DbSet<TB_GIFOLE_FUNNEL> TB_GIFOLE_FUNNEL { get; set; }

    }
}

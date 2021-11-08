using System;
using System.Collections.Generic;
using System.Linq;
//using System.Threading.Tasks;
using CMI_CS_FUVEX.Models.Entities;


namespace CMI_CS_FUVEX.Data.DataAccess
{
    public class ContSencDA
    {
        public IEnumerable<PLD_TC_CONVENIO> Cs_Listar(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO> query = db.PLD_TC_CONVENIO;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion == "TIEMPO-OFERTA-APROBADA-UTILES-LAB"
                    ||
                    item.producto == nombre
                    && item.descripcion == "TIEMPO-OFERTA-REGULAR-UTILES-LAB"
                    ||
                    item.producto == nombre
                    && item.descripcion == "% REPROCESOS-DIA"
                    ||
                    item.producto == nombre
                    && item.descripcion == "% FORMALIZACION"
                    ||
                    item.producto == nombre
                    && item.descripcion == "ANS - Efectividad"
                    ||
                    item.producto == nombre
                    && item.descripcion == "PORCENTAJE DE REPROCESOS GLOBAL"

                 );
                }

                list = query.OrderBy(x => x.descripcion.StartsWith("% FORMALIZACION"))
                    .ThenBy(x => x.descripcion.StartsWith("ANS - Efectividad"))
                    .ThenBy(x => x.descripcion.StartsWith("% REPROCESOS-DIA"))
                    .ThenBy(x => x.descripcion.StartsWith("TIEMPO-OFERTA-REGULAR-UTILES-LAB"))
                    .ThenBy(x => x.descripcion.StartsWith("TIEMPO-OFERTA-APROBADA-UTILES-LAB"))
                    .ThenBy(x => x.descripcion.StartsWith("PORCENTAJE DE REPROCESOS GLOBAL")).ToList();
            }
            return list;
        }

        public IEnumerable<PLD_TC_CONVENIO> Gifole_Listar(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO> query = db.PLD_TC_CONVENIO;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion == "EXITO EN LA FORMALIZACION DE OP. GIFOLE"
                    ||
                    item.producto == nombre
                    && item.descripcion == "CUMPLIMIENTO DE ANS - EFECTIVIDAD - GIFOLE"
                    ||                   
                    item.producto == nombre
                    && item.descripcion == "% RECHAZO ADICIONALES"
                    ||
                    item.producto == nombre
                    && item.descripcion == "% RECHAZO TITULARES"
                    ||
                    item.producto == nombre
                    && item.descripcion == "TIEMPO DE FORMALIZACION TC GIFOLE"

                 );
                }

                list = query.OrderBy(x => x.descripcion.StartsWith("EXITO EN LA FORMALIZACION DE OP. GIFOLE"))
                    .ThenBy(x => x.descripcion.StartsWith("CUMPLIMIENTO DE ANS - EFECTIVIDAD - GIFOLE"))
                    .ThenBy(x => x.descripcion.StartsWith("% RECHAZO ADICIONALES"))
                    .ThenBy(x => x.descripcion.StartsWith("% RECHAZO TITULARES"))
                    .ThenBy(x => x.descripcion.StartsWith("TIEMPO DE FORMALIZACION TC GIFOLE")).ToList();
            }
            return list;
        }



        public IEnumerable<PLD_TC_CONVENIO> Fuvex_Listar(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO> query = db.PLD_TC_CONVENIO;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre && item.descripcion == "PORCENTAJE EN LA FORMALIZACION FUNNEL" ||
                    item.producto == nombre && item.descripcion == "PORCENTAJE REPROCESOS FUVEX" ||
                    item.producto == nombre  && item.descripcion == "PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA" ||
                    item.producto == nombre  && item.descripcion == "TIEMPO DE FORMALIZACION OF. REGULAR" ||
                    item.producto == nombre  && item.descripcion == "TIEMPO DE FORMALIZACION OF. APROBADA"

                 );
                }

                list = query.OrderBy(x => x.descripcion.StartsWith("PORCENTAJE EN LA FORMALIZACION FUNNEL"))
                    .ThenBy(x => x.descripcion.StartsWith("PORCENTAJE REPROCESOS FUVEX"))
                    .ThenBy(x => x.descripcion.StartsWith("PAPERLESS TIEMPO DE FORMALIZACION OF. APROBADA"))
                    .ThenBy(x => x.descripcion.StartsWith("TIEMPO DE FORMALIZACION OF. REGULAR"))
                    .ThenBy(x => x.descripcion.StartsWith("TIEMPO DE FORMALIZACION OF. APROBADA")).ToList();
            }
            return list;
        }


        public int InsertRegistroResumen(PLD_TC_CONVENIO res)
        {
            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    db.Add(res);
                    result = db.SaveChanges();
                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    e.InnerException.ToString();
                }
            }
            return result;
        }
        public int DeleteRegistroResumen(string prod, string desc, DateTime fecha_proc)
        {

            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    var res = db.PLD_TC_CONVENIO.Where(item => item.producto
                    == prod && item.descripcion == desc && item.fecha_proceso.Date == fecha_proc.Date).FirstOrDefault();

                    db.PLD_TC_CONVENIO.Remove(res);

                    result = db.SaveChanges();

                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    
                }
            }

            return result;

        }


        public IEnumerable<PLD_TC_CONVENIO_OPERACIONES> CS_ListarOperaciones(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_OPERACIONES>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_OPERACIONES> query = db.PLD_TC_CONVENIO_OPERACIONES;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion_estado == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion_estado == "EXP.FORMALIZADOS"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "MONTO-FORMALIZADO"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "TICKET PROMEDIO"
                 );
                }

                list = query.ToList();
            }
            return list;
        }

        public IEnumerable<TC_GIFOLE_OPERACIONES> ListarGifole_Operaciones(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<TC_GIFOLE_OPERACIONES>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TC_GIFOLE_OPERACIONES> query = db.TC_GIFOLE_OPERACIONES;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion_estado == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion_estado == "EXPEDIENTES FORMALIZADOS GIFOLE"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "MONTO FORMALIZADO GIFOLE"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "TICKET PROMEDIO GIFOLE"
                 );
                }

                list = query.ToList();
            }
            return list;
        }

        public IEnumerable<PLD_TC_CONVENIO_OPERACIONES_ANUAL> CS_ListarOperacionesAnual(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_OPERACIONES_ANUAL>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_OPERACIONES_ANUAL> query = db.PLD_TC_CONVENIO_OPERACIONES_ANUAL;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion_estado == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion_estado == "EXP.FORMALIZADOS"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "MONTO-FORMALIZADO"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "TICKET PROMEDIO"
                 );
                }

                list = query.ToList();
            }
            return list;
        }

        public IEnumerable<TC_GIFOLE_OPERACIONES_ANUAL> Gifole_ListarOperacionesAnual(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<TC_GIFOLE_OPERACIONES_ANUAL>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TC_GIFOLE_OPERACIONES_ANUAL> query = db.TC_GIFOLE_OPERACIONES_ANUAL;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion_estado == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion_estado == "EXPEDIENTES FORMALIZADOS GIFOLE ANUAL"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "MONTO FORMALIZADO GIFOLE ANUAL"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "TICKET PROMEDIO GIFOLE ANUAL"
                 );
                }

                list = query.ToList();
            }
            return list;
        }


        public IEnumerable<PLD_TC_CONVENIO_OPERACIONES_GRAPH> CS_ListarOperaciones_Graph(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_OPERACIONES_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_OPERACIONES_GRAPH> query = db.PLD_TC_CONVENIO_OPERACIONES_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion_estado == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion_estado == "EXP.FORMALIZADOS"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "MONTO-FORMALIZADO"
                    ||
                    item.producto == nombre
                    && item.descripcion_estado == "TICKET-PROMEDIO"
                 );
                }

                list = query.OrderBy(x => x.descripcion_estado).ToList();
            }
            return list;
        }



        public IEnumerable<PLD_TC_CONVENIO_OPERACIONES_DESGLOSE> CS_ListarOperaciones_Desglose(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_OPERACIONES_DESGLOSE>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_OPERACIONES_DESGLOSE> query = db.PLD_TC_CONVENIO_OPERACIONES_DESGLOSE;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion == "OFERTA-APROBADA"
                    ||
                    item.producto == nombre
                    && item.descripcion == "OFERTA-REGULAR"
                    ||
                    item.producto == nombre
                    && item.descripcion == "TOTAL"
                 );
                }

                list = query.ToList();
            }
            return list;
        }


        public IEnumerable<TC_GIFOLE_OPERACIONES_DESGLOSE> Gifole_ListarOperaciones_Desglose(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<TC_GIFOLE_OPERACIONES_DESGLOSE>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TC_GIFOLE_OPERACIONES_DESGLOSE> query = db.TC_GIFOLE_OPERACIONES_DESGLOSE;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.descripcion == tipo);
                }

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre
                    && item.descripcion == "BANCA POR INTERNET"
                    ||
                    item.producto == nombre
                    && item.descripcion == "BMMOVIL"
                    ||
                    item.producto == nombre
                    && item.descripcion == "BMOVILWB"
                    ||
                    item.producto == nombre
                    && item.descripcion == "ZONA_PUB"
                    ||
                    item.producto == nombre
                    && item.descripcion == "TOTAL"
                 );
                }

                list = query.ToList();
            }
            return list;
        }


        //---- DETALLE REPROCESADOS



        public IEnumerable<PLD_TC_CONVENIO_DETALLE> ListaDetalle_Reprocesados(DateTime fecha_proceso, DateTime fecha, string nombre = "",
        int MES = 0, int YEAR = 0, int DAY = 0)
        {
            var ana = new List<PLD_TC_CONVENIO_DETALLE>();

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    IQueryable<PLD_TC_CONVENIO_DETALLE> query = db.PLD_TC_CONVENIO_DETALLE;


                    query = query.Where(item => item.fecha_proceso == fecha_proceso);

                    query = query.Where(item => item.fecha == fecha);

                    if (!String.IsNullOrWhiteSpace(nombre))
                    {
                        query = query.Where(item => item.producto.ToLower() == nombre.ToLower());
                    }                           


                    ana = query.ToList();
                }
            }
            catch (Exception x)
            {

                var b = x.Message;

                return ana;
            }
            return ana;



        }


       public IEnumerable<PLD_TC_CONVENIO_DETALLE_TIEMPOS> ListaDetalle_Tiempos(DateTime fecha, string nombre = "",
       string oferta = "", string tipo = "",int MES = 0, int YEAR = 0, int DAY = 0)
        {
            var ana = new List<PLD_TC_CONVENIO_DETALLE_TIEMPOS>();

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    IQueryable<PLD_TC_CONVENIO_DETALLE_TIEMPOS> query = db.PLD_TC_CONVENIO_DETALLE_TIEMPOS;

                    //query = query.Where(item => item.fecha_proceso == fecha_proceso);

                    query = query.Where(item => item.fecha_proceso.Date == fecha.Date);

                    if (!String.IsNullOrWhiteSpace(nombre))
                    {
                        query = query.Where(item => item.nombre_producto == nombre);
                    }
                    if (!String.IsNullOrWhiteSpace(oferta))
                    {
                        query = query.Where(item => item.nombre_tipo_oferta == oferta);
                    }
                    if (!String.IsNullOrWhiteSpace(tipo))
                    {
                        query = query.Where(item => item.tipo == tipo);
                    }

                    ana = query.OrderBy(item => item.tiempo).ToList();
                }
            }
            catch (Exception x)
            {

                var b = x.Message;

                return ana;
            }

            return ana;
        }


        public IEnumerable<PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA> ListarDetalleTiempoExpedienteXBbja(DateTime fecha, string expediente)
        {
            var ana = new List<PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA>();
            try
            {
                using (var db = new ApplicationDbContext())
                {
                    IQueryable<PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA> query = db.PLD_TC_CONVENIO_DETALLE_TIEMPOS_EXPBDJA;

                    //query = query.Where(item => item.fecha_proceso == fecha_proceso);

                    query = query.Where(item => item.fecha_proceso.Date == fecha.Date);

                    if (!String.IsNullOrWhiteSpace(expediente))
                    {
                        query = query.Where(item => item.nro_expediente == expediente);
                    }                   
                    ana = query.OrderBy(item => item.tiempo).ToList();
                }
            }
            catch (Exception x)
            {

                var b = x.Message;

                return ana;
            }

            return ana;
        }




        public IEnumerable<TB_CS_PERCENTIL_BANDEJA> ListarTiemposBandeja(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<TB_CS_PERCENTIL_BANDEJA>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TB_CS_PERCENTIL_BANDEJA> query = db.TB_CS_PERCENTIL_BANDEJA;

                query = query.Where(item => item.FECHA.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.NOMBRE_PRODUCTO == nombre);
                }

                list = query.OrderBy(x => x.PERFIL.StartsWith("EJECUTIVO"))
                    .ThenBy(x => x.PERFIL.StartsWith("MESA DE CONTROL"))
                    .ThenBy(x => x.PERFIL.StartsWith("ANALISIS Y ALTA"))
                    .ThenBy(x => x.PERFIL.StartsWith("SUB GERENTE OFICINA"))
                    .ThenBy(x => x.PERFIL.StartsWith("ANALISTA DE RIESGOS"))
                    .ThenBy(x => x.PERFIL.StartsWith("RIESGOS SUPERIOR"))
                    .ThenBy(x => x.PERFIL.StartsWith("CONTROLLER"))
                    .ThenBy(x => x.PERFIL.StartsWith("FORMALIZADOR")).ToList();
            }
            return list;
        }


        public IEnumerable<TB_CS_PERCENTIL_PERFIL_BANDEJA> ListarTiemposPerfilBandeja(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<TB_CS_PERCENTIL_PERFIL_BANDEJA>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TB_CS_PERCENTIL_PERFIL_BANDEJA> query = db.TB_CS_PERCENTIL_PERFIL_BANDEJA;

                query = query.Where(item => item.FECHA.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.NOMBRE_PRODUCTO == nombre);
                }               

                list = query.OrderBy(x => x.PERFIL.StartsWith("EVERIS-PERFIL"))
                     .ThenBy(x => x.PERFIL.StartsWith("RIESGOS-PERFIL"))
                     .ThenBy(x => x.PERFIL.StartsWith("OFICINA-PERFIL")).ToList();
            }
            return list;
        }



        public IEnumerable<PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH> ListarHistogramas(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH> query = db.PLD_TC_CONVENIO_HISTORAL_LAB_GRAPH;

                query = query.Where(item => item.FECHA.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.NOMBRE_PRODUCTO == nombre);
                }

                //if (!string.IsNullOrWhiteSpace(tipo))
                //{
                //    query = query.Where(item => item.NOMBRE_TIPO_OFERTA == "MES"
                //    && item.TIPO == "DÍAS ÚTILES");
                //}

                list = query.ToList();
            }
            return list;
        }


        public IEnumerable<PLD_TC_CONVENIO_REPROCESOS_GRAPH> ListarPorcentajesReprocesos(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_REPROCESOS_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_REPROCESOS_GRAPH> query = db.PLD_TC_CONVENIO_REPROCESOS_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.nombre_producto == nombre);
                }

                //if (!string.IsNullOrWhiteSpace(tipo))
                //{
                //    query = query.Where(item => item.NOMBRE_TIPO_OFERTA == "MES"
                //    && item.TIPO == "DÍAS ÚTILES");
                //}

                list = query.ToList();
            }
            return list;
        }



        public IEnumerable<PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS> ListarHistReprocesos(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS> query = db.PLD_TC_CONVENIO_HISTOGRAMAS_REPROCESOS;

                query = query.Where(item => item.FECHA.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.NOMBRE_PRODUCTO == nombre);
                }

                //if (!string.IsNullOrWhiteSpace(tipo))
                //{
                //    query = query.Where(item => item.NOMBRE_TIPO_OFERTA == "MES"
                //    && item.TIPO == "DÍAS ÚTILES");
                //}

                list = query.ToList();
            }
            return list;
        }



        public IEnumerable<PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH> ListarCantidadReprocesos(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH> query = db.PLD_TC_CONVENIO_REPROCESOS_CANT_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.nombre_producto == nombre);
                }     
            

                list = query.ToList();
            }
            return list;
        }


        public IEnumerable<PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH> ListarReprocesosAcumulado(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH> query = db.PLD_TC_CONVENIO_REPROCESOS_ACUM_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.nombre_producto == nombre);
                }

                list = query.OrderBy(x => x.mes_anio).ToList();
            }
            return list;
        }

        public IEnumerable<TB_CS_CANT_REPROCESO_TB_DINAMICA> ListarTablaDinamicaTotales(DateTime fecha, string tipo, string nombre,string resul, string sector)
        {
            var list = new List<TB_CS_CANT_REPROCESO_TB_DINAMICA>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TB_CS_CANT_REPROCESO_TB_DINAMICA> query = db.TB_CS_CANT_REPROCESO_TB_DINAMICA;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto== nombre);
                }
                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.tipo == tipo);
                }
                if (!string.IsNullOrWhiteSpace(resul))
                {
                    query = query.Where(item => item.resultado == resul);
                }
                if (!string.IsNullOrWhiteSpace(sector))
                {
                    query = query.Where(item => item.territorio == sector);
                }
                list = query.ToList();
            }
            return list;
        }




        public IEnumerable<PLD_TC_CONVENIO_CALIDAD> ListarPestañaCalidad(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_CALIDAD>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_CALIDAD> query = db.PLD_TC_CONVENIO_CALIDAD;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }

                list = query.OrderBy(x => x.nro).ToList();
            }
            return list;
        }

        public int InsertCalidad (PLD_TC_CONVENIO_CALIDAD calidad)
        {
            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    db.Add(calidad);
                    result = db.SaveChanges(); 
                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    e.InnerException.ToString();
                }                
            }
            return result;
        }

        public int InsertCalidadPuntosGrafico(PLD_TC_CONVENIO_CALIDAD_GRAPH calidad_grafico)
        {
            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    db.Add(calidad_grafico);
                    result = db.SaveChanges(); 
                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    e.InnerException.ToString();
                }
            }
            return result;
        }

        public int UpdateRegistroCalidad(PLD_TC_CONVENIO_CALIDAD calidad_web)
        {
            var result = 0;
            using (var db = new ApplicationDbContext())
            {
                var calidad_bd = db.PLD_TC_CONVENIO_CALIDAD.Where(item => item.codigo == calidad_web.codigo).FirstOrDefault();

                calidad_bd.dia1 = calidad_web.dia1;
                calidad_bd.dia2 = calidad_web.dia2;
                calidad_bd.dia3 = calidad_web.dia3;
                calidad_bd.dia4 = calidad_web.dia4;
                calidad_bd.dia5 = calidad_web.dia5;
                calidad_bd.dia6 = calidad_web.dia6;
                calidad_bd.dia7 = calidad_web.dia7;
                calidad_bd.dia8 = calidad_web.dia8;
                calidad_bd.dia9 = calidad_web.dia9;
                calidad_bd.dia10 = calidad_web.dia10;
                calidad_bd.dia11 = calidad_web.dia11;
                calidad_bd.dia12 = calidad_web.dia12;
                calidad_bd.dia13 = calidad_web.dia13;
                calidad_bd.dia14 = calidad_web.dia14;
                calidad_bd.dia15 = calidad_web.dia15;
                calidad_bd.dia16 = calidad_web.dia16;
                calidad_bd.dia17 = calidad_web.dia17;
                calidad_bd.dia18 = calidad_web.dia18;
                calidad_bd.dia19 = calidad_web.dia19;
                calidad_bd.dia20 = calidad_web.dia20;
                calidad_bd.dia21 = calidad_web.dia21;
                calidad_bd.dia22 = calidad_web.dia22;
                calidad_bd.dia23 = calidad_web.dia23;
                calidad_bd.dia24 = calidad_web.dia24;
                calidad_bd.dia25 = calidad_web.dia25;
                calidad_bd.dia26 = calidad_web.dia26;
                calidad_bd.dia27 = calidad_web.dia27;
                calidad_bd.dia28 = calidad_web.dia28;
                calidad_bd.dia29 = calidad_web.dia29;
                calidad_bd.dia30 = calidad_web.dia30;
                calidad_bd.dia31 = calidad_web.dia31;
                calidad_bd.mes1 = calidad_web.mes1;
                calidad_bd.mes2 = calidad_web.mes2;
                calidad_bd.mes3 = calidad_web.mes3;

                result = db.SaveChanges();
            }

            return result;
        }

        public IEnumerable<PLD_TC_CONVENIO_CALIDAD_GRAPH> ListarCalidadGraficos(DateTime fecha, string nombre, string estado)
        {
            var list = new List<PLD_TC_CONVENIO_CALIDAD_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_CALIDAD_GRAPH> query = db.PLD_TC_CONVENIO_CALIDAD_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }
                if (!string.IsNullOrWhiteSpace(estado))
                {
                    query = query.Where(item => item.descripcion_estado == estado);
                }

                list = query.OrderBy(x => x.codigo)
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia2"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia3"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia4"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia5"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia6"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia7"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia8"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia9"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia10"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia11"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia12"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia13"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia14"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia15"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia16"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia17"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia18"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia19"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia20"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia21"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia22"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia23"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia24"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia25"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia26"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia27"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia28"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia29"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia30"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("dia31"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("mes1"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("mes2"))
                 //.ThenBy(x => x.dia_nombre.StartsWith("mes3"))
                 .ToList();

            }
            return list;
        }
        public IEnumerable<PLD_TC_CONVENIO_CALIDAD_GRAPH> GetFiabilidades(DateTime fecha, string nombre, string descripcion)
        {
            var list = new List<PLD_TC_CONVENIO_CALIDAD_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_CALIDAD_GRAPH> query = db.PLD_TC_CONVENIO_CALIDAD_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }
                if (!string.IsNullOrWhiteSpace(descripcion))
                {
                    query = query.Where(item => item.descripcion_estado == descripcion);
                }

                list = query.ToList();
            }
            return list;
        }

        public IEnumerable<PLD_TC_CONVENIO_CALIDAD_GRAPH> ListarCalidadFiabilidadGraficos(DateTime fecha, string nombre, string estado)
        {
            var list = new List<PLD_TC_CONVENIO_CALIDAD_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_CALIDAD_GRAPH> query = db.PLD_TC_CONVENIO_CALIDAD_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }
                if (!string.IsNullOrWhiteSpace(estado))
                {
                    query = query.Where(item => item.descripcion_estado == "MESADECONTROL-Fiabilidad" ||
                                                item.descripcion_estado == "ANALISISYALTA-Fiabilidad" ||
                                                item.descripcion_estado == "CONTROLLER-Fiabilidad" || 
                                                item.descripcion_estado == "FORMALIZADOR-Fiabilidad");
                }

                list = query.OrderBy(x => x.codigo).ToList();

            }
            return list;
        }

        public PLD_TC_CONVENIO_CALIDAD_GRAPH GetDatoFiabilidad(int code)
        {
            var result = new PLD_TC_CONVENIO_CALIDAD_GRAPH();
            {
                using (var db = new ApplicationDbContext())
                {
                    result = db.PLD_TC_CONVENIO_CALIDAD_GRAPH.Where(item => item.codigo == code).FirstOrDefault();
                }
            }
            return result;
        }

        public PLD_TC_CONVENIO GetIndicadoresResumen(int code)
        {
            var result = new PLD_TC_CONVENIO();
            {
                using (var db = new ApplicationDbContext())
                {
                    result = db.PLD_TC_CONVENIO.Where(item => item.codigo == code).FirstOrDefault();
                }
            }
            return result;
        }

        public int UpdateIndicadoresResumen(PLD_TC_CONVENIO res)
        {
            var result = 0;
            using (var db = new ApplicationDbContext())
            {
                var resbd = db.PLD_TC_CONVENIO.Where(item => item.codigo == res.codigo).FirstOrDefault();

                resbd.dia1 = res.dia1;
                resbd.dia2 = res.dia2;
                resbd.dia3 = res.dia3;
                resbd.dia4 = res.dia4;
                resbd.dia5 = res.dia5;
                resbd.dia6 = res.dia6;
                resbd.dia7 = res.dia7;
                resbd.dia8 = res.dia8;
                resbd.dia9 = res.dia9;
                resbd.dia10 = res.dia10;
                resbd.dia11 = res.dia11;
                resbd.dia12 = res.dia12;
                resbd.dia13 = res.dia13;
                resbd.dia14 = res.dia14;
                resbd.dia15 = res.dia15;
                resbd.dia16 = res.dia16;
                resbd.dia17 = res.dia17;
                resbd.dia18 = res.dia18;
                resbd.dia19 = res.dia19;
                resbd.dia20 = res.dia20;
                resbd.dia21 = res.dia21;
                resbd.dia22 = res.dia22;
                resbd.dia23 = res.dia23;
                resbd.dia24 = res.dia24;
                resbd.dia25 = res.dia25;
                resbd.dia26 = res.dia26;
                resbd.dia27 = res.dia27;
                resbd.dia28 = res.dia28;
                resbd.dia29 = res.dia29;
                resbd.dia30 = res.dia30;
                resbd.dia31 = res.dia31;
                resbd.mes1 = res.mes1;
                resbd.mes2 = res.mes2;
                resbd.mes3 = res.mes3;

                result = db.SaveChanges();
            }
            return result;
        }


        public int UpdateDatoFiabilidad(PLD_TC_CONVENIO_CALIDAD_GRAPH fia)
        {
            var result = 0;
            using (var db = new ApplicationDbContext())
            {
                var fiabd = db.PLD_TC_CONVENIO_CALIDAD_GRAPH.Where(item => item.codigo == fia.codigo).FirstOrDefault();

                fiabd.valor = fia.valor;

                result = db.SaveChanges();
            }

            return result;
        }

        public IEnumerable<TB_FUVEX_RO> ListarFuvexRO(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<TB_FUVEX_RO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TB_FUVEX_RO> query = db.TB_FUVEX_RO;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }

                list = query.OrderBy(x => x.nro).ToList();
            }
            return list;
        }


        public IEnumerable<PLD_TC_CONVENIO_RS_ACUMULADO> ListarRSacumulado(DateTime fecha, string tipo, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_RS_ACUMULADO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_RS_ACUMULADO> query = db.PLD_TC_CONVENIO_RS_ACUMULADO;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }

                list = query.OrderBy(x => x.nro).ToList();
            }
            return list;
        }

        public int InsertAcumulados(PLD_TC_CONVENIO_RS_ACUMULADO acum)
        {
            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    db.Add(acum);
                    result = db.SaveChanges();
                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    e.InnerException.ToString();
                }
            }
            return result;
        }

        public int UpdateRegistroAcumulado(PLD_TC_CONVENIO_RS_ACUMULADO acum_web)
        {
            var result = 0;
            using (var db = new ApplicationDbContext())
            {
                var acumulado_bd = db.PLD_TC_CONVENIO_RS_ACUMULADO.Where(item => item.codigo == acum_web.codigo).FirstOrDefault();

                acumulado_bd.dia1 = acum_web.dia1;
                acumulado_bd.dia2 = acum_web.dia2;
                acumulado_bd.dia3 = acum_web.dia3;
                acumulado_bd.dia4 = acum_web.dia4;
                acumulado_bd.dia5 = acum_web.dia5;
                acumulado_bd.dia6 = acum_web.dia6;
                acumulado_bd.dia7 = acum_web.dia7;
                acumulado_bd.dia8 = acum_web.dia8;
                acumulado_bd.dia9 = acum_web.dia9;
                acumulado_bd.dia10 = acum_web.dia10;
                acumulado_bd.dia11 = acum_web.dia11;
                acumulado_bd.dia12 = acum_web.dia12;
                acumulado_bd.dia13 = acum_web.dia13;
                acumulado_bd.dia14 = acum_web.dia14;
                acumulado_bd.dia15 = acum_web.dia15;
                acumulado_bd.dia16 = acum_web.dia16;
                acumulado_bd.dia17 = acum_web.dia17;
                acumulado_bd.dia18 = acum_web.dia18;
                acumulado_bd.dia19 = acum_web.dia19;
                acumulado_bd.dia20 = acum_web.dia20;
                acumulado_bd.dia21 = acum_web.dia21;
                acumulado_bd.dia22 = acum_web.dia22;
                acumulado_bd.dia23 = acum_web.dia23;
                acumulado_bd.dia24 = acum_web.dia24;
                acumulado_bd.dia25 = acum_web.dia25;
                acumulado_bd.dia26 = acum_web.dia26;
                acumulado_bd.dia27 = acum_web.dia27;
                acumulado_bd.dia28 = acum_web.dia28;
                acumulado_bd.dia29 = acum_web.dia29;
                acumulado_bd.dia30 = acum_web.dia30;
                acumulado_bd.dia31 = acum_web.dia31;
                acumulado_bd.mes1 = acum_web.mes1;
                acumulado_bd.mes2 = acum_web.mes2;
                acumulado_bd.mes3 = acum_web.mes3;

                result = db.SaveChanges();
            }

            return result;
        }

        public IEnumerable<PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH> TraerGraficosProductividad(DateTime fecha, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH> query = db.PLD_TC_CONVENIO_PRODUCTIVIDAD_GRAPH;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }
                
                list = query.OrderBy(x => x.fecha).ToList();
            }
            return list;
        }       


        public IEnumerable<PLD_TC_CONVENIO_FUNNEL_ACUMULADO> TraerFunnelAcumuladoGrafico(DateTime fecha, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_FUNNEL_ACUMULADO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_FUNNEL_ACUMULADO> query = db.PLD_TC_CONVENIO_FUNNEL_ACUMULADO;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }
                //list = query.OrderBy(x => x.tipo.StartsWith("INGRESADOS"))
                //    .ThenBy(x => x.tipo.StartsWith("MESA DE CONTROL"))
                //    .ThenBy(x => x.tipo.StartsWith("ANALISIS Y ALTA"))          
                //    .ThenBy(x => x.tipo.StartsWith("CONTROLLER"))
                //    .ThenBy(x => x.tipo.StartsWith("DESEMBOLSO"))
                //    .ThenBy(x => x.tipo.StartsWith("RECHAZADOS"))
                //    .ThenBy(x => x.tipo.StartsWith("REPROCESADOS")).ToList();

                list = query.OrderBy(x => x.tipo.StartsWith("REPROCESADOS"))
                    .ThenBy(x => x.tipo.StartsWith("RECHAZADOS"))
                    .ThenBy(x => x.tipo.StartsWith("DESEMBOLSO"))
                    .ThenBy(x => x.tipo.StartsWith("CONTROLLER"))
                    .ThenBy(x => x.tipo.StartsWith("ANALISIS Y ALTA"))
                    .ThenBy(x => x.tipo.StartsWith("MESA DE CONTROL"))
                    .ThenBy(x => x.tipo.StartsWith("INGRESADOS")).ToList();
            }
            return list;
        }

        public IEnumerable<FDIFERENCIAS> GetDiferencia(string producto, string bandeja, DateTime fecha)
        {
            var result = new List<FDIFERENCIAS>();
            {
                using (var db = new ApplicationDbContext())
                {
                    IQueryable<FDIFERENCIAS> query = db.FDIFERENCIAS;

                    query = query.Where(item => item.fecha_proceso.Date == fecha);

                    if (!string.IsNullOrWhiteSpace(producto))
                    {
                        query = query.Where(item => item.producto == producto);
                    }
                    if (!string.IsNullOrWhiteSpace(bandeja))
                    {
                        query = query.Where(item => item.bandeja == bandeja);
                    }
                    result = query.ToList();
                }               
            }
            return result;
        }
               
        public IEnumerable<FPERFIL_RECHAZO> GetPerfilesRechazo(int diferencia_id)
        {
            var list = new List<FPERFIL_RECHAZO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<FPERFIL_RECHAZO> query = db.FPERFIL_RECHAZO;

                query = query.Where(item => item.id_diferencia == diferencia_id);

                list = query.ToList();
            }
            return list;
        }



        public IEnumerable<FMOTIVO> GetMotivos(int idperfil)
        {
            var list = new List<FMOTIVO>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<FMOTIVO> query = db.FMOTIVO;

                query = query.Where(item => item.id_perfil == idperfil);

                list = query.OrderBy(x => x.perfil.StartsWith("Clientedesiste"))
                    .ThenBy(x => x.perfil.StartsWith("Oficina"))
                    .ThenBy(x => x.perfil.StartsWith("Otros"))
                    .ThenBy(x => x.perfil.StartsWith("Riesgos"))
                    .ThenBy(x => x.perfil.StartsWith("Verficiacion")).ToList();
            }
            return list;
        }


        public int InsertDiferencia(FDIFERENCIAS dif)
        {
            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    db.Add(dif);
                    result = db.SaveChanges();
                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    e.InnerException.ToString();
                }
            }
            return result;
        }
       
        public int InsertPerfil(FPERFIL_RECHAZO perf)
        {
            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    db.Add(perf);
                    result = db.SaveChanges();
                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    e.InnerException.ToString();
                }
            }
            return result;
        }

        public int InsertMotivo(FMOTIVO motivo)
        {
            var result = 0;

            try
            {
                using (var db = new ApplicationDbContext())
                {
                    db.Add(motivo);
                    result = db.SaveChanges();
                }
            }
            catch (Exception e)
            {
                if (result == 0)
                {
                    e.Message.ToString();
                    e.InnerException.ToString();
                }
            }
            return result;
        }


        public int UpdateDiferencia(FDIFERENCIAS dif)
        {
            var result = 0;
            using (var db = new ApplicationDbContext())
            {
                var diferenciabd = db.FDIFERENCIAS.Where(item => item.id == dif.id).FirstOrDefault();

                diferenciabd.resta = dif.resta;
                diferenciabd.porcentaje = dif.porcentaje;
                diferenciabd.rechazados = dif.rechazados;
                diferenciabd.enproceso = dif.enproceso;               

                result = db.SaveChanges();
            }

            return result;
        }

        public int UpdatePerfil(FPERFIL_RECHAZO perf)
        {
            var result = 0;
            using (var db = new ApplicationDbContext())
            {
                var perfilbd = db.FPERFIL_RECHAZO.Where(item => item.id == perf.id).FirstOrDefault();

                perfilbd.qty = perf.qty;

                result = db.SaveChanges();
            }

            return result;
        }


        public int UpdateMotivo(FMOTIVO mot)
        {
            var result = 0;
            using (var db = new ApplicationDbContext())
            {
                var motivobd = db.FMOTIVO.Where(item => item.id == mot.id).FirstOrDefault();

                motivobd.qty = mot.qty;

                result = db.SaveChanges();
            }

            return result;
        }


        public IEnumerable<PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA> ListarTuberia(DateTime fecha,  string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA> query = db.PLD_TC_CONVENIO_SEGUIMIENTO_TUBERIA;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.producto == nombre);
                }

                list = query.OrderBy(x => x.bandeja.StartsWith("EJECUTIVO"))
                    .ThenBy(x => x.bandeja.StartsWith("MESA DE CONTROL"))
                    .ThenBy(x => x.bandeja.StartsWith("ANALISIS Y ALTA"))
                    .ThenBy(x => x.bandeja.StartsWith("SUB GERENTE OFICINA"))
                    .ThenBy(x => x.bandeja.StartsWith("ANALISTA DE RIESGOS"))
                    .ThenBy(x => x.bandeja.StartsWith("RIESGOS SUPERIOR"))
                    .ThenBy(x => x.bandeja.StartsWith("CONTROLLER"))
                    .ThenBy(x => x.bandeja.StartsWith("FORMALIZADOR")).ToList();
            }
            return list;
        }


        public IEnumerable<PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES> GetSeguimientoOperaciones(DateTime fecha, string nombre)
        {
            var list = new List<PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES> query = db.PLD_TC_CONVENIO_SEGUIMIENTO_OPERACIONES;

                query = query.Where(item => item.fecha_proceso.Date == fecha);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.tipo == nombre);
                }

                list = query.OrderBy(x => x.fecha).ToList();
            }
            return list;
        }

        public IEnumerable<TB_FUVEX_PERCENTIL> TraerFuvexPercentiles(int mes, int anio, string producto, string paperless,
            string tipo)
        {
            var list = new List<TB_FUVEX_PERCENTIL>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TB_FUVEX_PERCENTIL> query = db.TB_FUVEX_PERCENTIL;

                query = query.Where(item => item.FECHA.Date.Month == mes && item.FECHA.Date.Year == anio);

                if (!string.IsNullOrWhiteSpace(producto))
                {
                    query = query.Where(item => item.NOMBRE_PRODUCTO == producto);
                }
                if (!string.IsNullOrWhiteSpace(paperless))
                {
                    query = query.Where(item => item.PAPERLESS == paperless);
                }              
                if (!string.IsNullOrWhiteSpace(tipo))
                {
                    query = query.Where(item => item.TIPO == tipo);
                }
                //if (!string.IsNullOrWhiteSpace(frecuencia))
                //{
                //    query = query.Where(item => item.FRECUENCIA == frecuencia);
                //}
                //if (!string.IsNullOrWhiteSpace(oferta))
                //{
                //    query = query.Where(item => item.NOMBRE_TIPO_OFERTA == oferta);
                //}

                list = query.OrderBy(x => x.FECHA).ToList();
            }
            return list;
        }

        public IEnumerable<TB_FUVEX_FUNNEL> TraerFuvexFunnel(DateTime fecha, string nombre)
        {
            var list = new List<TB_FUVEX_FUNNEL>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TB_FUVEX_FUNNEL> query = db.TB_FUVEX_FUNNEL;

                query = query.Where(item => item.FECHA_PROCESO.Date == fecha.Date);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.PRODUCTO == nombre);
                }

                list = query.ToList();
            }
            return list;
        }

        public IEnumerable<TB_GIFOLE_FUNNEL> TraerGifoleFunnel(DateTime fecha, string nombre)
        {
            var list = new List<TB_GIFOLE_FUNNEL>();

            using (var db = new ApplicationDbContext())
            {
                IQueryable<TB_GIFOLE_FUNNEL> query = db.TB_GIFOLE_FUNNEL;

                query = query.Where(item => item.FECHA_PROCESO.Date == fecha.Date);

                if (!string.IsNullOrWhiteSpace(nombre))
                {
                    query = query.Where(item => item.PRODUCTO == nombre);
                }

                list = query.ToList();
            }
            return list;
        }

    }
}

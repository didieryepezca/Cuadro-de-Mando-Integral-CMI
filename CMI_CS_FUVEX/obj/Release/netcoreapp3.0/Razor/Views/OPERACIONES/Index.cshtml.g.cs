#pragma checksum "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "08a5c3eddc935d3ce0eaf37e9713568255c31dc4"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_OPERACIONES_Index), @"mvc.1.0.view", @"/Views/OPERACIONES/Index.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\_ViewImports.cshtml"
using CMI_CS_FUVEX;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\_ViewImports.cshtml"
using CMI_CS_FUVEX.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"08a5c3eddc935d3ce0eaf37e9713568255c31dc4", @"/Views/OPERACIONES/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"c389776d4191ca896db976ad1de6a72f362adddf", @"/Views/_ViewImports.cshtml")]
    public class Views_OPERACIONES_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<dynamic>
    {
        #line hidden
        #pragma warning disable 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext __tagHelperExecutionContext;
        #pragma warning restore 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner __tagHelperRunner = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner();
        #pragma warning disable 0169
        private string __tagHelperStringValueBuffer;
        #pragma warning restore 0169
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __backed__tagHelperScopeManager = null;
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __tagHelperScopeManager
        {
            get
            {
                if (__backed__tagHelperScopeManager == null)
                {
                    __backed__tagHelperScopeManager = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager(StartTagHelperWritingScope, EndTagHelperWritingScope);
                }
                return __backed__tagHelperScopeManager;
            }
        }
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.BodyTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("<!DOCTYPE HTML>\r\n");
            WriteLiteral("\r\n<style>\r\n    table tbody tr td {\r\n        font-size: 11px;\r\n    }\r\n\r\n    table thead tr th {\r\n        font-size: 11px;\r\n    }\r\n</style>\r\n\r\n\r\n<script type=\"text/javascript\">\r\n\r\n        var vMes = \'");
#nullable restore
#line 17 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
               Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
            WriteLiteral("\';\r\n        var vAno = \'");
#nullable restore
#line 18 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
               Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
            WriteLiteral("\';\r\n        var vDiaAC = \'");
#nullable restore
#line 19 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                 Write(ViewBag.DAY);

#line default
#line hidden
#nullable disable
            WriteLiteral(@"';


       function diaSemanaP(dia, mes, anio) {
        var dias = [""dom"", ""lun"", ""mar"", ""mie"", ""jue"", ""vie"", ""sab""];
        var dt = new Date(mes + ' ' + dia + ', ' + anio + ' 12:00:00');
        //console.log(dias[dt.getUTCDay()]);
        return dias[dt.getUTCDay()]
    };

    function load() {

        funOperaciones('PRESTAMO DE LIBRE DISPONIBILIDAD');
        funOperacionesAnual('PRESTAMO DE LIBRE DISPONIBILIDAD');
        //funDiario2()
        //console.log('");
#nullable restore
#line 34 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                  Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
            WriteLiteral(@"');
    };

    window.onload = load;

     function funOperaciones(nombre) {

         //$('#chartContainer').remove();

         //Cantidades Operaciones
         function EncuentrosMes(y, label, x) {
            this.y = y;
            this.x = x;
            this.label = label;
         };

         var arrEncuentroTabla = [];

         //Montos
         function EncuentrosMesMontos(y, label, x) {
            this.y = y;
            this.x = x;
            this.label = label;
         };

         var arrEncuentroTablaMontos = [];

         //Tickets
         function EncuentrosMesTickets(y, label, x) {
            this.y = y;
            this.x = x;
            this.label = label;
         };

         var arrEncuentroTablaTickets = [];

         $('#tbDiario').remove();
         $('#tbDesglose').remove();
         $('#tbDiarioCMI').remove();
         $('#tbTotales').remove();
         //------------------------------------------------------------------------------");
            WriteLiteral("--------- TABLA\r\n         var url = \"/OPERACIONES/FunListarOperaciones\";\r\n         $.get(url, { nombre: nombre, tipo: \'");
#nullable restore
#line 76 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                        Write(ViewBag.tipo);

#line default
#line hidden
#nullable disable
            WriteLiteral("\', txtTras: \'");
#nullable restore
#line 76 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                  Write(ViewBag.txtTras);

#line default
#line hidden
#nullable disable
            WriteLiteral(@"' }, function (data2) {

            var cabecera = """";
            var cuerpo = """";
            var cabeceratotal = """";

            cabecera = '<thead >';
            cabecera = cabecera + '<tr>';
            //cabecera = cabecera + '<th>.</th>';
            cabecera = cabecera + '<th>.</th>';
            cabecera = cabecera + '</tr></thead>';

            cabecera = cabecera + '<thead>';
            cabecera = cabecera + '<tr>';
            //cabecera = cabecera + '<th>Codigo</th>';
            cabecera = cabecera + '<th>Descripción de Estado</th>';
            cabecera = cabecera + '</tr></thead>';

             data2.forEach(function (element2) {

                //console.log(data2);


                cabecera = cabecera + '<tr>';
                //cabecera = cabecera + '<td> <small style=""color: blue"">' + element2.codigo + '</small></td>';
                cabecera = cabecera + '<td> <small style=""color: green"">' + element2.descripcion_estado + '</small> </td>';
               ");
            WriteLiteral(@" cabecera = cabecera + '</tr>';

                  //console.log(cabecera);

            });
            $('#pnlDiario').append('<table class=""table table-hover m-b-0"" style=""font-size:12.5px;"" id=""tbDiario"" >' + cabecera + '</table>').fadeIn(300000);
            //----------------------------------------------------------------------------

            cuerpo = '<thead>';
            cuerpo = cuerpo + '<tr>';
            for (i = 0; i < 31; i++) {

                var dia = i + 1;

                //console.log(dia);
                //console.log(vDiaAC);

                var Sem_dia = diaSemanaP(dia, vMes, vAno);


                if ((Sem_dia != ""dom"") && vDiaAC >= dia)
                {
                    cuerpo = cuerpo + '<th>' + Sem_dia + '</th>';
                }
            }
            cuerpo = cuerpo + '</tr>';
            cuerpo = cuerpo + '</thead>';

            cuerpo = cuerpo + '<thead>';
            cuerpo = cuerpo + '<tr>';
            for (i = 0; i < 31; i++");
            WriteLiteral(@") {

                var dia = i + 1;
                var Sem_dia = diaSemanaP(dia, vMes, vAno);
                //if ((Sem_dia != ""dom"" && Sem_dia != ""sab"") && vDiaAC >= dia)
                if ((Sem_dia != ""dom"") && vDiaAC >= dia)
                {

                    cuerpo = cuerpo + '<th>' + dia + '</th>';
                }
            }
            cuerpo = cuerpo + '</tr>';
            cuerpo = cuerpo + '</thead>';

            //--------------------------------------------- CUERPO INFORMACION

            cuerpo = cuerpo + '<tbody>';

            data2.forEach(function (element2) {
                cuerpo = cuerpo + '<tr>';
                for (i = 0; i < 31; i++) {

                    var dia = i + 1;
                    var Sem_dia = diaSemanaP(dia, vMes, vAno);
                    //if ((Sem_dia != ""dom"" && Sem_dia != ""sab"") && vDiaAC >= dia)
                    if ((Sem_dia != ""dom"") && vDiaAC >= dia)
                    {
                        var campo = ""element2.d");
            WriteLiteral(@"ia"" + dia;

                        cuerpo = cuerpo + '<td>'

                        if (eval(campo) >= 0) {

                            cuerpo = cuerpo + '<small style=""color: blue"">' + eval(campo).toLocaleString('en') + '</small>';
                        }
                        else {
                            cuerpo = cuerpo + '<small style=""color: blue"">' + eval(campo).toLocaleString('en') + '</small>';
                        }
                        cuerpo = cuerpo + '</td>';
                    }
                }

                cuerpo = cuerpo + '</tr>';
            });
            cuerpo = cuerpo + '</tbody>';

             $('#pnlDiarioCMI').append('<table class=""table table-hover m-b-0"" style=""font-size:12.5px;"" id=""tbDiarioCMI"" >' + cuerpo + '</table>').fadeIn(300000);//.innerHTML();

               //--------------------------------------------------------------------------------------- TABLA TOTALES

         cabeceratotal = '<thead >';
         cabeceratotal = ");
            WriteLiteral(@"cabeceratotal + '<tr>';
         //cabeceratotal = cabeceratotal + '<th>.</th>';
         cabeceratotal = cabeceratotal + '<th>.</th>';
         cabeceratotal = cabeceratotal + '</tr></thead>';

         cabeceratotal = cabeceratotal + '<thead>';
         cabeceratotal = cabeceratotal + '<tr>';
         //cabeceratotal = cabeceratotal + '<th>Codigo</th>';
         cabeceratotal = cabeceratotal + '<th>Total</th>';
         cabeceratotal = cabeceratotal + '</tr></thead>';

                 data2.forEach(function (element2) {

                     //console.log(data2);
                     //console.log(element.codigo);

                     cabeceratotal = cabeceratotal + '<tr>';
                     //cabecera = cabecera + '<td> <small style=""color: blue"">' + element2.codigo + '</small></td>';
                     cabeceratotal = cabeceratotal + '<td> <small style=""color: green"">' + element2.total + '</small> </td>';
                     cabeceratotal = cabeceratotal + '</tr>';

          ");
            WriteLiteral(@"           //console.log(cabecera);

                 });
             $('#pnlDiarioTotal').append('<table class=""table table-hover m-b-0"" style=""font-size:12.5px;"" id=""tbTotales"" >' + cabeceratotal + '</table>').fadeIn(300000);

         });

           //--------------------------------------------------------------------------------------- TABLA DESGLOSE
         var url = ""/OPERACIONES/FunListarOperacionesDesglose"";
         $.get(url, { nombre: nombre, tipo: '");
#nullable restore
#line 213 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                        Write(ViewBag.tipo);

#line default
#line hidden
#nullable disable
            WriteLiteral("\', txtTras: \'");
#nullable restore
#line 213 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                  Write(ViewBag.txtTras);

#line default
#line hidden
#nullable disable
            WriteLiteral(@"' }, function (data3) {

            var cabecera = """";
            var cuerpo = """";

            cabecera = cabecera + '<thead>';
            cabecera = cabecera + '<tr>';
            cabecera = cabecera + '<th>Codigo</th>';
            cabecera = cabecera + '<th>Descripcion</th>';
            cabecera = cabecera + '<th>Monto</th>';
            cabecera = cabecera + '<th>%</th>';
            cabecera = cabecera + '<th>Operaciones</th>';
            cabecera = cabecera + '<th>%</th>';
            cabecera = cabecera + '</tr></thead>';

             data3.forEach(function (element3) {

                //console.log(data3);
                //console.log(element.codigo);

                cabecera = cabecera + '<tr>';
                cabecera = cabecera + '<td> <small style=""color: blue"">' + element3.codigo + '</small></td>';
                cabecera = cabecera + '<td> <small style=""color: green"">' + element3.descripcion + '</small> </td>';
                cabecera = cabecera + '<td> <small");
            WriteLiteral(@" style=""color: blue"">' + element3.monto.toLocaleString('en') + '</small> </td>';
                cabecera = cabecera + '<td> <small style=""color: blue"">' + element3.monto_porcentaje + '</small> </td>';
                cabecera = cabecera + '<td> <small style=""color: blue"">' + element3.operaciones + '</small> </td>';
                cabecera = cabecera + '<td> <small style=""color: blue"">' + element3.operaciones_porcentaje + '</small> </td>';

                cabecera = cabecera + '</tr>';

                  //console.log(cabecera);

            });
            $('#pnlDesglose').append('<table class=""table table-hover m-b-0"" style=""font-size:12.5px;"" id=""tbDesglose"" >' + cabecera + '</table>').fadeIn(300000);

          });



         //--------------------------------------------------------------------------------------- GRAFICOS
         var url = ""/OPERACIONES/FunListarOperacionesGrafico"";
         $.get(url, { nombre: nombre, tipo: '");
#nullable restore
#line 254 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                        Write(ViewBag.tipo);

#line default
#line hidden
#nullable disable
            WriteLiteral("\', txtTras: \'");
#nullable restore
#line 254 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                  Write(ViewBag.txtTras);

#line default
#line hidden
#nullable disable
            WriteLiteral("\' }, function (data) {\r\n\r\n\r\n             //console.log(data);\r\n");
            WriteLiteral(@"
             data.forEach(function (element) {


                 if (element.descripcion_estado == ""EXP.FORMALIZADOS"")
                 {
                     arrEncuentroTabla.push(new EncuentrosMes(element.cantidad_monto, element.dia_nombre));
                     //ordenar ""label"" que será el día
                     arrEncuentroTabla.sort(function (a, b) { return a.label - b.label });

                 }
                 if (element.descripcion_estado == ""TICKET-PROMEDIO"")
                 {
                     arrEncuentroTablaTickets.push(new EncuentrosMesTickets(element.cantidad_monto, element.dia_nombre));
                     //ordenar ""label"" que será el día
                     arrEncuentroTablaTickets.sort(function (a, b) { return a.label - b.label });

                 }
                 if (element.descripcion_estado == ""MONTO-FORMALIZADO"") {

                     arrEncuentroTablaMontos.push(new EncuentrosMesMontos(element.cantidad_monto, element.dia_nombre));
          ");
            WriteLiteral(@"           //ordenar ""label"" que será el día
                     arrEncuentroTablaMontos.sort(function (a, b) { return a.label - b.label });
                 }

             });
             //console.log(arrEncuentroTablaMontos);

            CanvasJS.addColorSet(""greenShades"",
                [//colorSet Array

                ""#006ec1"",
                ""#ff2436"",
                ""#009ee5"",

                ""#a01e56"",

                ""#d1ce2b"",
                ""#52bcec"",
                ""#89d1f3"",
                ""#b5e5f9""

                ]);


            //var pointsArray = [];
            //pointsArray.push(points);

            var chart = new CanvasJS.Chart(""chartContainer"", {
                animationEnabled: true,
                animationDuration: 7000,
                colorSet: ""greenShades"",
                axisX: {
                    interval: 1,

                },
                axisY: {

                },
                 toolTip: {
                ");
            WriteLiteral(@"shared: true
                 },
                data: [
                    {
                        type: ""stackedColumn"",
                        name: ""# Operaciones"",
                        showInLegend: true,
                        yValueFormatString: ""#,##0.# Expedientes"",
                        dataPoints: arrEncuentroTabla,
                    },

                    {
                        type: ""line"",
                        name: ""Monto desembolsado en Millones S/."",
                        showInLegend: true,
                        yValueFormatString: ""#,##0.# Millones"",
                        axisYType: ""secondary"",
                        dataPoints: arrEncuentroTablaMontos,

                    },

                ]
            });

             chart.render();

             var chart2 = new CanvasJS.Chart(""chartContainer2"", {
                animationEnabled: true,
                animationDuration: 7000,
                colorSet: ""greenShades"",
        ");
            WriteLiteral(@"        axisX: {
                    interval: 1,

                },
                axisY: {

                },
                 toolTip: {
                shared: true
                 },
                data: [

                    {
                    type: ""line"",
                    name: ""Ticket Promedio"",
                    showInLegend: true,
                    yValueFormatString: ""#,##0.# Monto Promedio"",
                    //axisYType: ""secondary"",

                    dataPoints: arrEncuentroTablaTickets,

                },

                ]
            });

            chart2.render();


         //console.log(""--------------"");
         //console.log(points);

          });
    }

    function funOperacionesAnual(producto) {

        $('#tbAnual').remove();
        $('#tbAnualFlashReport').remove();
        //--------------------------------------------------------------------------------------- TABLA
        var url = ""/OPERACIONES/FunListarOperac");
            WriteLiteral("ionesAnual\";\r\n        $.get(url, { nombre: producto, tipo: \'");
#nullable restore
#line 390 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                         Write(ViewBag.tipo);

#line default
#line hidden
#nullable disable
            WriteLiteral("\', txtTras: \'");
#nullable restore
#line 390 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                   Write(ViewBag.txtTras);

#line default
#line hidden
#nullable disable
            WriteLiteral(@"' }, function (data2) {

            var cabeceraAnual = """";         

      

            cabeceraAnual = cabeceraAnual + '<thead>';
            cabeceraAnual = cabeceraAnual + '<tr>';            
            cabeceraAnual = cabeceraAnual + '<th>Descripción de Estado</th>';
            cabeceraAnual = cabeceraAnual + '</tr></thead>';

            data2.forEach(function (element2) {

                //console.log(data2);


                cabeceraAnual = cabeceraAnual + '<tr>';                
                cabeceraAnual = cabeceraAnual + '<td> <small style=""color: green"">' + element2.descripcion_estado + '</small> </td>';
                cabeceraAnual = cabeceraAnual + '</tr>';

                //console.log(cabecera);

            });
            $('#pnlAnual').append('<table class=""table table-hover m-b-0"" style=""font-size:12.5px;"" id=""tbAnual"" >' + cabeceraAnual + '</table>').fadeIn(300000);
        })



        //-------------------------------------------------------------");
            WriteLiteral("-------------------------- TABLA DESGLOSE\r\n         var url = \"/OPERACIONES/FunListarOperacionesAnual\";\r\n         $.get(url, { nombre: producto, tipo: \'");
#nullable restore
#line 420 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                          Write(ViewBag.tipo);

#line default
#line hidden
#nullable disable
            WriteLiteral("\', txtTras: \'");
#nullable restore
#line 420 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                    Write(ViewBag.txtTras);

#line default
#line hidden
#nullable disable
            WriteLiteral(@"' }, function (data3) {

            var tablaAnual = """";
            

            tablaAnual = tablaAnual + '<thead>';
            tablaAnual = tablaAnual + '<tr>';
            tablaAnual = tablaAnual + '<th>Ene</th>';
            tablaAnual = tablaAnual + '<th>Feb</th>';
            tablaAnual = tablaAnual + '<th>Mar</th>';
            tablaAnual = tablaAnual + '<th>Abr</th>';
            tablaAnual = tablaAnual + '<th>May</th>';
            tablaAnual = tablaAnual + '<th>Jun</th>';
            tablaAnual = tablaAnual + '<th>Jul</th>';
            tablaAnual = tablaAnual + '<th>Agos</th>';
            tablaAnual = tablaAnual + '<th>Set</th>';
            tablaAnual = tablaAnual + '<th>Oct</th>';
            tablaAnual = tablaAnual + '<th>Nov</th>';
            tablaAnual = tablaAnual + '<th>Dic</th>';
            tablaAnual = tablaAnual + '<th>Total</th>';
            tablaAnual = tablaAnual + '<th>Promedio</th>';
            tablaAnual = tablaAnual + '</tr></thead>';

             d");
            WriteLiteral(@"ata3.forEach(function (element4) {

                //console.log(data3);
                //console.log(element.codigo);

                 tablaAnual = tablaAnual + '<tr>';

                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.enero.toLocaleString('en') + '</small></td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.febrero.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.marzo.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.abril.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.mayo.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.junio.toLocaleString('en') + '</small> </td>';
                tablaAnual ");
            WriteLiteral(@"= tablaAnual + '<td> <small style=""color: blue"">' + element4.julio.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.agosto.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.setiembre.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.octubre.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.noviembre.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: blue"">' + element4.diciembre.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: green"">' + element4.total.toLocaleString('en') + '</small> </td>';
                tablaAnual = tablaAnual + '<td> <small style=""color: green"">' + ele");
            WriteLiteral(@"ment4.promedio.toLocaleString('en') + '</small> </td>';

                tablaAnual = tablaAnual + '</tr>';

                  //console.log(cabecera);

            });
            $('#pnlAnualMeses').append('<table class=""table table-hover m-b-0"" style=""font-size:12.5px;"" id=""tbAnualFlashReport"" >' + tablaAnual + '</table>').fadeIn(300000);

          });


     }



</script>


<div class=""block-header"">
    <div class=""row"">
        <div class=""col-lg-5 col-md-5 col-sm-12"">
            <h2>
                Contratacion Sencilla
                <small>Operaciones </small>
            </h2>
        </div>
        <div class=""col-lg-7 col-md-7 col-sm-12 text-right"">
            <ul class=""breadcrumb float-md-right"">
                <li class=""breadcrumb-item""><i class=""zmdi zmdi-home""></i>Contratacion Sencilla</a></li>
                <li class=""breadcrumb-item active"">Operaciones</li>
            </ul>
        </div>
    </div>
</div>

");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("body", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "08a5c3eddc935d3ce0eaf37e9713568255c31dc426385", async() => {
                WriteLiteral(@"

    <div class=""card"">
        <!-- Nav tabs -->

        <div class=""row clearfix"">

            <div class=""col-lg-9 col-md-9 col-3"">

                <ul class=""nav nav-tabs"">
                    <li class=""nav-item""><a class=""nav-link active"" data-toggle=""tab"" onclick=""funOperaciones('PRESTAMO DE LIBRE DISPONIBILIDAD'); funOperacionesAnual('PRESTAMO DE LIBRE DISPONIBILIDAD');"" style=""cursor:pointer"" aria-expanded=""false"">PRESTAMO DE LIBRE DISPONIBILIDAD</a></li>
                    <li class=""nav-item""><a class=""nav-link"" data-toggle=""tab"" onclick=""funOperaciones('TARJETA DE CREDITO');funOperacionesAnual('TARJETA DE CREDITO');"" style=""cursor:pointer"" aria-expanded=""false"">TARJETA DE CREDITO</a></li>
                    <li class=""nav-item""><a class=""nav-link"" data-toggle=""tab"" onclick=""funOperaciones('CONVENIO');funOperacionesAnual('CONVENIO');"" style=""cursor:pointer"" aria-expanded=""false"">CONVENIO</a></li>

                </ul>
            </div>

            <div class=""col-lg-3 col-");
                WriteLiteral("md-3 col-3\">\r\n\r\n                <div class=\"row\">\r\n                    <div class=\"col-4 p-r-0\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 520 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                     Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral("</h5>\r\n                        <small>Año</small>\r\n                    </div>\r\n                    <div class=\"col-4\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 524 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                     Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral("</h5>\r\n                        <small>Mes</small>\r\n                    </div>\r\n                    <div class=\"col-4 p-l-0\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 528 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                     Write(ViewBag.DAY);

#line default
#line hidden
#nullable disable
                WriteLiteral(@"</h5>
                        <small>Dia</small>
                    </div>
                </div>
            </div>
        </div>

    </div>


            <div class=""tab-content"">

                <div id=""home"" class=""tab-pane active"">


                    <div class=""row clearfix"">

                        <div class=""col-md-3"">
                            <div class=""card parents-list"">
                                <div class=""header"">
                                    <h2><strong>Flash Report</strong> M: ");
#nullable restore
#line 548 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                    Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral(" - A: ");
#nullable restore
#line 548 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                                      Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral(@"</h2>
                                </div>

                                <div class=""body"">
                                    <div class=""table-responsive"" id=""pnlDiario"">

                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class=""col-md-7"">
                            <div class=""card parents-list"">
                                <div class=""header"">
                                    <h2><strong>Contratación Sencilla</strong></h2>

                                </div>
                                <div class=""body"">
                                    <div class=""table-responsive"" id=""pnlDiarioCMI"">

                                    </div>
                                </div>
                            </div>
                        </div>



                        <div class=""col-md-2"">
                            <div class=""card p");
                WriteLiteral(@"arents-list"">
                                <div class=""header"">
                                    <h2><strong>TOTAL</strong></h2>

                                </div>
                                <div class=""body"">
                                    <div class=""table-responsive"" id=""pnlDiarioTotal"">

                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>


                    <div class=""row clearfix"">
                        <div class=""col-md-12"">
                            <div class=""card parents-list"">
                                <div class=""header"">
                                    <h2><strong>Grafico</strong> Cant. Expedientes vs Monto desembolsado en millones / Mes: ");
#nullable restore
#line 597 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                                                                       Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral(" - Año: ");
#nullable restore
#line 597 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                                                                                           Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral(@"</h2>

                                </div>

                                <div id=""chartContainer"" style=""height: 300px; width: 100%;""></div>

                            </div>

                        </div>


                        <div class=""col-md-12"">
                            <div class=""card parents-list"">
                                <div class=""header"">
                                    <h2><strong>Desglose de Ofertas</strong></h2>

                                </div>
                                <div class=""body"">
                                    <div class=""table-responsive"" id=""pnlDesglose"">

                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class=""col-md-12"">
                            <div class=""card parents-list"">
                                <div class=""header"">
                                    <h2><strong>Gr");
                WriteLiteral("afico</strong> Ticket Promedio / Mes: ");
#nullable restore
#line 625 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                                   Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral(" - Año: ");
#nullable restore
#line 625 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                                                       Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral(@"</h2>

                                </div>
                                <div class=""body"">
                                    <div id=""chartContainer2"" style=""height: 300px; width: 100%;""></div>
                                </div>
                            </div>

                        </div>

                    </div>


                    <div class=""row clearfix"">

                        <div class=""col-md-3"">
                            <div class=""card parents-list"">
                                <div class=""header"">
                                    <h2><strong>Flash Report</strong> Año: ");
#nullable restore
#line 643 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\OPERACIONES\Index.cshtml"
                                                                      Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral(@"</h2>
                                </div>

                                <div class=""body"">
                                    <div class=""table-responsive"" id=""pnlAnual"">

                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class=""col-md-9"">
                            <div class=""card parents-list"">
                                <div class=""header"">
                                    <h2><strong>Resumen Anual</strong></h2>

                                </div>
                                <div class=""body"">
                                    <div class=""table-responsive"" id=""pnlAnualMeses"">

                                    </div>
                                </div>
                            </div>
                        </div>





                    </div>




                </div>
            </div>









");
                WriteLiteral("            <script src=\"https://canvasjs.com/assets/script/canvasjs.min.js\"></script>\r\n\r\n");
                WriteLiteral("\r\n\r\n");
            }
            );
            __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.BodyTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            WriteLiteral("\r\n\r\n\r\n\r\n");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<dynamic> Html { get; private set; }
    }
}
#pragma warning restore 1591

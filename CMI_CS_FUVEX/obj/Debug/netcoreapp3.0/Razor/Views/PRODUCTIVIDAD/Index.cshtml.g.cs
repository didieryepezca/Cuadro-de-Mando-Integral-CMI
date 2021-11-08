#pragma checksum "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "b020188a0efe566de6bb364b56d645f4afc8e458"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_PRODUCTIVIDAD_Index), @"mvc.1.0.view", @"/Views/PRODUCTIVIDAD/Index.cshtml")]
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
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"b020188a0efe566de6bb364b56d645f4afc8e458", @"/Views/PRODUCTIVIDAD/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"c389776d4191ca896db976ad1de6a72f362adddf", @"/Views/_ViewImports.cshtml")]
    public class Views_PRODUCTIVIDAD_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<dynamic>
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
#nullable restore
#line 2 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
  
    ViewData["Title"] = "Index";

#line default
#line hidden
#nullable disable
            WriteLiteral(@"
<style>
    table tbody tr td {
        font-size: 12px;
        height: 40px;
    }

    table thead tr th {
        font-size: 11px;
        height: 30px;
    }

    select, option {
        text-align: right;
    }


    table tbody tr td .form-control {
        height: 20px;
    }   
</style>

");
            WriteLiteral("\r\n<script type=\"text/javascript\">\r\n\r\n    var vMes = \'");
#nullable restore
#line 34 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
           Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
            WriteLiteral("\';\r\n    var vAno = \'");
#nullable restore
#line 35 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
           Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
            WriteLiteral("\';\r\n    var vDiaAC = \'");
#nullable restore
#line 36 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
             Write(ViewBag.DAY);

#line default
#line hidden
#nullable disable
            WriteLiteral("\';\r\n\r\n");
            WriteLiteral(@"    
      window.onload = load;

    function load() {

        funFormalizacion('PRESTAMO DE LIBRE DISPONIBILIDAD'); //Funcion para traer la data de los graficos 
        funFormalizacionFuvex('PLD')
        
    };

    function funFormalizacion(producto)
    {        

        //---------------------------------GRAFICOS DE LINEAS

        //-------------- TIEMPO OFERTA APROBADA
        function TOfertaAprobada(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTOfertaAprobada = [];

        //-------------- TIEMPO OFERTA REGULAR
          function TOfertaRegular(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTOfertaRegular = [];

         //-------------- VALOR OBJETIVO APROBADA
          function VObjetivoAprobada(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrVObjetivoAprobada = [];

        //-------------- VALOR OBJETIVO REGULAR
 ");
            WriteLiteral(@"         function VObjetivoRegular(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrVObjetivoRegular = [];


        //---------------------------------TIEMPO ACUMULADO - GRAFICO DE BARRITAS

         //-------------- VALOR OBJETIVO REGULAR
          function TiemposAcumulados(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTiemposAcumulados = [];

        //---------------------------------TIEMPO ACUMULADO - GRAFICO DE BARRITAS MENSUAL
         function TiemposAcumuladosMensual(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTiemposAcumuladosMensual = [];

        //--------------------------------------------------------------------------------------- GRAFICO DE LINEAS CUMPLIMIENTO DE ANS DIARIO
        var url = ""/PRODUCTIVIDAD/FunMostrarGrafico"";
        $.get(url, { nombre: producto }, function (data) {

            data.forEach(function (elem");
            WriteLiteral(@"ent) {

                if (element.oferta == ""APROBADO"") {

                    arrTOfertaAprobada.push(new TOfertaAprobada(element.percentil, element.dia_nombre));
                    arrVObjetivoAprobada.push(new VObjetivoAprobada(1, element.dia_nombre));
                }
                if (element.oferta == ""REGULAR"") {
                    arrTOfertaRegular.push(new TOfertaRegular(element.percentil, element.dia_nombre));
                    arrVObjetivoRegular.push(new VObjetivoRegular(2, element.dia_nombre));
                }

                //-------------------------------- Barritas
                if (element.oferta == ""APROBADO-MES"" && element.tipo == ""DÍAS ÚTILES"" && element.dia_nombre == ""T. Oferta Aprobada"") {

                    arrTiemposAcumulados.push(new TiemposAcumulados(element.percentil, element.dia_nombre));
                }
                if (element.oferta == ""REGULAR-MES"" && element.tipo == ""DÍAS ÚTILES"" && element.dia_nombre == ""T. Oferta Regular"") {
         ");
            WriteLiteral(@"           arrTiemposAcumulados.push(new TiemposAcumulados(element.percentil, element.dia_nombre));
                }
                if (element.oferta == ""APROBADO-MES"" && element.tipo == ""DÍAS ÚTILES"") {
                    arrTiemposAcumuladosMensual.push(new TiemposAcumuladosMensual(element.percentil, element.dia_nombre));
                }
                if (element.oferta == ""REGULAR-MES"" && element.tipo == ""DÍAS ÚTILES"") {
                    arrTiemposAcumuladosMensual.push(new TiemposAcumuladosMensual(element.percentil, element.dia_nombre));
                }

            })
            //console.log(data);
        });



        //-------- Gráfico de lineas, tiempos diarios

        var charTiempos = new CanvasJS.Chart(""chartFormalizacion"", {
            animationEnabled: true,

            axisX: {
                interval: 1,
                valueFormatString: ""DD MMM,YY""
            },
            axisY: {
                includeZero: false,
                suffix: "" """);
            WriteLiteral(@"
            },
            legend: {
                cursor: ""pointer"",
                fontSize: 16,
                itemclick: toggleDataSeries
            },
            toolTip: {
                shared: true
            },
            data: [{
                name: ""Tiempo Oferta Aprobada"",
                type: ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrTOfertaAprobada
            },
            {
                name: ""Tiempo Oferta Regular"",
                type: ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrTOfertaRegular
            },
            {
                name: ""Valor Objetivo Aprobado"",
                type: ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrVObjetivoAprobada
            },
            {
                name: ""Valor O");
            WriteLiteral(@"bjetivo Regular"",
                type: ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrVObjetivoRegular
            },
            ]
        });
        charTiempos.render();

        function toggleDataSeries(e) {
            if (typeof (e.dataSeries.visible) === ""undefined"" || e.dataSeries.visible) {
                e.dataSeries.visible = false;
            }
            else {
                e.dataSeries.visible = true;
            }
            charTiempos.render();
        }


        //-------- Gráfico de columnas, tiempos acumulados oferta aprobada y regular

        var chartColumnas = new CanvasJS.Chart(""chartTiempoAcumulado"", {
            animationEnabled: true,
            theme: ""light1"",
            data: [{
                type: ""column"", //change type to bar, line, area, pie, etc
                indexLabelFontColor: ""#5A5757"",
                indexLabelFontSize: 16,
                indexLa");
            WriteLiteral(@"belPlacement: ""outside"",
                dataPoints: arrTiemposAcumulados
            }]
        });
        chartColumnas.render();


        //-------- Gráfico de columnas, tiempos acumulados oferta aprobada y regular MENSUAL

        var chartAcumuladoMensual = new CanvasJS.Chart(""chartDesembolsoMensual"", {

            animationEnabled: true,

            axisY: {
                titleFontColor: ""#4F81BC"",
                lineColor: ""#4F81BC"",
                labelFontColor: ""#4F81BC"",
                tickColor: ""#4F81BC""
            },
            axisY2: {

                titleFontColor: ""#C0504E"",
                lineColor: ""#C0504E"",
                labelFontColor: ""#C0504E"",
                tickColor: ""#C0504E""
            },
            toolTip: {
                shared: true
            },
            legend: {
                cursor: ""pointer""
            },
            data: [{

                type: ""column"",
                showInLegend: true,
              ");
            WriteLiteral(@"  yValueFormatString: ""##.00"",
                dataPoints: arrTiemposAcumuladosMensual
            }]
        });

        chartAcumuladoMensual.render();
    }  


    function funFormalizacionFuvex(producto)
    {




         //-------------- TIEMPO OFERTA APROBADA
        function TOfertaAprobada(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTOfertaAprobada = [];

        //-------------- TIEMPO OFERTA REGULAR
          function TOfertaRegular(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTOfertaRegular = [];

         //-------------- VALOR OBJETIVO APROBADA
          function VObjetivoAprobada(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrVObjetivoAprobada = [];

        //-------------- VALOR OBJETIVO REGULAR
          function VObjetivoRegular(y,label) {
            this.y = y;
            this.label = label;
         };");
            WriteLiteral(@"
        var arrVObjetivoRegular = [];

        //---------------------------------TIEMPO ACUMULADO - GRAFICO DE BARRITAS

         //-------------- VALOR OBJETIVO REGULAR
          function TiemposAcumulados(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTiemposAcumulados = [];

        //---------------------------------TIEMPO ACUMULADO - GRAFICO DE BARRITAS MENSUAL
         function TiemposAcumuladosMensual(y,label) {
            this.y = y;
            this.label = label;
         };
        var arrTiemposAcumuladosMensual = [];



        //--------------------------------------------------------------------------------------- GRAFICO DE LINEAS CUMPLIMIENTO DE ANS DIARIO
        var url = ""/PRODUCTIVIDAD/FunTraerFuvexPercentiles"";
        $.get(url, { mes: vMes, anio: vAno, producto: producto, paperless: ""FISICO"", tipo: ""DÍAS ÚTILES"", frecuencia: ""DIARIO""  }, function (data) {

            console.log(data);

            data.forEa");
            WriteLiteral(@"ch(function (element) {

                if (element.nombrE_TIPO_OFERTA == ""APROBADOS"" && element.tipo == ""DÍAS ÚTILES"") {

                    arrTOfertaAprobada.push(new TOfertaAprobada(element.percentil, element.fecha));
                    arrVObjetivoAprobada.push(new VObjetivoAprobada(1, moment(element.fecha).format('DD-MM')));
                }
                if (element.nombrE_TIPO_OFERTA == ""REGULAR"" && element.tipo == ""DÍAS ÚTILES"") {
                    arrTOfertaRegular.push(new TOfertaRegular(element.percentil, element.fecha));
                    arrVObjetivoRegular.push(new VObjetivoRegular(2, moment(element.fecha).format('DD-MM')));
                }

                //-------------------------------- Barritas
                if (element.nombrE_TIPO_OFERTA == ""APROBADOS"" && element.tipo == ""DÍAS ÚTILES"" && element.frecuencia == ""MES"") {

                    arrTiemposAcumulados.push(new TiemposAcumulados(element.percentil, moment(element.fecha).format('DD-MM-YYYY')));
        ");
            WriteLiteral(@"        }
                if (element.nombrE_TIPO_OFERTA == ""REGULAR"" && element.tipo == ""DÍAS ÚTILES"" && element.frecuencia == ""MES"") {

                    arrTiemposAcumulados.push(new TiemposAcumulados(element.percentil, moment(element.fecha).format('DD-MM-YYYY')));
                }
                //if (element.nombrE_TIPO_OFERTA == ""APROBADOS"" && element.tipo == ""DÍAS ÚTILES"") {
                //    arrTiemposAcumuladosMensual.push(new TiemposAcumuladosMensual(element.percentil, element.fecha));
                //}
                //if (element.nombrE_TIPO_OFERTA == ""REGULAR"" && element.tipo == ""DÍAS ÚTILES"") {
                //    arrTiemposAcumuladosMensual.push(new TiemposAcumuladosMensual(element.percentil, element.dia_nombre));
                //}

            })
            //console.log(data);
        });


        //-------- Gráfico de lineas, tiempos diarios

        var charTiemposFuvex = new CanvasJS.Chart(""chartFormalizacionFuvex"", {
            animationEnabled: true,");
            WriteLiteral(@"

            axisX: {
                interval: 1,
                valueFormatString: ""DD MMM,YY""
            },
            axisY: {
                includeZero: false,
                suffix: "" ""
            },
            legend: {
                cursor: ""pointer"",
                fontSize: 16,
                itemclick: toggleDataSeries
            },
            toolTip: {
                shared: true
            },
            data: [{
                name: ""Tiempo Oferta Aprobada"",
                type: ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrTOfertaAprobada
            },
            {
                name: ""Tiempo Oferta Regular"",
                type: ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrTOfertaRegular
            },
            {
                name: ""Valor Objetivo Aprobado"",
                type:");
            WriteLiteral(@" ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrVObjetivoAprobada
            },
            {
                name: ""Valor Objetivo Regular"",
                type: ""spline"",
                yValueFormatString: ""##.00"",
                showInLegend: true,
                dataPoints: arrVObjetivoRegular
            },
            ]
        });
        charTiemposFuvex.render();

        function toggleDataSeries(e) {
            if (typeof (e.dataSeries.visible) === ""undefined"" || e.dataSeries.visible) {
                e.dataSeries.visible = false;
            }
            else {
                e.dataSeries.visible = true;
            }
            charTiemposFuvex.render();
        }


        //-------- Gráfico de columnas, tiempos acumulados oferta aprobada y regular

        var chartColumnasFuvex = new CanvasJS.Chart(""chartTiempoAcumuladoFuvex"", {
            animationEnabled: true,
            the");
            WriteLiteral(@"me: ""light1"",
            data: [{
                type: ""column"", //change type to bar, line, area, pie, etc
                indexLabelFontColor: ""#5A5757"",
                indexLabelFontSize: 16,
                indexLabelPlacement: ""outside"",
                dataPoints: arrTiemposAcumulados
            }]
        });
        chartColumnasFuvex.render();

    }

</script>

<div class=""block-header"">
    <div class=""row"">
        <div class=""col-lg-5 col-md-5 col-sm-12"">
            <h2>
                Contratacion Sencilla
                <small>Tiempo de Formalizacion Dias Laborales </small>
            </h2>
        </div>
        <div class=""col-lg-7 col-md-7 col-sm-12 text-right"">
            <ul class=""breadcrumb float-md-right"">
                <li class=""breadcrumb-item""><i class=""zmdi zmdi-home""></i>Contratacion Sencilla</a></li>
                <li class=""breadcrumb-item active"">Tiempo de Formalizacion Dias Laborales</li>
            </ul>
        </div>
    </div>
</");
            WriteLiteral("div>\r\n\r\n");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("body", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "b020188a0efe566de6bb364b56d645f4afc8e45819454", async() => {
                WriteLiteral(@"

    <div class=""card"">
        <!-- Nav tabs -->

        <div class=""row clearfix"">

            <div class=""col-lg-9 col-md-9 col-3"">
                <ul class=""nav nav-tabs"">
                    <li class=""nav-item""><a class=""nav-link active"" data-toggle=""tab"" onclick=""funFormalizacion('PRESTAMO DE LIBRE DISPONIBILIDAD');funFormalizacionFuvex('PLD')"" style=""cursor:pointer"" aria-expanded=""false"">PRESTAMO DE LIBRE DISPONIBILIDAD</a></li>
                    <li class=""nav-item""><a class=""nav-link"" data-toggle=""tab"" onclick=""funFormalizacion('TARJETA DE CREDITO');funFormalizacionFuvex('TC')"" style=""cursor:pointer"" aria-expanded=""false"">TARJETA DE CREDITO</a></li>
                    <li class=""nav-item""><a class=""nav-link"" data-toggle=""tab"" onclick=""funFormalizacion('CONVENIO')"" style=""cursor:pointer"" aria-expanded=""false"">CONVENIO</a></li>
                </ul>
            </div>
            <div class=""col-lg-3 col-md-3 col-3"">

                <div class=""row"">
                    <div c");
                WriteLiteral("lass=\"col-4 p-r-0\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 465 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
                                     Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral("</h5>\r\n                        <small>Año</small>\r\n                    </div>\r\n                    <div class=\"col-4\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 469 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
                                     Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral("</h5>\r\n                        <small>Mes</small>\r\n                    </div>\r\n                    <div class=\"col-4 p-l-0\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 473 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
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
                <div class=""col-md-12"">
                    <div class=""card parents-list"">
                        <div class=""header"">
                            <h2><strong>Contratacion Sencilla</strong> Tiempo de Formalizacion Dias Laborales</h2>

                        </div>

                        <div id=""chartFormalizacion"" style=""height: 300px; width: 100%;""></div>

                    </div>

                </div>


            </div>



            <div class=""row"">

                <div class=""col-md-4"">
                    <div class=""card parents-list"">
                        <div class=""header"">
                            <h2><strong>Contratacion Sencilla</strong> Tiempo Acumulado M: ");
#nullable restore
#line 509 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
                                                                                      Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral(" - A: ");
#nullable restore
#line 509 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
                                                                                                        Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral(@"</h2>
                        </div>

                        <div class=""body"">
                            <div id=""chartTiempoAcumulado"" style=""height: 300px; width: 100%;""></div>
                        </div>

                    </div>
                </div>

                <div class=""col-md-8"">
                    <div class=""card parents-list"">
                        <div class=""header"">
                            <h2><strong>Contratacion Sencilla</strong> Tiempo Desembolso Mensual</h2>

                        </div>
                        <div class=""body"">
                            <div id=""chartDesembolsoMensual"" style=""height: 300px; width: 90%;""></div>
                        </div>


                    </div>
                </div>


            </div>




            <div class=""row clearfix"">
                <div class=""col-md-12"">
                    <div class=""card parents-list"">
                        <div class=""header"">
                        ");
                WriteLiteral(@"    <h2><strong>Fuvex</strong> Tiempo de Formalizacion Dias Laborales</h2>

                        </div>

                        <div id=""chartFormalizacionFuvex"" style=""height: 300px; width: 100%;""></div>

                    </div>

                </div>


            </div>



            <div class=""row"">

                <div class=""col-md-4"">
                    <div class=""card parents-list"">
                        <div class=""header"">
                            <h2><strong>Fuvex</strong> Tiempo Acumulado M: ");
#nullable restore
#line 563 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
                                                                      Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral(" - A: ");
#nullable restore
#line 563 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\Index.cshtml"
                                                                                        Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral(@"</h2>
                        </div>

                        <div class=""body"">
                            <div id=""chartTiempoAcumuladoFuvex"" style=""height: 300px; width: 100%;""></div>
                        </div>

                    </div>
                </div>

                <div class=""col-md-8"">
                    <div class=""card parents-list"">
                        <div class=""header"">
                            <h2><strong>Fuvex</strong> Tiempo Desembolso Mensual</h2>

                        </div>
                        <div class=""body"">
                            <div id=""chartDesembolsoMensualFuvex"" style=""height: 300px; width: 90%;""></div>
                        </div>


                    </div>
                </div>


            </div>









            <script src=""https://canvasjs.com/assets/script/canvasjs.min.js""></script>
            <script src=""https://momentjs.com/downloads/moment.js""></script>

");
                WriteLiteral("\r\n");
                WriteLiteral("        </div>\r\n    </div>\r\n\r\n");
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
            WriteLiteral("\r\n\r\n\r\n");
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

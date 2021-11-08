#pragma checksum "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "8201040002dbdf805132adf38d2b705c2d33dbb0"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_PRODUCTIVIDAD_TuberiaConv), @"mvc.1.0.view", @"/Views/PRODUCTIVIDAD/TuberiaConv.cshtml")]
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
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"8201040002dbdf805132adf38d2b705c2d33dbb0", @"/Views/PRODUCTIVIDAD/TuberiaConv.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"c389776d4191ca896db976ad1de6a72f362adddf", @"/Views/_ViewImports.cshtml")]
    public class Views_PRODUCTIVIDAD_TuberiaConv : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<dynamic>
    {
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_0 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("src", new global::Microsoft.AspNetCore.Html.HtmlString("~/js/tablaDesglose.js"), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
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
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n");
#nullable restore
#line 2 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml"
  
    ViewData["Title"] = "TuberiaConv";
    //Layout = "~/Views/Shared/_Layout.cshtml";

#line default
#line hidden
#nullable disable
            WriteLiteral(@"
<link rel=""stylesheet"" type=""text/css"" href=""https://cdn3.devexpress.com/jslib/20.1.4/css/dx.common.css"" />
<link rel=""stylesheet"" type=""text/css"" href=""https://cdn3.devexpress.com/jslib/20.1.4/css/dx.softblue.css"" />
<script type=""text/javascript"">


    var vMes = '");
#nullable restore
#line 12 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml"
           Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
            WriteLiteral("\';\r\n    var vAno = \'");
#nullable restore
#line 13 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml"
           Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
            WriteLiteral("\';\r\n    var vDiaAC = \'");
#nullable restore
#line 14 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml"
             Write(ViewBag.DAY);

#line default
#line hidden
#nullable disable
            WriteLiteral(@"';


    window.onload = load;

    function load() {

        funTuberia('CONVENIO');

        };


        function funTuberia(producto)
        {
            function EncuentrosTuberia(y,label) {
            this.y = y;
            this.label = label;
         };
            var arrEncuentrosTuberia = [];


            var url = ""/PRODUCTIVIDAD/FunMostrarTuberia"";
            $.get(url, { nombre: producto }, function (data) {


                data.forEach(function (element) {
                    ///-------------------------------------------------------------------------------GRAFICO DE BARRAS

                    if (element.producto == producto) {

                        arrEncuentrosTuberia.push(new EncuentrosTuberia(element.total, element.bandeja));
                    }

                })

            });

             //-------- Gráfico grande Mensual
        var chartTuberia = new CanvasJS.Chart(""chartTuberia"", {
            animationEnabled: true,
        ");
            WriteLiteral(@"    axisX: {
                interval: 1
            },
            axisY: {
                scaleBreaks: {
                    type: ""wavy"",
                    customBreaks: [{
                        startValue: 80,
                        endValue: 210
                    },
                    {
                        startValue: 230,
                        endValue: 600
                    }
                    ]
                }
            },
            data: [{
                type: ""bar"",
               dataPoints: arrEncuentrosTuberia
            }]
        });

            chartTuberia.render();



        }

</script>
<div class=""block-header"">
    <div class=""row"">
        <div class=""col-lg-5 col-md-5 col-sm-12"">
            <h2>
                Contratacion Sencilla
                <small>Tuberia y Seguimiento de Operaciones </small>
            </h2>
        </div>
        <div class=""col-lg-7 col-md-7 col-sm-12 text-right"">
            <ul class=""br");
            WriteLiteral(@"eadcrumb float-md-right"">
                <li class=""breadcrumb-item""><i class=""zmdi zmdi-home""></i>Contratacion Sencilla</a></li>
                <li class=""breadcrumb-item active"">Tuberia y Seguimiento de Operaciones</li>
            </ul>
        </div>
    </div>
</div>

");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("body", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "8201040002dbdf805132adf38d2b705c2d33dbb07332", async() => {
                WriteLiteral(@"
    <div class=""card"">
        <!-- Nav tabs -->

        <div class=""row clearfix"">

            <div class=""col-lg-9 col-md-9 col-3"">
                <ul class=""nav nav-tabs"" id=""myTab"">                   
                    <li class=""nav-item""><a class=""nav-link active"" data-toggle=""tab"" onclick=""funTuberia('CONVENIO');"" style=""cursor:pointer"" aria-expanded=""false"">CONVENIO</a></li>
                </ul>
            </div>
            <div class=""col-lg-3 col-md-3 col-3"">

                <div class=""row"">
                    <div class=""col-4 p-r-0"">
                        <h5 class=""m-b-5"">");
#nullable restore
#line 116 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml"
                                     Write(ViewBag.YEAR);

#line default
#line hidden
#nullable disable
                WriteLiteral("</h5>\r\n                        <small>Año</small>\r\n                    </div>\r\n                    <div class=\"col-4\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 120 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml"
                                     Write(ViewBag.MES);

#line default
#line hidden
#nullable disable
                WriteLiteral("</h5>\r\n                        <small>Mes</small>\r\n                    </div>\r\n                    <div class=\"col-4 p-l-0\">\r\n                        <h5 class=\"m-b-5\">");
#nullable restore
#line 124 "C:\Workspace\CMI_CS_FUVEX\CMI_CS_FUVEX\Views\PRODUCTIVIDAD\TuberiaConv.cshtml"
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
                            <h2><strong>Tuberia de Contratacion Sencilla: </strong></h2>
                        </div>

                        <div class=""body"">
                            <div id=""chartTuberia"" style=""height: 300px; width: 100%;""></div>
                        </div>

                        <div class=""footer"">
                            <div id=""chartTuberiaFooter"" style=""height: 20px; width: 100%;"">

                            </div>
                        </div>

                    </div>
                </div>






            </div>


        ");
                WriteLiteral(@"    <div class=""row"">

                <div class=""col-md-12"">
                    <div class=""card parents-list"">
                        <div class=""header"">
                            <h2><strong>Seguimiento de Operaciones: </strong></h2>
                        </div>

                        <div class=""body"">
                            <div id=""tableSeguimientoOperaciones"" style=""height: auto; width: 100%;""></div>
                        </div>

                        <div class=""footer"">
                            <div style=""height: auto; width: 100%;"">
                                <div class=""options"">
                                    <div class=""caption"">Options</div>
                                    <div class=""option"">
                                        <div id=""autoExpand""></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
  ");
                WriteLiteral("              </div>\r\n\r\n            </div>\r\n\r\n\r\n\r\n        </div>\r\n    </div>\r\n\r\n\r\n    <script src=\"https://canvasjs.com/assets/script/canvasjs.min.js\"></script>\r\n\r\n\r\n");
                WriteLiteral(@"
    <script src=""https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js""></script>
    <script>window.jQuery || document.write(decodeURIComponent('%3Cscript src=""js/jquery.min.js""%3E%3C/script%3E'))</script>
    <script src=""https://cdn3.devexpress.com/jslib/20.1.4/js/dx.all.js""></script>

    ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("script", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "8201040002dbdf805132adf38d2b705c2d33dbb012071", async() => {
                }
                );
                __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_0);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
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
            WriteLiteral("\r\n");
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

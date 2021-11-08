


var producto = $('.nav-tabs .active').text();


// $('.nav-tabs').on('dblclick', function (event) {    

//     producto = $('.nav-tabs .active').text();
//     arrojarValor();
    
//});

//function arrojarValor() {
//    alert(producto); 

//    return producto;
//};

console.log(producto);

//---------------------------------AJAX
var seguimientos = function () {    

    var salidaAjax = null;

    $.ajax({
        url: '/PRODUCTIVIDAD/FunTraerSeguimientoOperaciones',
        type: "POST",
        dataType: "JSON",
        async: false,
        data: { nombre: producto },
        success: function (data) {
            //console.log(data);

            salidaAjax = data;
        }
    });
    return salidaAjax;
}();

//console.log(producto);
//console.log(seguimientos); 


    
var dataGrid = $("#tableSeguimientoOperaciones").dxDataGrid({
    dataSource: seguimientos,
    allowColumnReordering: true,
    showBorders: true,
    grouping: {
        autoExpandAll: true,
    },
    searchPanel: {
        visible: true
    },
    paging: {
        pageSize: 15
    },
    groupPanel: {
        visible: true
    },
    columns: [
        "tipo",
        "tarea",
        "nro_expediente",
        "ejecutivo",
        "nom_territorio",
        "nom_oficina",
        "fecha",
        "plazo",
        {
            dataField: "tarea",
            groupIndex: 0
        }
    ]
}).dxDataGrid("instance");

$("#autoExpand").dxCheckBox({
    value: true,
    text: "Expand All Groups",
    onValueChanged: function (data) {
        dataGrid.option("grouping.autoExpandAll", data.value);
    }
});



window.addEventListener('load', function() {

    var colonias = $('#field-Colonia');
    var segments = window.location.pathname.split('/');
    var posicion = segments.length - 1;
    $.ajax({
        data: { ids: segments[posicion] },
        url: 'http://localhost/eddyburguerR/index.php/Empleado/llenarColoniasEdit',
        type: 'POST',
        dataType: 'json',
        success: function(r) {
            colonias.find('option').remove();
            colonias.append('<option value=""> Selecciona una colonia </option>');
            $(r).each(function(i, v) {
                colonias.append('<option value="' + v.idColonia + '">' + v.colonia + '</option>');
            });
            editSel();
        },
        error: function() {
            alert('Algo salio mal');
        }
    });
});
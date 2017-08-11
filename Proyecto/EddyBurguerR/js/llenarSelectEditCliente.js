function editSel() {
    var ciudad = $('#field-Ciudad');
    var estado = $('#field-Estado');
    var calle = $('#field-calle');
    var numero = $('#field-numero');
    var segments = window.location.pathname.split('/');
    var posicion = segments.length - 1;
    $.ajax({
        data: { id: segments[posicion] },
        url: 'http://localhost/eddyburguerR/index.php/Cliente/llenarEditFields',
        type: 'POST',
        dataType: 'json',
        success: function(r) {
            $(r).each(function(i, v) {
                $('#field-Codigopostal > option[value="' + v.codigoPostal + '"]').attr('selected', 'selected');
                $('#field-Colonia > option[value="' + v.idColonia + '"]').attr('selected', 'selected');
                // $('#field_Codigopostal_chosen > a > span').val(v.codigoPostal);
                $('#field_Codigopostal_chosen > div > ul').append('<li class="active-result result-selected" data-option-array-index="2">38610</li>');
                $('#cp_actual').val(v.codigoPostal);
                $('#field-Direccion_idDireccion').val(v.Direccion_idDireccion);
                ciudad.val(v.ciudad);
                estado.val(v.estado);
                calle.val(v.calle_dir);
                numero.val(v.no_dir);
            });
        }
    });
}
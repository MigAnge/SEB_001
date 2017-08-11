$(document).ready(function() {
    //añadimos la propiedad disabled al select colonias
    $("#field-Colnia").prop('disabled', true);

    //detectamos el cambio del select C.P
    $('#field-Codigopostal').change(function() {
        //guardamos el selec de colonia
        var colonias = $('#field-Colonia');
        var ciudad = $('#field-Ciudad');
        var estado = $('#field-Estado');

        //guardamos el C.P seleccionado
        var cp = $(this);

        if ($(this).val() != '') {
            $.ajax({
                data: { codigos: cp.val() },
                url: 'http://localhost/eddyburguerR/index.php/Empleado/llenarColonias',
                type: 'POST',
                dataType: 'json',
                success: function(r) {
                    cp.prop('disabled', false);
                    colonias.find('option').remove();
                    colonias.append('<option value=""> Selecciona una colonia </option>');
                    $(r).each(function(i, v) {
                        colonias.append('<option value="' + v.idColonia + '">' + v.colonia + '</option>');
                        ciudad.val(v.ciudad);
                        estado.val(v.estado);
                    });
                    colonias.prop('disabled', false);
                },
                error: function() {
                    alert('Algo salio mal');
                    cp.prop('disabled', false);
                }
            });
        } else {
            colonias.find('option').remove();
            colonias.prop('disabled', true);
        }
    });
});
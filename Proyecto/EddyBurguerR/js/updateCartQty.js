$(document).ready(function() {
    var cantidad1 = $('#cantidad');
    var can = cantidad1.val();
    $('#cantidad').change(function() {
        var cantidad = $('#cantidad');
        var rowids = $('#rowid');
        $.ajax({
            data: { cantidad: cantidad.val(), rowid: rowids.val() },
            url: 'http://localhost/eddyburguerR/index.php/Productos/updateCartStock',
            type: 'POST',
            success: function(r) {
                if (r == "Actualizado") {
                    cantidad.val(cantidad.val());
                } else {
                    alert("error");
                }
                window.location.reload();
            },
        });

    });
});
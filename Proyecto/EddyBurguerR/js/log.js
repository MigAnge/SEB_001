$(document).on("ready", main);

function main() {
    $("#login").submit(function(event) {
        event.preventDefault();
        $.ajax({
            url: $(this).attr("action"),
            type: $(this).attr("method"),
            data: $(this).serialize(),
            success: function(resp) {
                if (resp == 1) {
                    window.location.href = "../Eddy/eddy";
                } else if (resp == 0) {
                    window.location.href = "index"
                } else if (resp == "error") {
                    alert("El usuario no existe");
                }
            }
        });
    });
}
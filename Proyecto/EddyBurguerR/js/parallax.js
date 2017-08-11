$(document).ready(function(){

	$(window).scroll(function(){
		var barra = $(window).scrollTop();
		var posicion =  (barra * 0.15);

		$('.paralax').css({
			'background-position': '0 +' + posicion + 'px'
		});

	});

});

$(document).ready(function(){

	$(window).scroll(function(){
		var barra = $(window).scrollTop();
		var posicion =  (barra * 0.35);

		$('.galerias').css({
			'background-position': '0 -' + posicion + 'px'
		});

	});

});

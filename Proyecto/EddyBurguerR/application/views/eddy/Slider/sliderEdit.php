<?php

/**
 * vista editar slider
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.2
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/eddy/Slider/sliderEdit.php
 *@since File available since Release 0.0.1
*/


$this->load->view('eddy/template/header');
$this->load->view('eddy/template/nav');
?>

<div class="right_col" role="main">
  <div class="row">
    <div class="col-xs-12 col-sm-12">
      <div class="page-title">
        <div class="title_left">
          <h3>Aministrar Slider</h3>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-xs-12 col-sm-12">
      <div class="x_panel">
        <div class="x_title">
          <h2>Editar un elemento al slider</h2>
          <div class="clearfix"></div>
        </div>
        <div class="x_content">

<?php foreach ($sliderEdit as $item): ?>
          <form name="form" class="" role="form" data-toggle="validator" action="../updateSlider" data-parsley-validate method="post" class="form-horizontal form-label-left" enctype="multipart/form-data">
            <div class="form-group">
                <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Cambiar imagen</label>
            </div>
            <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Imagen Actual</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                  <img src="<?php echo base_url() . $item->urlImagen ?>" class="imgSliderEdit"alt="">
              </div>
              <script>
              function imgm(reader){
                if(reader){
                  document.getElementById('vistaPrevia').innerHTML=('<div class=\"form-group\"><label for="" class=\"control-label col-md-3 col-sm-3 col-xs-12\">Cambiar por</label></div><div class=\"col-md-6 col-sm-6 col-xs-12\"><img id=\"mostrarImagen\" src=\"#\" class=\"imgSliderEdit\"alt=""></div>');
                }
              }
              </script>
              <div id="vistaPrevia">

              </div>

              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" class="form-control" placeholder="Selecciona una imagen" id="imagenN" name="imagenN" readonly="readonly">
                   <label for="imagen" class="btn btn-success"><span class="fa fa-search" ></span> Buscar<input type="file" name="imagen" id="imagen" value="" class="form-control col-md-7 col-xs-12"></label>
                </div>
              </div>

            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Cambiar título</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="titulo" value="<?php echo $item->titulo; ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

            <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Cambiar texto</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="texto" value="<?php echo $item->texto; ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

            <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Cambiar texto del botón</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="boton" value="<?php echo $item->botonText; ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

            <div class="clearfix"></div>
            <div class="form-group">
             
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="hidden" name="user" value="<?php echo $this->session->userdata('id') ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

            <div class="clearfix"></div>
            <br>
            <input type="hidden" name="idImagen" value="<?php echo $item->idImagen ?>">
            <input type="hidden" name="imagenActual" value="<?php echo $item->urlImagen ?>">
            <div class="col-md-6 col-sm-6 col-xs-12">
              <input type="Submit" name="btn" value="Actualizar" class="btn btn-success">
            </div>
          </form>
<?php endforeach; ?>
        </div>
      </div>
    </div>
  </div>
</div>

<?php $this->load->view('eddy/template/footer'); ?>

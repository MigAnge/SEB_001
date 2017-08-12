<?php
$this->load->view('eddy/template/header');
$this->load->view('eddy/template/nav');
?>

<div class="right_col" role="main">
  <div class="row">
    <div class="col-xs-12 col-sm-12">
      <div class="page-title">
        <div class="title_left">
          <h3>Administrar Noticias</h3>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-xs-12 col-sm-12">
      <div class="x_panel">
        <div class="x_title">
          <h2>Agregar Noticias</h2>
          <div class="clearfix"></div>
        </div>
        <div class="x_content">
          <form class="" name="form" role="form" data-toggle="validator" action="saveNoticias" data-parsley-validate method="post" class="form-horizontal form-label-left" enctype="multipart/form-data">
            <div class="form-group">
                <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Selecciona una imagen <span class="required">*</span></label>
                <div class="clearfix"></div>

                            <script>
                            function imgm(reader){
                              if(reader){
                                document.getElementById('vistaPrevia').innerHTML=('<div class=\"col-md-6 col-sm-6 col-xs-12\"><img id=\"mostrarImagen\" src=\"#\" class=\"imgSliderEdit\"alt=""></div>');
                              }
                            }
                            </script>
                            <div id="vistaPrevia">

                            </div>

                            <div class="clearfix"></div>
                            <div class="col-md-6 col-sm-6 col-xs-12">
                              <input type="text" class="form-control" placeholder="Selecciona una imagen" id="imagenN" name="imagenN" readonly="readonly">
                                 <label for="imagen" class="btn btn-success"><span class="fa fa-search"></span> Buscar<input type="file" name="imagen" id="imagen" value="" required="required" class="form-control col-md-7 col-xs-12"></label>
                            </div>
            </div>

            <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Título</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="titulo" value="" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

            <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Texto</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="texto" value="" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>
            <div class="clearfix"></div>
            <div class="col-md-6 col-sm-6 col-xs-12">
              <input type="Submit" name="btn" value="Guardar" class="btn btn-success ">
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<?php $this->load->view('eddy/template/footer'); ?>

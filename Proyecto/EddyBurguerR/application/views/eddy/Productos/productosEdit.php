<?php
$this->load->view('eddy/template/header');
$this->load->view('eddy/template/nav');
?>

<div class="right_col" role="main">
  <div class="row">
    <div class="col-xs-12 col-sm-12">
      <div class="page-title">
        <div class="title_left">
          <h3>Editar Producto</h3>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="col-xs-12 col-sm-12">
      <div class="x_panel">
        <div class="x_title">
          <h2>Agregar producto nuevo</h2>
          <div class="clearfix"></div>
        </div>
        <div class="x_content">
          <?php foreach ($productosEdit as $item):?>
          <form class="" name="form" role="form" data-toggle="validator" action="../updateProductos" data-parsley-validate method="post" class="form-horizontal form-label-left" enctype="multipart/form-data">
            <div class="form-group">
                <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Cambiar imagen <span class="required">*</span></label>
                <div class="clearfix"></div>

                <div class="clearfix"></div>
                      <div class="form-group">
                        <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Imagen Actual</label>
                      </div>
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
                                 <label for="imagen" class="btn btn-success"><span class="fa fa-search"></span> Buscar<input type="file" name="imagen" id="imagen" value="" class="form-control col-md-7 col-xs-12"></label>
                            </div>
            </div>

            <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Nombre</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="nombre" value="<?php echo $item->nombre ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

            <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Texto</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="texto" value="<?php echo $item->texto ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

           <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Stock</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="stock" value="<?php echo $item->stock ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>



           <div class="clearfix"></div>
            <div class="form-group">
              <label for="" class="control-label col-md-3 col-sm-3 col-xs-12">Precio</label>
              <div class="clearfix"></div>
              <div class="col-md-6 col-sm-6 col-xs-12">
                <input type="text" name="precio" value="<?php echo $item->precio ?>" class="form-control col-md-7 col-xs-12" required="required">
              </div>
            </div>

            <div class="clearfix"></div>
            
            <input type="hidden" name="idProducto" value="<?php echo $item->idProducto ?>">
            <input type="hidden" name="imagenActual" value="<?php echo $item->urlImagen ?>">
            <br>
            <div class="col-md-6 col-sm-6 col-xs-12">
              <input type="Submit" name="btn" value="Guardar" class="btn btn-success ">
            </div>
          </form>
        <?php endforeach; ?>
        </div>
      </div>
    </div>
  </div>
</div>

<?php $this->load->view('eddy/template/footer'); ?>

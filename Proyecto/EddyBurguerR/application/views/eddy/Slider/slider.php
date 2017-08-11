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
          <h2>Elementos actuales en el slider</h2>
          <div class="clearfix"></div>
        </div>
        <div class="x_content">
          <a href="addSlider" class="btn btn-success"><span class="glyphicon glyphicon-plus"></span> Nuevo</a>
          <div class="row">
            <?php foreach ($slider as $item):?>
              <div class="col-md-55">
                <div class="thumbnail">
                  <div class="image view view-first">
                    <img style="width: 100%; display: block;" src="<?php echo base_url() ."". $item->urlImagen ?>" alt="image">
                    <div class="mask">
                      <p>Acciones</p>
                      <div class="tools tools-bottom">
                        <a href=""><i class="fa fa-link"></i></a>
                        <a href="sliderEdit/<?php echo $item->idImagen ?>"><i class="fa fa-pencil"></i></a>
                        <a href="sliderDelete/<?php echo $item->idImagen ?>"><i class="fa fa-times"></i></a>
                      </div>
                    </div>
                  </div>
                  <div class="caption">
                    <p><?php echo $item->texto ?></p>
                  </div>
                </div>
              </div>
        <?php endforeach; ?>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

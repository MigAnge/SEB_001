<div class="right_col" role="main" style="min-height: 3124px;">
          <div class="">
            <div class="page-title">
              <div class="title_left">
                <h3>Administrar galeria</h3>
              </div>
            </div>

            <div class="clearfix"></div>

            <div class="row">
              <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Imagenes mostradas en la sección galeria</h2>
                    <ul class="nav navbar-right panel_toolbox">
                      <li><a class="collapse-link"><i class="fa fa-chevron-up"></i></a></li>
                      <li><div><a href="addGaleria" class="btn btn-success" style="color: #fff">Agregar</a></div></li>
                    </ul>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">
                  <div id="datatable_wrapper" class="dataTables_wrapper form-inline dt-bootstrap no-footer">
                    <div class="row">
                        <div class="col-sm-12">
                          <table id="datatable" class="table table-striped table-bordered dataTable no-footer" role="grid" aria-describedby="datatable_info">
                            <tr role="row">
                              <th class="sorting" tabindex="0" aria-controls="datatable" rowspan="1" colspan="1" aria-sort="ascending" aria-label="Name: activate to sort column descending" style="width: 40px;">Imagen</th>
                              <th class="sorting" tabindex="0" aria-controls="datatable" rowspan="1" colspan="1" aria-label="Position: activate to sort column ascending" style="width: 50px;">Titulo Mostrado</th>
                              <th class="sorting" tabindex="0" aria-controls="datatable" rowspan="1" colspan="1" aria-label="Office: activate to sort column ascending" style="width: 190px;">Texto mostrado</th>
                              <th class="sorting" tabindex="0" aria-controls="datatable" rowspan="1" colspan="1" aria-label="Age: activate to sort column ascending" style="width: 5px;">Fecha de publicación</th>
                              <th class="sorting_asc" tabindex="0" aria-controls="datatable" rowspan="1" colspan="1" aria-label="Age: activate to sort column ascending" style="width: 5px;">Hora de publicación</th>
                              <th class="sorting" tabindex="0" aria-controls="datatable" rowspan="1" colspan="2" aria-label="Age: activate to sort column ascending" style="width: 6px;">Opciones</th>
                            </tr>
                              <?php foreach ($galeria as $item):?>
                            <tr role="row" class="odd">
                                <td style="width: 90px;"><img style="width: 100%" src="<?php echo base_url().$item->urlImagen ?>" alt=""></td>
                                <td style="width: 50px;"><?php echo $item->titulo ?></td>
                                <td><?php echo $item->texto ?></td>
                                <td style="width:5%"><?php echo $item->fecha ?></td>
                                <td style="width:5%"><?php echo $item->hora ?></td>
                                <td style="width:3%"><a href="galeriaEdit/<?php echo $item->idGaleria ?>" class="btn btn-dark"><span class="fa fa-edit"></span> editar</a></td>
                                <td style="width:3%"><a href="galeriaDelete/<?php echo $item->idGaleria ?>" class="btn btn-danger"><span class="fa fa-trash"></span> eliminar</a></td>
                            </tr>
                              <?php endforeach; ?>

                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

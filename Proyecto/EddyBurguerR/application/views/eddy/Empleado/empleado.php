<?php
/**
 * vista empleados
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/eddy/Empleado/empleado.php
 *@since File available since Release 0.0.1
*/
?>
<div class="right_col" role="main" style="min-height: 3124px;">
          <div class="">
            <div class="page-title">
              <div class="title_left">
                <h3>Administrar Empleados</h3>
              </div>
            </div>

            <div class="clearfix"></div>

            <div class="row">
              <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                  <div class="x_title">
                    <h2>Empleados registrados</h2>
                    <div class="clearfix"></div>
                  </div>
                  <div class="x_content">
                  <div id="datatable_wrapper" class="dataTables_wrapper form-inline dt-bootstrap no-footer">
                     <div class="row">
                        <div class="col-sm-12">
                          <?php echo $output; ?>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

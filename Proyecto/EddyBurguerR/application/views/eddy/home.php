<?php
/**
 * Pagina inicial del cpanel
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/eddy/home.php
 *@since File available since Release 0.0.1
*/

?>
<div class="right_col" role="main">
  <div class="row">
    <div class="col-xs-12 col-sm-12">
      <div class="page-title">
        <div class="title_left">
          <h3>Panel de control</h3>
        </div>
      </div>
    </div>
  </div>
  <div class="row">
  	<div class="col-xs-12 col-sm 12">
  		<div class="x_panel">
        	<div class="x_title">
          		<h2>¿Qué desea hacer?</h2>
          	<div class="clearfix"></div>
        </div>
        <div class="x_content">
        <div class="align">
        <div class="col-xs-12 col-sm-6">
        	<a href="<?php echo base_url() ?>index.php/Empleado/empleados" class="tama btn btn-success">
        		<span class="fa fa-users"></span>
        		Usuarios
        	</a>
        </div>
        <div class="col-xs-12 col-sm-6">
        	<a href="<?php echo base_url() ?>index.php/Slider/slider" class="tama btn btn-danger">
        		<span class="fa fa-desktop"></span>
        		Slider
        	</a>
        </div>
        <br>
        <div class="clearfix"></div>
        <br>
        <div class="col-xs-12 col-sm-6">
        	<a href="<?php echo base_url() ?>index.php/Productos/productos" class="tama btn btn-warning">
        		<span class="fa fa-shopping-basket"></span>
        		Tienda
        	</a>
        </div>
        <div class="col-xs-12 col-sm-6">
        	<a href="<?php echo base_url() ?>index.php/Noticias/noticias" class="tama btn btn-primary">
        		<span class="fa fa-newspaper-o"></span>
        		Ofertas
        	</a>
        </div>
        </div>
        </div>
  	</div>
  </div>
 </div>
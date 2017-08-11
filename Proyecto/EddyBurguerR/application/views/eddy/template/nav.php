<body class="nav-md">
  <div class="container body">
    <div class="main_container">
      <div class="col-md-3 left_col">
        <div class="left_col scroll-view">
          <div class="navbar nav_title" style="border: 0;">
            <a href="<?php echo base_url(); ?>index.php/Eddy/eddy"><i><img class="img-circle img-t" src="<?php echo base_url();?>/images/producto.jpg" alt=""></i> <span class="text-titleEddy">Eddy Burguer</span></a>
          </div>

          <div class="clearfix"></div>

          <!-- menu profile quick info -->
          <div class="profile">
            <div class="profile_pic">
              <img src="<?php echo base_url(); ?>images/contacto.jpg" alt="..." class="img-circle profile_img">
            </div>
            <div class="profile_info">
              <span>Bienvenido,</span>
              <h2><?php echo $this->session->userdata('name'); ?></h2>
            </div>
          </div>
          <!-- /menu profile quick info -->

          <br />
          <br />

          <!-- sidebar menu -->
          <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
            <div class="menu_section">
              <br>
              <h3>Acciones</h3>
              <ul class="nav side-menu">
                <li><a href="<?php echo base_url(); ?>index.php/Eddy/eddy" ><i class="fa fa-home"></i> Inicio </span></a></li>
                <li><a><i class="fa fa-desktop"></i> Ofertas y Slider <span class="fa fa-chevron-down"></span></a>
                  <ul class="nav child_menu">
                    <li><a href="<?php echo base_url() ?>index.php/Noticias/noticias"><i class="fa fa-newspaper-o"></i> Ofertas</a></li>
                    <li><a href="<?php echo base_url() ?>index.php/Slider/slider"><i class="fa fa-desktop" ></i> Slider</a></li>
                  </ul>
                </li>
                <li><a><i class="fa fa-shopping-bag"></i> Tienda <span class="fa fa-chevron-down"></a>
                  <ul class="nav child_menu">
                    <li><a href="<?php echo base_url() ?>index.php/Productos/productos"><i class="fa fa-shopping-basket"></i> Productos</a></li>
                    <li><a href="<?php echo base_url() ?>index.php/Pedido/pedido"><i class="fa fa-shopping-cart"></i> Pedidos</a></li>
                    <li><a href="<?php echo base_url() ?>index.php/Categoria/categoria"><i class="fa fa-list"></i> Categorías</a></li>
                    <li><a href="<?php echo base_url() ?>index.php/Marca/marcas"><i class="fa fa-bookmark"></i> Marcas</a></li>
                  </ul>
                </li>
                <li><a><i class="fa fa-users"></i> Usuarios <span class="fa fa-chevron-down"></a>
                  <ul class="nav child_menu">
                    <li><a href="<?php echo base_url() ?>index.php/Empleado/empleados"><i class="fa fa-user"></i> Empleados</a></li>
                    <li><a href="<?php echo base_url() ?>index.php/Cliente/cliente"><i class="fa fa-male"></i> Clientes</a></li>
                    <li><a href="<?php echo base_url() ?>index.php/Contacto/contacto"><i class="fa fa-comment"></i> Contacto</a></li>
                  </ul>
                </li>
                <br>
                <br>
                <li><a href="<?php echo base_url() ?>index.php/Welcome/logout"><i class="fa fa-sign-out"></i>Cerrar sesión</a></li>
              </ul>
             
            </div>

          </div>
          <!-- /sidebar menu -->


          
        </div>
      </div>

      <!-- top navigation -->
      <div class="top_nav">
        <div class="nav_menu">
          <nav class="" role="navigation">
            <div class="nav toggle">
              <a id="menu_toggle"><i class="fa fa-bars"></i></a>
            </div>
          </nav>
        </div>
      </div>
      <!-- /top navigation -->

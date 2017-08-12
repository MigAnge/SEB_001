<?php
/**
 * navbar de las paginas front-end
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/template/contacto.php
 *@since File available since Release 0.0.1
*/

?>
<body id="pageBody">

<div id="decorative2">
    <div class="container">

        <div class="divPanel topArea notop nobottom">
            <div class="row-fluid">
                <div class="span12">

                    <div id="divLogo" class="pull-left">
                        <a href="index.html" id="divSiteTitle">EDDY BURGUER</a><br />
                       <!-- <a href="index.html" id="divTagLine">Your Tag Line Here</a>-->
                    </div>

                    <div id="divMenuRight" class="pull-right">
                        <div class="navbar">
                            <button type="button" class="btn btn-navbar-highlight btn-large btn-primary" data-toggle="collapse" data-target=".nav-collapse">
                                NAVIGATION <span class="icon-chevron-down icon-white"></span>
                            </button>
                            <div class="nav-collapse collapse">
                                <ul class="nav nav-pills ddmenu">
                                    <li class="dropdown <?php if(isset($title)){if($title == 'EDDY BURGUER'){echo 'active';}}?>"><a href="<?php echo base_url();?>">Inicio</a></li>
                                    <li class="dropdown <?php if(isset($title)){if($title == 'filosofia' || $title == 'instalaciones'){echo 'active';}}?>">
                                        <a href="#">Acerca de<b class="caret"></b></a>
                                        <ul class="dropdown-menu">
                                            <li class="dropdown <?php if(isset($title)){if($title == 'filosofia'){echo 'active';}}?>"><a href="<?php echo base_url();?>index.php/Welcome/paginas/filosofia">Filosofía</a></li>
                                            <li class="dropdown <?php if(isset($title)){if($title == 'instalaciones'){echo 'active';}}?>"><a href="<?php echo base_url();?>index.php/Welcome/paginas/instalaciones">Instalaciones</a></li>
                                        </ul>
                                    </li>
                                   <li class="dropdown <?php if(isset($title)){if($title == 'productos'){echo 'active';}}?>"><a href="<?php echo base_url();?>index.php/Welcome/paginas/productos">Productos</a></li>
                                    <!--<li class="dropdown">
                                        <a href="page.html" class="dropdown-toggle">Page <b class="caret"></b></a>
                                        <ul class="dropdown-menu">
                                            <li><a href="full.html">Full Page</a></li>
                                            <li><a href="2-column.html">Two Column</a></li>
                                            <li><a href="3-column.html">Three Column</a></li>
                                            <li><a href="../documentation/index.html">Documentation</a></li>
                                            <li class="dropdown">
                                                <a href="#" class="dropdown-toggle">Dropdown Item &nbsp;&raquo;</a>
                                                <ul class="dropdown-menu sub-menu">
                                                    <li><a href="#">Dropdown Item</a></li>
                                                    <li><a href="#">Dropdown Item</a></li>
                                                    <li><a href="#">Dropdown Item</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>-->
                                    <li class="dropdown <?php if(isset($title)){if($title == 'galeria'){echo 'active';}}?>"><a href="<?php echo base_url();?>index.php/Welcome/paginas/galeria">Ofertas</a></li>
                                    <li class="dropdown <?php if(isset($title)){if($title == 'contacto'){echo 'active';}}?>"><a href="<?php echo base_url();?>index.php/Welcome/paginas/contacto">Contactanos</a></li>
                                    <!--<li class="dropdown <?php //if($title == 'noticias'){echo 'active';}?>"><a href="<?php //echo base_url();?>index.php/Welcome/paginas/noticias">Mi pedido</a></li>-->
                                
                                    <li class="dropdown <?php if($this->uri->segment(2)=="mycart"){echo 'active';}?>"><a href="<?php echo base_url();?>index.php/Productos/mycart"><span class="icon-shopping-cart"></span> Pedido</a></li>
                                   
                                    <li class="dropdown active">
                                        
                                        <?php if($this->session->userdata('name')){echo '<a><span class="icon-user"> </span>';}else{ ?> <a href="<?php echo base_url(); ?>index.php/Welcome/loginV"><span class="icon-signin"> </span><?php }?><?php if($this->session->userdata('name')){echo $this->session->userdata('name');}else{ echo "Login"; }?></a>
                                        <ul class="dropdown-menu">
                                        <?php if($this->session->userdata('name')){ ?>
                                        
                                            <li class="dropdown <?php if(isset($title) == 'filosofia'){echo 'active';}?>"><a href="<?php echo base_url();?>index.php/Cliente/cliente/edit/<?php echo $this->session->userdata('id');?>"><span class="icon-edit"></span>Editar mi información</a></li>
                                            <li class="dropdown <?php if(isset($title) == 'filosofia'){echo 'active';}?>"><a href="<?php echo base_url();?>index.php/Welcome/logout"><span class="icon-signout"></span>Cerrar sesión</a></li>
                                           
                                        <?php } ?>
                                         <?php if(!$this->session->userdata('name')){ ?>
                                            <li class="dropdown <?php if(isset($title) == 'filosofia'){echo 'active';}?>"><a href="<?php echo base_url();?>index.php/Cliente/cliente/add"><span class="icon-signout"></span>Registrar</a></li>
                                            <?php } ?>
                                        </ul>
                                    </li>
                                    
                                </ul>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>

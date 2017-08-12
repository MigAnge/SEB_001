<?php
/**
 * Vista para el formulario login
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/login.php
 *@since File available since Release 0.0.1
*/ 
 
 $this->load->view('template/header'); 
 $this->load->view('template/nav');
 ?>

 <div class="container">
    <div class="row-fluid">
        <div class="apan12">
            <h1 id="titulos">Iniciar sesión</h1>
        </div>
    </div>
</div>
<div class="container-fluid contac-fluid">

    <div class="divPanel page-content paralax">
        <div class="row-fluid contac-par">
            <div class="span12 paralax-text" id="divMain">
                <br>
                <div class="errors">
                <?php echo validation_errors(); ?>
                </div>
                    <?php 
                    
                    $par = array ("id" => "login");
                    echo form_open(base_url().'index.php/Welcome/login', $par);?>
                    <label for=""><h3 class="paralax-text">Correo electrónico</h3></label>
                    <input type="text" name="email" value="<?php echo set_value('email') ?>" class="form-control">
                    <br>
                    <label for=""><h3 class="paralax-text">Contraseña</h3></label>
                    <input type="password" value="<?php echo set_value('password') ?>" name="password" class="form-control">
                    <br>
                    <input type="submit" class="btn btn-success" value="Login">
                    <?php echo 
                    form_close(); ?>
                <br>    
            </div>
        </div>
    </div>
    </div>
<?php $this->load->view('template/footer'); ?>
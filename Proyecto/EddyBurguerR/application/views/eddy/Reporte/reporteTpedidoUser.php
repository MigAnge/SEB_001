<?php
/**
 * plantilla para reporte de todos los pedidos del usuario
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/eddy/Reporte/reporteTpedidoUser.php
 *@since File available since Release 0.0.1
*/

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <?php if(isset($css_files)){ foreach($css_files as $css): ?>
    <link type="text/css" rel="stylesheet" href="<?php echo $css; ?>">
<?php endforeach; }?>

<link href="<?php echo base_url(); ?>js/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="<?php echo base_url(); ?>js/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Icons -->
    <link href="<?php echo base_url(); ?>js/icons/general/stylesheets/general_foundicons.css" media="screen" rel="stylesheet" type="text/css" />
    <link href="<?php echo base_url(); ?>js/icons/social/stylesheets/social_foundicons.css" media="screen" rel="stylesheet" type="text/css" />
    <!--[if lt IE 8]>
    <link href="<?php echo base_url(); ?>js/icons/general/stylesheets/general_foundicons_ie7.css" media="screen" rel="stylesheet" type="text/css" />
    <link href="<?php echo base_url(); ?>js/icons/social/stylesheets/social_foundicons_ie7.css" media="screen" rel="stylesheet" type="text/css" />
    <![endif]-->
    <link rel="stylesheet" href="<?php echo base_url(); ?>js/fontawesome/css/font-awesome.min.css">
    <!--[if IE 7]>
    <link rel="stylesheet" href="<?php echo base_url(); ?>js/fontawesome/css/font-awesome-ie7.min.css">
    <![endif]-->

    <link href="<?php echo base_url(); ?>js/carousel/style.css" rel="stylesheet" type="text/css" />
    <link href="<?php echo base_url(); ?>js/camera/css/camera.css" rel="stylesheet" type="text/css" />
    <link href="<?php echo base_url(); ?>js/prettyphoto/css/prettyPhoto.css" rel="stylesheet" type="text/css" />

    <!--<link href="http://fonts.googleapis.com/css?family=Allura" rel="stylesheet" type="text/css">-->
    <!--<link href="http://fonts.googleapis.com/css?family=Aldrich" rel="stylesheet" type="text/css">-->
    <link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css">
    <link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet" type="text/css">
   <!-- <link href="http://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet" type="text/css">-->
    <!--<link href="http://fonts.googleapis.com/css?family=Palatino+Linotype" rel="stylesheet" type="text/css">  -->
   <!-- <link href="http://fonts.googleapis.com/css?family=Calligraffitti" rel="stylesheet" type="text/css">-->


<link href="<?php echo base_url(); ?>css/custom.css" rel="stylesheet" type="text/css" />
<style>
.pDiv{
    display: none;
}

.ftitle{
    display: none;
}

h1{
    text-align: center; 
    float: right;
}

body {
    padding-top: 0;
}

#productos_field_box > div#productos_display_as_box {
    float: none!important;
    width: 100%!important;
}

#productos_field_box > div#productos_input_box {
    float: none!important;
    width: 100%!important;
}

table{
    width: 100%!important;
}

#field-direccion{
    width: 70%;
}

label{
    font-size: 17px;
    text-align: center;
}

h2{
   text-align: center;
}

a{
    float: left;
}

td, th{
    text-align: center!important;
}

#total{
    text-align: right!important;
}


</style>
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Reporte </title>
</head>
<body>

                        
                       <!-- <a href="index.html" id="divTagLine">Your Tag Line Here</a>-->
<div class="container-fluid">
   <?php foreach($user as $us):?>                 
    <label><a href="index.html" id="divSiteTitle">EDDY BURGUER</a> <h1> Compras del cliente <?php echo $us->nombre ?> </h1></label>

    <hr style="width:100%">
    <h2>Información del cliente</h2>
    <label><strong>Nombre completo: </strong><?php echo $us->nombre.' '.$us->apellido_P.' '.$us->apellido_M ?></label>
    <br>
    <label><strong>Correo electrónico: </strong><?php echo $us->email ?></label>
<br>
    <label><strong>Dirección: </strong><?php echo $us->calle_dir .' #'. $us->no_dir.
                    ', '. $us->colonia . ', ' . $us->ciudad . ', ' . $us->estado ?></label>
    <br>
    <label><strong>C.P: </strong><?php echo $us->codigoPostal ?></label>
    <?php endforeach; ?>
    <br>
    <br>
<table class="table table-bordered">
    <tr style="background-color: #ff8c00; color:#FFFFFF">
        <th>Fecha de compra</th>
        <th>Estatus de la compra</th>
        <th>Total de la compra</th>
    </tr>
    <?php $totalPedidos = 0;
     foreach($pedidos as $ped):?>
        <tr>
            <td><?php echo $ped->fecha ?></td>
            <td><?php if($ped->estatus == 0){ 
                echo "en espera";
                }else if($ped->estatus == 2){ 
                    echo "enviado";
                    }else if($ped->estatus == 1){
                         echo "entregado";} ?></td>
            <td>$<?php echo $ped->total ?></td>
        </tr>
    <?php $totalPedidos = $totalPedidos + $ped->total; endforeach;?>
    <tr><td></td><td id="total"><strong>total comprado: </strong></td><td>$<?php echo $totalPedidos ?></td></tr>
</table>
</div>
    <?php if(isset($js_files)){
  foreach($js_files as $js): ?>
    <script src="<?php echo $js; ?>"></script>
<?php endforeach; }?>
</body>
</html>
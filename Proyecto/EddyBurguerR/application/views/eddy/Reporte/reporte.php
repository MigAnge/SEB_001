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


</style>
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Reporte </title>
</head>
<body>

                        <a href="index.html" id="divSiteTitle">EDDY BURGUER</a>
                       <!-- <a href="index.html" id="divTagLine">Your Tag Line Here</a>-->
                    
    <h1>Reporte de pedido</h1>
    
     <?php //Ejemplo aprenderaprogramar.com

        echo $output;



?>

    <?php if(isset($js_files)){
  foreach($js_files as $js): ?>
    <script src="<?php echo $js; ?>"></script>
<?php endforeach; }?>
</body>
</html>
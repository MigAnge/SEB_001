<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title><?php if(isset($title)){ echo $title;}else{ echo 'Editar mi información';} ?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="Html5TemplatesDreamweaver.com">
    <META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW"> <!-- Remove this Robots Meta Tag, to allow indexing of site -->

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
</head>

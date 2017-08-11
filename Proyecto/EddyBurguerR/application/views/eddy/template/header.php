<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <?php 

    if(isset($css_files)){ foreach($css_files as $css): ?>
    <link type="text/css" rel="stylesheet" href="<?php echo $css; ?>">
<?php endforeach; }?>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Eddy Burguer | Amin </title>
    
    <!-- Bootstrap -->
    <link href="<?php echo base_url(); ?>vendors/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="<?php echo base_url(); ?>vendors/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <!-- iCheck -->
    <link href="<?php echo base_url(); ?>vendors/iCheck/skins/flat/green.css" rel="stylesheet">
    <!-- bootstrap-progressbar -->
    <link href="<?php echo base_url(); ?>vendors/bootstrap-progressbar/css/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet">
    <!-- jVectorMap -->
    <link href="<?php echo base_url(); ?>css/admin/css/maps/jquery-jvectormap-2.0.3.css" rel="stylesheet"/>
    <!-- bootstrap-wysiwyg -->
  <link href="<?php echo base_url() ?>vendors/google-code-prettify/bin/prettify.min.css" rel="stylesheet">
  <!-- Select2 -->
  <link href="<?php echo base_url() ?>vendors/select2/dist/css/select2.min.css" rel="stylesheet">
  <!-- Switchery -->
  <link href="<?php echo base_url() ?>vendors/switchery/dist/switchery.min.css" rel="stylesheet">
  <!-- starrr -->
  <link href="<?php echo base_url() ?>vendors/starrr/dist/starrr.css" rel="stylesheet">
<?php if (isset($tables) && $tables==true): ?>
    <!--tablas-->
   <link href="<?php echo base_url(); ?>vendors/datatables.net-bs/css/dataTables.bootstrap.min.css" rel="stylesheet">
   <link href="<?php echo base_url(); ?>vendors/datatables.net-buttons-bs/css/buttons.bootstrap.min.css" rel="stylesheet">
   <link href="<?php echo base_url(); ?>vendors/datatables.net-fixedheader-bs/css/fixedHeader.bootstrap.min.css" rel="stylesheet">
   <link href="<?php echo base_url(); ?>vendors/datatables.net-responsive-bs/css/responsive.bootstrap.min.css" rel="stylesheet">
   <link href="<?php echo base_url(); ?>vendors/datatables.net-scroller-bs/css/scroller.bootstrap.min.css" rel="stylesheet">

    <!--tablas-->
<?php endif; ?>
<?php if (isset($uf) && $uf == true): ?>
  <!-- Dropzone.js -->
  <link href="<?php echo base_url() ?>vendors/dropzone/dist/min/dropzone.min.css" rel="stylesheet">
<?php endif;?>
    <!-- Custom Theme Style -->
<link href="<?php echo base_url(); ?>css/admin/css/style.css" rel="stylesheet">
    <link href="<?php echo base_url(); ?>build/css/custom.css" rel="stylesheet">


  </head>

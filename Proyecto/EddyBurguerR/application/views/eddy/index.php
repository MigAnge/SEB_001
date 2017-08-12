<?php
/**
 * genera la pagina principal del cpanel
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/eddy/index.php
 *@since File available since Release 0.0.1
*/

$this->load->view('eddy/template/header');
$this->load->view('eddy/template/nav');
$this->load->view('eddy/home');
$this->load->view('eddy/template/footer');

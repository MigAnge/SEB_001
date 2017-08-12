<?php
/**
 * Genera la vista de las paginas exceptuando el home
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/paginas.php
 *@since File available since Release 0.0.1
*/

$this->load->view('template/header');
$this->load->view('template/nav');
$this->load->view($pag);
$this->load->view('template/footer');
<?php
/**
 * Alternativa a la generacion de reportes
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/Report.php
 *@since File available since Release 0.0.1
*/


$texto = file_get_contents(base_url()."index.php/Reportes/reportePedido/edit/13");

echo $texto;
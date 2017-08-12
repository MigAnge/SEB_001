<?php
/**
 * carrousel de la seccion instalaciones y página principal
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/template/header.php
 *@since File available since Release 0.0.1
*/

?>
<br />

<div class="list_carousel responsive">
    <ul id="list_photos">
        <?php foreach ($imagenes as $item): ?>
        <li><a href="<?php echo base_url(); ?>images/instalaciones/<?php echo $item; ?>"><img src="<?php echo base_url(); ?>images/instalaciones/<?php echo $item; ?>" class="img-polaroid"></a></li>
        <?php endforeach; ?>
    </ul>
</div>

</br>
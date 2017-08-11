<br />

<div class="list_carousel responsive">
    <ul id="list_photos">
        <?php foreach ($imagenes as $item): ?>
        <li><a href="<?php echo base_url(); ?>images/instalaciones/<?php echo $item; ?>"><img src="<?php echo base_url(); ?>images/instalaciones/<?php echo $item; ?>" class="img-polaroid"></a></li>
        <?php endforeach; ?>
    </ul>
</div>

</br>
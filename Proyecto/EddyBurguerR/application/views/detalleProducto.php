<?php
/**
 * Se muestra el detalle del producto, seleccionado
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/detalleProducto.php
 *@since File available since Release 0.0.1
*/

?>

<?php 
$this->load->view('template/header');
$this->load->view('template/nav');
?>
<div class="container">
    <div class="divPanel page-content">
        <div class="row-fluid">
            <div class="span12">
                <h1 id="titulos">
                    Detalles del producto
                </h1>
            </div>
        </div>
        <?php foreach ($detalleProucto as $detalle) { ?>
        <div class="row-fluid">
            <div class="span2"></div>
            <div class="span4">
                <img src="<?php echo base_url() ?>/uploads/productos/<?php echo $detalle->urlImagen ?>" alt=""/>

            </div>
            <div class="span4">
                <h2><?php echo $detalle->nombre ?></h2>
                <span><label>$ <?php echo $detalle->precio; ?> 
                <?php echo form_open(base_url().'/index.php/Productos/addToCart'); ?> 
                <br>
                <input type="number" name="cantidad" value="1" min=1 max=<?php echo $detalle->stock ?>>
                <br>
                            <?php                            
                            echo form_hidden('uri', $this->uri->segment(4));
                            echo form_hidden('idProducto', $detalle->idProducto);?>
                            
                            <button type="submit" class="btn btn-primary">Lo quiero</button>
                           <?php echo form_close();
                           
                            ?>
                <label><a href="<?php  echo base_url().'/index.php/Welcome/paginas/productos'?>"> < Regresar a productos </a></label>
            </div>
            <div class="span2"></div>
        </div>
        <div class="row-fluid">
            <div class="span2"></div>
            <div class="span8">
                <h1>Más información</h1>
                <p><?php echo $detalle->descripcion ?></p>
            </div>
            <div class="span2"></div>
        </div>
        <?php } ?>
    </div>
</div>

<?php $this->load->view('template/footer'); ?>
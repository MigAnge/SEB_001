<?php
/**
 * Lista los productos disponibles
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/productos.php
 *@since File available since Release 0.1.0
*/



$agregado = $this->session->flashdata('agregado');
$destruido = $this->session->flashdata('destruido');
$productoEliminado = $this->session->flashdata('productoEliminado');


?>

<div class="container">

    <div class="divPanel page-content">

        <!--Edit Main Content Area here-->
        <div class="row-fluid">
                <h1 id="titulos">Productos</h1>
             
                        <?php $con= 0; 
                        
                        foreach ($productos as $item):
                        if($con == 0){?>
                        <div class="span2 ">
                            <label class="macs"for=""><input type="checkbox" name="" value="Tortas"> Tortas</label>
                            <label class="macs"for=""><input type="checkbox" name="" value="Refrescos"> Refrescos</label>
                            <label class="macs"for=""><input type="checkbox" name="" value="Otros"> Otros</label>
                        </div>
                    <?php $con = 1; 
                        }else{
                            if($con==1){ ?>
                       <div class="span2">  </div>
                  <?php     } 
                        } ?>   
                        <div class="span2"><img style="width:100%!important; height:140px!important" src="<?php echo base_url().'/uploads/productos/'.$item->urlImagen ?>" alt=""></div>
                        <div class="span2 mac">
                            <label><?php echo $item->nombre ?></label>
                            <label><?php echo $item->descripcion ?></label>
                            <label>$<?php echo $item->precio?>
                            <?php echo form_open(base_url().'/index.php/Productos/addToCart'); ?> 
                            <input type="hidden" name="cantidad" value="1" min=1>
                            <?php  
                            echo form_hidden('uri', $this->uri->segment(4));
                            echo form_hidden('idProducto', $item->idProducto);?>
                            
                            <button type="submit" class="btn btn-primary">Lo quiero</button>
                           <?php echo form_close();
                           
                            ?></label>
                            <label><a href="<?php echo base_url().'/index.php/Productos/detalleProducto/'.$item->idProducto ?>">más información ></a></label>
                        </div>
                   <?php
                    if($con==2){ ?>
        </div><br>
                   <?php $con=1; }else{
                      $con=$con+1;
                      }
                          endforeach; 
                          
                          ?>                
</div>
<div class="row-fluid">
    <div class="span12" style="text-align:center;">
        <?php echo $pagination; ?>
    </div>
</div>
        <div id="footerInnerSeparator"></div>
    </div>

</div>

<script src="<?php echo base_url(); ?>js/jquery.min.js" type="text/javascript"></script>
<script src="<?php echo base_url();?>js/wookmark/js/jquery.wookmark.js" type="text/javascript"></script>
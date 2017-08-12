<?php
/**
 * Muetra una galeria de ofertas
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/galeria.php
 *@since File available since Release 0.0.1
*/

?>
<div id="decorative1" style="position:relative">
<div class="container">

    <div class="divPanel page-content">

        <!--Edit Main Content Area here-->
        <div class="row-fluid">
            <div class="span12">

                <h1 id="titulos">Ofertas</h1>

                <!--<div id="mosaic" class="mosaic">

                    <img src="<?php echo base_url(); ?>carousal/ham3.jpg" alt="Sticky" title="Sticky"/>

                          <img src="<?php echo base_url(); ?>carousal/ins.jpg" alt="Sticky" title="Sticky"/>

                          <img src="<?php echo base_url(); ?>images/torta.jpg" alt="Sticky" title="Sticky"/>

                          <img src="<?php echo base_url(); ?>images/torta2.jpg" alt="Sticky" title="Sticky"/>

                          <img src="<?php echo base_url(); ?>images/torta3.jpg" alt="Sticky" title="Sticky"/>

                          <img src="<?php echo base_url(); ?>images/torta4.jpg" alt="Sticky" title="Sticky"/>

                          <img src="<?php echo base_url(); ?>carousal/ham1.jpg" alt="Sticky" title="Sticky"/>
                            
                          <img src="<?php echo base_url(); ?>carousal/ham2.jpg" alt="Sticky" title="Sticky"/>

                </div>-->
                <div style="width: 100%!important;">
                <?php
                    $c = 0;
                   foreach ($galeria as $item):
                    ?>
                    <div class="">
                        <div class="jumbotron galerias" style="background: url('<?php echo base_url().'uploads/galeria/'.$item->urlImagen ?>'); width: 100%!important; height: 309px; background-repeat: no-repeat!important;background-color: rgb(0, 0, 0)">
                         <div class="galeria-deg">
                                    <br><br>
                                    
                                        <h1 style="margin-left:25px; color: #fff; font-size: 60px!important; text-shadow: -2px -2px 1px #000;"><?php echo $item->titulo?></h1>
                                            <br>
                                            <p style="margin-left:25px; color: #fff; font-size: 20px!important; text-shadow: -2px -2px 1px #000"><?php echo $item->texto?></p>
                                            <p>
                                               <br>
                                                <a class="btn btn-primary btn-lg" style="margin-left:25px; font-size: 30px!important;" href="#" role="button"><?php echo $item->botonText?></a>
                                            </p>
                                                <br>
                                                <br>
                                     
                         </div>
                      </div>
                      </div>
                      <br>
                    <?php endforeach;?>
                    </div>
            </div>
        </div>
        <!--End Main Content Area here-->

        <div id="footerInnerSeparator"></div>
    </div>

</div>
    
</div>
<script src="<?php echo base_url(); ?>js/jquery.min.js" type="text/javascript"></script>
<script src="<?php echo base_url();?>js/wookmark/js/jquery.wookmark.js" type="text/javascript"></script>

<script src="<?php echo base_url(); ?>js/prettyphoto/js/jquery.prettyPhoto.js" type="text/javascript"></script>
<script type="text/javascript">$("a[rel^='prettyPhoto']").prettyPhoto({social_tools: false});$("a[rel^='prettyPhoto'] img").hover(function(){$(this).animate({opacity:0.7},300)},function(){$(this).animate({opacity:1},300)});</script>


<div id="about" class="section-padding">
        <div class="container">
            <div class="span12">
                <div class="page-title text-center">
                <center>
                    <h1>Noticias</h1>
                    <p>Noticias mas sobresalientes. </p>
                    <hr class="pg-titl-bdr-btm"></hr>
                    </center>
                </div>
                <div class="autoplay">
                <?php foreach ($noticias as $item) { ?>

                    <div class="col-md-2">
                        <div class="team-info">
                        <div class="container-fluid contac-fluid" style="background-color: #b34b02;"><br><br></div>
                             <center>
                                <h4><a href="#"><?php echo $item->titulo ?></a></h4>
                                <p class="marb-20"><p><span>Descripción : <?php echo $item->texto ?></span></p>
    
                             
                             <a href="<?php echo base_url().$item->urlImagen ?>" title="<?php echo $item->texto ?>" rel="prettyPhoto[gallery1]"><img src="<?php echo base_url().$item->urlImagen ?>" class="img-home" style="margin:20px 10px 25px;" alt="<?php echo $item->titulo ?>"</a></center>
                    </div>
                <?php } ?>
                </div>
            </div>
        </div>
    </div>


        <div id="footerInnerSeparator"></div>
    </div>

</div>
<script src="<?php echo base_url(); ?>js/jquery.min.js" type="text/javascript"></script>
<script src="<?php echo base_url();?>js/wookmark/js/jquery.wookmark.js" type="text/javascript"></script>

<script src="<?php echo base_url(); ?>js/prettyphoto/js/jquery.prettyPhoto.js" type="text/javascript"></script>
<script type="text/javascript">$("a[rel^='prettyPhoto']").prettyPhoto({social_tools: false});$("a[rel^='prettyPhoto'] img").hover(function(){$(this).animate({opacity:0.7},300)},function(){$(this).animate({opacity:1},300)});</script>





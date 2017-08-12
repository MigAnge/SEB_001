<?php
/**
 * slider de la pagina principal
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/template/cameraSlider.php
 *@since File available since Release 0.0.1
*/

?>
<div id="decorative1" style="position:relative">
    <div class="container-fluid">

        <div class="divPanel headerArea">
            <div class="row-fluid">


              <div id="myCarousel" class="carousel slide">
                    <div class="carousel-inner">

                  <?php
                    $c = 0;
                   foreach ($slider as $item):
                    $active = "active";
                    $c = $c+1;
                    ?>
                      <div class="item <?php if($c == 1): echo $active; endif?>">
                        <div class="jumbotron" style="background-image: url('<?php echo base_url().$item->urlImagen ?>'); width: 100%!important; height: 309px; background-repeat: no-repeat!important;">
                                   <div class="galeria-deg">
                                    <br><br>
                                    <br><br>
                                    <br><br>
                                    <br><br>
                                        <h1 style="margin-left:25px; color: #fff; font-size: 60px!important;"><?php echo $item->titulo?></h1>
                                            <br>
                                            <p style="margin-left:25px; color: #fff; font-size: 20px!important;"><?php echo $item->texto?></p>
                                            <p>
                                               <br>
                                                <a class="btn btn-primary btn-lg" style="margin-left:25px; font-size: 30px!important;" href="#" role="button"><?php echo $item->botonText?></a>
                                            </p>
                                                <br>
                                                <br>
                                </div>
                                </div>
                      </div>
                    <?php endforeach;?>
                    </div>
                    <a class="left carousel-control" href="#myCarousel" data-slide="prev">‹</a>
                    <a class="right carousel-control" href="#myCarousel" data-slide="next">›</a>
                  </div>


    </div>
    </div>
    </div>
    </div>
    <!-- /.carousel

    <div class="jumbotron" style="background-image: url(''); width: 100%!important; height: auto; background-repeat: no-repeat!important;">
                <br><br>
                <br><br>
                <br><br>
                <br><br>
                    <h1 style="margin-left:25px; color: #fff; font-size: 60px!important;">Somos EDDY BURGUER</h1>
                        <br>
                        <p style="margin-left:25px; color: #fff; font-size: 20px!important;">Conoce los productos que te ofrecemos</p>
                        <p>
                           <br>
                            <a class="btn btn-primary btn-lg" style="margin-left:25px; font-size: 30px!important;" href="#" role="button">Saber más</a>
                        </p>
                            <br>
                            <br>
            </div>



    -->

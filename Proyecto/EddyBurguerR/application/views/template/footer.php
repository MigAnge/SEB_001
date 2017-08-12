<?php
/**
 * Footer de las vistas front-end
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.1.0
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/template/footer.php
 *@since File available since Release 0.0.1
*/

?>
<div id="footerOuterSeparator"></div>

<div id="divFooter" class="footerArea">

    <div class="container">

        <div class="divPanel">

            <div class="row-fluid">
                <div class="span4" id="footerArea1">

                    <h3>Acerca de la compañia</h3>

                    <p>EDDY BURGUER empresa dedicada a la venta de comida rapida y productos de abarrotes.</p>

                   <!-- <p>
                        <a href="#" title="Terms of Use">Terms of Use</a><br />
                        <a href="#" title="Privacy Policy">Privacy Policy</a><br />
                        <a href="#" title="FAQ">FAQ</a><br />
                        <a href="#" title="Sitemap">Sitemap</a>
                    </p>-->

                </div>
                <div class="span4" id="footerArea2">
                    <br>
                    <br>
                    <ul id="contact-info">
                        <li>
                            <i class="general foundicon-phone icon"></i>
                            <span class="field">Teléfono:</span> <span class="colors-footer">417-106-6005</span>
                        </li>
                        <li>
                            <i class="general foundicon-mail icon"></i>
                            <span class="field">Email:</span> <a href="mailto:eddyburgueroficial@gmail.com" title="Email">eddyburgueroficial@gmail.com</a>
                        </li>
                    </ul>
                </div>
                <div class="span4" id="footerArea3">
                    <br>
                    <br>
                    <ul id="contact-info">
                        <li>
                            <i class="general foundicon-home icon" style="margin-bottom:50px"></i>
                            <span class="field">Dirección:</span><span class="colors-footer"> Avenida hidalgo esquina con Aquiles Serdan s/n zona centro cp 38600, Acámbaro, Guanajuato.</span>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="row-fluid">
                <div class="span8">
                    <p class="copyright colors-footer">
                        EDDY BURGUER © 2017.
                    </p>
                </div>
                <!--<div class="span4">
                    <p class="social_bookmarks">
                        <a href="#"><i class="social foundicon-facebook"></i> Facebook</a>
                        <a href=""><i class="social foundicon-twitter"></i> Twitter</a>
                        <a href="#"><i class="social foundicon-pinterest"></i> Pinterest</a>
                        <a href="#"><i class="social foundicon-rss"></i> Rss</a>
                    </p>
                </div>-->
            </div>

        </div>

    </div>

</div>

<script src="<?php echo base_url(); ?>js/jquery.min.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>js/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>js/default.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>js/jquery.mosaic.min.js" type="text/javascript"></script>



<script src="<?php echo base_url(); ?>js/llenarSelect.js"></script>
<script>
  $(function(){
    $('#mosaic').Mosaic({
      maxRowHeight:150,
      innerGap:20
    });
  });
</script>

<script src="<?php echo base_url(); ?>js/carousel/jquery.carouFredSel-6.2.0-packed.js" type="text/javascript"></script>
<script type="text/javascript">$('#list_photos').carouFredSel({ responsive: true, width: '100%', scroll: 2, items: {width: 320,visible: {min: 2, max: 6}} });</script>
<script src="<?php echo base_url(); ?>js/camera/scripts/camera.min.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>js/easing/jquery.easing.1.3.js" type="text/javascript"></script>
<script type="text/javascript">function startCamera() {$('#camera_wrap').camera({ fx: 'scrollLeft', time: 2000, loader: 'none', playPause: false, navigation: true, height: '65%', pagination: true });}$(function(){startCamera()});</script>
<script src="<?php echo base_url(); ?>js/parallax.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>js/log.js" type="text/javascript"></script>
<script src="<?php echo base_url(); ?>js/updateCartQty.js" type="text/javascript"></script>
<?php if(isset($js_files)){
  foreach($js_files as $js): ?>
    <script src="<?php echo $js; ?>"></script>
<?php endforeach; }?>
</body>
</html>

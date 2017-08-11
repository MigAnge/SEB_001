<script src="<?php echo base_url(); ?>email/validation.js" type="text/javascript"></script>

<div class="container">
    <div class="row-fluid">
        <div class="apan12">
            <h1 id="titulos">Contacto EDDY BURGUER</h1>
        </div>
    </div>
</div>

<div class="container-fluid contac-fluid">

    <div class="divPanel page-content paralax">
        <div class="row-fluid contac-par">
            <div class="span2"></div>
            <div class="span8" id="divMain">
                <br>
                <h3 class="paralax-text">En EDDY BURGUER nos interesa tu opinión, envianos tu comentario acerca de nuestro servicio, sitio web o alguna duda que tengas, con gusto te atenderemos.</h3>
                <br>
                <!--Start Contact form -->
                <div class="errors">
                <?php echo validation_errors(); ?>
                </div>
                <form name="enq" method="post" action="<?php echo base_url(); ?>index.php/Contacto/add" onsubmit="return validation();">
                    <fieldset>

                        <input type="text" name="name" id="name" value="<?php echo $this->session->userdata('fullName'); ?>"  class="input-block-level" placeholder="Nombre" readonly/>
                        <input type="text" name="email" id="email" value="<?php echo $this->session->userdata('email'); ?>" class="input-block-level" placeholder="Correo electrónico" readonly rquired="required"/>
                        <input type="hidden" name="iduser" value="<?php echo $this->session->userdata('email');?>">
                        <textarea rows="11" name="message" id="message" class="input-block-level" placeholder="Comentarios"></textarea>
                        <div class="actions">
                            <input type="submit" value="Enviar" name="submit" id="submitButton" class="btn btn-primary pull-right" title="Click para enviar el mensaje" />
                        </div>

                    </fieldset>
                </form>
                <!--End Contact form -->
            </div>
            <div class="span2"></div>
        </div>

        <div id="footerInnerSeparator"></div>
    </div>

</div>
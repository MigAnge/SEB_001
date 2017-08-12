<?php
/**
 * muestra información previa la registro del pedido
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/eddy/Productos/infoPedido.php
 *@since File available since Release 0.0.1
*/



if(!$this->session->userdata('login')){
 
 redirect(base_url().'index.php/Welcome/loginV','refresh');
 
}else{
$this->load->view('template/header');
$this->load->view('template/nav');
?>

<div class="container">
    <div class="divPanel page-content">
        <div class="row-fluid">
            <div class="span12">
            <h1 id="titulos">
                Mi pedido
            </h1>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span12">
                <?php 
                foreach($datosUsuario as $infoUser):
                $settings = array(
                    'class' => 'form-vertical'
                );
                echo form_open('', $settings);
                ?>
                    <br>
                    <label class="span2">Nombre:</label>
                    <input class="span4" type="text" value="<?php echo $infoUser->nombre ?>" readonly>
                    <br>
                    <label class="span2">Apellidos:</label>
                    <input class="span4" type="text" value="<?php echo $infoUser->apellido_P.' '. $infoUser->apellido_M ?>" readonly>
                    <br>
                    <label class="span2">Coreo electrónico;</label>
                    <input class="span4" type="email" value="<?php echo $infoUser->email ?>" readonly>  
                    <br>
                    <label class="span2">Dirección:</label>
                    <input type="text" class="span7" value="<?php echo $infoUser->calle_dir .' #'. $infoUser->no_dir.
                    ', '. $infoUser->colonia . ', ' . $infoUser->ciudad . ', ' . $infoUser->estado ?>" readonly>
                    <br>
                    <label class="span2">C.P:</label>
                    <input class="span2" type="text" value="<?php echo $infoUser->codigoPostal ?>" readonly>
                <?php echo 
                form_close();
                endforeach;
                ?>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span12">
                <h2 id="titulos">Productos</h2>
                 <?php 
                if($this->cart->contents()){ ?>
                <table class="table table-bordered" style="border-bottom:0;">
                    <tr style="background-color: #ff8c00; color:#FFFFFF">
                        <th>Imágen</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Cantidad</th>
                        <th>Precio</th>
                        <th>Subtotal</th>
                    </tr>
                    <tr>

                        <?php $carrito = $this->cart->contents(); 
                            foreach($carrito as $cart):
                        ?>
                            <td style="padding:0; width:11%;"><img style="width:100%; padding:0;" src="<?php echo base_url().'uploads/productos/'.$cart['urlImagen'] ?>" alt=""/></td>
                            <td style="width:18%;"><?php echo $cart['name'] ?></td>
                            <td style="width:50%;"><?php echo $cart['descripcion'] ?></td>
                            <td style="width:7%;">
                                <input type="hidden" id="rowid" name="roiwid" value="<?php echo $cart['rowid']; ?>">
                                <input id="cantidad" style="width:80%;" type="number" min=1 max=<?php echo $cart['stock'] ?> name="cantidad" value="<?php echo $cart['qty'] ?>">
                            </td>
                            <td style="width:7%;"><?php echo $cart['price'] ?></td>
                            <td id="subtotal" style="width:7%;"><?php echo $cart['subtotal'] ?></td>
                        </tr>
                        <?php endforeach;?>
                        <tr>
                            <td style="border-left:0;border-bottom:0;" colspan="4"></td>
                            <td style="border-bottom:1px solid #ddd;">Total</td>
                            <td id="total" style="border-bottom:1px solid #ddd;"><?php echo $this->cart->total() ?></td>
                        </tr>
                </table>
                  
                <div style="text-align: right;"><a class="btn btn-primary" onClick="mensaje()" href="<?php echo base_url().'/index.php/Pedido/insertPedido/';?>">Finalizar</a></div>
                <script>
                    function mensaje(){
                        alert('tu oedido se ha guardado, el prodúcto lo pagas al recivirlo');
                    }
                </script>
           <?php } ?>
            </div>
        </div>
    </div>
</div>

<?php $this->load->view('template/footer'); } ?>
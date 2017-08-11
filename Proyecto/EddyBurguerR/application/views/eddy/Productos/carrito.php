<?php


$agregado = $this->session->flashdata('agregado');
$destruido = $this->session->flashdata('destruido');
$productoEliminado = $this->session->flashdata('productoEliminado');

?>
<?php 
$this->load->view('template/header');
$this->load->view('template/nav');
?>
<div class="container">
    <div class="page-content divPanel">
        <div class="row-fluid">
            <div class="span12">
                <h1 id="titulos">Mi pedido</h1>
            </div>
        </div>
    </div>
    <div class="page-content divPanel">
        <div class="row-fluid">
            <div class="span12">
                <?php 
                if($this->cart->contents()){ ?>
                <table id="pedido" class="table table-bordered" style="border-bottom:0;">
                    <tr style="background-color: #ff8c00; color:#FFFFFF">
                        <th>Imágen</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Cantidad</th>
                        <th>Precio</th>
                        <th>Subtotal</th>
                        <th>Eliminar</th>
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
                            <td id="eliminar"><?= anchor('Productos/deleteCartItem/' . $cart['rowid'], '<span class="btn btn-danger"><span style="color: #fff;" class="icon-remove"></span></span>') ?></td>
                        </tr>
                        <?php endforeach;?>
                        <tr>
                            <td style="border-left:0;border-bottom:0;" colspan="4"></td>
                            <td style="border-bottom:1px solid #ddd;">Total</td>
                            <td id="total" style="border-bottom:1px solid #ddd;"><?php echo $this->cart->total() ?></td>
                            <td style="border-bottom:1px solid #ddd;" id="eliminarCarrito"><?= anchor('Productos/destroyCart', '<span class="btn btn-danger"><span style="color: #fff;" class="icon-trash"></span></span>') ?></td>
                        </tr>
                </table>
                  
                <div style="text-align: right;"><a class="btn btn-primary" href="<?php echo base_url().'/index.php/Productos/info/'.$this->session->userdata('id');?>">Finalizar</a></div>
           <?php } ?>
           </div>
        </div>
    </div>
</div>


<?php $this->load->view('template/footer'); ?>
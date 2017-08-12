<?php
/**
*Clase Reportes
*Esta clase extiende de CI_Controler, y funciona como controlaor para la creacion de reportes
*Se hace uso de la libreria mPDF creada por Ian Back <ianb@bpm1.com> 
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version  0.1.0
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/controllers/Reportes.php
*@author Alejandro Onofre Cornejo
*@since Class available since Release 0.1.0
*@deprecated Class deprecated in Release 2.0.0
*/

defined('BASEPATH') OR exit('No direct script access allowed');

class Reportes extends CI_Controller{
private $id;
  public function __construct(){
    parent::__construct();
    $this->load->library('cart');
    $this->load->library('Grocery_CRUD');
    $this->load->model('Pedidom');
    $this->load->model('Usuariosm');
    $this->load->model('Productosm');
    $this->load->library('M_pdf');
  }

function report($idP){
    $id = $this->Pedidom->getIdUser($idP);
    $user = $this->Usuariosm->getUserdataToCart($id);
    $pedidos = $this->Pedidom->pedidosUser($id);
    $data['user'] = $user;
    $data['pedidos'] = $pedidos;

    $this->load->view('eddy/Reporte/reporteTpedidoUser', $data);
}
 

  function descargar($type, $id){

      $data = [];
      if($type == "pedido"){
        $html = file_get_contents(base_url()."index.php/Reportes/reportePedido/edit/".$id);
      }

      if($type == "todos"){
        $html = file_get_contents(base_url()."index.php/Reportes/report/".$id);
      }
      $hoy = date("dmyhis");

      $pdfFilepath = "eddyburguerR*".$hoy.".pdf";

      $this->load->library('M_pdf');
        $mpdf = new mPDF('c', 'A4-L'); 
 		$mpdf->WriteHTML($html);
		$mpdf->Output($pdfFilePath, "I");

        
  }

    function reportePedido($idPedido){
      $pedido = new grocery_CRUD();
      $pedido->set_table('pedidos');
      $pedido->unset_read();
      $pedido->set_subject('Reporte de pedido');
      $pedido->unset_add();
      $pedido->unset_delete();
      $pedido->unset_delete();
      $pedido->unset_back_to_list();
      $pedido->add_action('Imprimir reporte', base_url().'assets/grocery_crud/themes/flexigrid/css/images/print.png', base_url().'/index.php/Reportes/reportePedido/', 'print-icon');

      $pedido->callback_column('estatus', array($this, 'columnas'));

      $pedido->fields('fecha', 'estatus', 'informaciondelcliente', 'productos');
      $pedido->columns(array('fecha','total','estatus','Cliente_idCliente'));
      
      $pedido->field_type('fecha', 'readonly');

      $pedido->display_as('codigopostal', 'C.P');
      $pedido->display_as('Cliente_idCliente', 'Cliente');
      $pedido->display_as('nombrecliente', 'Nombre del cliente');
      $pedido->display_as('informaciondelcliente', 'Información del cliente');

      $pedido->set_relation('Cliente_idCliente', 'cliente', 'nombre');

      $pedido->callback_edit_field('estatus', array($this, 'estatusSelect'));

      $pedido->callback_edit_field('informaciondelcliente', array($this, 'infoUser'));

       $pedido->callback_edit_field('productos', array($this, 'tableDetalle'));

      $pedido->set_language('spanish');

      $pedido->callback_update(array($this, 'updateS'));

      $output_pedido = $pedido->render();

      $this->_example_output($output_pedido);
  }

  function _example_output($output_pedido){
      $this->session->set_flashdata('c', 1);
      
      $this->load->view('eddy/Reporte/reporte', $output_pedido);
  }

    function estatusSelect($primary_key){
        $estatus = $this->Pedidom->getEstatus($this->uri->segment(4));
        $select = '<select id="field-Estatus" name="estatus" class="misel" data-placeholder="Seleccionar Colonia">';
        foreach($estatus as $est){
            if($est->estatus == 0){
                $select = $select . '<option value="0" selected = "selected">en espera</option>
            <option value="2">enviado</option>
            <option value="1">entregado</option>';
            }else if($est->estatus == 2){
                $select = $select . '<option value="0">en espera</option>
            <option value="2" selected = "selected" >enviado</option>
            <option value="1">entregado</option>';
            }else if($est->estatus == 1){
                $select = $select . '<option value="0">en espera</option>
            <option value="2" >enviado</option>
            <option value="1" selected = "selected">entregado</option>';
            }
            
        
        }

        $select = $select . '</select>';
        return $select;
    }

    function columnas($value, $row){
        if($value==0){
            return 'en espera';
        }else if($value==2){
            return 'enviado';
        }else if($value==1){
            return 'entregado';
        }
    }



  function tableDetalle($primary_key){
      $infoDetalle = $this->Pedidom->getIdsProdDetalle($this->uri->segment(4));
      $tabla = '<br><hr><br><table class="table table-bordered" style="border-bottom:0;">
                    <tr style="background-color: #ff8c00; color:#FFFFFF">
                        <th>Imágen</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Cantidad</th>
                        <th>Precio</th>
                        <th>Subtotal</th>
                    </tr>';
       $ids[]=array();
       $cantidad[]=array();
       $subtotal[]=array();
       $total[]=array();
       $count = 0;
    foreach($infoDetalle as $row){
        $ids[$count] = $row->Producto_idProducto;
        $cantidad[$count] = $row->cantidad;
        $subtotal[$count] = $row->subtotal;
        $total[$count] = $row->total;
        $count++;
    }
      $productos = $this->Productosm->getProdDetalles($ids);
      $count = 0;
for($i = 0; $i < count($productos); $i++){
      foreach($productos[$i] as $item){
          $urlImg = base_url().'uploads/productos/'.$item->urlImagen;
            $tabla = $tabla . '<tr>
                            <td style="padding:0; width:7%;"><img style="width:15%; padding:0;" src="'.$urlImg.'" alt=""/></td>
                            <td style="width:20%;">'.$item->nombre.'</td>
                            <td style="width:52%;">'.$item->descripcion.'</td>
                            <td style="width:7%;">'.$cantidad[$count].'</td>
                            <td style="width:7%;">$'.$item->precio.'</td>
                            <td id="subtotal" style="width:7%;">$'.$subtotal[$count].'</td>
                        </tr>';
                        $count++;
      }
}
      $tabla = $tabla . '<tr>
                            <td style="border-left:0;border-bottom:0;" colspan="4"></td>
                            <td style="border-bottom:1px solid #ddd;">Total</td>
                            <td id="total" style="border-bottom:1px solid #ddd;">$'.$total[0].'</td>
                        </tr>
                </table>';

                return $tabla;
  }

  function infoUser(){
      $id = $this->Pedidom->getIdUser($this->uri->segment(4));
      $getUgetUserdata = $this->Usuariosm->getUserdataToCart($id);
      $nombre = "";
      $email = "";
      $direccion = "";
      $cp = "";
      foreach($getUgetUserdata as $infoUser){
          $nombre = '<field>Nombre del cliente</field><input id="field-cliente" class="form-control" type="text" name="cliente" value="'. $infoUser->nombre.' '.$infoUser->apellido_P.' '.$infoUser->apellido_M.'" readonly/>';
        $email = '<field>Correo electrónico</field><input id="field-email" class="form-control" type="text" name="email" value="'.$infoUser->email.'" readonly/>';
        $direccion = '<field>Dirección</field><input id="field-direccion" class="form-control" type="text" name="direccion" value="'.
          $infoUser->calle_dir .' #'. $infoUser->no_dir.
                    ', '. $infoUser->colonia . ', ' . $infoUser->ciudad . ', ' . $infoUser->estado.'" readonly/>';
        
        $cp ='<field>C.P</field><input id="field-codigopostal" class="form-control" type="text" name="codigopostal" value="'.$infoUser->codigoPostal.'" readonly />';
      }

      return $nombre.'<br><br>'.$email.'<br><br>'.$direccion.'<br><br>'.$cp;
  }

    function updateS($post_array, $primary_key){
        $object[]=array();
        if (!empty($post_array['estatus'])){
            $object = array(
                'estatus' => $post_array['estatus'],
            );
        }
        
        return $this->db->update('pedidos', $object, array('idPedidos' => $primary_key,));
        ;
    }


    function insertPedido(){
        $date = getdate();
        $fecha = $date['year']."-".$date['mon']."-".$date['mday'];
        $carrito = $this->cart->contents();
        $idProducto;
        $cantidad;
        $precio;
        $subtotal; 
        $count=0;
        foreach($carrito as $cart){
            $idProducto[$count] = $cart['id'];
            $cantidad[$count] = $cart['qty'];
            $precio[$count] = $cart['price'];
            $subtotal[$count] = $cart['subtotal'];
            $count++;
        }

            $success = $this->Pedidom->insertPedido($fecha, $this->cart->total(), 0, $this->session->userdata('id'), $idProducto, $cantidad, $precio, $subtotal);
            
            redirect(base_url().'/index.php/Productos/destroyCart','refresh');
            
    }
}
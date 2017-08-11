<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Productos extends CI_Controller{

  public function __construct(){
    parent::__construct();
    $this->load->model('Productosm');
    $this->load->model('Usuariosm');
    $this->load->library('cart');
    $this->load->library('Grocery_CRUD');
  }

  function productos(){
    $producto_crud = new grocery_CRUD();
    $producto_crud->set_table('producto');

//campos requeridos
    $producto_crud->required_fields('urlImagen','nombre','precio','stock','Categoria_idCategoria','Marca_idMarca');
    $producto_crud->columns('urlImagen','nombre','precio','stock','Categoria_idCategoria');

    //renombrar campos
    $producto_crud->display_as('urlImagen', 'Imágen a mostrar');
    $producto_crud->display_as('nombre', 'Nombre');
    $producto_crud->display_as('descripción', 'Descripción');
    $producto_crud->display_as('precio', 'Precio');
    $producto_crud->display_as('stock', 'Cantidad');
    $producto_crud->display_as('Categoria_idCategoria', 'Categoría');
    $producto_crud->display_as('Marca_idMarca', 'Marca');

    $producto_crud->set_rules('nombre', 'nombre', 'trim|max_length[150]|min_length[5]');
    $producto_crud->set_rules('descripcion', 'descripción', 'trim|max_length[300]|min_length[5]');
    $producto_crud->set_rules('precio', 'precio', 'trim|max_length[300]|min_length[5]');
    $producto_crud->set_rules('stock', 'stock', 'trim|max_length[300]|min_length[5]');
    $producto_crud->set_rules('Categoria_idCategoria', 'Categoria', 'trim|required');
    $producto_crud->set_rules('Marca:idMarca', 'Marca', 'trim|required');

    //tipo de elemento
    $producto_crud->field_type('precio','integer');
    $producto_crud->field_type('stock','integer');
    $producto_crud->field_type('descripcion','text');
    $producto_crud->unset_texteditor('descripcion');

    //vincular tablas
    $producto_crud->set_language('spanish');

    //relacionar tablas
    $producto_crud->set_relation('Categoria_idCategoria', 'categoria', 'nombre');
    $producto_crud->set_relation('Marca_idMarca', 'marca', 'nombre');

    //uso de imagenes
    $producto_crud->set_field_upload('urlImagen', 'uploads/productos', 'jpg','png','jpeg');

    $output_producto = $producto_crud->render();

    $this->_example_output($output_producto);
  }

  public function _example_output($output_producto){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
        $this->load->view('eddy/Productos/index', $output_producto);
   }else{
        redirect(base_url(),'refresh');
    } 
  }

  function detalleProducto($idProducto){
    $data['detalleProucto'] = $this->Productosm->productoDetalle($idProducto);
    $data['title']= "Detalle de producto";
	  $data['pag']= "detalle de producto";
    $this->load->view("detalleProducto", $data);
  }
/*
  function addProductos(){
    $data['uf'] = true;
    $this->load->view('eddy/Productos/addProductos', $data);
  }

  function saveProductos(){
    $data['upload_path'] = 'uploads/productos/';
    $data['allowed_types'] = 'gif|jpg|png|jpeg';

    $this->load->library('upload', $data);

    if(!$this->upload->do_upload("imagen")){
      $data['error'] = $this->upload->display_errors();
      $this->load->view('eddy/Productos/addProductos', $data);
    }else{
      $file_info = $this->upload->data();
      $imagen = $data['upload_path'].$file_info['file_name'];
      $nombre = $this->input->post('nombre');
      $texto = $this->input->post('texto');
      $stock = $this->input->post('stock');
      $precio = $this->input->post('precio');
      $this->Productosm->saveProductos($imagen, $nombre, $texto, $stock, $precio);
      redirect('Productos/productos');
    }
  }*/

  function addToCart(){
    $idProducto = $this->input->post('idProducto');
    $uri = $this->input->post('uri');
    $prod = $this->Productosm->productosEditCart($idProducto);
      $cantidad = $this->input->post('cantidad');
    $carrito = $this->cart->contents();
    
    foreach($prod as $producto){
    $data = array(
      'id' => $idProducto,
      'name' => $producto->nombre,
      'price' => $producto->precio,
      'qty' => $cantidad,
      'stock' => $producto->stock,
      'urlImagen' => $producto->urlImagen,
      'descripcion' => $producto->descripcion,
    );
    }

//agrega producto al carrito
    
    $this->cart->insert($data);

    $this->session->set_flashdata('agregado', 'Agregado');
    
    redirect('../index.php/Welcome/paginas/productos/'.$uri,'refresh');
    
  }

  function updateCartStock(){
    $rowid = $this->input->post('rowid');
    $cantidad = $this->input->post('cantidad');
    $data = array(
      'rowid' => $rowid,
      'qty' => $cantidad,
    );

    if($this->cart->update($data)){
      echo 'Actualizado';
    }else{
      echo 'error';
    }
  }

  function deleteCartItem($rowid){
    $data = array(
      'rowid' => $rowid,
      'qty' => 0
    );

    $this->cart->update($data);
    $this->session->set_flashdata('productoEliminado', 'Productoeliminado');
    redirect(base_url().'/index.php/Productos/mycart','refresh');
    
  }

  function destroyCart(){
    $this->cart->destroy();
    $this->session->set_flashdata('destruido', 'Carrito eliminado');
    
    redirect(base_url().'/index.php/Welcome/paginas/productos','refresh');
    
  }

  function myCart(){
    $data['title']= "Mi pedido";
	  $data['pag']= "Mi pedido";
    $this->load->view('eddy/Productos/carrito', $data);
  }

  function info($idCliente){
    $datosUsuario = $this->Usuariosm->getUserdataToCart($idCliente);
    $data['title']= "Comprobar información";
	  $data['pag']= "Comprobar información";
    $data['datosUsuario'] = $datosUsuario;
    if(!$this->session->userdata('name')){
      redirect(base_url().'index.php/Welcome/loginV','refresh');
    }
    $this->load->view("eddy/Productos/infoPedido",$data);
  }

  function productosEdit($idProducto){
    $data['productosEdit'] = $this->Productosm->productosEdit($idProducto);
    $data['uf'] = true;
    $this->load->view('eddy/Productos/productosEdit', $data);
  }

  function updateProductos(){
    $imagen =$_FILES['imagen']['type'];

    if($imagen != null){
      $data['upload_path'] = 'uploads/productos/';
      $data['allowed_types'] = 'gif|jpg|png|jpeg';

      $this->load->library('upload', $data);

      if(!$this->upload->do_upload("imagen")){
        $data['error'] = $this->upload->display_errors();
        $this->load->view('eddy/Productos/productos', $data);
      }else{
        $file_info = $this->upload->data();
        $imagen = $data['upload_path'].$file_info['file_name'];
        $idProducto = $this->input->post('idProducto');
        $nombre = $this->input->post('nombre');
        $texto = $this->input->post('texto');
        $stock = $this->input->post('stock');
        $precio = $this->input->post('precio');

        $imagenActual = $this->input->post('imagenActual');
        unlink($imagenActual);
        $this->Productosm->updateProductos($idProducto, $imagen, $nombre, $texto, $stock, $precio);
        redirect('Productos/productos');
      }
    }else{
      $imagen = "";
      $idProducto = $this->input->post('idProducto');
      $nombre = $this->input->post('nombre');
      $texto = $this->input->post('texto');
      $stock = $this->input->post('stock');
      $precio = $this->input->post('precio');
      $this->Productosm->updateProductos($idProducto, $imagen, $nombre, $texto, $stock, $precio);
    redirect('Productos/productos');
    }
  }

  function productosDelete($idProducto){
    $this->Productosm->productosDelete($idProducto);
    redirect('Productos/productos');
  }

}

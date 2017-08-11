<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Productosm extends CI_Model {
  public function __construct(){
    parent::__construct();
  }

  public function productosSelect(){
    $sql = $this->db->get('producto');
    return $sql->result();
  }

  public function productosSelectRows(){
    $sql = $this->db->query("SELECT count(*) as number FROM producto")->row()->number;
    return intval($sql);
  }

  //listar front-end, para hacer la paginación.
   public function productosSelectpag($no_prod, $pag){
    $sql = $this->db->get('producto', $no_prod, $pag);
    if($sql->num_rows() > 0){
      foreach($sql->result() as $fila):
        $data[] = $fila;
      endforeach;
    }
    return $data;
  }

  public function saveProductos($imagen, $nombre, $descripcion, $stock, $precio){
    $data = array(
      'urlImagen' => $imagen,
      'nombre' => $nombre,
      'descripcion' => $descripcion,
     'stock' => $stock,
     'precio' => $precio,

    );

    $this->db->insert('producto', $data);
  }

  public function productoDetalle($idProducto){
    $this->db->where('idProducto', $idProducto);
    $sql = $this->db->get('producto');
    return $sql->result();
  }

  public function productosEditCart($idProducto){
    $this->db->where('idProducto', $idProducto);
    $productos = $this->db->get('producto');
   // foreach  as $producto){
     //   $data[]=$producto;
    //}
    return $productos->result();
  }

  public function updateProductos($idProducto, $imagen, $nombre, $descripcion, $stock, $precio){
    $this->db->where('idProducto', $idProducto);
    if($imagen != ""){
      $data = array(
        'urlImagen' => $imagen,
      'nombre' => $nombre,
      'descripcion' => $descripcion,
     'stock' => $stock,
     'precio' => $precio,
    );
    }else{
      $data = array(
        //'urlImagen' => $imagen,
      'nombre' => $nombre,
      'descripcion' => $descripcion,
      'stock' => $stock,
     'precio' => $precio,
      );
    }
    $this->db->update('producto', $data);
  }

  public function productosDelete($idProducto){
    $this->db->where('idProducto', $idProducto);
    $this->db->select('urlImagen');
    $sql = $this->db->get('producto');
    $sql = $sql->result();
    foreach ($sql as $di):
      unlink($di->urlImagen);
    endforeach;
    $this->db->where('idProducto', $idProducto);
    $this->db->delete('producto');
  }

  function getProdDetalles($ids){
    $data[]=array();
    for($i = 0; $i < count($ids); $i++){
      $this->db->select('nombre, urlImagen, precio, descripcion');
      $this->db->from('producto');
      $this->db->where('idProducto', $ids[$i]);
      $sql = $this->db->get();
      $data[$i] = $sql->result();
    } 
    return $data;  
  }
}

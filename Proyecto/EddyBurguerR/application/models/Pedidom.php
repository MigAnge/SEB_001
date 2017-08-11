<?php
/**
*Clase Pedidom
*Esta clase extiende de CI_Model, y funciona como modelo para las vistas back-end pertenecientes a la gestión
*de pedidos.
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version 0.1
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/models/Pedidom.php
*@author Alejandro Onofre Cornejo
*@since 0.1
*/

defined('BASEPATH') OR exit('No direct script access allowed');
class Pedidom extends CI_Model {
  public function __construct(){
    parent::__construct();
  }

  function insertPedido($fecha, $total, $status, $idCliente, $idProducto, $cantidad, $precio, $subtotal){
    $data = array(
        'fecha' => $fecha,
        'total' => $total,
        'estatus' => $status,
        'Cliente_idCliente' => $idCliente
    );
    $sql = $this->db->insert('pedidos', $data);
    $idPedido = $this->db->insert_id();
    $this->insertDetalle($idProducto, $cantidad, $precio, $subtotal, $idPedido);
  }

  function insertDetalle($idProducto, $cantidad, $precio, $subtotal, $idPedido){
    for($i = 0; $i < count($cantidad); $i++){
        $data = array(
            'Producto_idProducto' => $idProducto[$i],
            'cantidad' => $cantidad[$i],
            'precio' => $precio[$i],
            'subtotal' => $subtotal[$i],
            'Pedidos_idPedidos' => $idPedido
        );
        $this->db->insert('detallepedido', $data); 
    }
    $this->updateStock($idProducto, $cantidad);
  }

  function updateStock($idProducto, $menos){
      for($i = 0; $i < count($idProducto); $i++){
          $this->db->select('stock');
          $this->db->from('producto');
          $this->db->where('idProducto', $idProducto[$i]);
          $stock = $this->db->get();
          $stock = $stock->result();
            foreach($stock as $st){
                $stock = $st->stock;
            }
        $data = array(
            'stock' => $stock-$menos[$i],
        );
        $this->db->where('idProducto', $idProducto[$i]);
        $this->db->update('producto', $data);
      }
  }

  function getIdsProdDetalle($idPedido){
      $this->db->select('Producto_idProducto, cantidad, subtotal, total');
      $this->db->from('detallepedido');
      $this->db->join('pedidos', 'pedidos.idPedidos = detallepedido.Pedidos_idPedidos', 'left');
      $this->db->where('Pedidos_idPedidos', $idPedido);
      $sql = $this->db->get();
      return $sql->result();
  }

  function getEstatus($idPedido){
      $this->db->select('estatus');
      $this->db->where('idPedidos', $idPedido);
      $sql = $this->db->get('pedidos');
      return $sql->result();
  }

  function getIdUser($idPedido){
      $this->db->select('Cliente_idCliente');
      $this->db->from('pedidos');
      $this->db->where('idPedidos', $idPedido);
      $sql = $this->db->get();
      foreach($sql->result() as $id){
          $sql = $id->Cliente_idCliente;
      }
      return $sql;
  }

  function pedidosUser($idUser){
      $this->db->select('*');
      $this->db->from('pedidos');
      $this->db->where('Cliente_idCliente', $idUser);
      $sql = $this->db->get();
      return $sql->result();
  }
}
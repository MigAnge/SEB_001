<?php
/**
*Clase Contactom
*Esta clase extiende de CI_Model, y funciona como modelo para las vistas back-end pertenecientes a la gestión
*de comentarios.
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version 0.1
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/models/Contactom.php
*@author Alejandro Onofre Cornejo
*@since 0.1
*/

defined('BASEPATH') OR exit('No direct script access allowed');
class Contactom extends CI_Model {
  public function __construct(){
    parent::__construct();
  }

  function add($nombre, $email, $comentario){
      $data = array(
          'nombre' => $nombre,
          'email' => $email,
          'comentario' => $comentario
      );
      $this->db->insert('contacto', $data);
      
      redirect(base_url(),'refresh');
      
  }
}
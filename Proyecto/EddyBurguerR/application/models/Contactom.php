<?php

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
<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Sliderm extends CI_Model {
    public function __construct(){
      parent::__construct();
    }

    public function sliderList(){
      $sql = $this->db->get('slider');
      return $sql->result();
    }

    public function saveSlider($imagen, $texto, $titulo, $user, $boton){
      $data = array(
        'urlImagen' => $imagen,
        'texto' => $texto,
        'titulo' => $titulo,
        'botonText' => $boton,
        'Empleado_idEmpleado' => $user
      );
      $this->db->insert('slider', $data);
    }

    public function sliderEdit($idImagen){
      $this->db->where('idImagen', $idImagen);
      $sql = $this->db->get('slider');
      return $sql->result();
    }

    public function updateSlider($idImagen, $imagen, $texto, $titulo, $user, $boton){
      $this->db->where('idImagen', $idImagen);
      if ($imagen != ""):
          $data = array(
            'urlImagen' => $imagen,
            'texto' => $texto,
            'titulo' => $titulo,
            'botonText' => $boton,
          'Empleado_idEmpleado' => $user
          );
      else:
        $data = array(
          'texto' => $texto,
          'titulo' => $titulo,
        'botonText' => $boton,
        'Empleado_idEmpleado' => $user
        );
      endif;
      $this->db->update('slider', $data);
    }

    public function sliderDelete($idImagen){
      $this->db->where('idImagen', $idImagen);
      $this->db->select('urlImagen');
      $sql = $this->db->get('slider');
      $sql = $sql->result();
      foreach ($sql as $di):
        unlink($di->urlImagen);
      endforeach;
      $this->db->where('idImagen', $idImagen);
      $this->db->delete('slider');
    }
}

<?php
/**
*Clase Slider
*Esta clase extiende de CI_Model, y funciona como modelo para las vistas back-end pertenecientes a la gestión
*del slider.
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version  0.1.0
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/models/Sliderm.php
*@author Alejandro Onofre Cornejo
*@since Class available since Release 0.1.0
*@deprecated Class deprecated in Release 2.0.0
*/

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

<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Galeriam extends CI_Model {
  public function __construct(){
    parent::__construct();
  }

  public function galeriaSelect(){
    $sql = $this->db->get('ofertas');
    return $sql->result();
  }

  public function saveGaleria($imagen, $titulo, $texto, $fecha, $hora){
    $data = array(
      'urlImagen' => $imagen,
      'titulo' => $titulo,
      'texto' => $texto,
      'fecha' => $fecha,
      'hora' => $hora
    );

    $this->db->insert('ofertas', $data);
  }

  public function galeriaEdit($idGaleria){
    $this->db->where('idGaleria', $idGaleria);
    $sql = $this->db->get('ofertas');
    return $sql->result();
  }

  public function updateGaleria($idGaleria, $imagen, $titulo, $texto, $fecha, $hora){
    $this->db->where('idGaleria', $idGaleria);
    if($imagen != ""){
      $data = array(
        'urlImagen' => $imagen,
        'titulo' => $titulo,
        'texto' => $texto,
        'fecha' => $fecha,
        'hora' => $hora
      );
    }else{
      $data = array(
        'titulo' => $titulo,
        'texto' => $texto,
        'fecha' => $fecha,
        'hora' => $hora
      );
    }
    $this->db->update('ofertas', $data);
  }

  public function galeriaDelete($idGaleria){
    $this->db->where('idGaleria', $idGaleria);
    $this->db->select('urlImagen');
    $sql = $this->db->get('ofertas');
    $sql = $sql->result();
    foreach ($sql as $di):
      unlink($di->urlImagen);
    endforeach;
    $this->db->where('idGaleria', $idGaleria);
    $this->db->delete('ofertas');
  }
}
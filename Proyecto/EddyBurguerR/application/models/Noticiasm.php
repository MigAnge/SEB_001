<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Noticiasm extends CI_Model {
  public function __construct(){
    parent::__construct();
  }

  public function noticiasSelect(){
    $sql = $this->db->get('ofertas');
    return $sql->result();
  }

  public function saveNoticias($imagen, $titulo, $texto){
    $data = array(
      'urlImagen' => $imagen,
      'titulo' => $titulo,
      'texto' => $texto,
    );

    $this->db->insert('noticias', $data);
  }

  public function noticiasEdit($idNoticia){
    $this->db->where('idNoticia', $idNoticia);
    $sql = $this->db->get('noticias');
    return $sql->result();
  }

  public function updateNoticias($idNoticia, $imagen, $titulo, $texto){
    $this->db->where('idNoticia', $idNoticia);
    if($imagen != ""){
      $data = array(
        'urlImagen' => $imagen,
      'titulo' => $titulo,
      'texto' => $texto,
    );
    }else{
      $data = array(
      'titulo' => $titulo,
      'texto' => $texto,
      );
    }
    $this->db->update('noticias', $data);
  }

  public function noticiasDelete($idNoticia){
    $this->db->where('idNoticia', $idNoticia);
    $this->db->select('urlImagen');
    $sql = $this->db->get('noticias');
    $sql = $sql->result();
    foreach ($sql as $di):
      unlink($di->urlImagen);
    endforeach;
    $this->db->where('idNoticia', $idNoticia);
    $this->db->delete('noticias');
  }
}

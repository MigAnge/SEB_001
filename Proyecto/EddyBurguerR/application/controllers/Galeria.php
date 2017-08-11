<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Galeria extends CI_Controller{

  public function __construct(){
    parent::__construct();
    $this->load->model('Galeriam');
  }

  function galeria(){
    $data['galeria'] = $this->Galeriam->galeriaSelect();
    $data['tables']= true;
    $this->load->view('eddy/galeria/index', $data);
  }

  function addGaleria(){
    $data['uf'] = true;
    $this->load->view('eddy/galeria/addGaleria', $data);
  }

  function saveGaleria(){
    $data['upload_path'] = 'uploads/galeria/';
    $data['allowed_types'] = 'gif|jpg|png|jpeg';

    $this->load->library('upload', $data);

    if(!$this->upload->do_upload("imagen")){
      $data['error'] = $this->upload->display_errors();
      $this->load->view('eddy/galeria/addGaleria', $data);
    }else{
      $file_info = $this->upload->data();
      $imagen = $data['upload_path'].$file_info['file_name'];
      $titulo = $this->input->post('titulo');
      $texto = $this->input->post('texto');
      $fecha = $this->input->post('fecha');
      $hora = $this->input->post('hora');
      $this->Galeriam->saveGaleria($imagen, $titulo, $texto, $fecha, $hora);
      redirect('Galeria/galeria');
    }
  }

  function galeriaEdit($idGaleria){
    $data['galeriaEdit'] = $this->Galeriam->galeriaEdit($idGaleria);
    $data['uf'] = true;
    $this->load->view('eddy/galeria/galeriaEdit', $data);
  }

  function updateGaleria(){
    $imagen =$_FILES['imagen']['type'];

    if($imagen != null){
      $data['upload_path'] = 'uploads/galeria/';
      $data['allowed_types'] = 'gif|jpg|png|jpeg';

      $this->load->library('upload', $data);

      if(!$this->upload->do_upload("imagen")){
        $data['error'] = $this->upload->display_errors();
        $this->load->view('eddy/galeria/galeria', $data);
      }else{
        $file_info = $this->upload->data();
        $imagen = $data['upload_path'].$file_info['file_name'];
        $idGaleria = $this->input->post('idGaleria');
        $titulo = $this->input->post('titulo');
        $texto = $this->input->post('texto');
        $fecha = $this->input->post('fecha');
        $hora = $this->input->post('hora');
        $imagenActual = $this->input->post('imagenActual');
        unlink($imagenActual);
        $this->Galeriam->updateGaleria($idGaleria, $imagen, $titulo, $texto, $fecha, $hora);
        redirect('Galeria/galeria');
      }
    }else{
      $imagen = "";
      $idGaleria = $this->input->post('idGaleria');
      $titulo = $this->input->post('titulo');
      $texto = $this->input->post('texto');
      $fecha = $this->input->post('fecha');
      $hora = $this->input->post('hora');
      $this->Galeriam->updateGaleria($idGaleria, $imagen, $titulo, $texto, $fecha, $hora);
      redirect('Galeria/galeria');
    }
  }

  function galeriaDelete($idGaleria){
    $this->Galeriam->galeriaDelete($idGaleria);
    redirect('Galeria/galeria');
  }

}

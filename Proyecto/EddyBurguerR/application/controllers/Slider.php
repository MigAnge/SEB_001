<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Slider extends CI_Controller{

  public function __construct(){
    parent::__construct();
    $this->load->model('Sliderm');
  }

  function slider(){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
  
    $data['slider'] = $this->Sliderm->sliderList();
    $this->load->view('eddy/Slider/index', $data);
     }else{
        redirect(base_url(),'refresh');
    }
  }

  function addSlider(){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
    $data['uf'] = true;
    $this->load->view('eddy/Slider/addSlider', $data);
     }else{
        redirect(base_url(),'refresh');
    }
  }

  function saveSlider(){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
    $data['upload_path'] = 'uploads/slider/';
    $data['allowed_types'] = 'gif|jpg|png|jpeg';

    $this->load->library('upload', $data);

    if(!$this->upload->do_upload("imagen")){
      $data['error'] = $this->upload->display_errors();
      $this->load->view('eddy/Slider/addSlider', $data);
    }else{
      $file_info = $this->upload->data();
      $imagen = $data['upload_path'].$file_info['file_name'];
      $texto = $this->input->post('texto');
      $user = $this->input->post('user');
      $boton = $this->input->post('boton');
      $titulo = $this->input->post('titulo');
      $this->Sliderm->saveSlider($imagen, $texto, $titulo, $user, $boton);
      redirect('Slider/slider');
    }
     }else{
        redirect(base_url(),'refresh');
    }
  }

  function sliderEdit($idImagen){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
    $data['sliderEdit'] = $this->Sliderm->sliderEdit($idImagen);
    $data['uf'] = true;
    $this->load->view('eddy/Slider/sliderEdit', $data);
     }else{
        redirect(base_url(),'refresh');
    }
  }

  function updateSlider(){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
    $imagen =$_FILES['imagen']['type'];
    if($imagen != null){
      $data['upload_path'] = 'uploads/slider/';
      $data['allowed_types'] = 'gif|jpg|png|jpeg';

      $this->load->library('upload', $data);

      if(!$this->upload->do_upload("imagen")){
        $data['error'] = $this->upload->display_errors();
        $this->load->view('eddy/Slider/slider', $data);
      }else{
        $file_info = $this->upload->data();
        $imagen = $data['upload_path'].$file_info['file_name'];
        $idImagen = $this->input->post('idImagen');
        $texto = $this->input->post('texto');
        $imagenActual = $this->input->post('imagenActual');
        $user = $this->input->post('user');
       $boton = $this->input->post('boton');
        $titulo = $this->input->post('titulo');
        unlink($imagenActual);
        $this->Sliderm->updateSlider($idImagen, $imagen, $texto, $titulo, $user, $boton);
        redirect('Slider/slider');
      }
    }else{
      $imagen = "";
      $idImagen = $this->input->post('idImagen');
      $texto = $this->input->post('texto');
      $user = $this->input->post('user');
      $boton = $this->input->post('boton');
      $titulo = $this->input->post('titulo');
      $this->Sliderm->updateSlider($idImagen, $imagen, $texto, $titulo, $user, $boton);
      redirect('Slider/slider');
    }
     }else{
        redirect(base_url(),'refresh');
    }
  }

  function sliderDelete($idImagen){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
    $this->Sliderm->sliderDelete($idImagen);
    redirect('Slider/slider');
     }else{
        redirect(base_url(),'refresh');
    }
  }
}

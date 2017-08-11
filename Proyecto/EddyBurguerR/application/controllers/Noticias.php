
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Noticias extends CI_Controller{

  public function __construct(){
    parent::__construct();
    $this->load->model('Noticiasm');
    $this->load->library('Grocery_CRUD');
  }

  function noticias(){

    $ofertas_crud = new grocery_CRUD();
    $ofertas_crud->set_table('ofertas');
$ofertas_crud->field_type('texto','text');
    $ofertas_crud->unset_textEditor('texto');
    $ofertas_crud->set_rules('titulo', 'título', 'trim|min_length[5]|max_length[100]');
    $ofertas_crud->set_rules('texto', 'texto', 'trim|min_length[5]|max_length[100]');
    //required fields to add and edit records
    $ofertas_crud->required_fields('urlImagen', 'titulo', 'texto');
    $ofertas_crud->columns('urlImagen', 'titulo', 'texto', 'botonText', 'fecha', 'Empleado_idEmpleado');
    //renombrar campos
    $ofertas_crud->display_as('urlImagen', 'Imágen a mostrar');
    $ofertas_crud->display_as('titulo', 'Título de la oferta');
    $ofertas_crud->display_as('texto', 'Descripción de la oferta');
    $ofertas_crud->display_as('botonText', 'Texto del botón');
    $ofertas_crud->display_as('Empleado_idEmpleado', 'Registrado por:');

//campos automaticos para agregar
    $ofertas_crud->callback_add_field('fecha', function(){
      $date = getdate();
      return '<input id="field-fecha" class="form-control" type="text" name="fecha" value="'.$date['mday']."/". $date['mon']."/".$date['year'].'" readonly/>';
    });

    $ofertas_crud->callback_add_field('hora', function(){
      $date = getdate();
      return '<input id="field-hora" class="form-control" type="text" name="hora" value="'.$date['hours'].":".$date['minutes'].":".$date['seconds'].'" readonly/>';
    });

//campos autimaticos para editar
    $ofertas_crud->callback_edit_field('fecha', function(){
      $date = getdate();
      return '<input id="field-fecha" class="form-control" type="text" name="fecha" value="'.$date['mday']."/". $date['mon']."/".$date['year'].'" readonly/>';
    });

    $ofertas_crud->callback_edit_field('hora', function(){
      $date = getdate();
      return '<input id="field-hora" class="form-control" type="text" name="hora" value="'.$date['hours'].":".$date['minutes'].":".$date['seconds'].'" readonly/>';
    });

    $ofertas_crud->set_language('spanish');

    //vincular tablas
    $ofertas_crud->set_relation('Empleado_idEmpleado', 'empleado', 'nombre');

    //imagenes
    $ofertas_crud->set_field_upload('urlImagen', 'uploads/galeria', 'jpg','png','jpeg');

    $output_ofertas = $ofertas_crud->render();

    $this->_example_output($output_ofertas);

    /** backup old code **/
    /**$data['noticias'] = $this->Noticiasm->noticiasSelect();
    $data['tables']= true;
    $this->load->view('eddy/Noticias/index', $data);**/
  }

  public function _example_output($output_ofertas){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
        $this->load->view('eddy/Noticias/index', $output_ofertas);
   }else{
        redirect(base_url(),'refresh');
    }
  }












  function addNoticias(){
    $data['uf'] = true;
    $this->load->view('eddy/Noticias/addNoticias', $data);
  }

  function saveNoticias(){
    $data['upload_path'] = 'uploads/noticias/';
    $data['allowed_types'] = 'gif|jpg|png|jpeg';

    $this->load->library('upload', $data);

    if(!$this->upload->do_upload("imagen")){
      $data['error'] = $this->upload->display_errors();
      $this->load->view('eddy/Noticias/addNoticias', $data);
    }else{
      $file_info = $this->upload->data();
      $imagen = $data['upload_path'].$file_info['file_name'];
      $titulo = $this->input->post('titulo');
      $texto = $this->input->post('texto');
      
      $this->Noticiasm->saveNoticias($imagen, $titulo, $texto);
      redirect('Noticias/noticias');
    }
  }

  function noticiasEdit($idNoticia){
    $data['noticiasEdit'] = $this->Noticiasm->NoticiasEdit($idNoticia);
    $data['uf'] = true;
    $this->load->view('eddy/Noticias/noticiasEdit', $data);
  }

  function updateNoticias(){
    $imagen =$_FILES['imagen']['type'];

    if($imagen != null){
      $data['upload_path'] = 'uploads/noticias/';
      $data['allowed_types'] = 'gif|jpg|png|jpeg';

      $this->load->library('upload', $data);

      if(!$this->upload->do_upload("imagen")){
        $data['error'] = $this->upload->display_errors();
        $this->load->view('eddy/Noticias/noticias', $data);
      }else{
        $file_info = $this->upload->data();
        $imagen = $data['upload_path'].$file_info['file_name'];
        $idProducto = $this->input->post('idNoticia');
        $titulo = $this->input->post('titulo');
        $texto = $this->input->post('texto');
        $imagenActual = $this->input->post('imagenActual');
        unlink($imagenActual);
        $this->Noticiasm->updateNoticias($idNoticia, $imagen, $titulo, $texto);
        redirect('Noticias/noticias');
      }
    }else{
      $imagen = "";
      $idNoticia = $this->input->post('idNoticia');
      $titulo = $this->input->post('titulo');
      $texto = $this->input->post('texto');
      $this->Noticiasm->updateNoticias($idNoticia, $imagen, $titulo, $texto);
    redirect('Noticias/noticias');
    }
  }

  function noticiasDelete($idNoticia){
    $this->Noticiasm->noticiasDelete($idNoticia);
    redirect('Noticias/noticias');
  }

}

<?php
/**
*Clase Noticias
*Esta clase extiende de CI_Controler, y funciona como controlaor para las vistas back-end pertenecientes a las ofertas (Noticias)
*Se hace uso de la libreria GROCERY CRUD creada por John Skoumbourdis <scoumbourdisj@gmail.com>
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version 0.2
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/controllers/Noticias.php
*@author Raul Ugarte Ramos
*@since 0.1
*/

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
    $ofertas_crud->set_rules('titulo', 'título', 'trim|min_length[5]|max_length[100]|required');
    $ofertas_crud->set_rules('texto', 'texto', 'trim|min_length[5]|max_length[100]|required');
    $ofertas_crud->set_rules('botonText', 'Texto del botón', 'trim|min_length[5]|max_length[100]|required');
    //required fields to add and edit records
    $ofertas_crud->required_fields('urlImagen', 'titulo', 'texto');
    $ofertas_crud->columns('urlImagen', 'titulo', 'texto', 'botonText', 'fecha', 'Empleado_idEmpleado');
    //renombrar campos
    $ofertas_crud->display_as('urlImagen', 'Imágen a mostrar');
    $ofertas_crud->display_as('titulo', 'Título de la oferta');
    $ofertas_crud->display_as('texto', 'Descripción de la oferta');
    $ofertas_crud->display_as('botonText', 'Texto del botón');
    $ofertas_crud->display_as('Empleado_idEmpleado', 'Registrado por:');
    $Empleado_idEmpleado = $this->session->userdata('id');
    $ofertas_crud->field_type('Empleado_idEmpleado', 'hidden', $Empleado_idEmpleado);

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
}

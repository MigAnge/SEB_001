<?php
/**
*Clase Categoria
*Esta clase extiende de CI_Controler, y funciona como controlaor para las vistas back-end pertenecientes a las categorias
*Se hace uso de la libreria GROCERY CRUD creada por John Skoumbourdis <scoumbourdisj@gmail.com>
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version 0.1
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/controllers/Categoria.php
*@author Raul Ugarte Ramos
*@since 0.1
*/

defined('BASEPATH') OR exit('No direct script access allowed');

class Categoria extends CI_Controller{
private $id;
  public function __construct(){
    parent::__construct();
    $this->load->library('cart');
    $this->load->library('Grocery_CRUD');
  }

  function categoria(){
    $categoria = new grocery_CRUD();
    $categoria->set_Table('categoria');
    $categoria->required_fields('nombre');
    $categoria->set_language('spanish');
    $categoria->field_type('descripcion','text');
    $categoria->unset_textEditor('descripcion');
    $categoria->set_rules('descripcion','descripción','trim|max_length[300]');
    $categoria->set_rules('nombre','nombre','trim|min_length[5]');
    $output_categoria = $categoria->render();

    

    $this->_example_output($output_categoria);
  }

  function _example_output($output_categoria){
   if($this->session->userdata('login') && $this->session->userdata('privi')){
        $this->load->view('eddy/Categoria/index', $output_categoria);
   }else{
        redirect(base_url(),'refresh');
    }
  }
}
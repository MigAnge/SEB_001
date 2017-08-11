<?php

defined('BASEPATH') OR exit('No direct script access allowed');

class Marca extends CI_Controller{
private $id;
  public function __construct(){
    parent::__construct();
    $this->load->library('cart');
    $this->load->library('Grocery_CRUD');
  }

  function marcas(){
    $marca = new grocery_CRUD();
    $marca->set_Table('marca');
    $marca->required_fields('nombre');
    $marca->set_language('spanish');

    $marca->set_rules('nombre','nombre','trim|max_length[45]');

    $output_marca = $marca->render();

    $this->_example_output($output_marca);
  }

  function _example_output($output_marca){
    if($this->session->userdata('login') && $this->session->userdata('privi')){
        $this->load->view('eddy/Marca/index', $output_marca);
   }else{
        redirect(base_url(),'refresh');
    }    
  }
}
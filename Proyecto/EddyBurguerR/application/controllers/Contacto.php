<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Contacto extends CI_Controller {
public function __construct(){
	parent::__construct();
	$this->load->model('Contactom');
    $this->load->library('grocery_CRUD');
}

    function contacto(){
        $contacto = new grocery_CRUD();
    $contacto->set_table('contacto');
    $contacto->unset_add();
    $contacto->unset_edit();
    $contacto->unset_delete();

    $contacto->set_language('spanish');

    $output_contacto = $contacto->render();

    $this->_example_output($output_contacto);
    }

    function _example_output($output_contacto){
         if($this->session->userdata('login') && $this->session->userdata('privi')){
         $this->load->view('eddy/Contacto/index', $output_contacto);
   }else{
        redirect(base_url(),'refresh');
    }   
    }

	public function add(){
		$this->form_validation->set_rules('email', 'Correo electrónico', 'trim|required|valid_email');
	    $this->form_validation->set_rules('name', 'Nombre', 'trim|required');
	    $this->form_validation->set_rules('message', 'Comentario', 'trim|required|max_length[200]|min_length[5]');
	
	$this->form_validation->set_message('required', 'El campo "%s" es requerido');
	$this->form_validation->set_message('valid_email', 'El %s no es válido');

    if ($this->form_validation->run() === TRUE) {
        $email = $this->input->post('email');
        $name = $this->input->post('name');
        $comentario = $this->input->post('message');

        $this->Contactom->add($name, $email, $comentario);
    }else{
        $data['title']= "contacto";
	  		$data['pag']= "contacto";
	  		$this->load->view('paginas', $data);	
    }

	}

}
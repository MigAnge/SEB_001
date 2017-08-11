<?php
/**
*Clase Welcome
*Esta clase extiende de CI_Controler, y funciona como controlador principal para acceder a las vistas del front-end
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version 0.2
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/controllers/Welcome.php
*@author Miguel Ángel Franco Ramirez
*@since 0.2
*/
defined('BASEPATH') OR exit('No direct script access allowed');

class Welcome extends CI_Controller {
public function __construct(){
	parent::__construct();
	$this->load->model('Sliderm');
	$this->load->model('Galeriam');
	$this->load->model('Productosm');
	$this->load->model('Usuariosm');
    $this->load->model('Noticiasm');
}
	public function index(){
		$data['slider'] = $this->Sliderm->sliderList();
		$data['title'] = 'EDDY BURGUER';
		$this->load->view('index', $data);
	}

	public function paginas($pagina){
		if($pagina === 'galeria'){
			$data['galeria'] = $this->Galeriam->galeriaSelect();
		}
		if($pagina === 'productos'){
			$pages = 8;
			$desde = ($this->uri->segment(4)) ? $this->uri->segment(4) : 0;
			$this->load->library('pagination');
			$config['base_url'] = base_url()."index.php/Welcome/paginas/productos";
			$config['total_rows'] = $this->Productosm->productosSelectRows();
			$config['per_page'] = $pages;
			$config['uri_segment'] = 4;
			$config['num_links'] = 20;
			$config['first_link'] = 'Primera';
			$config['last_link'] = 'Última';
			$config['next_link'] = 'Siguiente';
			$config['prev_link'] = 'Anterior';
			$config['full_tag_open'] = '<div class="pagination">';
			$config['full_tag_close'] = '</div>';
			$config['num_tag_open'] = '<div class="btn btn-primary numerpag">'; 
			$config['num_tag_close'] = '</div>'; 
			$config['cur_tag_open'] = '<div class="btn activopag"><a>'; 
			$config['cur_tag_close'] = '</a></div>'; 
			$config['prev_tag_open'] = '<div class="btn pagcontrol">'; 
			$config['prev_tag_close'] = '</div>'; 
			$config['next_tag_open'] = '<div class="btn pagcontrol">'; 
			$config['next_tag_close'] = '</div>'; 
			$config['first_link'] = '«'; 
			$config['prev_link'] = '‹'; 
			$config['last_link'] = '»'; 
			$config['next_link'] = '›'; 
			$config['first_tag_open'] = '<div class="btn pagcontrol">'; 
			$config['first_tag_close'] = '</div>'; 
			$config['last_tag_open'] = '<div class="btn pagcontrol">'; 
			$config['last_tag_close'] = '</div>'; 

			$this->pagination->initialize($config);
			$data['productos'] = $this->Productosm->productosSelectpag($pages, $desde);
			$data['pagination']=$this->pagination->create_links();
		}
		if($pagina === 'noticias'){
			$data['noticias'] = $this->Noticiasm->noticiasSelect();
		}

	  $data['title']= $pagina;
	  $data['pag']= $pagina;
    $this->load->view('paginas', $data);
  }

  public function loginV(){
	  if($this->session->userdata('name')){
		$this->index();
	  }else{
	  	$data['title']= "Login";
	  	$data['pag']= "Login";
	  	$this->load->view('login', $data);
	  }
  }

  public function login(){
	$this->form_validation->set_rules('email', 'Correo electrónico', 'trim|required|valid_email');
	$this->form_validation->set_rules('password', 'Contraseña', 'trim|required');
	
	$this->form_validation->set_message('required', 'El campo "%s" es requerido');
	$this->form_validation->set_message('valid_email', 'El %s no es válido');
	

	if ($this->form_validation->run() === TRUE) {
			$email = $this->input->post("email");
			$password = $this->input->post("password");
			$res = $this->Usuariosm->login($email, $password, "cliente");
			$rep = $this->Usuariosm->login($email, $password, "empleado");
			if($res){
				foreach ($res as $key) {
					$data = array(
						"id" => $key->idCliente,
						"name" => $key->nombre,
						"fullName" => $key->nombre.' '.$key->apellido_P.' '.$key->apellido_M,
						"email"  => $key->email,
						"userType" => 0,
						"login" => TRUE
					);
				}

				$this->session->set_userdata($data);
				echo $this->session->userdata("userType");
			}else if($rep){
				foreach ($rep as $key) {
					$data = array(
						"id" => $key->idEmpleado,
						"name" => $key->nombre,
						"userType" => 1,
						"privi" => $key->privi,
						"login" => TRUE
					);
				}
				
				$this->session->set_userdata($data);
				echo $this->session->userdata("userType");
				
			}else{
				echo "error";
			}
				
		} else {
			$data['title']= "Login";
	  		$data['pag']= "Login";
	  		$this->load->view('login', $data);		 
		}
  }

  public function logout(){
	  $this->session->sess_destroy();
	  
	  redirect('Welcome/index','refresh');
	  
  }
}
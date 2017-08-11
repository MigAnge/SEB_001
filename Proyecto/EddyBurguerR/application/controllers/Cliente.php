<?php
/**
*Clase Cliente
*Esta clase extiende de CI_Controler, y funciona como controlaor para las vistas back-end pertenecientes a la gestión
*de clientes.
*Se hace uso de metodos propios y de la libreria GROCERY CRUD creada por John Skoumbourdis <scoumbourdisj@gmail.com>
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version 0.1
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/controllers/Cliente.php
*@author Alejandro Onofre Cornejo
*@since 0.1
*/

defined('BASEPATH') OR exit('No direct script access allowed');

class Cliente extends CI_Controller{
private $id;
  public function __construct(){
    parent::__construct();
    $this->load->model('Usuariosm');
    $this->load->library('cart');
    $this->load->library('Grocery_CRUD');
  }

  function cliente(){
    $cliente_crud = new grocery_CRUD();
    $cliente_crud->set_table('cliente');
    $cliente_crud->set_js('js/llenarSelectEditCliente.js');
    $cliente_crud->set_js('js/listarColoniasCliente.js');
    $cliente_crud->unset_read();
    

    if(!$this->session->userdata('privi')){
        $cliente_crud->unset_back_to_list();
        $url = base_url().'index.php/Welcome/index';
        $cliente_crud->set_lang_string('update_success_message',
		 'Tus dátos se han actualizado.<br/>En unos momentos seras redireccionado a la pagina principal.
		 <script type="text/javascript">
		  window.location = "'.$url.'";
		 </script>
		 <div style="display:none">
		 '
        );

        $cliente_crud->set_lang_string('insert_success_message',
		 'Tus datos se han guardado.<br/> ahora puedes iniciar sesión.
		 <script type="text/javascript">
		  window.location = "'.base_url().'/index.php/Welcome/loginV";
		 </script>
		 <div style="display:none">');
    }else{
        $cliente_crud->unset_add();
        $cliente_crud->unset_edit();
    }
$cliente_crud->set_rules('nombre', 'nombre', 'trim|min_length[3]|max_length[45]|required');
    $cliente_crud->set_rules('apellido_P', 'Apellido paterno', 'trim|min_length[3]|max_length[100]|required');
    $cliente_crud->set_rules('apellido_M', 'Apellido materno', 'trim|min_length[3]|max_length[100]|required');
    $cliente_crud->set_rules('email', 'email', 'trim|max_length[100]|valid_email|required');
    $cliente_crud->set_rules('password', 'Contraseña', 'trim|min_length[8]|max_length[64]|required');
    $cliente_crud->set_rules('calle', 'calle', 'trim|min_length[3]|max_length[100]|required');
    $cliente_crud->set_rules('numero', 'número', 'trim|min_length[1]|max_length[45]|required');


    $estado = $cliente_crud->getState();

    if($estado == 'add'){
        $cliente_crud->set_rules('Codigopostal', 'C.P', 'trim|min_length[5]|max_length[5]|required');
        $cliente_crud->set_rules('Colonia', 'colonia', 'trim|min_length[1]|max_length[5]|required');
        $this->session->set_userdata('login', TRUE);
    }

    if($this->session->userdata('login') && !$this->session->userdata('privi')){
        $cliente_crud->unset_list();
    }

//campos requeridos
    $cliente_crud->required_fields('nombre','apellido_P','email', 'password');
    $cliente_crud->columns('nombre','apellido_P','apellido_M','email','password');
    
    $cliente_crud->fields('nombre','apellido_P','apellido_M',
    'email','password', 'Direccion_idDireccion', 'calle', 'numero', 'Codigopostal', 'Colonia','Ciudad', 'Estado');

    //renombrar campos
    $cliente_crud->display_as('apellido_M', 'Apellido materno');
    $cliente_crud->display_as('nombre', 'Nombre');
    $cliente_crud->display_as('numero', 'Número');
    $cliente_crud->display_as('calle', 'Calle');
    $cliente_crud->display_as('apellido_P', 'Apellido paterno');
    $cliente_crud->display_as('email', 'Correo electrónico');
    $cliente_crud->display_as('password', 'Contraseña');
    $cliente_crud->display_as('Direccion_idDireccion', 'Direccion');
    

    $codigosP = $this->Usuariosm->getCodigosPostales();
    foreach ($codigosP as $cp) {
        $datos[$cp->codigoPostal] = $cp->codigoPostal;
    }

    //tipo de elemento
    $cliente_crud->field_type('Ciudad', 'readonly', 'Acambaro');
    $cliente_crud->field_type('Estado', 'readonly', 'Guanajuato');
    $cliente_crud->field_type('password','password');
    $cliente_crud->field_type('Codigopostal','dropdown', $datos);
    $cliente_crud->field_type('Colonia', 'dropdown', array('' => 'seleccionar colónia'));
    

//campos personalizados
    $cliente_crud->callback_add_field('Direccion_idDireccion',  function(){
        return '<input id="field-Direccion_idDireccion" class="form-control" type="hidden" name="Direccion_idDireccion" value="" readonly/>';
    });

    $cliente_crud->callback_add_field('Colonia',  function(){
        return '<select id="field-Colonia" name="Colonia" class="misel" data-placeholder="Seleccionar Colonia">
        </select>';
    });

    $cliente_crud->callback_add_field('Ciudad',  function(){
        return '<input id="field-Ciudad" name="Ciudad" type="text" class="form-control" readonly>';
    });

     $cliente_crud->callback_add_field('Estado',  function(){
        return '<input id="field-Estado" name="Estado" type="text" class="form-control" readonly>';
    });


    //campos personalizados para editar
 $cliente_crud->callback_edit_field('Direccion_idDireccion',  function(){
        return '<input id="field-Direccion_idDireccion" class="form-control" type="hidden" name="Direccion_idDireccion" value="2" readonly/>
        ';
    });

    $cliente_crud->callback_edit_field('Colonia',  function(){
        return '
        <select id="field-Colonia" name="Colonia" class="misel" data-placeholder="Seleccionar Colonia">
        </select>';
    });

    $cliente_crud->callback_edit_field('Ciudad',  function(){
        return '<input id="field-Ciudad" name="Ciudad" type="text" class="form-control" readonly>';
    });

     $cliente_crud->callback_edit_field('Estado',  function(){
        return '<input id="field-Estado" name="Estado" type="text" class="form-control" readonly>';
    });

    $cliente_crud->callback_edit_field('numero', function(){
        return '
        <input id="field-numero" class="form-control" name="numero" type="text" value="">
        <br>
        <br>
        <field for="cp_actual"> C.P actual</field>
        <input id="cp_actual" class="form-control" type="text" name="cpActual" value="" readonly/>';
    });

    $cliente_crud->callback_before_insert(array($this,'editArray'));

    $cliente_crud->callback_before_update(array($this,'updateArray'));

    //vincular tablas
    $cliente_crud->set_language('spanish');

    //relacionar tablas
    $cliente_crud->set_relation('Direccion_idDireccion', 'direccion', '{calle_dir} #{no_dir}');

    try{
        $output_cliente = $cliente_crud->render();
    } catch(Exception $e) {  
        redirect(base_url(),'refresh');
    }

    $this->_example_output($output_cliente);
  }

  public function _example_output($output_cliente){
      if($this->session->userdata('login') && !$this->session->userdata('privi')){
          $data['title'] = 'Editar mi información';
    $this->load->view('eddy/Cliente/indexEditCliente', $output_cliente, $data);
      }else if($this->session->userdata('login') && $this->session->userdata('privi')){
        $this->load->view('eddy/Cliente/index', $output_cliente);
      }else{
          redirect(base_url(),'refresh');
      }
  }

  public function llenarColonias(){
      header('Content-Type: application/json');
      $colonias = $this->Usuariosm->getColonias($this->input->post('codigos'));
      echo json_encode($colonias);
  }

public function llenarColoniasEdit(){
      header('Content-Type: application/json');
      $colonias = $this->Usuariosm->getColoniasEdit($this->input->post('ids'), 'cliente','idCliente');
      echo json_encode($colonias);
  }
  

  public function editArray($post_array){
     unset($post_array['calle']);
        unset($post_array['numero']);
        unset($post_array['Codigopostal']);
        unset($post_array['Colonia']);
        unset($post_array['privi']);

        $colonia = $this->input->post('Colonia');
        $numero = $this->input->post('numero');
        $calle = $this->input->post('calle');
        $direccion = $this->Usuariosm->setDireccionUsuario($calle, $numero, $colonia);

        $post_array['Direccion_idDireccion'] = $direccion;

        return $post_array;
  }

public function updateArray($post_array){
     unset($post_array['calle']);
        unset($post_array['numero']);
        unset($post_array['Codigopostal']);
        unset($post_array['Colonia']);
        unset($post_array['privi']);

        $colonia = $this->input->post('Colonia');
        $numero = $this->input->post('numero');
        $calle = $this->input->post('calle');
        $idDireccion = $this->input->post('Direccion_idDireccion');
        $direccion = $this->Usuariosm->updateDireccionUsuario($calle, $numero, $colonia, $idDireccion);

        return $post_array;
  }


  function llenarEditFields(){
      header('Content-Type: application/json');
      $datos = $this->Usuariosm->llenarEditFields($this->input->post('id'), 'idCliente', 'cliente');
      echo json_encode($datos);
  }
}
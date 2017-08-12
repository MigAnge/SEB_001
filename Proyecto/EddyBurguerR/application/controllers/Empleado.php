<?php
/**
*Clase Empleado
*Esta clase extiende de CI_Controler, y funciona como controlaor para las vistas back-end pertenecientes a la gestión
*de empleados.
*Se hace uso de metodos propios y de la libreria GROCERY CRUD creada por John Skoumbourdis <scoumbourdisj@gmail.com>
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version  0.1.0
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/controllers/Empleado.php
*@author Alejandro Onofre Cornejo
*@since Class available since Release 0.1.0
*@deprecated Class deprecated in Release 2.0.0
*/

defined('BASEPATH') OR exit('No direct script access allowed');

class Empleado extends CI_Controller{
private $id;
  public function __construct(){
    parent::__construct();
    $this->load->model('Usuariosm');
    $this->load->library('cart');
    $this->load->library('Grocery_CRUD');
  }

  function empleados(){
    $empleado_crud = new grocery_CRUD();
    $empleado_crud->set_table('empleado');
    $empleado_crud->set_js('js/llenarSelectEdit.js');
    $empleado_crud->set_js('js/listarColonias.js');
    $empleado_crud->unset_read();

    $empleado_crud->set_rules('nombre', 'nombre', 'trim|min_length[3]|max_length[45]|required');
    $empleado_crud->set_rules('apellido_P', 'Apellido paterno', 'trim|min_length[3]|max_length[100]|required');
    $empleado_crud->set_rules('apellido_M', 'Apellido materno', 'trim|min_length[3]|max_length[100]|required');
    $empleado_crud->set_rules('email', 'email', 'trim|max_length[100]|valid_email|required');
    $empleado_crud->set_rules('password', 'Contraseña', 'trim|min_length[8]|max_length[64]|required');
    $empleado_crud->set_rules('calle', 'calle', 'trim|min_length[3]|max_length[100]|required');
    $empleado_crud->set_rules('numero', 'número', 'trim|min_length[1]|max_length[45]|required');


    $estado = $empleado_crud->getState();

    if($estado == 'add'){
        $empleado_crud->set_rules('Codigopostal', 'C.P', 'trim|min_length[5]|max_length[5]|required|numeric');
        $empleado_crud->set_rules('Colonia', 'Colonia', 'trim|min_length[5]|max_length[5]|required');
    }
//campos requeridos
    $empleado_crud->required_fields('nombre','apellido_P','email', 'password', 'priv');
    $empleado_crud->columns('nombre','apellido_P','apellido_M','email','password', 'priv');
    
    $empleado_crud->fields('nombre','apellido_P','apellido_M',
    'email','password', 'Direccion_idDireccion', 'calle', 'numero', 'Codigopostal', 'Colonia','Ciudad', 'Estado', 'privi');

    //renombrar campos
    $empleado_crud->display_as('apellido_M', 'Apellido materno');
    $empleado_crud->display_as('nombre', 'Nombre');
    $empleado_crud->display_as('numero', 'Número');
    $empleado_crud->display_as('calle', 'Calle');
    $empleado_crud->display_as('apellido_P', 'Apellido paterno');
    $empleado_crud->display_as('email', 'Correo electrónico');
    $empleado_crud->display_as('password', 'Contraseña');
    $empleado_crud->display_as('Direccion_idDireccion', 'Direccion');
    if($estado=='edit'){
    $empleado_crud->display_as('Codigopostal', 'Cambiar C.P');
    }else{
        $empleado_crud->display_as('Codigopostal', 'C.P');
    }

    $codigosP = $this->Usuariosm->getCodigosPostales();
    foreach ($codigosP as $cp) {
        $datos[$cp->codigoPostal] = $cp->codigoPostal;
    }

    //tipo de elemento
    $empleado_crud->field_type('privi','hidden', 1);
    $empleado_crud->field_type('Ciudad', 'readonly', 'Acambaro');
    $empleado_crud->field_type('Estado', 'readonly', 'Guanajuato');
    $empleado_crud->field_type('password','password');
    $empleado_crud->field_type('Codigopostal','dropdown', $datos);
    $empleado_crud->field_type('Colonia', 'dropdown', array('' => 'seleccionar colónia'));
    

//campos personalizados
    $empleado_crud->callback_add_field('Direccion_idDireccion',  function(){
        return '<input id="field-Direccion_idDireccion" class="form-control" type="hidden" name="Direccion_idDireccion" value="" readonly/>';
    });

    $empleado_crud->callback_add_field('Colonia',  function(){
        return '<select id="field-Colonia" name="Colonia" class="misel" data-placeholder="Seleccionar Colonia">
        </select>';
    });

    $empleado_crud->callback_add_field('Ciudad',  function(){
        return '<input id="field-Ciudad" name="Ciudad" type="text" class="form-control" readonly>';
    });

     $empleado_crud->callback_add_field('Estado',  function(){
        return '<input id="field-Estado" name="Estado" type="text" class="form-control" readonly>';
    });


    //campos personalizados para editar
 $empleado_crud->callback_edit_field('Direccion_idDireccion',  function(){
        return '<input id="field-Direccion_idDireccion" class="form-control" type="hidden" name="Direccion_idDireccion" value="2" readonly/>
        ';
    });

    $empleado_crud->callback_edit_field('Colonia',  function(){
        return '
        <select id="field-Colonia" name="Colonia" class="misel" data-placeholder="Seleccionar Colonia">
        </select>';
    });

    $empleado_crud->callback_edit_field('Ciudad',  function(){
        return '<input id="field-Ciudad" name="Ciudad" type="text" class="form-control" readonly>';
    });

     $empleado_crud->callback_edit_field('Estado',  function(){
        return '<input id="field-Estado" name="Estado" type="text" class="form-control" readonly>';
    });

    $empleado_crud->callback_edit_field('numero', function(){
        return '
        <input id="field-numero" class="form-control" name="numero" type="text" value="">
        <br>
        <br>
        <field for="cp_actual"> C.P actual</field>
        <input id="cp_actual" class="form-control" type="text" name="cpActual" value="" readonly/>';
    });

    $empleado_crud->callback_before_insert(array($this,'editArray'));

    $empleado_crud->callback_before_update(array($this,'updateArray'));

    //vincular tablas
    $empleado_crud->set_language('spanish');

    //relacionar tablas
    $empleado_crud->set_relation('Direccion_idDireccion', 'direccion', '{calle_dir} #{no_dir}');

    $output_empleado = $empleado_crud->render();

    $this->_example_output($output_empleado);
  }

  public function _example_output($output_empleado){
      if($this->session->userdata('login') && $this->session->userdata('privi')){
        $this->load->view('eddy/Empleado/index', $output_empleado);
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
      $colonias = $this->Usuariosm->getColoniasEdit($this->input->post('ids'), 'empleado','idEmpleado');
      echo json_encode($colonias);
  }
  

  public function editArray($post_array){
     unset($post_array['calle']);
        unset($post_array['numero']);
        unset($post_array['Codigopostal']);
        unset($post_array['Colonia']);

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

        $colonia = $this->input->post('Colonia');
        $numero = $this->input->post('numero');
        $calle = $this->input->post('calle');
        $idDireccion = $this->input->post('Direccion_idDireccion');
        $direccion = $this->Usuariosm->updateDireccionUsuario($calle, $numero, $colonia, $idDireccion);

        return $post_array;
  }


  function llenarEditFields(){
      header('Content-Type: application/json');
      $datos = $this->Usuariosm->llenarEditFields($this->input->post('id'), 'idEmpleado', 'empleado');
      echo json_encode($datos);
  }
}
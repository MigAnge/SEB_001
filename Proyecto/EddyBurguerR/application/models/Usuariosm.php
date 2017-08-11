<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Usuariosm extends CI_Model {
    private $lastDireccionid;
    public function __construct(){
      parent::__construct();
    }

    function login($email, $password, $tabla){
        $this->db->where('email', $email);
        $this->db->where('password', $password);
        $sql = $this->db->get($tabla);
        if($sql->num_rows()==1){
            return $sql->result();
        }else{
          return false;
        } 
    }

    function setTablename($tablename){
        $this->tablename = $tablename;
    }

    function DireccionesProvedor($datos){
        $estado = array(
            'estado' => $datos['estado']
        );
        $this->db->insert('estado', $estado);
        $ciudad = array(
            'ciudad' => $datos['ciudad'],
            'Estado_idEstado' => $this->db->insert_id()
        );
        $this->db->insert('ciudad', $ciudad);
        $colonia = array(
            'colonia' => $datos['colonia'],
            'codigoPostal' => $datos['codigoPostal'],
            'Ciudad_idEstadoCiudad' => $this->db->insert_id()
        );
        $this->db->insert('colonia', $colonia);
        $direccion = array(
            'calle_dir' => $datos['calle'], 
            'no_dir' => $datos['numeroCalle'],
            'Colonia_idColonia' => $this->db->insert_id()
        );
        $this->db->insert('direccion', $direccion);
    }

    function Direcciones($datos){
        $this->db->insert('direccion', $datos);
    }

    function getCodigosPostales(){
        $this->db->select('codigoPostal');
        $sql = $this->db->get('colonia');
        return $sql->result();
    }


    function getColonias($codigoPostal){
         $this->db->select('colonia, idColonia, ciudad, estado');
         $this->db->from('colonia');
        $this->db->join('ciudad', 'ciudad.idEstadociudad = colonia.Ciudad_idEstadoCiudad', 'rigth');
        $this->db->join('estado', 'estado.idEstado = ciudad.Estado_idEstado', 'rigth');
        $this->db->where('codigoPostal', $codigoPostal);
        $sql = $this->db->get();
        return $sql->result();
    }

    function setDireccionUsuario($calle, $numero, $colonia){
        $data= array(
            'calle_dir' => $calle,
            'no_dir' => $numero,
            'Colonia_idColonia' => $colonia
        );
        $this->db->insert('direccion', $data);
        $this->lastDireccionid = $this->db->insert_id();
        return  $this->lastDireccionid;
    }

    function setDir($direccion, $tabla){
        $data= array(
            'Direccion_idDireccion' => $direccion
        );
        if($tabla=='empleado'){
            $this->db->where('idEmpleado', $this->db->insert_id());
        }elseif ($tabla =='cliente'){
            $this->db->where('idCliente', $this->db->insert_id());
        }else {
            return false;
        }
        return $this->db->update($tabla, $data);
    }

    function db_insert($tabla, $post_array){
        $data = array(
            'nombre' => $post_array['nombre'],
            'apellido_P' => $post_array['apellido_P'],
            'apellido_M' => $post_array['apellido_M'],
            'email' => $post_array['email'],
            'Direccion_idDireccion' =>  $post_array['Direccion_idDireccion'],
            'password' => $post_array['password'],
            'privi' => $post_array['privi'],
        );
        $this->db->insert($tabla, $data);   
    }

    function llenarEditFields($id,$campo, $tabla){

        $this->db->select('Direccion_idDireccion, calle_dir, no_dir, colonia, codigoPostal, idColonia, ciudad, estado');
         $this->db->from($tabla);
         $this->db->join('direccion', 'direccion.idDireccion = '.$tabla.'.Direccion_idDireccion', 'rigth'); 
        $this->db->join('colonia', 'colonia.idColonia = direccion.Colonia_idColonia', 'rigth'); 
        $this->db->join('ciudad', 'ciudad.idEstadociudad = colonia.Ciudad_idEstadoCiudad', 'rigth');
        $this->db->join('estado', 'estado.idEstado = ciudad.Estado_idEstado', 'rigth');
        $this->db->where($campo, $id);
        $sql = $this->db->get();
        return $sql->result();
    }

    function getColoniasEdit($id, $tabla, $idComparar){
         $this->db->select('codigoPostal');
         $this->db->from($tabla);
          $this->db->join('direccion', 'direccion.idDireccion = '.$tabla.'.Direccion_idDireccion', 'rigth'); 
        $this->db->join('colonia', 'colonia.idColonia = direccion.Colonia_idColonia', 'rigth'); 
        $this->db->join('ciudad', 'ciudad.idEstadociudad = colonia.Ciudad_idEstadoCiudad', 'rigth');
        $this->db->join('estado', 'estado.idEstado = ciudad.Estado_idEstado', 'rigth');
        $this->db->where($idComparar, $id);
        $sql = $this->db->get();
        $sql = $sql->result();
        foreach($sql as $cp){
        $sql = $this->getColonias($cp->codigoPostal);
        }
        return $sql;
    }

    function updateDireccionUsuario($calle, $numero, $colonia, $direccion){
        $this->db->where('idDireccion', $direccion);
        $data= array(
            'calle_dir' => $calle,
            'no_dir' => $numero,
            'Colonia_idColonia' => $colonia
        );
        return $this->db->update('direccion', $data);
    }

    function getUserdataToCart($idComparar){
         $this->db->select('nombre, apellido_P, apellido_M, email, calle_dir, no_dir, colonia, codigoPostal, ciudad, estado');
         $this->db->from('cliente');
         $this->db->join('direccion', 'direccion.idDireccion = cliente.Direccion_idDireccion', 'rigth'); 
        $this->db->join('colonia', 'colonia.idColonia = direccion.Colonia_idColonia', 'rigth'); 
        $this->db->join('ciudad', 'ciudad.idEstadociudad = colonia.Ciudad_idEstadoCiudad', 'rigth');
        $this->db->join('estado', 'estado.idEstado = ciudad.Estado_idEstado', 'rigth');
        $this->db->where('idCliente', $idComparar);
        $sql = $this->db->get();
        return $sql->result();
    }
}
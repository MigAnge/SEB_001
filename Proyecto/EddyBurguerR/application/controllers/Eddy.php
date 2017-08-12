<?php
/**
*Clase Eddy
*Esta clase extiende de CI_Controler, y funciona como controlaor acceder al panel de control
*/

/**
*@category EddyBurguer
*@package EddyBurguerR
*@subpackage controllers
*@copyright Derechos reservados® Soft-pack
*@version  0.1.0
*@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/controllers/Eddy.php
*@author Alejandro Onofre Cornejo
*@since Class available since Release 0.1.0
*@deprecated Class deprecated in Release 2.0.0
*/
class Eddy extends CI_Controller
{

    function __construct()
    {
        parent::__construct();
    }

    public function Eddy()
    {
    if($this->session->userdata('login') && $this->session->userdata('privi')){
        $this->load->view("eddy/index");
   }else{
        redirect(base_url(),'refresh');
    }
        
    }
}


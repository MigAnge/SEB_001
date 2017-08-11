<?php

/**
 * Created by PhpStorm.
 * User: alex
 * Date: 18/11/16
 * Time: 04:55 PM
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


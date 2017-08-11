<div class="container">
<div class="divPanel page-content">

    <!--Edit Main Content Area here-->
    <div class="row-fluid">
        <div class="span12">
            <h1 id="titulos"><?php if(!$this->uri->segment(3)=='add'){?>Editar mi información<?php }else{ echo 'Crear usuario'; }?></h1>
    </div>
    <div class="row-fluid">
        <div class="span12">

<?php
echo $output;
?>
 </div>
   </div>
</div>
</div>
</div>
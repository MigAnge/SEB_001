<div class="container">
<div class="divPanel page-content">

    <!--Edit Main Content Area here-->
    <div class="row-fluid">
        <div class="span12">
            <h1 id="titulos">Instalaciones</h1>
            <p>! Te invitamos a conocer nuestras instalaciones ¡</p>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span12">
            <?php
            $data['imagenes'] = array(1 => 'ins.jpg',
                2 => 'ins2.jpg',
                3 => 'ins3.jpg',
                4 => 'ins4.jpg',
                5 => 'ins5.jpg',
                6 => 'ins6.jpg',
                7 => 'ins7.jpg',
                8 => 'ins8.jpg',
                9 => 'ins9.jpg',
                10 => 'ins10.jpg',
                11 => 'ins11.jpg');
            $this->load->view('template/listCarousel', $data);
            ?>
        </div>
        <div class="span11">
            <h2>Estamos mejorando para darte servicio de calidad</h2>
            <p>Estamos buscando la forma de mejorar la infraestructura de nuestra empresa, para garantizarte una gran comodidad a la hora de consumir tus alimentos y de esta forma, darte un servicio de mayor calidad</p>
        </div>
    </div>
</div>
</div>
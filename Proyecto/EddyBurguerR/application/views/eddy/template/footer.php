<?php

/**
 * footer para las vistas back-end
 *
 *  
 *@category EddyBurguer
 *@package EddyBurguerR
 *@subpackage views
 *@copyright Derechos reservados® Soft-pack 
 *@version 0.0.1
 *@link https://github.com/MigAnge/SEB_001/blob/master/Proyecto/EddyBurguerR/application/views/eddy/template/footer.php
 *@since File available since Release 0.0.1
*/

?>


<!-- footer content -->
<footer>
  <div class="pull-right">
    Eddy Burguer 2017
  </div>
  <div class="clearfix"></div>
</footer>
<!-- /footer content -->
</div>
</div>



<!-- jQuery -->
<script src="<?php echo base_url(); ?>vendors/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap -->
<script src="<?php echo base_url(); ?>vendors/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- FastClick -->
<script src="<?php echo base_url(); ?>vendors/fastclick/lib/fastclick.js"></script>
<!-- NProgress -->
<script src="<?php echo base_url(); ?>vendors/nprogress/nprogress.js"></script>
<!-- Chart.js -->
<script src="<?php echo base_url(); ?>vendors/Chart.js/dist/Chart.min.js"></script>
<!-- gauge.js -->
<script src="<?php echo base_url(); ?>vendors/bernii/gauge.js/dist/gauge.min.js"></script>
<!-- bootstrap-progressbar -->
<script src="<?php echo base_url(); ?>vendors/bootstrap-progressbar/bootstrap-progressbar.min.js"></script>
<!-- iCheck -->
<script src="<?php echo base_url(); ?>vendors/iCheck/icheck.min.js"></script>
<!-- Skycons -->
<script src="<?php echo base_url(); ?>vendors/skycons/skycons.js"></script>
<!-- Flot -->
<script src="<?php echo base_url(); ?>vendors/Flot/jquery.flot.js"></script>
<script src="<?php echo base_url(); ?>vendors/Flot/jquery.flot.pie.js"></script>
<script src="<?php echo base_url(); ?>vendors/Flot/jquery.flot.time.js"></script>
<script src="<?php echo base_url(); ?>vendors/Flot/jquery.flot.stack.js"></script>
<script src="<?php echo base_url(); ?>vendors/Flot/jquery.flot.resize.js"></script>
<!-- Flot plugins -->
<script src="<?php echo base_url() ?>js/admin/js/flot/jquery.flot.orderBars.js"></script>
<script src="<?php echo base_url() ?>js/admin/js/flot/date.js"></script>
<script src="<?php echo base_url() ?>js/admin/js/flot/jquery.flot.spline.js"></script>
<script src="<?php echo base_url() ?>js/admin/js/flot/curvedLines.js"></script>
<!-- jVectorMap -->
<script src="<?php echo base_url() ?>js/admin/js/maps/jquery-jvectormap-2.0.3.min.js"></script>
<!-- bootstrap-daterangepicker -->
<script src="<?php echo base_url() ?>js/admin/js/moment/moment.min.js"></script>
<script src="<?php echo base_url() ?>js/admin/js/datepicker/daterangepicker.js"></script>
<script src="<?php echo base_url(); ?>js/llenarSelect.js"></script>

<!-- Custom Theme Scripts -->
<script src="<?php echo base_url(); ?>build/js/custom.min.js"></script>

<!-- Flot -->
<script>
  $(document).ready(function() {
    var data1 = [
      [gd(2012, 1, 1), 17],
      [gd(2012, 1, 2), 74],
      [gd(2012, 1, 3), 6],
      [gd(2012, 1, 4), 39],
      [gd(2012, 1, 5), 20],
      [gd(2012, 1, 6), 85],
      [gd(2012, 1, 7), 7]
    ];

    var data2 = [
      [gd(2012, 1, 1), 82],
      [gd(2012, 1, 2), 23],
      [gd(2012, 1, 3), 66],
      [gd(2012, 1, 4), 9],
      [gd(2012, 1, 5), 119],
      [gd(2012, 1, 6), 6],
      [gd(2012, 1, 7), 9]
    ];
    $("#canvas_dahs").length && $.plot($("#canvas_dahs"), [
      data1, data2
    ], {
      series: {
        lines: {
          show: false,
          fill: true
        },
        splines: {
          show: true,
          tension: 0.4,
          lineWidth: 1,
          fill: 0.4
        },
        points: {
          radius: 0,
          show: true
        },
        shadowSize: 2
      },
      grid: {
        verticalLines: true,
        hoverable: true,
        clickable: true,
        tickColor: "#d5d5d5",
        borderWidth: 1,
        color: '#fff'
      },
      colors: ["rgba(38, 185, 154, 0.38)", "rgba(3, 88, 106, 0.38)"],
      xaxis: {
        tickColor: "rgba(51, 51, 51, 0.06)",
        mode: "time",
        tickSize: [1, "day"],
        //tickLength: 10,
        axisLabel: "Date",
        axisLabelUseCanvas: true,
        axisLabelFontSizePixels: 12,
        axisLabelFontFamily: 'Verdana, Arial',
        axisLabelPadding: 10
      },
      yaxis: {
        ticks: 8,
        tickColor: "rgba(51, 51, 51, 0.06)",
      },
      tooltip: false
    });

    function gd(year, month, day) {
      return new Date(year, month - 1, day).getTime();
    }
  });
</script>
<!-- /Flot -->

<!-- jVectorMap -->
<script src="<?php echo base_url() ?>js/admin/js/maps/jquery-jvectormap-world-mill-en.js"></script>
<script src="<?php echo base_url() ?>js/admin/js/maps/jquery-jvectormap-us-aea-en.js"></script>
<script src="<?php echo base_url() ?>js/admin/js/maps/gdp-data.js"></script>
<script>
  $(document).ready(function(){
    $('#world-map-gdp').vectorMap({
      map: 'world_mill_en',
      backgroundColor: 'transparent',
      zoomOnScroll: false,
      series: {
        regions: [{
          values: gdpData,
          scale: ['#E6F2F0', '#149B7E'],
          normalizeFunction: 'polynomial'
        }]
      },
      onRegionTipShow: function(e, el, code) {
        el.html(el.html() + ' (GDP - ' + gdpData[code] + ')');
      }
    });
  });
</script>
<!-- /jVectorMap -->

<!-- Skycons -->
<script>
  $(document).ready(function() {
    var icons = new Skycons({
        "color": "#73879C"
      }),
      list = [
        "clear-day", "clear-night", "partly-cloudy-day",
        "partly-cloudy-night", "cloudy", "rain", "sleet", "snow", "wind",
        "fog"
      ],
      i;

    for (i = list.length; i--;)
      icons.set(list[i], list[i]);

    icons.play();
  });
</script>
<!-- /Skycons -->

<!-- Doughnut Chart -->
<script>
  $(document).ready(function(){
    var options = {
      legend: false,
      responsive: false
    };

    new Chart(document.getElementById("canvas1"), {
      type: 'doughnut',
      tooltipFillColor: "rgba(51, 51, 51, 0.55)",
      data: {
        labels: [
          "Symbian",
          "Blackberry",
          "Other",
          "Android",
          "IOS"
        ],
        datasets: [{
          data: [15, 20, 30, 10, 30],
          backgroundColor: [
            "#BDC3C7",
            "#9B59B6",
            "#E74C3C",
            "#26B99A",
            "#3498DB"
          ],
          hoverBackgroundColor: [
            "#CFD4D8",
            "#B370CF",
            "#E95E4F",
            "#36CAAB",
            "#49A9EA"
          ]
        }]
      },
      options: options
    });
  });
</script>
<!-- /Doughnut Chart -->

<!-- bootstrap-daterangepicker -->
<script>
  $(document).ready(function() {

    var cb = function(start, end, label) {
      console.log(start.toISOString(), end.toISOString(), label);
      $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
    };

    var optionSet1 = {
      startDate: moment().subtract(29, 'days'),
      endDate: moment(),
      minDate: '01/01/2012',
      maxDate: '12/31/2015',
      dateLimit: {
        days: 60
      },
      showDropdowns: true,
      showWeekNumbers: true,
      timePicker: false,
      timePickerIncrement: 1,
      timePicker12Hour: true,
      ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
      },
      opens: 'left',
      buttonClasses: ['btn btn-default'],
      applyClass: 'btn-small btn-primary',
      cancelClass: 'btn-small',
      format: 'MM/DD/YYYY',
      separator: ' to ',
      locale: {
        applyLabel: 'Submit',
        cancelLabel: 'Clear',
        fromLabel: 'From',
        toLabel: 'To',
        customRangeLabel: 'Custom',
        daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        firstDay: 1
      }
    };
    $('#reportrange span').html(moment().subtract(29, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
    $('#reportrange').daterangepicker(optionSet1, cb);
    $('#reportrange').on('show.daterangepicker', function() {
      console.log("show event fired");
    });
    $('#reportrange').on('hide.daterangepicker', function() {
      console.log("hide event fired");
    });
    $('#reportrange').on('apply.daterangepicker', function(ev, picker) {
      console.log("apply event fired, start/end dates are " + picker.startDate.format('MMMM D, YYYY') + " to " + picker.endDate.format('MMMM D, YYYY'));
    });
    $('#reportrange').on('cancel.daterangepicker', function(ev, picker) {
      console.log("cancel event fired");
    });
    $('#options1').click(function() {
      $('#reportrange').data('daterangepicker').setOptions(optionSet1, cb);
    });
    $('#options2').click(function() {
      $('#reportrange').data('daterangepicker').setOptions(optionSet2, cb);
    });
    $('#destroy').click(function() {
      $('#reportrange').data('daterangepicker').remove();
    });
  });
</script>
<!-- /bootstrap-daterangepicker -->

<!-- gauge.js -->
<script>
  var opts = {
      lines: 12,
      angle: 0,
      lineWidth: 0.4,
      pointer: {
          length: 0.75,
          strokeWidth: 0.042,
          color: '#1D212A'
      },
      limitMax: 'false',
      colorStart: '#1ABC9C',
      colorStop: '#1ABC9C',
      strokeColor: '#F0F3F3',
      generateGradient: true
  };
  var target = document.getElementById('foo'),
      gauge = new Gauge(target).setOptions(opts);

  gauge.maxValue = 6000;
  gauge.animationSpeed = 32;
  gauge.set(3200);
  gauge.setTextField(document.getElementById("gauge-text"));
</script>
<!-- /gauge.js -->

<?php if(isset($tables) && $tables==true):?>
  <!-- Datatables -->
   <script src="<?php echo base_url() ?>vendors/datatables.net/js/jquery.dataTables.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-bs/js/dataTables.bootstrap.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-buttons-bs/js/buttons.bootstrap.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-buttons/js/buttons.flash.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-buttons/js/buttons.html5.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-buttons/js/buttons.print.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-fixedheader/js/dataTables.fixedHeader.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-keytable/js/dataTables.keyTable.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-responsive/js/dataTables.responsive.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-responsive-bs/js/responsive.bootstrap.js"></script>
   <script src="<?php echo base_url() ?>vendors/datatables.net-scroller/js/dataTables.scroller.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/jszip/dist/jszip.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/pdfmake/build/pdfmake.min.js"></script>
   <script src="<?php echo base_url() ?>vendors/pdfmake/build/vfs_fonts.js"></script>

   <!-- Custom Theme Scripts -->
   <script src="<?php echo base_url() ?>build/js/custom.min.js"></script>

   <!-- Datatables -->
   <script>
     $(document).ready(function() {
       var handleDataTableButtons = function() {
         if ($("#datatable-buttons").length) {
           $("#datatable-buttons").DataTable({
             dom: "Bfrtip",
             buttons: [
               {
                 extend: "copy",
                 className: "btn-sm"
               },
               {
                 extend: "csv",
                 className: "btn-sm"
               },
               {
                 extend: "excel",
                 className: "btn-sm"
               },
               {
                 extend: "pdfHtml5",
                 className: "btn-sm"
               },
               {
                 extend: "print",
                 className: "btn-sm"
               },
             ],
             responsive: true
           });
         }
       };

       TableManageButtons = function() {
         "use strict";
         return {
           init: function() {
             handleDataTableButtons();
           }
         };
       }();

       $('#datatable').dataTable();
       $('#datatable-keytable').DataTable({
         keys: true
       });

       $('#datatable-responsive').DataTable();

       $('#datatable-scroller').DataTable({
         ajax: "<?php echo base_url() ?>js/datatables/json/scroller-demo.json",
         deferRender: true,
         scrollY: 380,
         scrollCollapse: true,
         scroller: true
       });

       var table = $('#datatable-fixed-header').DataTable({
         fixedHeader: true
       });

       TableManageButtons.init();
     });
   </script>
   <!-- /Datatables -->
<?php endif; ?>

<?php if (isset($uf) && $uf == true): ?>
 <script>

 $('#imagen').change(function() {
   var filepath = this.value;
   var m = filepath.match(/([^\/\\]+)$/);
   var filename = m[1];
   //$('#imagenN').html(filename);
   document.form.imagenN.value=filename;

});

 </script>
 <script>
 function mostrarImagen(input) {
   if (input.files && input.files[0]) {
     var reader = new FileReader();
     reader.onload = function (e) {
       $('#mostrarImagen').attr('src', e.target.result);
     }
     reader.readAsDataURL(input.files[0]);
   }
}

$("#imagen").change(function(){
mostrarImagen(this);
imgm('activate');
});
</script>


<?php endif;?>


<!-- Custom Theme Scripts -->
<script src="<?php echo base_url() ?>build/js/custom.min.js"></script>
<script type="text/javascript" src="<?php echo base_url(); ?>js/validator.min.js">

</script>
<?php if(isset($js_files)){
  foreach($js_files as $js): ?>
    <script src="<?php echo $js; ?>"></script>
<?php endforeach; }?>

<script src="<?php echo $theme_path.'/flexigrid/js/jquery.form.js';?>"></script>
<script src="<?php echo $theme_path.'/jquery_plugins/jquery.form.min.js';?>"></script>
<script src="<?php echo $theme_path.'/flexigrid/js/flexigrid-add.js'?>"></script>

</body>

</html>

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .

//= require bootstrap

function parseBool(val) { return val === true || val === "true" }

function confirmation(text){
    resp = window.confirm(text);
    return resp;
  }

function toggle_power(option){  //turn camera on or off
  $.ajax({
      url: "/monitorfire/2/?power="+option
        })
};


$( document ).ready(function() {

    $('.monitor_toggle').on("click", function(){ //section to save alerts
      console.log("click works");
      var monId = $(this).attr('id');
      var monVal = $(this).attr('value')
      var cam_id = $("#cam_id_").attr('value')
    $.ajax({
        url: "/monitor_" + monVal + "/" + cam_id
    })
      .done(function() {
        $('#monitor_status').text("The monitor is set to: " + monVal.toUpperCase());
        $('#monitor_status').css("display", "block");
      })
    });

    $('.cams_power').on("click", function(){  // turn power off and on
      var camspower = $(this).attr('value');
      var option = parseBool(camspower) //turn string true/false into bool true/false
      console.info('option is ' + option);



      if(option){ user_option = "ON" } else { user_option = "OFF"};
      console.log('user_option is ' + user_option);
      user_confirm = confirmation('You are about to turn the camera ' + user_option + '. Click ok to confirm and proceed.')
      console.log('user_confirm is ' + user_confirm);


      if(user_option == "ON" && user_confirm === true){
        var ref = new Firebase('wss://developer-api.nest.com');
        toggle_power(option);
        $('#cam_status').text("Camera status changed to "+ user_option, "block");
        $('#cam_status').css("display", "block");
      } else if (user_option == "OFF" && user_confirm === true) {
        toggle_power(option);
        $('#cam_status').text("Camera status changed to "+user_option, "block");
        $('#cam_status').css("display", "block");
      } else {
        $('#cam_status').text("No changes have been made to the camera's power status. ", "block");

        //insert firebase call to get real camera status
        $('#cam_status').append("\nCamera status is: " + user_option);
        $('#cam_status').css("display", "block");
      };
    })

    $('.alert_photos').on("click", function() { // toggle animated_url which is hidden below thumbnail iage
       var id_num = $(this).closest('div').attr('id');
        $('#' + id_num +'_imageholder').toggle();
        $('#' + id_num ).toggle();
    });

    $('.animated_display').on("click", function() { // toggle animated_url which is hidden below thumbnail iage
      //  var id_num = $(this).closest('div').attr('id');
       var id_num = $(this).prev().attr('id');
        $('#' + id_num +'_imageholder').toggle();
        $('#' + id_num ).toggle();

    });


    // get latest alert without screen refresh. either alert user to refresh or update page with prepend.
    function checkForNewAlerts(){
      var ref = new Firebase("https://blistering-heat-6382.firebaseio.com/alerts");
      ref.on ("child_changed", function(snapshot) {
        var resp = snapshot.val();
          $( '<img src="'+ resp.image_url+ '" class="alert_photos" <br><br>' ).prependTo( '#alerts_container' );
          $( '<p>A new image is available. Refresh page to view details</p>' ).prependTo( '#alerts_container' );
          $('.refresh_btn').css("display", "block");
          $('.refresh_btn').css("color", "red");
          console.log('new alert! : '+ resp.last_alert);
          // ref.remove(); //can remove it, but since this data is in 'alerts' branch, no need to.
        }, function (errorObject) {
        console.log("The read failed: " + errorObject.code);
        });
      };
      checkForNewAlerts();

      function checkStatus(){
        var ref2 = new Firebase("https://blistering-heat-6382.firebaseio.com/monitor");
        ref2.on ("child_changed", function(snapshot) {
          var status = snapshot.val();
            // $( '</div id="status_btn">Alerts being saved? ' + status.save_alerts + ' <br><br>' ).prependTo( '#alerts_container' );
            var power = "";
            var powerstatus = (status.power === true) ? power ='ON': power = 'OFF';
            console.log(powerstatus);
            if(powerstatus == 'ON') {
              $('#cam_status').html('</div id="status_btn">Camera\'s Power is ' + power + '</div>');
              $('#cam_status').css("display", "block");
            }

            $('#alert_status').html('<div id="status_btn">Alerts being saved? ' + status.save_alerts.toUpperCase() + '</div>');
            $('#cam_status').css("display", "block");

            $('.refresh_btn').css("color", "red");
            console.log('do we save alerts? : '+ status.save_alerts);
            console.log('name is is: '+ status.user);
            console.log('name is is: '+ status.power); // power will be true/false
            // console.log(typeof(status.power));  // confirmed boolean if true, not 'true'
          }, function (errorObject) {
          console.log("The read failed: " + errorObject.code);
          });
        };
        checkStatus();
});

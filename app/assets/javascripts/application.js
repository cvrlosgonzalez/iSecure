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
  console.log('in toggle_power: options is => ' + option);
  $.ajax({
      url: "/monitorfire/2/?power="+option
  })
    .done(function() {
      if(option){ status = 'on'} else {status = 'off'}
      $('#cam_status').text("Camera\'s Power : " + status.toUpperCase());
      $('#cam_status').css("display", "block");
      console.log('STATUS >>> ' + status);
      // $('#cam_power_' + status).css("checked", "checked")
      $('#monitor_off').css("checked", "checked")
      if (option == true) {
        $('#cam_status').css("background-color", "green");
      } else {
        $('#cam_status').css("background-color", "red");
        $('#text_status').css("background-color", "red");
        set_monitor_to_off();
        set_text_alerts_to_off();
      }
    })
};

function set_monitor_to_off() {
  var cam_id = $("#cam_id_").attr('value')
  $.ajax({
      url: "/monitor_off/" + cam_id
  })
};

function set_text_alerts_to_off() {
  var cam_id = $("#cam_id_").attr('value')
  var page_name = $("#page_name_").attr('value')
  if(page_name == "cam_page"){
    $.ajax({
        url: "/textfire_off/" + cam_id
    })
  }
};

function status_check() {
  var cam_id = $("#cam_id_").attr('value')
  $.ajax({
    url: "/status_check/" + cam_id
  })
};

function delete_image(del_id) {
  //if animated_url is displayed
    if ( $('#' + del_id + '_imageholder').css('display') == 'block' ){
        $('#'+ del_id + '_imageholder').slideToggle( "slow");
        $('#'+ del_id ).slideToggle( "slow");
        $('#title_' + del_id).slideToggle( "slow");
        $('#' + del_id).css("display","none");
    } else {
  // if image_url is displayed
    $('#title_' + del_id).slideToggle( "slow");
    $('#'+ del_id ).slideToggle( "slow", function() {
      $('#' + del_id).css("display","none");
      $('#' + del_id + '_imageholder').css("display","none");
    });
  };
  $.ajax({
    url: "/delete_alert/" + del_id
  })
};
//----------document ready below------------------------------

$( document ).ready(function() {
//make sure we are on the cams page to set texts to off.
var page_name = $("#page_name_").attr('value')
if(page_name == "cam_page"){
  console.log("this is the cam page!!!");
  $('#texting').css("display", "none");
  status_check(); //check firebase to update status of power, alerts and texts
  set_text_alerts_to_off();
}
// $('#monitor_off').prop('checked', true);
// set_monitor_to_off();

// turn power off and on
    $('.cams_power').on("click", function(){
      var camspower = $(this).attr('value');
      var option = parseBool(camspower) //turn string true/false into bool true/false
      console.info('power option selected is: ' + option);
      if(option){ user_option = "ON" } else { user_option = "OFF"};
      console.log('after IF statement, user_option is ' + user_option);

      if(user_option == "ON"){
        var ref = new Firebase('wss://developer-api.nest.com');
        toggle_power(option);
        $('#monitor_off').prop('checked', true); //alerts will be off when power is turned on.

      } else if (user_option == "OFF") {
        var ref = new Firebase('wss://developer-api.nest.com');
        toggle_power(option);
        //show alerts as off
        $('#alert_status').text("Alerts being saved? NO");
        $('#alert_status').css("background-color", "red");
        $('#alert_status').css("display", "block");
        //show text alerts as off
        $('#text_status').text("Text message status: " + user_option );
        $('#text_status').css("background-color", "red");
        $('#text_status').css("display", "block");
      } else {
        $('#cam_status').text("No changes have been made to the camera's power status. ", "block");
      };
    })

    //alert saving (aka monitor/monitoring) section turn on/off
        $('.monitor_toggle').on("click", function(){
          console.log("click works");
          var monId = $(this).attr('id');
          var monVal = $(this).attr('value')
          var cam_id = $("#cam_id_").attr('value')
        $.ajax({
            url: "/monitor_" + monVal + "/" + cam_id
        })
          .done(function() {
    console.log('monVal is::::' + monVal);
            monitor_status = ""
            if(monVal == 'on'){monitor_status = 'YES'} else {monitor_status = 'NO'}
            $('#alert_status').text("Alerts being saved?: " + monVal.toUpperCase());
            $('#alert_status').css("display", "block");
            $('#monitor_' + monVal).prop('checked', true);

            if (monVal == 'on') {
              $('#alert_status').css("display", "block");
              $('#alert_status').css("background-color", "green");
            } else {
              $('#alert_status').css("background-color", "red");
              set_monitor_to_off();
              set_text_alerts_to_off();
              status_check();
            }
          })
        });


// ---- toggle text alerts - do you want to get a text message for alerts?
      $('.text_alert_toggle').on("click", function(){
          var text_option = $(this).attr('value');
          var cam_id = $("#cam_id_").attr('value')
          console.log('cam_id ' + cam_id);
          console.log('text_option ' + text_option);
          // var text_bool = parseBool(text_option) //turn string true/false into bool true/false
          // if(text_bool){ text_alerts_option = "on" } else { text_alerts_option = "off"};

// call route to hit text controller to set texts to on/off
          $.ajax({
              url: "/textfire_" + text_option + "/" + cam_id
          })
            .done(function() {
              //update the screen
              console.log('text_option is::::' + text_option);
              $('#text_status').text("Text message status: " + text_option.toUpperCase());
              $('#text_status').css("display", "block");
              // $('#monitor_' + monVal).css("selected", "selected")
              if (text_option == 'on') {
                $('#text_status').css("background-color", "green");
                $('#text_alert_on').prop('checked', true);
              } else {
                $('#text_alert_off').prop('checked', true);
                $('#text_status').css("background-color", "red");
              }
            })
//---- end text alerts
       });

// PHOTOS TO DISPLAY WHEN ALERTS ARE ON
// toggle animated_url which is hidden below thumbnail image
    $('.alert_photos').on("click", function() {
       var id_num = $(this).closest('div').attr('id');
        $('#' + id_num +'_imageholder').toggle();
        $('#' + id_num ).toggle();
    });
// toggle animated_url which is hidden below thumbnail image
    $('.animated_display').on("click", function() {
      //  var id_num = $(this).closest('div').attr('id');
       var id_num = $(this).prev().attr('id');
        $('#' + id_num +'_imageholder').toggle();
        $('#' + id_num ).toggle();

    });

    // add the photos to the page automagically
    function checkForNewAlerts(){
      var ref = new Firebase("https://blistering-heat-6382.firebaseio.com/alerts/");
      ref.on ("child_changed", function(snapshot) {
        var resp = snapshot.val();

        var theLastAlertDiv =  $( "#alerts_container div:first" ).attr('id');
        var newDivID = theLastAlertDiv + 1;
        var numDiv = parseInt(newDivID, 10);
        var numDiv = numDiv + 1;
        console.dir('theDiv is '+ newDivID);
        console.dir('numDiv is '+ numDiv);
        var randomNum = Math.floor(Math.random() * 200);
        console.log('Randon num is >' + randomNum);
        var theTime = Math.round(new Date().getTime()/1000);
         console.log(theTime);
// display image and hide anumated image. i dont think this is working because DOM has been rendered, so nothing is bound to this element.
        // $( '<div id="' + newDivID + '_imageholder" class="animated_display" style="display:none"> <img src="' + resp.animated_url + '" alt="" class="img-ani"></div>').prependTo( '#alerts_container');
        $( '<small><a href="#" onClick="window.location.reload()"> New Alert! click here to refresh page for more detail.</a> <br> ' + resp.last_alert + '<br></small> <div id="' + newDivID + '" style="display:block;>" ><img src="' + resp.animated_url + '" alt="" class="alert_photos" /></div>').prependTo( '#alerts_container');
        // $( '<small> New Alert! <br></small> <div id="' + newDivID + '" style="display:block;>" ><img src="' + resp.image_url + '" alt="" class="alert_photos" /></div>').prependTo( '#alerts_container');

          // $( '<img src="'+ resp.image_url + '" class="alert_photos"> <br><br>' ).prependTo( '#alerts_container' );
          // $( '<p>A new image is available. Refresh page to view details</p>' ).prependTo( '#alerts_container' );
          $('.refresh_btn').css("display", "block");
          $('.refresh_btn').css("color", "red");
          console.log('new alert! : '+ resp.last_alert);
          // ref.remove(); //can remove it, but since this data is in 'alerts' branch, no need to.
        }, function (errorObject) {
        console.log("The read failed: " + errorObject.code);
        });
      };


// get Firebase status to update screen whenever a change is made.
// changes to Firebase are triggered by turning power OR alerts OR texts on/off.
      function checkStatus(){
        var ref2 = new Firebase("https://blistering-heat-6382.firebaseio.com/monitor");
// get changes to anything in the status section
        ref2.on ("child_changed", function(snapshot) {
          var status = snapshot.val();
            // $( '</div id="status_btn">Alerts being saved? ' + status.save_alerts + ' <br><br>' ).prependTo( '#alerts_container' );
            var power = "";
            var powerstatus = (status.power === true) ? power ='ON': power = 'OFF';
// power status
            console.log("power is >: " + power);
            $('#cam_status').html('<div id="status_btn">Camera\'s Power : ' + power + '</div>');
            $('#cam_status').css("color","white")
            $('#cam_status').css("display", "block");

            if(power == 'ON') {
              $('#cam_status').css("background-color","green");
              $('#monitor_off').prop('checked', true);  //.css("checked", "checked") //default to monitor off!
              $('#alerts').css("display","block");
              $('#cam_power_true').prop('checked', true);

            } else if (power == 'OFF') {
              $('#cam_status').css("background-color","red");
              $('#cam_power_false').prop('checked', true);

              //if power is off, no alerts and no texts, both are unavailable as options
              $('#alerts').css("display","none");
              $('#texting').css("display", "none");

            }
// alerts status
          console.log("alerts >: " + alerts);
            var alerts = "";
            var alertstatus = (status.save_alerts == "yes") ? alerts ='ON': alerts = 'OFF';
            console.log("alerts >: " + alerts);
            $('#alert_status').html('<div id="status_btn">Alerts being saved? ' + alertstatus + '</div>'); // status.save_alerts.toUpperCase() + '</div>');
            $('#alert_status').css("color","white");
            $('#cam_status').css("display", "block");
            $('#cam_power_true').prop('checked', true);


            if(alerts == 'ON') {
              $('#alert_status').css("background-color","green  ");
              $('#alert_status').css("display", "block");
              // $('#alerts').css("display", "block");
              $('#texting').css("display", "block");
              $('#monitor_on').prop('checked', true);
              $('#monitor_off').prop('checked', false);
              console.log('alerts setcion');
              status_check();

            } else if (alerts == 'OFF'){
              $('#alert_status').css("background-color","red");
              $('#alert_status').css("display", "none");
              $('#texting').css("display", "none");
              $('#monitor_off').prop('checked', true);
              status_check();

            }

// text status
            var texts = status.text.toUpperCase();
            // var alertstatus = (status.text == "yes") ? alerts ='ON': alerts = 'OFF';
            console.log("texts >: " + texts);
            $('#text_status').html('<div id="status_btn">Text message status ' + status.text.toUpperCase() + '</div>');
            // $('#text_status').css("background-color","red");
            $('#text_status').css("color","white");
            $('#text_status').css("display", "block");
            //if text messages are on, be sure to display alert and power (cam) status
            $('#alert_status').css("display", "block");
            $('#cam_status').css("display", "block");

            if(texts == 'ON') {
              $('#text_status').css("background-color","green  ");
              $('#monitor_on').prop('checked', true);

            } else if (texts == 'OFF'){
              $('#text_status').css("background-color","red");
              $('#text_alert_off').prop('checked', true);

            }

            console.log('do we save alerts? : '+ status.save_alerts);
            console.log('name is is: '+ status.user);
            console.log('name is is: '+ status.power); // power will be true/false
          }, function (errorObject) {
          console.log("The read failed: " + errorObject.code);
          });

        };

        var page_name = $("#page_name_").attr('value')
        if(page_name == "cam_page"){
          console.log("ready to check for alerts and status");
          checkForNewAlerts();
          checkStatus();
        }

        $('.delete_images').on("click", function(event) {
            var id = $(this).attr('id');
            var id_del = id.replace(/del_/i, '');
            console.log('id to delete is '+ id_del);
            delete_image(id_del);
        });
});

  // function start() {
  //   // set_monitor_to_off();
  // }
  // window.onload = start;

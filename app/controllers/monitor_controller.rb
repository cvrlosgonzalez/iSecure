class MonitorController < ApplicationController

attr_accessor :power, :id

    def monitor_on
      p "Monitor is ON from method!!"
      @monitor = Cam.find(params[:id])
      @monitor.update(monitoring: true)
      monitoring = Firebase::Client.new("https://blistering-heat-6382.firebaseio.com/")
      response = monitoring.update("monitor/status", {:save_alerts => 'yes', :check => 'on'})
      redirect_to cams_path
    end

    def monitor_off
      p "Monitor is OFF from method!!"
      @monitor = Cam.find(params[:id])
      @monitor.update(monitoring: false)
      monitoring = Firebase::Client.new("https://blistering-heat-6382.firebaseio.com/")
      response = monitoring.update("monitor/status", {:save_alerts => 'no', :check => 'off'})
      redirect_to cams_path
    end

    def edit
      raise
      @cameras = cams.find_by(1)
    end

    def show
      power= params[:power]
      id= params[:id]
      firebase(power, id)
    end

    def firebase(power_on, id)
      power_on_boolean = (power_on == "true") # power_on is initially a string, returning boolean here
      # send request to nest cam to power on or off.
      firebase = Firebase::Client.new('https://developer-api.nest.com', ENV['NESTTOKEN']);
      response = firebase.update("devices/cameras/VzE0LkDkTwboTLgNR0kGvb0k6laaMeWdPTPxP9MDOU1BEsxNcUT72g", { :is_streaming => power_on_boolean })
      # require 'pp'
      # pp response.body
      # add power status to firebase so cam page can display, in case user cancels out of a power state change.
      power_status = Firebase::Client.new("https://blistering-heat-6382.firebaseio.com/")
      response = power_status.update("monitor/status", {:power => power_on_boolean, :save_alerts => "no"})
      redirect_to cam_path
    end
end

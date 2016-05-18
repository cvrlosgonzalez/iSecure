class MonitorController < ApplicationController

attr_accessor :power, :id

    def monitor_on
      p "Monitor is ON from method!!"
      @monitor = Cam.find(params[:id])
      @monitor.update(monitoring: true)
      redirect_to cams_path
    end

    def monitor_off
      p "Monitor is OFF from method!!"
      @monitor = Cam.find(params[:id])
      @monitor.update(monitoring: false)
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
      # require 'pp'
      firebase = Firebase::Client.new('https://developer-api.nest.com', ENV['NESTTOKEN']);
      response = firebase.update("devices/cameras/VzE0LkDkTwboTLgNR0kGvb0k6laaMeWdPTPxP9MDOU1BEsxNcUT72g", { :is_streaming => power_on_boolean })
      # pp response.body
      redirect_to cam_path
    end
end

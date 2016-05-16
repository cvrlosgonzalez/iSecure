class MonitorController < ApplicationController

    def monitor_on
      p "Monitor is ON from method!!"
      redirect_to cams_path
    end

    def monitor_off
      p "Monitor is OFF from method!!"
      redirect_to cams_path
    end




end

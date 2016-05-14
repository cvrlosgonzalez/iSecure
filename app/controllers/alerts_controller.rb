class AlertsController < ApplicationController
  def index
    @alerts = Alert.all
  end

  def new
    @alerts = Alert.new
  end


  def poll_alert

  end

  def compare_alert
    
  end


end

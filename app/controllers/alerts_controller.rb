class AlertsController < ApplicationController
  def index
    @alerts = Alert.all
  end

  def new
    @alerts = Alert.new
  end
end

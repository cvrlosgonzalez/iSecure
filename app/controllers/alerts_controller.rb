class AlertsController < ApplicationController
attr_accessor :animated_url, :image_url, :start_time


  def index
    @alerts = Alert.all
  end

    require 'pp'


  def initialize(animate, image, start)
    @animated_url = animate
    @image_url = image
    @start_time = start
    p "end if init"
  end


end

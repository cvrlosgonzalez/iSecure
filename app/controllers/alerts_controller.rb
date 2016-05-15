class AlertsController < ApplicationController
attr_accessor :animated_url, :image_url, :start_time

require 'pp'

  def index
    @alerts = Alert.all
  end

  def initialize(animate, image, start)
    @animated_url = animate
    @image_url = image
    @start_time = start
    p "end if init"
  end

  def create

  end



end

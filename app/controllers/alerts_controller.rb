class AlertsController < ApplicationController
attr_accessor :animated_url, :image_url, :last_event

require 'pp'

  def index
    @alerts = Alert.all
  end

  # def initialize(animate, image, start)
  #   @animated_url = animate
  #   @image_url = image
  #   @last_event = start
  #   p "end if init"
  # end

  def new
       @alert = Alert.new
    end

  def delete
    id_del = params[:id]
    del = Alert.find(id_del).destroy
    p "in delete controller, params is #{id_del}"
    p "in delete controller,items is #{del.id}"
    redirect_to cams_path
  end

  def create
    @user = current_user
    @alert = Alert.new(alert_params)

    respond_to do |format|
      if @alert.save

        PostMailer.alert_created(@user).deliver
        # format.html { redirect_to @alert, notice: 'Alert was successfully created.' }
        # format.json { render :show, status: :created, location: @alert}
      else
        format.html { render :new }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end

  end

end

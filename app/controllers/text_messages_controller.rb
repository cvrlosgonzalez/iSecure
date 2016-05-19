class SendTextController < ApplicationController

    # twilio account information
    TWILIO_NUMBER = "+17733624308"
    ACCOUNT_SID = 'AC66fe222ac78b6a424d42577aca96424a'
    AUTH_TOKEN = '43a273da95bf36bc354e99ea131bda3d'

    # GET /text_messages/new
    def new
      @text_message = TextMessage.new
      render :new
    end

    # POST /text_messages
    def create
      @text_message = TextMessage.new(params[:text_message])

      if @text_message.valid?

        successes = []
        errors = []
        numbers = @text_message.numbers_array
        account = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN).account
        numbers.each do |number|

          logger.info "sending message: #{@text_message.message} to: #{number}"

          begin
            account.sms.messages.create(
                :from => TWILIO_NUMBER,
                :to => "+1#{number}",
                :body => @text_message.message
            )
            successes << "#{number}"
          rescue Exception => e
            logger.error "error sending message: #{e.to_s}"
            errors << e.to_s
          end
        end

        flash[:errors] = errors
        flash[:successes] = successes
        if (flash[:errors].any?)
          render :action => :status, :status => :bad_request
        else
          render :action => :status
        end

      else
        render :action => :new, :status => :bad_request
      end
    end

end

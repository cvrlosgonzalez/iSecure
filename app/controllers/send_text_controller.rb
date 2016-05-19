class SendTextController < ApplicationController
  def index
  end

  def send_text_message
    number_to_send_to = "3054316702"
    puts "Hello! Sending text"
    twilio_sid = "AC66fe222ac78b6a424d42577aca96424a"
    twilio_token = "43a273da95bf36bc354e99ea131bda3d"
    twilio_phone_number = "7733624308"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => "This is an message. It gets sent to #{number_to_send_to}"
    )
  end
end

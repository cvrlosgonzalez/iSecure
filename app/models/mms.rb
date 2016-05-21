class Mms

  def self.send_text(animated_url,phone)
    p "inside sent text method #{@alert}"
    @client = Twilio::REST::Client.new "AC66fe222ac78b6a424d42577aca96424a", "43a273da95bf36bc354e99ea131bda3d"
    @client.messages.create(
        from: '+17733624308',
        to: "+1#{phone}",
        body: 'Alert notification!',
        media_url: animated_url
      )

    p "leaving send text"
    end


    # media_url: @alert.last.animated_url
end

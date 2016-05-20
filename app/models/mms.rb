class Mms

  def self.send_text
    p "inside of Text messages create"
    @client = Twilio::REST::Client.new "AC66fe222ac78b6a424d42577aca96424a", "43a273da95bf36bc354e99ea131bda3d"
    @client.messages.create(
        from: '+17733624308',
        to: '+13054316702',
        body: 'Alert notification!',
        media_url: @alert.last.animated_url
      )
  end


end

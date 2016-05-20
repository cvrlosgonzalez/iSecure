class Mms

  def self.send_text
    p "inside of Text messages create"
    @client = Twilio::REST::Client.new "AC66fe222ac78b6a424d42577aca96424a", "43a273da95bf36bc354e99ea131bda3d"
    @client.messages.create(
        from: '+17733624308',
        to: '+15613240400',
        body: 'Alert notification!',
        media_url: 'https://www.dropcam.com/api/wwn.get_animated_image/CjZWekUwTGtEa1R3Ym9UTGdOUjBrR3ZiMGs2bGFhTWVXZFBUUHhQOU1ET1UxQkVzeE5jVVQ3MmcSFnBJdnR3aFdKdjRMb2NKUnp0dk40MlEaNlBsTDNsTG5pRkpZNzJsQmo4dnZEZ2FhcU1kdXIzNXF0OXplaXNDZ0NURndYVXVaSmotZ2U5UQ/729THRj2FloJyQmptfNv47oX1PCGFpMl?auth=c.nzBlvHnxsPsoFsDcnm5MeqiZAVLzBUQZoiXuagOBg2iqrws25pfNWmnS7tYNVombU2Isz5q9pQHBtYmjXEELc9ZzoOQR4q3OIhm1FOMKc1TJSMZ2inVcrDJK430ovvvaquBDiURKXUuUQfBr'
      )
  end


end

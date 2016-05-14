class Alert < ActiveRecord::Base
  belongs_to :cam

require 'httparty'
require 'pp'

def url
  url = "https://developer-api.nest.com/"
end

def compare_alert

end

def camera_id
  camera_id = "VzE0LkDkTwboTLgNR0kGvb0k6laaMeWdPTPxP9MDOU1BEsxNcUT72g"
end



# removed this from below..  "Accept"=> "text/event-stream",

response = HTTParty.get(url, headers: {
    "Authorization"=> "Bearer c.nzBlvHnxsPsoFsDcnm5MeqiZAVLzBUQZoiXuagOBg2iqrws25pfNWmnS7tYNVombU2Isz5q9pQHBtYmjXEELc9ZzoOQR4q3OIhm1FOMKc1TJSMZ2inVcrDJK430ovvvaquBDiURKXUuUQfBr"
    }
 )

pp response["devices"]["cameras"][camera_id]["last_event"]["start_time"]
pp response["devices"]["cameras"][camera_id]["last_event"]["animated_image_url"]
pp response["devices"]["cameras"][camera_id]["last_event"]["image_url"]
pp response["devices"]["cameras"][camera_id]["last_event"]["start_time"][(1..10)]


pp response





end

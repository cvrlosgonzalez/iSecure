require 'pp'
camera_id = "VzE0LkDkTwboTLgNR0kGvb0k6laaMeWdPTPxP9MDOU1BEsxNcUT72g"
animated_url = ""
image_url = ""

def animated_url
  response["data"]["devices"]["cameras"][camera_id]["last_event"]["animated_image_url"]
end

namespace :nest do
  desc "monitor nest endpoint"
  task monitor: :environment do

    EM.run do
      source = EM::EventSource.new("https://developer-api.nest.com/",
      nil,
      {'Authorization' => PASTE_HERE })
      source.on('put') do |message|
        # puts "PUT message"
        response = JSON.parse(message)
        puts "*"*100
        # pp response
        animated_url = response["data"]["devices"]["cameras"][camera_id]["last_event"]["animated_image_url"]
        image_url = response["data"]["devices"]["cameras"][camera_id]["last_event"]["image_url"]
        start_time = response["data"]["devices"]["cameras"][camera_id]["last_event"]["start_time"] #[(0..9)]
        @alert = AlertsController.new(animated_url,image_url,start_time)
        p @alert
        puts "*"*100
      end

      source.error do |err|
        puts err
      end

      source.start
    end

  end

end

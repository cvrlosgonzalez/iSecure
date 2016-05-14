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
      {'Authorization' => "Bearer #{ENV['NESTTOKEN']}" })
      source.on('put') do |message|
        # puts "PUT message"
        response = JSON.parse(message)
        puts "*"*100
        # pp response
        animated_url = response["data"]["devices"]["cameras"][camera_id]["last_event"]["animated_image_url"]
        image_url = response["data"]["devices"]["cameras"][camera_id]["last_event"]["image_url"]
        start_time = response["data"]["devices"]["cameras"][camera_id]["last_event"]["start_time"] #[(0..9)]
        @alert = AlertsController.new(animated_url,image_url,start_time)
        p @alert.start_time
        p @alert.animated_url
        p @alert.image_url
        # atert condition here to compare @alert.start_time  with the last Alert.
        # if it matches (which is likely will each time we start rake nest:monitor) the do nothing
        # if it's not matching (maybe also greater than 30 secondes or 1 or 2 minutes?) then save it. We can try different settings.
        # not matching, call method in controller to save the record.
        puts "*"*100
      end

      source.error do |err|
        puts err
      end

      source.start
    end

  end

end

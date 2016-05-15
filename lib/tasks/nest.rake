require 'pp'
camera_id = "VzE0LkDkTwboTLgNR0kGvb0k6laaMeWdPTPxP9MDOU1BEsxNcUT72g"
# animated_url = ""
# image_url = ""
counter = 0

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
        # maybe call a compare method here.. (that will get Alerts.last and compare)
        # if its different then call a create method.. and rather then do .new below, it should be a call to 'create'
        @alert = AlertsController.new(animated_url,image_url,start_time)
        # p stuff to console to see values..
        p "Alert time #{@alert.start_time}"
        p "Animated URL #{@alert.animated_url}"
        p "image url #{@alert.image_url}"
        p "the last prior alert from db is #{Alert.last.last_event}"
        p "the current alert is #{@alert.start_time}"
        p "@alert.start time inspect: #{@alert.start_time.inspect}"
        p "Alert.last.last_event #{Alert.last.last_event.inspect}"
        p "@alert.start time class: #{@alert.start_time.class}"
        p "let's compare using .eql, start time on left,last event on right"
        p @alert.start_time.eql? Alert.last.last_event
        counter = counter + 1
                  # last = Alert.last.last_event
                  # p "the last alert time was : #{last}"
        # if @alert.start_time = Alert.last.last_event  (This isn't working. always saying the the same and not prompting to save)
        
        if @alert.start_time.eql? Alert.last.last_event
          p "it's the same alert number -#{counter}"
        else
          p "it's a new alert number-#{counter}, TIME TO SAVE IT!!"
        end
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

require 'pp'
# camera_id = "VzE0LkDkTwboTLgNR0kGvb0k6laaMeWdPTPxP9MDOU1BEsxNcUT72g"
counter = 0

# def animated_url
#   response["data"]["devices"]["cameras"][camera_id]["last_event"]["animated_image_url"]
# end

namespace :nest do
  desc "monitor nest endpoint"
  task monitor: :environment do

    EM.run do
      source = EM::EventSource.new("https://developer-api.nest.com/",
      nil,
      {'Authorization' => "Bearer #{ENV['NESTTOKEN']}" }) #nest token in USer table
      source.on('put') do |message|
        # puts "PUT message"
        response = JSON.parse(message)
        puts "*"*100
        puts "-----=================== RAKE TAKS HAS BEEN INITIATED ================------"
        puts "*"*100
        # pp response
        cameras = response["data"]["devices"]["cameras"]
        cameras.each do |api_name , val|
          cam = Cam.find_or_create_by(api_name: api_name)

          last_event = val["last_event"]["start_time"] #[(0..9)]
          animated_url = val["last_event"]["animated_image_url"]
          image_url = val["last_event"]["image_url"]
        end
        # maybe call a compare method here.. (that will get Alerts.last and compare)
        # if its different then call a create method.. and rather then do .new below, it should be a call to 'create'
        # @alert = AlertsController.new(animated_url,image_url,start_time)
        # @alert = Alert.create(animated_url: animated_url, image_url: image_url, last_event: start_time)
        # p stuff to console to see values..
#-------
        # p "Alert time #{@alert.last_event}"
        # p "Animated URL #{@alert.animated_url}"
        # p "image url #{@alert.image_url}"
        # p "the last prior alert from db is #{Alert.last.last_event}"
        # p "the current alert is #{@alert.last_event}"
        # p "@alert.start time inspect: #{@alert.last_event.inspect}"
        # p "Alert.last.last_event #{Alert.last.last_event.inspect}"
        # p "@alert.start time class: #{@alert.last_event.class}"
        # p "let's compare using .eql, start time on left,last event on right"
#-------
        # p @alert.last_event.eql? Alert.last.last_event
        p last_event.eql? Alert.last.last_event
        counter = counter + 1
                  # last = Alert.last.last_event
                  # p "the last alert time was : #{last}"
        # if @alert.last_event = Alert.last.last_event  (This isn't working. always saying the the same and not prompting to save)
        p "-----monitor_toggle start-----"
        p @monitoring
        if @monitoring
          "monitoring is: #{@monitoring}"
        end
        p "-----monitor_toggle end -----"

        if last_event.eql? Alert.last.last_event
          p "it's the same alert number -#{counter}"
        else
          p "it's a new alert number-#{counter}, TIME TO SAVE IT!!"
          @alert = Alert.create(animated_url: animated_url, image_url: image_url, last_event: last_event, cam:Cam.first)
        end
        # atert condition here to compare @alert.last_event  with the last Alert.
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

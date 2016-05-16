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
        puts "-----=================== RAKE TASK ================------"
        puts "*"*100
        # pp response
        cameras = response["data"]["devices"]["cameras"]
        cameras.each do |api_name , val|
          cam = Cam.find_or_create_by(api_name: api_name) # cam will be a cam object which happens to have an id.
            #later on it will save the id when we do cam:cam, this is based on rails convention.
            #if the api_name (which is a unique camera ID) doesn't exist, it will be created.
            #if the api_name does exist then the cam object is returned, which actually happens either way
          last_event = val["last_event"]["start_time"] #[(0..9)]
          animated_url = val["last_event"]["animated_image_url"]
          image_url = val["last_event"]["image_url"]

          p last_event.eql? Alert.last.last_event
          counter = counter + 1

          if last_event.eql? Alert.last.last_event
            p "it's the same alert number -#{counter}"
          else
            p "it's a new alert number-#{counter}, TIME TO SAVE IT!!"
            @alert = Alert.create(animated_url: animated_url, image_url: image_url, last_event: last_event, cam:cam)
          end

          puts "*"*100
        end

      end

      source.error do |err|
        puts err
      end

      source.start
    end

  end

end

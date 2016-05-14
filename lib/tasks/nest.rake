require 'pp'

namespace :nest do
  desc "monitor nest endpoint"
  task monitor: :environment do

    EM.run do
      source = EM::EventSource.new("https://developer-api.nest.com/",
      nil,
      {'Authorization' => "Bearer #{NESTTOKEN}"})
      source.on('put') do |message|
        puts "PUT message"
        data = JSON.parse(message)
        # do something with this data hash
        puts "*"*100
      end

      source.error do |err|
        puts err
      end

      source.start
    end

  end

end

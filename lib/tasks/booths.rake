namespace :background do
  desc "Run the background task"
  task booths: :environment do
    loop do
      for booth in Booth.all
        # set a random track
        if !booth.start_time
          booth.track = Track.all.sample
          booth.start_time = Time.now
          booth.save
        end

        # set a random track if the current track is over
        if booth.start_time + booth.track.duration.seconds < Time.now
          booth.next!
        end


      end
      
      sleep 1
    end
  end
end

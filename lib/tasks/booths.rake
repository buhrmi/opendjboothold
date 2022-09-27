namespace :background do
  desc "Run the background task"
  task booths: :environment do
    loop do
      for booth in Booth.all
        booth.next! if booth.track_finished?
      end
      sleep 1
    end
  end
end

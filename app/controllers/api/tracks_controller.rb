class Api::TracksController < ApplicationController
  def index
    query = params[:q]
    if params[:service] == 'youtube'
      api_key = Rails.application.credentials.dig(:youtube, :api_key)
      url = URI("https://www.googleapis.com/youtube/v3/search?q=#{CGI.escape query}&type=video&videoEmbeddable=true&maxResults=50&key=#{api_key}")
      res = Net::HTTP.get_response(url)
      data = JSON.parse(res.body)
      video_ids = data['items'].map { |item| item['id']['videoId'] }
      video_ids = video_ids.join(',')
      url = URI("https://www.googleapis.com/youtube/v3/videos?id=#{video_ids}&part=snippet,contentDetails&key=#{api_key}")
      res = Net::HTTP.get_response(url)
      data = JSON.parse(res.body)
      tracks = data['items'].map do |item|
        Track.where(service: 'youtube', service_id: item['id']).first_or_create do |track|
          track.title = item['snippet']['title']
          track.duration = youtube_duration_to_seconds item['contentDetails']['duration']
          track.thumbnail = item['snippet']['thumbnails']['high']['url']
          track.uploader = item['snippet']['channelTitle']
        end
      end
      render json: tracks
    end
  end

  private

  def youtube_duration_to_seconds duration
    duration = duration[2..-1]
    duration = duration.split('M')
    if duration.length == 1
      duration[0].to_i
    else
      duration[0].to_i * 60 + duration[1][0..-2].to_i
    end
  end
end
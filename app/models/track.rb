class Track < ApplicationRecord
  has_many :booths  

  def transmission
    {
      id: id,
      title: title,
      service: service,
      service_id: service_id,
      uploader: uploader,
      thumbnail: thumbnail,
      duration: duration
    }
  end
end
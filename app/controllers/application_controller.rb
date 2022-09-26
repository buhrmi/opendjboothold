class ApplicationController < ActionController::Base
  use_inertia_instance_props

  rescue_from ActiveRecord::RecordInvalid do |exception|
    raise exception unless request.inertia?
    session[:errors] = exception.record.errors
    redirect_back(fallback_location: root_path)
  end

  rescue_from ActionController::BadRequest do |exception|
    flash[:error] = exception.message
    redirect_back(fallback_location: root_path)
  end

  inertia_share do
    {
      youtube_api_key: Rails.application.credentials.dig(:youtube, :api_key),
      logged_in: current_user.present?,
      errors: session.delete(:errors),
      flash: flash.to_h
    }
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end

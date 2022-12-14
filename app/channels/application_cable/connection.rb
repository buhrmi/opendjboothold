module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private 
    def find_user
      User.find_by(id: session[:user_id])
    end

    def session
      @request.session
    end
  end
end
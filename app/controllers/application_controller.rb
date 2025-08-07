class ApplicationController < ActionController::Base
  before_action :identify_user_session

  private

  def identify_user_session
    session[:user_session_token] ||= SecureRandom.uuid
    @current_user_session ||= UserSession.find_or_create_by(session_token: session[:user_session_token]) do |user_session|
      user_session.ip_address = request.remote_ip
    end
  end
end

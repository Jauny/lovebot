class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_account
  	@current_account ||= Account.find_by_name(session[:account_name]) if session[:account_name]
  end
  helper_method :current_account
end

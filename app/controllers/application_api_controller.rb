class ApplicationApiController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session

  include Authenticable

  respond_to :json

end

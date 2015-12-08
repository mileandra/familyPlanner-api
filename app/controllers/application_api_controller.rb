class ApplicationApiController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :null_session

  respond_to :json

end

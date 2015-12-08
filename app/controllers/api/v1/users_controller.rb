class Api::V1::UsersController < ApplicationApiController

  def show
    respond_with User.find(params[:id])
  end

end

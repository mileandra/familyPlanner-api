class Api::V1::UsersController < ApplicationApiController

  before_action :authenticate_with_token!, :except => :create

  def show
    respond_with User.includes(:group).find(params[:id])
  end

  def create
    user = User.new(user_params)
    user.generate_authentication_token!
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors.full_messages.join(", ") }, status: 422
    end
  end

  def update
    user = current_user

    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors.full_messages.join(", ") }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end


  private
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end


end

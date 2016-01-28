class Api::V1::GroupsController < ApplicationApiController

  before_filter :authenticate_with_token!

  def create

    unless current_user.group.nil?
      return render json: { errors: "This user already has a group"}, status: 422
    end

    group = Group.new(group_params)
    group.owner = current_user
    if group.save
      render json: group, status: 201
    else
      render json: { errors: group.errors }, status: 422
    end
  end

  def show
    if current_user.group.nil?
      return render json: { errors: "This user does not belong to a group yet" }, status: 422
    end
    group = current_user.group
    render json: group, :include => :users, status: 200
  end

  def remove_member
    if current_user.group.nil?
      return render json: { errors: "This user does not belong to a group yet" }, status: 422
    end
    user = current_user.group.users.find(params[:user_id])
    unless user
      return render json: { errors: "This user could not be found in this group" }, status: 422
    end
    user.group = nil
    if user.save
      render json: { success: true }, status: 204
    else
      render json: { errors: "Unable to remove user from group"}, status: 422
    end
  end

  private
  def group_params
    params.require(:group).permit(:name)
  end
end

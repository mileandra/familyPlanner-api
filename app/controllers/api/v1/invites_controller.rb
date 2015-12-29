class Api::V1::InvitesController < ApplicationApiController

  before_filter :authenticate_with_token!

  def create
    invite = Invitation.new
    invite.user = current_user
    invite.group = current_user.group
     if invite.save
      render json: invite, status: 201
    else
      render json: { errors: invite.errors }, status: 422
    end
  end

  def accept
    # Remove all expired codes
    Invitation.where('created_at < ?', 24.hours.ago).delete_all

    code = params[:code]
    invite = Invitation.includes(:group).find_by(code: code)
    unless invite.nil?
      render json: invite.group, status: 201
    else
      render json: { errors: "Invalid invitation code"}, status: 422
    end
  end
end

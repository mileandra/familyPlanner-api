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
end

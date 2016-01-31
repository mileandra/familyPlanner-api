class Api::V1::MessagesController < ApplicationApiController

  before_filter :authenticate_with_token!

  def index
    if params[:since]
      since = params[:since].to_time
      @messages = Message.includes(:responses).where('responds_id IS NULL AND group_id = ? AND updated_at >= ?', current_user.group_id, since).order(updated_at: :desc)
    else
      @messages = Message.includes(:responses).where('responds_id IS NULL AND group_id = ?', current_user.group_id).order(updated_at: :desc)
    end

    render json: {messages: @messages.as_json(:include => :responses), synctime: Time.now }, status: 200
  end

  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @message.group_id = current_user.group_id
    if @message.save
      render json: @message, status: 201
    else
      render json: { errors: @message.errors.full_messages.join(", ") }, status: 422
    end
  end

  def update
    message = Message.find(params[:id])

    if message.update(message_params)
      render json: message, status: 200
    else
      render json: {errors: message.errors.full_messages.join(", ") }, status: 422
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    head 204
  end

  private
  def message_params
    params.require(:message).permit(:message, :group_id, :user_id, :subject, :responds_id, :read)
  end
end

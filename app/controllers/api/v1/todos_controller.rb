class Api::V1::TodosController < ApplicationApiController

  before_filter :authenticate_with_token!

  def create
    @todo = Todo.new(todo_params)
    @todo.creator = current_user
    @todo.group_id = current_user.group_id
    if @todo.save
      return render json: @todo, status: 201
    else
      return render json: { errors: @todo.errors.full_messages.join(", ") }, status: 422
    end
  end

  private
  def todo_params
    params.require(:todo).permit(:title, :group_id, :user_id, :completed, :creator_id)
  end
end

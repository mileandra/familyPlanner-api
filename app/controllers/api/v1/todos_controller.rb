class Api::V1::TodosController < ApplicationApiController

  before_filter :authenticate_with_token!

  def index

    @todos = Todo.where('group_id = ?', current_user.group_id).order(updated_at: :desc)

    render json: @todos, status: 200
  end

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

  def update
    todo = Todo.find(params[:id])
    todo_completed = todo.completed?

    todo.update_attributes(todo_params)

    if todo.completed? && !todo_completed
      todo.user = current_user
    end

    if todo.save
      render json: todo, status: 200
    else
      render json: {errors: todo.errors.full_messages.join(", ") }, status: 422
    end
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy
    head 204
  end

  private
  def todo_params
    params.require(:todo).permit(:title, :group_id, :user_id, :completed, :creator_id)
  end
end

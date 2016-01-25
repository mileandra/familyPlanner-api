class Api::V1::TodosController < ApplicationApiController

  before_filter :authenticate_with_token!

  def index
    if params[:since]
      since = params[:since].to_s
      @todos = Todo.where('group_id = ? AND updated_at >= ? AND id NOT IN(select todo_id from todo_user_archives where archived = ?)', current_user.group_id, since, true).order(updated_at: :desc)
    else
      @todos = Todo.where('group_id = ? AND id NOT IN(select todo_id from todo_user_archives where archived = ?)', current_user.group_id, true).order(updated_at: :desc)
    end


    render json: {todos: @todos, synctime: Time.now }, status: 200
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

  def archive
    @todos = Todo.where('group_id = ? AND completed = ? AND id NOT IN(select todo_id from todo_user_archives where archived = ?)', current_user.group_id, true, true)
    ids = []
    @todos.each do |todo|
      tua = TodoUserArchive.new()
      tua.user = current_user
      tua.todo = todo
      tua.archived = true
      tua.save
      ids << todo.id
    end
    return render json: {success: true, ids: ids}, status: 422
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

require 'spec_helper'

describe Api::V1::TodosController do

  describe 'POST #create' do
    context 'when it is successfully created' do
      before(:each) do
        @user = create_user_with_group

        @todo_attributes = FactoryGirl.attributes_for(:todo)

        api_authorization_header(@user.auth_token)

        post :create, { todo: @todo_attributes }
      end

      it 'returns a json of the created todo' do
        expect(json_response[:title]).to eql @todo_attributes[:title]
      end

      it 'should set the creator to current user' do
        expect(json_response[:creator_id]).to eql @user.id
      end

      it { should respond_with 201 }

    end

    context 'when it is not successfully created' do
      before(:each) do
        @user = create_user_with_group

        api_authorization_header(@user.auth_token)

        post :create, { todo: {title: '' } }
      end

      it 'returns a json with errors' do
        expect(json_response[:errors]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

    context 'when the user is not authorized' do
      before(:each) do
        @todo_attributes = FactoryGirl.attributes_for(:todo)
        post :create, { todo: @todo_attributes }
      end

      it { should respond_with 401 }
    end
  end

  describe 'PUT #update' do

    context 'when it is successfully udpated' do
      before(:each) do
        @user = create_user_with_group
        @todo = create_todo(@user)

        api_authorization_header(@user.auth_token)
        put :update, {id: @todo.id, todo: {completed: true}}
      end

      it 'returns a json with updated data' do
        expect(json_response[:completed]).to eql true
      end

      it 'saves the user who completed the todo' do
        expect(json_response[:user_id]).to eql @user.id
      end

      it { should respond_with 200 }
    end

    context 'when it is not successfully updated' do
      before(:each) do
        @user = create_user_with_group
        @todo = create_todo(@user)

        api_authorization_header(@user.auth_token)
        put :update, {id: @todo.id, todo: {title: ''}}
      end

      it 'should return a string with errors' do
        expect(json_response[:errors]).to include 'blank'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = create_user_with_group
      @todo = create_todo(@user)

      api_authorization_header @user.auth_token
      delete :destroy, { id: @todo.id }
    end

    it { should respond_with 204 }
  end

  describe 'GET #index' do
    before(:each) do
      @user = create_user_with_group
      @todo1 = create_todo(@user)
      @todo2 = create_todo(@user)
      @todo3 = create_todo(@user)
      @completed_todo = create_todo(@user)
      @completed_todo.completed = true
      @completed_todo.save

      user2 = create_user_with_group
      other_user_todo = create_todo(user2)

      api_authorization_header @user.auth_token
      get :index
    end

    it 'should list all todos of @users group' do
      expect(json_response.count).to eql 4
    end

    it 'should sort todos by update date desc' do
      expect(json_response[0][:id]).to eql @completed_todo.id
    end

    it { should respond_with 200}
  end
end

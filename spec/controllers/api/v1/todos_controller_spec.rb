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
        @todo = FactoryGirl.build(:todo)
        @todo.creator = @user
        @todo.group = @user.group
        @todo.save

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
  end
end

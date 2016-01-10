require 'spec_helper'

describe Api::V1::MessagesController do
  describe 'POST #create' do
    context 'when it is successfully created' do
      before(:each) do
        @user = create_user_with_group

        @message_attributes = FactoryGirl.attributes_for(:message)

        api_authorization_header(@user.auth_token)

        post :create, { message: @message_attributes }
      end

      it 'returns a json of the created todo' do
        expect(json_response[:message]).to eql @message_attributes[:message]
      end

      it 'should set the user to current user' do
        expect(json_response[:user_id]).to eql @user.id
      end

      it { should respond_with 201 }

    end

    context 'when it is not successfully created' do
      before(:each) do
        @user = create_user_with_group

        api_authorization_header(@user.auth_token)

        post :create, { message: {message: '' } }
      end

      it 'returns a json with errors' do
        expect(json_response[:errors]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

    context 'when the user is not authorized' do
      before(:each) do
        @message_attributes = FactoryGirl.attributes_for(:message)
        post :create, { message: @message_attributes }
      end

      it { should respond_with 401 }
    end
  end

  describe 'PUT #update' do

    context 'when it is successfully udpated' do
      before(:each) do
        @user = create_user_with_group
        @message = create_message(@user)

        api_authorization_header(@user.auth_token)
        put :update, {id: @message.id, message: {message: "Some new message string" }}
      end

      it 'returns a json with updated data' do
        expect(json_response[:message]).to eql "Some new message string"
      end

      it 'saves the user who completed the todo' do
        expect(json_response[:user_id]).to eql @user.id
      end

      it { should respond_with 200 }
    end

    context 'when it is not successfully updated' do
      before(:each) do
        @user = create_user_with_group
        @message = create_message(@user)

        api_authorization_header(@user.auth_token)
        put :update, {id: @message.id, message: {message: ''}}
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
      @message = create_message(@user)

      api_authorization_header @user.auth_token
      delete :destroy, { id: @message.id }
    end

    it { should respond_with 204 }
  end

  describe 'GET #index' do
    before(:each) do
      @user = create_user_with_group
      @message1 = create_message(@user)
      @message2 = create_message(@user)
      @message3 = create_message(@user)

      user2 = create_user_with_group
      other_user_message = create_message(user2)

      api_authorization_header @user.auth_token
      get :index
    end

    it 'should list all todos of @users group' do
      expect(json_response[:messages].count).to eql 3
    end

    it 'should sort todos by update date desc' do
      expect(json_response[:messages][0][:id]).to eql @message3.id
    end

    it { should respond_with 200}
  end
end

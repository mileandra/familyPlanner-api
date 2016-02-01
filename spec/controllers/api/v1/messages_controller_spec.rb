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

      it 'should include the author in the returned message' do
        expect(json_response[:author]).to eql @user.name
      end

      it { should respond_with 201 }

    end

    context 'when it has a parent message' do
      before(:each) do
        @user = create_user_with_group
        @message = create_message(@user)
        @message.read = true
        @message.save!
        @message_attributes = FactoryGirl.attributes_for(:message)
        @message_attributes[:responds_id] = @message.id

        api_authorization_header(@user.auth_token)

        post :create, { message: @message_attributes }

      end

      it 'returns a json fo the created message' do
        expect(json_response[:responds_id]).to eql @message.id
      end

      it 'has the updated_date of the new child message' do
        @message.reload
        expect(json_response[:updated_at]).to eql @message.updated_at.as_json
      end

      it 'is unread after a new unread response' do
        @message.reload
        expect(@message.read).to be_falsey
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
      @message_3_response = FactoryGirl.build(:message)
      @message_3_response.responds = @message3
      @message_3_response.user = @user
      @message_3_response.save


      user2 = create_user_with_group
      other_user_message = create_message(user2)

      api_authorization_header @user.auth_token
      get :index
    end

    it 'should list all todos of @users group' do
      expect(json_response[:messages].count).to eql 3
    end

    it 'should sort message by update date desc' do
      expect(json_response[:messages][0][:id]).to eql @message3.id
    end

    it 'should show the response for message 3' do
      expect(json_response[:messages][0][:responses][0][:id]).to eql @message_3_response.id
    end

    it { should respond_with 200}
  end
end

require 'spec_helper'

describe Api::V1::UsersController do

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header(@user.auth_token)
      get :show, id: @user.id
    end

    it 'return the information about a reporter on a hash' do
      expect(json_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do

    context 'when it is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for(:user)
        post :create, { user: @user_attributes }
      end

      it 'renders the json for the user created' do
        expect(json_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when creation fails' do
      before(:each) do
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678"}
        post :create, {user: @invalid_user_attributes }
      end

      it 'renders errors as json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the errors on why it could not be created' do
        expect(json_response[:errors]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT #update' do
    context 'when it is successfully updated' do
      new_email = 'newmail@example.com'
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header(@user.auth_token)
        put :update, { id: @user.id, user: { email: new_email } }, format: :json
      end

      it 'renders the updated user' do
        expect(json_response[:email]).to eql new_email
      end

      it { should respond_with 200 }
    end

    context 'when update fails' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header(@user.auth_token)
        put :update, { id: @user.id, user: { email: 'bademail.com' } }
      end

      it 'renders an error json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the errors on why it could not be updated' do
        expect(json_response[:errors]).to include 'is invalid'
      end

      it { should respond_with 422 }
    end

  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, { id: @user.id }
    end

    it { should respond_with 204 }
  end
end

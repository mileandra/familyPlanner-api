require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) {request.headers['Accept'] = "application/family.planner.v1"}

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it 'return the information about a reporter on a hash' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do

    context 'when it is successfully created' do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for(:user)
        post :create, { user: @user_attributes }, format: :json
      end

      it 'renders the json for the user created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when creation fails' do
      before(:each) do
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678"}
        post :create, {user: @invalid_user_attributes }, format: :json
      end

      it 'renders errors as json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders the errors on why it could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT #update' do
    context 'when it is successfully updated' do
      before(:each) do
        @user = FactoryGirl.create :user
        put :update, { id: @user.id, user: { email: 'newmail@example.com' } }, format: :json
      end

      it 'renders the updated user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql 'newmail@example.com'
      end

      it { should respond_with 200 }
    end

    context 'when update fails' do
      before(:each) do
        @user = FactoryGirl.create :user
        put :update, { id: @user.id, user: { email: 'bademail.com' } }, format: :json
      end

      it 'renders an error json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders the errors on why it could not be updated' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it { should respond_with 422 }
    end

  end
end

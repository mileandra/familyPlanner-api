require 'spec_helper'

describe Api::V1::GroupsController do

  describe 'POST #create' do
    context 'when it is successfully created' do
      before(:each) do
        @user = FactoryGirl.create :user
        @group_attributes = FactoryGirl.attributes_for :group

        api_authorization_header(@user.auth_token)

        post :create, { group: @group_attributes }
      end

      it 'renders the json for the group created' do
        expect(json_response[:name]).to eql @group_attributes[:name]
      end

      it 'sets the owner to current user' do
        expect(json_response[:owner_id]).to eql @user.id
      end

      it 'sets the users group id' do
        @user.reload
        expect(json_response[:id]).to eql @user.group_id
      end

      it { should respond_with 201 }
    end

    context 'when it is not successfully created' do
      before(:each) do
        @user = FactoryGirl.create :user
        @invalid_attributes = {name: ""}

        api_authorization_header(@user.auth_token)

        post :create, { group: @invalid_attributes }
      end

      it 'renders errors as json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the errors on why it could not be created' do
        expect(json_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end

    context 'when the user already has a group' do
      before(:each) do
        @user = FactoryGirl.create :user
        @group_attributes = FactoryGirl.attributes_for :group
        api_authorization_header(@user.auth_token)

        post :create, { group: @group_attributes }

        @second_group_attributes = FactoryGirl.attributes_for :group
        api_authorization_header(@user.auth_token)
        post :create, { group: @second_group_attributes }
      end

      it 'renders errors as json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the errors on why it could not be created' do
        expect(json_response[:errors]).to include "has a group"
      end

      it { should respond_with 422 }
    end
  end

  describe 'GET #show' do
    context 'when the current user has a group' do
      before(:each) do
        @user = create_user_with_group
        @group = @user.group

        api_authorization_header(@user.auth_token)
        get :show, {id: @group.id}
      end

      it 'return the information about the group' do
        expect(json_response[:users].count).to eql 1
      end

      it { should respond_with 200 }
    end

    context 'when the current user does not have a group' do
      before(:each) do
        @user = FactoryGirl.create(:user)

        api_authorization_header(@user.auth_token)
        get :show, {id: 1}
      end

      it 'will return a json with the error message' do
        expect(json_response[:errors]).to include 'does not belong'
      end

      it should { respond_with 422 }
    end
  end
end

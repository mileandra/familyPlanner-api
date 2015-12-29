require 'spec_helper'

describe Api::V1::InvitesController do

  describe 'POST #create' do
    context 'when it is successfully created' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        api_authorization_header(@user.auth_token)

        post :create, {}
      end

      it 'renders the json for the invite created' do
        expect(json_response[:user_id]).to eql @user[:id]
      end

      it { should respond_with 201 }
    end

  end

  describe 'POST #accept' do
    context 'when it is successfully accepted' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @group = FactoryGirl.build(:group)
        @group.owner = @user
        @group.save


        @invite = FactoryGirl.build(:invitation)
        @invite.user = @user
        @invite.group = @user.group
        @invite.save


        @second_user = FactoryGirl.create(:user)
        api_authorization_header(@second_user.auth_token)
        post :accept, { code: @invite.code }
      end

      it 'renders the group' do
        expect(json_response[:name]).to eql @user.group.name
      end

      it 'removes any expired invites' do

      end

      it { should respond_with 201 }
    end

    context 'when it is not successfully accepted' do
      before(:each) do
        @user = FactoryGirl.create(:user)

        api_authorization_header(@user.auth_token)
        post :accept, { code: 'invalidCode' }
      end

      it 'renders an error json' do
        expect(json_response[:errors]).to include 'Invalid'
      end

      it { should respond_with 422 }
    end

    context 'it should remove all expired invites' do
      before(:each) do

        @user = FactoryGirl.create(:user)
        @group = FactoryGirl.build(:group)
        @group.owner = @user
        @group.save


        @invite = FactoryGirl.build(:invitation)
        @invite.user = @user
        @invite.group = @user.group
        @invite.save
        # mock an expired invite
        @invite.created_at = 48.hours.ago
        @invite.save


        @second_user = FactoryGirl.create(:user)
        api_authorization_header(@second_user.auth_token)
        post :accept, { code: @invite.code }
      end

      it 'renders an error json' do
        expect(json_response[:errors]).to include 'Invalid'
      end

      it { should respond_with 422 }
    end
  end

end

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

end

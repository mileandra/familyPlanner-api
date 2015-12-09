require 'spec_helper'

describe Api::V1::SessionsController do

  # Test creation
  # Test delete

  describe 'POST #create' do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when the credentials are correct' do
      before(:each) do
        credentials = { email: @user.email, password: "12345678" }
        post :create, { session: credentials }
      end

      it 'returns the user record to the given credentials' do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end
  end
end

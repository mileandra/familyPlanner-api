require 'spec_helper'

describe Api::V1::TodosController do

  describe 'POST #create' do
    context 'when it is successfully created' do
      before(:each) do
        @user = FactoryGirl.create(:user)
        @group = FactoryGirl.build(:group)
        @group.owner = @user
        @group.save

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
        @user = FactoryGirl.create(:user)
        @group = FactoryGirl.build(:group)
        @group.owner = @user
        @group.save

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
end

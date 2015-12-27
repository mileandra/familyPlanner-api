require 'spec_helper'

describe Invitation do

  before(:each) do
    @user = FactoryGirl.create :user
    @group = FactoryGirl.build(:group)
    @group.owner = @user
    @group.save

    @invitation = FactoryGirl.build :invitation
    @invitation.user = @user
    @invitation.group = @user.group
  end

  subject { @invitation }

  it { should respond_to(:group_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:code) }
  it { should validate_uniqueness_of(:code) }

  # auth token testing
  describe '#generate_invitation_code!' do
    it 'generates a unique code' do
      Devise.stub(:friendly_token).and_return("auniquetoken123")
      @invitation.generate_code!
      expect(@invitation.code).to eql "auniquetoken123"
    end

    it 'generates another code when one has already been taken' do
      existing_invite = FactoryGirl.create(:invitation, code: "auniquetoken123")
      @invitation.generate_code!
      expect(@invitation.code).not_to eql existing_invite.code
    end
  end

end

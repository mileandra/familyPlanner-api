require 'spec_helper'

describe Group do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.build(:group)
    @group.owner = @user
  end

  subject { @group }

  it { should respond_to(:name) }
  it { should respond_to(:owner) }

  it { should belong_to(:owner)}

  it { should be_valid }


end

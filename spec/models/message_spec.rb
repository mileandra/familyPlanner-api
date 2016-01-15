require 'spec_helper'

describe Message do
  before { @message = FactoryGirl.build(:message) }

  subject { @message }

  it { should respond_to :message }
  it { should respond_to :group }
  it { should respond_to :user }
  it { should respond_to :subject }
  it { should respond_to :responds }
  it { should respond_to :responses }

  it { should validate_presence_of :message }
  it { should validate_presence_of :subject }

  it { should be_valid }

  describe 'When message is not present' do
    before { @message.message = '' }
    it { should_not be_valid }
  end
end

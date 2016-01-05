require 'spec_helper'

describe Todo do
  before { @todo = FactoryGirl.build(:todo) }

  subject { @todo }

  it { should respond_to :title }
  it { should respond_to :completed }
  it { should respond_to :group }
  it { should respond_to :user }
  it { should respond_to :creator }

  it { should validate_presence_of :title }

  it { should be_valid }

  describe 'When title is not present' do
    before { @todo.title = '' }
    it { should_not be_valid }
  end

end

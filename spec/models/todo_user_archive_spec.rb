require 'spec_helper'

describe TodoUserArchive do
  before { @todo_user_archive = FactoryGirl.build(:todo_user_archive) }

  subject { @todo_user_archive }

  it { should respond_to :user }
  it { should respond_to :todo }
  it { should respond_to :archived }

  it { should be_valid }
end

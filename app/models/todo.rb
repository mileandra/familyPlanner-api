class Todo < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :creator, :class_name => "User"

  validates_presence_of :title
end

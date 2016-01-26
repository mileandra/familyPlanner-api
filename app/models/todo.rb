class Todo < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :creator, :class_name => "User"

  validates_presence_of :title

  attr_accessor :archived

  def archive(user)
    tua = TodoUserArchive.new()
    tua.todo = self
    tua.user = user
    tua.archived = true
    tua.save
  end
end

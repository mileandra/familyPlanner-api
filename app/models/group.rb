class Group < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"

  validates_presence_of :owner_id
  validates_presence_of :name

  after_create :set_owner_group

  private

  def set_owner_group
    owner.group_id = self.id
    owner.save
  end

end

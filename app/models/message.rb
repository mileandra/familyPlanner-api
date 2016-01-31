class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :responds, :class_name => "Message"
  has_many :responses, :class_name => "Message", :foreign_key => :responds_id

  validates_presence_of :message
  validates_presence_of :subject, :if => :has_no_parent_message?

  after_create :update_parent
  before_save :set_author

  accepts_nested_attributes_for :responds

  def has_no_parent_message?
    self.responds_id.nil?
  end

  def update_parent
    if self.has_no_parent_message?
      return
    end
    parent = self.responds
    parent.updated_at = self.updated_at
    parent.read = false
    parent.save()
  end

  def set_author
    self.author = self.user.name
    true
  end
end

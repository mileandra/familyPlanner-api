class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :responds, :class_name => "Message"
  has_many :responses, :class_name => "Message", :foreign_key => :responds_id

  validates_presence_of :message
  validates_presence_of :subject, :if => :has_no_parent_message?

  after_create :update_parent

  accepts_nested_attributes_for :responds

  def has_no_parent_message?
    self.responds.nil?
  end

  def update_parent
    unless has_no_parent_message?
      self.responds.updated_at = self.updated_at
      self.responds.read = self.read
      self.responds.save
    end
  end
end

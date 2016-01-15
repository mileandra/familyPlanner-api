class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :responds, :class_name => "Message"
  has_many :responses, :class_name => "Message", :foreign_key => :responds_id

  validates_presence_of :message
  validates_presence_of :subject, :if => :has_no_parent_message?

  accepts_nested_attributes_for :responds

  def has_no_parent_message?
    self.responds.nil?
  end
end

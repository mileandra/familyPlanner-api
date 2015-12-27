class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  before_create :generate_code!

  validates :code, uniqueness: true

  def generate_code!
    begin
      self.code = Devise.friendly_token(8)
    end while self.class.exists?(code: code)
  end
end

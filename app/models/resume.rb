class Resume < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :guest_user, optional: true
  
  validate :user_or_guest_user_present

  def generate_summary
    "私は#{company}で#{position}として、#{tasks}。その中で#{improvements}。結果として#{achievements}。"
  end
  
  private
  
  def user_or_guest_user_present
    if user_id.blank? && guest_user_id.blank?
      errors.add(:base, "Either user or guest_user must be present")
    end
  end
end

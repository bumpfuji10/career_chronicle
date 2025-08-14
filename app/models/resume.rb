class Resume < ApplicationRecord
  belongs_to :user

  def generate_summary
    "私は#{company}で#{position}として、#{tasks}。その中で#{improvements}。結果として#{achievements}。"
  end
end

class User < ApplicationRecord
  @inheritance_column = :not_type

  has_secure_password
  before_save :downcase_email

  has_many :courses, foreign_key: :user_id, primary_key: :id, inverse_of: :user
  has_many :projects, foreign_key: :user_id, primary_key: :id, inverse_of: :user
  has_many :events, foreign_key: :user_id, primary_key: :id, inverse_of: :user

  def downcase_email
    self.email = email.downcase
  end
end

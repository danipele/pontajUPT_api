class User < ApplicationRecord
  @inheritance_column = :not_type

  has_secure_password
  before_save :downcase_email

  def downcase_email
    self.email = email.downcase
  end
end

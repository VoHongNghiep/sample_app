class User < ApplicationRecord
  before_save :downcase_email

  validates :email, presence: true, length: { minimum: Settings.min_leng, maximum: Settings.max_leng },
                    format: Settings.regex_email,
                    uniqueness: { case_sensitive: false }

  validates :name, presence: true, length: { maximum: Settings.max_leng }
  validates :password, presence: true, length: { minimum: Settings.min_pass }, if: :password
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end

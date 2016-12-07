class User < ApplicationRecord
  validates :email, :username, presence: true
  validates :email, uniqueness: true
  validates :username, uniqueness: { case_sensitive: false }

  # from Device https://github.com/plataformatec/devise/blob/18b6064d74726147eccd69b24812000074261bbb/lib/generators/templates/devise.rb#L151-L154
  validates :email, format: { with: /\A[^@]+@[^@]+\z/}
  validates :username, length: { maximum: 40,
                                 too_long: "%{count} characters is the maximum allowed" }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/,
                                 message: "only letters, numbers, and the sign _" }

  before_save :downcase_username

  private

  def downcase_username
    username.downcase!
  end
end

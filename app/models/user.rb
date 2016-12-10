require 'openssl'

class User < ApplicationRecord
  # параметры работы модуля шифрования паролей
  ITERATIONS = 20000
  DIGEST = OpenSSL::Digest::SHA256.new

  has_many :questions

  validates :email, :username, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :username, uniqueness: { case_sensitive: false }

  # from Device https://github.com/plataformatec/devise/blob/18b6064d74726147eccd69b24812000074261bbb/lib/generators/templates/devise.rb#L151-L154
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ }
  validates :username, length: { maximum: 40 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/ }

  attr_accessor :password

  validates :password, presence: true, on: :create

  validates :password, confirmation: true
  # validates :password_confirmation, presence: true

  before_save :encrypt_password

  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))
      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt,
                                   ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    if user.present? && user.password_hash == User.hash_to_string(
      OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt,
                                 ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end
  # before_save :downcase_username

  private

  # def downcase_username
  #   username.downcase!
  # end
end

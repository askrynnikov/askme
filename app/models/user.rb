class User < ApplicationRecord
  validates :email, :username, presence: true #{ message: "не должно быть пустым" }
  validates :email, :username, uniqueness: true #{ message: "должны быть уникальными" }
end

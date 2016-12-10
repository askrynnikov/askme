class Question < ApplicationRecord
  validates :text, length: { maximum: 255 }

  belongs_to :user
end

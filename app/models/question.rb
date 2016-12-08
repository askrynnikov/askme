class Question < ApplicationRecord
  validates :text, length: { maximum: 255 }
end

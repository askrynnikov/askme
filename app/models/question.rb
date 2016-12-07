class Question < ApplicationRecord
  validates :text, length: { maximum: 255,
                             too_long: "%{count} characters is the maximum allowed" }
end

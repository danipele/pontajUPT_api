class Holiday < ApplicationRecord
  has_many :timelines, as: :activity
end

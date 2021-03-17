class OtherActivity < ApplicationRecord
  has_many :timelines, as: :activity
end

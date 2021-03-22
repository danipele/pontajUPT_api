class Timeline < ApplicationRecord
  belongs_to :activity, polymorphic: true, primary_key: :id, inverse_of: :timelines
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :timelines
end

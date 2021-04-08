class Event < ApplicationRecord
  belongs_to :activity, polymorphic: true, primary_key: :id, inverse_of: :events
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :events
end

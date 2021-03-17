class Timeline < ApplicationRecord
  belongs_to :activity, polymorphic: true, primary_key: :id, inverse_of: :timelines
end

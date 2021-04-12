class Event < ApplicationRecord
  belongs_to :activity, polymorphic: true, primary_key: :id, inverse_of: :events
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :events

  scope :in_period, lambda { |start_date, end_date|
    where('start_date::timestamp >= ? and start_date::timestamp < ? or
           end_date::timestamp > ? and end_date::timestamp <= ?',
          start_date, end_date, start_date, end_date)
  }
end

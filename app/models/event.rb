# frozen_string_literal: true

class Event < ApplicationRecord
  include Constants

  @inheritance_column = :not_type

  belongs_to :activity, polymorphic: true, primary_key: :id, inverse_of: :events
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :events

  scope :in_period, lambda { |start_date, end_date|
    where('start_date::timestamp >= ? and start_date::timestamp < ? or
           end_date::timestamp > ? and end_date::timestamp <= ? or
           start_date::timestamp <= ? and end_date::timestamp >= ?',
          start_date, end_date, start_date, end_date, start_date, end_date)
  }

  scope :from_date, ->(date) { where('start_date::timestamp >= ? and end_date::timestamp <= ?', date, date + 1.day) }
  scope :from_week, ->(date) { where('start_date::timestamp >= ? and end_date::timestamp <= ?', date, date + 1.week) }

  scope :should_delete_for_holiday, lambda { |date|
    where('start_date::Date = ? and type != ? and type != ?', date, PROJECT_TYPE, HOLIDAY_TYPE)
  }
  scope :should_delete_holidays_for_holiday, lambda { |date|
    where('start_date::Date = ? and type = ?', date, HOLIDAY_TYPE)
  }
end

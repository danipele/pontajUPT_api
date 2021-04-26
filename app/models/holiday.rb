# frozen_string_literal: true

class Holiday < ApplicationRecord
  include Constants

  has_many :events, as: :activity

  def display_name
    HOLIDAY
  end
end

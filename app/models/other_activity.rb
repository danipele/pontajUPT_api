# frozen_string_literal: true

class OtherActivity < ApplicationRecord
  include Constants

  has_many :events, as: :activity

  def display_name
    OTHER_ACTIVITY
  end
end

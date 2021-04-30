# frozen_string_literal: true

class Holiday < ApplicationRecord
  include Constants

  has_many :events, as: :activity

  def name_id
    HOLIDAYS
  end
end

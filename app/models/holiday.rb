# frozen_string_literal: true

class Holiday < ApplicationRecord
  has_many :events, as: :activity

  def display_name
    'Concediu'
  end
end

# frozen_string_literal: true

class Holiday < ApplicationRecord
  has_many :timelines, as: :activity

  def display_name
    'Concediu'
  end
end

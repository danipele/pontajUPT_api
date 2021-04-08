# frozen_string_literal: true

class OtherActivity < ApplicationRecord
  has_many :events, as: :activity

  def display_name
    'Alta activitate'
  end
end

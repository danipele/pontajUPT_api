# frozen_string_literal: true

class Project < ApplicationRecord
  include Constants

  has_many :events, as: :activity, dependent: :nullify
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :projects

  def display_name
    PROJECT
  end
end

# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Constants

  self.abstract_class = true
end

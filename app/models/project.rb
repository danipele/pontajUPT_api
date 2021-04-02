class Project < ApplicationRecord
  has_many :project_hours, foreign_key: :project_id, primary_key: :id, inverse_of: :project, dependent: :nullify
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :projects

  def add_project_hours
    project_hours.create type: 'Documentare pentru cercetare'
    project_hours.create type: 'Documentare oportunitati de finantare proiecte'
    project_hours.create type: 'Elaborare proiecte de cercetare'
    project_hours.create type: 'Executie proiecte de cercetare'
  end
end

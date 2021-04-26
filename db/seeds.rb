# frozen_string_literal: true

OtherActivity.create name: Constants::DOCTORAL_STUDENTS_GUIDANCE
OtherActivity.create name: Constants::UNPAID_INVOLVEMENT_IN_SOCIETY
OtherActivity.create name: Constants::COOPERATION_MANAGEMENT
OtherActivity.create name: Constants::INTERNAL_DELEGATION_DAYS
OtherActivity.create name: Constants::EXTERNAL_DELEGATION_DAYS
OtherActivity.create name: Constants::DEPARTURE_WITH_SCHOLARSHIP
OtherActivity.create name: Constants::OTHER_ACTIVITIES
OtherActivity.create name: Constants::RESEARCH_DOCUMENTATION
OtherActivity.create name: Constants::PROJECT_FINANCING_OPPORTUNITIES_DOCUMENTATION
OtherActivity.create name: Constants::RESEARCH_PROJECTS_ELABORATION
OtherActivity.create name: Constants::RESEARCH_PROJECTS_EXECUTION

Holiday.create name: Constants::SICK_LEAVE
Holiday.create name: Constants::VACATION
Holiday.create name: Constants::UNPAID_LEAVE
Holiday.create name: Constants::CHILD_GROWTH_LEAVE
Holiday.create name: Constants::MATERNITY_LEAVE
Holiday.create name: Constants::UNMOTIVATED_ABSENCES

User.create email: 'angajat@email.com', password: 'wertyuio', first_name: 'dani', last_name: 'pele',
            type: 'Angajat'
User.create email: 'colaborator@email.com', password: 'wertyuio', first_name: 'dani', last_name: 'pele',
            type: 'Colaborator'
User.create email: 'admin@email.com', password: 'wertyuio', first_name: 'dani', last_name: 'pele',
            type: 'Admin'

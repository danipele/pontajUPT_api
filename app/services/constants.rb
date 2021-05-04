# frozen_string_literal: true

module Constants
  # General
  XLS_TYPE = 'text/xls'
  LOCAL_TIMEZONE = 'Bucharest'

  # Authenticate
  AUTHORIZATION_HEADER = 'Authorization'

  # Mailer
  DEFAULT_EMAIL = 'peledanyel@gmail.com'
  LAYOUT_MAILER = 'mailer'

  # Users
  EMPLOYEE_TYPE = 'employee'
  USER_TYPES = %w[employee collaborator].freeze

  # Events
  COLLABORATOR_EVENTS = %w[course seminar laboratory projectHour].freeze
  PROJECT_TYPE = 'project'
  HOLIDAY_TYPE = 'holidays'
  BASIC_NORM = 'basic norm'
  HOURLY_PAYMENT = 'hourly payment'
  DAILY = 'daily'
  WEEKLY = 'weekly'
  EVERY_OTHER_WEEK = 'everyOtherWeek'
  MONTHLY = 'monthly'
  YEARLY = 'yearly'
  ACTIVITY = 'activity'
  SUBACTIVITY = 'subactivity'
  ENTITY = 'entity'
  DESC = 'desc'
  DAY = 'day'
  WEEK = 'week'
  DATE = 'date'

  # Courses and Projects
  ORDER_COURSES_PROJECTS = 'LOWER(name)'

  # Courses
  COURSE_MODEL = 'Course'
  COURSE = 'course'
  SEMINAR = 'seminar'
  LABORATORY = 'laboratory'
  PROJECT_HOUR = 'projectHour'
  EVALUATION = 'evaluation'
  CONSULTATIONS = 'consultations'
  TEACHING_ACTIVITY_PREPARATION = 'teachingActivityPreparation'
  COURSE_HOUR = 'courseHour'

  # Projects
  PROJECT_MODEL = 'Project'
  PROJECT = 'project'

  # Other Activities
  OTHER_ACTIVITY = 'otherActivity'
  DOCTORAL_STUDENTS_GUIDANCE = 'doctoralStudentsGuidance'
  COOPERATION_MANAGEMENT = 'cooperationManagement'
  INTERNAL_DELEGATION_DAYS = 'internalDelegationDays'
  EXTERNAL_DELEGATION_DAYS = 'externalDelegationDays'
  DEPARTURE_WITH_SCHOLARSHIP = 'departureWithScholarship'
  OTHER_ACTIVITIES = 'otherActivities'
  RESEARCH_DOCUMENTATION = 'researchDocumentation'
  PROJECT_FINANCING_OPPORTUNITIES_DOCUMENTATION = 'projectFinancingOpportunitiesDocumentation'
  RESEARCH_PROJECTS_ELABORATION = 'researchProjectsElaboration'

  # Holidays
  HOLIDAYS = 'holidays'
  VACATION = 'vacation'
  SICK_LEAVE = 'sickLeave'
  UNPAID_LEAVE = 'unpaidLeave'
  CHILD_GROWTH_LEAVE = 'childGrowthLeave'
  MATERNITY_LEAVE = 'maternityLeave'
  UNMOTIVATED_ABSENCES = 'unmotivatedAbsences'

  # Reports
  PROJECT_REPORT = 'projectReport'
  TEACHER_REPORT = 'teacherReport'
end

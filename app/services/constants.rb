# frozen_string_literal: true

module Constants
  # General
  XLS_TYPE = 'text/xls'
  LOCAL_TIMEZONE = 'Bucharest'

  # Authenticate
  AUTHORIZATION_HEADER = 'Authorization'
  NOT_AUTHORIZED = I18n.t 'authenticate.not_authorized'
  INVALID_TOKEN = I18n.t 'authenticate.invalid_token'

  # Mailer
  DEFAULT_EMAIL = 'peledanyel@gmail.com'
  LAYOUT_MAILER = 'mailer'
  RESET_PASSWORD = I18n.t 'mailer.reset_password'

  # Sessions
  NO_ACCOUNT_MESSAGE = I18n.t 'session.no_account_message'
  INCORRECT_PASSWORD_MESSAGE = I18n.t 'session.incorrect_password_message'

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
  COURSES_FILE_NAME = I18n.t 'course.filename'
  COURSE_MODEL = 'Course'
  COURSE_HEADERS = [I18n.t('course.headers.name'),
                    I18n.t('course.headers.year_of_study'),
                    I18n.t('course.headers.semester'),
                    I18n.t('course.headers.cycle'),
                    I18n.t('course.headers.faculty'),
                    I18n.t('course.headers.description')].freeze
  COURSES_SHEET_NAME = I18n.t 'course.sheet_name'
  COURSE = 'course'
  SEMINAR = 'seminar'
  LABORATORY = 'laboratory'
  PROJECT_HOUR = 'projectHour'
  EVALUATION = 'evaluation'
  CONSULTATIONS = 'consultations'
  TEACHING_ACTIVITY_PREPARATION = 'teachingActivityPreparation'
  COURSE_HOUR = 'courseHour'

  # Projects
  PROJECTS_FILE_NAME = I18n.t 'project.filename'
  PROJECT_MODEL = 'Project'
  PROJECT_HEADERS = [I18n.t('project.headers.name'),
                     I18n.t('project.headers.hours_per_month'),
                     I18n.t('project.headers.start_hour_restriction'),
                     I18n.t('project.headers.end_hour_restriction'),
                     I18n.t('project.headers.description')].freeze
  PROJECTS_SHEET_NAME = I18n.t 'project.sheet_name'
  PROJECT = 'project'

  # Other Activities
  OTHER_ACTIVITY = 'otherActivity'
  DOCTORAL_STUDENTS_GUIDANCE = 'doctoralStudentsGuidance'
  UNPAID_INVOLVEMENT_IN_SOCIETY = 'unpaidInvolvementInSociety'
  COOPERATION_MANAGEMENT = 'cooperationManagement'
  INTERNAL_DELEGATION_DAYS = 'internalDelegationDays'
  EXTERNAL_DELEGATION_DAYS = 'externalDelegationDays'
  DEPARTURE_WITH_SCHOLARSHIP = 'departureWithScholarship'
  OTHER_ACTIVITIES = 'otherActivities'
  RESEARCH_DOCUMENTATION = 'researchDocumentation'
  PROJECT_FINANCING_OPPORTUNITIES_DOCUMENTATION = 'projectFinancingOpportunitiesDocumentation'
  RESEARCH_PROJECTS_ELABORATION = 'researchProjectsElaboration'
  RESEARCH_PROJECTS_EXECUTION = 'researchProjectsExecution'

  # Holidays
  HOLIDAYS = 'holidays'
  VACATION = 'vacation'
  SICK_LEAVE = 'sickLeave'
  UNPAID_LEAVE = 'unpaidLeave'
  CHILD_GROWTH_LEAVE = 'childGrowthLeave'
  MATERNITY_LEAVE = 'maternityLeave'
  UNMOTIVATED_ABSENCES = 'unmotivatedAbsences'
end

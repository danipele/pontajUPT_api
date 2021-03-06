# frozen_string_literal: true

module Constants
  # General
  XLS_TYPE = 'text/xls'
  LOCAL_TIMEZONE = 'Bucharest'
  NO_CODE = 'no code'

  # Authenticate
  AUTHORIZATION_HEADER = 'Authorization'

  # Mailer
  DEFAULT_EMAIL = 'peledanyel@gmail.com'
  LAYOUT_MAILER = 'mailer'

  # Users
  EMPLOYEE_TYPE = 'employee'
  COLLABORATOR_TYPE = 'collaborator'
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
  COURSE_CODE = 'A I (C)'
  SEMINAR = 'seminar'
  SEMINAR_CODE = 'A I (S)'
  LABORATORY = 'laboratory'
  LABORATORY_CODE = 'A I (L)'
  PROJECT_HOUR = 'projectHour'
  PROJECT_HOUR_CODE = 'A I (P)'
  EVALUATION = 'evaluation'
  CONSULTATIONS = 'consultations'
  EVALUATION_CONSULTATIONS_CODE = 'A II'
  TEACHING_ACTIVITY_PREPARATION = 'teachingActivityPreparation'
  TEACHING_ACTIVITY_PREPARATION_CODE = 'B'
  COURSE_HOUR = 'courseHour'

  # Projects
  PROJECT_MODEL = 'Project'
  PROJECT = 'project'

  # Other Activities
  OTHER_ACTIVITY = 'otherActivity'
  DOCTORAL_STUDENTS_GUIDANCE = 'doctoralStudentsGuidance'
  COOPERATION_MANAGEMENT = 'cooperationManagement'
  INTERNAL_DELEGATION_DAYS = 'internalDelegationDays'
  INTERNAL_DELEGATION_DAYS_CODE = 'DI'
  EXTERNAL_DELEGATION_DAYS = 'externalDelegationDays'
  EXTERNAL_DELEGATION_DAYS_CODE = 'DE'
  DEPARTURE_WITH_SCHOLARSHIP = 'departureWithScholarship'
  OTHER_ACTIVITIES = 'otherActivities'
  RESEARCH_DOCUMENTATION = 'researchDocumentation'
  PROJECT_FINANCING_OPPORTUNITIES_DOCUMENTATION = 'projectFinancingOpportunitiesDocumentation'
  RESEARCH_PROJECTS_ELABORATION = 'researchProjectsElaboration'
  RESEARCH_CODE = 'C'

  # Holidays
  HOLIDAYS = 'holidays'
  VACATION = 'vacation'
  VACATION_CODE = 'CO'
  SICK_LEAVE = 'sickLeave'
  SICK_LEAVE_CODE = 'CME'
  UNPAID_LEAVE = 'unpaidLeave'
  UNPAID_LEAVE_CODE = 'CFS'
  CHILD_GROWTH_LEAVE = 'childGrowthLeave'
  CHILD_GROWTH_LEAVE_CODE = 'CCC'
  MATERNITY_LEAVE = 'maternityLeave'
  MATERNITY_LEAVE_CODE = 'CMA'
  UNMOTIVATED_ABSENCES = 'unmotivatedAbsences'
  UNMOTIVATED_ABSENCES_CODE = 'ABS'

  # Reports
  PROJECT_REPORT = 'projectReport'
  TEACHER_REPORT = 'teacherReport'
  ONLINE_REPORT = 'onlineReport'

  # Formats
  BOLD_FORMAT = Spreadsheet::Format.new weight: :bold
  SIMPLE_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true
  LEFT_ALIGN_FORMAT = Spreadsheet::Format.new horizontal_align: :left, vertical_align: :middle
  RIGHT_ALIGN_FORMAT = Spreadsheet::Format.new horizontal_align: :right, vertical_align: :middle
  TOP_BOLD_BORDER_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :top, text_wrap: true,
                                                   border: :thin, bold: true
  LEFT_TOP_BOLD_BORDER_FORMAT = Spreadsheet::Format.new horizontal_align: :left, vertical_align: :top, text_wrap: true,
                                                        border: :thin, bold: true
  BIG_FONT_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true,
                                            bold: true, size: 14
  ROTATE_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true,
                                          border: :thin, bold: true, rotation: 90
  CENTER_BOLD_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true,
                                               bold: true
  RIGHT_BOLD_FORMAT = Spreadsheet::Format.new horizontal_align: :right, vertical_align: :middle, text_wrap: true,
                                              bold: true
  BOLD_BORDER_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, text_wrap: true,
                                               border: :thin, bold: true
  TOP_BORDER_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :top, border: :thin,
                                              text_wrap: true
  LEFT_TOP_BORDER_FORMAT = Spreadsheet::Format.new horizontal_align: :left, vertical_align: :top, border: :thin,
                                                   text_wrap: true
  GREY_FORMAT = Spreadsheet::Format.new horizontal_align: :left, vertical_align: :top, border: :thin, text_wrap: true,
                                        pattern: 1, pattern_fg_color: :grey
  LEFT_BOLD_FORMAT = Spreadsheet::Format.new horizontal_align: :left, vertical_align: :middle, text_wrap: true,
                                             bold: true
  ITALIC_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, border: :thin,
                                          italic: true
  LEFT_BORDER_FORMAT = Spreadsheet::Format.new horizontal_align: :left, vertical_align: :middle, border: :thin,
                                               text_wrap: true
  BORDER_FORMAT = Spreadsheet::Format.new horizontal_align: :centre, vertical_align: :middle, border: :thin,
                                          text_wrap: true
  RED_BOLD_BORDER_FORMAT = Spreadsheet::Format.new border: :thin, bold: true, horizontal_align: :centre,
                                                   vertical_align: :middle, color: :red, text_wrap: true
  RED_FORMAT = Spreadsheet::Format.new color: :red, horizontal_align: :centre, vertical_align: :middle
  RED_PATTERN_FORMAT = Spreadsheet::Format.new color: :red, horizontal_align: :centre, vertical_align: :middle,
                                               pattern: 2, pattern_fg_color: :red
  RIGHT_BORDER_BOLD_FORMAT = Spreadsheet::Format.new border: :thin, bold: true, horizontal_align: :right,
                                                     vertical_align: :middle
  RED_BOLD_FORMAT = Spreadsheet::Format.new bold: true, color: :red
  JUST_BORDER_FORMAT = Spreadsheet::Format.new border: :thin
end

# frozen_string_literal: true

module Constants
  # General
  XLS_TYPE = 'text/xls'
  BUCHAREST_TIMEZONE = 'Bucharest'

  # Authenticate
  AUTHORIZATION_HEADER = 'Authorization'
  NOT_AUTHORIZED = 'Not Authorized'
  INVALID_TOKEN = 'Invalid token'

  # Mailer
  DEFAULT_EMAIL = 'peledanyel@gmail.com'
  LAYOUT_MAILER = 'mailer'
  RESET_PASSWORD = 'Resetare parola'

  # Sessions
  NO_ACCOUNT_MESSAGE = 'Nu exista niciun cont cu acest email!'
  INCORRECT_PASSWORD_MESSAGE = 'Parola incorecta!'

  # Users
  EMPLOYEE_TYPE = 'Angajat'
  USER_TYPES = %w[Angajat Colaborator].freeze

  # Events
  COLLABORATOR_EVENTS = ['Curs', 'Seminar', 'Laborator', 'Ora de proiect'].freeze
  PROJECT_TYPE = 'proiect'
  HOLIDAY_TYPE = 'concediu'
  BASIC_NORM = 'norma de baza'
  HOURLY_PAYMENT = 'plata cu ora'
  DAILY = 'daily'
  WEEKLY = 'weekly'
  EVERY_OTHER_WEEK = 'every other week'
  MONTHLY = 'monthly'
  YEARLY = 'yearly'
  DAILY_RO = 'Zilnic'
  WEEKLY_RO = 'Saptamanal'
  EVERY_OTHER_WEEK_RO = 'La doua saptamani'
  MONTHLY_RO = 'Lunar'
  YEARLY_RO = 'Anual'
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
  COURSES_FILE_NAME = 'Cursuri.xls'
  COURSE_MODEL = 'Course'
  COURSE_HEADERS = ['Nume', 'An de studiu', 'Semestru', 'Ciclu(Licenta, Master, Doctorat)',
                    'Facultate', 'Descriere'].freeze
  COURSES_SHEET_NAME = 'Cursuri'
  COURSE = 'Curs'
  SEMINAR = 'Seminar'
  LABORATORY = 'Laborator'
  PROJECT_HOUR = 'Ora de proiect'
  EVALUATION = 'Evaluare'
  CONSULTATIONS = 'Consultatii'
  TEACHING_ACTIVITY_PREPARATION = 'Pregatire pentru activitatea didactica'
  COURSE_HOUR = 'Activitate didactica'

  # Projects
  PROJECTS_FILE_NAME = 'Proiecte.xls'
  PROJECT_MODEL = 'Project'
  PROJECT_HEADERS = ['Nume', 'Ore pe luna', 'Restrictie ora de inceput',
                     'Restrictie ora de sfarsit', 'Descriere'].freeze
  PROJECTS_SHEET_NAME = 'Proiecte'
  PROJECT = 'Proiect'

  # Other Activities
  OTHER_ACTIVITY = 'Alta activitate'
  DOCTORAL_STUDENTS_GUIDANCE = 'Indrumare doctoranzi'
  UNPAID_INVOLVEMENT_IN_SOCIETY = 'Implicare neremunerată în problematica societății'
  COOPERATION_MANAGEMENT = 'Gestiune cooperari'
  INTERNAL_DELEGATION_DAYS = 'Zile delegatie (Deplasare interna)'
  EXTERNAL_DELEGATION_DAYS = 'Zile delegatie (Deplasare externa)'
  DEPARTURE_WITH_SCHOLARSHIP = 'Plecati cu bursa'
  OTHER_ACTIVITIES = 'Alte activitati'
  RESEARCH_DOCUMENTATION = 'Documentare pentru cercetare'
  PROJECT_FINANCING_OPPORTUNITIES_DOCUMENTATION = 'Documentare oportunitati de finantare proiecte'
  RESEARCH_PROJECTS_ELABORATION = 'Elaborare proiecte de cercetare'
  RESEARCH_PROJECTS_EXECUTION = 'Executarea proiecte de cercetare'

  # Holidays
  HOLIDAY = 'Concediu'
  VACATION = 'Concediu de odihna'
  SICK_LEAVE = 'Concediu medical'
  UNPAID_LEAVE = 'Concediu fara salariu'
  CHILD_GROWTH_LEAVE = 'Concediu crestere copil'
  MATERNITY_LEAVE = 'Concediu de maternitate'
  UNMOTIVATED_ABSENCES = 'Absente nemotivate'
end

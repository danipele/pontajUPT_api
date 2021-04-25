# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
OtherActivity.create name: 'Indrumare doctoranzi'
OtherActivity.create name: 'Implicare neremunerată în problematica societății'
OtherActivity.create name: 'Gestiune cooperari'
OtherActivity.create name: 'Zile delegatie (Deplasare interna)'
OtherActivity.create name: 'Zile delegatie (Deplasare externa)'
OtherActivity.create name: 'Plecati cu bursa'
OtherActivity.create name: 'Alte activitati'
OtherActivity.create name: 'Documentare pentru cercetare'
OtherActivity.create name: 'Documentare oportunitati de finantare proiecte'
OtherActivity.create name: 'Elaborare proiecte de cercetare'
OtherActivity.create name: 'Executie proiecte de cercetare'

Holiday.create name: 'Concediu medical'
Holiday.create name: 'Concediu de odihna'
Holiday.create name: 'Concediu fara salariu'
Holiday.create name: 'Concediu crestere copil'
Holiday.create name: 'Concediu de maternitate'
Holiday.create name: 'Absente nemotivate'

User.create email: 'angajat@email.com', password: 'wertyuio', first_name: 'dani', last_name: 'pele',
            type: 'Angajat'
User.create email: 'colaborator@email.com', password: 'wertyuio', first_name: 'dani', last_name: 'pele',
            type: 'Colaborator'
User.create email: 'admin@email.com', password: 'wertyuio', first_name: 'dani', last_name: 'pele',
            type: 'Admin'

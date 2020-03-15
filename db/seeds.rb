puts "Cleaning databse from old records..." if User.any?

User.destroy_all if User.any?

puts "Seeding database..."

User.create! \
  admin:                 true,
  name:                  'Goku',
  email:                 'goku@san.com',
  password:              'password',
  password_confirmation: 'password',
  activated:             true,
  activated_at:          Time.zone.now

99.times do |n|
  name     = Faker::Name.name
  email    = "user-#{n + 1}@test.com"
  password = "password"

  User.create! \
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now
end

puts "Database successfuly seeded!"

puts "Cleaning databse from old records..." if User.any?

User.destroy_all if User.any?

puts "Seeding database..."

100.times do |n|
  name     = Faker::Name.name
  email    = "user-#{n + 1}@test.com"
  password = "password"

  User.create! \
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password
end

puts "Database successfuly seeded!"

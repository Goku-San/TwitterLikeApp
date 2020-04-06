puts "Cleaning databse from old records..." if User.any? || Micropost.any?

User.destroy_all if User.any?
Micropost.destroy_all if Micropost.any?

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

users = User.order(:created_at).take 6

20.times do
  content = Faker::Lorem.sentence word_count: 5

  users.each { |user| user.microposts.create! content: content }
end

puts "Database successfuly seeded!"

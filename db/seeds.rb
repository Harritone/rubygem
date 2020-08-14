User.create!(email: 'test@test.com', password: '111111', password_confirmation: '111111')

puts "Admin created"

30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::ChuckNorris.fact,
    user_id: User.first.id
  }])
end

puts "30 courses created"

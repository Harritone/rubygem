#User.create!(email: 'test@test.com', password: '111111', password_confirmation: '111111')

puts "Admin created"

30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::ChuckNorris.fact,
    user_id: User.first.id,
    short_description: Faker::Quote.most_interesting_man_in_the_world,
    level: "Begginer",
    language: "#{["Russian", "Spanish", "English", "French"].sample}",
    price: Faker::Number.between(from: 1000, to: 20000)

  }])
end

puts "30 courses created"

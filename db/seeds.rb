#User.create!(email: 'test@test.com', password: '111111', password_confirmation: '111111')
#user = User.new(
#  email: 'test@test.com',
#  password: '111111',
#  password_confirmation: '111111'
#)
#user.skip_confirmation!
#user.save!
#
#puts "Admin created"

PublicActivity.enabled = false
30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::ChuckNorris.fact,
    user_id: User.first.id,
    short_description: Faker::Quote.most_interesting_man_in_the_world,
    level: "Begginer",
    language: "#{["Russian", "Spanish", "English", "Polish", "French"].sample}",
    price: Faker::Number.between(from: 1000, to: 20000)

  }])
end
PublicActivity.enabled = true

puts "30 courses created"

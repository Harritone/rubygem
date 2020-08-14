30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::ChuckNorris.fact
  }])
end

puts "30 courses created"

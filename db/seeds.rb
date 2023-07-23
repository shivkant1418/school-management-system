# frozen_string_literal: true

# db/seeds.rb

%w[student school_admin admin].each do |role|
  Role.create(name: role)
end

# Create Admin user with the 'admin' role
User.create!(email: 'admin@example.com', password: 'password', role_ids: Role.admin.id)

2.times do |index|
  User.create!(email: "schooladmin#{index + 100}@example.com", password: 'password', role_ids: Role.school_admin.id)
end

# Create Student User with the 'student' role
10.times do |index|
  User.create!(email: "student#{index + 1}@example.com", password: 'password', role_ids: Role.student.id)
end

# Create a school
5.times do
  school_name = Faker::University.unique.name
  school_location = Faker::Address.city
  school_motto = Faker::Company.catch_phrase
  num_students = Faker::Number.within(range: 100..2000)
  course = Faker::Educator.course

  description = "#{school_name} is located in the heart of #{school_location}. With the motto '#{school_motto}', our school is dedicated to providing quality education to #{num_students} students. Offering a wide range of courses like '#{course}', we strive to nurture a diverse learning environment. Our experienced faculties are committed to empowering students and fostering a love for learning. At #{school_name}, we believe in preparing our students for success and equipping them with the skills for a brighter future."

  School.create!(name: school_name, address: school_location, description: description)
end

# Create courses for the school
School.first(2).each do |school|
  3.times do
    Course.create!(name: Faker::Educator.unique.course, description: Faker::Lorem.sentences.join(' '), school: school)
  end
end

# Create batches for the course
Course.first(2).each do |course|
  ('A'..'C').each do |letter|
    Batch.create(name: "Batch #{letter}", description: Faker::Lorem.sentences.join(' '), start_date: '2023-09-01',
                 end_date: '2024-06-30', course: course)
  end
end

# Seed data for school_admins
School.last(2).each do |school|
  school_admin_user = User.create!(email: "schooladmin#{school.id}@example.com", password: 'password',
                                   role_ids: Role.school_admin.id)

  # Create SchoolAdmin user with the 'school_admin' role
  School::Admin.create(user: school_admin_user, school: school)
end

# Seed data for enrolments
Role.student.users.first(3).each do |user|
  Enrollment.create(student: user, batch: Batch.first).approved!
  Enrollment.create(student: user, batch: Batch.second).rejected!
  Enrollment.create(student: user, batch: Batch.third)
end

Role.student.users.last(2).each do |user|
  Enrollment.create(student: user, batch: Batch.first)
  Enrollment.create(student: user, batch: Batch.second).approved!
  Enrollment.create(student: user, batch: Batch.third).rejected!
end

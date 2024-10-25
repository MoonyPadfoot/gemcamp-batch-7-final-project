# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
3.times do
  user = User.create!(email: Faker::Internet.email, username: Faker::Internet.username(specifier: 10), password: '123456', password_confirmation: "123456",
                      phone_number: "09#{Faker::Number.number(digits: 9)}", coins: Faker::Number.between(from: 1, to: 100), role: 1,
                      total_deposit: Faker::Number.decimal(l_digits: 2, r_digits: 2), children_members: Faker::Number.between(from: 0, to: 5))
  puts "create user id: #{user.id}, email: #{user.email}. username: #{user.username}"
end
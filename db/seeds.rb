# sam/db/seeds.rb

# 1. Create a user (your "Auth for you")
user = User.find_or_create_by!(email: "august@example.com") do |u|
  u.password = "password123"
end

# 2. Create some books for that user
user.books.create!([
  { title: "Tomorrow, and Tomorrow, and Tomorrow", author: "Gabrielle Zevin", is_public: true },
  { title: "The Hobbit", author: "J.R.R. Tolkien", is_public: true },
  { title: "Personal Diary", author: "August", is_public: false } # This one shouldn't show up in public
])

puts "Sam has been seeded with books!"

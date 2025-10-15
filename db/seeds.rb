# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# USER ROLES SEEDING

puts "🌱 Seeding user roles..."

["Admin", "Author", "Arc Reader", "Beta Reader", "Proof Reader"].each do |role|
  Role.find_or_create_by!(role: role)
end

# BOOK GENRES SEEDING - GENERAL CATEGORIES

puts "🌱 Seeding genres..."

["Biographies & Memoirs", "Business & Money","Children's Books", "History", "Self-Help", "Teen & Young Adult", "Westerns", "NSFW 18+"].each do |genre|
  Genre.find_or_create_by!(name: genre)
end

# BOOK GENRES SEEDING - ROMANCE SUBCATEGORIES

puts "🌱 Seeding romance subgenres..."

romance = Genre.create!(name: "Romance")
["Romantic Suspense","Romantic Comedy", "New Adult & College", "Second Chances", "Forbidden Love", "Alpha Males", "Fantasy", "Enemies to Lovers", "Contemporary", "Werewolves & Shifters", "Paranormal", "Historical Romance", "Dark Romance", "Science Fiction"].each do |genre|
  Genre.find_or_create_by!(name: genre, parent: romance)
end

# BOOK GENRES SEEDING - MYSTERY, THRILLER & SUSPENSE SUBCATEGORIES

puts "🌱 Seeding mystery, thriller & suspense subgenres..."

mystery = Genre.create!(name: "Mystery, Thriller & Suspense")
["Crime", "Murder", "Female Protagonists", "Amateur Sleuths", "Psychological Thrillers", "Supernatural", "Serial Killers", "Conspiracy", "Espionage", "Kidnapping", "Historical", "Vigilante", "Suspense", "Assassinations"].each do |genre|
  Genre.find_or_create_by!(name: genre, parent: mystery)
end

# BOOK GENRES SEEDING - SCIENCE FICTION & FANTASY SUBCATEGORIES

puts "🌱 Seeding science fiction & fantasy subgenres..."

sf_fantasy = Genre.create!(name: "Science Fiction & Fantasy")
["Epic", "Dark Fantasy","Space Opera", "Post-Apocalyptic", "Aliens", "Wizards & Witches", "Urban Fantasy", "Dystopian", "Dragons", "Supernatural Sci-Fi Fantasy", "Myths & Legends", "Time Travel", "Genetic Engineering", "Space Travel", "Cyberpunk"].each do |genre|
  Genre.find_or_create_by!(name: genre, parent: sf_fantasy)
end

# SEEDING TEST USERS

puts "🌱 Seeding test users..."

# Base test users (excluding admin)
base_users = [
  {
    first_name: 'Jane',
    last_name: 'Writer',
    username: 'jane_writer',
    roles: ['Author']
  },
  {
    first_name: 'Mike',
    last_name: 'Reviewer',
    username: 'mike_arc',
    roles: ['Arc Reader'],
    bio: 'Voracious reader specializing in sci-fi and fantasy.',
    instagram: 'mike_reads',
    x: 'mike_reviews'
  },
  {
    first_name: 'Sarah',
    last_name: 'Beta',
    username: 'sarah_beta',
    roles: ['Beta Reader'],
    bio: 'Professional beta reader with 5+ years experience.',
    facebook: 'sarahbetareads',
    x: 'sarah_beta'
  },
  {
    first_name: 'David',
    last_name: 'Sharp',
    username: 'david_proof',
    roles: ['Proof Reader'],
    bio: 'Detail-oriented proofreader. Former English teacher.',
    facebook: 'davidsharpediting'
  },
  {
    first_name: 'Alex',
    last_name: 'Multi',
    username: 'alex_multi',
    roles: ['Author', 'Beta Reader'],
    bio: 'Author and beta reader.',
    facebook: 'alex_multi',
    instagram: 'alex_writes_romance',
    x: 'alex_multi'
  }
]

# Create 20 of each base user type
20.times do |i|
  base_users.each do |template|
    email = "#{template[:roles].first.downcase.gsub(' ', '')}#{i+1}@earlyDraftSociety.com"
    username = "#{template[:username]}_#{i+1}"

    user = User.find_or_create_by(email: email) do |u|
      u.password = 'Password1!'
      u.password_confirmation = 'Password1!'
      u.first_name = "#{template[:first_name]}#{i+1}"
      u.last_name = template[:last_name]
      u.username = username
      u.bio = template[:bio]
      u.facebook = template[:facebook]
      u.instagram = template[:instagram]
      u.x = template[:x]
      u.subscription_status = 'active'
      u.subscription_type = 'free'
      u.tos_accepted = true
    end

    if user.persisted?
      template[:roles].each do |role_name|
        role = Role.find_by(role: role_name)
        UserRole.find_or_create_by!(user: user, role: role)
      end
      puts "  ✓ Created #{template[:roles].join(', ')} user: #{email}"
    else
      puts "  ❌ Failed to create #{email}: #{user.errors.full_messages.join(', ')}"
    end
  end
end

# Create admin separately
admin = User.find_or_create_by(email: 'administrator@earlyDraftSociety.com') do |u|
  u.password = 'Password1!'
  u.password_confirmation = 'Password1!'
  u.first_name = 'Admin'
  u.last_name = 'User'
  u.username = 'admin_user'
  u.subscription_status = 'active'
  u.subscription_type = 'free'
  u.tos_accepted = true
end

if admin.persisted?
  role = Role.find_by(role: 'Admin')
  UserRole.find_or_create_by!(user: admin, role: role)
  puts "  ✓ Created Admin user: #{admin.email}"
end

puts "🎉 Seeding completed!"
puts "\nTest Login Credentials:"
puts "========================"
base_users.each do |user_data|
  puts "#{user_data[:roles].join('/')} User: #{user_data[:email]} / Password1!"
end
puts "\n💡 All users use the password: Password1!"
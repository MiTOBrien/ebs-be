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

# Test users data
test_users = [
  {
    email: 'administrator@earlyDraftSociety.com',
    password: 'password123',
    first_name: 'Admin',
    last_name: 'User',
    username: 'admin',
    roles: ['Admin']
  },
  {
    email: 'author@earlyDraftSociety.com',
    password: 'password123',
    first_name: 'Jane',
    last_name: 'Writer',
    username: 'jane_writer',
    roles: ['Author']
  },
  {
    email: 'arcreader@earlyDraftSociety.com',
    password: 'password123',
    first_name: 'Mike',
    last_name: 'Reviewer',
    username: 'mike_arc',
    roles: ['Arc Reader'],
    bio: 'Voracious reader specializing in sci-fi and fantasy. I provide honest, constructive reviews.',
    professional: false,
    instagram: 'mike_reads',
    x: 'mike_reviews'
  },
  {
    email: 'betareader@earlyDraftSociety.com',
    password: 'password123',
    first_name: 'Sarah',
    last_name: 'Beta',
    username: 'sarah_beta',
    roles: ['Beta Reader'],
    bio: 'Professional beta reader with 5+ years experience. I focus on plot, character development, and pacing.',
    professional: true,
    facebook: 'sarahbetareads',
    x: 'sarah_beta'
  },
  {
    email: 'proofreader@earlyDraftSociety.com',
    password: 'password123',
    first_name: 'David',
    last_name: 'Sharp',
    username: 'david_proof',
    roles: ['Proof Reader'],
    bio: 'Detail-oriented proofreader specializing in grammar, punctuation, and formatting. Former English teacher.',
    professional: true,
    facebook: 'davidsharpediting'
  },
  {
    email: 'multi@earlyDraftSociety.com',
    password: 'password123',
    first_name: 'Alex',
    last_name: 'Multi',
    username: 'alex_multi',
    roles: ['Author', 'Beta Reader'],
    bio: 'Author and beta reader. I write romance novels and love helping other authors polish their work.',
    professional: false,
    facebook: 'alex_multi',
    instagram: 'alex_writes_romance',
    x: 'alex_multi'
  }
]

puts "Creating test users..." # Roles already seeded above

test_users.each do |user_data|
  # Create or find the user
  user = User.find_or_create_by(email: user_data[:email]) do |u|
    u.password = user_data[:password]
    u.password_confirmation = user_data[:password]
    u.first_name = user_data[:first_name]
    u.last_name = user_data[:last_name]
    u.username = user_data[:username]
    u.bio = user_data[:bio]
    u.professional = user_data[:professional]
    u.facebook = user_data[:facebook]
    u.instagram = user_data[:instagram]
    u.x = user_data[:x]
  end

  if user.persisted?
    puts "  ✓ #{user.first_name} #{user.last_name} (#{user.email})"
    
    # Assign roles
    user_data[:roles].each do |role_name|
      role = Role.find_by(role: role_name)
      unless user.roles.include?(role)
        UserRole.create!(user: user, role: role)
        puts "    → Assigned #{role_name} role"
      end
    end
    
    # Show assigned roles
    puts "    → Total roles: #{user.roles.map(&:role).join(', ')}"
  else
    puts "  ❌ Failed to create #{user_data[:first_name]} #{user_data[:last_name]}: #{user.errors.full_messages.join(', ')}"
  end
  
  puts "" # Empty line for readability
end

puts "🎉 Seeding completed!"
puts "\nTest Login Credentials:"
puts "========================"
test_users.each do |user_data|
  puts "#{user_data[:roles].join('/')} User: #{user_data[:email]} / password123"
end
puts "\n💡 All users use the password: password123"
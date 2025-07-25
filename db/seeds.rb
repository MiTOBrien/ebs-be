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
["Admin", "Author", "Arc Reader", "Beta Reader", "Proof Reader"].each do |role|
  Role.find_or_create_by!(role: role)
end

# BOOK GENRES SEEDING - GENERAL CATEGORIES
["Biographies & Memoirs", "Business & Money","Children's Books", "History", "Teen & Young Adult", "Self-Help", "NSFW 18+"].each do |genre|
  Genre.find_or_create_by!(name: genre)
end

# BOOK GENRES SEEDING - ROMANCE SUBCATEGORIES
["Romance", "Romantic Suspense","Romantic Comedy", "New Adult & College", "Second Chances", "Forbidden Love", "Alpha Males", "Fantasy", "Enemies to Lovers", "Contemporary", "Werewolves & Shifters", "Paranormal", "Historical", "Dark", "Science Fiction"].each do |genre|
  Genre.find_or_create_by!(name: genre)
end

# BOOK GENRES SEEDING - MYSTERY, THRILLER & SUSPENSE SUBCATEGORIES
["Mystery, Thriller & Suspense", "Crime", "Murder","Female Protagonists", "Amateur Sleuths", "Psychological Thrillers", "Supernatural", "Serial Killers", "Conspiracy", "Espionage", "Kidnapping", "Historical", "Vigilante", "Suspense", "Assassinations"].each do |genre|
  Genre.find_or_create_by!(name: genre)
end

# BOOK GENRES SEEDING - SCIENCE FICTION & FANTASY SUBCATEGORIES
["Science Fiction & Fantasy", "Epic", "Dark Fantasy","Space Opera", "Post-Apocalyptic", "Aliens", "Wizards & Witches", "Urban Fantasy", "Dystopian", "Dragons", "Supernatural", "Myths & Legends", "Time Travel", "Genetic Engineering", "Space Travel", "Cyberpunk"].each do |genre|
  Genre.find_or_create_by!(name: genre)
end
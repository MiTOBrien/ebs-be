# EARLY DRAFT SOCIETY

This is a website designed for Arc, Beta, and Proof readers to be able to advertise their services and for Authors to be able to browse the list of Arc/Beta/Proof readers to find someone to work with them on their books.

![homepage image](public/eds_login_page.png)

## Deployed Site
- Coming soon

## Front End Repo
[Front End Repo](https://github.com/MiTOBrien/eds)

## Technology Used
* Ruby 3.2.3
* Rails 7.1.5
* PostgresSQL 1.1

### Gems
* devise
* devise-jwt
* jsonapi serializer
* RSpec 7.0.0
* shoulda-matchers
* Faker
* Factorybot
* simplecov
* Pry

## Getting Started
To run this locally clone this repository onto your local machine. Change directory into the eds-be directory and install all dependiences:
```
bundle install
```

To launch the backend server:
```sh
rails server (or rails s)
```

To see the application fully functioning you will also need to clone down the front end repository and run that as well.

## Database creation and setup
To quickly set up the database from the command line:
```sh
rails db:{drop,create,migrate,seed} or rails db:reset
```

## Routes/Endpoints
### users
- Register        - /signup
- Login           - /login
- Logout          - /logout
- Update profile  - /users/#id

## Testing Suite
* RSpec

To run the RSpec tests from the command prompt run:
```sh
rspec spec
```
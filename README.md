# Board Games

Web app for organising board game events

## Setup

- Install docker
- Clone repo
- Setup the database  `docker-compose run --rm rails db:setup`
- Run the tests `docker-compose run --rm web rspec`
- Create an admin user `docker-compose run --rm web rails users:create_admin`
- Start the app `docker-compose up`
- Visit `localhost:3000` and log in!
- Shutdown the app when finished `docker-compose down`

# Board Games

Web app for organising board game events

## Setup

- Install docker
- Clone repo
- Install JS dependencies `docker-compose run --rm web yarn`
- Setup the database  `docker-compose run --rm web rails db:setup`
- Run the tests `docker-compose run --rm web rspec`
- Create an admin user `docker-compose run --rm web rails users:create_admin`
- Start the app `docker-compose up`
- (Optional) Create some fake game data `docker-compose run --rm web rails demo:generate_data`
- Visit `localhost:3000` and log in!
- Shutdown the app when finished `docker-compose down
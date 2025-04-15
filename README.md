# Goodnite

This service is a take-home technical test for a job application.

Simple API-only Ruby on Rails application to let users track when they go to bed and when they wake up

## Endpoints

See the endpoints served by Goodnite in this [Postman](https://www.postman.com/) collection
- [Goodnite.postman_collection.json](https://github.com/user-attachments/files/19758578/Goodnite.postman_collection.json)
- [Goodnite Local.postman_environment.json](https://github.com/user-attachments/files/19753864/Goodnite.Local.postman_environment.json)


## Technical Guidelines

### Code directory structure

This app was initialized using this command:

```sh
rails new goodnite --database=postgresql --skip-action-cable --skip-javascript --skip-action-mailer --skip-action-mailbox --skip-solid --api
```

Hence the directory structure complies with [Rails' standard directory structure](https://guides.rubyonrails.org/getting_started.html#directory-structure)

### Requirements

Install these first; see the links for more details
1. [Git](https://git-scm.com/downloads)
2. [Ruby 3.4.2](https://guides.rubyonrails.org/install_ruby_on_rails.html#choose-your-operating-system)
3. [PostgreSQL 14.7](https://www.postgresql.org/download/)
4. [Rails 8.0.2](https://guides.rubyonrails.org/install_ruby_on_rails.html#installing-rails)

### Application Initial Setup

These steps only need to be done once.

1. Clone this repo. This repo already utilized go.mod, so you can clone it anywhere
```shell
git clone git@github.com:inassjunus/goodnite.git
```
2. Install dependencies
```shell
make prepare
```
3. Make sure PostgreSQL is already running.

```shell
# check for postgres
psql postgres
```

If they haven't, run them.
```shell
# starting redis in macOSX
brew services start postgresql
```
Check the respective guidelines to find the right command for your local machine.

4. Setup the database tables on PostgreSQL
```sh
# open PostgreSQL CLI
psql postgres
```

```shell
# inside the CLI create admin user if you don't have one yet
CREATE ROLE goodnite WITH LOGIN PASSWORD <your password>;
ALTER ROLE goodnite Superuser;
```

Login with the admin user

```shell
psql postgres -U goodnite
```

Create database inside the psql CLI
```shell
CREATE DATABASE goodnite_dev;
CREATE DATABASE goodnite_test;
```

Exit the postgreSQL CLI when you are done

5. Install gems
```sh
gem install bundler
bundle install
```

6. Run rails db migration
```sh
bin/rails db:migrate
```

7. Copy env.sample, then adjust the values with the your own environment details
```shell
cp env.sample .env
```
Please double check that the database values are correct

8. [OPTIONAL] Initialize app data
```sh
# with default limit, each limit is 20 by default
bin/rails db:seed

# with custom data limit
bin/rails db:seed seed_user_limit=2 seed_clock_in_limit=1 seed_following_limit=1
```

### Running the service

1. You can run the service with this command

```shell
bin/rails server

```

2. To make sure the application running, try running this command; it should return 200 OK response
```shell
curl localhost:3000/up
```

### Contribution
#### Linting
Please always ensure the code complies with the Ruby on Rails syntax convention by running this command before committing

```sh
bin/rubocop -a -f github
```

#### Testing

##### Unit Test
Run basic unit tests. This is the test that MUST be run before each commit:
```shell
bin/rails db:test:prepare test
```

##### Postman Test
1. Import the Postman collection and environment from [here](https://github.com/inassjunus/goodnite?tab=readme-ov-file#endpoints) to your local Postman
2. Run the service based on [these steps](https://github.com/inassjunus/goodnite?tab=readme-ov-file#running-the-service)
3. Select a request and hit the `Send` button
4. Observe the endpoint response and test result

#### Troubleshooting

If you encounter an unexpected issue, you can try these things:
- Observe the server logs in terminal
- Use `binding.pry` on the code. See [the doc](https://github.com/pry/pry?tab=readme-ov-file#runtime-invocation) for more info. Please don't forget to remove the line before committing

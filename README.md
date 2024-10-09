# README

1. [Overview](#overview)
2. [Setup](#setup)
3. [Testing](#testing)
4. [Next Steps](#next-steps)

## Overview
The Echo application is designed using the Ruby on Rails framework. It responds to dynamic requests by matching predefined endpoints stored in the database. When a request matches a defined endpoint, the application returns a custom response with headers, status code, and body based on the endpoint configuration. If no matching endpoint is found, it returns a 404 with a "Endpoint not found" error message.

## Setup
1. Enter the project directory:
    ```bash
    cd project-directory
    ```
2. Install the specified gems:
    ``` bash
    bundle install
    ```
3. Create the database:
    ``` bash
    rails db:create
    ```
4. Run the database migrations:
    ``` bash
    rails db:migrate
    ```
5. Start the Rails server:
    ``` bash
    rails s
    ```
The application will now be running at http://localhost:3000.

## Testing
The Echo application uses RSpec for testing. Make sure the test database is created and migrated.

1. To run all tests, follow these steps:
    ``` bash
    rspec spec
    ```
This will run all the tests within the spec folder.
## Next Steps
- [ ] Application cleanup - remove redundant parts of code after initialing Rails project

- [ ] Refactor Model Validations - in order to keep the models small and maintainable, refactor complex validation methods, replace it with json-schema approach.

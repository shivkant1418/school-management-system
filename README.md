# School Management System

## Description
The School Management System is a web application built using Ruby on Rails. It provides a platform for managing schools, courses, batches, enrollments, and user roles. Additionally, it includes APIs for student-specific actions. Currently, admin actions can be done via the web application only.

## Features
- User Roles: The system supports three types of user roles - Admin, School Admin, and Student. Each role has different levels of access and privileges.
- Schools: Admins can manage schools, and school admins have access to their respective schools.
- Courses: Schools can offer multiple courses, and school admins can manage the courses.
- Batches: Each course can have multiple batches, and school admins can manage batches for their courses.
- Enrollments: Students can request enrollment for batches, and school admins can approve or reject the requests.
- Authentication: The system uses Devise for user authentication and rolify for role management.
- Authorization: The system uses CanCanCan to handle user authorization based on their roles.
- Pagination: The application uses the `will_paginate` gem for pagination in lists.
- Search: Users can filter and search for schools, courses, batches, and enrollments based on various criteria.

## APIs for Students

The application includes APIs for student-related actions. These APIs are documented using Swagger and can be accessed at `http://localhost:3000/api-docs/index.html`. Swagger allows you to explore and test the APIs directly from the documentation.

## Setup and Installation
1. Ensure you have Ruby 3.0.0 installed on your system.
2. Clone the repository from GitHub.
3. Install the required gems by running `bundle install`.
4. Create and set up the database by running `rails db:create` and `rails db:migrate`.
5. Seed the database with initial data by running `rails db:seed`.

## JavaScript Build

This application uses the cssbundling-rails and jsbundling-rails gems to manage CSS and JavaScript assets. After making changes to your CSS or JavaScript files and with your initial setup, you need to build the app to compile the assets.

To build the app and compile the assets, run the following command:

```bash
  rails css:build && rails javascript:build
```

Also, these assets build uses `yarn` so make sure that you have `yarn` install.

In case javascript function or dropdown click does not work in application please delete the files under the build folder and build the assets running same command.

## Usage
1. Run the Rails server with `rails server`.
2. Access the application in your web browser by visiting `http://localhost:3000/`.
3. You will be prompted to log in or sign up. Use the provided seeds for testing.

## Testing
The application includes unit tests and integration tests using RSpec, FactoryBot, and Shoulda Matchers. To run the tests, use the following command:


```bash
  bundle exec rspec
```

## License
The School Management System is open-source software released under the MIT License. See the LICENSE file for details.

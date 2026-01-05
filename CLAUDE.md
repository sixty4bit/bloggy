# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

This is a Ruby on Rails 8 application using modern Rails stack:
- **Database**: PostgreSQL with UUID primary keys
- **Assets**: Propshaft asset pipeline with ImportMaps for JavaScript
- **Frontend**: Hotwire (Turbo + Stimulus) for SPA-like behavior, Bootstrap 5 for CSS
- **Authentication**: Magic link authentication
- **Authorization**: Role-based (owner, admin, member)
- **Deployment**: Kamal for Docker-based deployment

## Development Commands

### Setup and Server
- `bin/setup` - Full environment setup
- `bin/dev` - Start Rails development server with CSS watching
- `bin/rails server` - Start server directly

### Database
- `bin/rails db:prepare` - Prepare database (create/migrate/seed as needed)
- `bin/rails db:migrate` - Run pending migrations
- `bin/rails db:seed` - Load seed data

### Testing
- `bin/rails test` - Run all tests
- `bin/rails test test/models/user_test.rb` - Run specific test file
- `bin/rails test:system` - Run system tests

### Code Quality
- `bin/rubocop` - Run Ruby linting
- `bin/brakeman` - Run security analysis

## Development Philosophy

This project follows **DHH's Rails best practices** and the Rails doctrine:

### Controller Design
- ALWAYS follow RESTful conventions
- ONLY use the 7 standard actions: index, show, new, create, edit, update, destroy
- NEVER add custom actions to controllers
- For non-RESTful behavior, create new controllers with RESTful actions

### Code Organization
- **Convention over Configuration**: Follow Rails naming conventions strictly
- **Fat models, skinny controllers**: Business logic belongs in models
- **Concerns for shared behavior**: Use `app/models/concerns/` and `app/controllers/concerns/`

### Views and Frontend
- **Hotwire first**: Use Turbo and Stimulus instead of heavy JavaScript frameworks
- **Server-rendered HTML**: Prefer server-side rendering
- **HAML**: Use HAML for views

### Testing
- **Rails testing stack**: Use built-in test framework, not RSpec
- **Fixtures over factories**: Prefer Rails fixtures for test data
- **Test-driven development**: Write tests before code

### Code Style
- **Omakase Ruby styling**: Follow the rubocop-rails-omakase gem conventions

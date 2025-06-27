#!/usr/bin/env bash

# Exit on error
set -o errexit

# Install dependencies
bundle install

# Run database migrations (only runs new ones)
bundle exec rails db:migrate

# Seed the database (only if it's empty, or use a conditional check)
# For initial deploy, you might run this manually via Render's shell if needed
# For a simple API, seeding is often a one-time thing.
# We will run db:seed manually for the first deploy to avoid duplicates.
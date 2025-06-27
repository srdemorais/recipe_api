# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # In development, the Vue app is on localhost:8080.
    # In production, this will be the actual frontend domain.
    # For dev, we should allow all origins for simplicity, but we should be more specific in production.
    origins 'http://localhost:8080' # Explicitly allow your Vue dev server

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
  
  # New block for Heroku production frontend
  allow do
    # Replace 'your-heroku-frontend-app-name' with the actual name
    # you will choose for your Vue.js Heroku app (e.g., 'my-recipe-frontend-123.herokuapp.com')
    # You'll come back and update this after you deploy the frontend
    origins 'https://*.herokuapp.com' # Wildcard for Heroku subdomains
    # OR, once you know your frontend app name:
    # origins 'https://your-frontend-app-name.herokuapp.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

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
    origins 'https://recipe-frontend-vqn1.onrender.com' 

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true # Crucial if you're using cookies, sessions, or sending authentication tokens
  end
end

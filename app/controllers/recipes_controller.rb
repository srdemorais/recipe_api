class RecipesController < ApplicationController
  # GET /recipes
  def index
    @recipes = Recipe.all
    # For a simple display of all recipes
  end

  # GET /recipes/search?keywords=sugar,flour
  # or /recipes/search?keywords=egg&match_all=true
  def search
    keywords_param = params[:keywords]
    match_all = params[:match_all].present? # Check if match_all parameter is present

    if keywords_param.present?
      # Split the keywords by comma and remove empty strings
      keywords = keywords_param.split(',').map(&:strip).reject(&:empty?)

      if match_all
        @recipes = Recipe.find_by_all_ingredients(keywords)
      else
        @recipes = Recipe.find_by_any_ingredient(keywords)
      end
    else
      @recipes = Recipe.all # If no keywords, show all recipes
    end

    # Render a view (e.g., app/views/recipes/search.html.erb) or JSON
    # For API, you might render as JSON:
    render json: @recipes.to_a, status: :ok
  end
end
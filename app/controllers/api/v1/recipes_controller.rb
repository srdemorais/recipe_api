module Api
  module V1
    class RecipesController < ApplicationController
      def index
        ingredients_query = params[:ingredients]
        @recipes = [] # Initialize to empty array

        if ingredients_query.present?
          # Split the query string by comma, strip whitespace, and remove blanks
          # Convert to lowercase for case-insensitive comparison
          ingredients = ingredients_query.split(',').map { |s| s.strip.downcase }.reject(&:blank?)

          if ingredients.any?
            # Build the WHERE clause dynamically.
            # We need to ensure that the recipe's ingredients array contains EACH of the
            # provided ingredients (case-insensitively, partially matching).
            # This translates to:
            # EXISTS (SELECT 1 FROM unnest(ingredients) AS recipe_ingredient WHERE recipe_ingredient ILIKE '%chicken%')
            # AND EXISTS (SELECT 1 FROM unnest(ingredients) AS recipe_ingredient WHERE recipe_ingredient ILIKE '%rice%')
            # ... and so on for all provided ingredients.

            # Constructing the EXISTS subquery for each ingredient:
            # For each ingredient 'x', we want:
            # "(SELECT 1 FROM unnest(recipes.ingredients) AS i WHERE i ILIKE ?)"
            # And then combine these with ' AND '.
            
            conditions = []
            search_terms_for_query = []

            ingredients.each do |ingredient|
              conditions << "EXISTS (SELECT 1 FROM unnest(recipes.ingredients) AS ri WHERE ri ILIKE ?)"
              search_terms_for_query << "%#{ingredient}%"
            end

            # Apply the conditions to the Recipe model
            @recipes = Recipe.where(conditions.join(' AND '), *search_terms_for_query)
          end
        end

        # Render the recipes as JSON
        # Update `only` array to match your actual migration columns
        render json: @recipes.as_json(only: [
          :id,
          :title,
          :cook_time,
          :prep_time,
          :ingredients,
          :ratings,
          :cuisine,
          :category,
          :author,
          :image,
          :created_at,  # Include this if case we want this value in the API response
          :updated_at   # Include this if case we want this value in the API response
        ])
      end

      # We might also want a 'show' action
      # def show
      #   @recipe = Recipe.find(params[:id])
      #   render json: @recipe.as_json(only: [
      #     :id,
      #     :title,
      #     :cook_time,
      #     :prep_time,
      #     :ingredients,
      #     :ratings,
      #     :cuisine,
      #     :category,
      #     :author,
      #     :image,
      #     :created_at,
      #     :updated_at
      #   ])
      # rescue ActiveRecord::RecordNotFound
      #   render json: { error: 'Recipe not found' }, status: :not_found
      # end
    end
  end
end
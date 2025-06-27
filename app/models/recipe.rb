# # class Recipe < ApplicationRecord
# #   # Active Record will automatically handle the ingredients array.
# #   # When you retrieve a Recipe object, `recipe.ingredients` will be a Ruby Array.
# #   # When you save, Rails will convert the Ruby Array back to a PostgreSQL TEXT[] array.

# #   # You might add validations here, e.g.:
# #   validates :title, presence: true
# #   validates :ingredients, presence: true

# #   # Custom class method for filtering recipes
# #   # This method finds recipes that contain ALL of the given keywords in their ingredients
# #   def self.find_by_all_ingredients(keywords)
# #     return Recipe.none if keywords.blank? # Return empty relation if no keywords

# #     # Sanitize keywords for SQL injection by mapping to `ILIKE` conditions
# #     conditions = keywords.map do |keyword|
# #       # IMPORTANT: Use `connection.quote` or parameterization to prevent SQL injection
# #       # The `ILIKE` operator needs the '%' wildcards around the quoted keyword.
# #       sanitized_keyword = connection.quote("%#{keyword.strip.downcase}%")
# #       "EXISTS (SELECT 1 FROM unnest(ingredients) AS ingredient WHERE LOWER(ingredient) LIKE #{sanitized_keyword})"
# #     end.join(' AND ')

# #     # Execute the raw SQL query
# #     Recipe.where(conditions)
# #   end

# #   # Custom class method for filtering recipes
# #   # This method finds recipes that contain ANY of the given keywords in their ingredients
# #   def self.find_by_any_ingredient(keywords)
# #     return Recipe.none if keywords.blank?

# #     conditions = keywords.map do |keyword|
# #       sanitized_keyword = connection.quote("%#{keyword.strip.downcase}%")
# #       "EXISTS (SELECT 1 FROM unnest(ingredients) AS ingredient WHERE LOWER(ingredient) LIKE #{sanitized_keyword})"
# #     end.join(' OR ')

# #     Recipe.where(conditions)
# #   end
# # end

# class Recipe < ApplicationRecord
#   # Active Record will automatically handle the ingredients array.
#   # When you retrieve a Recipe object, `recipe.ingredients` will be a Ruby Array.
#   # When you save, Rails will convert the Ruby Array back to a PostgreSQL TEXT[] array.

#   # You might add validations here, e.g.:
#   validates :title, presence: true
#   validates :ingredients, presence: true

#   # Custom class method for filtering recipes
#   # This method finds recipes that contain ALL of the given keywords in their ingredients
#   def self.find_by_all_ingredients(keywords)
#     return Recipe.none if keywords.blank? # Return empty relation if no keywords

#     conditions = keywords.map do |keyword|
#       # Ensure keyword is lowercased and correctly quoted for ILIKE pattern
#       sanitized_keyword = connection.quote("%#{keyword.strip.downcase}%")
#       "EXISTS (SELECT 1 FROM unnest(ingredients) AS ingredient WHERE LOWER(ingredient) ILIKE #{sanitized_keyword})"
#     end.join(' AND ')

#     # Execute the raw SQL query
#     Recipe.where(conditions)
#   end

#   # Custom class method for filtering recipes
#   # This method finds recipes that contain ANY of the given keywords in their ingredients
#   def self.find_by_any_ingredient(keywords)
#     return Recipe.none if keywords.blank?

#     conditions = keywords.map do |keyword|
#       # Ensure keyword is lowercased and correctly quoted for ILIKE pattern
#       sanitized_keyword = connection.quote("%#{keyword.strip.downcase}%")
#       "EXISTS (SELECT 1 FROM unnest(ingredients) AS ingredient WHERE LOWER(ingredient) ILIKE #{sanitized_keyword})"
#     end.join(' OR ')

#     Recipe.where(conditions)
#   end

#   # Alternative for ANY using PostgreSQL's ANY array operator (less flexible for substrings)
#   # This is useful if your keywords are exact matches for elements in the array,
#   # but your requirement for "sugar", "flour" implies substring matching.
#   # For exact array element matching:
#   # def self.find_by_exact_any_ingredients(keywords)
#   #   Recipe.where("ingredients @> ARRAY[?]::text[]", keywords)
#   # end
# end
# 

class Recipe < ApplicationRecord
  # Active Record will automatically handle the ingredients array.
  # When you retrieve a Recipe object, `recipe.ingredients` will be a Ruby Array.
  # When you save, Rails will convert the Ruby Array back to a PostgreSQL TEXT[] array.

  # You might add validations here, e.g.:
  validates :title, presence: true
  validates :ingredients, presence: true

  # Custom class method for filtering recipes
  # This method finds recipes that contain ALL of the given keywords in their ingredients
  def self.find_by_all_ingredients(keywords)
    return Recipe.none if keywords.blank? # Return empty relation if no keywords

    conditions = keywords.map do |keyword|
      # Ensure keyword is lowercased and correctly quoted for ILIKE pattern
      sanitized_keyword = connection.quote("%#{keyword.strip.downcase}%")
      "EXISTS (SELECT 1 FROM unnest(ingredients) AS ingredient WHERE TRIM(LOWER(ingredient::text)) ILIKE #{sanitized_keyword})"
    end.join(' AND ')

    # Execute the raw SQL query
    Recipe.where(conditions)
  end

  # Custom class method for filtering recipes
  # This method finds recipes that contain ANY of the given keywords in their ingredients
  def self.find_by_any_ingredient(keywords)
    return Recipe.none if keywords.blank?

    conditions = keywords.map do |keyword|
      # Ensure keyword is lowercased and correctly quoted for ILIKE pattern
      sanitized_keyword = connection.quote("%#{keyword.strip.downcase}%")
      "EXISTS (SELECT 1 FROM unnest(ingredients) AS ingredient WHERE TRIM(LOWER(ingredient::text)) ILIKE #{sanitized_keyword})"
    end.join(' OR ')

    # Debugging: Print the generated SQL to the test console
    puts "DEBUG SQL for find_by_any_ingredient: SELECT * FROM recipes WHERE (#{conditions})"

    Recipe.where(conditions)
  end

  # Alternative for ANY using PostgreSQL's ANY array operator (less flexible for substrings)
  # This is useful if your keywords are exact matches for elements in the array,
  # but your requirement for "sugar", "flour" implies substring matching.
  # For exact array element matching:
  # def self.find_by_exact_any_ingredients(keywords)
  #   Recipe.where("ingredients @> ARRAY[?]::text[]", keywords)
  # end
end
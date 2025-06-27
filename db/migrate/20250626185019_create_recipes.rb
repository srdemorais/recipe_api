class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time
      t.integer :prep_time
      # Use `array: true` to tell Rails to create a PostgreSQL array type (TEXT[])
      t.text :ingredients, array: true, default: []
      t.numeric :ratings, precision: 3, scale: 2
      t.string :cuisine
      t.string :category
      t.string :author
      t.text :image # Using text for URL

      t.timestamps # Adds `created_at` and `updated_at` columns
    end

    # Add the GIN index for efficient array searching
    add_index :recipes, :ingredients, using: :gin
  end
end
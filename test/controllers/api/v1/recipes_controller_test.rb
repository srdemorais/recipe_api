require "test_helper"

class Api::V1::RecipesControllerTest < ActionDispatch::IntegrationTest
  # This line loads the fixtures before each test
  # This makes the data defined in recipes.yml available in your tests
  fixtures :recipes

  test "should get index" do
    get api_v1_recipes_url
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 0, json_response.length # Should be empty if no ingredients are provided
  end

  test "should return recipes matching single ingredient" do
    get api_v1_recipes_url, params: { ingredients: "chicken" }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length # Only chicken_rice_stir_fry should match
    assert_equal recipes(:chicken_rice_stir_fry).title, json_response.first['title']
  end

  test "should return recipes matching multiple ingredients" do
    get api_v1_recipes_url, params: { ingredients: "chicken, rice" }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
    assert_equal recipes(:chicken_rice_stir_fry).title, json_response.first['title']
  end

  test "should return recipes matching multiple ingredients case insensitively" do
    get api_v1_recipes_url, params: { ingredients: "Chicken, rICE" }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
    assert_equal recipes(:chicken_rice_stir_fry).title, json_response.first['title']
  end

  test "should return no recipes if no match" do
    get api_v1_recipes_url, params: { ingredients: "pizza, pasta" }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 0, json_response.length
  end

  test "should return no recipes if partial match not enough" do
    get api_v1_recipes_url, params: { ingredients: "chicken, potato" } # Chicken but not potato
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal 0, json_response.length
  end
end
require "test_helper"

class JogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jog = jogs(:one)
  end

  test "should get index" do
    get jogs_url, as: :json
    assert_response :success
  end

  test "should create jog" do
    assert_difference('Jog.count') do
      post jogs_url, params: { jog: { date: @jog.date, distance: @jog.distance, duration: @jog.duration, user_id: @jog.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show jog" do
    get jog_url(@jog), as: :json
    assert_response :success
  end

  test "should update jog" do
    patch jog_url(@jog), params: { jog: { date: @jog.date, distance: @jog.distance, duration: @jog.duration, user_id: @jog.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy jog" do
    assert_difference('Jog.count', -1) do
      delete jog_url(@jog), as: :json
    end

    assert_response 204
  end
end

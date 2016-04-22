require 'test_helper'

class StreamControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get next_instagram_photo" do
    get :next_instagram_photo
    assert_response :success
  end

  test "should get next_twitter_photo" do
    get :next_twitter_photo
    assert_response :success
  end

end

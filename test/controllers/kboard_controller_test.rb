require "test_helper"

class KboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kboard_index_url
    assert_response :success
  end
end

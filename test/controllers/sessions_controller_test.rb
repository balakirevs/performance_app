require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get create" do
    request.env["HTTP_REFERER"] = root_path
    get :create
    assert_redirected_to root_path
  end

  test "should get destroy" do
    request.env["HTTP_REFERER"] = root_path
    get :destroy
    assert_redirected_to root_path
  end

end

require 'test_helper'

class EnrollmentsControllerTest < ActionController::TestCase
  test "should post create" do
    post :create, { enrollment: { course_id: courses(:one) } }, { current_user_id: students(:one) }
    assert_redirected_to Course.last
  end

end

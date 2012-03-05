require 'test_helper'

module Railstar
  class GeneralControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end
  
  end
end

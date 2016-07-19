require 'test_helper'

class DealsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
    assert assigns(:deals).all? { |deal| deal.live? }
  end

  test "should get past" do
    get :past
    assert_response :success
    assert_template :past
    assert assigns(:deals).all? { |deal| deal.expired? }
  end

  test "should get search" do
    get(:search, {'search' => "st"})
    assert_response :success
    assert_template :search
    assert_equal( assigns(:deals).size, 5, "incorrect search result")
    assert assigns(:deals).all? { |deal| deal.publishable? && deal.title.match('st') }
  end

  test "should get refresh" do
    get(:refresh, {'id' => 8, format: :json})
    assert_response :success
    assert_template :refresh
    assert_not_nil( assigns(:deal), "deal exists")
    assert assigns(:deal).publishable?, 'Deal should be publishable'
  end

end

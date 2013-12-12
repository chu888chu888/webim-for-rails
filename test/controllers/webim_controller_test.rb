require 'test_helper'

class WebimControllerTest < ActionController::TestCase
  test "should get online" do
    get :online
    assert_response :success
  end

  test "should get offline" do
    get :offline
    assert_response :success
  end

  test "should get message" do
    get :message
    assert_response :success
  end

  test "should get presence" do
    get :presence
    assert_response :success
  end

  test "should get refresh" do
    get :refresh
    assert_response :success
  end

  test "should get status" do
    get :status
    assert_response :success
  end

  test "should get setting" do
    get :setting
    assert_response :success
  end

  test "should get history" do
    get :history
    assert_response :success
  end

  test "should get clear_history" do
    get :clear_history
    assert_response :success
  end

  test "should get download_history" do
    get :download_history
    assert_response :success
  end

  test "should get members" do
    get :members
    assert_response :success
  end

  test "should get join" do
    get :join
    assert_response :success
  end

  test "should get leave" do
    get :leave
    assert_response :success
  end

  test "should get buddies" do
    get :buddies
    assert_response :success
  end

  test "should get notifications" do
    get :notifications
    assert_response :success
  end

end

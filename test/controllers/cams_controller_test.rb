require 'test_helper'

class CamsControllerTest < ActionController::TestCase
  setup do
    @cam = cams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cam" do
    assert_difference('Cam.count') do
      post :create, cam: { alert: @cam.alert, title: @cam.title }
    end

    assert_redirected_to cam_path(assigns(:cam))
  end

  test "should show cam" do
    get :show, id: @cam
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cam
    assert_response :success
  end

  test "should update cam" do
    patch :update, id: @cam, cam: { alert: @cam.alert, title: @cam.title }
    assert_redirected_to cam_path(assigns(:cam))
  end

  test "should destroy cam" do
    assert_difference('Cam.count', -1) do
      delete :destroy, id: @cam
    end

    assert_redirected_to cams_path
  end
end

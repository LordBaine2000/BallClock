require 'test_helper'

class BallClockControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should call service' do
    mock_container = mock('MarbleContainer')
    mock_container.responds_like_instance_of(MarbleContainer)
    mock_container.stubs(:marbles)

    mock_service = mock('BallClockService')
    mock_service.responds_like_instance_of(BallClockService)
    mock_service.expects(:run).once
    mock_service.stubs(
      :one_minute_chute => mock_container,
      :five_minute_chute => mock_container,
      :one_hour_chute => mock_container,
      :queue => mock_container
    )

    BallClockService.expects(:new).once.returns(mock_service)

    get :index
  end
end

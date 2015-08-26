require 'test_helper'

class BallClockServiceTest < ActiveSupport::TestCase
  def setup
    @mock_queue = mock('MarbleContainer')
    @mock_queue.responds_like_instance_of(MarbleContainer)
      .expects(:capacity=).once.with(3)

    mock_marble = mock('Marble')
    mock_marble.responds_like_instance_of(Marble)
    marble_sequence = sequence('marble')
    Marble.expects(:new).once.with(1).returns(mock_marble).in_sequence(marble_sequence)
    Marble.expects(:new).once.with(2).returns(mock_marble).in_sequence(marble_sequence)
    Marble.expects(:new).once.with(3).returns(mock_marble).in_sequence(marble_sequence)

    @mock_queue.expects(:add_marble).times(3).with(mock_marble)

    @mock_one_minute_chute = mock('MarbleContainer')
    @mock_one_minute_chute.responds_like_instance_of(MarbleContainer)
      .expects(:capacity=).once.with(4)

    @mock_five_minute_chute = mock('MarbleContainer')
    @mock_five_minute_chute.responds_like_instance_of(MarbleContainer)
      .expects(:capacity=).once.with(11)

    @mock_one_hour_chute = mock('MarbleContainer')
    @mock_one_hour_chute.responds_like_instance_of(MarbleContainer)
      .expects(:capacity=).once.with(11)

    @service = BallClockService.new(
      @mock_queue,
      @mock_one_minute_chute,
      @mock_five_minute_chute,
      @mock_one_hour_chute,
      3
    )
  end

  test 'increment method' do
    @mock_queue.expects(:remove_marble).once
    @mock_one_minute_chute.expects(:add_marble).once

    @service.increment

    @mock_queue.expects(:remove_marble).once
    @mock_one_minute_chute.expects(:add_marble).once.raises(MarbleContainerException)
    @mock_one_minute_chute.expects(:dump_marbles).once
    @mock_queue.expects(:load_marbles).once
    @mock_five_minute_chute.expects(:add_marble).once

    @service.increment

    @mock_queue.expects(:remove_marble).once
    @mock_one_minute_chute.expects(:add_marble).once.raises(MarbleContainerException)
    @mock_one_minute_chute.expects(:dump_marbles).once
    @mock_queue.expects(:load_marbles).once
    @mock_five_minute_chute.expects(:add_marble).once.raises(MarbleContainerException)
    @mock_five_minute_chute.expects(:dump_marbles).once
    @mock_queue.expects(:load_marbles).once
    @mock_one_hour_chute.expects(:add_marble).once

    @service.increment

    @mock_queue.expects(:remove_marble).once
    @mock_one_minute_chute.expects(:add_marble).once.raises(MarbleContainerException)
    @mock_one_minute_chute.expects(:dump_marbles).once
    @mock_queue.expects(:load_marbles).once
    @mock_five_minute_chute.expects(:add_marble).once.raises(MarbleContainerException)
    @mock_five_minute_chute.expects(:dump_marbles).once
    @mock_queue.expects(:load_marbles).once
    @mock_one_hour_chute.expects(:add_marble).once.raises(MarbleContainerException)
    @mock_one_hour_chute.expects(:dump_marbles).once
    @mock_queue.expects(:load_marbles).once
    @mock_queue.expects(:add_marble).once

    @service.increment
  end

  test 'run method' do
    @service.expects(:increment).at_least_once

    @service.run
  end
end

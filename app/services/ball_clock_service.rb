class BallClockService
  attr_accessor :days_to_reset,     #Integer
                :queue,             #MarbleContainer
                :one_minute_chute,  #MarbleContainer
                :five_minute_chute, #MarbleContainer
                :one_hour_chute     #MarbleContainer

  def initialize(queue, one_minute_chute, five_minute_chute, one_hour_chute, capacity)
    @queue             = queue
    @one_minute_chute  = one_minute_chute
    @five_minute_chute = five_minute_chute
    @one_hour_chute    = one_hour_chute

    @queue.capacity             = capacity
    @one_minute_chute.capacity  = 4
    @five_minute_chute.capacity = 11
    @one_hour_chute.capacity    = 11

    if capacity > 127
      raise MarbleContainerException, 'Queue cannot be larger than 127'
    end

    (1..capacity).each do |i|
      @queue.add_marble(Marble.new(i))
    end
  end

  def run(minutes=0)
    if minutes > 0
      (1..minutes).each do
        increment
      end
    else
      initial_state = Array.new(@queue.marbles)
      count = 0

      until count > 0 && @queue.marbles == initial_state do
        increment
        count += 1
      end

      @days_to_reset = count/1440
    end
  end

  def increment
    marble = @queue.remove_marble

    begin
      @one_minute_chute.add_marble(marble)
    rescue MarbleContainerException
      begin
        @queue.load_marbles(@one_minute_chute.dump_marbles)
        @five_minute_chute.add_marble(marble)
      rescue MarbleContainerException
        begin
          @queue.load_marbles(@five_minute_chute.dump_marbles)
          @one_hour_chute.add_marble(marble)
        rescue MarbleContainerException
          @queue.load_marbles(@one_hour_chute.dump_marbles)
          @queue.add_marble(marble)
        end
      end
    end
  end
end
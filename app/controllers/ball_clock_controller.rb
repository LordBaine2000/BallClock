class BallClockController < ApplicationController
  def index
    service = BallClockService.new(
      MarbleContainer.new,
      MarbleContainer.new,
      MarbleContainer.new,
      MarbleContainer.new,
      30
    )

    service.run

    @days_to_reset = service.days_to_reset

    service.run(720)

    @results = {
      Min:     service.one_minute_chute.marbles,
      FiveMin: service.five_minute_chute.marbles,
      Hour:    service.one_hour_chute.marbles,
      Queue:   service.queue.marbles
    }
  end
end

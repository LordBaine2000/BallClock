class MarbleContainer
  include ActiveModel::Validations

  validates :capacity, presence: true

  attr_accessor :capacity, #integer
                :marbles   #Array<Marble>

  def initialize
    @marbles = []
  end

  def add_marble(marble)
    if !@capacity.present? || @marbles.count == @capacity
      raise MarbleContainerException, 'Could not add a marble'
    end

    @marbles.push(marble)
  end

  def remove_marble
    if @marbles.count == 0
      raise MarbleContainerException, 'Could not remove a marble'
    end

    @marbles.shift
  end

  def load_marbles(marbles)
    marbles.each do |marble|
      add_marble(marble)
    end
  end

  def dump_marbles
    marbles = []

    (1..@marbles.length).each do
      marbles.unshift(remove_marble)
    end

    marbles
  end
end
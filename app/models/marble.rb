class Marble
  include ActiveModel::Validations

  validates :number, presence: true

  attr_accessor :number #integer

  def initialize(number)
    @number = number
  end
end
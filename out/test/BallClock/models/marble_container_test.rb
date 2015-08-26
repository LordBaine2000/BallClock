require 'test_helper'

class MarbleContainerTest < ActiveModel::TestCase
  def setup
    @model = MarbleContainer.new

    @marble1 = mock('Marble')
    @marble1.responds_like_instance_of(Marble)

    @marble2 = mock('Marble')
    @marble2.responds_like_instance_of(Marble)

    @marble3 = mock('Marble')
    @marble3.responds_like_instance_of(Marble)
  end

  test 'initialize method' do
    assert_respond_to(@model.marbles, :each, 'Marbles not iterable')
  end

  test 'add_marble method' do
    assert_raises(MarbleContainerException) { @model.add_marble(@marble1) }

    @model.capacity = 2
    @model.marbles.push(@marble1)
    @model.add_marble(@marble2)

    assert_raises(MarbleContainerException) { @model.add_marble(@marble3) }
    assert_equal(@marble1, @model.marbles.shift, 'Marble not added to end of array')
  end

  test 'remove_marble method' do
    @model.marbles.push(@marble1, @marble2)
    marble = @model.remove_marble

    assert_equal(@marble1, marble, 'Incorrect marble removed from array')
    assert_not_includes(@model.marbles, @marble1, 'Marble not removed from array')

    @model.marbles.shift

    assert_raises(MarbleContainerException) { @model.remove_marble }
  end

  test 'load_marbles method' do
    @model.expects(:add_marble).times(2)

    @model.load_marbles([@marble1, @marble2])
  end

  test 'dump_marbles method' do
    @model.marbles.push(@marble1, @marble2)
    assert_equal([@marble2, @marble1], @model.dump_marbles, 'Marbles not returned in correct order')

    @model.marbles.push(@marble1, @marble2)
    @model.expects(:remove_marble).times(2)
    @model.dump_marbles
  end
end

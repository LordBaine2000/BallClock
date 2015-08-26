require 'test_helper'

class MarbleTest < ActiveModel::TestCase
  test 'initialize method' do
    assert_equal(42, Marble.new(42).number, 'Marble number incorrect')
  end
end
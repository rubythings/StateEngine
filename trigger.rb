class Trigger
  attr_accessor :element
  attr_accessor :to_state
  attr_accessor :from_state

  def initialize(element, to_state, from_state)
    @element = element
    @to_state = to_state
    @from_state = from_state
  end
end
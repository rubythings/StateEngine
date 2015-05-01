class StateChanger

  attr_accessor :element
  attr_accessor :state

  def initialize(element, state)
    @element = element
    @state = state
  end

  def change_state
    @element.state = @state
    to_guard = CascadingGuard.guard(element, state)
    if to_guard.check_children? or !to_guard.triggers.empty?
      element.children.each do |child|
        child.state = @state if element.state_flow == child.state_flow
        to_guard.triggers.each do |trigger|
          child.state = @state if trigger.element.reference == child.reference and trigger.to_state.to_s == @state.to_s
        end
      end
    end
  end
end
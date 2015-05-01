require './state_machine'
class ProjectElement
  attr_accessor :state
  attr_accessor :state_flow
  attr_accessor :children
  attr_accessor :reason
  attr_accessor :comment
  attr_accessor :errors
  attr_accessor :signed
  attr_accessor :reference


  def initialize(flow, state)
    @state = state
    @state_flow = flow
    @children = []
    @errors = {:base => []}
    @signed = false
    @reference = 'request'
  end

  def set_state(state)
    StateMachine.new.set_state(self, state)
  end

  def method_missing(m, *args, &block)

    state_change = AllowedGuard.all_state_changes.detect { |change|
      change.transition == m }
    return if state_change.nil?
    set_state(state_change.to_guard.state)
  end

end
# StateMachine is a Composite object implementing a Composite Specification Pattern(Fowler - http://martinfowler.com/apsupp/spec.pdf)
# Allows us to combine rules easily and flexibly.
# This pattern has an important advantage in that it allows rules to be added in customer plugins
# simply by adding a new class.

# When the app is loaded and this class is instantiated, all the states, stateflows and guards
# are loaded into memory from the database.  If any of these objects are changed (which rarely happens, and
# is only done when the app is being configured) then the whole state machine is reloaded.  Reload is called
# by the StateMachineObserver class which watches states, state flows and guards for changes.

require './state_flow'
require './state_changer'
require './state'
require './allowed_guard'
require './generic_state_change'
require 'ostruct'
require './cascading_guard'
require './with_reason_guard'
require './signature_on_entry_guard'
require './signature_on_exit_guard'
require './triggered_changes_guard'
require './requires_signoff_guard'
require './trigger'

class Request

end
class User

end

class StateMachine

  attr_accessor :states
  attr_accessor :state_flows
  attr_accessor :guards
  attr_accessor :state_change

  @@states = State.all
  @@state_flows = StateFlow.all
  STATE_CHANGES = AllowedGuard.all_state_changes


  def initialize
    @states = State.all
    @state_flows = StateFlow.all
    @guards = Guard.all
  end

  def set_state(element, state)
    state_changer = GenericStateChange.new
    state_changer.change_state(element, state)
  end

  def selectable_states(element)
    # do not allow state change in signoff state unless its the correct user

    return nil if state == State.find_by_name('signoff') and  !Request.to_be_signed_off_by_user(User.current).include?(element.reference)
    State.find(element.state_flow.state_changes.where(:old_state_id => state).map { |sc| sc.new_state_id }).sort { |x, y| x.name <=> y.name }
  end

  def next_states(element)
   flow =  StateFlow.new(element.state_flow)
    flow.next_states(element)
  end

end
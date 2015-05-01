

class TriggeredChangesGuard < GenericStateChange

  def self.is_satisfied_by?(subject, to)
    state_flow = subject.state_flow
    to_guard = Guard.find(state_flow, to)
    return true unless to_guard.check_children?

    subject.children.each do |child|
      #we already checked cascading within stateflows with the cascading guard - just say yes
      return true if child.state_flow == subject.state_flow
      # now cascade across state flows if change is triggered on child
      to_guard.triggers.each do |trigger|
      return false unless  trigger.element.reference == child.reference and trigger.to_state.to_s == to.to_s and (trigger.from_state.to_s == child.state.to_s or trigger.from_state == :any)
      end
    end
    return true
  end

end
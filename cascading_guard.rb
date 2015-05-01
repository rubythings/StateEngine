
class CascadingGuard

  def self.guard(subject, to)
    Guard.find(subject.state_flow, to)
  end

  def self.is_satisfied_by?(subject, to)
    to_guard = guard(subject, to)
    return true unless to_guard.check_children?
    subject.children.each do |child|
      # do not cascade across state flows by default - just ignore them
      return true if subject.state_flow != child.state_flow
      return false unless GenericStateChange.new.is_satisfied_by?(child, to)
    end
    return true
  end
end
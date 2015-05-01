
class GenericStateChange < Guard
  def initialize
    @specifications = [AllowedGuard, RequiresSignoffGuard, CascadingGuard, WithReasonGuard, SignatureOnEntryGuard, SignatureOnExitGuard, TriggeredChangesGuard]
  end

  # changes the state of the project element if all the guards are satisfied
  def change_state(subject, to)
    if self.is_satisfied_by?(subject, to)
      StateChanger.new(subject, to).change_state
    end
  end


  # checks whether the guards are satisifed
  def is_satisfied_by?(subject, to)
    @specifications.all? do |spec|
      spec.is_satisfied_by?(subject, to)
    end

  end
end
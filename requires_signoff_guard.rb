class RequiresSignoffGuard

  def self.is_satisfied_by?(subject, to)
    state_flow = subject.state_flow
    from_guard = Guard.find(state_flow, subject.state)
    subject.errors[:base] << 'requires signoff' and return false if from_guard.requires_signoff? && !Request.to_be_signed_off_by_user(User.current).include?(subject.reference)
    return true
  end



end
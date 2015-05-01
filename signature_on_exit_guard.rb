

class SignatureOnExitGuard < GenericStateChange

  def self.is_satisfied_by?(subject, to)
    state_flow = subject.state_flow
    from_guard = Guard.find(state_flow, subject.state)
    subject.errors[:base] << 'no signature on exit' and return false if from_guard.requires_signature_on_exit? && !subject.signed
    return true
  end

end
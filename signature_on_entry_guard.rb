

class SignatureOnEntryGuard < GenericStateChange

  def self.is_satisfied_by?(subject, to)
    state_flow = subject.state_flow
    to_guard = Guard.find(state_flow, to)
    subject.errors[:base] << 'no signature on entry' and return false if to_guard.requires_signature_on_entry? && !subject.signed
    return true
  end

end
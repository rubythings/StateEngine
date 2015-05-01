
class WithReasonGuard
  def self.is_satisfied_by?(subject, to)
    state_flow = subject.state_flow
    to_guard = Guard.find(state_flow, to)
    if to_guard.requires_reason?
      subject.errors[:base] << 'no reason given' and return false if subject.reason.nil?
      subject.errors[:base] << 'no comment given' and return false if subject.reason == 'other' and subject.comment.empty?
    end
    return true
  end
end
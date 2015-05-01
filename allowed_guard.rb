require './generic_state_change'
require 'ostruct'

class AllowedGuard < GenericStateChange

  def self.all_state_changes
    [OpenStruct.new(:state_flow => :all, :transition => :accept, :from_guard => Guard.find(:all, :draft), :to_guard => Guard.find(:all, :pending)),
     OpenStruct.new(:state_flow => :all, :transition => :activate, :from_guard => Guard.find(:all, :signoff), :to_guard => Guard.find(:all, :active)),
     OpenStruct.new(:state_flow => :all, :transition => :activate, :from_guard => Guard.find(:all, :pending), :to_guard => Guard.find(:all, :active)),
     OpenStruct.new(:state_flow => :all, :transition => :activate, :from_guard => Guard.find(:all, :draft), :to_guard => Guard.find(:all, :active)),
     OpenStruct.new(:state_flow => :all, :transition => :redraft, :from_guard => Guard.find(:all, :pending), :to_guard => Guard.find(:all, :draft)),
     OpenStruct.new(:state_flow => :all, :transition => :redraft, :from_guard => Guard.find(:all, :active), :to_guard => Guard.find(:all, :draft)),
     OpenStruct.new(:state_flow => :all, :transition => :deactivate, :from_guard => Guard.find(:all, :active), :to_guard => Guard.find(:all, :pending))]
  end

  def self.is_satisfied_by?(subject, to)
    state_flow = subject.state_flow
    from_guard = Guard.find(state_flow, subject.state)
    to_guard = Guard.find(state_flow, to)


    ok = AllowedGuard.all_state_changes.select { |change|
 change.state_flow == state_flow && change.from_guard == from_guard && change.to_guard == to_guard }.any?
    subject.errors[:base] << 'change not allowed' unless ok
    ok
  end

end
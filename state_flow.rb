require 'ostruct'
require './state'
require './guard'

class StateFlow
  attr_accessor :name, :guards, :default, :states
  attr_accessor :guards

def initialize(name)
  sf = StateFlow.find_by_name(name)
  @name = sf.name
  @default = sf.default
  @states = sf.states
  @guards = sf.guards
end

  def self.all
    [OpenStruct.new(:name => 'all', :id => 1, :default => false, :states => State.all, :guards => Guard.all_for_state_flow(:all)),
     OpenStruct.new(:name => 'none', :id => 2, :default => false)]
  end

  def self.find_by_name(name)
    self.all.detect{|flow| flow.name.to_s == name.to_s}
  end

  def next_states(element)
  changes =  StateMachine::STATE_CHANGES.select{|sc| sc.state_flow == element.state_flow}
  changes.map{|state_change|
     state_change.to_guard.state if  state_change.from_guard.state == element.state}.compact
  end

end
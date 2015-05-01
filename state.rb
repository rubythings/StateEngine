require 'ostruct'
class State
  # state should maybe have a default transition - for cancelled it would be cancel for example
  # state change would then delegate to this if it didn't have its own transition defined
  @@draft = OpenStruct.new(:name => 'draft', :default => false)
  @@pending = OpenStruct.new(:name => 'pending', :default => false)
  @@active = OpenStruct.new(:name => 'active', :default => true)
  @@signoff = OpenStruct.new(:name => 'signoff', :default => true)


  def self.all
    [@@draft, @@pending, @@active, @@signoff]
  end

  def self.find_by_name(name)
    self.all.detect{|state| state.name == name}
  end

  def self.initial_state
    @@draft
  end

end
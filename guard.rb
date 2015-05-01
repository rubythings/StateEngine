class Guard
  attr_accessor :state_flow
  attr_accessor :state
  attr_accessor :triggers


  def self.all
    [OpenStruct.new(:state_flow => :all, :state => :draft, :requires_reason? => false, :comment => '', :check_children? => false, :triggers => []),
     OpenStruct.new(:state_flow => :all, :state => :pending, :requires_reason? => false,  :comment => '', :check_children? => false, :triggers => []),
         OpenStruct.new(:state_flow => :all, :state => :active, :requires_reason? => false, :comment => '', :check_children? => false, :triggers => []),
    OpenStruct.new(:state_flow => :all, :state => :signoff, :requires_reason? => false, :comment => '', :check_children? => false, :triggers => [])]

  end


  def self.find(flow, state)
    all.detect { |guard| guard.state_flow == flow && guard.state == state }
  end

  def self.all_for_state_flow(flow)
    all.map { |guard|
      guard if guard.state_flow == flow }
  end


end
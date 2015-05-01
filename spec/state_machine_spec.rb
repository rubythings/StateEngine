require './state_machine'
require './state_flow'
require './guard'
require './project_element'

describe 'StateMachine' do

  it 'should initialize the machine' do
    StateMachine.new.should_not be_nil
  end

  it 'should list the possible states' do
    StateMachine.new.states.map(&:name).should eq %w{draft pending active signoff}
  end

  it 'each state in the all state flow should have a guard' do
    Guard.all_for_state_flow(:all).size.should == 4
  end

  it 'should list the states a project element can change to' do
    states = StateMachine.new.next_states(ProjectElement.new(:all, :draft))
    states.should eq [:pending, :active]
  end

  it 'should list all the guards for a state flow' do
    StateMachine.new.guards.size.should eq 4
  end


end

# require 'spec_helper'
#
# describe State do
#   it { should belong_to(:updated_by_user) }
#   it { should belong_to(:created_by_user) }
#   it { should have_many(:state_usages).dependent(:destroy) }
#   it { should have_many(:state_flows).through(:state_usages) }
#   it { should validate_presence_of(:name) }
#   it { should validate_presence_of(:description) }
#   it { should validate_presence_of(:position) }
#   it { should validate_uniqueness_of(:name) }
#   it 'should reload the state machine after changing a state'
# end
#
# describe StatesController do
#   context 'an administrator' do
#     it "should see the index page"
#     it "should be able to edit a state to change its name and translations"
#     it 'should allow users to add translations for state names in all existing locales'
#     it 'should allow users to provide a default name for the operation to move to this state' do
#       #   if the state is called ordered, the default transition name could be 'order'
#     end
#     it 'should be able to destroy an unused state'
#     it 'should not be able to destroy a used state'
#     it "should create a valid state"
#     it "should not create an invalid state"
#     it "should update a valid state"
#     it "should not update an invalid state"
#   end
# end
#
# describe StateFlow do
#   it {should have_many(:state_changes).dependent(:delete_all)}
#   it {should have_many(:states).through(:state_usages)}
#   it {should have_many(:state_usages).dependent(:destroy)}
#   it {should have_many :element_types}
#   it {should validate_presence_of :name}
#   it {should validate_uniqueness_of :name}
#   it {should validate_presence_of :description}
#   it {should validate_presence_of(:state_usages).on(:update)}
#   it {should accept_nested_attributes_for :state_usages}
#   it 'should remove all transitions'
#   it 'should enable all transitions'
#   it 'should remove a single transition'
#   it 'should enable a single transition'
#   it 'should allow changes between states when there is a transition'
#   it 'should not allow changes between states when there is no transition'
#   it 'should reload the state machine after changing a stateflow'
# end
# describe StateFlowsController do
#   context 'as administrator'
#   it "should return error message and home page if trying to edit, update or destroy a state flow that does not exist"
#   it "should show the index page"
#   it "should show a state flow"
#   it "should show a new form"
#   it "should create a new state flow with just one state"
#   it "should not create a new state flow when there is no state id"
#   it "should show a form to edit a state flow"
#   it "should fail to update an invalid state flow, and return to edit with warning "
#   it "should destroy state flow that is not in use"
#   it "should not destroy a state flow that is in use"
#   it "should show state usages for this state flow"
#   it "should not allow user to try and add a state when all states have usages"
# end
# # state usage is a poor name - the class describes a set of guard conditions
# describe Guard do
#   it {should belong_to :state}
#   it {should belong_to :state_flow}
#   it {should have_many(:to_links).dependent(:destroy)}
#   it {should have_many(:from_links).dependent(:destroy)}
#   # to and from usages are only used to check sign_on_entry and sign_on_exit
#   # probably just do the query instead
#   it {should have_many(:to_usages).through(:to_links)}
#   it {should have_many(:from_usages).through(:from_links)}
#   it {should validate_uniqueness_of(:state_id).scoped_to(:state_flow_id)}
#   it {should validate_presence_of(:state_flow_id).on(:update)}
#   it {should validate_presence_of :state_id}
#   it {should delegate_method(:state_name).to(:state).as(:name)}
#   it {should delegate_method(:state_flow_name).to(:state_flow).as(:name)}
#   it 'should be signable if guard allows signature'
#   it 'should be signable if guard requires signature on entry'
#   it 'should be signable if guard requires signature on exit'
#   it 'should not be signable otherwise'
#   it 'should cascade state changes to children'
#   it 'should show state is in use '
#   it 'test_signed_change_to_state?'
#   it 'test_signed_change_to_state_on_exit'
#   it 'test_signed_change_to_state_on_entry'
#   it 'should reload the state machine after changing a guard'
# end
# describe AllowedStateChange do
#   it { should belong_to :updated_by_user }
#   it { should belong_to :created_by_user }
#   it { should belong_to :state_flow }
#   it { should belong_to :from_state } #through guard
#   it { should belong_to :to_state } #through guard
#   it { should validate_presence_of :from_guard_id }
#   it { should validate_presence_of :to_guard_id }
#   it {should delegate_method(:to_state_name).to(:to_).as(:state_name)}
#   it {should delegate_method(:from_state_name).to(:from_usage).as(:state_name)}
#   it {should delegate_method(:state_flow_name).to(:state_flow).as(:name)}
#   it 'should have a readable description'
#   it 'should have a name that describes the change' do
#     #   In a requesting state flow, the act of ordering the items (pending -> ordered) might be 'order items'
#     #   In a queue item state flow it would be 'order'
#     it 'should allow users to add translations for state transitions in all existing locales'
#     it 'should reload the state machine after changing a statechange'
#   end
# end
# describe StateMachine do
#   it 'should store all available state names as an array of class variables' do
#     #   the components of the state machine will hardly ever change once the system is set up
#     #   so we could store them as constants and reset when they are reloaded - but maybe
#     #   class variables provide a purer solution?
#   end
#   it 'should store all the information about a state in an openstruct'
#   it 'should instantiate the states when initialized'
#   it 'should store all the information about a state change in an openstruct'
#   it 'should instantiate the state changes when initialized'
#   it 'should store all the information about a state  flow in an openstruct'
#   it 'should instantiate the stateflows when initialized'
#   it 'should store all the information about a state usage in an openstruct'
#   it 'should instantiate the state usages when initialized'
#   it 'should use class variables to reference the other components'
#
#   context 'when reporting on state changes' do
#     it 'returns the transitions available for a given object'
#     it 'say if an object can be signed'
#     it 'say if signature requires a witness'
#     it 'say if an object requires a signature when it changes from a state'
#     it 'say if an object requires a signature when it changes to a state'
#     it 'say if a state change requires a reason'
#     it 'say if a state change requires a reason and a comment'
#   end
#
#   context 'enacting state changes' do
#     context 'when transition is allowed' do
#       it 'confirm state was successfully changed when a transition is allowed' do
#         #   pass in a project element with request to change its state - if allowed
#         #   updates the state_id of the object and returns true. The state change will have
#         #   fk links in the db, so referential integrity is maintained.  We only update state_id, not
#         #   the state object - this link is now removed to decouple the state machine.
#         #   If we want to know the state_name of an object, we delegate to the state machine with the state_id
#       end
#       it 'should update a history object'
#       context 'when a signature is required' do
#         it 'confirm a state was successfully changed when a signature is present'
#         it 'confirm a state was not changed unless a signature is present'
#       end
#
#       context 'when a witness is required' do
#         it 'confirm a state was successfully changed when a signature and a witness are present'
#         it 'confirm a state was not changed unless a signature and a witness are present'
#       end
#       context 'when a reason is required' do
#         it 'confirm a state was successfully changed when a reason is given'
#         it 'confirm a state was not changed unless a reason is given'
#       end
#       context 'when cascading changes to children' do
#         it 'should change the state of child elements in the same state flow'
#         it 'should not change the state of child elements in other state flows'
#         it 'should issue a warning for suspicious transitions' #warn if we do not cascade from request to queue items for example - key value pair
#       end
#       context 'when an object has additional rules'
#       it 'should call the rule engine'
#     end
#   end
#
#   context 'when transition is not allowed' do
#     it 'confirm state was not changed unless transition allowed'
#   end
#
#
# end
#
# #Maybe use composite specification pattern:
#
# #Application setup determines which subclass gets called
# class Specification
#   def change_states
#     #we already checked this was legal - so implement the changes
#   end
# end
#
# class LeafSpecification < Specification
#
# end
#
# class AllowedStateChange < LeafSpecification
#
#
#   def is_satisfied_by?( subject, to)
#     subject.state_flow.allow?(subject.state, to) #plus quite a few other checks
#   end
# end
#
# class AllowedChildrenStateChange < LeafSpecification
#
#   def is_satisfied_by?(from, to, subject)
#     subject.children.each{|child| child.state_flow.allow?(from, to) } #plus quite a few other checks
#   end
# end
#
# # we can then combine these leaves
# class GenericAndSpecification < LeafSpecification
#   def initialize(specs)
#     @specifications = specs
#   end
#
#   def is_satisfied_by?(subject)
#     @specifications.all? do |spec|
#       spec.is_satisfied_by?(subject)
#     end
#   end
# end
#
# class CascadingStateChange < LeafSpecification
#   def initialize(from, to, subject)
#     specs = [AllowedStateChange(from, to, subject), AllowedChildrenStateChange(from, to, subject)]
#     @and_spec = GenericAndSpecification.new(specs)
#   end
#
#   def is_satisfied_by?(subject)
#     @and_spec.is_satisfied_by?(subject)
#   end
# end
#
# class ChangeParentToMatchChildren < LeafSpecification
#   def initialize(from, to, subject)
#     specs = [AllowedStateChange(from, to, subject.parent), AllowedChildrenStateChange(from, to, subject.parent)]
#     @and_spec = GenericAndSpecification.new(specs)
#   end
#
#   def is_satisfied_by?(subject)
#     @and_spec.is_satisfied_by?(subject)
#   end
# end
#
#

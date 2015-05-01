require 'mocha/setup'
require './project_element'
require './state_changer'
require './guard'
require './state_machine'


describe 'ProjectElement' do

  it 'should change the state if allowed' do
    element = ProjectElement.new(:all, :draft)
    element.set_state(:active)
    element.state.should eq :active
  end

  it 'should not change the state if not allowed' do
    AllowedGuard.stubs(:all_state_changes).returns([])
    element = ProjectElement.new(:all, :draft)
    element.set_state(:active)
    element.errors[:base].should_not be_empty
    element.state.should eq :draft
    AllowedGuard.unstub(:all_state_changes)
  end

  it 'should not change the state if reason required and none given' do
    OpenStruct.any_instance.stubs(:requires_reason?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.set_state(:active)
    element.errors[:base].should_not be_empty
    element.state.should eq :draft
    OpenStruct.any_instance.unstub(:requires_reason?)
  end

  it 'should not change the state if reason required and reason is :other and no comment' do
    OpenStruct.any_instance.stubs(:requires_reason?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.reason = 'other'
    element.comment = ''
    element.set_state(:active)
    element.errors.should_not be_empty
    element.state.should eq :draft
    OpenStruct.any_instance.unstub(:requires_reason?)
  end

  it 'should change the state if reason required and a reason is given' do
    OpenStruct.any_instance.stubs(:requires_reason?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.reason = 'reason'
    element.set_state(:active)
    element.state.should eq :active
    OpenStruct.any_instance.unstub(:requires_reason?)
  end

  it 'should not change the state of the project element children unless set to cascade' do
    element = ProjectElement.new(:all, :draft)
    element.children =  [ ProjectElement.new(:all, :draft), ProjectElement.new(:all, :draft)]
    element.set_state(:active)
    element.state.should eq :active
    element.children.first.state.should eq :draft
  end

  it 'should change the state of the project element children if set to cascade' do
    OpenStruct.any_instance.stubs(:check_children?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.children =  [ ProjectElement.new(:all, :draft), ProjectElement.new(:all, :draft)]
    element.set_state(:active)
    element.state.should eq :active
    element.children.first.state.should eq :active
    OpenStruct.any_instance.unstub(:check_children?)
  end

  it 'should not change the state of the project element children if have different state flows' do
    OpenStruct.any_instance.stubs(:check_children?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.children =  [ ProjectElement.new(:none, :draft), ProjectElement.new(:none, :draft)]
    element.set_state(:active)
    element.state.should eq :active
    element.children.first.state.should eq :draft
    OpenStruct.any_instance.unstub(:check_children?)
  end

  it 'should change state using transition as method' do
    element = ProjectElement.new(:all, :draft)
    element.activate
    element.state.should eq :active
  end
  it 'should raise error if element requires a signature on entry and is not signed' do
    OpenStruct.any_instance.stubs(:requires_signature_on_entry?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.activate
    element.errors[:base].should_not be_empty
    element.state.should eq :draft
    OpenStruct.any_instance.unstub(:requires_signature_on_entry?)
  end

  it 'should not raise error if element requires a signature on entry and is signed' do
    OpenStruct.any_instance.stubs(:requires_signature_on_entry?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.signed = true
    element.activate
    element.errors[:base].should be_empty
    element.state.should eq :active
    OpenStruct.any_instance.unstub(:requires_signature_on_entry?)
  end

  it 'should raise error if element requires a signature on exit and is not signed' do
    OpenStruct.any_instance.stubs(:requires_signature_on_exit?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.activate
    element.errors[:base].should_not be_empty
    element.state.should eq :draft
    OpenStruct.any_instance.unstub(:requires_signature_on_exit?)
  end

  it 'should not raise error if element requires a signature on exit and is signed' do
    OpenStruct.any_instance.stubs(:requires_signature_on_exit?).returns(true)
    element = ProjectElement.new(:all, :draft)
    element.signed = true
    element.activate
    element.errors[:base].should be_empty
    element.state.should eq :active
    OpenStruct.any_instance.unstub(:requires_signature_on_exit?)
  end

  it 'should change the state of associated objects if state change is triggered' do
    element = ProjectElement.new(:all, :draft)
    other_element = ProjectElement.new(:none, :draft)
    element.reference = 'request'
    other_element.reference = 'queue_item'
    element.children << other_element
    OpenStruct.any_instance.stubs(:triggers => [Trigger.new(other_element, :active, :draft)], :check_children? => true)
    element.activate
    element.state.should eq :active
    element.children.first.state.should eq :active
    OpenStruct.any_instance.unstub(:triggers)
  end

  it 'should not change states if state change is triggered but an associated object is not in the correct state' do
    element = ProjectElement.new(:all, :draft)
    other_element = ProjectElement.new(:none, :pending)
    element.reference = 'request'
    other_element.reference = 'queue_item'
    element.children << other_element
    OpenStruct.any_instance.stubs(:triggers => [Trigger.new(other_element, :active, :draft)], :check_children? => true)
    element.activate
    element.state.should eq :draft
    element.children.first.state.should eq :pending
    OpenStruct.any_instance.unstub(:triggers)
  end


  it 'should not allow an unpriveleged user to change the state of a request that needs signoff' do
    Request.stubs(:to_be_signed_off_by_user).returns([])
    User.stubs(:current).returns(true)
    OpenStruct.any_instance.stubs(:requires_signoff?).returns(true)
    element = ProjectElement.new(:all, :signoff)
    element.reference = 'request'
    element.activate
    element.errors.should_not be_empty
    element.state.should eq :signoff
  end

  it 'should allow a riveleged user to change the state of a request that needs signoff' do
    Request.stubs(:to_be_signed_off_by_user).returns(['request'])
    User.stubs(:current).returns(true)
    OpenStruct.any_instance.stubs(:requires_signoff?).returns(true)
    element = ProjectElement.new(:all, :signoff)
    element.reference = 'request'
    element.activate
    element.errors.should_not be_empty
    element.state.should eq :active
  end
end
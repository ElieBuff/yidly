require 'spec_helper'

describe Record do

  before (:each) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user: @user)
    @stage = FactoryGirl.create(:stage, project: @project)
    @record = FactoryGirl.create(:record, stage: @stage)
  end

  describe :wait_for_sec do
    delay = 55
    before :each do
      @delay = delay
      @record.wait_for_sec @delay
    end
    it "should set status to 'waiting'" do
      @record.status.should == 'waiting'
    end
    it "should postpone :actionable_at by #{delay} sec " do
      @record.actionable_at.should be_within(1).of(Time.at(Time.now.utc + @delay))
    end
    it "should increment :trial_count" do
      @record.trial_count.should == 1
    end
    it "should not increment :reschedule_count" do
      @record.reschedule_count.should == 0
    end
  end

  describe :reschedule_in_sec do
    before :each do
      @delay = 1000
      @record.reschedule_in_sec @delay
    end
    it "should set status to 'rescheduled'" do
      @record.status.should == 'rescheduled'
    end
    it "should postpone :actionable_at by #{@delay} sec " do
      @record.actionable_at.should be_within(1).of(Time.at(Time.now.utc + @delay))
    end
    it "should increment :reschedule_count" do
      @record.reschedule_count.should == 1
    end
  end

  describe :move_to_next_stage do
    before :each do
        @record.stub(:update_stage_id) {}
    end
    describe "when in last stage" do
      it "should not call update_stage_id" do
        @record.should_not_receive(:update_stage_id)
        @record.move_to_next_stage
      end
    end
    describe "when not in last stage" do
      before :each do
        @stage_2 = FactoryGirl.create(:stage, project: @record.project)
      end
      it "should call update_stage_id with next stage id" do
        @record.should_receive(:update_stage_id).with(@stage_2.id)
        @record.move_to_next_stage
      end
    end

  end
  describe :update_stage_id do
    before :each do
      @record.actionable_at = Time.now - 1000
      @old_attributes = @record.attributes
    end
    describe "when stage is the same as current stage" do
      before :each do
        @record.update_stage_id(@stage.id)
      end
      it "should not modify the record" do
        @record.attributes.should == @old_attributes 
      end
    end

    describe "when stage is different than current stage" do
      before :each do
        @stage_2 = FactoryGirl.create(:stage, project: @record.project)
        @record.update_stage_id(@stage_2.id)
      end
      it "should modify the record" do
        @record.attributes.should_not == @old_attributes 
      end
      it "should update the stage" do
        @record.stage.should == @stage_2
      end

      it "should modify actionable_at" do
        @record.actionable_at.should_not be(@old_actionable_at)
      end

      it "should be actionable now" do
        @record.actionable_at.should be_within(1).of(Time.now)
      end
    end
  end
end

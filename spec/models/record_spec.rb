require 'spec_helper'

describe Record do

  before (:each) do
    @record = FactoryGirl.create(:record)
  end

  describe :wait_for_sec do
    before :each do
      @delay = 55
      @record.wait_for_sec @delay
    end
    it "should set status to 'waiting'" do
      @record.status.should == 'waiting'
    end
    it "should postpone :actionable_at by #{@delay} sec " do
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

  describe :update_stage_id do
    before :each do
      @stage_1 = @record.stage_id
      @stage_2 = FactoryGirl.create(:stage)
      p @stage_1
      p @stage_2
      @record = @record.update_stage_id(@stage_2.id)
    end
    xit "should update stage id" do
      @record.stage_id.should == @stage_2.id
    end
    
  end
end

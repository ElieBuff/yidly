require 'spec_helper'

describe Project do

  before (:each) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user: @user)
    @stage = FactoryGirl.create(:stage, project: @project)
  end

  describe :first_stage do
    describe "when only one stage" do
      it "should return the first stage" do
        @project.first_stage.should == @stage
      end
    end
    describe "when two stages" do
      before :each do
        FactoryGirl.create(:stage, project: @project)
      end
      it "should return the first stage" do
        @project.first_stage.should == @stage
      end
    end
  end
end

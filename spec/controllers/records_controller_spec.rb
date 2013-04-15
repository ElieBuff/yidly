require 'spec_helper'

describe RecordsController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, user: @user)
    @stage = FactoryGirl.create(:stage, project: @project)
    @record = FactoryGirl.create(:record, stage: @stage)
    sign_in @record.user
  end

  describe "GET 'show'" do
    before :each do
      get :show, :id => @record.id, :format => :json
    end
    it "should be successful" do
      response.should be_success
    end

    it "should find the right record" do
      assigns(:record).should == @record
    end
  end

  describe "GET 'reschedule_in_sec'" do
    before :each do
      get :reschedule_in_sec, :id => @record.id, :delay => "1000", :format => :json
      @response_json = JSON.parse(response.body)
    end
    it "should postpone the actionable_at attribute" do
      Time.parse(@response_json['actionable_at']).should be_within(5).of(Time.at(Time.now.utc + 1000))
    end
    it "should postpone the actionable_at attribute" do
      Time.parse(@response_json['actionable_at']).should be_within(5).of(Time.at(Time.now.utc + 1000))
    end
  end
end

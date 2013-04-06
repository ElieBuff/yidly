require 'spec_helper'

describe RecordsController do

  before (:each) do
    @record = FactoryGirl.create(:record)
    sign_in @record.user
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @record.id, :format => :json
      response.should be_success
    end
    
    it "should find the right record" do
      get :show, :id => @record.id, :format => :json
      assigns(:record).should == @record
    end
    
  end

end

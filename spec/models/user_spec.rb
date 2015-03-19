require 'rails_helper'
require 'spec_helper'
RSpec.describe User, type: :model do
  describe "models" do
    before(:each) do
      @n = FactoryGirl.create(:user, name: "Nick")
      @s = FactoryGirl.create(:user, name: "Steve")
      @r = FactoryGirl.create(:user, name: "Richard")
    end
    
    context "Nick sends a request to Steve" do   
      it "returns friends requested for Nick" do
        f = FactoryGirl.create(:friendship, user_id: @n.id, friend_id: @s.id, status: true)
        expect(@n.friends).to be_empty
      end
      it "nick sends request to steve" do
        @n.request(@s)
        expect(@s.request_received?(@n)).to be_truthy
      end
      it "steves accets request from nick" do
      end
    end
  end
end

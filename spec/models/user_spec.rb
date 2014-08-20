require 'rails_helper'

describe User do
  before :each do
    @valid_attributes = {
      id:1,
      name: "Bob"
    }
    @valid_attributes_2 = {
      id:2,
      name: "Jeff"
    }
  end
  context 'when all attributes are valid' do
    before :each do
      @user = User.new(@valid_attributes)
    end
    it 'the record is valid' do
        expect(@user).to be_valid
    end
    it 'stores the correct information in redis_key' do
        expect(@user.redis_key('')).to eq("user:1:")
    end
  end
  context 'when attributes are invalid' do
    context 'name is missing' do
      it 'the record is not valid' do
        expect(User.new(name:'')).to be_invalid
      end
    end
  end
  context 'when user 1 follows user 2' do
    before :each do
      @user_1 = User.create!(@valid_attributes)
      @user_2 = User.create!(@valid_attributes_2)
      @user_1.follow!(@user_2)
    end
    it "should add 2nd user to list of users 1st user is following" do
      expect(@user_1.following).to include(@user_2)
    end
    it "should add 1st user to list of 2nd user's followers" do
      expect(@user_2.followed).to include(@user_1)
    end
  end
end

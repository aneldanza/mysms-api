require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(username: "testuser", email: "test@example.com", password: "password")
      expect(user).to be_valid
    end

    it "is invalid without a username" do
      user = User.new(email: "test@example.com", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it "is invalid without an email" do
      user = User.new(username: "testuser", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate username" do
      User.create!(username: "testuser", email: "test1@example.com", password: "password")
      user = User.new(username: "testuser", email: "test2@example.com", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("is already taken")
    end

    it "is invalid with a duplicate email" do
      User.create!(username: "testuser1", email: "test@example.com", password: "password")
      user = User.new(username: "testuser2", email: "test@example.com", password: "password")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is already taken")
    end
  end

  describe "associations" do
    it "has many messages" do
      association = User.relations["messages"]
      expect(association.relation).to eq(Mongoid::Association::Referenced::HasMany::Proxy)
    end
  end

  describe "custom methods" do
    describe ".generate_jti" do
      it "generates a unique JTI" do
        jti = User.generate_jti
        expect(jti).to be_a(String)
        expect(jti.length).to be > 0
      end
    end

    describe ".revoke_jwt" do
      it "updates the user's JTI" do
        user = User.create!(username: "testuser", email: "test@example.com", password: "password")
        old_jti = user.jti
        User.revoke_jwt({}, user)
        expect(user.jti).not_to eq(old_jti)
      end
    end
  end
end
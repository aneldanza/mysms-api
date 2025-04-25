require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      message = Message.new(to: "+1234567890", body: "Hello, world!", user: user)
      expect(message).to be_valid
    end

    it "is invalid without a 'to' field" do
      message = Message.new(body: "Hello, world!", user: user)
      expect(message).not_to be_valid
      expect(message.errors[:to]).to include("can't be blank")
    end

    it "is invalid without a 'body' field" do
      message = Message.new(to: "+1234567890", user: user)
      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("can't be blank")
    end

    it "is invalid with an improperly formatted 'to' field" do
      message = Message.new(to: "12345", body: "Hello, world!", user: user)
      expect(message).not_to be_valid
      expect(message.errors[:to]).to include("must be a valid phone number")
    end

    it "is invalid if the 'body' exceeds 250 characters" do
      long_body = "a" * 251
      message = Message.new(to: "+1234567890", body: long_body, user: user)
      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("must be less than 250 characters")
    end
  end

  describe "associations" do
    it "belongs to a user" do
      association = Message.relations["user"]
      expect(association.relation).to eq(Mongoid::Association::Referenced::BelongsTo::Proxy)
    end
  end
end
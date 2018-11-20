require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation test' do
    it 'it ensures name is present' do
      user = User.new(email: 'rishabh@technogise.com', phone: '9039552737', counter: '0', password: '12345678').save
      expect(user).to eq(false)
    end
    it 'it ensures email is present' do
      user = User.new(name: 'rishabh agarwal', phone: '9039552737', counter: '0', password: '12345678').save
      expect(user).to eq(false)
    end
    it 'should not save as email is not in valid format' do
      user = User.new(name: 'rishabh agarwal', email: 'rishabhtechnogise.com', phone: '9039552737', counter: '0', password: '12345678').save
      expect(user).to eq(false)
    end
    it 'should not save as counter is negative' do
      user = User.new(name: 'rishabh agarwal', email: 'rishabh@technogise.com', phone: '9039552737', counter: -1, password: '12345678').save
      expect(user).to eq(false)
    end
    it 'should save successfully' do
      user = User.new(name: 'rishabh agarwal', email: 'rishabh@technogise.com', phone: '9039552737', counter: '0', password: '12345678').save
      should validate_uniqueness_of(:email)
      expect(user).to eq(true)
    end
    it {should validate_uniqueness_of(:email)}
  end
end




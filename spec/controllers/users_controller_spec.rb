require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:firstUser) {create :user, email: 'rishabh@technogise.com'}
  let!(:secondUser) {create :user, email: 'vineet@technogise.com'}

  context 'get#index' do
    it 'should give a response code ' do
      get :index, format: :json
      expect(response).to have_http_status(200)
      expect(resp['body'].length).to eq(User.count)
    end
  end
  context 'post#create' do
    it 'should create a user successfully' do
      params = {
          :email => 'someone@gmail.com',
          :name => 'rishabh agarwal',
          :password => '12345678',
          :phone => '9039552737',
          :counter => '0'
      }
      expect {post(:create, format: :json, params: {user: params})}.to change(User, :count).by(1)
    end
    it 'should not create user as do not satisfy required params' do
      params = {
          :email => 'someone@gmail.com',
          :name => 'rishabh agarwal',
          :password => '12345678',
          :phone => '9039552737'
      }
      expect {post(:create, :format => :json, params: {user: params})}.to change(User, :count).by(0)
    end
  end
  context 'put#update' do
    it 'should update user successfully' do
      params = {
          :name => 'agarwal rishabh'
      }
      put :update, format: :json, params: {:id => firstUser.id, user: params}
      firstUser.reload
      expect(firstUser.attributes['name']).to eq ('agarwal rishabh')
      expect(response).to be_success
    end

    it 'should not update email if email already exist' do
      params = {
          :email => 'rishabh@technogise.com'
      }
      put :update, format: :json, params: {:id => secondUser.id, user: params}
      secondUser.reload
      expect(resp['error']).to eq ('email already exist')
      expect(response).to be_success
    end
  end


  context 'post#update_counter' do
    it 'should  update the value of counter' do
      post(:update_counter, :format => :json, params: {:id => firstUser.id, counter: 5})
      expect(resp['body']['counter']).to eq(5)
    end
    it 'should not update the value of counter when passed negative' do
      post(:update_counter, :format => :json, params: {:id => firstUser.id, counter: -2})
      expect(resp['error']).to eq('You cannot update with negative value')

    end

  end

  context 'delete#destroy' do
    it 'should delete the user if user exist' do
      expect {delete :destroy, format: :json, params: {:id => firstUser.id}}.to change(User, :count).by(-1)
    end
  end
  context 'get#redeem' do
    it 'should not redeem the account for points lesser than 5' do
      get :redeem, format: :json, params: {:id => firstUser.id}
      expect(resp['message']).to eq('You cannot redeem your points')
    end
    it 'should redeem the account if points are greater than or equal to 5' do
      firstUser.counter = 5
      firstUser.save
      get :redeem, format: :json, params: {:id => firstUser.id}
      expect(resp['remainingCount']).to eq(0)
    end
  end

  context 'get#show' do

    it 'should display the user details for the id passed' do
      get :show, format: :json,params:{:id=>firstUser.id}
      expect(resp['body']['id']).to eq(firstUser.id)

    end
    it 'should display not display user when id does not exist ' do

      get :show, format: :json,params:{:id=>222}
      expect(resp['error']).to eq("Couldn't find User with 'id'=222")

    end

  end

  context 'check the validity of active record ' do

    it 'should fail when a user with id 555 passed' do
      User.exists?(:id => 555).should be_falsey

    end
  end

  def resp
    @json ||= JSON.parse(response.body)
  end

end



















Rails.application.routes.draw do
  get 'hello_world', to: 'hello_world#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users do
    member do
      post 'update_counter' =>'users#update_counter'
      get 'redeem' => 'users#redeem'
    end
    collection do
      post 'authenticate' => 'users#authenticate'

    end
    end

end

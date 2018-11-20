Rails.application.routes.draw do
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

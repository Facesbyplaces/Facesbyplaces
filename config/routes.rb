Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'api/v1/users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  default_url_options :host => "http://localhost:3000"

  # memorial controller
    # All memorials
    get 'memorials', to: 'memorials#index'
    # Show memorial
    get 'memorials/:id/show', to: 'memorials#show', as: 'memorialShow'
    
    # New Memorial
    get 'memorials/new', to: 'memorials#new'
    post 'memorials', to: 'memorials#create'

    # Memorial details
    get 'memorials/:id/editDetails', to: 'memorials#editDetails'
    put 'memorials/:id(.:format)', to: 'memorials#updateDetails', as: 'memorialEditDetails'

    # Memorial images
    get 'memorials/:id/editImages', to: 'memorials#editImages'
    put 'memorials/:id/images', to: 'memorials#updateImages', as: 'memorialUpdateImages'

    # Delete memorial
    delete 'memorials/:id', to: 'memorials#delete', as: 'memorialdelete'

  # post controller
    # Create Post
    post 'posts', to: 'posts#create'
    # Show Post
    get 'posts/:id', to: 'posts#show'

  # search controller
    scope 'search' do
      # search posts
      get 'posts', to: 'search#posts'
      # search memorials
      get 'memorials', to: 'search#memorials'
    end
end

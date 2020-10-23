Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'api/v1/users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :users do 
        resources :verify
        resources :users, only: [:index, :edit, :update]
        resources :image_upload, only: [:create]
      end
    end
  end
  


  default_url_options :host => "http://localhost:3000"

  # main pages controller
    # user's feed
    get 'feed', to: 'mainpages#feed'
    # user's memorials
    get 'memorials', to: 'mainpages#memorials'
    # user's memorials
    get 'posts', to: 'mainpages#posts'

  # memorial controller
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
  
  # blm controller
    # Show memorial
    get 'blm/:id/show', to: 'blm#show', as: 'blmShow'
    
    # New Memorial
    get 'blm/new', to: 'blm#new'
    post 'blm', to: 'blm#create'

    # Memorial details
    get 'blm/:id/editDetails', to: 'blm#editDetails'
    put 'blm/:id(.:format)', to: 'blm#updateDetails', as: 'blmEditDetails'

    # Memorial images
    get 'blm/:id/editImages', to: 'blm#editImages'
    put 'blm/:id/images', to: 'blm#updateImages', as: 'blmUpdateImages'

    # Delete memorial
    delete 'blm/:id', to: 'blm#delete', as: 'blmdelete'

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
  
  # admin controller
    scope '/admin' do
      # all users
      get 'users', to: 'admin#allUsers'
      # view user
      get 'users/:id', to: 'admin#showUser'
      # search user
      get 'search/user', to: 'admin#searchUser'

      # view post
      get 'posts/:id', to: 'admin#showPost'
      # remove post
      delete 'posts/:id', to: 'admin#deletePost'
      # search post
      get 'search/post', to: 'admin#searchPost'

      # view memorial
      get 'memorials/:id', to: 'admin#showMemorial'
      # remove memorial
      delete 'memorials/:id', to: 'admin#deleteMemorial'
      # search memorial
      get 'search/memorial', to: 'admin#searchMemorial'

      # contact user
      post 'contact', to: 'admin#contactUser'
    end
end

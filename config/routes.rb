Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'api/v1/users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :users do 
        resources :verify, only: [:create]
        resources :users
        resources :image_upload, only: [:create]
      end
      namespace :reports do 
        resources :report, only: [:create]
      end
      namespace :shares do 
        resources :share, only: [:create, :index]
      end
      namespace :mainpages do
        # user's feed
        get 'feed', to: 'mainpages#feed'
        # user's memorials
        get 'memorials', to: 'mainpages#memorials'
        # user's memorials
        get 'posts', to: 'mainpages#posts'
      end
      namespace :pages do
        # memorial controller
          # Show memorial
          get 'memorials/:id', to: 'memorials#show', as: 'memorialShow'
          
          # New Memorial
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
          get 'blm/:id', to: 'blm#show', as: 'blmShow'
          
          # New Memorial
          post 'blm', to: 'blm#create'

          # Memorial details
          get 'blm/:id/editDetails', to: 'blm#editDetails'
          put 'blm/:id(.:format)', to: 'blm#updateDetails', as: 'blmEditDetails'

          # Memorial images
          get 'blm/:id/editImages', to: 'blm#editImages'
          put 'blm/:id/images', to: 'blm#updateImages', as: 'blmUpdateImages'

          # Delete memorial
          delete 'blm/:id', to: 'blm#delete', as: 'blmdelete'
      end
      namespace :posts do
        # Post Index
        get '/:userId', to: 'posts#index', as: 'postsIndex' 
        # Create Post
        post '/', to: 'posts#create'
        # Show Post
        get '/:id', to: 'posts#show'
      end
      namespace :admin do
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
        get 'memorials/:id/:page', to: 'admin#showMemorial'
        # remove memorial
        delete 'memorials/:id/:page', to: 'admin#deleteMemorial'
        # search memorial
        get 'search/memorial', to: 'admin#searchMemorial'
  
        # contact user
        post 'contact', to: 'admin#contactUser'
  
        # all reports
        get 'reports', to: 'admin#allReports'
        # show report
        get 'reports/:id', to: 'admin#showReport'
      end
      namespace :search do
        # search posts
        get 'posts', to: 'search#posts'
        # search memorials
        get 'memorials', to: 'search#memorials'
      end
      namespace :followers do
        post '/', to: 'followers#follow'
        delete '/', to: 'followers#unfollow'
      end
      namespace :pageadmin do
        post '/', to: 'pageadmin#addAdmin'
        delete '/', to: 'pageadmin#removeAdmin'
        
        post 'addFamily', to: 'pageadmin#addFamily'
        delete 'removeFamily/:id', to: 'pageadmin#removeFamily'
        
        post 'addFriend', to: 'pageadmin#addFriend'
        delete 'removeFriend/:id', to: 'pageadmin#removeFriend'

        get 'editPost/:post_id/:page_type/:page_id', to: 'pageadmin#editPost'
        put 'updatePost', to: 'pageadmin#updatePost'
      end
    end
  end
  


  default_url_options :host => "http://localhost:3000"

  # shares controller
    #user's shares
    get 'shares/:userId', to: 'shares#index', as: 'sharesIndex' 
  
 end

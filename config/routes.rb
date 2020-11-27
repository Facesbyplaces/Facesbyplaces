Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'api/v1/users/registrations',
    sessions: 'api/v1/users/sessions',
    # omniauth_callbacks: 'omniauth'
  }

  # devise_for :users, controllers: { omniauth_callbacks: 'omniauth'}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      #Set Account ID Stripe
      post 'payment_intent', to: 'payment_intent#set_payment_intent'
      get 'stripe_connect', to: 'stripe_connect#success_stripe_connect'
      
      namespace :users do 
        resources :verify, only: [:create]
        resources :users
        resources :image_upload, only: [:create]
        resources :create_account_user, only: [:create]
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
        # user's notifications
        get 'notifications', to: 'mainpages#notifications'
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

          # Set privacy
          get 'memorials/privacy/:privacy/:id', to: 'memorials#setPrivacy'

          # Set relationship
          post 'memorials/relationship', to: 'memorials#setRelationship'
        
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

          # Set privacy
          get 'blm/privacy/:privacy/:id', to: 'blm#setPrivacy'

          #Set Account ID Stripe
          resources :payment_intent, only: [:create]
          
          # Set relationship
          post 'blm/relationship', to: 'blm#setRelationship'
      end
      namespace :posts do
        # Post Index
        get '/', to: 'posts#index', as: 'postsIndex' 
        # Create Post
        post '/', to: 'posts#create'
        # Show Post
        get '/:id', to: 'posts#show', as: "show_post"
        # Posts of the page
        get '/page/:page_type/:page_id', to: 'posts#pagePosts'
        # Like Post
        get '/like/:post_id', to: 'posts#like'
        # Unlike Post
        get '/unlike/:post_id', to: 'posts#unlike'
        # Add Comment to Post
        post '/comment', to: 'comments#addComment'
        # Add Reply to Comment
        post '/reply', to: 'comments#addReply'
        # Like Comment or Reply
        get '/likeComment/:commentable_type/:commentable_id', to: 'comments#like'
        # Unlike Comment or Reply
        get '/unlikeComment/:commentable_type/:commentable_id', to: 'comments#unlike'
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
        # search users
        get 'users', to: 'search#users'
        # search followers
        get 'followers/:page_type/:page_id', to: 'search#followers'
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
        delete 'deletePost/:post_id/:page_type/:page_id', to: 'pageadmin#deletePost'
      end
      namespace :notifications do
        # ignore lists of notifications
        get 'ignore/:ignore_type/:ignore_id', to: 'notifsettings#create'
        delete 'ignore/:ignore_id', to: 'notifsettings#delete'

        # read all notifications
        get 'read', to: 'notifsettings#read'

        # number of unread notifications
        get 'numOfUnread', to: 'notifsettings#numOfUnread'
      end
    end
  end
  

  
  # default_url_options :host => "http://localhost:3000"
  default_url_options :host => "http://fbp.dev1.koda.ws"

  # shares controller
    #user's shares
    get 'shares/:userId', to: 'shares#index', as: 'sharesIndex' 
  
 end

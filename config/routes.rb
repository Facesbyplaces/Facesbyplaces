Rails.application.routes.draw do
  
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'api/v1/users/registrations',
    sessions: 'api/v1/users/sessions',
  }, :skip => [:omniauth_callbacks]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      #Set Account ID Stripe
      post 'payment_intent', to: 'payment_intent#set_payment_intent'
      get 'stripe_connect', to: 'stripe_connect#success_stripe_connect'
      
      namespace :users do 
        resources :verify, only: [:create]
        resources :image_upload, only: [:create, :update]
        resources :create_account_user, only: [:create]
        resources :image_show, only: [:index]
        devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/users/omniauth_callbacks" }
      end
      devise_scope :user do
        delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
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

          # Leave blm
          delete 'memorials/:id/relationship/leave', to: 'memorials#leaveMemorial'

          # family Index
          get 'memorials/:id/family/index', to: 'memorials#familyIndex'

          # friends Index
          get 'memorials/:id/friends/index', to: 'memorials#friendsIndex'

          # followers Index
          get 'memorials/:id/followers/index', to: 'memorials#followersIndex'

          # admin Index
          get 'memorials/adminIndex/index', to: 'memorials#adminIndex'
        
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

          # Leave blm
          delete 'blm/:id/relationship/leave', to: 'blm#leaveBLM'

          # family Index
          get 'blm/:id/family/index', to: 'blm#familyIndex'

          # friends Index
          get 'blm/:id/friends/index', to: 'blm#friendsIndex'

          # followers Index
          get 'blm/:id/followers/index', to: 'blm#followersIndex'

          # admin Index
          get 'blm/adminIndex/index', to: 'blm#adminIndex'
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
        # List of pages that the user can post in
        get '/listPages/show', to: 'posts#listOfPages'

        # Add Comment to Post
        post '/comment', to: 'comments#addComment'
        # Add Reply to Comment
        post '/reply', to: 'comments#addReply'
        # Like Comment or Reply
        get '/likeComment/:commentable_type/:commentable_id', to: 'comments#like'
        # Unlike Comment or Reply
        get '/unlikeComment/:commentable_type/:commentable_id', to: 'comments#unlike'
        # Comments index
        get '/index/comments/:id', to: 'comments#commentsIndex'
        # Replies index
        get '/index/replies/:id', to: 'comments#repliesIndex'
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
        # search nearby
        get 'nearby', to: 'search#nearby'
        # suggested
        get 'suggested', to: 'search#suggested'
      end
      namespace :followers do
        get '/', to: 'followers#followStatus'
        put '/', to: 'followers#followOrUnfollow'
      end
      namespace :pageadmin do
        post '/', to: 'pageadmin#addAdmin'
        delete '/', to: 'pageadmin#removeAdmin'
        
        post 'addFamily', to: 'pageadmin#addFamily'
        post 'addFriend', to: 'pageadmin#addFriend'

        delete 'removeFamilyorFriend/:page_type/:page_id/:user_id', to: 'pageadmin#removeFamilyorFriend'

        get 'editPost/:post_id/:page_type/:page_id', to: 'pageadmin#editPost'
        put 'updatePost', to: 'pageadmin#updatePost'
        delete 'deletePost/:post_id/:page_type/:page_id', to: 'pageadmin#deletePost'

        get 'hideStatus/:page_type/:page_id', to: 'pageadmin#hideStatus'

        put 'unhideOrHideFamily/:page_type/:page_id', to: 'pageadmin#unhideOrHideFamily'
        put 'unhideOrHideFriends/:page_type/:page_id', to: 'pageadmin#unhideOrHideFriends'
        put 'unhideOrHideFollowers/:page_type/:page_id', to: 'pageadmin#unhideOrHideFollowers'
      end
      namespace :notifications do
        get 'notifSettingsStatus', to: 'notifsettings#notifSettingsStatus'

        put 'newMemorial', to: 'notifsettings#newMemorial'
        put 'newActivities', to: 'notifsettings#newActivities'
        put 'postLikes', to: 'notifsettings#postLikes'
        put 'postComments', to: 'notifsettings#postComments'
        put 'addFamily', to: 'notifsettings#addFamily'
        put 'addFriends', to: 'notifsettings#addFriends'
        put 'addAdmin', to: 'notifsettings#addAdmin'

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

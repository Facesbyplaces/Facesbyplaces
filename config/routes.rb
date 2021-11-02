Rails.application.routes.draw do
  
  # Route for BLM User
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'api/v1/users/registrations',
    sessions: 'api/v1/users/sessions',
    passwords: 'api/v1/users/passwords',
  }, :skip => [:omniauth_callbacks]
  
  # Route for ALM User
  mount_devise_token_auth_for 'AlmUser', at: 'alm_auth', controllers: {
    # Define routes for AlmUser within this block.
    registrations: 'api/v1/users/registrations',
    sessions: 'api/v1/users/sessions',
    passwords: 'api/v1/users/passwords',
  }, :skip => [:omniauth_callbacks]

  mount_devise_token_auth_for 'User2', at: 'auth2'
  as :user2 do
    # Define routes for User2 within this block.
  end

  mount_devise_token_auth_for 'Admin', at: 'admin_auth', controllers: {
    # Define routes for Admin within this block.
    registrations: 'api/v1/admin/registrations',
    sessions: 'api/v1/admin/sessions',
  }, :skip => [:omniauth_callbacks]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      
      
      namespace :users do 
        # resources :verify, only: [:create]
        resources :resend_verification_code, only: [:create]
        resources :create_account_user, only: [:create]
        resources :image_show, only: [:index]

        get 'check_password', to: 'users#check_password'
        post 'verify_code', to: 'verify#verify'

        post 'signin-blm-guest', to: 'users#blm_guest'
        post 'signin-alm-guest', to: 'users#alm_guest'
      
        put 'image_upload', to: 'image_upload#update'
        post 'image_upload', to: 'image_upload#create'

        put 'updateDetails', to: 'users#updateDetails'
        get 'getDetails', to: 'users#getDetails'
        put 'updateOtherInfos', to: 'users#updateOtherInfos'
        get 'getOtherInfos', to: 'users#getOtherInfos'
        get 'showDetails', to: 'users#show'
        get 'posts', to: 'users#posts'
        get 'memorials', to: 'users#memorials'
        
        get 'otherDetailsStatus', to: 'users#otherDetailsStatus'
        put 'hideOrUnhideBirthdate', to: 'users#hideOrUnhideBirthdate'
        put 'hideOrUnhideBirthplace', to: 'users#hideOrUnhideBirthplace'
        put 'hideOrUnhideEmail', to: 'users#hideOrUnhideEmail'
        put 'hideOrUnhideAddress', to: 'users#hideOrUnhideAddress'
        put 'hideOrUnhidePhonenumber', to: 'users#hideOrUnhidePhonenumber'
        
      end
      
      namespace :reports do 
        resources :report, only: [:create]
      end

      namespace :shares do 
        get 'share', to: 'share#getLink'
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
        # Like Status
        get '/likePost/status', to: 'posts#likeStatus'
        # Unlike or Like Post
        put '/likePost/unlikeOrLike', to: 'posts#unlikeOrLike'
        # List of pages that the user can post in
        get '/listPages/show', to: 'posts#listOfPages'
        # Add Comment to Post
        post '/comment', to: 'comments#addComment'
        # Add Reply to Comment
        post '/reply', to: 'comments#addReply'
        # edit Comment
        put 'comment', to: 'comments#editComment'
        # edit reply
        put 'reply', to: 'comments#editReply'
        # Like Status
        get '/comment/likeCommentStatus', to: 'comments#likeStatus'
        # Unlike or Like Comment or Reply
        put '/comment/unlikeOrLikeComment', to: 'comments#likeOrUnlike'
        # Comments index
        get '/index/comments/:id', to: 'comments#commentsIndex'
        # Replies index
        get '/index/replies/:id', to: 'comments#repliesIndex'
        # Delete Comment
        delete 'comment', to: 'comments#deleteComment'
        # Delete reply
        delete 'reply', to: 'comments#deleteReply'
      end

      namespace :admin do

        # all users
        get 'users',                                to: 'users#allUsers'
        # view user
        get 'users/show',                           to: 'users#showUser'
        # edit user
        put 'users/edit',                           to: 'users#editUser'
        # delete user
        post 'users/delete',                        to: 'users#deleteUser'
        # search user
        get 'users/search',                         to: 'users#searchUsers'
        # contact user
        post 'users/contact',                       to: 'users#contactUser'

        # index post
        get 'posts',                                to: 'posts#allPosts'
        # add post
        post 'posts/create',                        to: 'posts#createPost'
        # edit post
        put 'posts/edit/:id',                       to: 'posts#editPost'
        # edit post image
        put 'posts/image/:id',                      to: 'posts#editImageOrVideosPost'
        # index memorial post
        get 'posts/memorials',                      to: 'posts#memorialSelection'
        # index memorial post page admins
        get 'posts/pageAdmins',                     to: 'posts#pageAdmins'
        # view post
        get 'posts/:id',                            to: 'posts#showPost'
        # remove post
        delete 'posts/:id',                         to: 'posts#deletePost'
        # search post
        get 'search/post',                          to: 'posts#searchPost'

        # all users without paginations
        get 'comments/users/selection/:page_type',  to: 'comments#usersSelection'
        # comments
        get 'comments',                             to: 'comments#commentsIndex'
        # edit comment
        put 'comments/edit',                        to: 'comments#editComment'
        # add comment
        post 'comments/add',                        to: 'comments#addComment'
        # delete comment
        delete 'comments/delete',                   to: 'comments#deleteComment'
        # delete comment
        get 'search/comments',                      to: 'comments#searchComment'

        # all users without paginations
        get 'memorials/users/selection',            to: 'memorials#usersSelection'
        # all memorials
        get 'memorials',                            to: 'memorials#allMemorials'
        # add memorials
        post 'memorials/add',                       to: 'memorials#createMemorial'
        # view memorial
        get 'memorials/:id/:page',                  to: 'memorials#showMemorial'
        # update memorial
        put 'memorials/:id',                        to: 'memorials#updateMemorial'
        # update memorial images
        put 'memorials/image/:id/:page',            to: 'memorials#updateMemorialImages'
        # update blm
        put 'memorials/blm/:id',                    to: 'memorials#updateBlm'
        # update blm images
        put 'memorials/blm/image/:id/:page',        to: 'memorials#updateBlmImages'
        # remove memorial
        delete 'memorials/:id/:page',               to: 'memorials#deleteMemorial'
        # search memorial
        get 'search/memorial',                      to: 'memorials#searchMemorial'
  
        # all reports
        get 'reports',                              to: 'reports#allReports'
        # fetch all datas
        get 'reports/fetchData/:reportable_type',   to: 'reports#fetchData'
        # add report
        post 'reports/create',                      to: 'reports#createReport'
        # show report
        get 'reports/:id',                          to: 'reports#showReport'
        # edit report
        put 'reports/edit/:id',                     to: 'reports#editReport'
        # delete report
        delete 'reports/delete/:id',                to: 'reports#deleteReport'
        # search post
        get 'search/report',                        to: 'reports#searchReport'

        # all transactions
        get 'transactions',                         to: 'transactions#allTransactions'
        # show transaction
        get 'transactions/show',                    to: 'transactions#showTransaction'
        # payout transaction
        put 'transactions/payout/:id',              to: 'transactions#payoutTransaction'

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
        # Test current_user
        get 'test', to: 'search#test'
      end

      namespace :followers do
        get '/', to: 'followers#followStatus'
        put '/follow', to: 'followers#follow'
        put '/unfollow', to: 'followers#unfollow'
      end

      namespace :pageadmin do
        post '/', to: 'pageadmin#addAdmin'
        delete '/', to: 'pageadmin#removeAdmin'
        
        post 'addFamily', to: 'pageadmin#addFamily'
        post 'addFriend', to: 'pageadmin#addFriend'

        delete 'removeFamilyorFriend', to: 'pageadmin#removeFamilyorFriend'

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

        post 'pushNotification', to: 'notifsettings#pushNotification'

        # read all notifications
        get 'read', to: 'notifsettings#read'

        # number of unread notifications
        get 'numOfUnread', to: 'notifsettings#numOfUnread'
      end

      namespace :payments do 
        post  'payment_intent',               to: 'payment_intent#payment_intent'
        post  'payment_method',               to: 'payment_intent#create_payment_method'
        post  'confirm_payment_intent',       to: 'payment_intent#confirm_payment_intent'
        #Set Account ID Stripe
        get   'stripe_connect',               to: 'stripe_connect#success_stripe_connect'
        #Set Paypal Account to Memorial
        post  'braintree',                    to: 'braintree#createPayPalAccount'
        #Create Apple Pay Transaction
        post  'braintree/appleOrGooglePay',   to: 'braintree#createAppleOrGooglePayTransaction'
        #Braintree
        resources :braintree, only: [:new, :create, :show]
      end

    end
  end
  

  
  # default_url_options :host => "http://localhost:3000"
  # default_url_options :host => "http://fbp.dev1.koda.ws"
  default_url_options :host => "https://facesbyplaces.com"

  # shares controller
    #user's shares
    get 'shares/:userId', to: 'shares#index', as: 'sharesIndex' 

  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'terms', to: 'pages#terms'
<<<<<<< HEAD
=======
  get 'privacy', to: 'pages#privacy'
  get 'sign-up', to: 'pages#signUp'
  post 'sign-up-user', to: 'pages#create'
>>>>>>> new-web-homepage
  
  get 'new-home', to: 'pages#newHome'

 end

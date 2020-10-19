Rails.application.routes.draw do
  default_url_options :host => "http://localhost:3000"

  # memorial controller
    # All memorials
    get 'memorials', to: 'memorials#index'
    # Show memorial
    get 'memorials/:id', to: 'memorials#show'
    
    # New Memorial
    get 'memorials/new', to: 'memorials#new'
    post 'memorials', to: 'memorials#create'

    # Memorial details
    get 'memorials/:id/editDetails', to: 'memorials#editDetails'
    put 'memorials/:id', to: 'memorials#updateDetails', as: 'memorialEditDetails'

    # Memorial images
    get 'memorials/:id/editImages', to: 'memorials#editImages'
    put 'memorials/:id/images', to: 'memorials#updateImages', as: 'memorialUpdateImages'

    # Delete memorial
    delete 'memorials/:id', to: 'memorials#delete', as: 'memorialdelete'
end

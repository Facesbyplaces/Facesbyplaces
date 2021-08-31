class Api::V1::Search::SearchController < ApplicationController
    include Searchable
    before_action :authenticate_user, only: [:nearby, :suggested, :test]
    before_action :set_posts, only: [:posts]
    before_action :set_memorials, only: [:memorials]
    before_action :set_users, only: [:users]
    before_action :set_page, only: [:followers]
    before_action :set_followers, only: [:followers]
    before_action :set_nearby_alms, only: [:nearby]
    before_action :set_nearby_blms, only: [:nearby]
    before_action :set_suggested_pages, only: [:suggested]

    def posts
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                            @posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    def memorials
        render json: {  itemsremaining:  itemsRemaining(@memorials),
                        memorials: ActiveModel::SerializableResource.new(
                                    @memorials, 
                                    each_serializer: SearchmemorialSerializer
                                )
                    }
    end

    def users
        render json: {  itemsremaining:  itemsRemaining(@users),
                        users: ActiveModel::SerializableResource.new(
                            @users, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def followers
        render json: {  itemsremaining:  itemsRemaining(@followers),
                        followers: ActiveModel::SerializableResource.new(
                            @followers, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def nearby
        render json: {
            blmItemsRemaining: itemsRemaining(@blms),
            blm: ActiveModel::SerializableResource.new(
                    @blms, 
                    each_serializer: BlmSerializer
                ),
            memorialItemsRemaining: itemsRemaining(@memorials),
            memorial: ActiveModel::SerializableResource.new(
                    @memorials, 
                    each_serializer: MemorialSerializer
                )
        }
    end

    def suggested
        render json: {
            itemsRemaining: itemsRemaining(@pages),
            pages: ActiveModel::SerializableResource.new(
                        @pages, 
                        each_serializer: PageownerSerializer
                    )
        }
    end

    def test
        render json: {user: user().first_name, type: user().account_type}
    end

    private

    def user_location
        lon = params[:longitude].to_f
        lat = params[:latitude].to_f

        return user_location = Geocoder.search([lat,lon])
    end
end

module Memorialable
    include ApplicationConcern

    def set_memorials
        alm_memorials = Memorial.all.order("memorials.id DESC")
        alm_memorials = alm_memorials.page(params[:page]).per(numberOfPage)
        @memorials = ActiveModel::SerializableResource.new(
                            alm_memorials, 
                            each_serializer: MemorialSerializer
                        )
    end

    def set_blms
        blm_memorials = Blm.all.order("blms.id DESC")
        @blm_memorials = blm_memorials.page(params[:page]).per(numberOfPage)
        @blms = ActiveModel::SerializableResource.new(
                            @blm_memorials, 
                            each_serializer: BlmSerializer
                        )   
    end

    def set_search_memorials
        memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['Memorial', 'Blm'])
        @memorials = memorials.page(params[:page]).per(numberOfPage)

        @searched_memorials = @memorials.collect do |memorial|
            if memorial.searchable_type == 'Blm'
                memorial = Blm.find(memorial.searchable_id)
                set_page_type(1)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: BlmSerializer
                )
            else
                memorial = Memorial.find(memorial.searchable_id)
                set_page_type(2)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: MemorialSerializer
                )
            end
        end
    end

    def set_users
        alm_users = AlmUser.all.order("alm_users.id DESC")
        blm_users = User.all.where.not(guest: true, username: "admin").order("users.id DESC")

        @users = alm_users + blm_users
    end

    def set_memorial
        if (params[:page].present? && params[:page] === "Blm") || (blm_details_params[:precinct].present?)
            @memorial = Blm.find(params[:id])
        else
            @memorial = Memorial.find(params[:id])
        end
    end

    
    def set_page_type(i)
        @page_type = i
    end

    def set_notif_type
        if params[:page_type].to_i == 2
            @notif_type = 'Memorial'
        else
            @notif_type = 'Blm'
        end
    end
end
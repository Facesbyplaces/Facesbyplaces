module Blmable
    include ApplicationConcern

    def set_blm
        @blm = Blm.find(params[:id])
    end
end
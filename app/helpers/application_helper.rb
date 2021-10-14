module ApplicationHelper
    def attachment_image resource
        resource.backgroundImage.attached? ? (Rails.env.production? ? resource.image_url : "#{request.base_url}#{url_for(resource.backgroundImage)}") : ""
        resource.profileImage.attached? ? (Rails.env.production? ? resource.image_url : "#{request.base_url}#{url_for(resource.profileImage)}") : ""
        resource.imagesOrVideos.attached? ? (Rails.env.production? ? resource.image_url : "#{request.base_url}#{url_for(resource.imagesOrVideos)}") : ""
    end
end

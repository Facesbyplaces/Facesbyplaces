module ApplicationConcern
  extend ActiveSupport::Concern
  include Pagy::Backend

  def current_page
    params[:start].present? ? params[:start].to_i / params[:length].to_i + 1 : 1
  end

  def to_bool value
    ActiveModel::Type::Boolean.new.cast(value) 
  end
end
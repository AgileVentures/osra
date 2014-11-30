class RailsController < ApplicationController

  before_filter :get_crumbs, :get_user, :get_path, :get_request_params, :get_flashes
  layout 'application'

  def get_title name
    #first try to find an instance of a model, then a model, then default to name.to_s
    @model= ActiveRecord::Base.descendants.to_a.map do |model|
      model if model.name== name
    end.compact.first
    @page_title= if @model && params.has_key?(:id)
      @model.find_by_id(params[:id]).to_s
    else
      @model.name.pluralize if @model
    end || name.to_s
  end

  private

  def get_path
    @path= request.path.to_s
  end

  def get_request_params
    #@new_separator= @path.include?('?') ? '&' : '?'
    @request_params= params.except(*request.path_parameters.keys)
  end

  def get_flashes
    @flashes ||= flash.to_hash.with_indifferent_access
  end

  def get_user
    @user= current_admin_user
    @body_class= (@user && 'active_admin logged_in admin_namespace') || 'active_admin logged_out new'
  end

  def get_crumbs(path= request.path)
    parts= path.split('/').select(&:present?)[0..-2]
    @crumbs= [ ActionController::Base.helpers.link_to('Osra', root_path) ].tap do |crumbs|
      crumbs << parts.each_with_index.map do |part, index|
        ActionController::Base.helpers.link_to(part.titlecase, '/' + parts[0..index].join('/'))
      end
    end.flatten.compact
  end

end

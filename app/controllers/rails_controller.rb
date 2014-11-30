class RailsController < ApplicationController

  DEFAULT_SORT_SQL = '"id" ASC'

  before_filter :get_crumbs, :get_user, :get_request_params, :get_flashes
  layout 'application'

  def get_title name
    #first try to find a model instance, then a model, then default to name.to_s
    @models= ActiveRecord::Base.descendants.to_a
    @model= @models.map do |model|
      model if model.name== name
    end.compact.first
    @page_title= if @model && params.has_key?(:id)
      @model.find_by_id(params[:id]).to_s
    else
      @model.name.pluralize if @model
    end || name.to_s
  end

  private

  def get_request_params
    @request_params= params.except(*request.path_parameters.keys)
  end

  def get_flashes
    @flashes= flash.to_hash.with_indifferent_access
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

  def make_sort_sql
    @sort_sql= DEFAULT_SORT_SQL
    @new_direction= 'asc'
    if whitelist @request_params[:order]
      @sort_sql= first_half(@request_params[:order]) +
              ' ' + second_half(@request_params[:order])
      @new_direction= 'desc' if second_half(@request_params[:order])== 'ASC'
    end
  end

  def first_half sort_criteria
    sort_criteria.to_s.gsub(/_[^_]+$/, '')
  end

  def second_half sort_criteria
    sort_criteria.gsub(/.*_/, '').upcase
  end

  def whitelist param
    if param && @model && ['ASC', 'DESC'].include?(second_half(param))
      ['addresses.province_id', 'orphan_sponsorship_statuses.name',
              'partners.name'].include?(first_half(param)) ||
              @model.method_defined?(first_half(param).to_sym)
    end
  end

end

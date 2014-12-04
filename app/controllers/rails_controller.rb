class RailsController < ApplicationController

  HEADER_BUTTONS = ['dashboard', 'partners', 'sponsors', 'orphans', 'users', 'admin_users']
  DEFAULT_SORT_SQL = '"id" ASC'
  WHITELISTED_SORT_DEEP_JOINS = [ 'addresses.province_id',
                                  'orphan_sponsorship_statuses.name',
                                  'partners.name'
                                ]

  before_filter :authenticate_admin_user!, :get_user, :get_crumbs, :get_request_params, :get_flashes
  layout 'application'

  def link_to *args
    ActionController::Base.helpers.link_to *args
  end

private

  def get_title name
    #first try to find a model instance, then a model, then fall back to name.to_s
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
    @crumbs= [ link_to('Osra', root_path) ].tap do |crumbs|
      crumbs << parts.each_with_index.map do |part, index|
        link_to(part.titlecase, '/' + parts[0..index].join('/'))
      end
    end.flatten.compact
  end

  def make_sort_sql
    @sort_sql= DEFAULT_SORT_SQL
    @new_direction= 'desc'
    if whitelist @request_params[:order]
      @sort_sql= field(@request_params[:order]) +
              ' ' + direction(@request_params[:order])
      @new_direction= 'asc' if direction(@request_params[:order])== 'DESC'
    end
  end

  def field sort_criteria
    sort_criteria.to_s.gsub(/_[^_]+$/, '')
  end

  def direction sort_criteria
    sort_criteria.to_s.gsub(/.*_/, '').upcase
  end

  def whitelist sort_param
    if sort_param && @model && ['ASC', 'DESC'].include?(direction(sort_param))
      #TODO: investigate whether the next line might introduce a symbol overflow vulnerbility (param[:foo].to_sym)
      WHITELISTED_SORT_DEEP_JOINS.include?(field(sort_param)) ||
              @model.method_defined?(field(sort_param).to_sym)
    end
  end

end

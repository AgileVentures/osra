module ColumnSort
  extend ActiveSupport::Concern

  included do
    scope :column_sort, ->(column, direction = nil) do
      direction ||= :asc
      #validate first
      if column.nil? || !(self.column_names.include?(column.to_s))
        return order(nil)
      end
      direction = :asc unless direction.to_sym == :desc

      return order(column => direction)
    end
  end

end
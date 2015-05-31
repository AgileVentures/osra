module ColumnSort
  extend ActiveSupport::Concern

  included do
    scope :column_sort, ->(column, direction = nil) do
      #validate first
      if column.nil? || !(self.column_names.include?(column.to_s))
        return order(nil)
      end
      direction = :asc if !direction || direction.to_sym != :desc

      return order(column => direction)
    end
  end

end
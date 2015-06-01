module ColumnSort
  extend ActiveSupport::Concern

  included do

    #adds class method `column_sort` that returns an ActiveRelation object containing a sorted list.
    # column: is a table_column of the ActiveRecord object
    # direction:  is "asc" or "desc" and represent the direction of sorting
    # add `include ColumnSort` to your Model class
    # use like:  `Sponsor.column_sort("name", "asc")
    scope :column_sort, ->(column, direction = nil) do
      #validating first
      if column.nil? || !(self.column_names.include?(column.to_s))
        return order(nil)
      end
      direction = :asc if !direction || direction.to_sym != :desc

      return order(column => direction)
    end
  end

end
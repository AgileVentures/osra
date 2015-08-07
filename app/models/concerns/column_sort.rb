module ColumnSort
  extend ActiveSupport::Concern

  included do

    scope :sort_by_column, ->(column, direction, includes=nil) do
      self.includes(includes).order(column + " " +  direction)
    end

  end

end



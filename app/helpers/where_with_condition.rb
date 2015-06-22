module WhereWithCondition
protected

  # where_with_conditions(query_array, options: {conditions: [], join: nil})
  #    query_array :          a string or array that will be passed to the SQL query  (the same as for .where)
  #    options[:conditions] : an array of condition statements that will decide if the query_array will be executed.
  #                        Otherwise it will return same object that it was called on
  #    options[:join] : the name of the table to be joined
  # It should extend a model as a class method and a [Model]::ActiveRecord_Relation as an instance method
  # returns an [Model]::ActiveRecord_Relation object or self
  # Method is protected and used inside the [Model].filter method
  #
  # example: Sponsor.where_with_conditions(["gender LIKE ?", params(:gender)], conditions: [params(:gender)], join: :table)
  def where_with_conditions query=[], options_hash={conditions: [], join: nil}
    conditions_valid = options_hash[:conditions].all? {|c| c ? true : false}
    conditions_valid ? self.joins(options_hash[:join]).where(query) : self.where(nil)
  end
end
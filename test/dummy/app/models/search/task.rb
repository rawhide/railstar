class Search::Task < Railstar::SearchBase
  TARGET_COLUMN = %w(name like_name status project_id from_price to_price)
  attr_accessor *TARGET_COLUMN

  private
  def create_conditions
    eq(:project_id)
    eq(:name)
    like(:like_name, column: :name)
    inc(:status)
    compare(:from_price, ">=", column: :price)
    compare(:to_price, "<=", column: :price)
  end

  def target_model
    ::Task
  end
end

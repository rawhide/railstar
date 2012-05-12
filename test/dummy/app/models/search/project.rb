class Search::Project < Railstar::SearchBase
  TARGET_COLUMN = %w(name like_name)
  attr_accessor *TARGET_COLUMN

  private
  def create_conditions
    eq(:name)
    like(:like_name, column: :name, table_name: "tasks")
  end

  def target_model
    ::Project
  end
end

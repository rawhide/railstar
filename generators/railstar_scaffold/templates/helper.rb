module <%= controller_class_name %>Helper

  # move to application_helper
  def save_action(object)
    if object.new_record?
      {:action => "create"}
    else
      {:action => "update", :id => object.id}
    end
  end
end

module TasksHelper
  def task_enum_options(enum_name)
    Task.send(enum_name.to_s.pluralize).keys.map do |key|
      [ t(key, scope: [ :enums, :task, enum_name ]), key ]
    end
  end
end

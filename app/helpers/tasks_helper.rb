module TasksHelper
  def task_priority_options
    Task.priorities.keys.map do |key|
      [ I18n.t("enums.task.priority.#{key}"), key ]
    end
  end

  def task_status_options
    Task.statuses.keys.map do |key|
      [ I18n.t("enums.task.status.#{key}"), key ]
    end
  end
end

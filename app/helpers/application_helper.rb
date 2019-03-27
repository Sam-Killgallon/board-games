# frozen_string_literal: true

module ApplicationHelper
  def scheduled_time_in_words(time, context: nil)
    return 'Unscheduled' unless time

    case context
    when :future   then "In #{time_ago_in_words(time)}"
    when :past     then "#{time_ago_in_words(time)} ago"
    when :flexible then flexible_time(time)
    else time_ago_in_words(time)
    end
  end

  private

  def flexible_time(time)
    if Time.current > time
      scheduled_time_in_words(time, context: :past)
    else
      scheduled_time_in_words(time, context: :future)
    end
  end
end

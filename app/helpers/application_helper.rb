# frozen_string_literal: true

module ApplicationHelper
  def scheduled_time_in_words(time, context: nil)
    return 'Unscheduled' unless time

    case context
    when :future
      "In #{time_ago_in_words(time)}"
    when :past
      "#{time_ago_in_words(time)} ago"
    when :flexible
      if (Time.current > time)
        scheduled_time_in_words(time, context: :past)
      else
        scheduled_time_in_words(time, context: :future)
      end
    else
      time_ago_in_words(time)
    end
  end
end

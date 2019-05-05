# frozen_string_literal: true

module ApplicationHelper
  def scheduled_time_in_words(time)
    return 'Unscheduled' unless time

    if Time.current > time
      "#{time_ago_in_words(time)} ago"
    else
      "In #{time_ago_in_words(time)}"
    end
  end
end

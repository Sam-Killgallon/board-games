# frozen_string_literal: true

module ApplicationHelper
  def nav_link_to(name, path, html_options = {})
    classes = html_options.fetch(:class, [])
    classes << 'active' if current_page?(path)
    html_options[:class] = classes

    link_to(name, path, html_options)
  end

  def scheduled_time_in_words(time)
    return 'Unscheduled' unless time

    if Time.current > time
      "#{time_ago_in_words(time)} ago"
    else
      "In #{time_ago_in_words(time)}"
    end
  end
end

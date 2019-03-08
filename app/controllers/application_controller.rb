# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def require_user!
    current_user || not_found
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end

# frozen_string_literal: true

class Admin::ApplicationController < ActionController::Base
  before_action :require_admin!

  private

  def require_admin!
    current_user&.admin? || not_found
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end

# frozen_string_literal: true

module AuthenticationHelpers
  def not_found_without_user(description, &block)
    test "#{description} requires a user" do
      sign_out(:user)
      assert_raises(ActionController::RoutingError) do
        instance_exec(&block)
      end
    end
  end

  def not_found_for_normal_users(description, &block)
    test "#{description} requires an admin" do
      sign_in(create(:user))
      assert_raises(ActionController::RoutingError) do
        instance_exec(&block)
      end
    end
  end
end

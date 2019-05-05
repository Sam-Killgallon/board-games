# frozen_string_literal: true

RSpec.shared_examples 'not found' do
  it 'returns 404 status code' do
    expect { subject }.to raise_error(ActionController::RoutingError, 'Not Found')
  end
end

# frozen_string_literal: true

FactoryBot.define do
  auth_controller = AuthController.new
  factory :user do
    username { 'test_user' }
    password { 'test_user' }
  end
end

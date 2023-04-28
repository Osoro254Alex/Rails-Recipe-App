require 'faker'

FactoryBot.define do
  factory :user do
    name { 'tariq' }
    email { 'tariq@gmail.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end

User = Struct.new(:username)

FactoryBot.define do
  factory :user do
    username { "Hello World" }
  end
end

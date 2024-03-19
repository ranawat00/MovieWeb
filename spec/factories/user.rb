FactoryBot.define do
  factory :user do
    firstname { Faker::Name.name }
    lastname { Faker::Name.name }
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password" }
    # password_confirmation { "password"}
    # reset_password_token { nil }
    # reset_password_sent_at { nil }
    # remember_created_at { nil }
    # twofa { nil }
    # twofa_on_off { false }

    # trait :with_twofa do
    #   twofa { Faker::Alphanumeric.alphanumeric(number: 10) }
    #   twofa_on_off { true }
    # end
  end
end

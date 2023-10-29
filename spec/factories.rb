FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :style do
    name { "Lager" }
    description { "Universal lager." }
  end

  factory :beer do
    name { "anonymous" }
    brewery # use brewery factory
    style # use style factory
  end

  factory :rating do
    score { 10 }
    beer # use beer factory
    user # use user factory
  end
end

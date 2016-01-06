FactoryGirl.define do
  factory :todo do
    title FFaker::Lorem::sentence(5)
    completed false
    user nil
    group nil
    creator nil
  end

end

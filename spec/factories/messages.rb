FactoryGirl.define do
  factory :message do
    subject FFaker::Lorem::sentence(5)
    message FFaker::Lorem::paragraph(1)
    user nil
    group nil
    responds nil
  end

end

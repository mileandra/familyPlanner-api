FactoryGirl.define do
  factory :message do
    message FFaker::Lorem::paragraph(1)
    user nil
    group nil
  end

end

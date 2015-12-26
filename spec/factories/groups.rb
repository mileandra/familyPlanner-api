FactoryGirl.define do
  factory :group do
    name {FFaker::Name::last_name}
    owner nil
  end

end

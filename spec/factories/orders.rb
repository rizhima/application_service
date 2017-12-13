# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    pickup "kolla sabang"
    destination "sarinah mall"
    payment 'cash'
    distance "9.99"
    total "9000"

    association :customer
    association :driver
  end

  factory :invalid_order, parent: :user do
    pickup ''
    destination ''
    payment nil
    distance nil
    total nil
  end
end

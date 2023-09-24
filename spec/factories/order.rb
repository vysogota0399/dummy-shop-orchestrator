FactoryBot.define do
  factory :order do
    customer_id { 1 }
    customer_email { 'user@mail.ru' }
    address { 'Russia, Moscow' }
    front_door { '1' }
    floor { '10' }
    intercom { '#0000#' }

    trait :damaged do
      state { 'damaged' }
      error { { message: '', backtrace: '' } }
    end

    factory :order_with_items do
      transient do
        items_count { 5 }
      end

      after(:create) do |order, evaluator|
        items = create_list(:item, evaluator.items_count)
        order.items = items
        order.reload
      end
    end
  end
end
require 'faker'

Item.destroy_all

1000.times do
  kind = Item.kinds.keys.sample
  Item.create(
    kind: kind,
    cost_cops: rand(1000..100000),
    weight: rand(100..1000)/100*100,
    remainder: rand(100000..10000000),
    title: "#{kind} #{Faker::Food.dish}",
    description: Faker::Food.description
  )
end
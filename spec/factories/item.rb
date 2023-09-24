FactoryBot.define do
  factory :item do
    kind { 'alcohol' }
    cost_cops { 10000 }
    weight { rand(500) }
    remainder { 10000 }
    title { "Barister" }
    description { "Best gin ever" }
  end
end
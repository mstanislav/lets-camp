class MapPin < NanoStore::Model
  attribute :address
  attribute :created_at
end

class SuppliesItems < NanoStore::Model
  attribute :name
  attribute :quantity
  attribute :created_at
end

class FoodItems < NanoStore::Model
  attribute :name
  attribute :quantity
  attribute :created_at
end

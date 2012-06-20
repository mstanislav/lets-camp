class MapPin < NanoStore::Model
  attribute :address
  attribute :created_at
end

class MapType < NanoStore::Model
  attribute :type
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

class CampgroundSearch < NanoStore::Model
  attribute :type
  attribute :state
  attribute :created_at
end

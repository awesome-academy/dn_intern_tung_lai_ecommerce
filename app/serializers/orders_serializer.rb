class API::V1::OrdersSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :status, :total_price, :created_at, :updated_at
end

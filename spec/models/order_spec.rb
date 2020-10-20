require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "#validations" do
    it "minimal valid requirements" do
      order = Order.new(
        product: Product.new,
        child: Child.new,
        shipping_name: "Some name"
      )
      expect(order.valid?).to eq(true)
      expect(order.is_gift).to eq(false)
    end

    it "requires shipping_name" do
      order = Order.new(
        product: Product.new,
        shipping_name: nil,
        address: "123 Some Road",
        zipcode: "90210",
        user_facing_id: "890890908980980"
      )

      expect(order.valid?).to eq(false)
      expect(order.errors[:shipping_name].size).to eq(1)
    end
  end
end

class AddGiftingFlagToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :is_gift, :boolean, default: false, null: false
    add_column :orders, :gift_message, :text, null: true
  end
end

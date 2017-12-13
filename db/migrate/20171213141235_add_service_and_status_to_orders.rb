class AddServiceAndStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :service, :integer
    add_column :orders, :status, :string
  end
end

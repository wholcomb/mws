module MWS
  module API

    class Inventory < Base

      def_request [:list_inventory_supply, :list_inventory_supply_by_next_token],
        :verb => :get,
        :uri => '/FulfillmentInventory/2010-10-01',
        :version => '2010-10-01',
        :lists => {
          :seller_skus => "SellerSkus.member"
        },
        :mods => [
          lambda {|r| r.inventory_supply_list = [r.inventory_supply_list.member].flatten}
        ]

    end

  end
end
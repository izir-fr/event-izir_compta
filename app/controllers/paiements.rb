require_relative './../routes/api_mlab'
require_relative './../models/carts'

puts "Quel ets l'ID de l'événement ?"
event = gets.chomp.to_s

carts = Datas.get_carts_datas(event)

paiements = Array.new

carts.each do |cart|
  # puts cart
  if cart['paiement'].key?('stripe_id')
      formated_cart = Cart.new(cart['_id']['$oid'], cart['user']['$oid'], cart['paiement']['stripe_id'], event, cart['paiement']['amount'], cart['paiement']['captured'])
      cart['products'].each do |product|
        formated_cart.event_total(product['event']['$oid'], product['qty'], product['price'])
      end
      paiements << formated_cart
  end
  puts formated_cart.inspect
  puts "----------------"
end 

# puts paiements.inspect

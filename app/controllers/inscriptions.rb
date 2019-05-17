require_relative './../routes/api_stripe'
require_relative './../models/carts'
require_relative './../routes/api_mlab'

require "csv"

class Inscriptions

  def initialize
    @participants = 0
    @options = 0
    @total = 0
    @facturation = Array.new # contains only valide paiements
  end

  def facturation
    @facturation
  end

  def participants
    @participants
  end

  def options
    @options
  end

  def total
    @total    
  end

  def Paiement_check(carts, event)
    carts.each do |cart|
      # puts cart
      if cart['paiement'].key?('stripe_id')
          formated_cart = Cart.new(cart['_id']['$oid'], cart['user']['$oid'], cart['paiement']['stripe_id'], event, cart['paiement']['amount'], cart['paiement']['captured'])

          puts formated_cart

          cart['products'].each do |product|
            formated_cart.set_event_total(product['event']['$oid'], product['qty'], product['price'], product['race'])
          end

          if formated_cart != nil

            # validation de formated_cart avec stripe
            stripe_validation = Paiement.retreive_paiement(formated_cart.transaction_id)

            if stripe_validation == true
              formated_cart.set_user_email(Datas.get_user(formated_cart.user_id)["email"])
              @participants += formated_cart.nb_participants
              @options += formated_cart.nb_options
              @total += formated_cart.event_total.to_f
              @facturation << formated_cart.get_facturation_data
            end
          end

          puts "----------------"
      end
    end
  end

  def csv_export(event)
    puts "----------------"
    CSV.open("./data/#{event}.csv", "wb") do |csv|
      @facturation.each do |paiement|
        csv << ["cart_id", "user_email", "stripe_id", "event_total", "nb_participants", "event_id"]
        csv << paiement
      end
      puts "Check #{event}.csv"
    end
  end

  # public :paiements, :participants, :options

end



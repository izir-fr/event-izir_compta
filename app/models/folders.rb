require './app/models/cart.rb'
require './app/modules/paiement.rb'
require './app/modules/dataset.rb'

require "csv"

class Folders

  attr_accessor :facturation, :participants, :options, :total, :refounded

  def initialize
    @participants = 0
    @options = 0
    @total = 0
    @facturation = Array.new # contains only valide paiements
    @refounded = Array.new
  end

  def paiement_check(api_carts, event_id)

    api_carts.each do |cart|

      if cart['paiement'].key?('stripe_id')

        puts cart['_id']

        formated_cart = Cart.new(cart['_id']['$oid'], cart['user']['$oid'], cart['paiement']['stripe_id'], event_id, cart['paiement']['amount'], cart['paiement']['captured'])

        cart['products'].each do |product|

          formated_cart.set_event_total(product['event']['$oid'], product['qty'], product['price'], product['race'])

        end
        
        puts formated_cart

        if formated_cart != nil

          # validation de formated_cart avec stripe
          paiement_validation = Paiement.validation(formated_cart.stripe_id)

          if paiement_validation == true

            formated_cart.user_email = Dataset.get_user(formated_cart.user_id)["email"]

            @participants += formated_cart.nb_participants

            @options += formated_cart.nb_options

            @total += formated_cart.event_total.to_f

            @facturation << formated_cart.get_facturation_data

            puts "added in @facturation"

          else

            @refounded << formated_cart

          end

        else

          puts "error: #{cart}"

        end

        puts "----------------"
      end

    end

  end

  def export_in_csv(event_id)

    puts "----------------"

    CSV.open("./data/#{event_id}.csv", "wb") do |csv|

      @facturation.each do |paiement|

        csv << paiement # ["cart_id", "user_email", "stripe_id", "event_total", "nb_participants", "event_id"]

      end

      puts "Check #{event}.csv"

    end

  end

end



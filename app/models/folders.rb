require './app/models/cart.rb'
require './app/modules/paiement.rb'
require './app/modules/dataset.rb'

require "csv"

class Folders

  attr_accessor :facturation, :participants, :options, :total, :refounded, :error

  def initialize
    @participants = 0
    @options = 0
    @total = 0
    @facturation = Array.new # contains only valide paiements
    @refounded = Array.new
    @error = Array.new
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

          paiement_validation = Paiement.validation(formated_cart.stripe_id)
          
          # validation de formated_cart avec stripe
          if paiement_validation != false

            formated_cart.user_email = Dataset.get_user(formated_cart.user_id)["email"]

            @participants += formated_cart.nb_participants

            @options += formated_cart.nb_options

            if paiement_validation == true

              @total += formated_cart.event_total.to_f

              @facturation << formated_cart.get_facturation_data

              puts "added in @facturation"

            elsif paiement_validation.to_i > 0
              
              formated_cart.refounded_total(paiement_validation)

              @total += formated_cart.event_total.to_f

              @facturation << formated_cart.get_facturation_data

              @refounded << formated_cart

            end

          end

        else

          @error << cart

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

      puts "Check #{event_id}.csv"

    end

  end

end



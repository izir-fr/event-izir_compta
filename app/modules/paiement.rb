require 'stripe'

Stripe.api_key = ENV["STRIPE"]

module Paiement

  def Paiement.validation transaction_id

    begin

      retrieve =  Stripe::Charge.retrieve(transaction_id.to_s)

      if retrieve["captured"] == true && retrieve["refunded"] == false && retrieve["amount_refunded"] == 0
       
        puts "#{transaction_id} - status: OK, captured: #{retrieve["captured"]}, refund: #{retrieve["amount_refunded"]}€"
        
        true

      elsif retrieve["captured"].to_i > 0
        
        puts "#{transaction_id} - status: KO, captured: #{retrieve["captured"]}, refund: #{retrieve["amount_refunded"]}€"

        retrieve["amount_refunded"].to_i / 100

      else

        false

      end  

    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Charge ID is: #{err[:charge]}"
      # The following fields are optional
      puts "Code is: #{err[:code]}" if err[:code]
      puts "Decline code is: #{err[:decline_code]}" if err[:decline_code]
      puts "Param is: #{err[:param]}" if err[:param]
      puts "Message is: #{err[:message]}" if err[:message]
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
    rescue => e
      # Something else happened, completely unrelated to Stripe
    end

  end

end
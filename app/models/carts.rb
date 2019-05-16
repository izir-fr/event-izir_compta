class Cart

    def initialize (cart_id, user_id, stripe_id, event_id, amount, captured)
      @cart_id = cart_id
      @user_id = user_id
      @stripe_id = stripe_id
      @event_id = event_id
      @total = amount.to_f
      @captured = captured
      @event_total = 0
    end

    def event_total event, qty, price
      if @event_id.to_s == event.to_s
        total = qty * price
        puts "#{@cart_id} : #{qty} * #{price} = #{total}"
        @event_total += total
      end
    end

# "products"=>[{"team"=>false, "_id"=>{"$oid"=>"5cb496a5a6c2d000d26f7cc8"}, "ref"=>"5cacb9f244c4240050a08c51", "qty"=>1, "event"=>{"$oid"=>"5cacb79e44c4240050a08c4f"}, "name"=>"15 km pour Kaëlyss", "price"=>9, "race"=>true, "paiement_cb_required"=>false, "subtotal"=>9}]

end
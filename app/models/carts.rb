class Cart

  def initialize (cart_id, user_id, stripe_id, event_id, amount, captured)
    @cart_id = cart_id
    @user_id = user_id
    @stripe_id = stripe_id
    @event_id = event_id
    @total = amount.to_f
    @captured = captured
    @event_total = 0
    @nb_participants = 0
  end

  def event_total event, qty, price
    if @event_id.to_s == event.to_s
      total = qty * price
      # puts "#{@cart_id} : #{qty} * #{price} = #{total}"
      @event_total += total
      @nb_participants += qty
    end
  end

end
class Cart

  def initialize (cart_id, user_id, stripe_id, event_id, amount, captured)
    @cart_id = cart_id
    @user_id = user_id
    @user_email = nil
    @stripe_id = stripe_id
    @event_id = event_id
    @total = amount.to_f
    @captured = captured
    @event_total = 0
    @nb_participants = 0
    @nb_options = 0
  end

  def set_event_total event, qty, price, race
    if @event_id.to_s == event.to_s
      puts "#{price}"
      total = qty.to_i * price.to_f
      @event_total += total.to_f

      # puts "#{@cart_id} #{race}: #{qty} * #{price} = #{total}"

      if race == true
        @nb_participants += qty.to_i
      else
        @nb_options += qty.to_i
      end

    end
  end

  def nb_participants
    @nb_participants
  end

  def nb_options
    @nb_options
  end

  def transaction_id
    @stripe_id
  end

  def set_user_email email
    @user_email = email
  end

  def user_id
    @user_id
  end

  def event_total
    @event_total
  end

  def get_facturation_data
    [@cart_id, @user_email, @stripe_id, @event_total, @nb_participants, @event_id]
  end

  def total
    @total
  end

end
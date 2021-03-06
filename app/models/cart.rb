class Cart

  attr_accessor :nb_participants, :user_id, :user_email, :event_total, :total, :stripe_id, :nb_options

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

  def set_event_total event_id, qty, price, race

    if @event_id.to_s == event_id.to_s

      total = qty.to_i * price.to_f

      @event_total += total.to_f

      if race == true

        @nb_participants += qty.to_i

      else

        @nb_options += qty.to_i

      end

    end

  end

  def refounded_total amount_refound

    @total -= amount_refound.to_i

  end

  def get_facturation_data

    [@cart_id, @user_email, @stripe_id, @event_total, @nb_participants, @event_id, @nb_options]

  end

end
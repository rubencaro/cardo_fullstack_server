defmodule Cardo.Card do
  use Cardo.Xarango

  def get_one_card do
    run(:one, [%{}])
  end

  def destroy_card(card) do
    Cardo.Card.destroy(card)
  end

end



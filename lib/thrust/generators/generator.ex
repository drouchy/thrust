defmodule Generator do
  @callback distribute(Integer.t, Integer.t, Map.t) :: [Integer.t]
  @callback stream(Integer.t, Integer.t, Map.t) :: Stream.t
end
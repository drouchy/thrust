defmodule Generator do
  @callback distribute(integer(), integer(), Keyword) :: [integer()]
  @callback stream(integer(), integer(), Keyword) :: Stream.t
end
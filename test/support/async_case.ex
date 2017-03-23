defmodule Thrust.AsyncCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      def assert_eventually(check, timeout \\ 100, nb_retries \\ 10) do
        try do
          check.()
        rescue
          error in [ExUnit.AssertionError] ->
            case nb_retries do
              0 -> raise error
              _ -> 
                Process.sleep(timeout)
                assert_eventually(check, timeout, nb_retries - 1)
            end
        end
      end
    end
  end
end

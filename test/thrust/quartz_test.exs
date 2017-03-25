defmodule Thrust.QuartzTest do
  use ExUnit.Case, async: false

  alias Thrust.Quartz

  @timeout 110

  setup do
    {:ok, quartz} = Quartz.start_link(every: @timeout - 10, name: :quartz_test)
    on_exit fn ->
      Process.exit(quartz, :normal)
      Quartz.stop(:ping)
      case Process.whereis(:quartz) do
        nil -> :ok
        pid -> Process.exit(pid, :normal)
      end
    end

    {:ok, quartz: quartz}
  end

  #start/4
  test "starting a new timer returns :ok", %{quartz: quartz} do
    :ok = Quartz.start(quartz, :timer1, fn -> :ok end, [])
  end

  test "the started timer is persisted in the agent", %{quartz: quartz} do
    :ok = Quartz.start(quartz, :timer2, fn -> :ok end, [])
    {:interval, ref} = Agent.get(quartz, fn (state) -> get_in(state, [:timers, :timer2]) end)

    reference =  :ets.tab2list(:timer_tab) |> Enum.find(fn ({{_, r}, _, _}) -> r == ref end)

    assert reference != nil
  end

  test "executes the function every second", %{quartz: quartz} do
    this = self()
    :ok = Quartz.start(quartz, :timer3, fn -> send(this, :ok) end, [])

    assert_receive :ok, @timeout
    assert_receive :ok, @timeout
  end

  test "starting an existing time results :already_exist", %{quartz: quartz} do
    :ok            = Quartz.start(quartz, :timer4, fn -> :ok end, [])
    :already_exist = Quartz.start(quartz, :timer4, fn -> :ok end, [])
  end

  # stop/2
  test "stoping a timer stops the process", %{quartz: quartz} do
    this = self()
    Quartz.start(quartz, :timer5, fn -> send(this, :done) end, [])

    assert_receive :done, @timeout
    Quartz.stop(quartz, :timer5)
    refute_receive :done, @timeout
  end

  test "stopping a non existant timer returns :not_found", %{quartz: quartz} do
    :not_found = Quartz.stop(quartz, :foo)
  end

  # start/3
  test "starts the scheduler for the supervise agent in the application" do
    this = self()
    :ok = Quartz.start(:ping, fn -> send(this, :done) end)
    assert_receive :done, 3_000
  end

  test "starts the scheduler, and can customise the every parameter" do
    this = self()
    :ok = Quartz.start(:ping, fn -> send(this, :done) end, every: 2_000)
    refute_receive :done, 1_000
  end

  # stop/2
  test "stops the scheduler for the supervise agent in the application" do
    this = self()
    Quartz.start(:ping, fn -> send(this, :done) end)
    assert_receive :done, 3_000

    Quartz.stop(:ping)
    refute_receive :done, 1_000
  end
end
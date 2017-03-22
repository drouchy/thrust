defmodule Thrust.QuartzTest do
  use ExUnit.Case, async: true

  alias Thrust.Quartz

  setup do
    {:ok, quartz} = Quartz.start_link(every: 100)
    {:ok, quartz: quartz}
  end

  # start/3
  test "starting a new timer returns :ok", %{quartz: quartz} do
    :ok = Quartz.start(quartz, :timer1, fn -> :ok end)
  end

  test "the started timer is persisted in the agent", %{quartz: quartz} do
    :ok = Quartz.start(quartz, :timer2, fn -> :ok end)
    ref = Agent.get(quartz, fn (state) -> Map.get(state, :timers) |> Map.get(:timer2) end)

    assert Process.alive?(ref)
  end

  test "executes the function every second", %{quartz: quartz} do
    this = self()
    :ok = Quartz.start(quartz, :timer3, fn -> send(this, :ok) end)

    assert_receive :ok, 110
    assert_receive :ok, 110
  end

  test "starting an existing time results :already_exist", %{quartz: quartz} do
    :ok            = Quartz.start(quartz, :timer4, fn -> :ok end)
    :already_exist = Quartz.start(quartz, :timer4, fn -> :ok end)
  end

  # stop/2
  test "stoping a timer stops the process", %{quartz: quartz} do
    this = self()
    Quartz.start(quartz, :timer5, fn -> send(this, :done) end)

    assert_receive :done, 110
    Quartz.stop(quartz, :timer5)
    refute_receive :done, 110
  end

  test "stopping a non existant timer returns :not_found", %{quartz: quartz} do
    :not_found = Quartz.stop(quartz, :foo)
  end
end
defmodule Thrust.Supervisors.SchedulerSupervisorTest do
  use Thrust.AsyncCase

  test "starts the timer agent" do
    pid = Process.whereis(:quartz)

    assert pid != nil
  end

  test "restarts the timer when crashes" do
    pid = Process.whereis(:quartz)
    Process.exit(pid, :kill)
    
    assert_eventually fn -> 
      new_pid = Process.whereis(:quartz)
      assert new_pid != nil
      assert new_pid != pid
    end
  end  
end
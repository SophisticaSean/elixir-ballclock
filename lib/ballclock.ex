defmodule Ballclock do

  def agent_init(count) do
    queue = Agent.start_link(fn -> Enum.to_list(1..count) end) # n initial balls
    queue = elem(queue, 1)
    minute = Agent.start_link(fn -> [] end) # 4 balls
    minute = elem(minute, 1)
    five_minute = Agent.start_link(fn -> [] end) # 11 balls
    five_minute = elem(five_minute, 1)
    hours = Agent.start_link(fn -> [] end) # 11 balls, but needs to be from 1-12, not 0-11
    hours = elem(hours, 1)
    %{queue: queue, minute: minute, five_minute: five_minute, hours: hours}
  end

  def increment(agentlist) do
    queue = Agent.get(Map.get(agentlist, :queue), fn list -> list end)
    ball = hd(queue)
    Agent.update(Map.get(agentlist, :queue), fn list -> tl(list) end)

    agent_plus(Map.get(agentlist, :minute), :minute, ball, agentlist)
  end

  def agent_plus(agent, agent_name, item, agent_list) do
    list = get_state(agent_name, agent_list)
    list_count = Enum.count(list)
    queue = Map.get(agent_list, :queue)
    next_agent_name = nil
    max = nil
    case agent_name do
      :minute ->
        next_agent_name = :five_minute
        max = 4
      :five_minute ->
        next_agent_name = :hours
        max = 11
      :hours ->
        next_agent_name = :queue
        max = 11
    end
    cond do
      list_count >= max ->
        # add current agent's list back to the queue
        Agent.update(queue, fn arr -> arr ++ list end)
        # IO.inspect(Agent.get(queue, fn list -> list end))
        # clear current agent's list
        Agent.update(agent, fn list -> [] end)
        # add current ball (item) to next_agent
        unless next_agent_name == :queue do
          next_agent = Map.get(agent_list, next_agent_name)
          agent_plus(next_agent, next_agent_name, item, agent_list)
        else
          Agent.update(queue, fn arr -> arr ++ [item] end)
        end
      true ->
        Agent.update(agent, fn list -> [item] ++ list end)
    end
  end

  def go_until_initial_order(list) do
    initial_state = get_state(:queue, list)
    Ballclock.increment(list)
    go_until_initial_order(list, initial_state, 0)
  end

  def go_until_initial_order(list, initial_state, count) do
    current_state = get_state(:queue, list)
    done = initial_state == current_state
    count = count + 1
    case done do
      false ->
        Ballclock.increment(list)
        go_until_initial_order(list, initial_state, count)

      _ ->
        total_days = ((count/24)/60)
        ball_count = Enum.count(initial_state)
        IO.puts('yay done #{total_days} ball count: #{ball_count}')
    end
  end

  def get_state(process_name, list) do
    Agent.get(Map.get(list, process_name), fn list -> list end)
  end

  def increment(agentlist, amount) do
    if amount > 0 do
      increment(agentlist)
      amount = amount - 1
      increment(agentlist, amount)
    else
      IO.puts('all done')
    end
  end

  def hour_run(list, runs \\ 1) do
    increment(list, runs*720)
  end

  def permutation_vector(list) do
    pristine = get_state(:queue, list)
    hour_run(list)
    queue = get_state(:queue, list)

    instructions = Enum.map(pristine, fn(x) ->
      Enum.find_index(queue, fn(y) -> x == y end)
    end)
    IO.inspect(List.to_tuple(instructions))
    IO.inspect(List.to_tuple(pristine))
    IO.inspect(List.to_tuple(queue))
    instructions
  end
  # agentMap = Enum.map(Enum.to_list(1..10), fn(x) -> {:ok, ragent} = Agent.start_link(fn -> [] end); ragent end)
end

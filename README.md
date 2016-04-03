# Ballclock

ballclock simulation in elixir

# Usage

Pull the repo then do the following

`iex -S mix`

then in iex do:

`list = Ballclock.agent_init(x); Ballclock.go_until_initial_order(list)`

where x is the amount of balls you want to start the simulation with
it will exit when its done with how many days it takes before the similation
is back to its initial state (1..x) and what the ball count was

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ballclock to your list of dependencies in `mix.exs`:

        def deps do
          [{:ballclock, "~> 0.0.1"}]
        end

  2. Ensure ballclock is started before your application:

        def application do
          [applications: [:ballclock]]
        end


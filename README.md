# Ballclock

[ballclock simulation](http://www.chilton.com/~jimw/ballclk.html) in elixir

# Usage

Pull the repo then do the following

`iex -S mix`

then in iex do:

`list = Ballclock.agent_init(x); Ballclock.go_until_initial_order(list)`

where x is the amount of balls you want to start the simulation with
it will exit when its done with how many days it takes before the similation
is back to its initial state (1..x) and what the ball count was

# cheating

To use the provided permutation method (simulates 12 hour cycle, performs 12 hour cycle transformation until pristine)
do this:
`Ballclock.agent_init(123); Ballclock.permute_until_pristine(list)`

# TODO

Upon some inspection, as 123 balls runs in about 30 seconds (permutations) or 50 minutes (full sim) which is super slow, it looks
like some performance can be gained by not yusing Agents as agents seem to operate orders of magnitude slower than keeping the state within one monolithic function. Will end up exploring this non-idiomatic style of solution later.

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


inspect_limit = 5_000
history_size = 1000

eval_result = [:green, :bright]
eval_error = [:red, :bright]
eval_info = [:blue, :bright]

# Configuring IEx
IEx.configure [
  inspect: [limit: inspect_limit],
  history_size: history_size,
  colors: [
    eval_result: eval_result,
    eval_error: eval_error,
    eval_info: eval_info,
  ]
]

# Helper functions
defmodule H do
  def c do
    IEx.Helpers.continue()
  end

  def w do
    IEx.Helpers.whereami()
  end

  @doc """
  Start debugger and load up all the solve modules so that the debugger allows stepping into any
  solve module code
  """
  def debug(load_all_solve_modules \\ true) do
    {:ok, _} = :debugger.start()
    if load_all_solve_modules do
      Enum.each(solve_modules(), &:int.ni/1)
    end
  end

  @doc """
  Set a breakpoint, loading the module if needed (works on Solve modules and mix dependencies, but
  not Elixir standard library modules)
  """
  def break(module, line_number) do
    :int.ni(module)
    :int.break(module, line_number)
  end

  def solve_apps do
    Mix.Project.apps_paths
    |> Map.keys()
  end

  def solve_modules do
    solve_apps()
    |> Enum.flat_map(fn app_atom ->
      {:ok, list} = :application.get_key(app_atom, :modules)
      list |> Enum.filter(&is_solve_module/1)
    end)
  end

  def is_solve_module(module) do
    module
    |> Module.split
    |> Enum.take(1) == ["Solve"]
  end
end

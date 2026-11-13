defmodule AlgorithmsForOptimization.SimpleBracketing do
  def bracket_minimum(
        function,
        initial_x_value \\ 0,
        step_length \\ 1 * 10 ** -2,
        expansion_factor \\ 2
      ) do
    a_value = initial_x_value
    returned_a_value = function.(a_value)
    b_value = a_value + step_length
    returned_b_value = function.(b_value)

    {a_value, _returned_a_value, b_value, returned_b_value, step_length} =
      if returned_b_value > returned_a_value do
        {b_value, returned_b_value, a_value, returned_a_value, -step_length}
      else
        {a_value, returned_a_value, b_value, returned_b_value, step_length}
      end

    find_new_values(function, a_value, b_value, returned_b_value, step_length, expansion_factor)
  end

  def find_new_values(function, a_value, b_value, returned_b_value, step_length, expansion) do
    c_value = b_value + step_length
    returned_c_value = function.(c_value)

    if(returned_c_value > returned_b_value) do
      if a_value < c_value, do: {a_value, c_value}, else: {c_value, a_value}
    else
      find_new_values(
        function,
        b_value,
        c_value,
        returned_c_value,
        step_length * expansion,
        expansion
      )
    end
  end
end

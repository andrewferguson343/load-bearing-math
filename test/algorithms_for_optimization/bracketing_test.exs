defmodule AlgorithmsForOptimization.BracketingTest do
  use ExUnit.Case, async: true
  alias AlgorithmsForOptimization.Bracketing

  describe "bracket_minimum/4" do
    test "Brackets a simple parabola" do
      f = fn x -> (x-2) **2 end
      {left_bracket, right_bracket} = Bracketing.bracket_minimum(f, 0)

      assert left_bracket < 2
      assert right_bracket > 2
    end

    test "Swaps directions to find the minimum" do
      f = fn x -> (x-2) **2 end
      {left_bracket, right_bracket} = Bracketing.bracket_minimum(f, 5)

      assert left_bracket < 2
      assert right_bracket > 2
    end

    test "Handles multiple iterations to fund the minmum" do
      f = fn x -> (x-2) **2 end
      {left_bracket, right_bracket} = Bracketing.bracket_minimum(f, -500)

      assert left_bracket < 2
      assert right_bracket > 2
    end
  end
end

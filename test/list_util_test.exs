defmodule ListUtilTest do

  use ExUnit.Case
  import ListUtil


  test "split can split a list at a given position" do
    list = [1,2,3,4]
    assert split(list, 0)  == {[], [1,2,3,4]}
    assert split(list, 1)  == {[1], [2,3,4]}
    assert split(list, 2) == {[1,2], [3,4]}
    assert split(list, 3) == {[1,2,3], [4]}
    assert split(list, 4) == {[1,2,3,4], []}

  end

end

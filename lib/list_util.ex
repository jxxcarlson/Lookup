defmodule ListUtil do


    # Clause 1
    def split(in_list, count) when count > 0 do
      # FIRST STAGE
      [head | tail] = in_list

      # RECURSION
      result = split(tail, count - 1)

      # SECOND STAGE
      {left, right} = result
      return = {[head | left], right}
    end

    #Clause 2
    def split(list, _count), do: return = {[], list}

    def cut(list, n) do
      {a, b} = split(list, n)
      b ++ a
    end

    def random_split(list) do
      n = :rand.uniform(length(list)-1)
      split(list,n)
    end

    def random_cut(list) do
      {a,b} = random_split(list)
      b ++ a
    end

    def mcut(list) do
      n = length(list)
      c1 = div(n,2)
      c2 = div(n,3)
      c3 = div(n,4)
      list
      |> random_cut
      |> cut(c1)
      |> random_cut
      |> cut(c2)
      |> random_cut
      |> cut(c3)
    end

    def mmcut(list, n)
      when length(list) <= n, do: list

    def proj1(x) do
      elem(x,0)
    end

    def mmcut(list, n)
      when length(list) > n, do: mcut(list)
        |> split(n)
        |> proj1


end
import Std.Data.List.Basic

def lagmulx (c : List Float) : List Float :=
  if c.isEmpty then []
  else
    let n := c.length
    let result := List.replicate (n + 1) 0.0
    -- Apply the recursion relationship for each coefficient
    let rec processCoeff (i : Nat) (ci : Float) (acc : List Float) : List Float :=
      if i >= n then acc
      else
        let acc := if i > 0 then 
          acc.set! (i - 1) (acc.get! (i - 1) - (i : Float) * ci)
        else acc
        let acc := acc.set! i (acc.get! i + (2 * (i : Float) + 1) * ci)
        let acc := acc.set! (i + 1) (acc.get! (i + 1) - ((i : Float) + 1) * ci)
        acc
    c.enum.foldl (fun acc (i, ci) => processCoeff i ci acc) result

-- Test with the example from NumPy documentation
#eval lagmulx [1.0, 2.0, 3.0]
-- Expected: [-1.0, -1.0, 11.0, -9.0]
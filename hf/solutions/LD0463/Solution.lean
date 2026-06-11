def distinct (nums : Array Int) : Prop :=
∀ i j, 0 ≤ i → i < j → j < nums.size → nums[i]! ≠ nums[j]!

def containsDuplicate (nums : Array Int) : Bool :=
  nums.allDiff
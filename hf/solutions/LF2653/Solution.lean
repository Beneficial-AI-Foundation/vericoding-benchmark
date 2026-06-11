def inverse_slice {α : Type} (items : List α) (a : Nat) (b : Nat) : List α :=
  let before := items.take a
  let after := items.drop b
  before ++ after
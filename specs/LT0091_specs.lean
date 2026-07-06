-- <vc-preamble>
import Std.Do.Triple
import Std.Tactic.Do
open Std.Do
-- </vc-preamble>

-- <vc-helpers>
-- </vc-helpers>

-- <vc-definitions>
def numpy_unpackbits {n : Nat} (a : Vector Nat n) : Id (Vector Nat (n * 8)) :=
  sorry
-- </vc-definitions>

-- <vc-theorems>
theorem numpy_unpackbits_spec {n : Nat} (a : Vector Nat n) 
    (h_uint8 : ∀ i : Fin n, a.get i < 256) :
    ⦃⌜∀ i : Fin n, a.get i < 256⌝⦄
    numpy_unpackbits a
    ⦃⇓result => ⌜∀ i : Fin n, ∀ j : Fin 8,
                  result.get ⟨i.val * 8 + j.val, by
                        calc
                          i.val * 8 + j.val < i.val * 8 + 8 := by
                            exact Nat.add_lt_add_left j.isLt _
                          _ = (i.val + 1) * 8 := by
                            rw [Nat.succ_mul]
                          _ ≤ n * 8 := by
                            exact Nat.mul_le_mul_right _ i.isLt⟩ = 
                  (a.get i / (2 ^ (7 - j.val))) % 2⌝⦄ := by
  sorry
-- </vc-theorems>
-- <vc-preamble>
import Std.Do.Triple
import Std.Tactic.Do
open Std.Do
-- </vc-preamble>

-- <vc-helpers>
-- </vc-helpers>

-- <vc-definitions>
def fftshift {n : Nat} (x : Vector Float n) : Id (Vector Float n) :=
  sorry
-- </vc-definitions>

-- <vc-theorems>
theorem fftshift_spec {n : Nat} (x : Vector Float n) :
    ⦃⌜True⌝⦄
    fftshift x
    ⦃⇓result => ⌜∀ i : Fin n, result.get i = x.get ⟨(i.val + n - n / 2) % n, by
          have hn_ne : n ≠ 0 := by
            intro hn
            cases hn
            exact Nat.not_lt_zero _ i.isLt
          exact Nat.mod_lt _ (Nat.pos_of_ne_zero hn_ne)⟩ ∧
                  (∀ j : Fin n, ∃ k : Fin n, result.get k = x.get j) ∧
                  (∀ val : Float, (∃ j : Fin n, x.get j = val) ↔ (∃ k : Fin n, result.get k = val))⌝⦄ := by
  sorry
-- </vc-theorems>
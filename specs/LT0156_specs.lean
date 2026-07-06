-- <vc-preamble>
import Std.Do.Triple
import Std.Tactic.Do
open Std.Do
-- </vc-preamble>

-- <vc-helpers>
-- </vc-helpers>

-- <vc-definitions>
def ifftshift {n : Nat} (x : Vector Float n) : Id (Vector Float n) :=
  sorry
-- </vc-definitions>

-- <vc-theorems>
theorem ifftshift_spec {n : Nat} (x : Vector Float n) :
    ⦃⌜True⌝⦄
    ifftshift x
    ⦃⇓result => ⌜∀ i : Fin n, result.get i = x.get ⟨(i.val + n / 2) % n, by
          have hn_ne : n ≠ 0 := by
            intro hn
            cases hn
            exact Nat.not_lt_zero _ i.isLt
          exact Nat.mod_lt _ (Nat.pos_of_ne_zero hn_ne)⟩⌝⦄ := by
  sorry
-- </vc-theorems>
-- <vc-preamble>
import Std.Do.Triple
import Std.Tactic.Do
open Std.Do
-- </vc-preamble>

-- <vc-helpers>
-- </vc-helpers>

-- <vc-definitions>
def legvander3d {n : Nat} (x y z : Vector Float n) (deg_x deg_y deg_z : Nat) : 
    Id (Vector (Vector Float ((deg_x + 1) * (deg_y + 1) * (deg_z + 1))) n) :=
  sorry
-- </vc-definitions>

-- <vc-theorems>
theorem legvander3d_spec {n : Nat} (x y z : Vector Float n) (deg_x deg_y deg_z : Nat) :
    ⦃⌜True⌝⦄
    legvander3d x y z deg_x deg_y deg_z
    ⦃⇓result => ⌜
      -- Matrix has correct dimensions
      (∀ i : Fin n, ∀ j : Fin ((deg_x + 1) * (deg_y + 1) * (deg_z + 1)), 
        ∃ val : Float, (result.get i).get j = val) ∧
      -- First column corresponds to L_0(x) * L_0(y) * L_0(z) = 1 * 1 * 1 = 1
      (∀ i : Fin n, (result.get i).get ⟨0, by exact Nat.mul_pos (Nat.mul_pos (Nat.succ_pos _) (Nat.succ_pos _)) (Nat.succ_pos _)⟩ = 1) ∧
      -- Entries are products of Legendre polynomial evaluations
      (∀ i : Fin n, ∀ p : Fin (deg_x + 1), ∀ q : Fin (deg_y + 1), ∀ r : Fin (deg_z + 1), 
        let col_idx := (deg_y + 1) * (deg_z + 1) * p.val + (deg_z + 1) * q.val + r.val
        col_idx < (deg_x + 1) * (deg_y + 1) * (deg_z + 1) →
        ∃ L_p_x L_q_y L_r_z : Float, 
          (result.get i).get ⟨col_idx, by
            have h_qr : (deg_z + 1) * q.val + r.val < (deg_y + 1) * (deg_z + 1) := by
              calc
                (deg_z + 1) * q.val + r.val < (deg_z + 1) * q.val + (deg_z + 1) := by
                  exact Nat.add_lt_add_left r.isLt _
                _ = q.val * (deg_z + 1) + (deg_z + 1) := by
                  rw [Nat.mul_comm (deg_z + 1) q.val]
                _ = (q.val + 1) * (deg_z + 1) := by
                  rw [Nat.succ_mul]
                _ ≤ (deg_y + 1) * (deg_z + 1) := by
                  exact Nat.mul_le_mul_right _ q.isLt
            calc
              col_idx = ((deg_y + 1) * (deg_z + 1)) * p.val + ((deg_z + 1) * q.val + r.val) := by
                dsimp [col_idx]
                rw [Nat.add_assoc]
              _ < ((deg_y + 1) * (deg_z + 1)) * p.val + ((deg_y + 1) * (deg_z + 1)) := by
                exact Nat.add_lt_add_left h_qr _
              _ = ((deg_y + 1) * (deg_z + 1)) * (p.val + 1) := by
                rw [← Nat.mul_succ]
              _ ≤ ((deg_y + 1) * (deg_z + 1)) * (deg_x + 1) := by
                exact Nat.mul_le_mul_left _ p.isLt
              _ = (deg_x + 1) * ((deg_y + 1) * (deg_z + 1)) := by
                rw [Nat.mul_comm]
              _ = (deg_x + 1) * (deg_y + 1) * (deg_z + 1) := by
                rw [Nat.mul_assoc]⟩ = L_p_x * L_q_y * L_r_z)
    ⌝⦄ := by
  sorry
-- </vc-theorems>
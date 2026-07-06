-- <vc-preamble>
-- </vc-preamble>

-- <vc-helpers>
-- </vc-helpers>

-- <vc-definitions>
def diag {n : Nat} (matrix : Vector Float (n * n)) : Vector Float n :=
  sorry
-- </vc-definitions>

-- <vc-theorems>
theorem diag_spec {n : Nat} (matrix : Vector Float (n * n)) : 
    ∀ i : Fin n, (diag matrix).get i = matrix.get ⟨i.val * n + i.val, by
      calc
        i.val * n + i.val < i.val * n + n := by
          exact Nat.add_lt_add_left i.isLt _
        _ = (i.val + 1) * n := by
          rw [Nat.succ_mul]
        _ ≤ n * n := by
          exact Nat.mul_le_mul_right _ i.isLt⟩ := by
  sorry
-- </vc-theorems>
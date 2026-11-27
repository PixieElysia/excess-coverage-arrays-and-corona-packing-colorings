import CycleMetric

namespace CoronaUpper

/-- The edges of the cycle corona: every column is a triangle; only its
hub (role zero) meets the hubs of the neighboring columns. -/
def CycleEdge (n i j : Nat) (r s : Fin 3) : Prop :=
  (i=j ∧ r≠s) ∨
  (r.val=0 ∧ s.val=0 ∧
    (i+1=j ∨ j+1=i ∨ (i=0 ∧ j+1=n) ∨ (j=0 ∧ i+1=n)))

theorem height_le_one (r : Fin 3) : height r ≤ 1 := by
  unfold height
  split <;> decide

/-- Distance to a fixed target changes by at most one across any edge. -/
theorem cycle_edge_bound {n i j z : Nat} {r s t : Fin 3}
    (hi : i<n) (hj : j<n) (hz : z<n) (edge : CycleEdge n i j r s) :
    cycleDistance n i z r t ≤ cycleDistance n j z s t + 1 := by
  rcases edge with ⟨eq, _⟩ | ⟨hr, hs, cases⟩
  · subst j
    by_cases e : i=z
    · simp only [cycleDistance, e, if_true]
      split <;> split <;> omega
    · have hr := height_le_one r
      simp only [cycleDistance, if_neg e]
      omega
  · have bound : min (gap i z) (n-gap i z) ≤ min (gap j z) (n-gap j z) + 1 := by
      unfold gap
      rcases cases with a | a | ⟨a,b⟩ | ⟨a,b⟩ <;> omega
    have zr : height r = 0 := by simp [height, hr]
    have zs : height s = 0 := by simp [height, hs]
    by_cases iz : i=z
    · simp only [cycleDistance, if_pos iz]
      split <;> omega
    · by_cases jz : j=z
      · subst z
        have gj : gap j j = 0 := by simp [gap]
        rw [gj] at bound
        simp at bound
        simp only [cycleDistance, if_neg iz, if_pos rfl, zr, Nat.add_zero]
        by_cases st : s=t
        · subst t
          simp only [if_pos rfl, zs, Nat.add_zero]
          omega
        · simp [st]
          have ht := height_le_one t
          omega
      · simp only [cycleDistance, if_neg iz, if_neg jz, zr, zs, Nat.add_zero]
        omega

/-- An actual edge walk with fixed final vertex and explicit length. -/
inductive CycleWalk (n z : Nat) (t : Fin 3) : Nat → Fin 3 → Nat → Prop
  | stop (hz : z<n) : CycleWalk n z t z t 0
  | step {i j l : Nat} {r s : Fin 3} (hi : i<n)
      (edge : CycleEdge n i j r s) (rest : CycleWalk n z t j s l) :
      CycleWalk n z t i r (l+1)

theorem walk_starts_in_cycle {n z i l : Nat} {t r : Fin 3}
    (w : CycleWalk n z t i r l) : i<n := by
  cases w with
  | stop hz => exact hz
  | step hi _ _ => exact hi

theorem walk_length_bound {n z i l : Nat} {t r : Fin 3}
    (w : CycleWalk n z t i r l) : z<n ∧ cycleDistance n i z r t ≤ l := by
  induction w with
  | stop hz => simp [hz, cycleDistance]
  | step hi e rest ih =>
    have h := cycle_edge_bound (t := t) hi (walk_starts_in_cycle rest) ih.1 e
    exact ⟨ih.1, by omega⟩

/-- Vertices with the same color are joined by no edge walk of length at
most that color. This conclusion refers directly to triangle and hub edges. -/
theorem no_short_cycle_walk {n k : Nat} {f : Nat → Fin 3 → Nat}
    (hc : Packing n k f (cycleDistance n)) {i j l : Nat} {r s : Fin 3}
    (distinct : i≠j ∨ r≠s) (same : f i r=f j s) (walk : CycleWalk n j s i r l) :
    f i r < l := by
  have h := walk_length_bound walk
  have p := hc.2 i j r s (walk_starts_in_cycle walk) h.1 distinct same
  omega

end CoronaUpper

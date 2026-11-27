import Std

namespace CoronaUpper

def height (r : Fin 3) : Nat := if r.val = 0 then 0 else 1

def advance (n i d : Nat) : Nat := if i+d < n then i+d else i+d-n

/-- Distinct colors within a triangle, and the packing tests in each
positive cyclic direction up to k columns away. -/
def Local (n k : Nat) (f : Nat → Fin 3 → Nat) : Prop :=
  (∀ (i : Nat) (r : Fin 3), i<n → 1 ≤ f i r ∧ f i r ≤ k) ∧
  (∀ (i : Nat) (r s : Fin 3), i<n → r≠s → f i r ≠ f i s) ∧
  (∀ (i d : Nat) (r s : Fin 3), i<n → 0<d → d≤k →
      f i r = f (advance n i d) s → f i r < d + height r + height s)

/-- The absolute separation of two column indices. -/
def gap (i j : Nat) : Nat := (i-j)+(j-i)

/-- Distance between specified vertices in the cycle corona. The three
roles are center, first satellite, second satellite. -/
def cycleDistance (n i j : Nat) (r s : Fin 3) : Nat :=
  if i=j then (if r=s then 0 else 1)
  else min (gap i j) (n-gap i j) + height r + height s

/-- Distance between the same vertex roles on the path corona. -/
def pathDistance (i j : Nat) (r s : Fin 3) : Nat :=
  if i=j then (if r=s then 0 else 1)
  else gap i j + height r + height s

/-- Packing coloring on all vertices using the stated graph distance. -/
def Packing (n k : Nat) (f : Nat → Fin 3 → Nat)
    (dist : Nat → Nat → Fin 3 → Fin 3 → Nat) : Prop :=
  (∀ i r, i<n → 1 ≤ f i r ∧ f i r ≤ k) ∧
  (∀ i j r s, i<n → j<n → (i≠j ∨ r≠s) → f i r=f j s → f i r < dist i j r s)

theorem cycleDistance_comm (n i j : Nat) (r s : Fin 3) :
    cycleDistance n i j r s = cycleDistance n j i s r := by
  simp only [cycleDistance, gap, Nat.add_comm (i-j) (j-i)]
  by_cases hi : i=j
  · subst j
    by_cases hr : r=s <;> simp_all [Ne.symm, eq_comm]
  · simp only [if_neg hi, if_neg (Ne.symm hi)]
    omega

private theorem ordered_packing {n k : Nat} {f : Nat → Fin 3 → Nat}
    (loc : Local n k f) (i j : Nat) (r s : Fin 3) (hij : i<j) (hj : j<n)
    (same : f i r = f j s) : f i r < cycleDistance n i j r s := by
  obtain ⟨bounds, _, check⟩ := loc
  have hi : i<n := by omega
  have hb := (bounds i r hi).2
  have fwd : f i r < (j-i) + height r + height s := by
    by_cases h : j-i ≤ k
    · have adv : advance n i (j-i) = j := by unfold advance; split <;> omega
      exact check i (j-i) r s hi (by omega) h (by rw [adv]; exact same)
    · omega
  have back : f i r < (n-(j-i)) + height r + height s := by
    by_cases h : n-(j-i) ≤ k
    · have adv : advance n j (n-(j-i)) = i := by unfold advance; split <;> omega
      have back := check j (n-(j-i)) s r hj (by omega) h (by rw [adv]; exact same.symm)
      omega
    · omega
  simp only [cycleDistance, if_neg (Nat.ne_of_lt hij), gap,
    Nat.sub_eq_zero_of_le (Nat.le_of_lt hij), Nat.zero_add]
  omega

/-- The local finite-window checks imply every global same-color pair
satisfies the packing inequality on the cycle. -/
theorem local_to_cyclePacking {n k : Nat} {f : Nat → Fin 3 → Nat}
    (loc : Local n k f) : Packing n k f (cycleDistance n) := by
  refine ⟨loc.1, ?_⟩
  intro i j r s hi hj distinct same
  by_cases hij : i=j
  · subst j
    exact False.elim ((loc.2.1 i r s hi (by simpa using distinct)) same)
  · by_cases lt : i<j
    · exact ordered_packing loc i j r s lt hj same
    · rw [cycleDistance_comm, same]
      exact ordered_packing loc j i s r (by omega) hi same.symm

/-- Restrict a packing coloring of a cycle of length n to a path prefix
of length m. Deleting the other columns and the closing edge can only
increase the distance of a surviving pair. -/
theorem cycle_to_pathPacking {m n k : Nat} {f : Nat → Fin 3 → Nat}
    (hm : m≤n) (hc : Packing n k f (cycleDistance n)) :
    Packing m k f pathDistance := by
  refine ⟨fun i r hi => hc.1 i r (by omega), ?_⟩
  intro i j r s hi hj distinct same
  have h := hc.2 i j r s (by omega) (by omega) distinct same
  simp only [cycleDistance] at h
  simp only [pathDistance]
  by_cases eq : i=j <;> simp only [eq, if_true, if_false] at * <;> omega

end CoronaUpper

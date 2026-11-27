import Attainment
import ExactColors

namespace CoronaUpper

/-- The ordinary packing-coloring condition, expressed using walks along
    graph edges. The parameters of the relation are the two column indices,
    their vertex roles, and the walk length. -/
def WalkPacking (n k : Nat) (f : Nat → Fin 3 → Nat)
    (walk : Nat → Nat → Fin 3 → Fin 3 → Nat → Prop) : Prop :=
  (∀ i r, i<n → 1 ≤ f i r ∧ f i r ≤ k) ∧
  (∀ i j r s l, i<n → j<n → (i≠j ∨ r≠s) → f i r=f j s →
      walk i j r s l → f i r < l)

def ExactWalkPacking (n k : Nat)
    (walk : Nat → Nat → Fin 3 → Fin 3 → Nat → Prop) : Prop :=
  (∃ f, WalkPacking n k f walk) ∧
  ∀ l f, WalkPacking n l f walk → k ≤ l

private theorem exact_walk_of_distance {n k : Nat}
    {dist : Nat → Nat → Fin 3 → Fin 3 → Nat}
    {walk : Nat → Nat → Fin 3 → Fin 3 → Nat → Prop}
    (attains : ∀ i j r s, i<n → j<n → walk i j r s (dist i j r s))
    (bound : ∀ i j r s l, walk i j r s l → dist i j r s ≤ l)
    (exact_metric : ExactPacking n k dist) : ExactWalkPacking n k walk := by
  constructor
  · obtain ⟨f, hf⟩ := exact_metric.1
    refine ⟨f, hf.1, ?_⟩
    intro i j r s l hi hj distinct same path
    exact Nat.lt_of_lt_of_le (hf.2 i j r s hi hj distinct same) (bound i j r s l path)
  · intro l f hf
    apply exact_metric.2 l f
    refine ⟨hf.1, ?_⟩
    intro i j r s hi hj distinct same
    exact hf.2 i j r s _ hi hj distinct same (attains i j r s hi hj)

/-- The precise path-corona packing number directly from the graph edges. -/
theorem path_exact_on_edges {n : Nat} (hn : 12 ≤ n) :
    ExactWalkPacking n 7 (fun i j r s l => PathWalk n j s i r l) :=
  exact_walk_of_distance
    (fun i j r s hi hj => path_distance_attained n i j hi hj r s)
    (fun _ _ _ _ _ w => (path_walk_bounds w).2.2)
    (path_exact hn)

/-- The precise cycle-corona packing number directly from the graph edges. -/
theorem cycle_exact_on_edges {n : Nat} (hn : 12 ≤ n) :
    ExactWalkPacking n (if n = 13 then 8 else 7) (fun i j r s l => CycleWalk n j s i r l) :=
  exact_walk_of_distance
    (fun i j r s hi hj => cycle_distance_attained n i j hi hj r s)
    (fun _ _ _ _ _ w => (walk_length_bound w).2)
    (cycle_exact hn)

#print axioms path_exact_on_edges
#print axioms cycle_exact_on_edges

end CoronaUpper

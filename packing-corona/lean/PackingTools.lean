import CycleMetric

namespace CoronaUpper

/-- A larger palette allows all colorings on a smaller palette. -/
theorem enlarge_palette {f : Nat → Fin 3 → Nat} {n k l : Nat}
    {dist : Nat → Nat → Fin 3 → Fin 3 → Nat} (hk : k ≤ l)
    (h : Packing n k f dist) : Packing n l f dist :=
  ⟨fun i r hi => ⟨(h.1 i r hi).1, Nat.le_trans (h.1 i r hi).2 hk⟩, h.2⟩

/-- Restrict a packing coloring to its initial columns at the same distance. -/
theorem restrict_columns {f : Nat → Fin 3 → Nat} {m n k : Nat}
    {dist : Nat → Nat → Fin 3 → Fin 3 → Nat} (hm : m ≤ n)
    (h : Packing n k f dist) : Packing m k f dist :=
  ⟨fun i r hi => h.1 i r (Nat.lt_of_lt_of_le hi hm),
   fun i j r s hi hj => h.2 i j r s
     (Nat.lt_of_lt_of_le hi hm) (Nat.lt_of_lt_of_le hj hm)⟩

/-- The stated value is attained, and every admissible palette has at least
    that many colors. -/
def ExactPacking (n k : Nat) (dist : Nat → Nat → Fin 3 → Fin 3 → Nat) : Prop :=
  (∃ f, Packing n k f dist) ∧
  ∀ l f, Packing n l f dist → k ≤ l

end CoronaUpper

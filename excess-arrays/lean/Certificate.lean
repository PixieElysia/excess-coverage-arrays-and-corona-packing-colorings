import Patterns

namespace Excess

/-- Lookup in a finite weight table, extended by zero. -/
def entry : List Nat → Nat → Nat
  | [], _ => 0
  | a :: _, 0 => a
  | _ :: as, j + 1 => entry as j

/-- Sum adjacent entries, with zero padding to the right. -/
def adjacent : List Nat → List Nat
  | [] => []
  | a :: as => (a + entry as 0) :: adjacent as

theorem entry_adjacent (xs : List Nat) (j : Nat) :
    entry (adjacent xs) j = entry xs j + entry xs (j + 1) := by
  induction xs generalizing j with
  | nil => rfl
  | cons a as ih =>
    cases j with
    | zero => rfl
    | succ j => exact ih j

/-- The d-fold Pascal sum computed without enumerating 2^d completions. -/
def table : Nat → List Nat → List Nat
  | 0, xs => xs
  | d + 1, xs => adjacent (table d xs)

theorem completionMass_table (xs : List Nat) (d j : Nat) :
    completionMass (entry xs) d j = entry (table d xs) j := by
  induction d generalizing j with
  | zero => rfl
  | succ d ih => simp only [completionMass, table, entry_adjacent, ih]

def factorial : Nat → Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorial n

/-- An array is encoded by a multiplicity for each actual binary word.
    Each occurrence counts as one row. -/
def mass (m : List Bool → Nat) (p : List (Option Bool)) : Nat :=
  ((completions p).map m).sum

def ExactBinaryArray (m : List Bool → Nat) (N t k : Nat) : Prop :=
  mass m (List.replicate k none) = N ∧
  ∀ p : List (Option Bool), p.length = k → free p = k - t →
    mass m p = factorial (ones p) * factorial (t - ones p)

theorem free_all (k : Nat) : free (List.replicate k none) = k := by
  induction k with
  | zero => rfl
  | succ k ih => simp [List.replicate_succ, free, ih]

theorem ones_all (k : Nat) : ones (List.replicate k none) = 0 := by
  induction k with
  | zero => rfl
  | succ k ih => simp [List.replicate_succ, ones, ih]

theorem row_mass (xs : List Nat) (p : List (Option Bool)) :
    mass (fun w => entry xs (wordWeight w)) p = entry (table (free p) xs) (ones p) := by
  have h := patternMass_eq_sum (entry xs) p 0
  rw [patternMass_eq, completionMass_table] at h
  simpa [mass] using h.symm

/-- A pair of finite arithmetic checks implies the statement for every
    prescribed set of positions and every binary pattern on those positions. -/
theorem array_of_table (xs : List Nat) {t k : Nat} (ht : t ≤ k)
    (size : entry (table k xs) 0 = factorial (t + 1))
    (margins : ∀ a : Fin (t+1), entry (table (k-t) xs) a.val =
      factorial a.val * factorial (t-a.val)) :
    ExactBinaryArray (fun w => entry xs (wordWeight w)) (factorial (t+1)) t k := by
  constructor
  · simpa [row_mass, free_all, ones_all] using size
  · intro p hp hf
    have h := ones_add_free_le p
    rw [hp, hf] at h
    rw [row_mass, hf]
    exact margins ⟨ones p, by omega⟩

end Excess

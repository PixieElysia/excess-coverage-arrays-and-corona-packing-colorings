import Std

namespace Excess

/-- The number of unprescribed positions. -/
def free : List (Option Bool) → Nat
  | [] => 0
  | none :: p => free p + 1
  | some _ :: p => free p

/-- The number of prescribed ones. -/
def ones : List (Option Bool) → Nat
  | [] => 0
  | some true :: p => ones p + 1
  | some false :: p => ones p
  | none :: p => ones p

/-- Sum the multiplicities of completions, one branch per free bit.
The accumulator records ones already seen to the left of this suffix. -/
def patternMass (f : Nat → Nat) : List (Option Bool) → Nat → Nat
  | [], j => f j
  | some false :: p, j => patternMass f p j
  | some true :: p, j => patternMass f p (j + 1)
  | none :: p, j => patternMass f p j + patternMass f p (j + 1)

/-- Repeated Pascal addition for a suffix consisting of free bits. -/
def completionMass (f : Nat → Nat) : Nat → Nat → Nat
  | 0, j => f j
  | d + 1, j => completionMass f d j + completionMass f d (j + 1)

theorem patternMass_eq (f : Nat → Nat) (p : List (Option Bool)) (j : Nat) :
    patternMass f p j = completionMass f (free p) (j + ones p) := by
  induction p generalizing j with
  | nil => simp [patternMass, completionMass, free, ones]
  | cons a p ih =>
    cases a with
    | none =>
      simp only [patternMass, free, ones, completionMass, ih]
      congr 2 <;> omega
    | some b =>
      cases b with
      | false => simpa [patternMass, free, ones] using ih j
      | true =>
        simp only [patternMass, free, ones, ih]
        congr 1 <;> omega

theorem ones_add_free_le (p : List (Option Bool)) : ones p + free p ≤ p.length := by
  induction p with
  | nil => simp [ones, free]
  | cons a p ih =>
    cases a with
    | none => simp only [ones, free, List.length_cons]; omega
    | some b => cases b <;> simp only [ones, free, List.length_cons] <;> omega

/-- Enumerate the actual binary words compatible with a partial pattern. -/
def completions : List (Option Bool) → List (List Bool)
  | [] => [[]]
  | some b :: p => (completions p).map (b :: ·)
  | none :: p =>
    (completions p).map (false :: ·) ++ (completions p).map (true :: ·)

def wordWeight : List Bool → Nat
  | [] => 0
  | false :: w => wordWeight w
  | true :: w => wordWeight w + 1

private theorem sum_append_nat (xs ys : List Nat) : (xs ++ ys).sum = xs.sum + ys.sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [List.sum_cons, ih, Nat.add_assoc]

/-- The recursive count is the sum of the actual row multiplicities over
the list of compatible binary words. -/
theorem patternMass_eq_sum (f : Nat → Nat) (p : List (Option Bool)) (j : Nat) :
    patternMass f p j = ((completions p).map (fun w => f (j + wordWeight w))).sum := by
  induction p generalizing j with
  | nil => simp [patternMass, completions, wordWeight]
  | cons a p ih =>
    cases a with
    | none =>
      simp only [patternMass, completions, List.map_append, sum_append_nat,
        List.map_map, Function.comp_def, wordWeight, ih]
      simp [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm]
    | some b =>
      cases b with
      | false =>
        simpa [patternMass, completions, List.map_map, Function.comp_def, wordWeight] using ih j
      | true =>
        simpa [patternMass, completions, List.map_map, Function.comp_def, wordWeight,
          Nat.add_assoc, Nat.add_left_comm, Nat.add_comm] using ih (j + 1)


/-- A word obeys every prescribed bit and has exactly the prescribed length. -/
def compatible : List (Option Bool) → List Bool → Prop
  | [], [] => True
  | none :: p, _ :: w => compatible p w
  | some b :: p, c :: w => b = c ∧ compatible p w
  | _, _ => False

theorem mem_completions_iff (p : List (Option Bool)) (w : List Bool) :
    w ∈ completions p ↔ compatible p w := by
  induction p generalizing w with
  | nil => cases w <;> simp [completions, compatible]
  | cons a p ih =>
    cases a with
    | none =>
      cases w with
      | nil => simp [completions, List.mem_map, compatible]
      | cons b w => cases b <;> simp [completions, List.mem_map, compatible, ih]
    | some b =>
      cases w with
      | nil => simp [completions, List.mem_map, compatible]
      | cons c w => cases b <;> cases c <;> simp [completions, List.mem_map, compatible, ih]

/-- Each compatible word is listed once, even for the all-free pattern. -/
theorem completions_nodup (p : List (Option Bool)) : (completions p).Nodup := by
  induction p with
  | nil => simp [completions]
  | cons a p ih =>
    change (completions p).Pairwise (· ≠ ·) at ih
    cases a with
    | some b => simpa [completions, List.Nodup, List.pairwise_map] using ih
    | none =>
      simp [completions, List.Nodup, List.pairwise_append, List.pairwise_map,
        List.forall_mem_map, ih]

end Excess

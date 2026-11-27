import Certificate
import General

namespace Excess

/-- The signed and natural factorial conventions agree. -/
theorem cast_factorial (a : Nat) : (factorial a : Int) = Inversion.fact a := by
  induction a with
  | zero => rfl
  | succ a ih =>
    simp only [factorial, Inversion.fact, Int.natCast_mul, Int.natCast_succ, ih]

/-- On an interval of nonnegative multiplicities, natural and signed Pascal
addition count precisely the same extensions. -/
theorem cast_completionMass (x : Nat → Int) (k d j : Nat)
    (nonneg : ∀ i, i ≤ k → 0 ≤ x i) (h : j + d ≤ k) :
    (completionMass (fun i => (x i).toNat) d j : Int) = Inversion.marginal x d j := by
  induction d generalizing j with
  | zero => exact Int.toNat_of_nonneg (nonneg j (by omega))
  | succ d ih =>
    simp only [completionMass, Inversion.marginal, Int.natCast_add]
    rw [ih j (by omega), ih (j+1) (by omega)]

theorem mass_of_nonnegative_layers (x : Nat → Int) (k : Nat) (p : List (Option Bool))
    (hp : p.length = k) (nonneg : ∀ i, i ≤ k → 0 ≤ x i) :
    (mass (fun w => (x (wordWeight w)).toNat) p : Int) =
      Inversion.marginal x (free p) (ones p) := by
  have hs := patternMass_eq_sum (fun i => (x i).toNat) p 0
  rw [patternMass_eq] at hs
  have hm : mass (fun w => (x (wordWeight w)).toNat) p =
      completionMass (fun i => (x i).toNat) (free p) (ones p) := by
    simpa [mass] using hs.symm
  rw [hm, cast_completionMass x k _ _ nonneg]
  simpa [hp] using ones_add_free_le p

/-- A nonnegative rounded solution gives actual multiplicities on binary words.
Marginalizing all k bits recovers the zeroth moment, the total row count. -/
theorem exact_of_rounded_nonnegative (t k : Nat) (ht : t ≤ k)
    (nonneg : ∀ i, i ≤ k → 0 ≤ Inversion.layer
      (fun j => Inversion.nearestQuotient (Inversion.fact (t+1)) (j+1)) k i) :
    ExactBinaryArray
      (fun w => (Inversion.layer
        (fun j => Inversion.nearestQuotient (Inversion.fact (t+1)) (j+1)) k (wordWeight w)).toNat)
      (factorial (t+1)) t k := by
  let y : Nat → Int := fun j => Inversion.nearestQuotient (Inversion.fact (t+1)) (j+1)
  change ExactBinaryArray (fun w => (Inversion.layer y k (wordWeight w)).toNat) _ _ _
  constructor
  · apply Int.ofNat_inj.mp
    rw [mass_of_nonnegative_layers (Inversion.layer y k) k _ (List.length_replicate ..) nonneg,
      free_all, ones_all, Inversion.marginal_layer y k k 0 (by omega), cast_factorial]
    simp only [Nat.sub_self, Nat.sub_zero, Inversion.diff]
    simpa only [y, Int.natCast_zero, Int.zero_add, Int.one_mul] using
      Inversion.nearest_multiple 1 (Inversion.fact (t+1)) (by decide)
  · intro p hp hf
    have ho := ones_add_free_le p
    rw [hp, hf] at ho
    apply Int.ofNat_inj.mp
    rw [mass_of_nonnegative_layers _ _ _ hp nonneg, hf, Int.natCast_mul,
      cast_factorial, cast_factorial]
    exact Inversion.rounded_factorial_marginal t k (ones p) ht (by omega)

/-- Every strength from 22 onward admits a width-twice-strength array
with the minimum row count. The lower strengths use finite certificates. -/
theorem array_from_22 (t : Nat) (ht : 22 ≤ t) :
    ∃ m : List Bool → Nat, ExactBinaryArray m (factorial (t+1)) t (2*t) := by
  exact ⟨_, exact_of_rounded_nonnegative t (2*t) (by omega)
    (fun i hi => General.rounded_nonnegative t i ht hi)⟩

end Excess

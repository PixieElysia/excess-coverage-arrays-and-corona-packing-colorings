import Small
import Universal

namespace Excess

/-- For every positive strength, a minimum-size binary excess coverage array
    of width twice the strength exists with column-permutation symmetry. The
    witness (f) records the multiplicity of each individual word of a given
    weight. -/
theorem exists_symmetric_binary_excess_array (t : Nat) (ht : 1 ≤ t) :
    ∃ f : Nat → Nat,
      ExactBinaryArray (fun w => f (wordWeight w)) (factorial (t+1)) t (2*t) := by
  by_cases h : t ≤ 21
  · exact ⟨entry (finiteRows t), array_through_21 t ht h⟩
  · have h22 : 22 ≤ t := by omega
    refine ⟨fun i => (Inversion.layer
      (fun j => Inversion.nearestQuotient (Inversion.fact (t+1)) (j+1)) (2*t) i).toNat, ?_⟩
    exact exact_of_rounded_nonnegative t (2*t) (by omega)
      (fun i hi => General.rounded_nonnegative t i h22 hi)

#print axioms exists_symmetric_binary_excess_array
#print axioms exists_binary_excess_array_18
#print axioms equation_three_18

end Excess

import Certificate

namespace Excess

/-- Positive multiplicities in order of increasing row weight. -/
def witness18 : List Nat :=
  [
    3287704746234543, 91325561677561, 5218331986327, 460609882625,
    55728278943, 8769561774, 1660738944, 408707871,
    100683849, 39109461, 10767879, 6580331,
    2062333, 1711162, 717000, 668613,
    408459, 404361, 350847, 388109,
    447235, 591566, 865672, 1422819,
    2626677, 5472117, 12934239, 34922343,
    108647345, 393846602, 1687914016, 8720889081,
    55813690119, 460462943481, 5218580026119, 91325150457081,
    3287705416454919]

theorem exact_18_36 :
    ExactBinaryArray (fun w => entry witness18 (wordWeight w)) (factorial 19) 18 36 := by
  apply array_of_table witness18 (by decide)
  · decide
  · decide

/-- Every interaction on any 18 of the 36 columns has its required count. -/
theorem exists_binary_excess_array_18 :
    ∃ m : List Bool → Nat, ExactBinaryArray m (factorial 19) 18 36 :=
  ⟨_, exact_18_36⟩

/-- Binomial coefficients in Pascal row n, indexed from zero. -/
def pascalRow : Nat → List Nat
  | 0 => [1]
  | n+1 => adjacent (0 :: pascalRow n)

/-- Equation (3) in the article, with k=36 and t=18, verbatim as a
    finite binomial sum. Positivity and the row representation are checked separately. -/
theorem equation_three_18 (a : Fin 19) :
    ((List.range 19).map (fun j =>
      entry (pascalRow 18) j * entry witness18 (a.val+j))).sum =
       factorial a.val * factorial (18-a.val) := by
  have all : ∀ i : Fin 19, ((List.range 19).map (fun j =>
      entry (pascalRow 18) j * entry witness18 (i.val+j))).sum =
       factorial i.val * factorial (18-i.val) := by decide
  exact all a

theorem least_multiplicity_18 :
    (∀ i : Fin 37, 350847 ≤ entry witness18 i.val) ∧
    entry witness18 18 = 350847 := by decide

end Excess

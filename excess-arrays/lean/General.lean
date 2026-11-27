import Inversion

/-! Exact inequalities for symmetric binary excess coverage arrays. -/
namespace Excess.General

def fact : Nat → Nat
  | 0 => 1
  | n+1 => (n+1) * fact n

/-- The factorial sufficient condition for width `2*t` holds from 22 onwards. -/
theorem factorial_domination (t : Nat) (ht : 22 ≤ t) :
    (2*t+1) * 3^(2*t) ≤ 2 * fact (t+1) := by
  induction t with
  | zero => omega
  | succ t ih =>
    by_cases h : 22 ≤ t
    case neg =>
      have h21 : t = 21 := by omega
      subst t
      decide
    specialize ih h
    have h₁ : (2*(t+1)+1)*9 ≤ (t+2)*(2*t+1) := by
      have h : 20*(2*t+1) ≤ (t+2)*(2*t+1) :=
        Nat.mul_le_mul_right _ (by omega)
      omega
    calc
      (2*(t+1)+1) * 3^(2*(t+1)) = ((2*(t+1)+1)*9) * 3^(2*t) := by
        rw [show 2*(t+1) = 2*t + 2 by omega, Nat.pow_add]
        rw [show (3:Nat)^2 = 9 by decide]
        ac_rfl
      _ ≤ ((t+2)*(2*t+1)) * 3^(2*t) := Nat.mul_le_mul_right _ h₁
      _ = (t+2)*((2*t+1)*3^(2*t)) := by ac_rfl
      _ ≤ (t+2)*(2 * fact (t+1)) := Nat.mul_le_mul_left _ ih
      _ = 2 * fact (t+1+1) := by
        change _ = 2 * ((t+2)*fact (t+1))
        ac_rfl

theorem fact_pos (a : Nat) : 0 < fact a := by
  induction a with
  | zero => decide
  | succ a ih => exact Nat.mul_pos (by omega) ih

/-- Pascal multiplicity of a layer with `a` ones and `b` zeros. -/
def layer : Nat → Nat → Nat
  | 0, _ => 1
  | _+1, 0 => 1
  | a+1, b+1 => layer a (b+1) + layer (a+1) b

theorem weighted_layer (a b : Nat) : layer a b * 2^b ≤ 3^(a+b) := by
  induction a generalizing b with
  | zero =>
    simp only [layer, Nat.one_mul, Nat.zero_add]
    exact Nat.pow_le_pow_left (by decide) _
  | succ a ha =>
    induction b with
    | zero =>
      simp only [layer, Nat.pow_zero, Nat.one_mul, Nat.add_zero]
      exact Nat.pow_pos (by decide)
    | succ b hb =>
      calc
        layer (a+1) (b+1) * 2^(b+1) =
            layer a (b+1)*2^(b+1) + (layer (a+1) b*2^b)*2 := by
          rw [layer, Nat.add_mul, Nat.pow_succ]; ac_rfl
        _ ≤ 3^(a+(b+1)) + 3^(a+1+b)*2 :=
          Nat.add_le_add (ha (b+1)) (Nat.mul_le_mul_right _ hb)
        _ = 3^(a+1+(b+1)) := by
          rw [show a+(b+1) = a+1+b by omega, show a+1+(b+1) = (a+1+b)+1 by omega, Nat.pow_succ]
          omega

theorem layers_factorial (a b : Nat) : layer a b * fact a * fact b = fact (a+b) := by
  induction a generalizing b with
  | zero => simp [layer, fact]
  | succ a ha =>
    induction b with
    | zero => simp [layer, fact]
    | succ b hb =>
      rw [layer, Nat.add_mul, Nat.add_mul]
      have A := ha (b+1)
      have B := hb
      calc
        _ = (a+1) * (layer a (b+1)*fact a*fact (b+1)) +
            (b+1) * (layer (a+1) b*fact (a+1)*fact b) := by
          simp only [fact]
          ac_rfl
        _ = (a+1) * fact (a+b+1) + (b+1) * fact (a+b+1) := by
          rw [A, B, show a+1+b = a+b+1 by omega, show a+(b+1) = a+b+1 by omega]
        _ = fact (a+1+(b+1)) := by
          rw [← Nat.add_mul, show a+1+(b+1) = (a+b+1)+1 by omega]
          rfl

theorem int_fact (a : Nat) : (fact a : Int) = Inversion.fact a := by
  induction a with
  | zero => rfl
  | succ a ih =>
    simp only [fact, Inversion.fact, Int.natCast_mul, Int.natCast_succ, ih]

/-- Exact integer bound for nearest division, including ties to even. -/
theorem nearest_bound (N d : Int) (hd : 0 < d) :
    -d ≤ 2*(d*Inversion.nearestQuotient N d-N) ∧
         2*(d*Inversion.nearestQuotient N d-N) ≤ d := by
  have he := Int.emod_add_ediv N d
  have hr := Int.emod_nonneg N (Int.ne_of_gt hd)
  have hr' := Int.emod_lt_of_pos N hd
  unfold Inversion.nearestQuotient
  dsimp only
  split
  · omega
  · simp only [Int.mul_add, Int.mul_one]
    omega

/-- A uniform initial error, propagated by signed differences on an interval. -/
theorem difference_bound (y z : Nat → Int) (F : Int) (k : Nat)
    (h : ∀ j, j ≤ k → -F ≤ 2*(F*y j-z j) ∧ 2*(F*y j-z j) ≤ F)
    (a b : Nat) (hk : a+b ≤ k) :
    -(F*2^b) ≤ 2*(F*Inversion.diff y b a-Inversion.diff z b a) ∧
    2*(F*Inversion.diff y b a-Inversion.diff z b a) ≤ F*2^b := by
  induction b generalizing a with
  | zero => simpa [Inversion.diff] using h a (by omega)
  | succ b ih =>
      have h₀ := ih a (by omega)
      have h₁ := ih (a+1) (by omega)
      rw [Inversion.diff, Inversion.diff, Int.pow_succ, ← Int.mul_assoc F]
      simp only [Int.mul_sub]
      simp only [Int.mul_sub] at h₀ h₁
      omega

/-- Scale the local nearest-integer error to a common factorial denominator. -/
theorem rounded_initial (k j : Nat) (N : Int) (hj : j ≤ k) :
    let F := Inversion.fact (k+1);
    let d := (j+1 : Int);
    -F ≤ 2*(F*Inversion.nearestQuotient N d-(F/d)*N) ∧
    2*(F*Inversion.nearestQuotient N d-(F/d)*N) ≤ F := by
  dsimp only
  obtain ⟨c,hc⟩ := Inversion.factor_in_factorial k j hj
  have hd : 0 < (j+1 : Int) := by omega
  have hF := Inversion.fact_pos (k+1)
  rw [hc] at hF ⊢
  have hc0 : 0 ≤ c := by
    by_cases hn : 0 ≤ c
    · exact hn
    have hlim := Int.mul_le_mul_of_nonneg_left (show c ≤ 0 by omega) (Int.le_of_lt hd)
    simp only [Int.mul_zero] at hlim
    omega
  rw [Int.mul_ediv_cancel_left _ (Int.ne_of_gt hd)]
  obtain ⟨low,high⟩ := nearest_bound N (j+1) hd
  have hl := Int.mul_le_mul_of_nonneg_left low hc0
  have hu := Int.mul_le_mul_of_nonneg_left high hc0
  rw [show 2*((j+1 : Int)*c*Inversion.nearestQuotient N (j+1)-c*N) =
       c*(2*((j+1 : Int)*Inversion.nearestQuotient N (j+1)-N)) by
         simp only [Int.mul_sub]; congr 1 <;> ac_rfl]
  simpa only [Int.mul_neg, Int.mul_comm c ((j+1 : Int))] using And.intro hl hu

/-- The factorial form of the ternary bound:
`(k+1)! 2^b ≤ 2 N a! b!` for `a+b=k`. -/
theorem factorial_error_bound (t a b : Nat) (ht : 22 ≤ t) (hk : a+b=2*t) :
    Inversion.fact (a+b+1) * 2^b ≤
      2 * (Inversion.fact (t+1) * Inversion.fact a * Inversion.fact b) := by
  have h₁ := weighted_layer a b
  have h₂ := factorial_domination t ht
  rw [← hk] at h₂
  have h₃ := Nat.le_trans (Nat.mul_le_mul_left (a+b+1) h₁) h₂
  have h₄ := Nat.mul_le_mul_right (fact a * fact b) h₃
  have h₅ : fact (a+b+1) * 2^b ≤ 2 * (fact (t+1) * fact a * fact b) := by
    calc
      fact (a+b+1)*2^b =
          ((a+b+1)*(layer a b*2^b))*(fact a*fact b) := by
        change ((a+b+1)*fact (a+b))*2^b = _
        rw [← layers_factorial a b]
        ac_rfl
      _ ≤ (2*fact (t+1))*(fact a*fact b) := h₄
      _ = 2*(fact (t+1)*fact a*fact b) := by ac_rfl
  have h₆ := Int.ofNat_le.mpr h₅
  simpa only [Int.natCast_mul, Int.natCast_pow, Int.cast_ofNat_Int, int_fact] using h₆

/-- Every layer in the rounded width-`2*t` construction is nonnegative
from strength 22 onward. The proof uses exact integral comparisons. -/
theorem rounded_nonnegative (t i : Nat) (ht : 22 ≤ t) (hi : i ≤ 2*t) :
    0 ≤ Inversion.layer (fun j => Inversion.nearestQuotient (Inversion.fact (t+1)) (j+1)) (2*t) i := by
  let k := 2*t
  let b := k-i
  let N := Inversion.fact (t+1)
  let F := Inversion.fact (k+1)
  let y := fun j : Nat => Inversion.nearestQuotient N (j+1)
  have hik : i+b=k := by dsimp [k,b]; omega
  have e := difference_bound y (Inversion.idealMoment N k) F k
      (fun j hj => rounded_initial k j N hj) i b (by omega)
  rw [Inversion.ideal_layer_scaled N k i b hik] at e
  have h₀ := factorial_error_bound t i b ht hik
  rw [hik] at h₀
  change F * 2^b ≤ 2 * (N * Inversion.fact i * Inversion.fact b) at h₀
  have hF : 0 < F := Inversion.fact_pos _
  have hprod : 0 ≤ F * Inversion.diff y b i := by omega
  change 0 ≤ Inversion.diff y b i
  apply Int.le_of_mul_le_mul_left (a := F) _ hF
  simpa only [Int.mul_zero] using hprod

end Excess.General

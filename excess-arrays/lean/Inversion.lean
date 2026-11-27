import Std

/-! Boolean inversion and the factorial marginal identity over the integers. -/
namespace Excess.Inversion

/-- Alternating finite differences of the all-ones intersection counts. -/
def diff (y : Nat → Int) : Nat → Nat → Int
  | 0, a => y a
  | b + 1, a => diff y b a - diff y b (a + 1)

/-- Signed multiplicity assigned to each word of weight a at width k. -/
def layer (y : Nat → Int) (k a : Nat) : Int := diff y (k - a) a

/-- Marginalize over d unspecified bits. -/
def marginal (x : Nat → Int) : Nat → Nat → Int
  | 0, a => x a
  | d + 1, a => marginal x d a + marginal x d (a + 1)

/-- The multiplicity of a pattern is the finite difference at the
number of prescribed zeros, regardless of the number of unspecified bits. -/
theorem marginal_layer (y : Nat → Int) (k d a : Nat) (h : a + d ≤ k) :
    marginal (layer y k) d a = diff y (k - d - a) a := by
  induction d generalizing a with
  | zero => simp [marginal, layer]
  | succ d ih =>
    rw [marginal, ih a (by omega), ih (a+1) (by omega)]
    let b := k - (d+1) - a
    have h₀ : k - d - a = b + 1 := by dsimp [b]; omega
    have h₁ : k - d - (a + 1) = b := by dsimp [b]; omega
    rw [h₀, h₁, diff]
    change diff y b a - diff y b (a + 1) + diff y b (a + 1) = diff y b a
    omega

/-- Integer factorial, used to clear the denominators of the beta moments. -/
def fact : Nat → Int
  | 0 => 1
  | n + 1 => (n+1 : Int) * fact n

theorem fact_pos (n : Nat) : 0 < fact n := by
  induction n with
  | zero => decide
  | succ n ih => exact Int.mul_pos (by omega) ih

/-- Discrete beta identity. Only the given initial moments up to t are used. -/
theorem beta_cleared (y : Nat → Int) (N : Int) (t : Nat)
    (moments : ∀ j, j ≤ t → (j+1 : Int) * y j = N)
    (a b : Nat) (le : a + b ≤ t) :
    fact (a+b+1) * diff y b a = N * fact a * fact b := by
  induction b generalizing a with
  | zero =>
    have hm := moments a (by omega)
    simp only [Nat.add_zero, diff, fact, Int.mul_one]
    calc
      ((a : Int) + 1) * fact a * y a = (((a : Int) + 1) * y a) * fact a := by ac_rfl
      _ = N * fact a := by rw [hm]
  | succ b ih =>
    have h₀ := ih a (by omega)
    have h₁ := ih (a+1) (by omega)
    have idx : a+1+b+1 = a+(b+1)+1 := by omega
    rw [idx] at h₁
    rw [diff, Int.mul_sub, h₁]
    have decomp : fact (a+(b+1)+1) * diff y b a =
        ((a+b+1 : Nat) + 1 : Int) * (N * fact a * fact b) := by
      rw [show a+(b+1)+1 = (a+b+1)+1 by omega, fact, Int.mul_assoc, h₀]
    rw [decomp]
    change _ - N * (((a : Int)+1) * fact a) * fact b = N * fact a * (((b : Int)+1) * fact b)
    simp only [Int.natCast_add, Int.cast_ofNat_Int, Int.natCast_succ]
    simp only [Int.add_mul, Int.one_mul, Int.mul_add, Int.mul_one, Int.mul_assoc,
      Int.mul_comm, Int.mul_left_comm]
    omega

/-- For N = (t+1)!, all prescribed t-bit patterns receive their
factorial multiplicities. The upper moments are completely arbitrary. -/
theorem factorial_marginal (y : Nat → Int) (t k a : Nat)
    (htk : t ≤ k) (hat : a ≤ t)
    (moments : ∀ j, j ≤ t → (j+1 : Int) * y j = fact (t+1)) :
    marginal (layer y k) (k-t) a = fact a * fact (t-a) := by
  rw [marginal_layer y k (k-t) a (by omega)]
  rw [show k-(k-t)-a = t-a by omega]
  have hb := beta_cleared y (fact (t+1)) t moments a (t-a) (by omega)
  rw [show a+(t-a)+1 = t+1 by omega, Int.mul_assoc] at hb
  exact Int.eq_of_mul_eq_mul_left (Int.ne_of_gt (fact_pos _)) hb

/-- Round N/d to the nearest integer with ties to even for positive d. -/
def nearestQuotient (N d : Int) : Int :=
  let q := N / d
  let r := N % d
  if 2*r < d ∨ (2*r = d ∧ q%2 = 0) then q else q+1

theorem nearest_multiple (d z : Int) (hd : 0 < d) :
    nearestQuotient (d*z) d = z := by
  simp [nearestQuotient, Int.mul_emod_right, Int.mul_ediv_cancel_left, Int.ne_of_gt hd, hd]

theorem factor_in_factorial (n j : Nat) (hj : j ≤ n) :
    ∃ z : Int, fact (n+1) = (j+1 : Int) * z := by
  induction n generalizing j with
  | zero =>
    have h : j = 0 := by omega
    subst j
    exact ⟨1, rfl⟩
  | succ n ih =>
    by_cases h : j = n+1
    · subst j
      exact ⟨fact (n+1), rfl⟩
    · obtain ⟨z,hz⟩ := ih j (by omega)
      refine ⟨((n+1 : Nat)+1 : Int)*z, ?_⟩
      change ((n+1 : Nat)+1 : Int)*fact (n+1) = _
      rw [hz]
      ac_rfl

/-- Actual rounded construction. This unconditional signed marginal identity
holds at every strength and width k ≥ t, even where a layer is negative. -/
theorem rounded_factorial_marginal (t k a : Nat) (htk : t ≤ k) (hat : a ≤ t) :
    marginal (layer (fun j => nearestQuotient (fact (t+1)) (j+1)) k) (k-t) a =
      fact a * fact (t-a) := by
  apply factorial_marginal _ t k a htk hat
  intro j hj
  obtain ⟨z,hz⟩ := factor_in_factorial t j hj
  rw [hz]
  change (j+1 : Int) * nearestQuotient ((j+1 : Int) * z) (j+1) = (j+1 : Int) * z
  rw [nearest_multiple _ z (by omega)]

/-- The ideal intersections, cleared by the common denominator (k+1)!. -/
def idealMoment (N : Int) (k j : Nat) : Int := (fact (k+1) / (j+1 : Int)) * N

theorem ideal_moment_scaled (N : Int) (k j : Nat) (hj : j ≤ k) :
    (j+1 : Int) * idealMoment N k j = fact (k+1) * N := by
  obtain ⟨z,hz⟩ := factor_in_factorial k j hj
  simp only [idealMoment, hz, Int.mul_ediv_cancel_left z (show (j+1 : Int) ≠ 0 by omega)]
  ac_rfl

/-- At full width the exact layer, multiplied by (k+1)!, is the
integer N a! b!. This removes division in comparison with rounded layers. -/
theorem ideal_layer_scaled (N : Int) (k a b : Nat) (hk : a+b=k) :
    diff (idealMoment N k) b a = N * fact a * fact b := by
  have h := beta_cleared (idealMoment N k) (fact (k+1)*N) k
    (ideal_moment_scaled N k) a b (by omega)
  rw [hk] at h
  apply Int.eq_of_mul_eq_mul_left (Int.ne_of_gt (fact_pos (k+1)))
  calc
    _ = (fact (k+1)*N)*fact a*fact b := h
    _ = fact (k+1) * (N*fact a*fact b) := by ac_rfl

end Excess.Inversion

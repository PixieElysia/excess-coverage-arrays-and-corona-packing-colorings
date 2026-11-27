import GraphProof
import CycleMetric
namespace PackingCorona

inductive Role where
  | hub | left | right
deriving DecidableEq

def Role.depth : Role → Nat
  | .hub => 0
  | .left | .right => 1

def row (h x y : BitVec n) : Role → BitVec n
  | .hub => h
  | .left => x
  | .right => y

/-- The shortest-path formula, including two distinct vertices in one triangle. -/
def distance (cycle : Bool) (n i j : Nat) (r s : Role) : Nat :=
  let gap := (i-j) + (j-i)
  if i = j then (if r = s then 0 else 1)
  else (if cycle then min gap (n-gap) else gap) + r.depth + s.depth

def MetricPacking (cycle : Bool) (k : Nat) (h x y : BitVec n) : Prop :=
  ∀ (i j : Nat) (r s : Role), i < n → j < n → (i ≠ j ∨ r ≠ s) →
    (row h x y r).getLsbD i = true → (row h x y s).getLsbD j = true →
    k < distance cycle n i j r s

private theorem disjointRows {a b : BitVec n}
    (H : ∀ i, i < n → a.getLsbD i = true → b.getLsbD i = true → False) :
    (a &&& b == 0) = true := by
  apply beq_iff_eq.mpr
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  rw [BitVec.getLsbD_and]
  change (a.getLsbD i && b.getLsbD i) = (0#n).getLsbD i
  rw [BitVec.getLsbD_zero]
  cases ha : a.getLsbD i <;> cases hb : b.getLsbD i
  all_goals first | rfl | exact (H i hi ha hb).elim

private def lane (d : Bool) (h x y : BitVec n) :=
  if d then x ||| y else h

private theorem laneMember {d : Bool} {h x y : BitVec n} {i : Nat}
    (H : (lane d h x y).getLsbD i = true) :
    ∃ r, r.depth = d.toNat ∧ (row h x y r).getLsbD i = true := by
  cases d with
  | false => exact ⟨.hub, rfl, H⟩
  | true =>
    simp [lane] at H
    rcases H with H | H
    · exact ⟨.left, rfl, H⟩
    · exact ⟨.right, rfl, H⟩

private theorem within {h x y : BitVec n} {k : Nat} {cycle : Bool}
    (H : MetricPacking cycle k h x y) (hk : 1 ≤ k) :
    (h &&& (x ||| y) == 0) = true ∧ (x &&& y == 0) = true := by
  constructor
  · apply disjointRows
    intro i hi hh ht
    simp at ht
    rcases ht with hx | hy
    · have con := H i i .hub .left hi hi (Or.inr (by decide)) hh hx
      simp [distance] at con
      omega
    · have con := H i i .hub .right hi hi (Or.inr (by decide)) hh hy
      simp [distance] at con
      omega
  · apply disjointRows
    intro i hi hx hy
    have con := H i i .left .right hi hi (Or.inr (by decide)) hx hy
    simp [distance] at con
    omega

private theorem pathOffsets {h x y : BitVec 12} {k : Nat}
    (H : MetricPacking false k h x y) (a b : Bool) :
    ∀ d, d ≤ k-a.toNat-b.toNat →
      separated (lane a h x y) (lane b h x y) d = true := by
  intro d
  induction d with
  | zero => simp [separated]
  | succ d ih =>
    intro hd
    apply Bool.and_eq_true_iff.mpr
    refine ⟨?_, ih (by omega)⟩
    apply disjointRows
    intro j hj hshift hb
    rw [BitVec.getLsbD_shiftLeft] at hshift
    simp [hj] at hshift
    obtain ⟨hl, ha⟩ := hshift
    obtain ⟨r, hr, hri⟩ := laneMember ha
    obtain ⟨s, hs, hsj⟩ := laneMember hb
    have hi : j-(d+1) < 12 := by omega
    have hne : j-(d+1) ≠ j := by omega
    have con := H (j-(d+1)) j r s hi hj (Or.inl hne) hri hsj
    simp only [distance, hne, if_false, hr, hs, Bool.false_eq_true, ↓reduceIte] at con
    omega

private theorem cycleOffsets {h x y : BitVec 13} {k : Nat}
    (H : MetricPacking true k h x y) (hk : k < 13) (a b : Bool) :
    ∀ d, d ≤ k-a.toNat-b.toNat →
      cycleSeparated (lane a h x y) (lane b h x y) d = true := by
  intro d
  induction d with
  | zero => simp [cycleSeparated]
  | succ d ih =>
    intro hd
    apply Bool.and_eq_true_iff.mpr
    refine ⟨?_, ih (by omega)⟩
    apply disjointRows
    intro j hj hrot hb
    rw [BitVec.getLsbD_rotateLeft_of_le (by omega)] at hrot
    obtain ⟨s, hs, hsj⟩ := laneMember hb
    by_cases hwrap : j < d+1
    · simp [hwrap] at hrot
      obtain ⟨r, hr, hri⟩ := laneMember hrot
      have hi : 12-d+j < 13 := by omega
      have hne : 12-d+j ≠ j := by omega
      have con := H (12-d+j) j r s hi hj (Or.inl hne) hri hsj
      simp only [distance, hne, if_false, hr, hs, Bool.false_eq_true, ↓reduceIte] at con
      omega
    · simp [hwrap, hj] at hrot
      obtain ⟨r, hr, hri⟩ := laneMember hrot
      have hi : j-(d+1) < 13 := by omega
      have hne : j-(d+1) ≠ j := by omega
      have con := H (j-(d+1)) j r s hi hj (Or.inl hne) hri hsj
      simp only [distance, hne, if_false, hr, hs, Bool.false_eq_true, ↓reduceIte] at con
      omega


theorem pathPacking_of_metric {k : Nat} {s : ColorClass} (hk : 1 ≤ k)
    (H : MetricPacking false k s.h s.x s.y) : packing k s = true := by
  obtain ⟨w₁, w₂⟩ := within H hk
  have intervals := pathOffsets H
  simp only [packing, Bool.and_eq_true]
  exact ⟨⟨⟨⟨⟨w₁, w₂⟩, intervals false false k (by simp)⟩,
      intervals false true (k-1) (by simp)⟩,
      intervals true false (k-1) (by simp)⟩,
      intervals true true (k-2) (by simp; omega)⟩

theorem cyclePacking_of_metric {k : Nat} {s : CycleClass} (hk : 1 ≤ k) (hk' : k < 13)
    (H : MetricPacking true k s.h s.x s.y) : cyclePacking k s = true := by
  obtain ⟨w₁, w₂⟩ := within H hk
  have intervals := cycleOffsets H hk'
  simp only [cyclePacking, Bool.and_eq_true]
  exact ⟨⟨⟨⟨⟨w₁, w₂⟩, intervals false false k (by simp)⟩,
      intervals false true (k-1) (by simp)⟩,
      intervals true false (k-1) (by simp)⟩,
      intervals true true (k-2) (by simp; omega)⟩

/-- The coloring assigns integers to the three roles in every column.
Only entries in columns `0,...,n-1` are constrained. -/
def IsColoring (cycle : Bool) (n k : Nat) (f : Nat → Role → Nat) : Prop :=
  (∀ i r, i < n → 1 ≤ f i r ∧ f i r ≤ k) ∧
  ∀ i j r s, i < n → j < n → (i ≠ j ∨ r ≠ s) →
    f i r = f j s → f i r < distance cycle n i j r s

private def bits (p : Nat → Bool) : (n : Nat) → BitVec n
  | 0 => 0
  | n+1 => BitVec.cons (p n) (bits p n)

private theorem bitAt {p : Nat → Bool} {n i : Nat} (hi : i < n) :
    (bits p n).getLsbD i = p i := by
  induction n with
  | zero => omega
  | succ n ih =>
    rw [bits, BitVec.getLsbD_cons]
    split
    · rename_i h; rw [h]
    · exact ih (by omega)

private def colorRow (f : Nat → Role → Nat) (c : Nat) (r : Role) (n : Nat) :=
  bits (fun i => decide (f i r = c)) n

private theorem rowMetric {cyc : Bool} {n k c : Nat} {f : Nat → Role → Nat}
    (H : IsColoring cyc n k f) :
    MetricPacking cyc c (colorRow f c .hub n) (colorRow f c .left n)
      (colorRow f c .right n) := by
  intro i j r s hi hj hne hr hs
  have eqi : f i r = c := by
    cases r <;> simpa [row, colorRow, bitAt hi] using hr
  have eqj : f j s = c := by
    cases s <;> simpa [row, colorRow, bitAt hj] using hs
  rw [← eqi]
  exact H.2 i j r s hi hj hne (eqi.trans eqj.symm)

private def pathClass (f : Nat → Role → Nat) (c : Nat) : ColorClass :=
  ⟨colorRow f c .hub 12, colorRow f c .left 12, colorRow f c .right 12⟩
private def ringClass (f : Nat → Role → Nat) (c : Nat) : CycleClass :=
  ⟨colorRow f c .hub 13, colorRow f c .left 13, colorRow f c .right 13⟩

private theorem coversPath {f : Nat → Role → Nat} (H : IsColoring false 12 6 f) (r : Role) :
    let a := fun c => colorRow f c r 12
    covered (a 1) (a 2) (a 3) (a 4) (a 5) (a 6) = true := by
  apply beq_iff_eq.mpr
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  change _ = (BitVec.allOnes 12).getLsbD i
  have hc := H.1 i r hi
  simp only [BitVec.getLsbD_or, colorRow, bitAt hi, BitVec.getLsbD_allOnes, decide_eq_true hi, Bool.or_eq_true, decide_eq_true_eq]
  omega

private theorem coversCycle {f : Nat → Role → Nat} (H : IsColoring true 13 7 f) (r : Role) :
    let a := fun c => colorRow f c r 13
    cycleCovered (a 1) (a 2) (a 3) (a 4) (a 5) (a 6) (a 7) = true := by
  apply beq_iff_eq.mpr
  apply BitVec.eq_of_getLsbD_eq
  intro i hi
  change _ = (BitVec.allOnes 13).getLsbD i
  have hc := H.1 i r hi
  simp only [BitVec.getLsbD_or, colorRow, bitAt hi, BitVec.getLsbD_allOnes, decide_eq_true hi, Bool.or_eq_true, decide_eq_true_eq]
  omega

theorem path12_lower (f : Nat → Role → Nat) : ¬ IsColoring false 12 6 f := by
  intro H
  let a := pathClass f
  have pack (c : Nat) (hc : 1 ≤ c) : packing c (a c) = true :=
    pathPacking_of_metric hc (rowMetric H)
  apply noSixPackingCover (a 1) (a 2) (a 3) (a 4) (a 5) (a 6)
  simp only [Bool.and_eq_true]
  exact ⟨⟨⟨⟨⟨⟨⟨⟨pack 1 (by decide), pack 2 (by decide)⟩, pack 3 (by decide)⟩,
    pack 4 (by decide)⟩, pack 5 (by decide)⟩, pack 6 (by decide)⟩,
    coversPath H .hub⟩, coversPath H .left⟩, coversPath H .right⟩

theorem cycle13_lower (f : Nat → Role → Nat) : ¬ IsColoring true 13 7 f := by
  intro H
  let a := ringClass f
  have pack (c : Nat) (hc : 1 ≤ c) (hc' : c < 13) : cyclePacking c (a c) = true :=
    cyclePacking_of_metric hc hc' (rowMetric H)
  apply noSevenCyclePackingCover (a 1) (a 2) (a 3) (a 4) (a 5) (a 6) (a 7)
  simp only [Bool.and_eq_true]
  exact ⟨⟨⟨⟨⟨⟨⟨⟨⟨pack 1 (by decide) (by decide), pack 2 (by decide) (by decide)⟩,
    pack 3 (by decide) (by decide)⟩, pack 4 (by decide) (by decide)⟩,
    pack 5 (by decide) (by decide)⟩, pack 6 (by decide) (by decide)⟩,
    pack 7 (by decide) (by decide)⟩, coversCycle H .hub⟩, coversCycle H .left⟩, coversCycle H .right⟩
end PackingCorona

namespace CoronaUpper

private def roleIndex : PackingCorona.Role → Fin 3
  | .hub => 0
  | .left => 1
  | .right => 2

private theorem roleIndex_ne {r s : PackingCorona.Role} (h : r ≠ s) :
    roleIndex r ≠ roleIndex s := by
  cases r <;> cases s <;> first | contradiction | decide

private theorem metric_agrees (cycle : Bool) (n i j : Nat) (r s : PackingCorona.Role) :
    PackingCorona.distance cycle n i j r s =
    (if cycle then cycleDistance n else pathDistance) i j (roleIndex r) (roleIndex s) := by
  by_cases h : i = j
  · subst j
    cases cycle <;> cases r <;> cases s <;> rfl
  · cases cycle <;> cases r <;> cases s <;>
      simp [PackingCorona.distance, pathDistance, cycleDistance, gap, h,
            height, roleIndex, PackingCorona.Role.depth]

private theorem transfer {cycle : Bool} {n k : Nat} {f : Nat → Fin 3 → Nat}
    (H : Packing n k f (if cycle then cycleDistance n else pathDistance)) :
    PackingCorona.IsColoring cycle n k (fun i r => f i (roleIndex r)) := by
  refine ⟨fun i r hi => H.1 i (roleIndex r) hi, ?_⟩
  intro i j r s hi hj hne hsame
  rw [metric_agrees]
  exact H.2 i j _ _ hi hj (hne.imp id roleIndex_ne) hsame

theorem no_path_six : ¬ ∃ f, Packing 12 6 f pathDistance := by
  rintro ⟨f, H⟩
  exact PackingCorona.path12_lower _ (transfer (cycle := false) H)

theorem no_cycle_seven : ¬ ∃ f, Packing 13 7 f (cycleDistance 13) := by
  rintro ⟨f, H⟩
  exact PackingCorona.cycle13_lower _ (transfer (cycle := true) H)

end CoronaUpper

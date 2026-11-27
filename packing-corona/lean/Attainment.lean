import CoronaWalk

namespace CoronaUpper

/-- A path has the triangle edges and the consecutive hub edges. -/
def PathEdge (i j : Nat) (r s : Fin 3) : Prop :=
  (i=j ∧ r≠s) ∨ (r.val=0 ∧ s.val=0 ∧ (i+1=j ∨ j+1=i))

def hub : Fin 3 := 0

inductive PathWalk (n z : Nat) (t : Fin 3) : Nat → Fin 3 → Nat → Prop
  | stop (hz : z<n) : PathWalk n z t z t 0
  | step {i j l : Nat} {r s : Fin 3} (hi : i<n)
      (edge : PathEdge i j r s) (rest : PathWalk n z t j s l) :
      PathWalk n z t i r (l+1)

theorem path_edge_cycle {n i j : Nat} {r s : Fin 3} (e : PathEdge i j r s) :
    CycleEdge n i j r s := by
  rcases e with p | ⟨hr,hs,p|p⟩
  · exact Or.inl p
  · exact Or.inr ⟨hr,hs,Or.inl p⟩
  · exact Or.inr ⟨hr,hs,Or.inr (Or.inl p)⟩

theorem path_as_cycle {n z i l : Nat} {r t : Fin 3}
    (p : PathWalk n z t i r l) : CycleWalk n z t i r l := by
  induction p with
  | stop h => exact .stop h
  | step hi e _ ih => exact .step hi (path_edge_cycle e) ih

theorem cycle_append {n i j z l m : Nat} {r s t : Fin 3}
    (p : CycleWalk n j s i r l) (q : CycleWalk n z t j s m) :
    CycleWalk n z t i r (l+m) := by
  induction p with
  | stop _ => simpa using q
  | step hi e _ ih => simpa [Nat.add_right_comm] using CycleWalk.step hi e ih

theorem path_append {n i j z l m : Nat} {r s t : Fin 3}
    (p : PathWalk n j s i r l) (q : PathWalk n z t j s m) :
    PathWalk n z t i r (l+m) := by
  induction p with
  | stop _ => simpa using q
  | step hi e _ ih => simpa [Nat.add_right_comm] using PathWalk.step hi e ih

theorem walk_forward (n i d : Nat) (hn : i+d<n) :
    PathWalk n (i+d) hub i hub d := by
  induction d generalizing i with
  | zero => exact .stop hn
  | succ d ih =>
    have tail := ih (i+1) (by omega)
    rw [show i+1+d = i+(d+1) by omega] at tail
    exact .step (by omega) (Or.inr ⟨rfl,rfl,Or.inl rfl⟩) tail

theorem walk_backward (n j d : Nat) (hn : j+d<n) :
    PathWalk n j hub (j+d) hub d := by
  induction d with
  | zero => exact .stop hn
  | succ d ih =>
    exact .step hn (Or.inr ⟨rfl,rfl,Or.inr rfl⟩) (ih (by omega))

theorem path_hubs {n i j : Nat} (hi : i<n) (hj : j<n) :
    PathWalk n j hub i hub (gap i j) := by
  by_cases h : i≤j
  · have p := walk_forward n i (j-i) (by omega)
    rw [show i+(j-i)=j by omega] at p
    simpa [gap, Nat.sub_eq_zero_of_le h] using p
  · have p := walk_backward n j (i-j) (by omega)
    rw [show j+(i-j)=i by omega] at p
    simpa [gap, Nat.sub_eq_zero_of_le (show j≤i by omega)] using p

theorem same_column_walk (n i : Nat) (hi : i<n) (r s : Fin 3) :
    PathWalk n i s i r (if r=s then 0 else 1) := by
  by_cases h : r=s
  · subst s; simp; exact .stop hi
  · simp [h]; exact .step hi (Or.inl ⟨rfl,h⟩) (.stop hi)

theorem to_hub (n i : Nat) (hi : i<n) (r : Fin 3) : PathWalk n i hub i r (height r) := by
  simpa [height, hub, Fin.ext_iff] using same_column_walk n i hi r hub

theorem from_hub (n i : Nat) (hi : i<n) (r : Fin 3) : PathWalk n i r i hub (height r) := by
  simpa [height, hub, Fin.ext_iff, eq_comm] using same_column_walk n i hi hub r

theorem path_distance_attained (n i j : Nat) (hi : i<n) (hj : j<n) (r s : Fin 3) :
    PathWalk n j s i r (pathDistance i j r s) := by
  by_cases h : i=j
  · subst j; simpa [pathDistance] using same_column_walk n i hi r s
  · simpa [pathDistance,h,Nat.add_assoc,Nat.add_comm,Nat.add_left_comm]
      using path_append (to_hub n i hi r) (path_append (path_hubs hi hj) (from_hub n j hj s))

theorem path_edge_bound {i j z : Nat} {r s t : Fin 3} (edge : PathEdge i j r s) :
    pathDistance i z r t ≤ pathDistance j z s t + 1 := by
  rcases edge with ⟨eq, _⟩ | ⟨hr, hs, adj⟩
  · subst j
    by_cases e : i=z
    · simp only [pathDistance, e, if_true]
      split <;> split <;> omega
    · have h := height_le_one r
      simp only [pathDistance, if_neg e]
      omega
  · have bound : gap i z ≤ gap j z + 1 := by
      unfold gap
      rcases adj with a | a <;> omega
    have zr : height r = 0 := by simp [height, hr]
    have zs : height s = 0 := by simp [height, hs]
    by_cases iz : i=z
    · simp only [pathDistance, if_pos iz]
      split <;> omega
    · by_cases jz : j=z
      · subst z
        rw [show gap j j = 0 by simp [gap]] at bound
        simp [pathDistance, iz, zr]
        by_cases st : s=t
        · subst t
          simp [zs]
          omega
        · simp [st]
          have ht := height_le_one t
          omega
      · simp only [pathDistance, if_neg iz, if_neg jz, zr, zs, Nat.add_zero]
        omega

theorem path_walk_bounds {n z i l : Nat} {t r : Fin 3}
    (w : PathWalk n z t i r l) : i<n ∧ z<n ∧ pathDistance i z r t ≤ l := by
  induction w with
  | stop h => simp [h, pathDistance]
  | step hi e _ ih =>
    have h := path_edge_bound (z := z) (t := t) e
    exact ⟨hi, ih.2.1, by omega⟩

private theorem wrap_to_last {n : Nat} (hn : 0<n) :
    CycleWalk n (n-1) hub 0 hub 1 :=
  .step hn (Or.inr ⟨rfl,rfl,Or.inr (Or.inr (Or.inl ⟨rfl,by omega⟩))⟩)
    (.stop (by omega))

private theorem wrap_from_last {n : Nat} (hn : 0<n) :
    CycleWalk n 0 hub (n-1) hub 1 :=
  .step (by omega) (Or.inr ⟨rfl,rfl,Or.inr (Or.inr (Or.inr ⟨rfl,by omega⟩))⟩)
    (.stop hn)

private theorem opposite_hubs {n i j : Nat} (hi : i<n) (hj : j<n) :
    CycleWalk n j hub i hub (n-gap i j) := by
  by_cases h : i≤j
  · have p := path_as_cycle (path_hubs (j := 0) hi (by omega))
    have q := path_as_cycle (path_hubs (i := n-1) (by omega) hj)
    have w := cycle_append p (cycle_append (wrap_to_last (n := n) (by omega)) q)
    have form : gap i 0 + (1+gap (n-1) j) = n-gap i j := by unfold gap; omega
    rwa [form] at w
  · have p := path_as_cycle (path_hubs (j := n-1) hi (by omega))
    have q := path_as_cycle (path_hubs (i := 0) (by omega) hj)
    have w := cycle_append p (cycle_append (wrap_from_last (n := n) (by omega)) q)
    have form : gap i (n-1) + (1+gap 0 j) = n-gap i j := by unfold gap; omega
    rwa [form] at w

/-- The closed-form cycle distance is realized by an actual walk. -/
theorem cycle_distance_attained (n i j : Nat) (hi : i<n) (hj : j<n) (r s : Fin 3) :
    CycleWalk n j s i r (cycleDistance n i j r s) := by
  by_cases eq : i=j
  · subst j
    simpa [cycleDistance] using path_as_cycle (same_column_walk n i hi r s)
  · have hubs : CycleWalk n j hub i hub (min (gap i j) (n-gap i j)) := by
      by_cases h : gap i j ≤ n-gap i j
      · rw [Nat.min_eq_left h]
        exact path_as_cycle (path_hubs hi hj)
      · rw [Nat.min_eq_right (by omega)]
        exact opposite_hubs hi hj
    simpa [cycleDistance, eq, Nat.add_assoc, Nat.add_comm, Nat.add_left_comm] using
      cycle_append (path_as_cycle (to_hub n i hi r)) (cycle_append hubs
        (path_as_cycle (from_hub n j hj s)))

end CoronaUpper

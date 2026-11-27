import CycleMetric

/-! Explicit packing colorings on every required cycle length. The only
variable-length part of a coloring is a repetition of one twelve-column
word. Every local window already occurs with at most two repetitions. -/
namespace CoronaUpper

def six := [123,412,127,312,126,512]
def eight := [123,412,123,712,123,612,123,512]
def fifteen := [123,412,127,312,125,612,123,412,125,312,712,124,612,123,512]
def seventeen := [123,412,123,712,123,512,123,612,123,412,125,312,712,124,612,123,512]
def nineteen := [123,412,123,712,123,512,123,412,123,612,123,512,123,412,712,123,612,123,512]

def base : Nat → List Nat
  | 12 => six ++ six
  | 13 => [412,123,512,123,612,123,412,123,512,123,712,123,812]
  | 14 => six ++ eight
  | 15 => fifteen
  | 16 => eight ++ eight
  | 17 => seventeen
  | 18 => six ++ six ++ six
  | 19 => nineteen
  | 20 => six ++ six ++ eight
  | 21 => six ++ fifteen
  | 22 => six ++ eight ++ eight
  | 23 => six ++ seventeen
  | 24 => six ++ six ++ six ++ six
  | 25 => six ++ nineteen
  | _ => []

/-- Columns are decimal triples, with the center in the hundreds place. -/
def digit (x : Nat) (r : Fin 3) : Nat :=
  match r.val with
  | 0 => x / 100
  | 1 => x / 10 % 10
  | _ => x % 10

def template (a i : Nat) (r : Fin 3) : Nat :=
  if i < a then digit ((base a)[i]?.getD 0) r
  else digit ((six ++ six)[(i-a)%12]?.getD 0) r

/-- A finite type presentation of the local packing inequalities. -/
abbrev Checked (n k : Nat) (f : Nat → Fin 3 → Nat) : Prop :=
  (∀ (i : Fin n) (r : Fin 3), 1 ≤ f i r ∧ f i r ≤ k) ∧
  (∀ (i : Fin n) (r s : Fin 3), r≠s → f i r ≠ f i s) ∧
  (∀ (i : Fin n) (d : Fin (k+1)) (r s : Fin 3), 0<d.val →
      f i r = f (advance n i d) s → f i r < d.val + height r + height s)

theorem local_of_checked {n k f} (h : Checked n k f) : Local n k f := by
  obtain ⟨h₁, h₂, h₃⟩ := h
  exact ⟨fun i r hi => h₁ ⟨i, hi⟩ r,
         fun i r s hi => h₂ ⟨i, hi⟩ r s,
         fun i d r s hi hd hk => h₃ ⟨i, hi⟩ ⟨d, by omega⟩ r s hd⟩

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem thirteen : Local 13 8 (template 13) := local_of_checked (by decide)

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
theorem twelve : Local 12 7 (template 12) := local_of_checked (by decide)

private def compress (a q i : Nat) : Nat :=
  if i < a then i
  else if a+12*q ≤ i+12 then i - 12*(q-2)
  else a+(i-a)%12

private theorem small_index {a q i : Nat} (ha : 12≤a) (hq : 2≤q) (hi : i<a+12*q) :
    compress a q i < a+24 := by
  unfold compress
  split
  · omega
  · split <;> omega

private theorem same_here {a q i : Nat} (ha : 12≤a) (hq : 2≤q) (hi : i<a+12*q) (r : Fin 3) :
    template a i r = template a (compress a q i) r := by
  unfold compress
  split
  · rfl
  · split
    all_goals
      unfold template
      split <;> try omega
      split <;> try omega
      congr 3 <;> omega

private theorem same_there {a q i d : Nat} (ha : 12≤a) (hq : 2≤q) (hi : i<a+12*q)
    (hd : d≤7) (s : Fin 3) :
    template a (advance (a+12*q) i d) s =
      template a (advance (a+24) (compress a q i) d) s := by
  unfold compress advance template
  split <;> split <;> try split <;> try split <;> try split <;> try split
  all_goals first | omega | congr 3 <;> omega


/-- Every radius-seven window of the long cycle already occurs in the
cycle with a base of length a followed by two twelve-column periods. -/
theorem extend_template {a q : Nat} (ha : 12≤a) (hq : 2≤q)
    (small : Local (a+24) 7 (template a)) : Local (a+12*q) 7 (template a) := by
  obtain ⟨range, triangle, gaps⟩ := small
  refine ⟨?_, ?_, ?_⟩
  · intro i r hi
    rw [same_here ha hq hi r]
    exact range _ _ (small_index ha hq hi)
  · intro i r s hi hrs
    rw [same_here ha hq hi r, same_here ha hq hi s]
    exact triangle _ _ _ (small_index ha hq hi) hrs
  · intro i d r s hi hp hd hsame
    rw [same_here ha hq hi r, same_there ha hq hi hd s] at hsame
    rw [same_here ha hq hi r]
    exact gaps _ d r s (small_index ha hq hi) hp hd hsame

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check14 (q : Fin 3) : Checked (14+12*q.val) 7 (template 14) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 14 7 (template 14))
  · exact (by decide : Checked 26 7 (template 14))
  · exact (by decide : Checked 38 7 (template 14))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check15 (q : Fin 3) : Checked (15+12*q.val) 7 (template 15) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 15 7 (template 15))
  · exact (by decide : Checked 27 7 (template 15))
  · exact (by decide : Checked 39 7 (template 15))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check16 (q : Fin 3) : Checked (16+12*q.val) 7 (template 16) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 16 7 (template 16))
  · exact (by decide : Checked 28 7 (template 16))
  · exact (by decide : Checked 40 7 (template 16))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check17 (q : Fin 3) : Checked (17+12*q.val) 7 (template 17) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 17 7 (template 17))
  · exact (by decide : Checked 29 7 (template 17))
  · exact (by decide : Checked 41 7 (template 17))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check18 (q : Fin 3) : Checked (18+12*q.val) 7 (template 18) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 18 7 (template 18))
  · exact (by decide : Checked 30 7 (template 18))
  · exact (by decide : Checked 42 7 (template 18))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check19 (q : Fin 3) : Checked (19+12*q.val) 7 (template 19) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 19 7 (template 19))
  · exact (by decide : Checked 31 7 (template 19))
  · exact (by decide : Checked 43 7 (template 19))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check20 (q : Fin 3) : Checked (20+12*q.val) 7 (template 20) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 20 7 (template 20))
  · exact (by decide : Checked 32 7 (template 20))
  · exact (by decide : Checked 44 7 (template 20))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check21 (q : Fin 3) : Checked (21+12*q.val) 7 (template 21) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 21 7 (template 21))
  · exact (by decide : Checked 33 7 (template 21))
  · exact (by decide : Checked 45 7 (template 21))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check22 (q : Fin 3) : Checked (22+12*q.val) 7 (template 22) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 22 7 (template 22))
  · exact (by decide : Checked 34 7 (template 22))
  · exact (by decide : Checked 46 7 (template 22))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check23 (q : Fin 3) : Checked (23+12*q.val) 7 (template 23) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 23 7 (template 23))
  · exact (by decide : Checked 35 7 (template 23))
  · exact (by decide : Checked 47 7 (template 23))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check24 (q : Fin 3) : Checked (24+12*q.val) 7 (template 24) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 24 7 (template 24))
  · exact (by decide : Checked 36 7 (template 24))
  · exact (by decide : Checked 48 7 (template 24))

set_option maxRecDepth 100000 in
set_option maxHeartbeats 0 in
private theorem check25 (q : Fin 3) : Checked (25+12*q.val) 7 (template 25) := by
  rcases q with ⟨q, h⟩
  have cases : q=0 ∨ q=1 ∨ q=2 := by omega
  rcases cases with rfl | rfl | rfl
  · exact (by decide : Checked 25 7 (template 25))
  · exact (by decide : Checked 37 7 (template 25))
  · exact (by decide : Checked 49 7 (template 25))

private theorem small_checked (j : Fin 12) (q : Fin 3) :
    Checked (14+j.val+12*q.val) 7 (template (14+j.val)) := by
  rcases j with ⟨j,h⟩
  have cases : j=0 ∨ j=1 ∨ j=2 ∨ j=3 ∨ j=4 ∨ j=5 ∨ j=6 ∨ j=7 ∨ j=8 ∨ j=9 ∨ j=10 ∨ j=11 := by omega
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl
  · exact check14 q
  · exact check15 q
  · exact check16 q
  · exact check17 q
  · exact check18 q
  · exact check19 q
  · exact check20 q
  · exact check21 q
  · exact check22 q
  · exact check23 q
  · exact check24 q
  · exact check25 q

private theorem all_templates (a q : Nat) (ha : 14≤a) (hb : a≤25) :
    Local (a+12*q) 7 (template a) := by
  have ident : 14+(a-14) = a := by omega
  have sample (j : Fin 3) : Local (a+12*j.val) 7 (template a) := by
    have h := local_of_checked (small_checked ⟨a-14, by omega⟩ j)
    simpa only [ident] using h
  by_cases hq : q<2
  · exact sample ⟨q, by omega⟩
  · exact extend_template (by omega) (by omega) (sample 2)

theorem seven_upper {n : Nat} (hn : 12≤n) (hne : n≠13) :
    ∃ f, Packing n 7 f (cycleDistance n) := by
  by_cases h : n=12
  · subst n
    exact ⟨_, local_to_cyclePacking twelve⟩
  · let a := 14+(n-14)%12
    let q := (n-14)/12
    have hform : a+12*q=n := by dsimp [a,q]; omega
    have hlocal := all_templates a q (by dsimp [a]; omega) (by dsimp [a]; omega)
    rw [hform] at hlocal
    exact ⟨_, local_to_cyclePacking hlocal⟩

theorem eight_upper : Packing 13 8 (template 13) (cycleDistance 13) :=
  local_to_cyclePacking thirteen

end CoronaUpper

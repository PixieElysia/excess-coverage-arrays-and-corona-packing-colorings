import PackingTools
import Bridge
import Upper

namespace CoronaUpper

theorem path_exact {n : Nat} (hn : 12 ≤ n) : ExactPacking n 7 pathDistance := by
  constructor
  · obtain ⟨f, hf⟩ := seven_upper (n := n+2) (by omega) (by omega)
    exact ⟨f, cycle_to_pathPacking (by omega) hf⟩
  · intro k f hf
    by_cases h : 7 ≤ k
    · exact h
    · have hsmall : k ≤ 6 := by omega
      exact False.elim (no_path_six ⟨f, enlarge_palette hsmall (restrict_columns hn hf)⟩)

theorem cycle_exact {n : Nat} (hn : 12 ≤ n) :
    ExactPacking n (if n = 13 then 8 else 7) (cycleDistance n) := by
  by_cases h : n = 13
  · subst n
    simp only [if_pos rfl]
    refine ⟨⟨_, eight_upper⟩, ?_⟩
    intro k f hf
    by_cases hk : 8 ≤ k
    · exact hk
    · exact False.elim (no_cycle_seven ⟨f, enlarge_palette (by omega) hf⟩)
  · simp only [if_neg h]
    refine ⟨seven_upper hn h, ?_⟩
    intro k f hf
    exact (path_exact (n := 12) (by decide)).2 k f (cycle_to_pathPacking hn hf)

#print axioms path_exact
#print axioms cycle_exact

end CoronaUpper

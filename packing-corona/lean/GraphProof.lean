import Std.Tactic.BVDecide

/-! A path of twelve triangles is represented by a row of twelve bits for each
of its three vertex roles. A set of vertices has rows `h` (hubs), `x`, and `y`
(the two satellites). The packing condition below concerns the actual
distances between these vertices. -/
namespace PackingCorona

structure ColorClass where
  h : BitVec 12
  x : BitVec 12
  y : BitVec 12

/-- Inclusive ranges of positive column gaps. Shifts drop bits past the
endpoints, so they do not introduce a wrap-around edge. -/
def separated (a b : BitVec 12) : Nat → Bool
  | 0 => true
  | n+1 => (((a <<< (n+1)) &&& b) == 0) && separated a b n

/-- Distinct vertices in one column have distance one. In distinct columns,
the distance is the gap plus the number of satellite endpoints. -/
def packing (i : Nat) (s : ColorClass) : Bool :=
  let t := s.x ||| s.y
  (s.h &&& t == 0) && (s.x &&& s.y == 0) &&
  separated s.h s.h i &&
  separated s.h t (i-1) && separated t s.h (i-1) &&
  separated t t (i-2)

def covered (a b c d e f : BitVec 12) : Bool :=
  (a ||| b ||| c ||| d ||| e ||| f) == 4095

/-- The thirty-six vertices cannot even be covered by six packing sets.
Allowing overlaps strengthens the statement about partitions. -/
theorem noSixPackingCover (a b c d e f : ColorClass) :
    ¬ (packing 1 a && packing 2 b && packing 3 c &&
       packing 4 d && packing 5 e && packing 6 f &&
       covered a.h b.h c.h d.h e.h f.h &&
       covered a.x b.x c.x d.x e.x f.x &&
       covered a.y b.y c.y d.y e.y f.y) = true := by
  cases a; cases b; cases c; cases d; cases e; cases f
  dsimp [packing, separated, covered]
  bv_decide (config := { timeout := 120 })

/-! For a cycle of length thirteen, rotation replaces the zero-filled shift.
Testing the positive offsets 1 through i also enforces the reverse direction,
by the two ordered hub/satellite tests. -/
structure CycleClass where
  h : BitVec 13
  x : BitVec 13
  y : BitVec 13

def cycleSeparated (a b : BitVec 13) : Nat → Bool
  | 0 => true
  | n+1 => (((a.rotateLeft (n+1)) &&& b) == 0) && cycleSeparated a b n

def cyclePacking (i : Nat) (s : CycleClass) : Bool :=
  let t := s.x ||| s.y
  (s.h &&& t == 0) && (s.x &&& s.y == 0) &&
  cycleSeparated s.h s.h i &&
  cycleSeparated s.h t (i-1) && cycleSeparated t s.h (i-1) &&
  cycleSeparated t t (i-2)

def cycleCovered (a b c d e f g : BitVec 13) : Bool :=
  (a ||| b ||| c ||| d ||| e ||| f ||| g) == 8191

theorem noSevenCyclePackingCover (a b c d e f g : CycleClass) :
    ¬ (cyclePacking 1 a && cyclePacking 2 b && cyclePacking 3 c &&
       cyclePacking 4 d && cyclePacking 5 e && cyclePacking 6 f && cyclePacking 7 g &&
       cycleCovered a.h b.h c.h d.h e.h f.h g.h &&
       cycleCovered a.x b.x c.x d.x e.x f.x g.x &&
       cycleCovered a.y b.y c.y d.y e.y f.y g.y) = true := by
  cases a; cases b; cases c; cases d; cases e; cases f; cases g
  dsimp [cyclePacking, cycleSeparated, cycleCovered]
  bv_decide (config := { timeout := 180 })

end PackingCorona

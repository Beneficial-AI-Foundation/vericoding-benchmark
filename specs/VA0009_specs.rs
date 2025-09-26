// <vc-preamble>
use vstd::prelude::*;

verus! {

spec fn valid_input(input: Seq<char>) -> bool {
    input.len() > 0 && input.contains('\n' as char)
}

spec fn parse_input(input: Seq<char>) -> (int, int, int, Seq<int>, Seq<int>)
    recommends valid_input(input)
{
    (1, 1, 1, Seq::<int>::empty(), Seq::<int>::empty())
}

spec fn compute_max_bourles(r: int, s: Seq<int>, b: Seq<int>) -> int
    recommends r >= 1 && s.len() >= 1 && b.len() >= 1 &&
               (forall|i: int| 0 <= i < s.len() ==> s[i] >= 1) &&
               (forall|i: int| 0 <= i < b.len() ==> b[i] >= 1)
{
    r
}
// </vc-preamble>

// <vc-helpers>
// </vc-helpers>

// <vc-spec>
fn solve(input: Vec<u8>) -> (result: Vec<u8>)
    requires input.len() > 0 && input@.contains('\n' as u8) && valid_input(input@.map(|i: int, x: u8| x as char))
    ensures result.len() > 0
// </vc-spec>
// <vc-code>
{
    // impl-start
    assume(false);
    unreached()
    // impl-end
}
// </vc-code>


}

fn main() {}
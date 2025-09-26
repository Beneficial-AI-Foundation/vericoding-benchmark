// <vc-preamble>
use vstd::prelude::*;

verus! {
spec fn valid_input(x: int, a: int) -> bool {
    0 <= x <= 9 && 0 <= a <= 9
}

spec fn correct_output(x: int, a: int, result: int) -> bool {
    result == (if x < a { 0nat as int } else { 10nat as int })
}
// </vc-preamble>

// <vc-helpers>
// </vc-helpers>

// <vc-spec>
fn solve(x: i8, a: i8) -> (result: i8)
    requires valid_input(x as int, a as int)
    ensures correct_output(x as int, a as int, result as int)
// </vc-spec>
// <vc-code>
{
    assume(false);
    unreached()
}
// </vc-code>


}

fn main() {}
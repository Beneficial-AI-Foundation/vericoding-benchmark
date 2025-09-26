// <vc-preamble>
use vstd::prelude::*;

verus! {

uninterp spec fn power(n: int, alpha: int) -> int;

uninterp spec fn log(n: int, alpha: int) -> int;
// </vc-preamble>

// <vc-helpers>
// </vc-helpers>

// <vc-spec>
fn pow(n: u32, alpha: i32) -> (product: i32)
    requires n > 0 && alpha > 0
    ensures product == power(n as int, alpha as int)
// </vc-spec>
// <vc-code>
{
    assume(false);
    unreached()
}
// </vc-code>

}
fn main() {}
// <vc-preamble>
use vstd::prelude::*;

verus! {
// </vc-preamble>

// <vc-helpers>
// </vc-helpers>

// <vc-spec>
fn lucid_numbers(n: i32) -> (lucid: Vec<i32>)
    requires 
        n >= 0,
    ensures 
        forall|i: int| 0 <= i < lucid.len() ==> lucid[i] % 3 == 0,
        forall|i: int| 0 <= i < lucid.len() ==> lucid[i] <= n,
        forall|i: int, j: int| 0 <= i < j < lucid.len() ==> lucid[i] < lucid[j],
// </vc-spec>
// <vc-code>
{
    assume(false);
    unreached()
}
// </vc-code>

}
fn main() {}
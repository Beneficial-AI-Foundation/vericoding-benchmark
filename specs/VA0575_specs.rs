// <vc-preamble>
use vstd::prelude::*;

verus! {
spec fn valid_day(day: &str) -> bool {
    day == "SUN" || day == "MON" || day == "TUE" || day == "WED" || day == "THU" || day == "FRI" || day == "SAT"
}

spec fn days_until_sunday(day: &str) -> int {
    if day == "SUN" { 7 }
    else if day == "MON" { 6 }
    else if day == "TUE" { 5 }
    else if day == "WED" { 4 }
    else if day == "THU" { 3 }
    else if day == "FRI" { 2 }
    else { 1 }
}
// </vc-preamble>

// <vc-helpers>
// </vc-helpers>

// <vc-spec>
fn days_to_next_sunday(day: &str) -> (result: i8)
    requires 
        valid_day(day)
    ensures 
        result as int >= 1 && result as int <= 7,
        result as int == days_until_sunday(day)
// </vc-spec>
// <vc-code>
{
    assume(false);
    unreached()
}
// </vc-code>


}

fn main() {}
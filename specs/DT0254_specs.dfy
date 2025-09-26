// <vc-preamble>
// Method that checks if two sequences of the same length are element-wise equal
// </vc-preamble>

// <vc-helpers>
// </vc-helpers>

// <vc-spec>
method ArrayEqual<T(==)>(a1: seq<T>, a2: seq<T>) returns (result: bool)
  // Precondition: arrays must have the same length (shape constraint)
  requires |a1| == |a2|
  
  // Main postcondition: result is true iff all corresponding elements are equal
  ensures result <==> (forall i :: 0 <= i < |a1| ==> a1[i] == a2[i])
  
  // Special case: empty arrays are equal (vacuous truth)
  ensures |a1| == 0 ==> result == true
  
  // Special case: if any element differs, result is false
  ensures (exists i :: 0 <= i < |a1| && a1[i] != a2[i]) ==> result == false
  
  // Reflexivity property: any array is equal to itself
  ensures a1 == a2 ==> result == true
// </vc-spec>
// <vc-code>
{
  assume {:axiom} false;
}
// </vc-code>

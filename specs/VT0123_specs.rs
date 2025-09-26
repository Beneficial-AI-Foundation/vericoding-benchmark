// <vc-preamble>
use vstd::prelude::*;

verus! {

#[derive(PartialEq, Eq)]
pub enum NumpyDType {

    Bool,

    Int8,

    Int16,

    Int32,

    Int64,

    UInt8,

    UInt16,

    UInt32,

    UInt64,

    Float16,

    Float32,

    Float64,

    Complex64,

    Complex128,
}

#[derive(PartialEq, Eq)]
pub enum DTypeKind {

    Bool,

    SignedInteger,

    UnsignedInteger,

    Integral,

    RealFloating,

    ComplexFloating,

    Numeric,
}

spec fn get_dtype_kind(dtype: NumpyDType) -> DTypeKind {
    match dtype {
        NumpyDType::Bool => DTypeKind::Bool,
        NumpyDType::Int8 | NumpyDType::Int16 | NumpyDType::Int32 | NumpyDType::Int64 => DTypeKind::SignedInteger,
        NumpyDType::UInt8 | NumpyDType::UInt16 | NumpyDType::UInt32 | NumpyDType::UInt64 => DTypeKind::UnsignedInteger,
        NumpyDType::Float16 | NumpyDType::Float32 | NumpyDType::Float64 => DTypeKind::RealFloating,
        NumpyDType::Complex64 | NumpyDType::Complex128 => DTypeKind::ComplexFloating,
    }
}

spec fn is_of_kind(dtype: NumpyDType, kind: DTypeKind) -> bool {
    match kind {
        DTypeKind::Bool => get_dtype_kind(dtype) == DTypeKind::Bool,
        DTypeKind::SignedInteger => get_dtype_kind(dtype) == DTypeKind::SignedInteger,
        DTypeKind::UnsignedInteger => get_dtype_kind(dtype) == DTypeKind::UnsignedInteger,
        DTypeKind::Integral => get_dtype_kind(dtype) == DTypeKind::SignedInteger || get_dtype_kind(dtype) == DTypeKind::UnsignedInteger,
        DTypeKind::RealFloating => get_dtype_kind(dtype) == DTypeKind::RealFloating,
        DTypeKind::ComplexFloating => get_dtype_kind(dtype) == DTypeKind::ComplexFloating,
        DTypeKind::Numeric => get_dtype_kind(dtype) == DTypeKind::Bool || 
                             get_dtype_kind(dtype) == DTypeKind::SignedInteger || 
                             get_dtype_kind(dtype) == DTypeKind::UnsignedInteger || 
                             get_dtype_kind(dtype) == DTypeKind::RealFloating || 
                             get_dtype_kind(dtype) == DTypeKind::ComplexFloating,
    }
}
// </vc-preamble>

// <vc-helpers>
// </vc-helpers>

// <vc-spec>
fn numpy_isdtype(dtype: NumpyDType, kind: DTypeKind) -> (result: bool)
    ensures result == is_of_kind(dtype, kind)
// </vc-spec>
// <vc-code>
{
    assume(false);
    unreached()
}
// </vc-code>

}
fn main() {}
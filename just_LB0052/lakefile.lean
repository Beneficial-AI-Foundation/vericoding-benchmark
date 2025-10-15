import Lake
open Lake DSL

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.23.0-rc2"

package «just_LB0052» where
  -- add package configuration options here

@[default_target]
lean_lib «JustLB0052» where
  -- add library configuration options here


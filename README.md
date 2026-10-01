# SAC Finance — Lean 4 Verification Repository

Formal Lean 4 specification of the **Safety Asset Class (SAC) in Finance** under Human-Guided Narrow Superintelligence (HGNSI), by Michael Aaron Russell. It formalizes WAD-18 deterministic fixed-point arithmetic, the Cognitive State Ledger, transition semantics, fail-closed safety invariants, and Safety Asset admission, and proves their guarantees.

Pure Lean 4 core: no Mathlib, no external dependencies.

## Build

```bash
# install elan (Lean toolchain manager): https://github.com/leanprover/elan
lake build
```

The toolchain is pinned in `lean-toolchain` (`leanprover/lean4:v4.12.0`). Every push runs `.github/workflows/lean.yml`, which builds the project and checks every proof and golden vector.

## Build status

This repository was written without access to a Lean compiler. **It has not yet been compiled.** The first CI run on GitHub is the first check. If a proof fails there, the error log names the file and line. Until a CI run passes, treat the theorems as *Defined*, not *Verified*, in the specification's own evidence terms.

## Modules

| File | Contents |
|---|---|
| `SacFinance/Wad.lean` | WAD-18: `Q = 10^18`, int256 bound, `encode`, `add`, `sub`, `mulRaw`, `divRaw`, explicit `WadError` refusals |
| `SacFinance/Ledger.lean` | `CSL = (F, E, A, C, D, I, U, O, H)`, human decisions as state |
| `SacFinance/Transition.lean` | `valid = M ∧ C_qualified ∧ G` |
| `SacFinance/Safety.lean` | `Safe`, fail-closed, value conservation, position derivation, inductive safety preservation |
| `SacFinance/Asset.lean` | `Asset(S)`, `HG_established`, `SAC_F(S)` admission |
| `SacFinance/GoldenVectors.lean` | 38 concrete cases checked by `decide` |

## Theorems and the specification

| Theorem | Specification statement |
|---|---|
| `div_by_zero_rejected` | Division requires b ≠ 0 |
| `mul_nonexact_rejected` | Non-exact multiplication is not silently approximated |
| `excess_precision_rejected` | More than 18 decimals is rejected (no declared quantization) |
| `add_unit_mismatch_rejected`, `sub_unit_mismatch_rejected` | Incompatible quantities are not implicitly combined |
| `checked_out_of_bound` | Arithmetic bounds are enforced |
| `CSL.nine_fields` | The ledger has nine canonical fields |
| `missing_decision_invalid` | A required human decision cannot be skipped |
| `failed_predicate_invalid`, `decision_cannot_override_machine` | A human decision does not replace machine verification |
| `no_custodian_invalid` | A qualified custodian must be associated |
| `fail_closed` | ∃ I : I(S) = 0 ⇒ Safe(S) = 0 |
| `transfer_conserves` | Value conservation for a transfer with a fee |
| `position_append` | Positions are derived deterministically from history |
| `inductive_safety` | Every state reachable through valid transitions is safe |
| `unsafe_not_asset`, `impure_not_asset`, `no_provenance_not_asset` | A failed construction predicate yields a non-admitted state |
| `unverified_not_admitted`, `not_human_guided_not_admitted`, `admitted_iff` | SAC_F(S) = Asset(S) ∧ HG_established ∧ Verified(S) |

## Scope

These proofs cover the model as formalized here. They do not establish that any deployed financial system satisfies the model, and they do not measure E_m, R_v, V_r, or T_m. The int256 bound is a declared convention of this repository. `/` and `%` are used only where divisibility has already been checked, so results do not depend on Int rounding convention.

## Intellectual property

U.S. Patent Application No. 19/383,582 is identified by the author as the intellectual-property foundation for the architecture. Choose and add a license before publishing.

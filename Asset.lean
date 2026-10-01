/-!
# Safety Asset admission

Asset(S) = Safe ∧ Pure ∧ Prov ∧ Canon ∧ Gov
SAC_F(S) = Asset(S) ∧ HG_established ∧ Verified(S)
HG_established ⟺ Σ_H ≠ ∅ ∧ P_H = 1 ∧ G_H = 1
-/
namespace SacFinance

structure AssetChecks where
  safe  : Bool
  pure  : Bool
  prov  : Bool
  canon : Bool
  gov   : Bool
  deriving DecidableEq, Repr

def asset (c : AssetChecks) : Bool := c.safe && c.pure && c.prov && c.canon && c.gov

structure HumanGuided where
  sigmaNonEmpty         : Bool
  provenanceComplete    : Bool
  governanceSatisfied   : Bool
  deriving DecidableEq, Repr

def hgEstablished (h : HumanGuided) : Bool :=
  h.sigmaNonEmpty && h.provenanceComplete && h.governanceSatisfied

def sacAdmit (c : AssetChecks) (h : HumanGuided) (verified : Bool) : Bool :=
  asset c && hgEstablished h && verified

theorem unsafe_not_asset (c : AssetChecks) (h : c.safe = false) : asset c = false := by
  simp [asset, h]

theorem impure_not_asset (c : AssetChecks) (h : c.pure = false) : asset c = false := by
  simp [asset, h]

theorem no_provenance_not_asset (c : AssetChecks) (h : c.prov = false) : asset c = false := by
  simp [asset, h]

theorem unverified_not_admitted (c : AssetChecks) (h : HumanGuided) :
    sacAdmit c h false = false := by
  simp [sacAdmit]

theorem not_human_guided_not_admitted (c : AssetChecks) (h : HumanGuided) (v : Bool)
    (hg : hgEstablished h = false) : sacAdmit c h v = false := by
  simp [sacAdmit, hg]

theorem admitted_iff (c : AssetChecks) (h : HumanGuided) (v : Bool) :
    sacAdmit c h v = true ↔ asset c = true ∧ hgEstablished h = true ∧ v = true := by
  simp [sacAdmit, Bool.and_eq_true, and_assoc]

end SacFinance

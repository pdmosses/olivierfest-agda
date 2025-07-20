\begin{code}

module PrimSchemeQED.Domain-Equations where

open import PrimSchemeQED.Domain-Notation
open import PrimSchemeQED.Abstract-Syntax
  using (Ide; Key; Dat; Exp)

open import Data.Integer.Base
  renaming (ℤ to Int)

-- 7.2.2. Domain equations

postulate
  Loc  :  Set       -- set of locations
  𝐀    :  Domain    -- answers

data Misc : Set where
  null unspecified : Misc

-- Non-recursive domain definitions

𝐋   =  Loc +⊥   -- locations
𝐍   =  ℕ +⊥     -- natural numbers
𝐓   =  Bool +⊥  -- booleans
𝐐   =  Ide +⊥   -- identifier symbols
𝐑   =  Int +⊥   -- numbers
𝐏   =  (𝐋 × 𝐋)  -- pairs
𝐌   =  Misc +⊥  -- miscellaneous
𝐃   =  Dat +⊥   -- data ASTs
𝐗   =  Key +⊥   -- keyword symbols

-- Recursive domain isomorphisms

open import Function
  using (Inverse; _↔_) public

postulate
  𝐅  :  Domain      -- procedure values
  𝐄  :  Domain      -- expressed values
  𝐒  :  Domain      -- stores
  𝐔  :  Domain      -- environments
  𝐂  :  Domain      -- command continuations

postulate instance
  iso-𝐅  : 𝐅  ↔  (𝐄 ⋆ → (𝐄 → 𝐂) → 𝐂)
  iso-𝐄  : 𝐄  ↔  (𝕃 (𝐐 ⊎ 𝐓 ⊎ 𝐑 ⊎ 𝐏 ⊎ 𝐌 ⊎ 𝐅 ⊎ 𝐃 ⊎ 𝐗))
  iso-𝐒  : 𝐒  ↔  (𝐋 → 𝐄)
  iso-𝐔  : 𝐔  ↔  (Ide → 𝐋)
  iso-𝐂  : 𝐂  ↔  (𝐒 → 𝐀)

open Inverse {{ ... }}
  renaming (to to ▻ ; from to ◅ ) public
  -- iso-D : D ↔ D′ declares ▻ : D → D′ and ◅ : D′ → D

variable
  α   : 𝐋
  α⋆  : 𝐋 ⋆
  ν   : 𝐍
  γ   : 𝐐
  τ   : 𝐓
  ζ   : 𝐑
  π   : 𝐏
  μ   : 𝐌
  φ   : 𝐅
  δ   : 𝐃
  χ   : 𝐗
  ϵ   : 𝐄
  ϵ⋆  : 𝐄 ⋆
  σ   : 𝐒
  ρ   : 𝐔
  θ   : 𝐂

pattern
  inj-𝐐 γ   = inj₁ γ
pattern
  inj-𝐓 τ   = inj₂ (inj₁ τ)
pattern
  inj-𝐑 ζ   = inj₂ (inj₂ (inj₁ ζ))
pattern
  inj-𝐏 π   = inj₂ (inj₂ (inj₂ (inj₁ π)))
pattern
  inj-𝐌 μ   = inj₂ (inj₂ (inj₂ (inj₂ (inj₁ μ))))
pattern
  inj-𝐅 φ   = inj₂ (inj₂ (inj₂ (inj₂ (inj₂ (inj₁ φ)))))
pattern
  inj-𝐃 δ   = inj₂ (inj₂ (inj₂ (inj₂ (inj₂ (inj₂ (inj₁ δ))))))
pattern
  inj-𝐗 χ   = inj₂ (inj₂ (inj₂ (inj₂ (inj₂ (inj₂ (inj₂ χ))))))

_∈𝐏         : 𝐄 → Bool +⊥
ϵ ∈𝐏        = ((λ { (inj-𝐏 _) → η true ; _ → η false }) ♯) (▻ ϵ)

_|𝐏         : 𝐄 → 𝐏
ϵ |𝐏        = ((λ { (inj-𝐏 φ) → φ ; _ → ⊥ }) ♯) (▻ ϵ)

_∈𝐅         : 𝐄 → Bool +⊥
ϵ ∈𝐅        = ((λ { (inj-𝐅 _) → η true ; _ → η false }) ♯) (▻ ϵ)

_|𝐅         : 𝐄 → 𝐅
ϵ |𝐅        = ((λ { (inj-𝐅 φ) → φ ; _ → ⊥ }) ♯) (▻ ϵ)

_|𝐃         : 𝐄 → 𝐃
ϵ |𝐃        = ((λ { (inj-𝐃 Δ) → Δ ; _ → ⊥ }) ♯) (▻ ϵ)

_𝐃-in-𝐄     : 𝐃 → 𝐄
δ 𝐃-in-𝐄    = ◅ (η (inj-𝐃 δ))

_𝐐-in-𝐄     : 𝐐 → 𝐄
γ 𝐐-in-𝐄    = ◅ (η (inj-𝐐 γ))

_𝐓-in-𝐄     : 𝐓 → 𝐄
τ 𝐓-in-𝐄    = ◅ (η (inj-𝐓 τ))

_𝐑-in-𝐄     : 𝐑 → 𝐄
ζ 𝐑-in-𝐄    = ◅ (η (inj-𝐑 ζ))

_𝐏-in-𝐄     : 𝐏 → 𝐄
π 𝐏-in-𝐄    = ◅ (η (inj-𝐏 π))

_𝐅-in-𝐄     : 𝐅 → 𝐄
φ 𝐅-in-𝐄    = ◅ (η (inj-𝐅 φ))

_𝐗-in-𝐄     : 𝐗 → 𝐄
χ 𝐗-in-𝐄    = ◅ (η (inj-𝐗 χ))

null-in-𝐄   : 𝐄
null-in-𝐄   = ◅ (η (inj-𝐌 (η null)))

unspecified-in-𝐄  : 𝐄
unspecified-in-𝐄  = ◅ (η (inj-𝐌 (η unspecified)))

\end{code}
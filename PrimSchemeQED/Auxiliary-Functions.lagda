\begin{code}

module PrimSchemeQED.Auxiliary-Functions where

open import PrimSchemeQED.Domain-Notation
open import PrimSchemeQED.Domain-Equations
open import PrimSchemeQED.Abstract-Syntax -- using (Dat; Ide; Exp)

open import Data.Nat.Base
  using (NonZero; pred) public

-- 7.2.4. Auxiliary functions

postulate _==ᴵ_ : Ide → Ide → Bool

_[_/_] : 𝐔 → 𝐋 → Ide → 𝐔
ρ [ α / I ] = ◅ λ I′ → if I ==ᴵ I′ then α else ▻ ρ I′

extends : 𝐔 → Ide ⋆′ → 𝐋 ⋆ → 𝐔
extends = fix λ extends′ →
  λ ρ I⋆′ α⋆ →
    η (#′ I⋆′ == 0) ⟶ ρ ,
      ( ( ( (λ I → λ I⋆′′ →
              extends′ (ρ [ (α⋆ ↓ 1) / I ]) I⋆′′ (α⋆ † 1)) ♯)
          (I⋆′ ↓′ 1)) ♯) (I⋆′ †′ 1)

postulate
  new : 𝐒 → 𝐋

postulate
  _==ᴸ_ : 𝐋 → 𝐋 → 𝐓

_[_/_]′ : 𝐒 → 𝐄 → 𝐋 → 𝐒
σ [ z / α ]′ = ◅ λ α′ → (α ==ᴸ α′) ⟶ z , ▻ σ α′

tievals : (𝐋 ⋆ → 𝐂) → 𝐄 ⋆ → 𝐂
tievals = fix λ tievals′ →
  λ ψ ϵ⋆ → ◅ λ σ →
    (# ϵ⋆ ==⊥ 0) ⟶ ▻ (ψ ⟨⟩) σ ,
      (▻ (tievals′ (λ α⋆ → ψ (⟨ new σ ⟩ § α⋆)) (ϵ⋆ † 1))
      (σ [ (ϵ⋆ ↓ 1) / new σ ]′))

truish : 𝐄 → 𝐓
-- truish = λ ϵ → ϵ = false ⟶ false , true
truish = λ ϵ → (is-not-false ♯) (▻ ϵ) where
  is-not-false : (𝐐 ⊎ 𝐓 ⊎ 𝐑 ⊎ 𝐏 ⊎ 𝐌 ⊎ 𝐅 ⊎ 𝐃 ⊎ 𝐗) → 𝐓
  is-not-false (inj-𝐓 τ)  = ((λ { false → η false ; _ → η true }) ♯) (τ)
  is-not-false (inj₁ _)   = η true
  is-not-false (inj₂ _)   = η true
\end{code}
\clearpage
\begin{code}
cons : 𝐄 ⋆ → (𝐄 → 𝐂) → 𝐂
cons =
  λ ϵ⋆ κ → ◅ λ σ →
    (λ σ′ → ▻ (κ ((new σ , new σ′) 𝐏-in-𝐄))
                      (σ′ [ (ϵ⋆ ↓ 2)/ new σ′ ]′))
    (σ [ (ϵ⋆ ↓ 1) / new σ ]′)

list : 𝐄 ⋆ → (𝐄 → 𝐂) → 𝐂
list = fix λ list′ →
  λ ϵ⋆ κ →
    (# ϵ⋆ ==⊥ 0) ⟶ κ (◅ (η (inj-𝐌 (η null)))) ,
      list′ (ϵ⋆ † 1) (λ ϵ → cons ⟨ (ϵ⋆ ↓ 1) , ϵ ⟩ κ)

-- For use in the denotation of (eval expression ...):

-- datum ϵ κ maps the object ϵ representing the Dat Δ to Δ

datum : 𝐄 → (𝐄 → 𝐂) → 𝐂
datum = fix λ datum′ → 
  λ ϵ κ → ◅ λ σ →  ▻ (
    (ϵ ∈𝐏) ⟶ 
       datum′ (▻ σ (ϵ |𝐏 ↓1)) (λ ϵ₁ →
          datum′ (▻ σ (ϵ |𝐏 ↓2)) (λ ϵ₂ →
            κ (η (dat-cons ((id ♯) (ϵ₁ |𝐃)) ((id ♯) (ϵ₂ |𝐃))) 𝐃-in-𝐄))) ,
      κ (f ((id ♯) (▻ ϵ)) 𝐃-in-𝐄)
    ) σ
  where
    dat-cons : Dat → Dat → Dat
    dat-cons Δ₀ ⦅ Δ⋆ ⦆ = ⦅ (Δ₀ ::′ Δ⋆) ⦆
    dat-cons Δ₀ Δ₁ = ⦅ (1 , Δ₀) · Δ₁ ⦆
    f : (𝐐 ⊎ 𝐓 ⊎ 𝐑 ⊎ 𝐏 ⊎ 𝐌 ⊎ 𝐅 ⊎ 𝐃 ⊎ 𝐗) → 𝐃
    f (inj-𝐐 γ)  = η (ide I′) where I′ = (id ♯) γ
    f (inj-𝐓 τ)  = η (con (if b then #t else #f)) where b = (id ♯) τ
    f (inj-𝐑 ζ)  = η (con (int Z′)) where Z′ = (id ♯) ζ
    f (inj-𝐏 π)  = ⊥
    f (inj-𝐌 μ)  with (id ♯) μ
    f (inj-𝐌 μ)     | null  = η ( ⦅ 0 , [] ⦆ )
    f (inj-𝐌 μ)     | _     = ⊥
    f (inj-𝐅 φ)  = ⊥
    f (inj-𝐃 δ)  = δ
    f (inj-𝐗 χ)  = η (key X′) where X′ = (id ♯) χ    
\end{code}
\clearpage
\begin{code}
-- exp Δ maps Δ : Dat to an expression, returning the illegal ⦅␣⦆
-- when Δ does not represent a valid expression

exp : Dat → Exp

exps : ∀ {n} → Dat ^ n → Exp ^ n

ides : ∀ {n} → Dat ^ n → Ide ^ n

-- exp : Dat → Exp

exp (con K) = con K

exp (ide I) = ide I

exp ( ′ Δ ) =
  ⦅quote Δ ⦆

exp ⦅ 2 , key quote′ , Δ ⦆ =
  ⦅quote Δ ⦆

exp ⦅ 3 , key lambda , ⦅ m , I⋆ ⦆ , Δ₀ ⦆ =
  ⦅lambda␣⦅ m , ides I⋆ ⦆ exp Δ₀ ⦆

exp ⦅ 4 , key if , Δ₀ , Δ₁ , Δ₂ ⦆ =
  ⦅if exp Δ₀ ␣ exp Δ₁ ␣ exp Δ₂ ⦆

exp ⦅ 3 , key set! , ide I , Δ ⦆ =
  ⦅set! I ␣ exp Δ ⦆

exp ⦅ suc (suc n) , ide I , Δ⋆ ⦆ =
  ⦅ ide I ␣ (suc n , exps Δ⋆) ⦆

exp _ = ⦅␣⦆

-- exps : ∀ {n} → Dat ^ n → Exp ^ n

exps {0} _ = []

exps {1} Δ = exp Δ

exps {suc (suc n)} (Δ , Δ⋆) = (exp Δ , exps Δ⋆)

-- ides : ∀ {n} → Dat ^ n → Ide ^ n

ides {0} _ = []

ides {1} (ide I) = I

ides {1} _ = "?"

ides {suc (suc n)} (ide I , Δ⋆) = (I , ides Δ⋆)

ides {suc (suc n)} ( _ , Δ⋆) = ("?" , ides Δ⋆)

\end{code} 
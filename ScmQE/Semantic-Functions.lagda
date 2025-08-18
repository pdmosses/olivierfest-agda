\begin{code}
module ScmQE.Semantic-Functions where

open import Notation
open import ScmQE.Abstract-Syntax
open import ScmQE.Domain-Equations
open import ScmQE.Auxiliary-Functions

𝒦⟦_⟧    : Con → 𝐄
𝒟⟦_⟧    : Dat → (𝐄 → 𝐂) → 𝐂
𝒟⋆⟦_⟧   : Dat⋆ → (𝐄 → 𝐂) → 𝐂
𝒟⁺⟦_⟧   : Dat⁺ → 𝐄 → (𝐄 → 𝐂) → 𝐂

ℰ⟦_⟧    : Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂
ℰ⋆⟦_⟧   : Exp⋆ → 𝐔 → (𝐄⋆ → 𝐂) → 𝐂
ℱ_⟦_⟧   : (Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂) → Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂
ℱ⋆_⟦_⟧  : (Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂) → Exp⋆ → 𝐔 → (𝐄 ⋆ → 𝐂) → 𝐂

ℬ⟦_⟧    : Body → 𝐔 → (𝐔 → 𝐂) → 𝐂
ℬ⁺⟦_⟧   : Body⁺ → 𝐔 → (𝐔 → 𝐂) → 𝐂
𝒫⟦_⟧    : Prog → 𝐀

-- Constant denotations 𝒦⟦ K ⟧ : 𝐄

𝒦⟦ int Z ⟧  = η Z 𝐑-in-𝐄
𝒦⟦ #t ⟧     = η true 𝐓-in-𝐄
𝒦⟦ #f ⟧     = η false 𝐓-in-𝐄

-- Datum denotations 𝒟⟦ Δ ⟧ : (𝐄 → 𝐂) → 𝐂

𝒟⟦ con K ⟧ κ        = κ(𝒦⟦ K ⟧)
𝒟⟦ ide I ⟧ κ        = κ(η I 𝐐-in-𝐄)
𝒟⟦ key X ⟧ κ        = κ(η X 𝐗-in-𝐄)
𝒟⟦ ′ Δ ⟧ κ          = 𝒟⟦ Δ ⟧ κ
𝒟⟦ ⦅ Δ⋆ ⦆ ⟧ κ       = 𝒟⋆⟦ Δ⋆ ⟧ κ
𝒟⟦ ⦅ Δ⁺ · Δ ⦆ ⟧ κ   = 𝒟⟦ Δ ⟧ (λ ϵ → 𝒟⁺⟦ Δ⁺ ⟧ ϵ κ)
𝒟⟦ #proc ⟧ κ        = ⊥

-- Datum sequence denotations 𝒟⋆⟦ Δ⋆ ⟧ : (𝐄 → 𝐂) → 𝐂

𝒟⋆⟦ ␣␣␣ ⟧ κ = κ (η null 𝐌-in-𝐄)

𝒟⋆⟦ Δ₁ ␣␣ Δ⋆ ⟧ κ =
  𝒟⟦ Δ₁ ⟧ (λ ϵ₁ →
    𝒟⋆⟦ Δ⋆ ⟧ (λ ϵ →
      cons ⟨ ϵ₁ , ϵ ⟩ κ))

-- Datum prefix sequence denotations 𝒟⁺⟦ Δ⁺ ⟧ : 𝐄 → (𝐄 → 𝐂) → 𝐂

𝒟⁺⟦ ␣␣ Δ₁ ⟧ ϵ κ =
  𝒟⟦ Δ₁ ⟧ (λ ϵ₁ →
    cons ⟨ ϵ₁ , ϵ ⟩ κ)

𝒟⁺⟦ Δ⁺ ␣␣ Δ₁ ⟧ ϵ κ =
  𝒟⟦ Δ₁ ⟧ (λ ϵ₁ →
    cons ⟨ ϵ₁ , ϵ ⟩ (λ ϵ′ →
    𝒟⁺⟦ Δ⁺ ⟧ ϵ′ κ))
\end{code}
\clearpage
\begin{code}
-- Fixed expression denotations ℰ⟦ E ⟧ : 𝐔 → (𝐄 → 𝐂) → 𝐂

ℰ⟦ E ⟧ = ℱ (fix ℱ_⟦_⟧) ⟦ E ⟧

-- Fixed expression sequence denotations ℰ⋆⟦_⟧  : Exp⋆ → 𝐔 → (𝐄⋆ → 𝐂) → 𝐂

ℰ⋆⟦ E⋆ ⟧ = ℱ⋆ (fix ℱ_⟦_⟧) ⟦ E⋆ ⟧

-- Expression denotations ℱ ℰ′ ⟦ E ⟧ : 𝐔 → (𝐄 → 𝐂) → 𝐂

ℱ ℰ′ ⟦ con K ⟧ ρ κ = κ (𝒦⟦ K ⟧)

ℱ ℰ′ ⟦ ide I ⟧ ρ κ = hold (ρ I) κ

ℱ ℰ′ ⟦ ⦅ E ␣ E⋆ ⦆ ⟧ ρ κ =
  ℱ ℰ′ ⟦ E ⟧ ρ (λ ϵ →
    ℱ⋆ ℰ′ ⟦ E⋆ ⟧ ρ (λ ϵ⋆ →
      (ϵ |-𝐅) ϵ⋆ κ))

ℱ ℰ′ ⟦ ⦅lambda I ␣ E ⦆ ⟧ ρ κ =
  κ (  (λ ϵ⋆ κ′ →
          list ϵ⋆ (λ ϵ → 
            alloc ϵ (λ α →
              ℱ ℰ′ ⟦ E ⟧ (ρ [ α / I ]) κ′))
       ) 𝐅-in-𝐄)

ℱ ℰ′ ⟦ ⦅if E ␣ E₁ ␣ E₂ ⦆ ⟧ ρ κ =
  ℱ ℰ′ ⟦ E ⟧ ρ (λ ϵ →
    truish ϵ ⟶ ℱ ℰ′ ⟦ E₁ ⟧ ρ κ , ℱ ℰ′ ⟦ E₂ ⟧ ρ κ)

ℱ ℰ′ ⟦ ⦅set! I ␣ E ⦆ ⟧ ρ κ =
  ℱ ℰ′ ⟦ E ⟧ ρ (λ ϵ →
    assign (ρ I) ϵ (
      κ (η unspecified 𝐌-in-𝐄)))

ℱ ℰ′ ⟦ ⦅quote Δ ⦆ ⟧ ρ κ = 𝒟⟦ Δ ⟧ κ

ℱ ℰ′ ⟦ ⦅eval E ⦆ ⟧ ρ κ =
  ℱ ℰ′ ⟦ E ⟧ ρ (λ ϵ →
    datum ϵ (λ Δ → ℰ′ (exp⟦ Δ ⟧) nullenv κ))

ℱ ℰ′ ⟦ ⦅␣⦆ ⟧ ρ κ = ⊥

-- Expression sequence denotations ℱ⋆ ℰ′ ⟦ E⋆ ⟧ : 𝐔 → (𝐄⋆ → 𝐂) → 𝐂

ℱ⋆ ℰ′ ⟦ ␣␣␣ ⟧ ρ κ = κ ⟨⟩

ℱ⋆ ℰ′ ⟦ E ␣␣ E⋆ ⟧ ρ κ =
  ℱ ℰ′ ⟦ E ⟧ ρ (λ ϵ →
    ℱ⋆ ℰ′ ⟦ E⋆ ⟧ ρ (λ ϵ⋆ →
      κ (⟨ ϵ ⟩ § ϵ⋆)))
\end{code}
\clearpage
\begin{code}
-- Body denotations ℬ⟦ B ⟧ : 𝐔 → (𝐔 → 𝐂) → 𝐂

ℬ⟦ ␣␣ E ⟧ ρ κ = ℰ⟦ E ⟧ ρ (λ ϵ → κ ρ)

ℬ⟦ ⦅define I ␣ E ⦆ ⟧ ρ κ =
  ℰ⟦ E ⟧ ρ (λ ϵ → (ρ I ==ᴸ unknown) ⟶ 
                      alloc ϵ (λ α → κ (ρ [ α / I ])),
                    assign (ρ I) ϵ (κ ρ))

ℬ⟦ ⦅begin B⁺ ⦆ ⟧ ρ κ = ℬ⁺⟦ B⁺ ⟧ ρ κ

-- Body sequence denotations ℬ⁺⟦ B⁺ ⟧ : 𝐔 → (𝐔 → 𝐂) → 𝐂

ℬ⁺⟦ ␣␣ B ⟧ ρ κ = ℬ⟦ B ⟧ ρ κ

ℬ⁺⟦ B ␣␣ B⁺ ⟧ ρ κ = ℬ⟦ B ⟧ ρ (λ ρ′ → ℬ⁺⟦ B⁺ ⟧ ρ′ κ)

-- Program denotations 𝒫⟦ Π ⟧ : 𝐀

𝒫⟦ ␣␣␣ ⟧ = finished initial-store

𝒫⟦ ␣␣ B⁺ ⟧ = ℬ⁺⟦ B⁺ ⟧ nullenv (λ ρ → finished) initial-store
\end{code}
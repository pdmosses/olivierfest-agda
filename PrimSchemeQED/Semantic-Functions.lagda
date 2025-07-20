\begin{code}

module PrimSchemeQED.Semantic-Functions where

open import PrimSchemeQED.Domain-Notation
open import PrimSchemeQED.Abstract-Syntax
open import PrimSchemeQED.Domain-Equations
open import PrimSchemeQED.Auxiliary-Functions

-- 7.2.3. Semantic functions

-- Constant denotations

𝒦⟦_⟧ : Con → 𝐄

𝒦⟦ int Z  ⟧ = (η Z) 𝐑-in-𝐄
𝒦⟦ #t     ⟧ = (η true) 𝐓-in-𝐄
𝒦⟦ #f     ⟧ = (η false) 𝐓-in-𝐄

-- Datum denotations

𝒟⟦_⟧    : Dat → (𝐄 → 𝐂) → 𝐂
𝒟⋆⟦_⟧   : Dat ⋆′ → (𝐄 → 𝐂) → 𝐂

-- 𝒟⟦_⟧   : Dat → (𝐄 → 𝐂) → 𝐂

𝒟⟦ con K       ⟧  = λ κ → κ(𝒦⟦ K ⟧)
𝒟⟦ ide I       ⟧  = λ κ → κ((η I) 𝐐-in-𝐄)
𝒟⟦ key X       ⟧  = λ κ → κ((η X) 𝐗-in-𝐄)
𝒟⟦ ′ Δ         ⟧  = 𝒟⟦ Δ ⟧ 
𝒟⟦ ⦅ Δ⋆ ⦆      ⟧  = 𝒟⋆⟦ Δ⋆ ⟧ 
𝒟⟦ ⦅ Δ⋆ · Δ ⦆  ⟧  = λ κ →
  𝒟⋆⟦ Δ⋆ ⟧ (λ ϵ₀ →
    𝒟⟦ Δ ⟧  (λ ϵ₁ →
      cons ⟨ ϵ₀ , ϵ₁ ⟩ κ))

-- 𝒟⋆⟦_⟧  : Dat ⋆′ → (𝐄 → 𝐂) → 𝐂

𝒟⋆⟦ 0 , _  ⟧  = λ κ → κ null-in-𝐄

𝒟⋆⟦ 1 , Δ  ⟧  = λ κ →
  𝒟⟦ Δ ⟧ (λ ϵ →
      cons ⟨ ϵ , null-in-𝐄 ⟩ κ)

𝒟⋆⟦ suc (suc n) , Δ , Δ⋆ ⟧ = λ κ →
  𝒟⟦ Δ ⟧ (λ ϵ₀ →
    𝒟⋆⟦ suc n , Δ⋆ ⟧ (λ ϵ₁ →
      cons ⟨ ϵ₀ , ϵ₁ ⟩ κ))
\end{code}
\clearpage
\begin{code}
-- Expression denotations

ℰ_⟦_⟧   : (Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂) → Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂
ℰ⋆_⟦_⟧  : (Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂) → Exp ⋆′ → 𝐔 → (𝐄 ⋆ → 𝐂) → 𝐂

-- ℰ_⟦_⟧   : Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂

ℰ ℰ′ ⟦ con K ⟧ = λ ρ κ → κ (𝒦⟦ K ⟧)

ℰ ℰ′ ⟦ ide I ⟧ = λ ρ κ →
  ◅ λ σ → ▻ (κ (▻ σ (▻ ρ I))) σ

ℰ ℰ′ ⟦ ⦅ E₀ ␣ E⋆ ⦆ ⟧ = λ ρ κ →
  ℰ ℰ′ ⟦ E₀ ⟧ ρ (λ ϵ₀ →
    ℰ⋆ ℰ′ ⟦ E⋆ ⟧ ρ (λ ϵ⋆ →
      ▻ (ϵ₀ |𝐅) ϵ⋆ κ))

ℰ ℰ′ ⟦ ⦅lambda␣⦅ I⋆ ⦆ E₀ ⦆ ⟧ = λ ρ κ →
  κ (◅ ( λ ϵ⋆ κ′ →
          tievals
            (λ α⋆ → ℰ ℰ′ ⟦ E₀ ⟧ (extends ρ I⋆ α⋆) κ′)
            ϵ⋆
        ) 𝐅-in-𝐄)

ℰ ℰ′ ⟦ ⦅if E₀ ␣ E₁ ␣ E₂ ⦆ ⟧ = λ ρ κ → 
  ℰ ℰ′ ⟦ E₀ ⟧ ρ (λ ϵ →
    truish ϵ ⟶ ℰ ℰ′ ⟦ E₁ ⟧ ρ κ ,
      ℰ ℰ′ ⟦ E₂ ⟧ ρ κ)

ℰ ℰ′ ⟦ ⦅set! I ␣ E ⦆ ⟧ = λ ρ κ →
  ℰ ℰ′ ⟦ E ⟧ ρ (λ ϵ →
    ◅ λ σ → ▻ (κ unspecified-in-𝐄) (σ [ ϵ / (▻ ρ I) ]′))

ℰ ℰ′ ⟦ ⦅quote Δ ⦆ ⟧ = λ ρ κ → 𝒟⟦ Δ ⟧ κ

ℰ ℰ′ ⟦ ′ Δ ⟧ = λ ρ κ → 𝒟⟦ Δ ⟧ κ

ℰ ℰ′ ⟦ ⦅eval E ⦆ ⟧ = λ ρ κ →
  ℰ ℰ′ ⟦ E ⟧ ρ (λ ϵ →
    datum ϵ (λ ϵ′ →
      (λ E′ →  ℰ′ E′ ρ κ) ((exp ♯) (ϵ′ |𝐃))))

ℰ ℰ′ ⟦ ⦅␣⦆ ⟧ = λ ρ κ → ⊥

-- ℰ⋆_⟦_⟧  : Exp ⋆′ → 𝐔 → (𝐄 ⋆ → 𝐂) → 𝐂

ℰ⋆ ℰ′ ⟦ 0 , _ ⟧  = λ ρ κ → κ ⟨⟩

ℰ⋆ ℰ′ ⟦ 1 , E ⟧  = λ ρ κ →
  ℰ ℰ′ ⟦ E ⟧ ρ (λ ϵ → κ ⟨ ϵ ⟩ )

ℰ⋆ ℰ′ ⟦ suc (suc n) , E , Es ⟧ = λ ρ κ →
  ℰ ℰ′ ⟦ E ⟧ ρ (λ ϵ₀ →
    ℰ⋆ ℰ′ ⟦ suc n , Es ⟧ ρ (λ ϵ⋆ →
      κ (⟨ ϵ₀ ⟩ § ϵ⋆)))

-- Program denotations

𝒫⟦_⟧ : Exp → 𝐔 → (𝐄 → 𝐂) → 𝐂

𝒫⟦ E ⟧ = ℰ (fix ℰ_⟦_⟧) ⟦ E ⟧

\end{code} 
\begin{code}
module ScmQE.Auxiliary-Functions where

open import Notation
open import ScmQE.Abstract-Syntax
open import ScmQE.Domain-Equations

-- Environments ρ : 𝐔 = Ide → 𝐋

postulate _==_ : Ide → Ide → Bool

_[_/_] : 𝐔 → 𝐋 → Ide → 𝐔
ρ [ α / I ] = λ I′ → η (I == I′) ⟶ α , ρ I′

postulate unknown : 𝐋
-- ρ I = unknown represents the lack of a binding for I in ρ

postulate nullenv : 𝐔
-- nullenv shoud include various procedures and values

-- Stores σ : 𝐒 = 𝐋 → 𝐄

_[_/_]′ : 𝐒 → 𝐄 → 𝐋 → 𝐒
σ [ ϵ / α ]′ = λ α′ → (α ==ᴸ α′) ⟶ ϵ , σ α′

assign : 𝐋 → 𝐄 → 𝐂 → 𝐂
assign = λ α ϵ θ σ → θ (σ [ ϵ / α ]′)

hold : 𝐋 → (𝐄 → 𝐂) → 𝐂
hold = λ α κ σ → κ (σ α) σ

postulate new : (𝐋 → 𝐂) → 𝐂
-- new κ σ = κ α σ′ where σ α = unallocated, σ′ α ≠ unallocated

alloc : 𝐄 → (𝐋 → 𝐂) → 𝐂
alloc = λ ϵ κ → new (λ α → assign α ϵ (κ α))
-- should be ⊥ when ϵ |-𝐌 == unallocated

initial-store : 𝐒
initial-store = λ α → η unallocated 𝐌-in-𝐄

postulate finished : 𝐂
-- normal termination with answer depending on final store

truish : 𝐄 → 𝐓
truish =
  λ ϵ → (ϵ ∈-𝐓) ⟶
      (((ϵ |-𝐓) ==ᵀ η false) ⟶ η false , η true) ,
    η true
\end{code}
\clearpage
\begin{code}
-- Lists

cons : 𝐅
cons =
  λ ϵ⋆ κ →
      (# ϵ⋆ ==⊥ 2) ⟶ alloc (ϵ⋆ ↓ 1) (λ α₁ →
                        alloc (ϵ⋆ ↓ 2) (λ α₂ →
                          κ ((α₁ , α₂) 𝐏-in-𝐄))) , 
    ⊥

list : 𝐅
list = fix λ list′ →
  λ ϵ⋆ κ →
    (# ϵ⋆ ==⊥ 0) ⟶ κ (η null 𝐌-in-𝐄) ,
      list′ (ϵ⋆ † 1) (λ ϵ → cons ⟨ (ϵ⋆ ↓ 1) , ϵ ⟩ κ)

car : 𝐅
car =
  λ ϵ⋆ κ → (# ϵ⋆ ==⊥ 1) ⟶ hold ((ϵ⋆ ↓ 1) |-𝐏 ↓1) κ , ⊥

cdr : 𝐅
cdr =
  λ ϵ⋆ κ → (# ϵ⋆ ==⊥ 1) ⟶ hold ((ϵ⋆ ↓ 1) |-𝐏 ↓2) κ , ⊥

setcar : 𝐅
setcar =
  λ ϵ⋆ κ →
      (# ϵ⋆ ==⊥ 2) ⟶ assign  ((ϵ⋆ ↓ 1) |-𝐏 ↓1)
                             (ϵ⋆ ↓ 2)
                             (κ (η unspecified 𝐌-in-𝐄)) , 
    ⊥

setcdr : 𝐅
setcdr =
  λ ϵ⋆ κ →
      (# ϵ⋆ ==⊥ 2) ⟶ assign  ((ϵ⋆ ↓ 1) |-𝐏 ↓2)
                             (ϵ⋆ ↓ 2)
                             (κ (η unspecified 𝐌-in-𝐄)) , 
    ⊥
\end{code}
\clearpage
\begin{code}
-- datum prefix pre⟦ Δ ⟧ : Dat

pre⟦_⟧ : Dat → Dat

pre⟦ ⦅ ␣␣ Δ · ⦅ Δ⋆ ⦆ ⦆ ⟧ = ⟦ ⦅ Δ ␣␣ Δ⋆ ⦆ ⟧
-- otherwise:
pre⟦ Δ ⟧ = ⟦ Δ ⟧

-- datum ϵ κ applies κ to the datum represented by the value ϵ
datum : 𝐄 → (Dat → 𝐂) → 𝐂
datum = fix λ datum′ → 
  λ ϵ κ →
    (ϵ ∈-𝐓) ⟶
      ((ϵ |-𝐓) ⟶ κ ⟦ con #t ⟧ , κ ⟦ con #f ⟧) ,
    (ϵ ∈-𝐑) ⟶
      ((λ Z → κ ⟦ con (int Z) ⟧) ♯) (ϵ |-𝐑) ,
    (ϵ ∈-𝐏) ⟶ 
      car ⟨ ϵ ⟩ (λ ϵ₁ → cdr ⟨ ϵ ⟩ (λ ϵ₂ →
        datum′ ϵ₁ (λ Δ₁ → datum′ ϵ₂ (λ Δ₂ →
          κ pre⟦ ⦅ ␣␣ Δ₁ · Δ₂ ⦆ ⟧)))) ,
    (ϵ ∈-𝐌) ⟶ 
      (((ϵ |-𝐌) ==ᴹ η null) ⟶ κ ⟦ ⦅ ␣␣␣ ⦆ ⟧  , ⊥) ,
    (ϵ ∈-𝐅) ⟶ 
      κ ⟦ #proc ⟧ ,
    (ϵ ∈-𝐐) ⟶ 
      ((λ I → κ ⟦ ide I ⟧) ♯) (ϵ |-𝐐) ,
    (ϵ ∈-𝐗) ⟶ 
      ((λ X → κ ⟦ key X ⟧) ♯) (ϵ |-𝐗) ,
    ⊥
\end{code}
\clearpage
\begin{code}
-- mapping datum terms to expressions

exp⟦_⟧   : Dat → Exp
exp⋆⟦_⟧  : Dat⋆ → Exp⋆

-- datum expressions exp⟦ Δ ⟧ : Exp

exp⟦ con K ⟧  = ⟦ con K ⟧

exp⟦ ide I ⟧  = ⟦ ide I ⟧

exp⟦ ′ Δ ⟧    = ⟦ ⦅quote Δ ⦆ ⟧

exp⟦ ⦅ key quote′ ␣␣ Δ ␣␣ ␣␣␣ ⦆ ⟧ = ⟦ ⦅quote Δ ⦆ ⟧

exp⟦ ⦅ key lambda ␣␣ ide I ␣␣ Δ ␣␣ ␣␣␣ ⦆ ⟧ =
  ⟦ ⦅lambda I ␣ exp⟦ Δ ⟧ ⦆ ⟧

exp⟦ ⦅ key if ␣␣ Δ ␣␣ Δ₁ ␣␣ Δ₂ ␣␣ ␣␣␣ ⦆ ⟧ =
      ⟦ ⦅if exp⟦ Δ ⟧ ␣ exp⟦ Δ₁ ⟧ ␣ exp⟦ Δ₂ ⟧ ⦆ ⟧

exp⟦ ⦅ key set! ␣␣ ide I ␣␣ Δ ␣␣ ␣␣␣ ⦆ ⟧ =
  ⟦ ⦅set! I ␣ exp⟦ Δ ⟧ ⦆ ⟧

exp⟦ ⦅ ide I ␣␣ Δ⋆ ⦆ ⟧ =
  ⟦ ⦅ ide I ␣ exp⋆⟦ Δ⋆ ⟧ ⦆ ⟧

exp⟦ _ ⟧ = ⟦ ⦅␣⦆ ⟧

-- datum sequence expressions exp⋆⟦ Δ⋆ : Exp⋆

exp⋆⟦ ␣␣␣ ⟧ = ⟦ ␣␣␣ ⟧

exp⋆⟦ Δ ␣␣ Δ⋆ ⟧ = ⟦ exp⟦ Δ ⟧ ␣␣ exp⋆⟦ Δ⋆ ⟧ ⟧
\end{code}
\begin{code}
{-# OPTIONS --rewriting --confluence-check #-}

open import Agda.Builtin.Equality
open import Agda.Builtin.Equality.Rewrite

module ScmQE.Soundness-Tests where

open import Notation
open import ScmQE.Abstract-Syntax
open import ScmQE.Domain-Equations
open import ScmQE.Auxiliary-Functions
open import ScmQE.Semantic-Functions

open import Relation.Binary.PropositionalEquality.Core
  using (_≡_; refl; cong-app)

postulate
  fix-fix : (f : D → D) → fix f ≡ f (fix f)

fix-app : (f : (A → D) → (A → D)) (a : A) →
            fix f a ≡ f (fix f) a
fix-app f = cong-app (fix-fix f) 

{-# REWRITE fix-app #-}

test-1 : ∀ {K ρ κ} →
  ℰ⟦ con K ⟧ ρ κ ≡ κ (𝒦⟦ K ⟧)
test-1 = refl

test-2 : ∀ {ρ κ} →
  ℰ⟦ ⦅eval con #t ⦆ ⟧ ρ κ ≡
    datum (η true 𝐓-in-𝐄) (λ Δ → (fix ℱ_⟦_⟧) exp⟦ Δ ⟧ nullenv κ)
test-2 = refl
\end{code}
\clearpage
\begin{code}
a b c d e : Dat
a = ide "a"
b = ide "b"
c = ide "c"
d = ide "d"
e = ide "e"

-- R7RS §6.4

-- (a b c d e) and (a . (b . (c . (d . (e . ()))))) are equivalent
test-proper-list :
  𝒟⟦ ⦅ a ␣␣ b ␣␣ c ␣␣ d ␣␣ e ␣␣ ␣␣␣ ⦆ ⟧ ≡
  𝒟⟦ ⦅ ␣␣ a · ⦅ ␣␣ b · ⦅ ␣␣ c · ⦅ ␣␣ d ·  ⦅ ␣␣ e ·  ⦅ ␣␣␣ ⦆ ⦆ ⦆ ⦆ ⦆ ⦆ ⟧
test-proper-list = refl

-- (a b c . d) is equivalent to (a . (b . (c . d)))
test-improper-list :
  𝒟⟦ ⦅ (((␣␣ a) ␣␣ b) ␣␣ c) · d ⦆ ⟧ ≡
  𝒟⟦ ⦅ ␣␣ a · ⦅ ␣␣ b · ⦅ ␣␣ c · d ⦆ ⦆ ⦆ ⟧
test-improper-list = refl
\end{code}
\begin{code}

module PrimSchemeQED.Abstract-Syntax where

open import PrimSchemeQED.Domain-Notation
  using (_⋆′)

open import Data.Bool.Base
  using (Bool)
open import Data.Integer.Base
  renaming (ℤ to Int)
open import Data.String.Base
  using (String)

-- 7.2.1. Abstract syntax

data Con  : Set     -- constants, *excluding* quotations
Ide       = String  -- identifiers (variables)
data Key  : Set     -- keywords
data Dat  : Set     -- external representations
data Exp  : Set     -- expressions

data Con where
  int : Int → Con
  #t  : Con
  #f  : Con

data Key where
  quote′  : Key
  lambda  : Key
  if      : Key
  set!    : Key
  eval    : Key

data Dat where   
  con    : Con → Dat           -- constants
  ide    : Ide → Dat           -- symbols
  key    : Key → Dat           -- keyword
  ′      : Dat → Dat           -- 'Δ
  ⦅_⦆    : Dat ⋆′ → Dat        -- lists (Δ⋆)
  ⦅_·_⦆  : Dat ⋆′ → Dat → Dat  -- pairs (Δ⋆.Δ)

data Exp where
  con            : Con → Exp              -- K
  ide            : Ide → Exp              -- I
  ⦅_␣_⦆          : Exp → Exp ⋆′ → Exp     -- (E₀ E⋆′)
  ⦅lambda␣⦅_⦆_⦆  : Ide ⋆′ → Exp → Exp     -- (lambda (I⋆′) E₀)
  ⦅if_␣_␣_⦆      : Exp → Exp → Exp → Exp  -- (if E₀ E₁ E₂)
  ⦅set!_␣_⦆      : Ide → Exp → Exp        -- (set! I E)
  ⦅quote_⦆       : Dat → Exp              -- (quote Δ)
  ′              : Dat → Exp              -- ′ Δ
  ⦅eval_⦆        : Exp → Exp              -- (eval E)
  ⦅␣⦆            : Exp                    -- illegal

variable
  Z   : Int
  K   : Con
  I   : Ide
  I⋆  : Ide ⋆′
  X   : Key
  E   : Exp
  E⋆  : Exp ⋆′
  Δ   : Dat
  Δ⋆  : Dat ⋆′

\end{code}
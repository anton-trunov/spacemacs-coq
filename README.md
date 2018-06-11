# Coq Spacemacs layer

Adds support for Coq via [Proof General](https://github.com/ProofGeneral/PG) and [company-coq](https://github.com/cpitclaudel/company-coq).

## Installation

To install, run
```git clone https://github.com/tchajed/spacemacs-coq ~/.emacs.d/private/coq```
and add `coq` to your `dotspacemacs-configuration-layers` list.

## Shortcuts

This layer adds Spacemacs-style shortcuts for the most useful parts of Proof General and company-coq's functionality.

### Proof management

Key Binding  | Description
-----------  | -----------
`<f4>`, `,.` | Go to point
`<f3>`, `,n` | Process next command
`<f2>`, `,u` | Undo previous command

### Laying out windows

Key Binding  | Description
-----------  | -----------
`,ll`        | Re-layout windows
`,lc`        | Clear response buffer
`,lp`        | Show current proof

### Managing prover process

Key Binding  | Description
-----------  | -----------
`,pi`        | Interrupt prover
`,px`        | Quit prover
`,pr`        | Retract buffer - rewinds and moves point to beginning of buffer
`,pb`        | Process buffer - processes and moves point to end of buffer

### Prover queries

The mnemonic for `a` is "ask".

Key Binding  | Description
-----------  | -----------
`,af`        | Search (mnemonic: "find theorems")
`,ap`        | Print
`,ac`        | Check
`,ab`        | About
`,aip`       | Print (showing implicits)
`,aic`       | Check (showing implicits)
`,aib`       | About (showing implicits)
`,aap`       | Print (showing all)
`,aac`       | Check (showing all)
`,aab`       | About (showing all)

### Moving the point

Key Binding  | Description
-----------  | -----------
`,e`         | Go to last processed command
`,d`         | Jump to definition at point
`,ga`        | Go to start of command at point
`,ge`        | Go to end of command at point

### Inserting

Key Binding  | Description
-----------  | -----------
`,il`        | Extract lemma from current goal - exit with `C-RET` (not `C-j`)
`,im`        | Insert `match` on a type
`,ie`        | Insert `End <section-name>`.
`M-RET`      | Insert regular match branch
`M-S-RET`    | Insert `match goal with` branch

It's worth highlighting `,ie`, probably criminally underused due to the default binding of `C-c C-a C-)`.

Note the last two are regular company-coq bindings, left alone since they are most useful in insert mode.

## Note about cursor color

This package forces the insert mode cursor color to match normal mode, to avoid a serious performance problem in Evil where proof navigation in insert mode is extremely slow compared to the same commands in normal mode. See https://github.com/olivierverdier/spacemacs-coq/issues/6 for details.

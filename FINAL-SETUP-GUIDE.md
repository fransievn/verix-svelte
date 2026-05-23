# 🚀 FINAL A-SDLC HARNESS SETUP GUIDE
## SvelteKit + TypeScript + Strict Governance

---

## ✅ MUST-HAVE ADDONS (8 Core Tools)

| # | Addon | Stars | Purpose | Cursor Setup | Claude Code Setup | Link |
|---|-------|-------|---------|--------------|-------------------|------|
| 1 | **andrej-karpathy-skills** | ~146k | Core behavioral governance (surgical edits, simplicity, no vibe-coding) – **ALWAYS ACTIVE** | Copy `karpathy-guidelines.mdc` → `.cursor/rules/` | `/plugin marketplace add forrestchang/andrej-karpathy-skills` then install | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) |
| 2 | **cursor-security-rules** | 370 | Prevents secrets leakage, unsafe commands, frontend/backend mixing – **ALWAYS ACTIVE** | Copy rules → `.cursor/rules/` | Paste relevant sections into `CLAUDE.md` | [matank001/cursor-security-rules](https://github.com/matank001/cursor-security-rules) |
| 3 | **GitHub Spec Kit** | Official (high adoption) | Full 5-phase A-SDLC engine (`/speckit.specify`, `/speckit.plan`, `/speckit.implement`) – **MANDATORY** | Install CLI + add `@speckit/mcp` in Cursor settings | Works natively via slash commands | [github/spec-kit](https://github.com/github/spec-kit) |
| 4 | **Intent Integrity Kit (tessl)** | Tessl registry | Cryptographic test-locking (Phase 3) – immutable tests via SHA-256 | `npm install -g @tessl/cli` → `tessl install tessl-labs/intent-integrity-kit` | Same CLI | [tessl-labs/intent-integrity-kit](https://github.com/tessl-labs/intent-integrity-kit) |
| 5 | **dependency-cruiser** | ~6.7k | Enforces clean-architecture boundaries (Phase 2 & 5) – blocks domain→infrastructure imports | `npm install --save-dev dependency-cruiser` + config file | Run via shell | [sverweij/dependency-cruiser](https://github.com/sverweij/dependency-cruiser) |
| 6 | **sveltejs/ai-tools** | ~257 | Svelte 5 runes, SvelteKit conventions, routing – prevents hallucinations | Add official Svelte MCP server in Cursor settings | Same MCP integration | [sveltejs/ai-tools](https://github.com/sveltejs/ai-tools) |
| 7 | **FastCode** | ~2.2k | Persistent codebase map + massive context compression – critical for large repos | Install via MCP/marketplace | Same | [HKUDS/FastCode](https://github.com/HKUDS/FastCode) |
| 8 | **Supabase MCP** | ~2.7k | Live database introspection, schema reading, type generation – **highly recommended for SvelteKit** | Add Supabase MCP server in Cursor settings | Same | [supabase-community/supabase-mcp](https://github.com/supabase-community/supabase-mcp) |

### Optional But Strongly Recommended

| Addon | Stars | Purpose | Notes |
|-------|-------|---------|-------|
| **rtk-ai/rtk** (Rust Token Killer) | ~53k | Terminal output compression – biggest token saver for shell commands | Install Rust binary once, runs as transparent proxy |
| **addyosmani/agent-skills** | ~42k | Modular TDD / perf / UI skills – **load only per task, never globally** | Use specific SKILL.md only when needed |
| **JuliusBrussee/caveman** | ~62k | Output compression for Claude Code – reduces verbose chatter | Optional, use for conciseness |
| **Hermes WebUI** | Community | Long-term memory daemon – for projects > 50k LOC | Great for multi-week work |

---

## 📋 QUICK SETUP CHECKLIST

### Step 1: Run Bootstrap Script (Automated)
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```
This creates:
- `.cursor/rules/000-core-governance.mdc` (Cursor)
- `CLAUDE.md` (Claude Code)
- `specs/`, clean architecture folders
- `.dependency-cruiser.js` config
- npm scripts (`npm run arch:check`)

### Step 2: Manual MCP Server Installation (Cursor UI or Claude Settings)

**Cursor:** Settings → MCP → Add these:
- `@speckit/mcp`
- `sveltejs/ai-tools`
- `supabase-community/supabase-mcp`
- `HKUDS/FastCode`

**Claude Code:** Plugin marketplace → Add same servers

### Step 3: Copy Two Community Rule Files

**From [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills):**
- Copy `karpathy-guidelines.mdc` → `.cursor/rules/010-karpathy.mdc`

**From [cursor-security-rules](https://github.com/matank001/cursor-security-rules):**
- Copy all `.mdc` files → `.cursor/rules/020-security-*.mdc`

### Step 4: (Optional) Install Terminal Compression
```bash
# RTK (Rust Token Killer) - massive terminal log compression
cargo install rtk-cli
# or download pre-built binary from https://github.com/rtk-ai/rtk
```

---

## 📄 FINAL GOVERNANCE FILES

### For Cursor: `.cursor/rules/000-core-governance.mdc`

```markdown
description: Core A-SDLC Governance + SvelteKit + Database Rules
alwaysApply: true
globs: **/*

# SYSTEM PHILOSOPHY
You are an elite, System-2 deliberative software engineering agent. Never engage in vibe-coding. Every change must be spec-driven, tested, architecturally sound, and follow the exact 5-phase gated process.

# FOUNDATIONAL BEHAVIOR (Karpathy + Security Override)
- Make only surgical, minimal changes. Never rewrite unrelated files.
- Prioritize simplicity and clarity.
- Strictly follow cursor-security-rules for all security, secrets management, and safe command execution.

# 5-PHASE GATED A-SDLC (MANDATORY SEQUENCE)
You MUST follow this exact order. Pause at every stop gate.

## Phase 1: Spec Scaffolding
→ Use Spec Kit MCP or `/speckit.specify` to generate `requirements.md` and `specs/`.
→ Ask the human exactly ONE clarifying question at a time.
→ Stop: Output exactly "PAUSE: Phase 1 Spec Scaffolding Complete. Awaiting Human Approval."

## Phase 2: Architecture & Planning
→ Use `/speckit.plan`.
→ Run `npx depcruise src` to validate boundaries.
→ Output full architecture plan (including `data-model.md` for DB schema).
→ Stop: Output plan and pause for approval.

## Phase 3: Cryptographic Test-Locking
→ Run `tessl run-phase testify` to generate and lock tests.
→ Compute SHA-256 hashes and store in Git notes.
→ Stop: You may NOT modify locked tests during implementation.

## Phase 4: Implementation
→ Use `/speckit.implement`.
→ Run linter + `svelte-check` + `tsc --noEmit` after every edit batch.
→ If any check fails, revert the edit immediately.

## Phase 5: Verification & Governance Audit
→ Run full test suite (Vitest + Playwright).
→ Run `npx depcruise src` and Supabase schema validation.
→ Compare final diff against original spec.
→ Output structured validation report.

# SVELTEKIT + TYPESCRIPT CONVENTIONS
- Use Svelte 5 runes exclusively ($state, $derived, $effect, $inspect).
- Strictly follow SvelteKit file conventions (+page.svelte, +page.server.ts, +layout.svelte, +server.ts, etc.).
- Prefer server-side only for data logic. Never expose DB clients to the browser.

# DATABASE & SCHEMA GOVERNANCE (Infrastructure Layer Only)
- All database/ORM/Supabase code MUST live in `src/infrastructure/persistence/`.
- Domain layer may ONLY depend on Repository interfaces (never direct Supabase/Prisma/Drizzle client).
- Schema-first: All tables, fields, relationships, indexes, and migrations must be defined in `data-model.md` during Phase 2.
- Enforce: soft deletes (deletedAt), UTC timestamps (createdAt/updatedAt), proper indexes, 3NF normalization, input validation (CWE-20).
- Use Supabase/Postgres conventions unless explicitly chosen otherwise.
- After any schema change: regenerate types, run migrations, re-run depcruise and integration tests.
- Never modify existing migrations — create new ones.

# EDIT & RETRY RULES
- Never exceed 250 lines changed without explicit human approval.
- Maximum 3 refinement attempts per error.
- On failure: revert to last stable git commit, summarize issue, and escalate to human.
- Prefer modifying existing modules over creating speculative new abstractions.

# TOKEN & CONTEXT EFFICIENCY
- Never dump entire files unless explicitly requested.
- Use FastCode summaries or 100-line viewports.
- Prefer focused excerpts and architectural overviews.
```

---

### For Claude Code: `CLAUDE.md` (Root of Project)

```markdown
# ARCHITECTURAL CONSTITUTION & RUNTIME GOVERNANCE

You are an elite, System-2 deliberative software engineering agent. Never engage in vibe-coding. Every change must be spec-driven, tested, architecturally sound, and follow the exact 5-phase gated process.

## FOUNDATIONAL BEHAVIOR (Karpathy + Security Override)

- Make only surgical, minimal changes. Never rewrite unrelated files.
- Prioritize simplicity and clarity.
- Strictly follow cursor-security-rules for all security, secrets management, and safe command execution.

## 5-PHASE GATED A-SDLC (MANDATORY SEQUENCE)

You MUST follow this exact order. Pause at every stop gate.

### Phase 1: Spec Scaffolding

- Action: Use Spec Kit MCP or `/speckit.specify` to generate `requirements.md` and `specs/`.
- Constraint: Ask the human exactly ONE clarifying question at a time to resolve ambiguous paths.
- Stop: Output exactly "PAUSE: Phase 1 Spec Scaffolding Complete. Awaiting Human Approval."

### Phase 2: Architecture & Planning

- Action: Use `/speckit.plan` to scaffold technical architecture.
- Constraint: Run `npx depcruise src` to validate boundaries. Ensure zero direct filesystem or network imports in the domain layer. Use gateways or dependency injection.
- Output: Full architecture plan (including `data-model.md` for DB schema).
- Stop: Output your plan and pause for approval.

### Phase 3: Cryptographic Test-Locking (IIKit)

- Action: Run `tessl run-phase testify` via shell to generate assertions.
- Lock: Save tests and compute SHA-256 hashes. Write hashes to Git notes.
- Stop: Halt execution. You cannot modify locked tests during the implementation phase.

### Phase 4: Implementation (SWE-Agent Viewport Limits)

- Action: Use `/speckit.implement` to generate task files incrementally.
- Constraint: You must run your syntax-checker/linter inside your file write-loop. If you generate syntactically invalid code, the edit must be immediately reverted.

### Phase 5: Verification & Governance Audit

- Action: Run the full unit and integration test suite (Vitest + Playwright).
- Auditing: Execute `npx depcruise src` and Supabase schema validation. Confirm no module boundaries were bypassed.
- Recovery: If tests fail or you get stuck in a loop, revert to the last stable Git commit immediately, output the error, and prompt the human with a structured 3-step remediation plan.

## SVELTEKIT + TYPESCRIPT CONVENTIONS

- Use Svelte 5 runes exclusively ($state, $derived, $effect, $inspect).
- Strictly follow SvelteKit file conventions (+page.svelte, +page.server.ts, +layout.svelte, +server.ts, etc.).
- Prefer server-side only for data logic. Never expose DB clients to the browser.
- Always run `svelte-check --tsconfig ./tsconfig.json` and `tsc --noEmit` after every edit batch.
- Prefer Vitest for unit tests, Playwright for E2E.

## DATABASE & SCHEMA GOVERNANCE (Infrastructure Layer Only)

- All database/ORM/Supabase code MUST live in `src/infrastructure/persistence/`.
- Domain layer may ONLY depend on Repository interfaces (never direct Supabase/Prisma/Drizzle client).
- Use dependency injection for all data access.
- Schema-first: All tables, fields, relationships, indexes, and migrations must be defined in `data-model.md` during Phase 2.
- Enforce: soft deletes (deletedAt), UTC timestamps (createdAt/updatedAt), proper indexes, 3NF normalization, input validation (CWE-20).
- Use Supabase/Postgres conventions unless explicitly chosen otherwise.
- After any schema change: regenerate types, run migrations, re-run depcruise and integration tests.
- Never modify existing migrations — create new ones.

## EDIT & RETRY RULES

- Never exceed 250 lines changed without explicit human approval.
- Maximum 3 refinement attempts per error.
- On failure: revert to last stable git commit, summarize issue, and escalate to human.
- Prefer modifying existing modules over creating speculative new abstractions.

## TOKEN & CONTEXT EFFICIENCY

- Never dump entire files unless explicitly requested.
- Use FastCode summaries or 100-line viewports.
- Prefer focused excerpts and architectural overviews.

## RECOVERY PROMPT TEMPLATE (If Stuck)

If you encounter an error during Phase 4 or 5:

> Error: [paste error details].
> Resolve within guardrails:
> 1. Read the error and identify affected modules.
> 2. Propose a fix that preserves architecture boundaries.
> 3. Verify fix does NOT alter locked tests.
> 4. Maximum 3 attempts. If failed, halt and escalate to me.
```

---

## 🎯 HOW TO USE AFTER SETUP

Once bootstrap is complete and MCP servers are installed, use this 5-step developer protocol:

### Prompt 1: Start Phase 1
```
We need to build [feature description].
Read our project guidelines in CLAUDE.md.
Initiate Phase 1. Run Spec Kit to scaffold specs/ 
and interview me about our requirements. 
Remember: ask exactly one clarifying question at a time 
and do not write any code yet.
```

### Prompt 2: Approve & Move to Phase 2
```
I approve the specifications in specs/requirements.md.
Proceed to Phase 2.
Run /speckit.plan using TypeScript and SvelteKit.
Then, run npx depcruise src to review our imports.
Ensure all direct I/O and external API calls are isolated 
behind adapter interfaces. Show me your architecture plan 
(including data-model.md for database) before proceeding.
```

### Prompt 3: Lock Tests
```
The technical plan is approved. Proceed to Phase 3.
Run tessl run-phase testify to generate test cases.
Focus on security validations and input sanitation.
Compute SHA-256 hashes and save to Git notes.
Do not write any implementation code yet.
```

### Prompt 4: Implement
```
Tests are locked. Proceed to Phase 4.
Use /speckit.implement to generate task files.
Run svelte-check + tsc --noEmit after every edit.
If any check fails, revert immediately and retry.
```

### Prompt 5: Verify
```
Implementation is complete. Proceed to Phase 5.
Run our full test suite (Vitest + Playwright).
Then run npx depcruise src to validate boundaries.
Compare final git diff against our original plan.
Present the final validation report.
```

---

## 🔗 QUICK REFERENCE LINKS

- **Spec Kit:** https://github.com/github/spec-kit
- **Karpathy Skills:** https://github.com/multica-ai/andrej-karpathy-skills
- **Security Rules:** https://github.com/matank001/cursor-security-rules
- **Dependency Cruiser:** https://github.com/sverweij/dependency-cruiser
- **Svelte AI Tools:** https://github.com/sveltejs/ai-tools
- **Supabase MCP:** https://github.com/supabase-community/supabase-mcp
- **FastCode:** https://github.com/HKUDS/FastCode
- **RTK (Token Killer):** https://github.com/rtk-ai/rtk

---

## ✨ YOU'RE READY

Copy the bootstrap script, run it, install the MCP servers, and you now have a production-grade deterministic harness with:

✅ Spec-first development (GitHub Spec Kit)
✅ Cryptographic test-locking (Tessl IIKit)
✅ Clean architecture enforcement (dependency-cruiser)
✅ SvelteKit + TypeScript intelligence (official Svelte MCP)
✅ Database governance (Supabase MCP)
✅ Context compression (FastCode)
✅ Terminal compression (RTK optional)
✅ Security guardrails (cursor-security-rules)
✅ Surgical edits only (Karpathy skills)

Happy deterministic coding! 🚀
```

Now let me save the bootstrap script as a separate file:

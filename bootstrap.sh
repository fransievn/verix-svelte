#!/bin/bash
# =============================================================================
# SvelteKit + TypeScript A-SDLC Bootstrap Script
# Creates full deterministic harness with 5-phase gated workflow, clean architecture,
# database governance, and all must-have addons pre-configured.
#
# Usage: chmod +x bootstrap.sh && ./bootstrap.sh
# =============================================================================

set -euo pipefail

echo "🚀 Starting SvelteKit A-SDLC bootstrap..."
echo ""

# =============================================================================
# 1. SAFETY CHECKS
# =============================================================================

if [[ ! -f "package.json" ]]; then
  echo "❌ Error: No package.json found. Please run this script from your SvelteKit project root."
  exit 1
fi

if ! grep -q '"svelte"' package.json && ! grep -q '"@sveltejs/kit"' package.json; then
  echo "⚠️  Warning: This does not look like a SvelteKit project. Continuing anyway..."
fi

command -v node >/dev/null 2>&1 || { echo "❌ node is required. Install from https://nodejs.org/"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "❌ npm is required (comes with node)"; exit 1; }
command -v uv >/dev/null 2>&1 || { echo "❌ uv is required. Install with: curl -LsSf https://astral.sh/uv/install.sh | sh"; exit 1; }

echo "✅ Project checks passed."
echo ""

# =============================================================================
# 2. INSTALL REQUIRED CLI TOOLS
# =============================================================================

echo "📦 Installing CLI tools..."
echo "   → specify-cli (GitHub Spec Kit)..."
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git 2>&1 | grep -v "^Resolved\|^Prepared" || true

echo "   → @tessl/cli..."
npm install -g @tessl/cli >/dev/null 2>&1 || true

echo "   → tessl-labs/intent-integrity-kit..."
tessl install tessl-labs/intent-integrity-kit >/dev/null 2>&1 || true

echo "   → dependency-cruiser (dev dependency)..."
npm install --save-dev dependency-cruiser >/dev/null 2>&1 || true

echo "✅ CLI tools installed."
echo ""

# =============================================================================
# 3. CREATE CLEAN ARCHITECTURE FOLDER STRUCTURE
# =============================================================================

echo "📁 Creating clean architecture folders..."
mkdir -p \
  .cursor/rules \
  specs \
  src/core/domain \
  src/core/application \
  src/infrastructure/persistence \
  src/infrastructure/http \
  src/infrastructure/adapters \
  src/presentation/components \
  src/presentation/pages \
  src/presentation/layouts

echo "✅ Folder structure created."
echo ""

# =============================================================================
# 4. CREATE DEPENDENCY-CRUISER CONFIG (Clean Architecture Enforcement)
# =============================================================================

echo "⚙️  Creating dependency-cruiser config..."
cat > .dependency-cruiser.js << 'EOF'
module.exports = {
  forbidden: [
    {
      name: "domain-should-not-depend-on-anything",
      severity: "error",
      from: { path: '^src/core/domain' },
      to: { path: '^(?!src/core/domain)' }
    },
    {
      name: "application-should-not-depend-on-infrastructure",
      severity: "error",
      from: { path: '^src/core/application' },
      to: { path: '^(?!src/core/(domain|application))' }
    },
    {
      name: "infrastructure-should-not-depend-on-presentation",
      severity: "error",
      from: { path: '^src/infrastructure' },
      to: { path: '^(?!src/core/(domain|application)|src/infrastructure)' }
    },
    {
      name: "presentation-should-only-depend-on-application",
      severity: "error",
      from: { path: '^src/presentation' },
      to: { path: '^(?!src/core/application|src/presentation)' }
    },
    {
      name: "no-direct-db-in-core-layers",
      severity: "error",
      from: { path: '^src/(core|presentation)' },
      to: { module: 'supabase|@supabase|prisma|drizzle|@prisma' }
    }
  ],
  options: {
    tsConfig: { file: './tsconfig.json' },
    exclude: ['node_modules', 'dist', '.svelte-kit', 'build']
  }
};
EOF

echo "✅ dependency-cruiser config created."
echo ""

# =============================================================================
# 5. CREATE THE MASTER GOVERNANCE FILE (CURSOR)
# =============================================================================

echo "📝 Creating Cursor governance file (.cursor/rules/000-core-governance.mdc)..."
cat > .cursor/rules/000-core-governance.mdc << 'EOF'
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
- Use Supabase/Postgres conventions unless the human explicitly chooses otherwise.
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
EOF

echo "✅ Cursor governance file created."
echo ""

# =============================================================================
# 6. CREATE CLAUDE.MD FOR CLAUDE CODE
# =============================================================================

echo "📝 Creating CLAUDE.md for Claude Code..."
cat > CLAUDE.md << 'EOF'
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
EOF

echo "✅ CLAUDE.md created for Claude Code."
echo ""

# =============================================================================
# 7. ADD USEFUL NPM SCRIPTS
# =============================================================================

echo "⚙️  Adding npm scripts..."
npm pkg set scripts.arch:check="depcruise src" 2>/dev/null || npm pkg set "scripts.arch:check=depcruise src" || true
npm pkg set scripts.spec:init="specify init . --integration copilot" 2>/dev/null || npm pkg set "scripts.spec:init=specify init . --integration copilot" || true
npm pkg set scripts.spec:plan="specify plan" 2>/dev/null || npm pkg set "scripts.spec:plan=specify plan" || true
npm pkg set scripts.spec:implement="specify implement" 2>/dev/null || npm pkg set "scripts.spec:implement=specify implement" || true

echo "✅ Added npm scripts:"
echo "   - npm run arch:check (validate architecture boundaries)"
echo "   - npm run spec:init (initialize Spec Kit)"
echo "   - npm run spec:plan (generate architecture plan)"
echo "   - npm run spec:implement (generate implementation tasks)"
echo ""

# =============================================================================
# 8. INITIALIZE SPEC KIT
# =============================================================================

echo "🔧 Initializing Spec Kit..."
specify init . --integration copilot 2>&1 | grep -v "^Already\|^Created" || true
echo "✅ Spec Kit initialized."
echo ""

# =============================================================================
# COMPLETION MESSAGE
# =============================================================================

echo ""
echo "═════════════════════════════════════════════════════════════════════════════"
echo "✅ 🎉 BOOTSTRAP COMPLETE!"
echo "═════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Your A-SDLC harness is now 80% set up. Files created:"
echo "  ✓ .cursor/rules/000-core-governance.mdc"
echo "  ✓ CLAUDE.md"
echo "  ✓ .dependency-cruiser.js"
echo "  ✓ Clean architecture folders (src/core/*, src/infrastructure/*, etc.)"
echo "  ✓ npm scripts (arch:check, spec:init, spec:plan, spec:implement)"
echo ""
echo "═════════════════════════════════════════════════════════════════════════════"
echo "📋 NEXT MANUAL STEPS (do these in Cursor / Claude Code UI):"
echo "═════════════════════════════════════════════════════════════════════════════"
echo ""
echo "1️⃣  Install these MCP servers:"
echo "   Cursor: Settings → MCP → Add these servers:"
echo "      • @speckit/mcp"
echo "      • sveltejs/ai-tools"
echo "      • supabase-community/supabase-mcp"
echo "      • HKUDS/FastCode"
echo ""
echo "   Claude Code: Plugin marketplace → Add same servers"
echo ""
echo "2️⃣  Copy two community rule files:"
echo "   From: https://github.com/multica-ai/andrej-karpathy-skills"
echo "      → Copy 'karpathy-guidelines.mdc' to '.cursor/rules/010-karpathy.mdc'"
echo ""
echo "   From: https://github.com/matank001/cursor-security-rules"
echo "      → Copy all '.mdc' files to '.cursor/rules/020-security-*.mdc'"
echo ""
echo "3️⃣  (Optional) Install terminal compression (RTK):"
echo "   brew install rtk (macOS) or download from https://github.com/rtk-ai/rtk"
echo ""
echo "═════════════════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 You're now ready to start!"
echo ""
echo "Begin with this prompt:"
echo ""
echo '  "We need to build [feature]. Read CLAUDE.md / .cursor/rules/'
echo '   000-core-governance.mdc and initiate Phase 1."'
echo ""
echo "═════════════════════════════════════════════════════════════════════════════"
echo "Happy deterministic coding! 🚀"
echo "═════════════════════════════════════════════════════════════════════════════"

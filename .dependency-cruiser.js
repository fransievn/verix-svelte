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

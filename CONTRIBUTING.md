# Contributing

Thanks for helping improve the **FiveM Framework Adapter Starter**.

## Development setup
- Lua 5.4+
- [luarocks](https://luarocks.org/) with `luacheck` and `busted`
- Optional: a local FiveM server with ESX / QBCore / QBOX and (optionally) `ox_inventory`

```bash
luarocks install luacheck
luarocks install busted
luacheck .
busted -v
```

## Pull requests
- Keep the public surface (`FW.*`) small and documented.
- Do not add framework-specific business logic into adapters.
- Any interface change must include:
  - README updates
  - Tests (busted)
  - Semver bump in `README` (next release notes) and `CHANGELOG.md`

## Commit style
- Conventional Commits (e.g., `feat:`, `fix:`, `docs:`)

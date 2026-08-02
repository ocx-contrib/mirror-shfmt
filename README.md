# mirror-shfmt

OCX mirror for [shfmt](https://github.com/mvdan/sh), Daniel Martí's shell
parser and formatter. One repository, one spec directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [shfmt](https://github.com/mvdan/sh) | [`shfmt/mirror.yml`](shfmt/mirror.yml) | `ghcr.io/ocx-contrib/shfmt/shfmt` | `ocx.sh/shfmt/shfmt` | `BSD-3-Clause` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> **The upstream repository is `mvdan/sh`, not `mvdan/shfmt`.** The Go module
> `mvdan.cc/sh/v3` is a shell parser library that ships `shfmt` as its command.
> An index namespace is always two segments and `mvdan` is a personal handle,
> not a vendor — so the tool names itself: `shfmt/shfmt`. Provenance lives in
> the index entry's `upstream` field, never in the coordinate.

> This repository previously published the same upstream to the flat
> coordinate `ocx.sh/shfmt`. `shfmt/shfmt` is the grouped successor.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
shfmt/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.png            describe asset, 512px
└── tests/smoke.star    Starlark smoke test
```

`LICENSE` and `NOTICE.md` are shared at the root. The logo is **not** — it sits
beside the spec, because a repo-root `logo.*` sits in no workflow's `paths:`
filter, so replacing it would publish nothing until some unrelated edit
happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all.

## Platforms

`shfmt` publishes five platform entries: both Linux arches, both macOS arches,
and `windows/amd64`. Upstream builds shfmt as a pure-Go binary without cgo, so
there is one Linux build per arch and it is **fully static** — no `PT_INTERP`,
no `DT_NEEDED`. `os.features` states what an artifact requires *of the host*,
so both Linux keys are **bare**: tagging them `+libc.musl` would be a false
requirement that hid them from every glibc host. The `alpine:3.20` container
leg in `mirror-base.yml` is what turns that claim into evidence; the
measurement itself is recorded above the `assets:` block in `shfmt/mirror.yml`.

There is deliberately **no `windows/arm64`** — upstream ships only
`windows_386.exe` and `windows_amd64.exe`, verified at both ends of the
mirrored range. A platform whose pattern matches zero assets is *silently
skipped*, not an error, so declaring it would mean a green run with a missing
platform.

## The binaries claim

Upstream ships a **raw binary**, not an archive, so `asset_type: binary` puts
the single executable at the bundle content root and `metadata.json` declares a
bare `PATH=${installPath}`. That makes `bin_scan` unusable: the scan only reads
*below* the content root, so with no `${installPath}/<subdir>` entry it would
inspect no file — and `verify`/`auto` are rejected at spec load with exit 65
rather than passing green over an unread tree. `mirror-base.yml` therefore sets
`bin_scan: off` and `shfmt/metadata.json` declares `binaries: ["shfmt"]` by
hand. Inventing a `bin/` subdirectory to re-enable the scan is not the fix — it
would stop matching what upstream ships. The smoke test is what proves the name
resolves on the composed PATH.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `shfmt/mirror.yml` | hand | yes — see below |
| `shfmt/{metadata.json,CATALOG.md,logo.png}` | hand | — |
| `shfmt/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci --spec shfmt/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope; the
redistribution license is recorded in [`NOTICE.md`](NOTICE.md).

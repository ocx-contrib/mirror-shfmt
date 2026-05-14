---
name: shfmt
summary: Shell script formatter — POSIX, Bash, mksh
homepage: https://github.com/mvdan/sh
license: BSD-3-Clause
---

# shfmt

`shfmt` formats shell programs. Supports POSIX shell, Bash, and mksh.
Authored by [Daniel Martí](https://mvdan.cc/) and mirrored to
[`ocx.sh/shfmt`](https://ocx.sh/shfmt) from
[mvdan/sh](https://github.com/mvdan/sh) GitHub releases.

## Install

```sh
ocx install shfmt
```

## Usage

```sh
shfmt -d script.sh         # diff-style suggestions
shfmt -w script.sh         # rewrite in place
shfmt --version
```

## Versioning

Mirrors `vX.Y.Z` tags from upstream as `X.Y.Z` (cascade aliases `X.Y`, `X`,
`latest`). Pre-releases skipped. New versions land within ~6 hours of
upstream release.

## Source

- Upstream repo: <https://github.com/mvdan/sh>
- Mirror config: [`mirror.yml`](./mirror.yml)
- Pipeline status: see this repo's Actions tab

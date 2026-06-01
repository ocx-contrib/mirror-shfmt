# tests/smoke.star — stable across upstream shfmt releases.
#
# Run by `ocx package test --script tests/smoke.star` inside the composed
# package env. Asserts on the binary's contract — exit codes, version shape,
# and the computed format result — never on help/version prose (which upstream
# rewords freely). See ocx.mirror/references/testing-practices.md.

# Branch on the typed platform constant (ocx.platform() was removed).
TOOL = "shfmt.exe" if ocx.target_platform.os == ocx.os.Windows else "shfmt"

# Tier 1 + 2: liveness + version SHAPE.
# Proves shfmt resolves on the composed PATH (metadata.json) and runs, and that
# it self-reports a semver — the digits are the contract, the banner is not.
r_version = ocx.run(TOOL, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional behavior on hermetic input — assert the computed result.
# shfmt's job is formatting: feed an unindented shell block on stdin with an
# explicit 2-space indent and assert the body comes back indented. This drives
# the real parse+print path (a stronger liveness proof than --version) and
# asserts a stable transformation, not any wording.
r_fmt = ocx.run(TOOL, "-i", "2", stdin="if true; then\necho hi\nfi\n")
expect.ok(r_fmt)
expect.contains(r_fmt.stdout, "  echo hi")

# shfmt/tests/smoke.star — stable across upstream shfmt releases.
#
# Run by `ocx package test --script shfmt/tests/smoke.star` inside the composed
# package env. Asserts on the binary's contract — exit codes, version shape,
# and the computed format result — never on help/version prose (which upstream
# rewords freely). See the create-mirror skill's references/testing-practices.md.

# Branch on the typed platform constant (ocx.platform() was removed).
TOOL = "shfmt.exe" if ocx.target_platform.os == ocx.os.Windows else "shfmt"

# Tier 1 + 2: liveness + version SHAPE.
# Proves shfmt resolves on the composed PATH (metadata.json's bare
# ${installPath}, which is also what makes the hand-written `binaries` claim
# meaningful) and that it self-reports a semver — the digits are the contract,
# the banner is not.
r_version = ocx.run(TOOL, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3a: stdin path — computed result on hermetic input.
# Feed an unindented shell block with an explicit 2-space indent and assert the
# body comes back indented. Drives the real parse+print path and asserts a
# transformation, not any wording.
r_fmt = ocx.run(TOOL, "-i", "2", stdin="if true; then\necho hi\nfi\n")
expect.ok(r_fmt)
expect.contains(r_fmt.stdout, "  echo hi")

# Tier 3b: the in-place round trip — the check a stub binary cannot fake.
# `-l` names files whose formatting differs, so the same probe must flip from
# "names it" to "silent" across a `-w`. A binary that did nothing would stay in
# the first state; one that printed a canned success would never have named it.
ocx.write_file("messy.sh", "if true;then\necho hi\nfi\n")

before = ocx.run(TOOL, "-l", "messy.sh")
expect.contains(before.stdout, "messy.sh")

expect.ok(ocx.run(TOOL, "-w", "messy.sh"))

# The rewrite is real, not a touch: `;then` → `; then` and a tab-indented body
# are shfmt's own default output, reachable only through parse + print.
formatted = ocx.read_file("messy.sh")
expect.contains(formatted, "if true; then")
expect.contains(formatted, "\techo hi")

after = ocx.run(TOOL, "-l", "messy.sh")
expect.ok(after)
expect.eq(after.stdout.strip(), "")

# Tier 4: not applicable — metadata.json declares PATH only (no non-PATH env var).

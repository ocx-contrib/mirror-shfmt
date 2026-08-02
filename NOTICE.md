# NOTICE

This repository packages and redistributes upstream software published in
[`mvdan/sh`](https://github.com/mvdan/sh). The Apache-2.0 license in
[`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `shfmt` | `ghcr.io/ocx-contrib/shfmt/shfmt` | `BSD-3-Clause` |

---

## `shfmt`

Upstream: <https://github.com/mvdan/sh> — the repository is named `sh`, not
`shfmt`: the Go module `mvdan.cc/sh/v3` is a shell parser library that ships
`shfmt` as its command. The mirrored binaries are that command.

Published to `ghcr.io/ocx-contrib/shfmt/shfmt`.

| Component | SPDX | Holder |
|---|---|---|
| shfmt | **BSD-3-Clause** | Daniel Martí |

Permissive. BSD-3-Clause grants redistribution in binary form on the condition
that the copyright notice, the list of conditions and the disclaimer are
reproduced **in the documentation or other materials provided with the
distribution** — and upstream ships a bare binary with no accompanying
`LICENSE` file, so this file is that material. The full text follows verbatim;
the upstream original is at
<https://github.com/mvdan/sh/blob/master/LICENSE>.

The published binaries statically link third-party Go modules under permissive
licenses, enumerated in upstream's `go.mod`.

```
Copyright (c) 2016, Daniel Martí. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

   * Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above
copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the
distribution.
   * Neither the name of the copyright holder nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

No modifications are made to any upstream artifact in this repository; the
binary is republished byte-for-byte inside an OCX bundle, renamed from its
versioned upstream filename (`shfmt_v3.13.1_linux_amd64`) to `shfmt` so the
command is typeable.

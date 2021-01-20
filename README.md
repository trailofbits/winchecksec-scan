winchecksec-scan
================

![CI](https://github.com/trailofbits/winchecksec-scan/workflows/CI/badge.svg)

This repository provides a GitHub Action (`winchecksec-scan`) for running
[Winchecksec](https://github.com/trailofbits/winchecksec) on one or more
Windows binaries.

## Inputs

### `paths`

**Required**.

The paths to the Windows binaries to check. These should be space-separated
and relative to the workspace directory.

### `checks`

**Required**.

A space-separated list of Winchecksec checks that **must** pass.

Valid check names:

* `aslr`
* `highEntropyVA`
* `forceIntegrity`
* `isolation`
* `nx`
* `seh`
* `cfg`
* `rfg`
* `safeSEH`
* `gs`
* `authenticode`
* `dotNET`

## Example usage

```yaml
uses: trailofbits/winchecksec-scan@v1
with:
  paths: build/foo.exe build/bar.exe
  checks: aslr highEntropyVA nx
```

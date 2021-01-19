Winchecksec GitHub Action
=========================

![CI](https://github.com/trailofbits/winchecksec-github-action/workflows/CI/badge.svg)

**NOTE**: This is a work in progress!

This repository provides a GitHub Action for running
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
uses: trailofbits/winchecksec-github-action@v1
with:
  paths: build/foo.exe build/bar.exe
  checks: aslr highEntropyVA nx
```

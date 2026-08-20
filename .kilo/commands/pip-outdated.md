---
description: "Check how outdated a set of pinned pip package versions are by querying PyPI for release dates and the latest stable version."
argument-hint: "package==version [package==version ...]"
---

Your task is to analyse how obsolete a list of pinned pip packages are by querying PyPI for each package's release timeline.

The user will provide one or more package pins in the form `package==version`, typically copied from a `%pip install` notebook cell or a `requirements.txt` file. Lines that do not contain `==` should be skipped silently.

## Step 1 — Parse the input

Extract all `package==version` pairs from the user's input.

- Strip shell/notebook noise: `%pip install`, `| tail -n 1`, comments, extra whitespace.
- Normalise package names to lowercase (PyPI is case-insensitive).
- If no valid pairs are found, ask the user to provide them.

## Step 2 — Query PyPI for each package

For each `package==version` pair, run the following Python one-liner (requires only the stdlib `urllib` and the `packaging` library, which ships with pip):

```bash
curl -s https://pypi.org/pypi/<PACKAGE>/json | python3 -c "
import sys, json
from packaging.version import Version
d = json.load(sys.stdin)
versions = d['releases']
target = '<VERSION>'

# Sort all versions using PEP 440 ordering (handles rc, a, b, dev, post)
sorted_vers = sorted(versions.keys(), key=Version)

# Find latest STABLE (no pre-release qualifiers)
stable = [v for v in sorted_vers if not Version(v).is_prerelease and not Version(v).is_devrelease]
latest_stable = stable[-1] if stable else sorted_vers[-1]

try:
    idx = sorted_vers.index(target)
    next_v = sorted_vers[idx+1] if idx+1 < len(sorted_vers) else 'N/A'
    print(f'Pinned:        {target} — {versions[target][0][\"upload_time_iso_8601\"][:10]}')
    if next_v != 'N/A':
        print(f'Next release:  {next_v} — {versions[next_v][0][\"upload_time_iso_8601\"][:10]}')
    else:
        print(f'Next release:  N/A (was already the latest at pin time)')
    print(f'Latest stable: {latest_stable} — {versions[latest_stable][0][\"upload_time_iso_8601\"][:10]}')
except ValueError:
    print(f'Version {target} not found on PyPI')
"
```

Run all queries in parallel (one command per package) to minimise wall-clock time.

## Step 3 — Calculate age

For each package compute:

- **Days pinned → latest**: `(today) - (pinned release date)`.
- **Days pinned → next**: `(next release date) - (pinned release date)`. This shows how quickly the pinned version was superseded.

Today's date is available from the environment or can be obtained with `date -u +%Y-%m-%d`.

## Step 4 — Present the results

Display a Markdown table with the following columns:

| Package | Pinned | Pinned Released | Next Version | Next Released | Latest Stable | Latest Released | Days Behind |
|---------|--------|-----------------|--------------|---------------|---------------|-----------------|-------------|

After the table, add a **Key observations** section:
- Which package is most obsolete (most days behind).
- Whether any packages have crossed a **major version boundary** (0.x → 1.x or N.x → (N+1).x), which typically implies breaking API changes.
- Whether any pinned version was superseded very quickly (next release within a week), indicating it was a bad pin.

## Step 5 — Upgrade recommendation

Summarise the upgrade effort:
- **Safe to upgrade**: minor/patch bumps only, no major version change.
- **Requires migration**: major version change — link to changelog or migration guide if known.
- **Check compatibility**: packages that are tightly coupled (e.g., `langchain` + `langchain-community`) must be upgraded together.

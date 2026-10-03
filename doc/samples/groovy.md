<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — Groovy / Gradle examples

## Extract top-level Gradle properties

**Goal:** Extract top-level `sourceCompatibility` / `targetCompatibility` assignments from Gradle
files, ignoring nested ones inside tasks or other blocks.

**Query file:** `groovy-top-level-compatibility.scm` (`ast-tools-queries show groovy-top-level-compatibility`)
```scheme
; Find top-level sourceCompatibility and targetCompatibility assignments
(
  (source_file
    (assignment
      (identifier) @property
      (_) @value
    )
  )
  (#match? @property "^(source|target)Compatibility$")
)
```

**Command:**
```bash
git ls-files -- '*.gradle' | ast-tools-query groovy --compact -f groovy-top-level-compatibility.scm | jq '[.[] | {file: .file, source: (.captures | map(.name == "property" and .text == "sourceCompatibility") | index(true)) as $source_idx | if $source_idx then .captures[$source_idx + 1].text else null end, target: (.captures | map(.name == "property" and .text == "targetCompatibility") | index(true)) as $target_idx | if $target_idx then .captures[$target_idx + 1].text else null end}]'
```

**How it works:**

1. The query only matches `assignment` nodes that are direct children of the `source_file` root, so
   nested assignments are ignored.
2. `--compact` gives concise JSON per file.
3. The `jq` filter finds the index of the `sourceCompatibility` / `targetCompatibility` captures and
   takes the value capture that follows each, or `null` when the property is absent.

**Output:**
```json
[
  { "file": "java-single-prop.gradle", "source": "\"1.9\"", "target": null },
  { "file": "java17-source-target.gradle", "source": "\"1.7\"", "target": "\"1.7\"" }
]
```

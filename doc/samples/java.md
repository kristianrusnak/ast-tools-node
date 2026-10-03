<!-- Generated/modified by AI Kilo Code 7.5.6-gratex-017, used model glm-5.3 -->

# ast-tools-query — Java examples

Bundled queries: `ast-tools-queries list --language java`.

## Extract all class definitions

```bash
git ls-files -- '*.java' | ast-tools-query java \
  -f java-definitions.scm \
  --format text
```

## Find class declarations

```bash
git ls-files -- '*.java' | ast-tools-query java \
  -q "(class_declaration name: (identifier) @class.name) @class" \
  --format text
```

## Extract method names only

```bash
git ls-files -- '*.java' | ast-tools-query java \
  -q "(method_declaration name: (identifier) @method.name)" \
  --format json | jq -r '.[] | .captures[] | .text'
```

## Find classes whose name matches a pattern

```bash
git ls-files -- '*.java' | \
  ast-tools-query java \
    -q '(class_declaration name: (identifier) @name (#match? @name "Test"))' \
    --format json | \
  jq -r '.[] | select(.captureCount > 0) | .file'
```

## Extract class names as XML

```bash
git ls-files -- '*.java' | ast-tools-query java \
  -f java-definitions.scm \
  --format xml | \
  xmlstarlet sel -t -v '//capture[@name="name.definition.class"]' -n
```

## Other bundled Java queries

- `java-main-method.scm` — `public static void main` entry points.
- `java-type-block-comment.scm` (+ `.sh` helpers) — block comments attached to type declarations;
  `java-type-block-comment-generated.sh` extracts the `@generated` marker.
  Read them with `ast-tools-queries show <name>`.

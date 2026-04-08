#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  validate-github-project-schema.sh [options]

Options:
  --project-owner OWNER
  --project-number NUMBER
  --schema-file PATH
  --snapshot-json PATH
  --help
EOF
}

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
project_owner=""
project_number=""
schema_file="$repo_root/skills/ai-team/references/github-project-schema.json"
snapshot_json=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-owner)
      project_owner="${2:?missing value for --project-owner}"
      shift 2
      ;;
    --project-number)
      project_number="${2:?missing value for --project-number}"
      shift 2
      ;;
    --schema-file)
      schema_file="${2:?missing value for --schema-file}"
      shift 2
      ;;
    --snapshot-json)
      snapshot_json="${2:?missing value for --snapshot-json}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ! -f "$schema_file" ]]; then
  echo "Schema file not found: $schema_file" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "validate-github-project-schema.sh requires python3." >&2
  exit 1
fi

raw_json="$(mktemp)"

if [[ -n "$snapshot_json" ]]; then
  if [[ ! -f "$snapshot_json" ]]; then
    echo "Snapshot JSON not found: $snapshot_json" >&2
    exit 1
  fi
  cp "$snapshot_json" "$raw_json"
else
  if [[ -z "$project_owner" || -z "$project_number" ]]; then
    echo "Live schema validation requires --project-owner and --project-number." >&2
    exit 1
  fi

  if ! command -v gh >/dev/null 2>&1; then
    echo "validate-github-project-schema.sh requires gh for live GitHub validation." >&2
    exit 1
  fi

  if ! gh auth status >/dev/null 2>&1; then
    echo "validate-github-project-schema.sh requires an authenticated gh session." >&2
    exit 1
  fi

  graphql_query='query($owner: String!, $number: Int!) {
    organization(login: $owner) {
      projectV2(number: $number) {
        fields(first: 100) {
          nodes {
            __typename
            ... on ProjectV2FieldCommon { id name }
            ... on ProjectV2SingleSelectField {
              options { id name }
            }
          }
        }
      }
    }
    user(login: $owner) {
      projectV2(number: $number) {
        fields(first: 100) {
          nodes {
            __typename
            ... on ProjectV2FieldCommon { id name }
            ... on ProjectV2SingleSelectField {
              options { id name }
            }
          }
        }
      }
    }
  }'

  gh api graphql \
    -f query="$graphql_query" \
    -F owner="$project_owner" \
    -F number="$project_number" > "$raw_json"
fi

python3 - "$schema_file" "$raw_json" "$project_owner" "$project_number" <<'PY'
import json
import sys

schema_path, raw_path, owner, number = sys.argv[1:5]

def load_json(path):
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)

def normalize(data):
    if isinstance(data, dict) and isinstance(data.get("fields"), list):
        return data

    project = None
    if isinstance(data, dict):
        project = (((data.get("data") or {}).get("organization") or {}).get("projectV2"))
        if project is None:
            project = (((data.get("data") or {}).get("user") or {}).get("projectV2"))

    nodes = ((project or {}).get("fields") or {}).get("nodes") or []
    fields = []
    for node in nodes:
        field_type = "generic"
        if node.get("__typename") == "ProjectV2SingleSelectField":
            field_type = "single_select"
        fields.append(
            {
                "name": node.get("name"),
                "type": field_type,
                "options": [opt.get("name") for opt in node.get("options", []) if opt.get("name")],
            }
        )
    return {"fields": fields}

schema = load_json(schema_path)
actual = normalize(load_json(raw_path))

required_fields = schema.get("required_fields", [])
actual_map = {field.get("name"): field for field in actual.get("fields", []) if field.get("name")}

missing_fields = []
wrong_types = []
missing_options = []

for req in required_fields:
    name = req.get("name")
    if not name:
        continue
    actual_field = actual_map.get(name)
    if actual_field is None:
        missing_fields.append(name)
        continue

    expected_type = req.get("type")
    if expected_type and actual_field.get("type") != expected_type:
        wrong_types.append((name, expected_type, actual_field.get("type") or "unknown"))

    expected_options = req.get("options") or []
    actual_options = set(actual_field.get("options") or [])
    for option in expected_options:
      if option not in actual_options:
        missing_options.append((name, option))

print("# GitHub Project Schema Report")
print()
print("## Project")
if owner and number:
    print(f"- {owner} project #{number}")
else:
    print("- snapshot input")

print()
print("## Expected Fields")
for req in required_fields:
    label = req.get("name")
    if req.get("type"):
        label += f" ({req['type']})"
    print(f"- {label}")

print()
print("## Findings")
if not missing_fields and not wrong_types and not missing_options:
    print("- Schema matches AI TEAM requirements")
else:
    for field in missing_fields:
        print(f"- Missing field: {field}")
    for name, expected, actual_type in wrong_types:
        print(f"- Wrong field type for {name}: expected {expected}, got {actual_type}")
    for name, option in missing_options:
        print(f"- Missing option '{option}' in field {name}")

if missing_fields or wrong_types or missing_options:
    sys.exit(1)
PY

rm -f "$raw_json"

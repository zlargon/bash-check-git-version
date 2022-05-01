#!/bin/bash
set -e

# shellcheck disable=SC1091
source ./check-git-version.sh

# =========================================================
# assert function
# =========================================================
echo_error() { echo -e "\033[0;31m$*\033[0m" 1>&2; }
assert() {
  local actual_value="$1"
  local expect_value="$2"
  local expect_message="$3"
  if [[ "$actual_value" != "$expect_value" ]]; then
    echo_error "[FAIL] $expect_message, but the actual value is: $actual_value"
    exit 1
  fi
}

# =========================================================
# mock git_version
# =========================================================
git_version() { echo "$mock_version"; }

# =========================================================
# test numeric
# =========================================================
expect_numeric_to_be() {
  local msg="expect '$1' numeric to be '$expect_value'"
  assert "$(numeric "$1")" "$2" "$msg"
}
expect_numeric_to_be "0.0.1"    "1"
expect_numeric_to_be "0.8.0"    "800"
expect_numeric_to_be "1.2.3"    "10203"
expect_numeric_to_be "10.20.30" "102030"
expect_numeric_to_be "10.20.30" "102030"

# =========================================================
# test git_semantic_version
# =========================================================
expect_semantic_version_to_be() {
  mock_version="$1"
  local msg="expect '$1' semantic version to be '$expect_value'"
  assert "$(git_semantic_version)" "$2" "$msg"
}
expect_semantic_version_to_be "git version 1.2.3 (Apple Git-128)" "1.2.3"
expect_semantic_version_to_be "git version 1.2.4"                 "1.2.4"

# =========================================================
# test equal
# =========================================================
expect_git_version_equal() {
  mock_version="$1"
  local msg="expect '$1' version equal to '$2'"
  assert "$(git_version_eq "$2")" 1 "$msg"
  assert "$(git_version_ne "$2")" 0 "$msg"
}
expect_git_version_equal "git version 0.0.1"    "0.0.1"
expect_git_version_equal "git version 0.8.0"    "0.8.0"
expect_git_version_equal "git version 1.2.3"    "1.2.3"
expect_git_version_equal "git version 10.20.30" "10.20.30"

# =========================================================
# test not equal
# =========================================================
expect_git_version_not_equal() {
  mock_version="$1"
  local msg="expect '$1' version not equal to '$2'"
  assert "$(git_version_eq "$2")" 0 "$msg"
  assert "$(git_version_ne "$2")" 1 "$msg"
}
expect_git_version_not_equal "git version 0.0.1"    "0.0.2"
expect_git_version_not_equal "git version 0.8.0"    "0.9.1"
expect_git_version_not_equal "git version 1.2.3"    "1.3.5"
expect_git_version_not_equal "git version 10.20.30" "0.2.3"

# =========================================================
# test less than
# =========================================================
expect_git_version_less_than() {
  mock_version="$1"
  local msg="expect '$1' version less than '$2'"
  assert "$(git_version_lt "$2")" 1 "$msg"
  assert "$(git_version_ge "$2")" 0 "$msg"
}
expect_git_version_less_than "git version 0.0.1"    "0.0.2"
expect_git_version_less_than "git version 0.8.0"    "0.9.1"
expect_git_version_less_than "git version 1.2.3"    "1.3.5"
expect_git_version_less_than "git version 10.20.30" "10.21.35"

# =========================================================
# test less or equal
# =========================================================
expect_git_version_less_or_equal() {
  mock_version="$1"
  local msg="expect '$1' version less than or equal to '$2'"
  assert "$(git_version_le "$2")" 1 "$msg"
  assert "$(git_version_gt "$2")" 0 "$msg"
}
expect_git_version_less_or_equal "git version 0.0.1"    "0.0.2"
expect_git_version_less_or_equal "git version 0.0.1"    "0.0.1"
expect_git_version_less_or_equal "git version 0.8.0"    "0.9.1"
expect_git_version_less_or_equal "git version 1.2.3"    "1.3.5"
expect_git_version_less_or_equal "git version 1.2.3"    "1.2.3"
expect_git_version_less_or_equal "git version 10.20.30" "10.21.35"
expect_git_version_less_or_equal "git version 10.20.30" "10.20.30"

# =========================================================
# test greater than
# =========================================================
expect_git_version_greater_than() {
  mock_version="$1"
  local msg="expect '$1' version is greater than '$2'"
  assert "$(git_version_gt "$2")" 1 "$msg"
  assert "$(git_version_le "$2")" 0 "$msg"
}
expect_git_version_greater_than "git version 0.0.2"    "0.0.1"
expect_git_version_greater_than "git version 0.9.1"    "0.8.0"
expect_git_version_greater_than "git version 1.3.5"    "1.2.3"
expect_git_version_greater_than "git version 10.21.35" "10.20.30"

# =========================================================
# test greater or equal
# =========================================================
expect_git_version_greater_or_equal() {
  mock_version="$1"
  local msg="expect '$1' version is greater than or equal to '$2'"
  assert "$(git_version_ge "$2")" 1 "$msg"
  assert "$(git_version_lt "$2")" 0 "$msg"
}
expect_git_version_greater_or_equal "git version 0.0.2"    "0.0.1"
expect_git_version_greater_or_equal "git version 0.0.2"    "0.0.2"
expect_git_version_greater_or_equal "git version 0.9.1"    "0.8.0"
expect_git_version_greater_or_equal "git version 0.9.1"    "0.9.1"
expect_git_version_greater_or_equal "git version 1.3.5"    "1.2.3"
expect_git_version_greater_or_equal "git version 1.3.5"    "1.3.5"
expect_git_version_greater_or_equal "git version 10.21.35" "10.20.30"
expect_git_version_greater_or_equal "git version 10.21.35" "10.21.35"

echo "Tests all pass."

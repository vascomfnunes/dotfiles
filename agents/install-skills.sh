#!/bin/sh

set -eu

# Pin source revisions; do not replace skills already managed by the user.
# Skills from skills-hub.ai pin the published version and its content hash.
refactor_version=1.0.0
refactor_hash=718bfd8d8a6b18d4894e23e98f1924d8cf3a09d3e67ca37bd7be0ba6c11847cf
caveman_rev=2e068f735253cce28256744804785f01887d9646
vercel_rev=1a2c79d4e6c4a2283dc2c614b6538cbe1ed5ca62
apple_design_rev=ff4ebddf0488598723a82bfdce1afb04de0b1c44
find_skills_rev=cabe07254cddf16a3a650253f0ba03d543d8a86e
superpowers_rev=22f0b463e7a5e579904dd6211a520321035526f7
issue_rev=302c0d91a77097f1ae66e39bd996253e4bbb17d8
rea_rev=fe677f6cf9853fb12490dfb8ef23ccae3a551049
agent_scripts_rev=d210c0a77c8f9ae5e1d939b13238a75e87cdb69a
swiftui_rev=f2920b63995263f57b3e198674e89a602efba6d2
swift_concurrency_rev=bee3f69ba17142da148d3c5406f148ed62592b69
swift_testing_rev=2d6bba14a3c8bf3694f218b92fffe617c41ae43e
skills_dir="$HOME/.agents/skills"
mkdir -p "$skills_dir"
skills_tmp=$(mktemp -d)
trap 'rm -rf "$skills_tmp"' EXIT HUP INT TERM

skill_installed() {
  for dir in "$HOME/.agents/skills" "$HOME/.config/opencode/skills" "$HOME/.claude/skills"; do
    if [ -e "$dir/$1" ] || [ -L "$dir/$1" ] || [ -e "$dir/$1.md" ]; then
      return 0
    fi
  done
  return 1
}

install_skill() {
  name=$1
  source=$2
  if skill_installed "$name"; then
    echo "Keeping existing skill: $name"
    return
  fi
  [ -f "$source/SKILL.md" ] || { echo "Missing skill: $source" >&2; return 1; }
  cp -R "$source" "$skills_dir/$name"
}

# Rebuild the SKILL.md the skills-hub CLI would write, but pin the content
# hash so a changed payload is refused instead of installed.
install_hub_skill() {
  name=$1
  version=$2
  expected_hash=$3
  if skill_installed "$name"; then
    echo "Keeping existing skill: $name"
    return
  fi
  payload="$skills_tmp/$name.json"
  detail="$skills_tmp/$name-detail.json"
  curl -fsSL "https://api.skills-hub.ai/api/v1/skills/$name" -o "$detail"
  curl -fsSL "https://api.skills-hub.ai/api/v1/skills/$name/versions/$version" -o "$payload"
  actual_hash=$(jq -j '.instructions' "$payload" | shasum -a 256 | awk '{print $1}')
  if [ "$actual_hash" != "$expected_hash" ]; then
    echo "Checksum mismatch for skill: $name" >&2
    return 1
  fi
  skill_tmp="$skills_tmp/$name"
  mkdir -p "$skill_tmp"
  {
    jq -r --arg version "$version" \
      '"---\nname: " + (.name | @json) + "\ndescription: " + (.description | @json) +
       "\nversion: " + ($version | @json) + "\ncategory: " + (.category.slug | @json) + "\n---"' \
      "$detail"
    printf '\n'
    jq -j '.instructions' "$payload"
    printf '\n'
  } > "$skill_tmp/SKILL.md"
  cp -R "$skill_tmp" "$skills_dir/$name"
}

curl -fsSL "https://codeload.github.com/JuliusBrussee/caveman/tar.gz/$caveman_rev" -o "$skills_tmp/caveman.tar.gz"
mkdir "$skills_tmp/caveman"
tar -xzf "$skills_tmp/caveman.tar.gz" -C "$skills_tmp/caveman" --strip-components=1
for name in caveman caveman-compress caveman-help caveman-review caveman-stats cavecrew; do
  install_skill "$name" "$skills_tmp/caveman/skills/$name"
done

curl -fsSL "https://codeload.github.com/vercel-labs/agent-skills/tar.gz/$vercel_rev" -o "$skills_tmp/vercel.tar.gz"
mkdir "$skills_tmp/vercel"
tar -xzf "$skills_tmp/vercel.tar.gz" -C "$skills_tmp/vercel" --strip-components=1
install_skill web-design-guidelines "$skills_tmp/vercel/skills/web-design-guidelines"

download_source() {
  repository=$1
  revision=$2
  directory=$3
  curl -fsSL "https://codeload.github.com/$repository/tar.gz/$revision" -o "$skills_tmp/$directory.tar.gz"
  mkdir "$skills_tmp/$directory"
  tar -xzf "$skills_tmp/$directory.tar.gz" -C "$skills_tmp/$directory" --strip-components=1
}

download_source vercel-labs/skills "$find_skills_rev" find-skills
install_skill find-skills "$skills_tmp/find-skills/skills/find-skills"

download_source dickwu/apple-design-skill "$apple_design_rev" apple-design
install_skill apple-design "$skills_tmp/apple-design"

install_hub_skill refactor "$refactor_version" "$refactor_hash"

download_source obra/superpowers "$superpowers_rev" superpowers
for name in systematic-debugging writing-plans executing-plans requesting-code-review receiving-code-review; do
  install_skill "$name" "$skills_tmp/superpowers/skills/$name"
done

download_source cboone/cboone-cc-plugins "$issue_rev" issue
install_skill create-issue "$skills_tmp/issue/dist/codex/plugins/use-git/skills/create-issue"
download_source morluto/rea "$rea_rev" rea
install_skill reverse-engineer-anything "$skills_tmp/rea/.agents/skills/reverse-engineer-anything"

download_source steipete/agent-scripts "$agent_scripts_rev" agent-scripts
for name in project-structure instruments-profiling swiftui-performance-audit; do
  install_skill "$name" "$skills_tmp/agent-scripts/skills/$name"
done
download_source twostraws/swiftui-agent-skill "$swiftui_rev" swiftui
install_skill swiftui-pro "$skills_tmp/swiftui/swiftui-pro"
download_source twostraws/Swift-Concurrency-Agent-Skill "$swift_concurrency_rev" swift-concurrency
install_skill swift-concurrency-pro "$skills_tmp/swift-concurrency/swift-concurrency-pro"
download_source twostraws/swift-testing-agent-skill "$swift_testing_rev" swift-testing
install_skill swift-testing-pro "$skills_tmp/swift-testing/swift-testing-pro"

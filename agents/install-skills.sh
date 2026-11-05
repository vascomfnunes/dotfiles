#!/bin/sh

set -eu

# Pin source revisions; do not replace skills already managed by the user.
caveman_rev=2e068f735253cce28256744804785f01887d9646
vercel_rev=1a2c79d4e6c4a2283dc2c614b6538cbe1ed5ca62
skills_dir="$HOME/.agents/skills"
mkdir -p "$skills_dir"
skills_tmp=$(mktemp -d)
trap 'rm -rf "$skills_tmp"' EXIT HUP INT TERM

install_skill() {
  name=$1
  source=$2
  for dir in "$HOME/.agents/skills" "$HOME/.config/opencode/skills" "$HOME/.claude/skills"; do
    if [ -e "$dir/$name" ] || [ -L "$dir/$name" ] || [ -e "$dir/$name.md" ]; then
      echo "Keeping existing skill: $name"
      return
    fi
  done
  [ -f "$source/SKILL.md" ] || { echo "Missing skill: $source" >&2; return 1; }
  cp -R "$source" "$skills_dir/$name"
}

curl -fsSL "https://codeload.github.com/JuliusBrussee/caveman/tar.gz/$caveman_rev" -o "$skills_tmp/caveman.tar.gz"
mkdir "$skills_tmp/caveman"
tar -xzf "$skills_tmp/caveman.tar.gz" -C "$skills_tmp/caveman" --strip-components=1
for name in caveman caveman-commit caveman-compress caveman-help caveman-review caveman-stats cavecrew; do
  install_skill "$name" "$skills_tmp/caveman/skills/$name"
done

curl -fsSL "https://codeload.github.com/vercel-labs/agent-skills/tar.gz/$vercel_rev" -o "$skills_tmp/vercel.tar.gz"
mkdir "$skills_tmp/vercel"
tar -xzf "$skills_tmp/vercel.tar.gz" -C "$skills_tmp/vercel" --strip-components=1
install_skill web-design-guidelines "$skills_tmp/vercel/skills/web-design-guidelines"

#!/bin/sh

set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT HUP INT TERM
mkdir -p "$test_tmp/bin" "$test_tmp/home/.agents/skills/caveman"
printf 'keep\n' > "$test_tmp/home/.agents/skills/caveman/SKILL.md"
cat > "$test_tmp/bin/curl" <<'EOF'
#!/bin/sh
exit 0
EOF
cat > "$test_tmp/bin/tar" <<'EOF'
#!/bin/sh
dest=$4
case "$dest" in
  */caveman)
    for name in caveman caveman-commit caveman-compress caveman-help caveman-review caveman-stats cavecrew; do
      mkdir -p "$dest/skills/$name"
      printf 'test\n' > "$dest/skills/$name/SKILL.md"
    done
    ;;
  */vercel)
    mkdir -p "$dest/skills/web-design-guidelines"
    printf 'test\n' > "$dest/skills/web-design-guidelines/SKILL.md"
    ;;
esac
EOF
chmod +x "$test_tmp/bin/curl" "$test_tmp/bin/tar"
HOME="$test_tmp/home" PATH="$test_tmp/bin:$PATH" sh "$root/agents/install-skills.sh"
HOME="$test_tmp/home" PATH="$test_tmp/bin:$PATH" sh "$root/agents/install-skills.sh"
test "$(cat "$test_tmp/home/.agents/skills/caveman/SKILL.md")" = keep
test -f "$test_tmp/home/.agents/skills/caveman-review/SKILL.md"
test -f "$test_tmp/home/.agents/skills/web-design-guidelines/SKILL.md"

# Pipeline: copy-paste scripts (bash 3.2 safe)

Set these once. `NAMES` es la lista ordenada de section ids; el último es el
hero/finale.

```bash
WORK=/tmp/scroll-world          # scratch dir for prompts, sources, frames
ASSETS=./assets                 # where the site reads stills (webp) + clips (mp4)
mkdir -p "$WORK" "$ASSETS/vid"
NAMES="farm kitchen shop delivery plaza finale"   # <-- your section ids, in order

# Pollinations model: flux | zimage | klein
POLLINATIONS_MODEL=flux
POLLINATIONS_WIDTH=1536
POLLINATIONS_HEIGHT=1024

# Clip duration in seconds
DIVE_DUR=8
CONN_DUR=5

# Camera motion for HyperFrames compositions: zoom | pan | journey
CAMERA_MOTION=zoom

# Transitions: crossfade | connectors
TRANSITIONS=crossfade

# Mobile renders: yes | no
MOBILE=yes
```

HyperFrames renders can take time — launch them in background/detached mode and
poll the log.

## 1. Scene stills (Step 2)

Write one prompt file per section to `$WORK/still_<name>.txt` (see prompts.md),
then generate images with Pollinations.ai.

```bash
# Load env: global config first, then local .env overrides it.
[ -f "$HOME/.config/scroll-world/.env" ] && export $(grep -v '^#' "$HOME/.config/scroll-world/.env" | xargs)
[ -f .env ] && export $(grep -v '^#' .env | xargs)

gen_still() { # name
  local seed=$((RANDOM % 900000 + 100000))
  local prompt encoded url
  prompt=$(cat "$WORK/still_$1.txt")
  encoded=$(printf '%s' "$prompt" | jq -sRr '@uri')
  url="https://gen.pollinations.ai/image/${encoded}?model=${POLLINATIONS_MODEL}&width=${POLLINATIONS_WIDTH}&height=${POLLINATIONS_HEIGHT}&seed=${seed}&nologo=true&private=true"
  if [ -n "$POLLINATIONS_API_KEY" ]; then
    curl -fsSL "$url" -H "Authorization: Bearer ${POLLINATIONS_API_KEY}" \
      -o "$WORK/still_$1.png" 2> "$WORK/still_$1.err"
  else
    curl -fsSL "$url" \
      -o "$WORK/still_$1.png" 2> "$WORK/still_$1.err"
  fi
  if [ -f "$WORK/still_$1.png" ] && [ -s "$WORK/still_$1.png" ]; then
    echo "still $1 ok"
  else
    echo "still $1 FAIL"
  fi
}

for n in $NAMES; do
  gen_still "$n"
  # Respect Pollinations rate limit: 5s with key, 15s anonymous
  [ -n "$POLLINATIONS_API_KEY" ] && sleep 5 || sleep 15
done
```

If using **assets propios**, copy them to `$WORK/still_<name>.png` and skip the
generation loop.

Convert to webp for the site:

```bash
for n in $NAMES; do
  if command -v cwebp >/dev/null 2>&1; then
    cwebp -quiet -q 84 -resize 1800 0 "$WORK/still_$n.png" -o "$ASSETS/$n.webp"
  else
    ffmpeg -v error -y -i "$WORK/still_$n.png" -q:v 84 "$ASSETS/$n.webp"
  fi
done
```

Review the stills for cohesion before continuing. Re-roll any off-style one by
changing the seed or adjusting the prompt.

## 2. Build HyperFrames compositions (Step 4)

The skill ships templates in `references/`. The pipeline below copies the
template and substitutes placeholders with a small Python helper.

```bash
build_scene() { # name
  python3 - "$WORK" "$1" "$CAMERA_MOTION" "$DIVE_DUR" <<'PY'
import sys
from pathlib import Path
work, name, motion, dur = sys.argv[1:5]
base = Path('/home/quimaira/.agents/skills/scroll-world/references')
tmpl = (base / 'composition-template.html').read_text()
out = tmpl.replace('{{STILL_PATH}}', f'still_{name}.png') \
          .replace('{{COMPOSITION_ID}}', f'scene-{name}') \
          .replace('{{DURATION}}', dur) \
          .replace('{{CAMERA_MOTION}}', motion)
Path(f'{work}/scene_{name}.html').write_text(out)
PY
}

for n in $NAMES; do build_scene "$n"; done
```

Render desktop clips:

```bash
render_scene() { # name
  npx hyperframes render "$WORK" --composition "scene_$1.html" \
    -o "$WORK/dive_$1.mp4" \
    > "$WORK/dive_$1.render.log" 2>&1
  if [ -f "$WORK/dive_$1.mp4" ] && [ -s "$WORK/dive_$1.mp4" ]; then
    echo "dive $1 ok"
  else
    echo "dive $1 FAIL"
  fi
}

for n in $NAMES; do render_scene "$n" & done ; wait
```

Re-roll individual failures by running `render_scene shop` again.

### Mobile compositions (Step 4 / §6b)

If `MOBILE=yes`:

```bash
build_scene_mobile() { # name
  python3 - "$WORK" "$1" "$CAMERA_MOTION" "$DIVE_DUR" <<'PY'
import sys
from pathlib import Path
work, name, motion, dur = sys.argv[1:5]
base = Path('/home/quimaira/.agents/skills/scroll-world/references')
tmpl = (base / 'composition-template-mobile.html').read_text()
out = tmpl.replace('{{STILL_PATH}}', f'still_{name}.png') \
          .replace('{{COMPOSITION_ID}}', f'scene-{name}-m') \
          .replace('{{DURATION}}', dur) \
          .replace('{{CAMERA_MOTION}}', motion)
Path(f'{work}/scene_{name}_m.html').write_text(out)
PY
}

for n in $NAMES; do build_scene_mobile "$n"; done

render_scene_mobile() { # name
  npx hyperframes render "$WORK" --composition "scene_${1}_m.html" \
    -o "$WORK/dive_${1}_m.mp4" \
    > "$WORK/dive_${1}_m.render.log" 2>&1
  if [ -f "$WORK/dive_${1}_m.mp4" ] && [ -s "$WORK/dive_${1}_m.mp4" ]; then
    echo "dive $1 mobile ok"
  else
    echo "dive $1 mobile FAIL"
  fi
}

for n in $NAMES; do render_scene_mobile "$n" & done ; wait
```

## 3. Connector clips (Step 5, only if TRANSITIONS=connectors)

Build connector compositions between adjacent pairs:

```bash
build_connector() { # i prev next
  python3 - "$WORK" "$1" "$2" "$3" "$CONN_DUR" <<'PY'
import sys
from pathlib import Path
work, i, prev, nxt, dur = sys.argv[1:6]
base = Path('/home/quimaira/.agents/skills/scroll-world/references')
tmpl = (base / 'connector-template.html').read_text()
out = tmpl.replace('{{CURRENT_STILL}}', f'still_{prev}.png') \
          .replace('{{NEXT_STILL}}', f'still_{nxt}.png') \
          .replace('{{COMPOSITION_ID}}', f'conn-{i}') \
          .replace('{{DURATION}}', dur)
Path(f'{work}/conn_{i}.html').write_text(out)
PY
}

set -- $NAMES
i=0; prev=""
for n in "$@"; do
  if [ -n "$prev" ]; then
    i=$((i+1))
    build_connector "$i" "$prev" "$n"
  fi
  prev="$n"
done
```

Render connectors:

```bash
render_conn() { # i
  npx hyperframes render "$WORK" --composition "conn_$1.html" \
    -o "$WORK/conn_$1.mp4" \
    > "$WORK/conn_$1.render.log" 2>&1
  if [ -f "$WORK/conn_$1.mp4" ] && [ -s "$WORK/conn_$1.mp4" ]; then
    echo "conn $1 ok"
  else
    echo "conn $1 FAIL"
  fi
}

for f in "$WORK"/conn_*.html; do
  i=$(basename "$f" .html | sed 's/conn_//')
  render_conn "$i" &
done ; wait
```

Mobile connectors (only if `MOBILE=yes`):

```bash
build_connector_mobile() { # i prev next
  python3 - "$WORK" "$1" "$2" "$3" "$CONN_DUR" <<'PY'
import sys
from pathlib import Path
work, i, prev, nxt, dur = sys.argv[1:6]
base = Path('/home/quimaira/.agents/skills/scroll-world/references')
tmpl = (base / 'connector-template-mobile.html').read_text()
out = tmpl.replace('{{CURRENT_STILL}}', f'still_{prev}.png') \
          .replace('{{NEXT_STILL}}', f'still_{nxt}.png') \
          .replace('{{COMPOSITION_ID}}', f'conn-{i}-m') \
          .replace('{{DURATION}}', dur)
Path(f'{work}/conn_{i}_m.html').write_text(out)
PY
}

set -- $NAMES
i=0; prev=""
for n in "$@"; do
  if [ -n "$prev" ]; then
    i=$((i+1))
    build_connector_mobile "$i" "$prev" "$n"
  fi
  prev="$n"
done

render_conn_mobile() { # i
  npx hyperframes render "$WORK" --composition "conn_$1_m.html" \
    -o "$WORK/conn_$1_m.mp4" \
    > "$WORK/conn_$1_m.render.log" 2>&1
  if [ -f "$WORK/conn_$1_m.mp4" ] && [ -s "$WORK/conn_$1_m.mp4" ]; then
    echo "conn $1 mobile ok"
  else
    echo "conn $1 mobile FAIL"
  fi
}

for f in "$WORK"/conn_*_m.html; do
  i=$(basename "$f" .html | sed 's/conn_//; s/_m$//')
  render_conn_mobile "$i" &
done ; wait
```

## 4. Encode for scrubbing (Step 6)

Native resolution, GOP 8, light sharpen, no audio, faststart:

```bash
enc() {
  ffmpeg -v error -y -i "$1" -an \
    -vf "unsharp=5:5:0.8:5:5:0.0" \
    -c:v libx264 -preset slow -crf 20 -pix_fmt yuv420p \
    -g 8 -keyint_min 8 -sc_threshold 0 -movflags +faststart "$2"
  echo "enc $2 $(du -h "$2" | cut -f1)"
}

for n in $NAMES; do
  enc "$WORK/dive_$n.mp4" "$ASSETS/vid/$n.mp4"
done

if [ "$MOBILE" = "yes" ]; then
  for n in $NAMES; do
    enc "$WORK/dive_${n}_m.mp4" "$ASSETS/vid/${n}-m.mp4"
  done
fi

if [ "$TRANSITIONS" = "connectors" ]; then
  i=0
  for f in "$WORK"/conn_*.mp4; do
    i=$((i+1))
    enc "$f" "$ASSETS/vid/conn$i.mp4"
  done
  if [ "$MOBILE" = "yes" ]; then
    i=0
    for f in "$WORK"/conn_*_m.mp4; do
      i=$((i+1))
      enc "$f" "$ASSETS/vid/conn$i-m.mp4"
    done
  fi
fi
```

Extract poster frames:

```bash
for n in $NAMES; do
  ffmpeg -v error -ss 0 -i "$ASSETS/vid/$n.mp4" -frames:v 1 -q:v 2 "$ASSETS/${n}-poster.webp"
  if [ "$MOBILE" = "yes" ]; then
    ffmpeg -v error -ss 0 -i "$ASSETS/vid/${n}-m.mp4" -frames:v 1 -q:v 2 "$ASSETS/${n}-m-poster.webp"
  fi
done
```

## 5. Wire the engine config (Step 7)

After encoding, your assets are:

- Desktop clips: `assets/vid/<name>.mp4`
- Mobile clips: `assets/vid/<name>-m.mp4`
- Desktop posters: `assets/<name>-poster.webp`
- Mobile posters: `assets/<name>-m-poster.webp`
- Connectors (if any): `assets/vid/conn1.mp4, ...`
- Mobile connectors: `assets/vid/conn1-m.mp4, ...`

See `references/index-template.html` for a ready-to-copy config.

## Notes

- `.env` handling is optional; you can also `export POLLINATIONS_API_KEY=...`
  directly.
- If a Pollinations generation returns HTML instead of PNG (rare), retry after a
  few seconds — it usually means transient overload.
- HyperFrames render output paths must be writable; `/tmp/scroll-world` is used
  by default.
- If `npx hyperframes render` fails, read `$WORK/*.render.log` for lint/runtime
  errors.
- For `CAMERA_MOTION=journey`, keep the end state of scene i close to the start
  state of scene i+1 so crossfade reads as continuous flight.
- Connectors add (N-1) extra renders. For a 6-scene chain that means 5 more
  renders desktop + 5 mobile. Budget time accordingly.

# Skill: scroll-world

# scroll-world

Crea una landing page donde el **scroll mueve una cámara** a través de un mundo
visual. A diferencia de la versión anterior, esta skill **no usa video generado
por IA de pago**. En su lugar:

- Las escenas son **imágenes generadas gratis con Pollinations.ai** o assets del
  usuario.
- El movimiento de cámara se construye con **HyperFrames** (HTML + GSAP) y se
  renderiza a MP4.
- La página usa un motor de scrub vanilla (`scrub-engine.js`) que reproduce los
  clips según la posición de scroll.

**Lo que generas:** N imágenes de escena → N clips de cámara animada →
transiciones entre escenas (crossfade directo o conectores HyperFrames) → una
página scroll-scrubbed lista para publicar.

**Regla que hace o rompe la experiencia:** la transición entre escenas debe ser
suave. Si usas crossfade directo, las imágenes deben tener paleta y estilo
parecidos. Si usas conectores, deben renderizarse a la misma duración y
resolución que los clips principales. Lee [Step 5](#step-5--conectores-opcional)
antes de decidir.

El motor de scrub es vanilla JS, sin dependencias de framework. Pega
`scrub-engine.js` en tu proyecto, dale un contenedor y un config. Funciona en
HTML plano, Next.js, Vue, Python-served pages, etc.

---

## Step 0 — Bootstrap

1. **HyperFrames CLI.** Verifica que `npx hyperframes --version` funcione. Si no
   está instalado, se descargará automáticamente en el primer `npx`. Recomendado
   mantenerlo actualizado con `npx hyperframes@latest upgrade --project .` si
   renderizas dentro de un proyecto con pin antiguo.
2. **Pollinations.ai key (opcional pero recomendada).** Regístrate gratis en
   https://enter.pollinations.ai y genera una Secret Key (`sk_...`). La skill la
   lee de uno de estos lugares, en orden de prioridad:

   - `./.env` en el proyecto (override local)
   - `~/.config/scroll-world/.env` (global)

   Ejemplo de contenido:

   ```bash
   POLLINATIONS_API_KEY=sk_...
   ```

   Sin key la skill funciona en modo anónimo: 1 imagen cada 15 segundos y puede
   incluir watermark. Con key el rate sube y se quita el watermark.
3. **ffmpeg / ffprobe** en `$PATH` (para re-encode y extracción de posters).
4. **Python 3 + PIL** (`python3 -c "import PIL"`) si vas a usar el knockout de
   fondo en Step 3. Opcional.
5. **cwebp** opcional — para convertir PNG a WebP más liviano.

---

## Step 1 — Interview the user

El **tema lo define el usuario**. Haz la pregunta abierta: *"¿De qué quieres que
sea este mundo? Tu negocio, un cliente, una idea — una frase basta."*

Luego cubre estos puntos:

1. **Subject** — negocio + pitch de una línea + nombre de marca.
2. **Brand kit** — ofrece tres caminos:
   - El usuario entrega paleta + nombre + tono.
   - Propones tú una paleta y la aprueba.
   - Extraer de una URL (más manual; queda fuera del flujo automático).
   Captura **4–6 hexes nombrados**, nombre display y una palabra de tono.
3. **Art direction** — estilo visual compartido para todas las escenas. Default:
   *"diorama 3D low-poly de arcilla mate, isométrico, tilt-shift, luz cálida"*.
   Alternativas: papercraft plano, juguete brillante, claymation, noche neón,
   fotoreal arquitectónico.
4. **Camera style** — siempre pregunta, no elijas en silencio:
   - **"Vuelo suave con zoom"** — Ken Burns sobre cada escena. Default.
   - **"Paneo lateral"** — cámara se desplaza horizontalmente.
   - **"Viaje continuo"** — cada escena anima hacia la siguiente dirección.
5. **The journey (sections)** — 5–7 escenas ordenadas. Para cada una: id, label,
   subject del diorama, eyebrow, headline, body, 0–3 tags. La última escena es el
   hero product + CTA.
6. **Mobile version** — pregunta siempre:
   *"¿Quieres versión móvil nativa 9:16? Es un segundo render vertical, no un
   recorte del landscape."*
   Opciones: **Desktop only** / **Desktop + mobile nativo 9:16**.
7. **Transiciones** — pregunta:
   *"¿Transiciones directas con crossfade, o conectores animados entre escenas?
   Algunos conceptos no se ven bien con crossfade puro."*
   - **Crossfade** — más rápido, menos renders.
   - **Conectores** — un clip corto entre cada par de escenas; más cinematico.
8. **Fuente de imágenes** — elige una:
   - **Pollinations.ai** (default) — genera desde prompts con la key configurada.
   - **Assets propios** — el usuario entrega imágenes 3:2 por escena.
   - **HeyGen search** — búsqueda de assets genéricos (requiere `heygen auth
     login --oauth`); solo como fallback.

Consulta `references/prompts.md` para la checklist de intake y estructura de
copy.

---

## Step 2 — Generate the scene stills

### Opción A — Pollinations.ai (default)

Todas las imágenes comparten el mismo **style preamble** para cohesión. Plantilla
completa en `references/prompts.md`.

Prompt shape:

```
<STYLE PREAMBLE>. Plain solid <bg> background with soft contact shadow.
<PALETTE hexes>. No text, no letters, no logos, centered composition, 3:2 aspect.
Subject: <what is in THIS diorama>.
```

Comando por escena (reemplaza espacios por `%20` o usa `jq -sRr '@uri'`):

```bash
PROMPT="$(cat "$WORK/still_$name.txt")"
ENCODED="$(printf '%s' "$PROMPT" | jq -sRr '@uri')"
curl -fsSL "https://gen.pollinations.ai/image/${ENCODED}?model=flux&width=1536&height=1024&seed=${SEED}&nologo=true&private=true" \
  -H "Authorization: Bearer ${POLLINATIONS_API_KEY}" \
  -o "$WORK/still_$name.png"
```

- `model`: `flux` (default), `zimage` o `klein`. Prueba con `flux` primero.
- `width=1536&height=1024` da 3:2, suficiente para 1080p.
- Usa `seed` distinto por escena o fijo para consistencia.
- Corre las N generaciones en paralelo. Respeta el rate limit (1 cada 15s
  anónimo, 1 cada 5s con key).
- Revisa las imágenes antes de continuar. Si una está fuera de estilo,
  regenérala cambiando `seed` o ajustando el prompt.

### Opción B — Assets propios

El usuario entrega imágenes por escena. Requisitos:
- Formato PNG o JPG.
- Aspecto 3:2 (o que pueda recortarse a 16:9 sin perder el foco).
- Fondo sólido si se quiere hacer knockout (Step 3).
- Nombrar como `still_<id>.png` y copiar a `$WORK`.

### Convertir a WebP

```bash
for n in $NAMES; do
  cwebp -quiet -q 84 -resize 1800 0 "$WORK/still_$n.png" -o "$ASSETS/$n.webp"
done
```

Si no tienes `cwebp`, usa ffmpeg:

```bash
ffmpeg -i "$WORK/still_$n.png" -q:v 84 "$ASSETS/$n.webp"
```

---

## Step 3 — (Optional) Float the scenes

Si quieres que las escenas floten sobre un fondo atmosférico en lugar de verse
como cajas sólidas, quita el fondo con `references/knockout.py` (flood fill desde
bordes). Luego encodea a WebP con alpha.

Las imágenes sólidas también sirven como posters y fallback lazy-load, así que
mantén ambas versiones.

---

## Step 4 — HyperFrames compositions (camera clips)

Cada escena se convierte en una composición HTML renderizable por HyperFrames.
La plantilla base está en `references/composition-template.html`. Los conceptos
clave:

- Root con `data-composition-id`, `data-width="1920"`, `data-height="1080"`,
  `data-duration="8"`.
- Una imagen de fondo a pantalla completa.
- Un `gsap.fromTo()` que anime `scale`, `x`, `y` (y opcionalmente `rotate`) para
  simular movimiento de cámara.
- Sin audio.
- Determinista: usa valores fijos, no `Math.random`.

Ejemplo de movimiento según camera style elegido en Step 1.4:

- **Zoom suave:** `scale: 1 → 1.25`, leve `x/y` drift.
- **Paneo lateral:** `x: 0 → -300`, `scale: 1.05`.
- **Viaje continuo:** la escena i termina acercándose hacia la derecha; la
  escena i+1 empieza desde una posición similar para que el crossfade sea
  continuo.

Renderiza cada escena:

```bash
npx hyperframes render "$WORK" --composition "scene_$name.html" \
  -o "$WORK/dive_$name.mp4"
```

Para **mobile 9:16** usa `references/composition-template-mobile.html` con
`data-width="1080" data-height="1920"`. Renderiza a `$WORK/dive_${name}_m.mp4`.

Guarda los clips fuente. Necesitarás sus primeros frames como posters.

---

## Step 5 — Connectors (optional)

Si el usuario eligió **crossfade directo**, salta este paso. El
`scrub-engine.js` se encarga de la disolución entre clips.

Si eligió **conectores**, crea una composición HyperFrames corta (5s) entre cada
par de escenas adyacentes. Plantilla en
`references/connector-template.html`. Técnicas posibles:

- Zoom out de la escena A mientras la escena B aparece por detrás.
- Paneo lateral de A a B usando dos capas.
- Disolución con movimiento de cámara continuo.

Renderiza:

```bash
npx hyperframes render "$WORK" --composition "conn_$i.html" \
  -o "$WORK/conn_$i.mp4"
```

Para mobile, renderiza `$WORK/conn_${i}_m.mp4` con la plantilla móvil.

---

## Step 6 — Encode for smooth scrubbing

HyperFrames ya renderiza MP4, pero para scrubbing conviene re-encodear con
ffmpeg:

```bash
enc() {
  ffmpeg -v error -y -i "$1" -an \
    -vf "unsharp=5:5:0.8:5:5:0.0" \
    -c:v libx264 -preset slow -crf 20 -pix_fmt yuv420p \
    -g 8 -keyint_min 8 -sc_threshold 0 -movflags +faststart "$2"
}

for n in $NAMES; do
  enc "$WORK/dive_$n.mp4" "$ASSETS/vid/$n.mp4"
done

# Mobile
for n in $NAMES; do
  enc "$WORK/dive_${n}_m.mp4" "$ASSETS/vid/${n}-m.mp4"
done

# Connectors (si existen)
i=0; for f in "$WORK"/conn_*.mp4; do
  i=$((i+1)); enc "$f" "$ASSETS/vid/conn$i.mp4"
done
i=0; for f in "$WORK"/conn_*_m.mp4; do
  i=$((i+1)); enc "$f" "$ASSETS/vid/conn$i-m.mp4"
done
```

Extrae el primer frame de cada clip como poster:

```bash
for n in $NAMES; do
  ffmpeg -v error -ss 0 -i "$ASSETS/vid/$n.mp4" -frames:v 1 -q:v 2 "$ASSETS/$n-poster.webp"
done
```

---

## Step 7 — Assemble the page

Copia `references/scrub-engine.js` y adapta `references/index-template.html` en
tu proyecto. Es config-driven:

```js
mountScrollWorld(document.getElementById('world'), {
  brand: { name: 'Marca' },
  hint: 'scroll para volar',
  diveScroll: 1.3,
  connScroll: 0.9,
  sections: [
    {
      id: 'farm', label: 'La Granja',
      still: 'assets/farm.webp',
      stillMobile: 'assets/farm-m.webp',
      clip: 'assets/vid/farm.mp4',
      clipMobile: 'assets/vid/farm-m.mp4',
      accent: '#8FB98A',
      eyebrow: 'Desde la hoja hasta el último sorbo',
      title: 'Todo empieza en las colinas.',
      body: '...',
      tags: ['Origen único', 'Recolección manual'],
    },
    // ... más escenas
  ],
  connectors: [
    'assets/vid/conn1.mp4',
    // ... length = sections.length - 1; null para crossfade directo
  ],
  connectorsMobile: [
    'assets/vid/conn1-m.mp4',
  ],
});
```

Pacing:
- `scroll` por escena: más scroll = más tiempo en esa escena.
- `linger`: 0–0.6, pausa la cámara en el centro de la escena mientras el copy
  brilla.

El motor detecta móvil (`coarse` pointer o ≤860px), sirve `clipMobile` cuando
existe, coalescea seeks y hace prime en iOS. Sin configuración extra.

---

## Step 8 — QA the seams

1. Abre la página localmente (`python3 -m http.server` o similar).
2. Verifica que los videos carguen como Blob y `video.seekable.end(0) > 0`.
3. Scrollea lentamente: el `currentTime` debe seguir al scroll en cada clip.
4. Si usas conectores, revisa que la transición A→B no salte.
5. Si usas crossfade directo, revisa que las dos escenas vecinas no cambien
drásticamente de color/composición en el punto de cruce.
6. En móvil (DevTools portrait + CPU throttle):
   - Se sirve el `-m.mp4`.
   - El poster aparece antes de que el video pinte.
   - Scroll rápido no congela el clip.
7. `prefers-reduced-motion` debe mostrar solo los stills, sin video.

---

## Gotchas

- **Sin `POLLINATIONS_API_KEY`** la generación funciona pero es lenta y puede
  poner watermark. Siempre configura la key en proyectos reales.
- **Rate limit de Pollinations:** con key 1 img/5s; anónimo 1 img/15s. Lanza en
  paralelo con cuidado y respeta el límite.
- **Crossfade brusco:** si dos escenas tienen fondos muy distintos, el crossfade
  directo se ve feo. Usa conectores o unifica la paleta.
- **HyperFrames `lint` rechaza transform CSS + GSAP en mismo elemento.** Define
  el estado inicial dentro del `fromTo`, no en CSS.
- **No pongas `crossorigin` en `<video>`/`<img>` de HyperFrames.** `lint`
  rechaza.
- **Fuentes personalizadas en HyperFrames:** necesitan `@font-face` a archivo
  local, o `lint` falla.
- **La raíz de una composición standalone debe tener `width/height: 100%`**, no
  píxeles fijos. El tamaño del canvas va en `data-width/data-height`.
- **Videos atascados en frame 0:** el `scrub-engine.js` carga clips como Blob,
  así que esto normalmente no pasa. Si pasa, revisa que el host sirva los MP4
  correctamente.
- **Calidad baja:** no escales los clips hacia abajo. Renderiza 1920×1080 y
  encodea nativo.

---

## References

- `references/prompts.md` — intake checklist, style preamble, prompts de
  Pollinations, prompts de animación GSAP, copy por sección.
- `references/pipeline.md` — scripts copy-paste para generar stills, renderizar
  composiciones, encodear, extraer posters.
- `references/composition-template.html` — plantilla HyperFrames 16:9.
- `references/composition-template-mobile.html` — plantilla HyperFrames 9:16.
- `references/connector-template.html` — plantilla de transición A→B.
- `references/scrub-engine.js` — motor de scroll vanilla.
- `references/index-template.html` — página de ejemplo.
- `references/knockout.py` — knockout de fondo sólido.

Base directory for this skill: /home/quimaira/.agents/skills/scroll-world
Relative paths in this skill are relative to this base directory.

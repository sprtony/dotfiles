# Prompt templates & intake

Todo aquí es rellenar slots. Mantén el **style preamble** idéntico en todas las
escenas — esa repetición es lo que hace que el mundo se sienta un solo lugar.

## Intake checklist (Step 1)

Anota antes de renderizar:

- `SUBJECT` — negocio + pitch de una línea.
- `BRAND_NAME` — nombre display.
- `PALETTE` — 4–6 hexes nombrados, e.g. `taro #9B7EBD, crema #F5EDE0, caramelo
  #C88A5A, matcha #8FB98A, ciruela #3A2E48`. Elige uno como fondo de escena
  (normalmente el más claro) y uno como acento primario.
- `TONE` — una o dos palabras (acogedor/premium, juguetón, industrial...).
- `STYLE` — dirección de arte (default más abajo).
- `SECTIONS[]` — lista ordenada. Por cada una: `id`, `label`, `subject` (qué hay
  en el diorama), `eyebrow`, `title`, `body` (≤1 oración), `tags[]` (0–3). La
  última sección es hero product + CTA.
- `CAMERA` — zoom_suave (default) | paneo_lateral | viaje_continuo.
- `MOBILE` — yes | no.
- `CONNECTORS` — crossfade (default, rápido) | hyperframes (más cinematico).
- `IMAGE_SOURCE` — pollinations (default) | assets | heygen.
- `VIDEO_TIER` — eliminado; todo se renderiza con HyperFrames.

## Style preamble (default: clay diorama)

Reutilizar textualmente en cada prompt. Cambia solo los bracketed bits por la
paleta y fondo de la marca.

```
Isometric low-poly 3D diorama floating as a small rounded island on a plain solid
[BG_HEX] background with a soft contact shadow beneath it. Soft matte clay 3D render,
rounded toy-model shapes, gentle warm studio lighting, soft long shadows, tilt-shift
miniature look. Cohesive color palette of [PALETTE]. Highly detailed, centered
composition, absolutely no text, no letters, no numbers, no logos.
```

Direcciones alternativas (cambia las primeras dos oraciones, mantén la cola de
paleta/sin texto):

- **Flat papercraft:** "Isometric layered paper-craft diorama, matte cardstock,
  clean die-cut edges, subtle drop shadows between layers."
- **Glossy toy:** "Isometric glossy vinyl-toy diorama, smooth plastic shading,
  soft rim light, collectible figurine look."
- **Claymation:** "Isometric stop-motion clay set, visible thumbprints, handmade
  plasticine texture, soft studio softbox light."
- **Neon night:** "Isometric miniature at night, warm interior glow and neon
  signage, moody rim light, wet reflective ground."
- **Photoreal architectural:** "Ultra-photorealistic architectural photography of
  a single cohesive [subject], cinematic wide-angle, warm golden-hour light,
  natural materials, restrained designer furnishings, breathtaking view,
  editorial magazine quality, shallow depth of field, no people." Para photoreal
  no uses floating-island ni knockout; las escenas son full-bleed.

## Scene still prompt (Step 2 — Pollinations.ai)

```
[STYLE PREAMBLE]
Subject: [SECTION.subject — describe la escena miniatura: edificio/espacio,
personajes haciendo el trabajo, props que señalen esta etapa del negocio].
```

Consejos:
- Nombra props concretos (tanques, Calderos, conveyor, cajas, toldos, luces,
  bancos, scooters).
- Para la última sección de hero product, quita el encuadre de isla-diorama y
  pide un producto central grande flotando con pequeños props orbitando.
- **Compón para el centro.** El encuadre final es 16:9. Mantén el sujeto focal
  centrado horizontalmente con espacio arriba. La versión móvil 9:16 usará el
  mismo prompt pero distinto canvas.
- Aspecto final 3:2; Pollinations se pedirá `width=1536&height=1024`.

URL encodeada de ejemplo:

```
https://gen.pollinations.ai/image/{prompt_uri}?model=flux&width=1536&height=1024&seed=42&nologo=true&private=true
```

## Camera motion guide for HyperFrames (Step 4)

La composición es un `<div data-composition-id="..." data-width="1920"
data-height="1080" data-duration="8">` con una imagen de fondo a pantalla
completa. La cámara se anima con GSAP sobre esa imagen. Nunca uses CSS
`transform` inicial si luego GSAP anima la misma propiedad; usa `gsap.fromTo`.

### Zoom suave (default)

```js
gsap.fromTo('.bg',
  { scale: 1, x: 0, y: 0 },
  { scale: 1.25, x: '-5vw', y: '-3vh', duration: 8, ease: 'power1.inOut' }
);
```

### Paneo lateral

```js
gsap.fromTo('.bg',
  { scale: 1.08, x: '12vw' },
  { scale: 1.08, x: '-12vw', duration: 8, ease: 'power1.inOut' }
);
```

### Viaje continuo (preparado para crossfade)

Cada escena termina acercándose hacia la siguiente dirección. La siguiente
empieza desde una posición similar para que el crossfade sea continuo.

```js
// Escena i: entra desde la derecha, se asienta
gsap.fromTo('.bg',
  { scale: 1.15, x: '15vw' },
  { scale: 1.05, x: '-5vw', duration: 8, ease: 'power1.inOut' }
);

// Escena i+1: continúa desde posición similar
// (la siguiente composición empieza con scale 1.05, x -5vw y anima a scale 1.2, x -15vw)
```

### Mobile 9:16

Mismo movimiento, pero la imagen debe componerse para vertical. Usa
`data-width="1080" data-height="1920"` y ajusta el `object-position` de la
imagen a `center 40%` si el foco debe quedar arriba del centro.

## Connector prompt / guide (Step 5)

Si usas conectores HyperFrames, la composición tiene dos capas:

```html
<div class="conn">
  <img class="conn__b" src="still_next.png" />
  <img class="conn__a" src="still_current.png" />
</div>
```

Animación de ejemplo:

```js
const tl = gsap.timeline();
tl.fromTo('.conn__a',
  { scale: 1.05, x: 0, opacity: 1 },
  { scale: 1.3, x: '-20vw', opacity: 0, duration: 5, ease: 'power2.inOut' }, 0
);
tl.fromTo('.conn__b',
  { scale: 1.3, x: '20vw', opacity: 0 },
  { scale: 1.05, x: 0, opacity: 1, duration: 5, ease: 'power2.inOut' }, 0
);
```

Para transiciones más suaves, ambas imágenes deben compartir paleta y tono.

## Copy per section (for the engine config)

- `eyebrow` — 2–4 palabras, label de valor.
- `title` — 3–6 palabras, headline del beat.
- `body` — una oración, lenguaje simple, desde el visitante.
- `tags` — 0–3 chips cortos (e.g. "Cocido fresco", "Entrega 30 min").

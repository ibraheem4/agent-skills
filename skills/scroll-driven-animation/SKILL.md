---
name: scroll-driven-animation
description: Use when building scroll-linked motion on a web page — a pinned product demo that assembles as you scroll, section backgrounds that change on scroll, reveal-on-enter, a scroll progress bar, or a sticky nav that inverts over dark sections. Also use when reaching for GSAP ScrollTrigger, Framer Motion, Lenis or AOS, and when a scroll animation renders blank, never starts, or sits at its first frame.
---

# Scroll-driven animation

**Native CSS does this now. Do not install a library.** `animation-timeline: scroll()` and `view()`
are supported in Chrome/Edge 115+, Firefox 132+, Safari 18+ — around 84% globally as of mid-2026 —
and `transform`/`opacity` run on the compositor thread, which is the thing JS scroll libraries fight
and lose.

## The one rule that makes it safe

**Author the un-animated state as the finished state.** Put the animation behind `@supports` and
`prefers-reduced-motion`, and let the base CSS be what you want a non-supporting browser to show.

```css
.tint::before{ opacity:1 }                       /* the truth */
@supports (animation-timeline:view()){
  @media (prefers-reduced-motion:no-preference){
    .tint::before{ opacity:0; animation:fade linear both;
      animation-timeline:view(); animation-range:entry 10% entry 90% }
  }
}
@keyframes fade{ to{ opacity:1 } }
```

Get this backwards and the ~16% without support — plus everyone with reduced motion — see an
invisible page. No polyfill needed, and no JS.

## Pinned sequence: one named timeline, many beats

For a demo that assembles while held in place, **name one timeline on the tall scroller** and have
every part reference it. Per-element `view()` makes each part run on its own clock and the beats
drift apart.

```css
.scroller{ height:340vh; view-timeline:--demo block }   /* the clock */
.pin{ position:sticky; top:11vh; height:78vh }          /* holds the mock still */
.step{ animation:in linear both; animation-timeline:--demo }
.s1{ animation-range:contain  2% contain 12% }
.s2{ animation-range:contain 12% contain 22% }
```

`contain` is the right range for a subject taller than the viewport: it is the long stretch where
the subject fully covers the screen, which is exactly the window a pinned sequence should occupy.
Animated parts must be **descendants** of the element declaring the timeline, or add `timeline-scope`
on a common ancestor.

## Choose the right tool for the change

| Change | Use |
|---|---|
| Continuous, tied to position | scroll timeline (`scroll()`, `view()`, named) |
| **Discrete state flip** — nav inverting over a dark band | **IntersectionObserver.** A timeline is for progress; using one for a boolean is fighting the tool |
| A section's ground colour | Animate an **overlay's `opacity`**, not `background-color` — opacity composites, background-color repaints |

## Failures, each one hit in practice

| Symptom | Cause |
|---|---|
| Sticky pin does nothing | **`overflow-x:hidden` on `html` or `body`** establishes a scroll container and breaks `position:sticky` for every descendant. Use `overflow-x:clip`, which does not |
| A section will not stack on mobile | An **inline `grid-template-columns`** out-ranks the media query meant to collapse it. Drive columns through a custom property — inline sets `--cols`, the media query sets the property, and the media query wins |
| Animation sits at its first frame | The timeline is inactive. Check with `el.getAnimations()[0].timeline` — if it is `null` the name did not resolve; if it is a `ViewTimeline` the lookup worked and the **range** is wrong |

## Verifying it — do not trust headless

Headless Chrome mis-reports this in at least four ways, all observed:

- **Minimum viewport is ~500px.** A `--window-size=390,900` screenshot is a 500px layout cropped
  into a 390px image. It invents overflow and hides real breakage. Test narrow layouts by loading
  the page in a **390px `<iframe>`** inside a larger window.
- **`--screenshot` does not reliably capture a scrolled position.** You get a blank frame.
- **`scroll-behavior:smooth` makes `scrollTo` an animation** that virtual time never completes, so
  the probe silently stays at `scrollY=0`. Set `scrollBehavior='auto'` first.
- **`--virtual-time-budget` advances *time*; scroll timelines advance on *scroll*.** Reported
  `currentTime` can contradict the geometry.

So: verify **support and wiring** programmatically, and verify **timing** in a real browser.

```js
const a = el.getAnimations()[0];
a.timeline.constructor.name   // "ViewTimeline" means the name resolved
a.currentTime                 // null = inactive
```

Ship a small on-page read-out during development so what you are looking at is never ambiguous.

## Before it ships

- [ ] Un-animated state is the finished state, verified by disabling the `@supports` block
- [ ] `prefers-reduced-motion` honoured
- [ ] No `overflow-x:hidden` on `html` or `body`
- [ ] Only `transform` and `opacity` animate
- [ ] Timing judged by scrolling in a real browser, never from a headless screenshot

## Restraint

The technique being free makes it easier to overuse, not more appropriate. Before adding a second
scroll effect, check what the sites you admire actually do — many ship **zero** animation libraries
and a handful of observers. Motion should explain a mechanism, not decorate one.

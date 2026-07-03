# Design.md — Dristi Fashions App Home Screen

## Brand

**Dristi Fashions** — *Fashion That Reflects Your Personality.*
Identity is a deep **royal blue** field with **gold** accents, taken directly from the logo (gold "DF" monogram, gown & blazer, woman silhouette on a royal-blue ground). Royal blue drives primary actions and branding; gold is the luxury accent for highlights, ratings, festive callouts, and premium badges. Surfaces stay light and cool for shopping readability.

## Overview

**App:** Dristi Fashions (Fashion & Lifestyle E-Commerce)
**Screen:** Home Screen
**Platform:** Android Mobile (approx. 390×844pt viewport)
**Purpose:** Discovery-first landing — drive browsing across fashion, beauty, footwear, and home categories through sales, banners, and brand spotlights.

---

## Color Palette

Canonical values live in [`lib/core/constants/app_colors.dart`](lib/core/constants/app_colors.dart).

| Token | Hex | Usage |
|---|---|---|
| `primary` (royal blue) | `#1A2A80` | Logo, active tab indicator, CTA backgrounds, input focus, links, selected chips |
| `primaryDark` | `#10195E` | Splash/footer backgrounds, pressed states, native launch splash |
| `primaryContainer` | `#243AA0` | Brighter royal for gradients & filled containers |
| `brandGold` / `festiveGold` | `#C9A227` | Wordmark, festive highlights, ratings, "new" badges — the luxury accent |
| `brandGoldLight` | `#E6C766` | Gold gradient stop, subtle gold highlights |
| `surface` / `scaffoldBg` | `#FBFBFE` / `#F7F8FD` | App background, card surfaces (cool light) |
| `surfaceWarm` / `heroBg` | `#EEF1FF` | Subtle cool tint behind hero banner |
| `onSurface` (text primary) | `#181A2C` | Primary text, nav labels |
| `textSecondary` | `#44465A` | Sub-labels, descriptive copy |
| `discountGreen` | `#27AE60` | Discount % / savings |
| `saleOrange` / `urgencyOrange` | `#FF6B00` | Urgency & sale-strip accent (complements blue/gold) |
| `divider` | `#E2E3ED` | Hairline separators between sections |

---

## Typography

| Role | Typeface | Weight | Size (approx.) | Notes |
|---|---|---|---|---|
| Display / Sale Heading | **Poppins** or system sans-serif | 800 ExtraBold | 28–32px | "UP TO 50% OFF", "STYLISH STEALS" — all caps, tight letter-spacing |
| Section Label | **Poppins** | 600 SemiBold | 14–16px | Category names (Fashion, Beauty, etc.) |
| Search Placeholder | **Poppins** | 400 Regular | 15px | Quoted keyword style: `"Joggers"` |
| Body / Price Copy | **Roboto** / System | 400 Regular | 12–13px | Discount fine print, offer descriptions |
| Brand Name (banners) | Brand-specific / Bold | 700 Bold | 16–20px | Jack & Jones, Libas, Timex, Rare Rabbit |
| Tab Labels | **Poppins** | 600 SemiBold | 13px | ALL, MEN, WOMEN, KIDS — all caps |

---

## Layout Structure

```
┌──────────────────────────────────────┐
│         STATUS BAR (system)          │
├──────────────────────────────────────┤
│  📍 Delivery Address Row             │ ← 44px
├──────────────────────────────────────┤
│  [🔍 Search Bar]  [🔔] [♥] [👤]     │ ← 56px
├──────────────────────────────────────┤
│  [ALL] [MEN] [WOMEN] [KIDS] [⋮]     │ ← Gender Filter Tabs — 40px
├──────────────────────────────────────┤
│  [Category Chips — Horizontal Scroll] │ ← 100px (icon + label)
│   Fashion | Beauty | Homeliving...   │
├──────────────────────────────────────┤
│                                      │
│     Hero Banner (Full Width)         │ ← ~400px, auto-carousel
│     [Brand Ad — New Balance]         │
│     Dot indicators at bottom         │
│                                      │
├──────────────────────────────────────┤
│  Powered By: [Libas] [Rare Rabbit]   │ ← Horizontal brand strip — 48px
├──────────────────────────────────────┤
│  [MIRAGGIO] [JACK&JONES] [TIMEX]     │ ← Brand Partners strip — 48px
├──────────────────────────────────────┤
│  💳 Extra 10% Savings offer strip    │ ← 40px
├──────────────────────────────────────┤
│  [Brand of the Day] | [Stylish Steals] │ ← 2-col grid cards — 180px
├──────────────────────────────────────┤
│   ... (More scrollable content)      │
├──────────────────────────────────────┤
│  [Home] [Under ₹999] [NOW] [Luxe] [Bag 1] │ ← Bottom Nav — 60px
└──────────────────────────────────────┘
```

---

## Component Inventory

### 1. Top Address Bar
- Icon: 📍 (filled royal-blue pin)
- Text: "Deliver to {name}, {address}" — truncated with ellipsis
- Trailing dropdown chevron `˅`
- Background: transparent (over hero gradient bleed)

### 2. Search Bar
- Rounded rectangle pill, `border-radius: 24px`
- Left: Dristi "DF" gold monogram on royal-blue
- Placeholder text in quotes: `"Joggers"`
- Right: Search icon (magnifier)
- Alongside: Notification bell, Heart (wishlist), Profile icons
- Background: `#FFFFFF` with subtle `box-shadow: 0 1px 4px rgba(0,0,0,0.12)`

### 3. Gender Filter Tabs
- Options: ALL (active), MEN, WOMEN, KIDS + Grid/More icon
- Active tab: bold text + royal-blue underline indicator
- Style: flat tabs, no background pill, all caps

### 4. Category Chips (Horizontal Scroll)
- Circular image thumbnails (~64px diameter)
- Label below in 13px semi-bold
- Slight `border-radius: 50%` with thin border/shadow
- Categories: Fashion, Beauty, Homeliving, Footwear, Accessories

### 5. Hero Banner Carousel
- Full-bleed width with ~16px horizontal padding or edge-to-edge
- `border-radius: 12px` card container
- Bottom-left: Sale badge overlay ("END OF REASON SALE")
- Bottom-left: Headline text + sub-copy
- Bottom-right: `AD` label chip
- Brand logo bottom-left, CTA button bottom-right
- Dot indicators: active dot slightly larger, inactive dots faded
- Auto-slides (typically 3–5s interval)

### 6. Brand Partner Strips
- Full-width royal-blue gradient (`#1A2A80 → #243AA0`) background
- "POWERED BY" label left-aligned in white/gold
- Brand logos separated by `|` dividers
- Arrow `›` CTA per brand
- Second strip: white background, brand name chips with `›`

### 7. Credit Card Offer Strip
- White card with Dristi + bank partner logos
- Small text: "Get Extra 10% Savings* With Flipkart Axis Bank & SBI Credit Cards"
- Dismissible or static

### 8. 2-Column Promo Cards
- Left: "BRAND OF THE DAY" — white card, brand name, "MIN. 65% OFF" CTA
- Right: "STYLISH STEALS" — dark/gradient card, play button overlay (video-first card)
- Equal width columns, ~8px gap, `border-radius: 10px`

### 9. Bottom Navigation Bar
- 5 items: Home, Under ₹999, NOW (Dristi Now), Luxe, Bag
- Active (Home): filled icon + royal-blue label
- Bag: badge count `1` in royal-blue circle
- Fonts: 10–11px labels
- Background: `#FFFFFF` with top divider line

---

## Spacing & Grid

| Token | Value |
|---|---|
| Page Horizontal Padding | 12–16px |
| Section Gap | 8–12px |
| Card Border Radius | 10–12px |
| Icon Button Size | 40×40px tap target |
| Bottom Nav Height | 60px |
| Category Chip Gap | 8px |

---

## Interaction Patterns

- **Search Bar:** Tap → opens search with keyboard; current query shown as pill
- **Category Chips:** Tap → filtered listing page
- **Hero Carousel:** Auto-advances; swipe left/right; dot tap navigates
- **Brand Strips:** Horizontal scroll overflow on smaller viewports
- **Bottom Nav:** Stateful active indicator; Bag shows real-time item count badge
- **CTA Buttons:** "Shop Now ›" — filled white/outlined pill buttons on dark banners

---

## Visual Hierarchy (Priority Order)

1. 🔴 **Hero Banner** — largest real estate, primary attention driver
2. 🟠 **Brand/Sale Strips** — urgency + credibility via recognizable brands
3. 🟡 **Category Chips** — utility navigation
4. 🟢 **Search Bar** — persistent utility, high accessibility
5. 🔵 **Promo Cards (2-col)** — supplementary discovery
6. ⚫ **Bottom Nav** — wayfinding

---

## Motion & Animation

| Element | Behavior |
|---|---|
| Hero Carousel | Auto-advance every ~4s, smooth horizontal slide transition |
| Promo Video Card | Inline autoplay loop (muted), play button overlay |
| Category chips | Slight scale-up on press (0.95 → 1.0 spring) |
| Bottom Nav icons | Subtle fill-animation on active state change |
| Skeleton loaders | Shimmer effect while images/data load |

---

## Accessibility Notes

- Minimum tap target: 44×44px across all interactive elements
- Color contrast: White text on royal blue (`#1A2A80`) passes AA; gold (`#C9A227`) on royal blue is decorative/large-text only — use white/light copy for body text on blue surfaces
- Search bar placeholder uses quoted keyword — ensure screen reader reads it correctly
- Carousel: include pause control for reduced-motion preference
- Badge count on Bag icon: requires `aria-label="Cart, 1 item"`

---

## Brand Identity Tokens (Dristi Fashions)

| Token | Value |
|---|---|
| Logo Mark | Gold "DF" monogram on royal blue (gown + blazer, woman silhouette) |
| Tagline | *Fashion That Reflects Your Personality* |
| Primary Brand Color | `#1A2A80` (royal blue) |
| Accent Color | `#C9A227` (gold) — highlights, ratings, premium badges |
| Sale/Urgency Color | `#FF6B00` |
| Trust/Savings Color | `#27AE60` (green for discount %) |
| Font Brand Voice | Elegant, premium, fashion-forward — gold wordmark, generous letter-spacing |

---

*This Design.md reflects the Dristi Fashions royal-blue + gold rebrand (logo-driven, July 2026). Canonical color tokens: [`lib/core/constants/app_colors.dart`](lib/core/constants/app_colors.dart).*

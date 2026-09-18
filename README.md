# MY Events Room Planner

Drag-and-drop room layout planner for events: tables with chairs, stage, dance floor,
bar, partitions and other furniture on a scale plan, exported as a branded PDF or PNG.

**Live site:** https://ybx90.github.io/MyEvents/

## Files

- `index.html` — the whole site in one file (logo and favicon embedded). Open it locally or host it anywhere static.
- `assets/` — the MY Events logo (transparent and white-background PNGs) and favicon, in case they're needed separately.

## Guests

The Guests tab lists every table seat by seat (Seat 1, Seat 2 …). Type names straight in, import a CSV/XLSX (table + name columns, optional seat column; or one row per table with names across; or 'Table 1' lines followed by names) or paste a list. Names can be moved between tables, exported as CSV, and printed as a seating-list PDF (also appended to the plan PDF). Seat numbers are printed on the chairs on the plan.

## Access code and cloud sync

The site opens with an access code screen (the code is checked locally and, once cloud sync is connected, by the database as well).

Cloud sync uses a free Supabase project: run supabase.sql once in the Supabase SQL editor, then put the project URL and anon key into the two constants near the top of the script in index.html (SB_URL, SB_KEY). Plans and halls then sync across every device that has the code. The site works offline; changes queue and send when back online. Newest change wins.

## Saving

**Save** (top bar, Ctrl+S) writes the plan to a file on your computer; **Open** loads one. In Chrome/Edge it asks where to save the first time and then overwrites that file on later saves. The browser also autosaves silently as a safety net; **Backup all** in Project downloads every project in one file.

## Updating the site

Edit `index.html`, commit, push to `main`. GitHub Pages redeploys within a minute or two.

# Business Hub

A simple shared dashboard for your businesses: **tasks, files, money and history** in one place.
Works on phone and computer. Your partners only need the link. No accounts.

> ⚠️ **Fully open:** anyone who has the link can see and change everything,
> including money and files. Only share the link with people you trust.

---

## Setup (about 15 minutes, one time only)

### Step 1 – Create the free database (Supabase)
1. Go to **supabase.com** and sign up (free).
2. Click **New project**. Give it a name (e.g. `business-hub`), make a database password (save it somewhere), choose a region close to you (e.g. *Middle East* or *Europe*), then **Create**.
3. Wait 1–2 minutes until the project is ready.
4. In the left menu open **SQL Editor** → **New query**.
5. Open the file **`setup.sql`** from this repository, copy **everything**, paste it in, and press **Run**. You should see "Success".

### Step 2 – Copy your two keys
1. In Supabase, click **Connect** at the top (or **Project Settings → API Keys**).
2. Copy the **Project URL** (looks like `https://abcd1234.supabase.co`).
3. Copy the **Publishable key** (or the key called **anon public**).
   ❌ Never use the *secret* / *service_role* key.

### Step 3 – Paste the keys into the website
1. In this GitHub repository, open **`config.js`** and click the ✏️ pencil (Edit).
2. Paste the URL and key between the quotes:
   ```js
   url: "https://abcd1234.supabase.co",
   key: "sb_publishable_xxxxxxxx"
   ```
3. Click **Commit changes**.

### Step 4 – Turn on the website (GitHub Pages)
1. In this repository go to **Settings → Pages**.
2. Under **Branch**, choose **main** and **/ (root)**, then **Save**.
3. Wait 1–2 minutes. Your link appears at the top, like
   `https://alialali8.github.io/Business-hub-/`

### Step 5 – Share
Send the link to your partners. The first time each person opens it, it asks for their name.
That name shows in **History** next to their changes.

---

## What's inside
| Tab | What it does |
|---|---|
| Home | Open tasks, late tasks, due this week, money spent this month, one card per business |
| Tasks | To do → Doing → Done board, with who, due date, priority, comments and files |
| Files | Upload any file (PDF, Word, Excel, photos, videos) up to 50 MB |
| Money | Expenses and income, receipts, budget used, spending by category, copy to Excel |
| History | Every change: who, what changed (old → new) and when |
| Setup | Add or rename businesses, set budgets, currency, your name |

## Good to know
- **Free limits (Supabase free plan):** 500 MB of data and 1 GB of files. That is a lot of tasks and money entries; big videos fill it fast.
- A free Supabase project **pauses after 1 week with no visits**. Just open Supabase and click **Restore**. Using the dashboard every few days keeps it awake.
- **Back up money data:** Money tab → **Copy as table** → paste into Excel, once a month.
- Names are not checked, so anyone can type any name.

## Files in this repository
- `index.html` – the website
- `config.js` – your 2 Supabase keys (the only file you edit)
- `setup.sql` – run once in Supabase

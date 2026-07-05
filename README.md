# benlandes.net

Static rebuild of benlandes.net — no WordPress, no HostGator, no build step. Plain HTML/CSS/JS, ready for GitHub Pages.

```
index.html            Home
projects/index.html   Projects  (was /ai-projects/)
education/index.html  Education (URL preserved: /education/)
about/index.html      About     (URL preserved: /about/)
assets/css/styles.css Design system + stacking-plan motif
assets/js/main.js     Mobile nav + scroll reveal
CNAME                 Custom domain (benlandes.net)
localize-images.sh    Pull images off WordPress into assets/images/
```

## 1. Localize the images (do this first)

The pages currently load images from WordPress's CDN (`i0.wp.com`). Until you run this, the site still depends on WordPress being alive. From the site root, with internet access:

```bash
chmod +x localize-images.sh && ./localize-images.sh
```

It downloads each image into `assets/images/` and rewrites the HTML to point there. After it succeeds, the site is fully self-contained.

## 2. Preview locally

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

Use a server, not double-click — `file://` won't resolve the cross-page links cleanly.

## 3. Push to GitHub

```bash
git init
git add .
git commit -m "Static rebuild of benlandes.net"
git branch -M main
git remote add origin https://github.com/<your-username>/benlandes-site.git
git push -u origin main
```

## 4. Turn on GitHub Pages

Repo → **Settings → Pages** → Source: **Deploy from a branch** → Branch: **main**, folder **/(root)** → Save. First build takes a minute.

## 5. Point the domain at GitHub Pages

`CNAME` in this repo already claims `benlandes.net`. At your **DNS host** (wherever the domain's nameservers live — check if that's HostGator or a separate registrar), set:

- Four **A** records for the apex `benlandes.net` →
  `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
- One **CNAME** for `www` → `<your-username>.github.io`

Then in **Settings → Pages**, confirm the custom domain reads `benlandes.net` and enable **Enforce HTTPS** once the cert issues (can take up to ~24h). Only cut HostGator once Pages is serving the domain, to avoid downtime.

> These are GitHub's published Pages IPs as of this writing — confirm against GitHub's current docs before changing DNS.

## Notes

- `/ai-projects/` changed to `/projects/`. If you want inbound links to the old URL to keep working, add an `ai-projects/index.html` that redirects, or keep the folder named `ai-projects`.
- Fonts load from Google Fonts. To go fully self-hosted, download the woff2 files into `assets/fonts/` and swap the `<link>` for `@font-face`.

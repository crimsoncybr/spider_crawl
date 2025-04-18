# 🕷️ spider_crawl Web Crawler

> A real-time, keyword-aware Bash crawler with optional Dark Web support 🌐🧠

---

### 🚀 Features

- 📥 Downloads and parses HTML from any public website
- 🔎 Searches for keyword matches in page content and links
- 🌐 Supports both surface web and `.onion` (Tor) sites
- 🕵️ Rotates User-Agents to mimic human browsing
- 📊 Live terminal dashboard with:
  - Total URLs crawled
  - Keywords matched
  - Current target
  - Recent match results
- 🗂 Organizes downloads by domain name
- 🧠 Intelligent delay between requests (1–15 sec, randomized)

---
![Screenshot 2025-04-18 135258](https://github.com/user-attachments/assets/1453787b-bb0d-4fa0-844e-35d5eb483327)

---

### 🌌 Dark Web Support

To switch between Surface Web and Dark Web crawling:

Edit this section in the script (`SETUP_CONFIG()`):

```bash
# WGT="torrify wget"  # darkweb mode (requires Tor)
WGT="wget"            # normal mode
```

> 💡 **Make sure Tor is running** (e.g., via `tor` or Tor Browser) when using darkweb mode.

To install Tor + Torrify:
```bash
sudo apt install tor torsocks
```

---

### 🧱 Directory Structure

```
.
├── spider_crawl.sh           # The main crawler script
├── urls/
│   └── urls                  # Seed list of URLs to crawl
├── search/
│   └── keywords.txt          # List of keywords to detect
├── info/
│   ├── visited_urls.txt
│   ├── match_counter.txt
│   ├── keywords_found_counter.txt
│   ├── matches.txt
│   ├── match_output.tmp
│   └── temp_links
├── downloaded_pages/         # HTML files saved by domain
└── README.md
```

---

### ⚙️ Usage

1. **Clone the repo**
   ```bash
   git clone https://github.com/crimsoncybr/spider_crawl.git
   cd spider_crawl
   ```

2. **Add initial URL(s)**
   ```bash
   echo "https://example.com" >> urls/urls
   ```

3. **Add keyword(s)**
   ```bash
   echo "cyber" >> search/keywords.txt
   ```

4. **Run the crawler**
   ```bash
   chmod +x spider_crawl.sh
   ./spider_crawl.sh
   ```

---

### 📋 Requirements

- Bash 4+
- Tools: `wget`, `awk`, `grep`, `md5sum`, `sort`, `torsocks` (optional)
- OS: Linux or macOS (recommended)

---

### ⚠️ Disclaimer

This script is for educational and ethical use only.  
✅ Always ensure you have permission before crawling or indexing any domain.

---

**Author:** Dean  
**License:** MIT  
**Stars Welcome!** ⭐

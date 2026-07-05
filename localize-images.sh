#!/usr/bin/env bash
# Downloads every image the site currently pulls from WordPress (i0.wp.com)
# into assets/images/, then rewrites the HTML to point at those local copies.
# Run this ONCE, from the site root, in an environment with internet access
# (your terminal or Claude Code). After it succeeds, the site no longer
# depends on WordPress / HostGator for anything.
#
#   chmod +x localize-images.sh && ./localize-images.sh
#
set -euo pipefail
mkdir -p assets/images
cd "$(dirname "$0")"

# origin_url | local_filename | in-html-url-to-replace
map=(
"https://benlandes.net/wp-content/uploads/2025/08/Screenshot-2025-08-31-184557.png|suitestack.png|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/08/Screenshot-2025-08-31-184557.png?fit=710%2C712&ssl=1"
"https://benlandes.net/wp-content/uploads/2025/09/ChatGPT-Image-Sep-1-2025-07_28_43-PM.png|rapid-redline.png|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/09/ChatGPT-Image-Sep-1-2025-07_28_43-PM.png?resize=1024%2C1536&ssl=1"
"https://benlandes.net/wp-content/uploads/2025/08/LeadPro-logo-1.png|leadpro.png|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/08/LeadPro-logo-1.png?fit=788%2C932&ssl=1"
"https://benlandes.net/wp-content/uploads/2025/11/pipeline.png|deal-progression.png|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/11/pipeline.png?fit=896%2C1280&ssl=1"
"https://benlandes.net/wp-content/uploads/2025/09/BuildingScorecard.png|building-scorecard.png|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/09/BuildingScorecard.png?fit=706%2C1024&ssl=1"
"https://benlandes.net/wp-content/uploads/2025/11/ChatGPT-Image-Nov-9-2025-12_22_28-PM.png|dealstack.png|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/11/ChatGPT-Image-Nov-9-2025-12_22_28-PM.png?fit=1024%2C1536&ssl=1"
"https://benlandes.net/wp-content/uploads/2025/05/Headshot-1-683x1024.jpg|headshot.jpg|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/05/Headshot-1-683x1024.jpg?ssl=1"
"https://benlandes.net/wp-content/uploads/2025/05/323A0353-1.jpg|about-1.jpg|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/05/323A0353-1.jpg?resize=1024%2C683&ssl=1"
"https://benlandes.net/wp-content/uploads/2024/10/CA3A36AC-2700-4FD1-A806-761BE2832FF1.jpeg|about-2.jpeg|https://i0.wp.com/benlandes.net/wp-content/uploads/2024/10/CA3A36AC-2700-4FD1-A806-761BE2832FF1.jpeg?resize=1024%2C734&ssl=1"
"https://benlandes.net/wp-content/uploads/2025/05/3A74D26D-9CDF-460C-8118-48009445B421.jpeg|about-3.jpeg|https://i0.wp.com/benlandes.net/wp-content/uploads/2025/05/3A74D26D-9CDF-460C-8118-48009445B421.jpeg?resize=1024%2C734&ssl=1"
)

for row in "${map[@]}"; do
  IFS='|' read -r origin local search <<< "$row"
  echo "→ $local"
  curl -fsSL "$origin" -o "assets/images/$local"
  # rewrite every html file to use the local, root-absolute path
  find . -name '*.html' -print0 | xargs -0 sed -i.bak "s|$search|/assets/images/$local|g"
done

find . -name '*.html.bak' -delete
echo "Done. Images are in assets/images/ and the HTML now points to them."
echo "Preview locally with:  python3 -m http.server 8000   then open http://localhost:8000"

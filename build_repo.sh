#!/usr/bin/env bash
# Builds the consolidated repository from the four public repos, keeping their history.
# Run from github-consolidated/: bash build_repo.sh
set -euo pipefail
HERE="$(pwd)"
REPO="$HERE/LILYGO-T-Display-ESP32-S3"
PAGE5="$HERE/../crawl/pages/005.txt"
TRAILER=$'\n\nCo-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>'
NEW_PAGE="https://jashuang1983.wordpress.com/lilygo-t-display-esp32-s3-custom-images-and-live-imu-data-bno055/"

mkdir -p "$REPO"; find "$REPO" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
git init -q -b main "$REPO"
cd "$REPO"
git commit -q --allow-empty -m "Start consolidated LILYGO T-Display ESP32-S3 repository$TRAILER"

for pair in \
  "LILYGO-T-Display-ESP32-S3-display-custom-image:custom-image/Custom_Image_V3" \
  "LILYGO-T-Display-ESP32-S3-display-imu-sensor-data:imu-display" \
  "Image-Clipper:tools/image-clipper" \
  "convert-image-to-rgb565-header-file:tools/rgb565-converter"; do
  r=${pair%%:*}; p=${pair#*:}
  git subtree add -q --prefix="$p" "https://github.com/JasonHEngineering/$r.git" main -m "Merge $r into $p, keeping its history$TRAILER"
done

# Basic image processing scripts, previously only on the WordPress page. Private paths replaced.
mkdir -p tools/basic-image-processing
lines() { sed -n "$1,$2p" "$PAGE5" | sed 's/\xc2\xa0/ /g; s/[[:space:]]*$//'; }
lines 44 80 | sed "s#r'D:.*original'#r'path\\\\to\\\\original'#; s#r'D:.*compressed'#r'path\\\\to\\\\compressed'#" > tools/basic-image-processing/compress_images.py
lines 126 165 | sed "s#r'D:.*all_original_images'#r'path\\\\to\\\\original'#; s#r'D:.*cropped_images'#r'path\\\\to\\\\cropped'#" > tools/basic-image-processing/center_crop_images.py
lines 209 246 > tools/basic-image-processing/stitch_images.py
cat > tools/basic-image-processing/README.md <<'EOF'
# Basic image processing

Batch scripts for preparing images, for displays or for machine learning training and test sets. Set the folder paths at the top of each script before running.

| Script | What it does |
|---|---|
| `compress_images.py` | Scales every .jpg in a folder down to 1/k of its width and height. Change `k` for the scale. |
| `center_crop_images.py` | Crops every .jpg from its center to the smallest width and height found in the folder. Take care if the folder mixes portrait and landscape images. |
| `stitch_images.py` | Joins images in each folder side by side, one row per folder. Use `space_between_row` to set the gap. Adapted from https://stackoverflow.com/questions/42851896/stitch-images-together-in-python |

Requires `opencv-python` for the first two and `Pillow` for stitching.
EOF
git add tools/basic-image-processing
git commit -q -m "Add basic image processing scripts from the WordPress page$TRAILER"

# Point the old READMEs at the consolidated write-up, and add the top-level README.
sed -i "s#https://jashuang1983.wordpress.com/lilygo-t-display-esp32-s3-display-own-custom-image/#$NEW_PAGE#" custom-image/Custom_Image_V3/README.md
sed -i "s#https://jashuang1983.wordpress.com/lilygo-t-display-esp32-s3-display-imu-sensor-data-bno055/#$NEW_PAGE#" imu-display/README.md
cp "$HERE/README.md" README.md
git add README.md custom-image imu-display
git commit -q -m "Add combined README and point write-up links to the new page$TRAILER"
git log --oneline | head -8

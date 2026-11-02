# Basic image processing

Batch scripts for preparing images, for displays or for machine learning training and test sets. Set the folder paths at the top of each script before running.

| Script | What it does |
|---|---|
| `compress_images.py` | Scales every .jpg in a folder down to 1/k of its width and height. Change `k` for the scale. |
| `center_crop_images.py` | Crops every .jpg from its center to the smallest width and height found in the folder. Take care if the folder mixes portrait and landscape images. |
| `stitch_images.py` | Joins images in each folder side by side, one row per folder. Use `space_between_row` to set the gap. Adapted from https://stackoverflow.com/questions/42851896/stitch-images-together-in-python |

Requires `opencv-python` for the first two and `Pillow` for stitching.

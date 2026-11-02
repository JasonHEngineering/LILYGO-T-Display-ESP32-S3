# with reference from https://stackoverflow.com/questions/42851896/stitch-images-together-in-python

from PIL import Image
from os import listdir, path

space_between_row = 0
new_image_path = 'result.jpg'
im_dirs = ['stitching_images/1', 'stitching_images/2', 'stitching_images/3', 'stitching_images/4']

# get sorted list of images
im_path_list = [[path.join(p, f) for f in sorted(listdir(p))] for p in im_dirs]

# open images and calculate total widths and heights
im_list = []
total_width = 0
total_height = 0
for path_list in im_path_list:
    images = list(map(Image.open, path_list))
    widths, heights = zip(*(i.size for i in images))
    total_width = max(total_width, sum(widths))
    total_height += max(heights)
    im_list.append(images)

# concat images
new_im = Image.new('RGB', (total_width, total_height))
y_offset = 0
for images in im_list:
    x_offset = 0
    max_height = 0
    for im in images:
        new_im.paste(im, (x_offset, y_offset))
        x_offset += im.size[0]
        max_height = max(im.size[1], max_height)
    y_offset = y_offset + max_height + space_between_row

# show and save
new_im.show()
new_im.save(new_image_path)

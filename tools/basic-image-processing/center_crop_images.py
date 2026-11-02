import cv2
import os

rawdata_path = r'path\to\original'
output_path = r'path\to\cropped'

width = []
height = []

for root, dirs, files in os.walk(rawdata_path):
    for file in files:
        filename = os.path.join(root, file)

        if filename.endswith((".jpg")):
            print(filename)
            img = cv2.imread(filename)

            width.append(int(img.shape[1]))
            height.append(int(img.shape[0]))

# crop the middle of the smallest dimensions

for root, dirs, files in os.walk(rawdata_path):
    for file in files:
        filename = os.path.join(root, file)

        if filename.endswith((".jpg")):

            img = cv2.imread(filename)

            #if int(img.shape[1]) > min(width):
            cropped = img[
                         int((img.shape[0]-min(height))/2):int((img.shape[0]-min(height))/2+min(height)),
                         int((img.shape[1]-min(width))/2):int((img.shape[1]-min(width))/2+min(width))
                         ]

            # remove .jpg
            file = file[:-4]

            cv2.imwrite(output_path + '/cropped_' + file + '.jpg', cropped)

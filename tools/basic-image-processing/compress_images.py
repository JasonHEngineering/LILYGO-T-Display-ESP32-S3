import cv2
import os

rawdata_path = r'path\to\original'
bmp_output_path = r'path\to\compressed'

# set the ratio of resized image
k = 6

count = 0

for root, dirs, files in os.walk(rawdata_path):
    for file in files:

        filename = os.path.join(root, file)

        if filename.endswith((".jpg")):
            print(filename)
            img = cv2.imread(filename)

            width = int((img.shape[1])/k)
            height = int((img.shape[0])/k)

            # resize the image by resize() function of openCV library
            scaled = cv2.resize(img, (width, height), interpolation=cv2.INTER_AREA)

            # show the resized image using imshow() function of openCV library
            cv2.imshow("Output", scaled)
            cv2.waitKey(500)
            cv2.destroyAllWindows()

            # remove .jpg
            file = file[:-4]

            # get the resized image output by imwrite() function of openCV library
            #cv2.imwrite(bmp_output_path + '/compressed_' + file + '.bmp', scaled)
            cv2.imwrite(bmp_output_path + '/compressed_' + file + '.jpg', scaled)

# LILYGO T-Display ESP32-S3 (AMOLED)

Arduino sketches and Python tools for the LILYGO T-Display-S3 AMOLED, an ESP32-S3 with a 536 x 240 AMOLED screen on one board.

- **Custom images:** show your own photos on the AMOLED.
- **Live IMU display:** read a BNO055 9-DOF IMU over I2C and show Euler angles, quaternions, calibration status, battery voltage and 3D axes.

Full write-up: https://jashuang1983.wordpress.com/lilygo-t-display-esp32-s3-custom-images-and-live-imu-data-bno055/

## What's in this repository

| Folder | What it is | Language |
|---|---|---|
| [`custom-image/Custom_Image_V3`](custom-image/Custom_Image_V3) | Shows 536 x 240 images from header files, switching every 2 seconds | Arduino |
| [`imu-display/Gyro_Data_Display_Euler_Quaternions`](imu-display/Gyro_Data_Display_Euler_Quaternions) | Live BNO055 orientation dashboard | Arduino |
| [`tools/image-clipper`](tools/image-clipper) | Clips images to a fixed pixel size, such as 536 x 240 | Python |
| [`tools/rgb565-converter`](tools/rgb565-converter) | Converts an image to a 16-bit RGB565 array in a header (.h) file | Python |
| [`tools/basic-image-processing`](tools/basic-image-processing) | Batch compress, center-crop and stitch images | Python |

## Hardware

- LILYGO T-Display-S3 **AMOLED** (240 x 536, QSPI). The LCD variants differ in resolution and interface.
- For the IMU display: a BNO055 breakout (GY-BNO055) and a 4-pin JST SH 1.0 mm cable.

**Caution:** the old T-Display model is slightly longer and can be damaged if forced into the case. Check the model before you buy.

## Arduino IDE setup

1. Add this URL under **File > Preferences > Additional boards manager URLs**:
   `https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json`
2. Install **esp32 by Espressif Systems** from the Boards Manager and select **ESP32S3 Dev Module**.
3. In the **Tools** menu, set **PSRAM** to **OPI PSRAM** (required) and **USB CDC On Boot** to **Enabled** (for the Serial Monitor).
4. Install the libraries: **TFT_eSPI**, plus **Adafruit BNO055** and **Adafruit Unified Sensor** for the IMU display. The `rm67162` AMOLED driver is included in each sketch folder.

If an upload fails, hold **BOOT**, press and release **RST**, release **BOOT**, then upload again.

## Custom images

1. Clip each photo to 536 x 240 with [`tools/image-clipper`](tools/image-clipper).
2. Convert it with [`tools/rgb565-converter`](tools/rgb565-converter). Give each image its own `array_name`, such as `gImage_true_color_1`, to match the sketch.
3. Copy the header files into [`custom-image/Custom_Image_V3`](custom-image/Custom_Image_V3) and upload.

One full-screen image is 536 x 240 x 2 = 257,280 bytes, so only a few fit alongside the code.

## IMU display wiring

| BNO055 | T-Display AMOLED |
|---|---|
| VIN | 3V |
| GND | G |
| SDA | GPIO 43 |
| SCL | GPIO 44 |

The sketch uses I2C address `0x29`. Change `Adafruit_BNO055(55, 0x29)` if your board differs.

The top button steps through seven brightness levels. Ignore the orientation data until the SYS calibration value is above 0.

## Parts (affiliate links)

- T-Display-S3-AMOLED Development Board: https://s.click.aliexpress.com/e/_c3A8s3yx
- BNO055 9DOF 9 Axis Absolute Orientation IMU: https://s.click.aliexpress.com/e/_c3ycMcOx
- 10Pcs 4P SH1.0 to Dupont line: https://s.click.aliexpress.com/e/_c3wiXkyf

These are affiliate links. I may earn a small commission if you buy through them, at no extra cost to you.

## History

This repository combines four earlier repositories, with their commit history kept:
`LILYGO-T-Display-ESP32-S3-display-custom-image`, `LILYGO-T-Display-ESP32-S3-display-imu-sensor-data`, `Image-Clipper` and `convert-image-to-rgb565-header-file`.

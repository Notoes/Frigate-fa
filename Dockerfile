# Use the standard Frigate container as a base, matching your installed version
FROM ghcr.io/blakeblackshear/frigate:0.16.1

# Add YOLOv9-for-Coral plugin + model (512) + labels
ADD https://raw.githubusercontent.com/dbro/frigate-detector-edgetpu-yolo9/main/edgetpu_tfl.py /opt/frigate/frigate/detectors/plugins/edgetpu_tfl.py
ADD https://raw.githubusercontent.com/dbro/frigate-detector-edgetpu-yolo9/main/labels-coco17.txt /opt/frigate/models/labels-coco17.txt
ADD https://github.com/dbro/frigate-detector-edgetpu-yolo9/releases/download/v1.5/yolov9-s-relu6-tpumax_512_int8_edgetpu.tflite /opt/frigate/models/yolov9-s-relu6-tpumax_512_int8_edgetpu.tflite

# Make them read-only so updates can’t clobber
RUN chmod 444 /opt/frigate/frigate/detectors/plugins/edgetpu_tfl.py \
    && chmod 444 /opt/frigate/models/*.tflite /opt/frigate/models/*.txt

# Add our tiny launch script
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]

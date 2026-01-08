FROM public.ecr.aws/lambda/python:3.11

# ------------------------------------------------------------
# Create Lambda layer structure
# ------------------------------------------------------------
RUN mkdir -p /opt/python

# ------------------------------------------------------------
# Install Python dependencies into the layer
# ------------------------------------------------------------
RUN pip install --no-cache-dir \
      python-docx==1.1.2 \
      mammoth==1.6.0 \
      -t /opt/python

# ------------------------------------------------------------
# 🔍 CI VALIDATION (simulate Lambda environment)
# ------------------------------------------------------------
ENV PYTHONPATH=/opt/python

RUN python - <<EOF
import docx
import mammoth
import lxml
print("DOCX layer validation OK")
EOF

# ------------------------------------------------------------
# Strip unnecessary files
# ------------------------------------------------------------
# Final cleanup
RUN find /opt/python -type d -name "__pycache__" -exec rm -rf {} + && \
    find /opt/python -type d -name "tests" -exec rm -rf {} + && \
    #find /opt/python -type d -name "*.dist-info" -exec rm -rf {} + && \
    rm -rf /opt/python/bin
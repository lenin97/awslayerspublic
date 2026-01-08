FROM public.ecr.aws/lambda/python:3.11

# ------------------------------------------------------------
# Install poppler (binaries + native deps)
# ------------------------------------------------------------
RUN yum install -y \
    poppler \
    poppler-utils \
    && yum clean all

# ------------------------------------------------------------
# Create Lambda layer structure
# ------------------------------------------------------------
RUN mkdir -p /opt/bin /opt/lib /opt/python

# ------------------------------------------------------------
# Copy Poppler binaries used by pdf2image
# ------------------------------------------------------------
RUN cp /usr/bin/pdftoppm /opt/bin/ && \
    cp /usr/bin/pdfinfo /opt/bin/

# ------------------------------------------------------------
# 🔑 Automatically copy ONLY required shared libraries
# (no guessing, no missing deps, no glibc)
# ------------------------------------------------------------
RUN for bin in /usr/bin/pdfinfo /usr/bin/pdftoppm; do \
      ldd $bin | awk '{print $3}' | grep '^/' ; \
    done | sort -u | \
    grep -Ev 'libc\.so|libm\.so|libpthread\.so|libdl\.so|ld-linux|libstdc\+\+\.so|libgcc_s\.so' | \
    xargs -I '{}' cp -v '{}' /opt/lib/

# ------------------------------------------------------------
# Install Python dependencies into the layer
# ------------------------------------------------------------
RUN pip install --no-cache-dir pdf2image -t /opt/python

# ------------------------------------------------------------
# Ensure binaries are executable
# ------------------------------------------------------------
RUN chmod +x /opt/bin/*

# ------------------------------------------------------------
# 🔍 CI VALIDATION: fail build if ANY .so is missing
# ------------------------------------------------------------
RUN echo "Validating Poppler shared libraries..." && \
    LD_LIBRARY_PATH=/opt/lib \
    ldd /opt/bin/pdfinfo | grep "not found" && exit 1 || true && \
    LD_LIBRARY_PATH=/opt/lib \
    ldd /opt/bin/pdftoppm | grep "not found" && exit 1 || true
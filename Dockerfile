# Use an official PyTorch image with CUDA support (Python 3.10, CUDA 12, cuDNN 8)
FROM nvcr.io/nvidia/pytorch:25.04-py3

# install git so we can clone flash-attention
RUN apt-get update
RUN apt-get install -y --no-install-recommends git libgl1 libglx-mesa0 libglib2.0-0 libsm6 libxext6 libxrender1 
RUN rm -rf /var/lib/apt/lists/*

# Set working directory inside container
WORKDIR /workspace/Bagel

# Copy requirement file and install Python dependencies
COPY requirements_nvidia.txt .
RUN python -m pip install --upgrade pip && pip install -r requirements_nvidia.txt

# Install FlashAttention from source (since we removed it from requirements)
RUN python -m pip install git+https://github.com/Dao-AILab/flash-attention.git@v2.7.3

# Install Jupyter and other tools for development
RUN python -m pip install jupyter gradio huggingface_hub

# Copy the rest of the BAGEL code into the container
COPY . .

# By default, launch Jupyter Lab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

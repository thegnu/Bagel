## Instructions for NVIDIA GPU Windows Users (using Docker on WSL)
If you are using an NVIDIA GPU, please follow these steps to ensure that your environment is set up correctly:

In WSL, run the following command to install the NVIDIA driver and CUDA toolkit:
```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

To speed up  builds, pull the NVIDIA CUDA base image by running:
```bash
docker pull nvcr.io/nvidia/pytorch:25.04-py3
```

Build the Docker image using the NVIDIA base image by running:
```bash
docker build --progress=plain -t bagel:latest .
```

This will take some minutes, depending on your internet connection and system performance.

After the build is complete, you can run the Docker container with GPU support using:
```bash
docker run -d --name bagel_gpu --gpus all -p 8888:8888 -p 7860:7860 -v D:\_GIT\Bagel\models:/models -v D:\_GIT\Bagel\Bagel:/workspace/Bagel bagel:latest
```

Make sure the models weights from https://huggingface.co/ByteDance-Seed/BAGEL-7B-MoT are available locally.

Replace the volume paths with your actual paths as needed.

The Jupyter server URL including the token will be displayed in the Docker output.

Open inference.ipynb in the Jupyter server to start using the Bagel model.

The "Model Loading" step will take some time (10 minutes on my quite fast dev machine). The progress bar widget in the notebook seems to die after some minutes, but by clicking on the dot in the upper right corner you can still see if it is still working.

The first line in the "Model Loading" cell configures the max memory, if you have less than 32GB VRAM please configure accordingly.
# Triton Inference Server
A customized Triton Inference Server image for fast and flexible deployment. The image is publicly available as `hieupth/tritonserver:[version]-[tag]`.
Version|Image Tag|Device|Backend|
|-|-|-|-|
|24.12|no tag|GPU|OnnxRuntime, TensorRT|
|24.12|cpuonly|CPU|OnnxRuntime, OpenVINO|
|24.12, 25.02|trtllm|GPU|TensorRT-LLM|
|24.12, 25.02|vllm|GPU|vLLM|  
## Entrypoint
This image enters the Tini environment (equivalent to `docker run --init`) and then uses `CMD` to execute the `/entry.d/entrypoint.sh` script. The script installs Python packages from `requirements.txt` if the file exists, and then runs all Python scripts located at the same level. Users can override this process by mapping a volume or modifying the `CMD` when starting the container.
## Download model from Huggingface Hub
The `/entry.d/huggingface.py` script downloads models from the Hugging Face Hub. It reads the configuration JSON file from `/conf.d/huggingface.json` if it exists. For example:
```json
{
  "token": "{{HF_TOKEN}}",                // Primary authentication token
  "models": [                             // List of models to download
    {
      "name": "hieupth/triton.viencoder", // Model repository on Hugging Face Hub
      "ref": "main",                      // Branch or version to download
      "token": "{{HF_TOKEN_1}}"           // Repository-specific token (falls back to the primary token if not provided)
    }
  ]
}
```
The configuration file is rendered by Jinja2 before being applied, allowing you to use template syntax like `{{HF_TOKEN}}` to inject environment variables at runtime.
## Deployment
```yml
services:
  tritonserver:
    image: hieupth/tritonserver:24.12
    container_name: tritonserver
    restart: unless-stopped
    volumes:
      - ./conf.d:/conf.d
      - ./entry.d:/entry.d  # Override default entry process if needed.
    tty: true
    ports:
      - "8000:8000"
      - "8001:8001"
      - "8002:8002"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/v2/health/ready"]
      interval: 30s
      timeout: 5s
      retries: 2
```
## License
[GNU AGPL v3.0](LICENSE).<br>
Copyright &copy; 2024 [Hieu Pham](https://github.com/hieupth). All rights reserved.
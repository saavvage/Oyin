import requests
import logging
from typing import Optional
from app.config import get_settings

logger = logging.getLogger(__name__)


class VastAIService:
    """
    Calls a GGUF model hosted on a Vast.ai GPU instance.

    Expects an OpenAI-compatible server (llama.cpp server, vLLM, etc.).

    Setup on Vast.ai:
      1. Rent a GPU instance
      2. Upload your .gguf model
      3. Run: ./llama-server -m sports-health-gemma2.gguf --host 0.0.0.0 --port 8080
      4. Set VASTAI_API_URL=http://<vast-ip>:<port> in .env
    """

    def __init__(self):
        self.settings = get_settings()
        self.base_url = self.settings.vastai_api_url
        self.api_key = self.settings.vastai_api_key
        self.model_name = self.settings.vastai_model_name
        self.timeout = self.settings.vastai_timeout
        self._available: Optional[bool] = None

    @property
    def is_available(self) -> bool:
        if not self.base_url:
            return False
        if self._available is not None:
            return self._available
        self._available = self._check_health()
        return self._available

    def _check_health(self) -> bool:
        headers = {}
        if self.api_key:
            headers["Authorization"] = f"Bearer {self.api_key}"

        # Try /health (llama.cpp)
        for endpoint in ["/health", "/v1/models"]:
            try:
                resp = requests.get(
                    f"{self.base_url}{endpoint}",
                    headers=headers,
                    timeout=5,
                )
                if resp.status_code == 200:
                    logger.info(f"Vast.ai server reachable at {self.base_url}")
                    return True
            except Exception:
                continue

        logger.warning(f"Vast.ai server not reachable at {self.base_url}")
        return False

    def invalidate_cache(self):
        self._available = None

    def generate_response(self, prompt: str, max_tokens: int = 512) -> Optional[str]:
        if not self.base_url:
            return None

        # Try OpenAI-compatible chat/completions first, then llama.cpp native
        result = self._try_chat_completions(prompt, max_tokens)
        if result:
            return result

        return self._try_llama_completion(prompt, max_tokens)

    def _try_chat_completions(self, prompt: str, max_tokens: int) -> Optional[str]:
        headers = {"Content-Type": "application/json"}
        if self.api_key:
            headers["Authorization"] = f"Bearer {self.api_key}"

        payload = {
            "model": self.model_name,
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": max_tokens,
            "temperature": 0.7,
            "top_p": 0.9,
        }

        try:
            resp = requests.post(
                f"{self.base_url}/v1/chat/completions",
                json=payload,
                headers=headers,
                timeout=self.timeout,
            )
            resp.raise_for_status()
            text = resp.json()["choices"][0]["message"]["content"].strip()
            if text and len(text) >= 10:
                logger.info("Got response from Vast.ai (chat/completions)")
                return text
        except requests.exceptions.ConnectionError:
            logger.warning("Vast.ai connection refused")
            self._available = False
        except requests.exceptions.Timeout:
            logger.warning(f"Vast.ai timed out ({self.timeout}s)")
            self._available = False
        except Exception as e:
            logger.debug(f"Vast.ai chat/completions failed: {e}")

        return None

    def _try_llama_completion(self, prompt: str, max_tokens: int) -> Optional[str]:
        """Fallback: llama.cpp native /completion endpoint."""
        headers = {"Content-Type": "application/json"}
        if self.api_key:
            headers["Authorization"] = f"Bearer {self.api_key}"

        formatted_prompt = (
            f"<start_of_turn>user\n{prompt}<end_of_turn>\n"
            f"<start_of_turn>model\n"
        )

        payload = {
            "prompt": formatted_prompt,
            "n_predict": max_tokens,
            "temperature": 0.7,
            "top_p": 0.9,
            "top_k": 40,
            "repeat_penalty": 1.1,
            "stop": ["<end_of_turn>", "<start_of_turn>"],
        }

        try:
            resp = requests.post(
                f"{self.base_url}/completion",
                json=payload,
                headers=headers,
                timeout=self.timeout,
            )
            resp.raise_for_status()
            text = resp.json().get("content", "").strip()
            if text and len(text) >= 10:
                logger.info("Got response from Vast.ai (completion)")
                return text
        except requests.exceptions.ConnectionError:
            self._available = False
        except requests.exceptions.Timeout:
            self._available = False
        except Exception as e:
            logger.debug(f"Vast.ai completion failed: {e}")

        return None


_vastai_service: Optional[VastAIService] = None


def get_vastai_service() -> VastAIService:
    global _vastai_service
    if _vastai_service is None:
        _vastai_service = VastAIService()
    return _vastai_service

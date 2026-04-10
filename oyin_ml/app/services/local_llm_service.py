import os
from pathlib import Path
import logging
from typing import Optional

logger = logging.getLogger(__name__)


class LocalLLMService:
    """
    Service for running local Gemma model as fallback when Gemini API is unavailable.
    
    Supports both GGUF and Hugging Face formats:
    - GGUF files (*.gguf) - Use llama-cpp-python (fast, quantized)
    - Hugging Face format - Use transformers (original weights)
    
    To use this service:
    1. Place your model file in the project directory or models/gemma/
    2. Install dependencies: pip install llama-cpp-python (for GGUF)
    3. Set USE_LOCAL_MODEL=true in .env or let automatic fallback handle it
    
    Supported models:
    - Gemma 2 (GGUF format) - Recommended
    - google/gemma-2b-it (Hugging Face)
    - google/gemma-7b-it (Hugging Face)
    """
    
    def __init__(self, model_path: str):
        self.model_path = Path(model_path) if not model_path.endswith('.gguf') else Path(model_path)
        self.model = None
        self.tokenizer = None
        self.is_available = False
        self.model_type = None
        
        self._check_availability()
    
    def _check_availability(self):
        """Check if local model and dependencies are available"""
        # Search for GGUF files in multiple locations
        gguf_files = []
        
        # Check if model_path is a specific GGUF file
        if self.model_path.is_file() and str(self.model_path).endswith('.gguf'):
            gguf_files = [self.model_path]
        # Search in models/ directory
        elif not gguf_files:
            gguf_files = list(Path('models').glob("*.gguf"))
        # Fallback to project root
        if not gguf_files:
            gguf_files = list(Path('.').glob("*.gguf"))
        
        if gguf_files:
            try:
                from llama_cpp import Llama
                self.is_available = True
                self.model_type = 'gguf'
                self.gguf_path = gguf_files[0]
                logger.info(f"GGUF model found: {self.gguf_path} ({self.gguf_path.stat().st_size / (1024**3):.2f} GB)")
                return
            except ImportError:
                logger.info("llama-cpp-python not installed. Run: pip install llama-cpp-python")
                self.is_available = False
                return
        
        if self.model_path.is_dir():
            try:
                import torch
                import transformers
                
                model_files = list(self.model_path.glob("*"))
                if model_files:
                    self.is_available = True
                    self.model_type = 'huggingface'
                    logger.info(f"Hugging Face model files found in {self.model_path}")
                else:
                    logger.info(f"No model files in {self.model_path}")
                    self.is_available = False
            except ImportError:
                logger.info("transformers or torch not installed")
                self.is_available = False
        else:
            logger.info(f"No GGUF or model directory found. Place .gguf file in project root or model files in {self.model_path}")
            self.is_available = False
    
    def load_model(self):
        """Load the local Gemma model"""
        if not self.is_available:
            logger.warning("Cannot load model - dependencies or model files missing")
            return False
        
        if self.model is not None:
            return True
        
        try:
            if self.model_type == 'gguf':
                from llama_cpp import Llama
                
                logger.info(f"Loading GGUF model from {self.gguf_path}...")
                logger.info("This may take a minute on first load...")
                
                self.model = Llama(
                    model_path=str(self.gguf_path),
                    n_ctx=2048,
                    n_threads=4,
                    n_gpu_layers=0,
                    verbose=False
                )
                
                logger.info("GGUF model loaded successfully")
                return True
                
            elif self.model_type == 'huggingface':
                from transformers import AutoTokenizer, AutoModelForCausalLM
                import torch
                
                logger.info("Loading Hugging Face model...")
                
                self.tokenizer = AutoTokenizer.from_pretrained(
                    str(self.model_path),
                    local_files_only=True
                )
                
                self.model = AutoModelForCausalLM.from_pretrained(
                    str(self.model_path),
                    local_files_only=True,
                    torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32,
                    device_map="auto" if torch.cuda.is_available() else None
                )
                
                logger.info("Hugging Face model loaded successfully")
                return True
            
        except Exception as e:
            logger.error(f"Error loading local model: {e}")
            self.is_available = False
            return False
    
    def generate_response(self, prompt: str, max_tokens: int = 512) -> Optional[str]:
        """Generate response using local model"""
        if not self.is_available:
            return None
        
        if self.model is None:
            if not self.load_model():
                return None
        
        try:
            if self.model_type == 'gguf':
                # Check if prompt contains Cyrillic (Russian/Kazakh)
                has_cyrillic = any('\u0400' <= char <= '\u04FF' for char in prompt)
                
                # Format prompt for Gemma 2 instruction model
                if has_cyrillic:
                    # For multilingual, keep it simple
                    formatted_prompt = f"<start_of_turn>user\n{prompt}<end_of_turn>\n<start_of_turn>model\n"
                else:
                    # For English, use standard format
                    formatted_prompt = f"<start_of_turn>user\n{prompt}<end_of_turn>\n<start_of_turn>model\n"
                
                output = self.model(
                    formatted_prompt,
                    max_tokens=max_tokens,
                    temperature=0.7,
                    top_p=0.9,
                    top_k=40,
                    repeat_penalty=1.1,
                    echo=False,
                    stop=["<end_of_turn>", "<start_of_turn>", "\n\nUser:", "\n\nQuestion:"]
                )
                
                response = output['choices'][0]['text'].strip()
                
                # If response is empty or too short, return None to trigger fallback
                if not response or len(response) < 10:
                    logger.warning("Model returned empty or very short response")
                    return None
                
                return response
                
            elif self.model_type == 'huggingface':
                inputs = self.tokenizer(prompt, return_tensors="pt")
                
                if self.model.device.type == "cuda":
                    inputs = {k: v.cuda() for k, v in inputs.items()}
                
                outputs = self.model.generate(
                    **inputs,
                    max_length=max_tokens,
                    temperature=0.7,
                    do_sample=True,
                    top_p=0.9,
                    pad_token_id=self.tokenizer.eos_token_id
                )
                
                response = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
                
                if prompt in response:
                    response = response[len(prompt):].strip()
                
                return response if response else None
            
        except Exception as e:
            logger.error(f"Error generating response with local model: {e}")
            return None
    
    def generate_embeddings(self, texts: list[str]) -> Optional[list[list[float]]]:
        """
        Local embedding generation - placeholder for sentence-transformers
        """
        try:
            from sentence_transformers import SentenceTransformer
            
            model = SentenceTransformer('all-MiniLM-L6-v2')
            embeddings = model.encode(texts)
            return embeddings.tolist()
            
        except ImportError:
            logger.warning("sentence-transformers not installed. Run: pip install sentence-transformers")
            return None
        except Exception as e:
            logger.error(f"Error generating embeddings: {e}")
            return None


local_llm_service = None

def get_local_llm_service(model_path: str) -> LocalLLMService:
    global local_llm_service
    if local_llm_service is None:
        local_llm_service = LocalLLMService(model_path)
    return local_llm_service







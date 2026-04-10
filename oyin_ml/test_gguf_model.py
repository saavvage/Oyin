#!/usr/bin/env python3
"""
Test script for your Gemma 2 GGUF model.
Run this after installing llama-cpp-python:
  pip install llama-cpp-python
"""

import sys
from pathlib import Path

print("=" * 70)
print(" GEMMA 2 GGUF MODEL TEST")
print("=" * 70)

# Check for model file
model_file = Path("sports-health-gemma2.gguf")
if not model_file.exists():
    print(f"\n✗ Model file not found: {model_file}")
    print("Make sure sports-health-gemma2.gguf is in the project root")
    sys.exit(1)

print(f"\n✓ Model file found: {model_file}")
print(f"  Size: {model_file.stat().st_size / (1024**3):.2f} GB")

# Check for llama-cpp-python
try:
    from llama_cpp import Llama
    print("\n✓ llama-cpp-python is installed")
except ImportError:
    print("\n✗ llama-cpp-python not installed")
    print("\nInstall it with:")
    print("  pip install llama-cpp-python")
    print("\nOr if you have network issues:")
    print("  pip install llama-cpp-python --no-cache-dir")
    sys.exit(1)

# Load the model
print("\n" + "-" * 70)
print("Loading model (this may take 30-60 seconds)...")
print("-" * 70)

try:
    llm = Llama(
        model_path=str(model_file),
        n_ctx=2048,
        n_threads=4,
        n_gpu_layers=0,
        verbose=False
    )
    print("✓ Model loaded successfully!")
except Exception as e:
    print(f"✗ Error loading model: {e}")
    sys.exit(1)

# Test generation
print("\n" + "=" * 70)
print(" TESTING TEXT GENERATION")
print("=" * 70)

test_prompts = [
    "What is tennis?",
    "How do I prevent injuries while playing sports?",
    "What are the basic rules of badminton?"
]

for i, prompt in enumerate(test_prompts, 1):
    print(f"\n[Test {i}/{len(test_prompts)}]")
    print(f"Prompt: {prompt}")
    print("-" * 70)
    
    try:
        output = llm(
            prompt,
            max_tokens=150,
            temperature=0.7,
            top_p=0.9,
            echo=False,
            stop=["\n\n", "User:", "Question:"]
        )
        
        response = output['choices'][0]['text'].strip()
        print(f"Response: {response}")
        print("-" * 70)
        print("✓ Generation successful")
        
    except Exception as e:
        print(f"✗ Error: {e}")

print("\n" + "=" * 70)
print(" TEST COMPLETE")
print("=" * 70)
print("\nYour Gemma 2 GGUF model is working!")
print("\nNext steps:")
print("1. Restart the FastAPI server")
print("2. The service will automatically detect and use your GGUF model")
print("3. Test with: curl -X POST http://localhost:8000/chat \\")
print('     -H "Content-Type: application/json" \\')
print('     -d \'{"user_id":"test","message":"What is tennis?"}\'')

#!/usr/bin/env python3
"""Test multilingual support"""
import requests
import json

BASE_URL = "http://localhost:8000"

tests = [
    {
        "name": "English",
        "message": "What is tennis?"
    },
    {
        "name": "Russian",
        "message": "Что такое теннис?"
    },
    {
        "name": "Kazakh",
        "message": "Теннис дегеніміз не?"
    },
    {
        "name": "Russian - Technique",
        "message": "Какой хват лучше для начинающих?"
    },
    {
        "name": "Kazakh - Technique",
        "message": "Жаңадан бастағандарға қандай ұстағыш жақсы?"
    }
]

print("=" * 70)
print(" MULTILINGUAL TESTING")
print("=" * 70)

for test in tests:
    print(f"\n[{test['name']}]")
    print(f"Query: {test['message']}")
    print("-" * 70)
    
    try:
        response = requests.post(
            f"{BASE_URL}/chat",
            json={"user_id": "test", "message": test['message']},
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            print(f"Response: {result['response']}")
            print(f"Used RAG: {result['used_rag']}")
        else:
            print(f"Error: {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")

print("\n" + "=" * 70)
print("All tests completed!")

import re


class QueryRouter:
    def __init__(self):
        self.rag_keywords = {
            'injury': ['injury', 'pain', 'hurt', 'strain', 'sprain', 'recovery', 'rehabilitation', 'heal', 'sore', 'ache'],
            'safety': ['safe', 'safety', 'dangerous', 'risk', 'precaution', 'warm-up', 'cool-down', 'hydration', 'dehydration', 'prevent'],
            'medical': ['doctor', 'medical', 'health', 'symptom', 'condition', 'treatment', 'therapy'],
            'first_aid': ['emergency', 'first aid', 'what to do if', 'immediate', 'urgent', 'bleed', 'concussion']
        }
        
        self.direct_llm_keywords = {
            'technique': ['grip', 'stance', 'swing', 'serve', 'footwork', 'technique', 'form', 'posture'],
            'rules': ['scoring', 'regulations', 'court dimensions', 'rules', 'point', 'game', 'set', 'match'],
            'equipment': ['racket', 'racquet', 'shoes', 'ball', 'gear', 'equipment', 'net'],
            'general': ['hello', 'hi', 'thanks', 'find', 'match', 'player', 'opponent']
        }
    
    def should_use_rag(self, query: str) -> bool:
        query_lower = query.lower()
        
        rag_score = 0
        direct_score = 0
        
        for category, keywords in self.rag_keywords.items():
            for keyword in keywords:
                if re.search(r'\b' + re.escape(keyword) + r'\b', query_lower):
                    rag_score += 1
        
        for category, keywords in self.direct_llm_keywords.items():
            for keyword in keywords:
                if re.search(r'\b' + re.escape(keyword) + r'\b', query_lower):
                    direct_score += 1
        
        return rag_score > direct_score


query_router = QueryRouter()







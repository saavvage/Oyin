from deep_translator import GoogleTranslator
from langdetect import detect, LangDetectException
import logging

logger = logging.getLogger(__name__)


class TranslationService:
    def __init__(self):
        self.supported_languages = {
            'en': 'English',
            'ru': 'Russian',
            'kk': 'Kazakh'
        }
    
    def detect_language(self, text: str) -> str:
        """Detect the language of the text"""
        try:
            lang = detect(text)
            return lang if lang in self.supported_languages else 'en'
        except LangDetectException:
            logger.warning("Could not detect language, defaulting to English")
            return 'en'
    
    def translate_to_english(self, text: str, source_lang: str = None) -> str:
        """Translate text to English"""
        if source_lang is None:
            source_lang = self.detect_language(text)
        
        if source_lang == 'en':
            return text
        
        try:
            translator = GoogleTranslator(source=source_lang, target='en')
            translated = translator.translate(text)
            logger.info(f"Translated from {source_lang} to English")
            return translated
        except Exception as e:
            logger.error(f"Translation to English failed: {e}")
            return text
    
    def translate_from_english(self, text: str, target_lang: str) -> str:
        """Translate text from English to target language"""
        if target_lang == 'en':
            return text
        
        try:
            translator = GoogleTranslator(source='en', target=target_lang)
            translated = translator.translate(text)
            logger.info(f"Translated from English to {target_lang}")
            return translated
        except Exception as e:
            logger.error(f"Translation from English failed: {e}")
            return text


translation_service = TranslationService()

"""Encryption utilities for secure credential storage.

This module provides symmetric encryption using Fernet for storing
sensitive credentials (S3 access keys, WebDAV passwords, etc.) in the database.
"""

import base64
import json
import os
from typing import Any, Dict, Optional

from cryptography.fernet import Fernet, InvalidToken

from app.core.config import settings
from app.core.logging import logger


class CredentialEncryption:
    """Handles encryption/decryption of storage credentials.

    Uses Fernet symmetric encryption with a key derived from environment.
    All credentials are encrypted before database storage and decrypted
    only when needed for storage adapter initialization.
    """

    _instance: Optional["CredentialEncryption"] = None
    _fernet: Optional[Fernet] = None

    def __new__(cls) -> "CredentialEncryption":
        """Singleton pattern to ensure single Fernet instance."""
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._initialize()
        return cls._instance

    def _initialize(self) -> None:
        """Initialize Fernet with encryption key from settings."""
        key = getattr(settings, "ENCRYPTION_KEY", None)

        if not key:
            # Try environment variable directly
            key = os.environ.get("ENCRYPTION_KEY")

        if not key:
            # Check environment to decide whether to fail
            is_dev = getattr(settings, "ENVIRONMENT", "development").lower() == "development"

            if not is_dev:
                logger.critical("encryption_key_missing_in_production")
                raise ValueError(
                    "CRITICAL: ENCRYPTION_KEY environment variable is required in production! "
                    'Generate one using: python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"'
                )

            # Generate a warning but don't fail in development
            logger.warning(
                "encryption_key_not_configured",
                message="ENCRYPTION_KEY not set. Using insecure dev-only fallback key. NEVER use this in production!",
            )
            # Use a deterministic key for development only
            fallback_seed = b"augo-dev-key-do-not-use-in-prod"
            key = base64.urlsafe_b64encode(fallback_seed[:32].ljust(32, b"0"))

        # Ensure key is properly formatted (bytes or base64 string)
        if isinstance(key, str):
            try:
                key = key.encode()
            except Exception:
                pass

        try:
            self._fernet = Fernet(key)
            logger.info("encryption_initialized", key_source="environment" if key else "fallback")
        except Exception as e:
            logger.error("encryption_init_failed", error=str(e))
            raise ValueError(f"Failed to initialize encryption: {e}")

    def encrypt_credentials(self, credentials: Dict[str, Any]) -> str:
        """Encrypt a credentials dictionary to a string.

        Args:
            credentials: Dictionary containing sensitive credential data
                        (e.g., access_key, secret_key, endpoint, etc.)

        Returns:
            Base64-encoded encrypted string safe for database storage

        Raises:
            ValueError: If encryption fails
        """
        if not credentials:
            return ""

        try:
            # Serialize to JSON then encrypt
            json_bytes = json.dumps(credentials, ensure_ascii=False).encode("utf-8")
            encrypted = self._fernet.encrypt(json_bytes)
            return encrypted.decode("utf-8")
        except Exception as e:
            logger.error("credential_encryption_failed", error=str(e))
            raise ValueError(f"Failed to encrypt credentials: {e}")

    def decrypt_credentials(self, encrypted_str: str) -> Dict[str, Any]:
        """Decrypt a credentials string back to a dictionary.

        Args:
            encrypted_str: Base64-encoded encrypted string from database

        Returns:
            Original credentials dictionary

        Raises:
            ValueError: If decryption fails (invalid key or corrupted data)
        """
        if not encrypted_str:
            return {}

        try:
            encrypted_bytes = encrypted_str.encode("utf-8")
            decrypted = self._fernet.decrypt(encrypted_bytes)
            return json.loads(decrypted.decode("utf-8"))
        except InvalidToken:
            logger.error("credential_decryption_failed", reason="invalid_token")
            raise ValueError("Invalid encryption key or corrupted credential data")
        except Exception as e:
            logger.error("credential_decryption_failed", error=str(e))
            raise ValueError(f"Failed to decrypt credentials: {e}")

    def mask_credentials(self, credentials: Dict[str, Any]) -> Dict[str, Any]:
        """Create a masked version of credentials for display.

        Sensitive fields are replaced with asterisks while keeping
        non-sensitive fields visible.

        Args:
            credentials: Original credentials dictionary

        Returns:
            Masked credentials dictionary safe for API responses
        """
        if not credentials:
            return {}

        sensitive_keys = {
            "secret_key",
            "secretkey",
            "password",
            "passwd",
            "access_key",
            "accesskey",
            "token",
            "api_key",
            "apikey",
        }

        masked = {}
        for key, value in credentials.items():
            key_lower = key.lower().replace("_", "").replace("-", "")
            if any(s.replace("_", "") in key_lower for s in sensitive_keys):
                if isinstance(value, str) and len(value) > 4:
                    masked[key] = f"{value[:2]}{'*' * 6}{value[-2:]}"
                else:
                    masked[key] = "********"
            else:
                masked[key] = value

        return masked


# Singleton instance for easy import
credential_encryption = CredentialEncryption()

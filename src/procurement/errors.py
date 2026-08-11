"""Procurement exception taxonomy."""


class ProcurementError(Exception):
    """Base class for procurement failures."""


class ConfigurationError(ProcurementError):
    """Configuration is missing or invalid."""


class IdentifierError(ProcurementError, ValueError):
    """An external identifier is malformed."""


class ProviderError(ProcurementError):
    """A provider could not satisfy an operation."""


class ProviderNotFoundError(ProviderError):
    """A requested provider is not registered."""


class UnsupportedCapabilityError(ProviderError):
    """A provider does not implement the requested capability."""


class ProviderHttpError(ProviderError):
    """A provider returned an unsuccessful HTTP response."""

    def __init__(self, message: str, *, status_code: int | None = None) -> None:
        super().__init__(message)
        self.status_code = status_code


class ProviderRateLimitError(ProviderHttpError):
    """A provider refused a request because of rate limiting."""


class ProviderPayloadError(ProviderError):
    """A provider response could not be decoded or mapped."""


class ProviderRecordNotFoundError(ProviderError):
    """A provider returned no record for an identifier."""


class MetadataError(ProcurementError):
    """API metadata could not satisfy a source-deposit contract."""


class MetadataIdentityError(MetadataError):
    """Returned metadata does not identify the deposited artifact."""


class MetadataUnavailableError(MetadataError):
    """No configured metadata provider produced a valid observation."""

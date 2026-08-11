"""Scholarly metadata provider adapters."""

from procurement.providers.arxiv import ArxivProvider
from procurement.providers.openalex import OpenAlexProvider
from procurement.providers.semanticscholar import SemanticScholarProvider
from procurement.providers.zenodo import ZenodoProvider

__all__ = ["ArxivProvider", "OpenAlexProvider", "SemanticScholarProvider", "ZenodoProvider"]

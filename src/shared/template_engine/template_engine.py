"""General-purpose Jinja2 rendering engine.

This module provides a flexible Jinja2 rendering engine that doesn't assume
specific project structure or template locations. It can be configured with
custom template directories, loaders, and rendering options.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

from jinja2 import (
    BaseLoader,
    DictLoader,
    Environment,
    FileSystemBytecodeCache,
    FileSystemLoader,
    Template,
    TemplateNotFound,
    select_autoescape,
)


class TemplateEngine:
    """A configurable Jinja2 template rendering engine.

    This engine can work with various template sources (filesystem, dictionary,
    custom loaders) and provides flexible configuration options.
    """

    def __init__(
        self,
        template_dirs: Optional[Union[str, Path, List[Union[str, Path]]]] = None,
        template_dict: Optional[Dict[str, str]] = None,
        loader: Optional[BaseLoader] = None,
        cache_dir: Optional[Union[str, Path]] = None,
        autoescape_extensions: Optional[List[str]] = None,
        no_autoescape_extensions: Optional[List[str]] = None,
        autoescape_default: bool = False,
        **env_kwargs: Any,
    ):
        """Initialize the template engine.

        Args:
            template_dirs: Directory or list of directories containing templates.
                          If None, no filesystem templates will be available.
            template_dict: Dictionary mapping template names to template strings.
                          Useful for inline templates or testing.
            loader: Custom Jinja2 loader. If provided, takes precedence over
                   template_dirs and template_dict.
            cache_dir: Directory for bytecode cache. If None, no caching is used.
            autoescape_extensions: List of file extensions that should have
                                 autoescaping enabled (e.g., ['html', 'xml']).
                                 Defaults to ['html', 'xml'].
            no_autoescape_extensions: List of file extensions that should have
                                    autoescaping disabled (e.g., ['md', 'txt']).
                                    Defaults to ['md', 'txt'].
            autoescape_default: Default autoescaping behavior for templates
                              without recognized extensions.
            **env_kwargs: Additional keyword arguments passed to Jinja2 Environment.
        """
        self._env = self._create_environment(
            template_dirs=template_dirs,
            template_dict=template_dict,
            loader=loader,
            cache_dir=cache_dir,
            autoescape_extensions=autoescape_extensions or ["html", "xml"],
            no_autoescape_extensions=no_autoescape_extensions or ["md", "txt"],
            autoescape_default=autoescape_default,
            **env_kwargs,
        )

    def _create_environment(
        self,
        template_dirs: Optional[Union[str, Path, List[Union[str, Path]]]],
        template_dict: Optional[Dict[str, str]],
        loader: Optional[BaseLoader],
        cache_dir: Optional[Union[str, Path]],
        autoescape_extensions: List[str],
        no_autoescape_extensions: List[str],
        autoescape_default: bool,
        **env_kwargs: Any,
    ) -> Environment:
        """Create and configure the Jinja2 environment."""

        # Set up loader
        if loader is not None:
            env_loader = loader
        elif template_dirs is not None or template_dict is not None:
            loaders = []

            # Add filesystem loader if template directories provided
            if template_dirs is not None:
                if isinstance(template_dirs, (str, Path)):
                    template_dirs = [template_dirs]
                str_dirs = [str(d) for d in template_dirs]
                loaders.append(FileSystemLoader(str_dirs))

            # Add dictionary loader if template dict provided
            if template_dict is not None:
                loaders.append(DictLoader(template_dict))

            # Use single loader or choice loader
            if len(loaders) == 1:
                env_loader = loaders[0]
            else:
                from jinja2 import ChoiceLoader
                env_loader = ChoiceLoader(loaders)
        else:
            # No templates configured - create empty dict loader
            env_loader = DictLoader({})

        # Set up bytecode cache
        bytecode_cache = None
        if cache_dir is not None:
            cache_path = Path(cache_dir)
            cache_path.mkdir(parents=True, exist_ok=True)
            bytecode_cache = FileSystemBytecodeCache(directory=str(cache_path))

        # Set up autoescaping
        autoescape = select_autoescape(
            enabled_extensions=autoescape_extensions,
            disabled_extensions=no_autoescape_extensions,
            default_for_string=autoescape_default,
        )

        # Create environment
        env = Environment(
            loader=env_loader,
            autoescape=autoescape,
            bytecode_cache=bytecode_cache,
            **env_kwargs,
        )

        return env

    @property
    def environment(self) -> Environment:
        """Get the underlying Jinja2 environment."""
        return self._env

    def render_template(self, template_name: str, **context: Any) -> str:
        """Render a template by name with the given context.

        Args:
            template_name: Name of the template to render.
            **context: Template context variables.

        Returns:
            Rendered template as string.

        Raises:
            TemplateNotFound: If the template doesn't exist.
        """
        template = self._env.get_template(template_name)
        return template.render(**context)

    def render_string(self, template_string: str, **context: Any) -> str:
        """Render a template string with the given context.

        Args:
            template_string: Template content as string.
            **context: Template context variables.

        Returns:
            Rendered template as string.
        """
        template = self._env.from_string(template_string)
        return template.render(**context)

    def render_template_safe(
        self,
        template_name: str,
        fallback_template: Optional[str] = None,
        **context: Any,
    ) -> str:
        """Render a template with fallback handling.

        Args:
            template_name: Name of the template to render.
            fallback_template: Optional fallback template string if the
                             named template is not found.
            **context: Template context variables.

        Returns:
            Rendered template as string, or fallback if template not found.

        Raises:
            TemplateNotFound: If both the named template and fallback are unavailable.
        """
        try:
            return self.render_template(template_name, **context)
        except TemplateNotFound:
            if fallback_template is not None:
                return self.render_string(fallback_template, **context)
            raise

    def add_template(self, name: str, content: str) -> None:
        """Add a template to the engine's dictionary loader.

        Note: This only works if the engine was configured with a DictLoader
        as part of its loader chain.

        Args:
            name: Template name.
            content: Template content.
        """
        # This is a limitation - we can't easily add templates to an existing
        # FileSystemLoader. For runtime template addition, users should use
        # DictLoader or implement a custom loader.
        loader = self._env.loader

        # Direct DictLoader
        if hasattr(loader, 'mapping'):
            loader.mapping[name] = content
            return

        # ChoiceLoader that may contain a DictLoader
        # Avoid importing ChoiceLoader at module top to keep deps minimal
        if hasattr(loader, 'loaders') and isinstance(getattr(loader, 'loaders'), (list, tuple)):
            for sub in loader.loaders:  # type: ignore[attr-defined]
                if hasattr(sub, 'mapping'):
                    sub.mapping[name] = content
                    return

        raise NotImplementedError(
            "Adding templates at runtime is only supported with DictLoader. "
            "Initialize the engine with template_dict or include a DictLoader in the loader chain."
        )

    def template_exists(self, template_name: str) -> bool:
        """Check if a template exists.

        Args:
            template_name: Name of the template to check.

        Returns:
            True if template exists, False otherwise.
        """
        try:
            self._env.get_template(template_name)
            return True
        except TemplateNotFound:
            return False

    def list_templates(self) -> List[str]:
        """List all available template names.

        Returns:
            List of template names.
        """
        return self._env.list_templates()


def create_simple_engine(
    template_dir: Optional[Union[str, Path]] = None,
    cache_dir: Optional[Union[str, Path]] = None,
) -> TemplateEngine:
    """Create a simple template engine with common defaults.

    Args:
        template_dir: Directory containing templates. If None, only string
                     templates can be rendered.
        cache_dir: Directory for bytecode cache. If None, no caching is used.

    Returns:
        Configured TemplateEngine instance.
    """
    return TemplateEngine(
        template_dirs=template_dir,
        cache_dir=cache_dir,
        autoescape_extensions=["html", "xml"],
        no_autoescape_extensions=["md", "txt"],
        autoescape_default=False,
    )


def create_string_engine(templates: Optional[Dict[str, str]] = None) -> TemplateEngine:
    """Create a template engine that works only with string templates.

    Args:
        templates: Optional dictionary of template name -> template content.

    Returns:
        Configured TemplateEngine instance.
    """
    return TemplateEngine(
        template_dict=templates or {},
        autoescape_extensions=["html", "xml"],
        no_autoescape_extensions=["md", "txt"],
        autoescape_default=False,
    )

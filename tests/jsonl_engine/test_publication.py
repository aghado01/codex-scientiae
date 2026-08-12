"""Generation-pinned file, hierarchy, directory, and article publication contracts."""

from __future__ import annotations

import hashlib
import os
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import jsonl_engine.publication as publication_module
from jsonl_engine.kinds.article import ArticleManifest
from jsonl_engine.publication import (
    PinnedPublicationRoot,
    PublicationConflict,
    PublicationError,
    copy_file_no_clobber,
)
from jsonl_test_support import article as article_record


class TestPinnedHierarchy(unittest.TestCase):
    def test_nested_directory_access_retains_each_route_component(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            with PinnedPublicationRoot(root_path) as root:
                nested = root.mkdir_relative("source/chapters", parents=True)
                self.assertEqual(os.path.join(root_path, "source", "chapters"), nested)
                self.assertEqual(
                    nested,
                    root.mkdir_relative("source/chapters", parents=True, exist_ok=True),
                )
                with root.open_relative_file("source/chapters/main.tex", "xb") as handle:
                    handle.write(b"\\begin{document}x\\end{document}\n")
                self.assertEqual(
                    ["main.tex"],
                    root.list_relative("source/chapters"),
                )
                self.assertTrue(
                    os.path.isfile(root.absolute_relative("source/chapters/main.tex"))
                )
                self.assertEqual(
                    b"\\begin{document}x\\end{document}\n",
                    root.read_relative_bytes(
                        "source/chapters/main.tex",
                        maximum_bytes=len(b"\\begin{document}x\\end{document}\n"),
                    ),
                )
                self.assertEqual(
                    len(b"\\begin{document}x\\end{document}\n"),
                    root.stat_relative("source/chapters/main.tex").st_size,
                )

    def test_nested_access_rejects_a_redirecting_directory_component(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            outside = os.path.join(parent, "outside")
            os.mkdir(root_path)
            os.mkdir(outside)
            with open(os.path.join(outside, "evidence.bin"), "wb") as handle:
                handle.write(b"outside")
            link = os.path.join(root_path, "linked")
            try:
                os.symlink(outside, link, target_is_directory=True)
            except (OSError, NotImplementedError) as exc:
                self.skipTest(f"directory symbolic links are unavailable: {exc}")
            with PinnedPublicationRoot(root_path) as root:
                with self.assertRaises((OSError, NotADirectoryError, PublicationConflict)):
                    with root.open_relative_file("linked/evidence.bin", "rb"):
                        pass

    def test_stable_file_read_measure_and_mutation_detection(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            path = os.path.join(root_path, "evidence.bin")
            raw = b"stable evidence\n"
            with open(path, "wb") as handle:
                handle.write(raw)
            with PinnedPublicationRoot(root_path) as root:
                self.assertEqual(raw, root.read_bytes(path, maximum_bytes=len(raw)))
                measured = root.measure_file(path, maximum_bytes=len(raw))
                self.assertEqual(len(raw), measured.bytes)
                self.assertEqual(hashlib.sha256(raw).hexdigest(), measured.sha256)
                with self.assertRaisesRegex(PublicationError, "byte boundary"):
                    root.read_bytes(path, maximum_bytes=len(raw) - 1)
                with self.assertRaisesRegex(PublicationConflict, "changed while it was open"):
                    with root.open_stable_file(path):
                        with open(path, "ab") as writer:
                            writer.write(b"changed")


class TestPinnedFileCopy(unittest.TestCase):
    def test_copy_is_independent_create_only_and_idempotent(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            source_dir = os.path.join(parent, "source")
            destination_dir = os.path.join(parent, "destination")
            os.mkdir(source_dir)
            os.mkdir(destination_dir)
            source = os.path.join(source_dir, "paper.tar.gz")
            destination = os.path.join(destination_dir, "paper.tar.gz")
            raw = b"source archive bytes\n"
            with open(source, "wb") as handle:
                handle.write(raw)
            digest = hashlib.sha256(raw).hexdigest()

            with PinnedPublicationRoot(source_dir) as source_root, PinnedPublicationRoot(
                destination_dir
            ) as destination_root:
                with self.assertRaisesRegex(ValueError, "distinct files"):
                    copy_file_no_clobber(
                        source_root,
                        source,
                        source_root,
                        source,
                    )
                first = copy_file_no_clobber(
                    source_root,
                    source,
                    destination_root,
                    destination,
                    expected_bytes=len(raw),
                    expected_sha256=digest,
                )
                before_mtime = os.stat(destination).st_mtime_ns
                second = copy_file_no_clobber(
                    source_root,
                    source,
                    destination_root,
                    destination,
                    expected_bytes=len(raw),
                    expected_sha256=digest,
                )

            self.assertTrue(first.created)
            self.assertFalse(second.created)
            self.assertEqual(raw, Path(destination).read_bytes())
            self.assertFalse(os.path.samefile(source, destination))
            self.assertEqual(before_mtime, os.stat(destination).st_mtime_ns)
            self.assertEqual(
                [],
                [name for name in os.listdir(destination_dir) if name.endswith(".tmp")],
            )

    def test_copy_rejects_expected_or_occupied_byte_conflicts_without_clobber(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            source_dir = os.path.join(parent, "source")
            destination_dir = os.path.join(parent, "destination")
            os.mkdir(source_dir)
            os.mkdir(destination_dir)
            source = os.path.join(source_dir, "source.bin")
            destination = os.path.join(destination_dir, "destination.bin")
            source_raw = b"source"
            incumbent = b"incumbent"
            with open(source, "wb") as handle:
                handle.write(source_raw)
            with PinnedPublicationRoot(source_dir) as source_root, PinnedPublicationRoot(
                destination_dir
            ) as destination_root:
                with self.assertRaisesRegex(PublicationConflict, "expected digest"):
                    copy_file_no_clobber(
                        source_root,
                        source,
                        destination_root,
                        destination,
                        expected_bytes=len(source_raw),
                        expected_sha256="0" * 64,
                    )
                self.assertFalse(os.path.lexists(destination))
                with open(destination, "wb") as handle:
                    handle.write(incumbent)
                with self.assertRaisesRegex(PublicationConflict, "conflicting bytes"):
                    copy_file_no_clobber(
                        source_root,
                        source,
                        destination_root,
                        destination,
                    )
            self.assertEqual(incumbent, Path(destination).read_bytes())
            self.assertEqual(
                [],
                [name for name in os.listdir(destination_dir) if name.endswith(".tmp")],
            )

    def test_copy_adopts_an_identical_destination_that_wins_the_publish_race(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            source_dir = os.path.join(parent, "source")
            destination_dir = os.path.join(parent, "destination")
            os.mkdir(source_dir)
            os.mkdir(destination_dir)
            source = os.path.join(source_dir, "source.bin")
            destination = os.path.join(destination_dir, "destination.bin")
            raw = b"identical peer publication"
            Path(source).write_bytes(raw)

            with PinnedPublicationRoot(source_dir) as source_root, PinnedPublicationRoot(
                destination_dir
            ) as destination_root:
                def racing_publish(root, staged, target, *, overwrite):
                    self.assertIs(root, destination_root)
                    self.assertFalse(overwrite)
                    with root.open_file(target, "xb") as handle:
                        handle.write(raw)
                    raise FileExistsError(target)

                with mock.patch.object(
                    PinnedPublicationRoot,
                    "publish",
                    autospec=True,
                    side_effect=racing_publish,
                ):
                    result = copy_file_no_clobber(
                        source_root,
                        source,
                        destination_root,
                        destination,
                    )

            self.assertFalse(result.created)
            self.assertEqual(raw, Path(destination).read_bytes())
            self.assertEqual(
                [],
                [name for name in os.listdir(destination_dir) if name.endswith(".tmp")],
            )

    def test_copy_refuses_a_conflicting_destination_that_wins_the_publish_race(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            source_dir = os.path.join(parent, "source")
            destination_dir = os.path.join(parent, "destination")
            os.mkdir(source_dir)
            os.mkdir(destination_dir)
            source = os.path.join(source_dir, "source.bin")
            destination = os.path.join(destination_dir, "destination.bin")
            Path(source).write_bytes(b"candidate")
            incumbent = b"peer winner"

            with PinnedPublicationRoot(source_dir) as source_root, PinnedPublicationRoot(
                destination_dir
            ) as destination_root:
                def racing_publish(root, staged, target, *, overwrite):
                    self.assertIs(root, destination_root)
                    self.assertFalse(overwrite)
                    with root.open_file(target, "xb") as handle:
                        handle.write(incumbent)
                    raise FileExistsError(target)

                with mock.patch.object(
                    PinnedPublicationRoot,
                    "publish",
                    autospec=True,
                    side_effect=racing_publish,
                ), self.assertRaisesRegex(PublicationConflict, "appeared with conflicting"):
                    copy_file_no_clobber(
                        source_root,
                        source,
                        destination_root,
                        destination,
                    )

            self.assertEqual(incumbent, Path(destination).read_bytes())
            self.assertEqual(
                [],
                [name for name in os.listdir(destination_dir) if name.endswith(".tmp")],
            )


class TestPinnedDirectoryPublication(unittest.TestCase):
    @staticmethod
    def _tree(root: str, leaf: str, body: bytes) -> str:
        path = os.path.join(root, leaf)
        os.mkdir(path)
        with open(os.path.join(path, "main.tex"), "wb") as handle:
            handle.write(body)
        return path

    def test_directory_publication_preserves_generation_and_refuses_empty_occupancy(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            staged = self._tree(root_path, ".tree-stage", b"candidate")
            occupied = self._tree(root_path, ".other-stage", b"other")
            destination = os.path.join(root_path, "paper-tex")
            occupied_destination = os.path.join(root_path, "occupied-tex")
            os.mkdir(occupied_destination)
            with PinnedPublicationRoot(root_path) as root:
                source_identity = root.stat_path(staged)
                published = root.publish_directory(staged, destination)
                destination_identity = root.stat_path(destination)
                self.assertEqual(destination, published)
                self.assertFalse(os.path.lexists(staged))
                if source_identity.st_ino or destination_identity.st_ino:
                    self.assertEqual(
                        (source_identity.st_dev, source_identity.st_ino),
                        (destination_identity.st_dev, destination_identity.st_ino),
                    )
                with self.assertRaises(FileExistsError):
                    root.publish_directory(occupied, occupied_destination)
            self.assertEqual(b"candidate", Path(destination, "main.tex").read_bytes())
            self.assertEqual(b"other", Path(occupied, "main.tex").read_bytes())
            self.assertEqual([], os.listdir(occupied_destination))

    def test_destination_appearing_after_precheck_is_never_replaced(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            staged = self._tree(root_path, ".tree-stage", b"candidate")
            destination = os.path.join(root_path, "paper-tex")
            with PinnedPublicationRoot(root_path) as root:
                if os.name == "nt":
                    original = publication_module.os.rename

                    def race(source: str, target: str) -> None:
                        os.mkdir(target)
                        with open(os.path.join(target, "peer.txt"), "wb") as handle:
                            handle.write(b"peer")
                        original(source, target)

                    patch = mock.patch("jsonl_engine.publication.os.rename", side_effect=race)
                else:
                    original = publication_module._rename_directory_no_replace_posix

                    def race(directory_fd, source_leaf, destination_leaf, *, destination_path):
                        os.mkdir(destination_path)
                        with open(os.path.join(destination_path, "peer.txt"), "wb") as handle:
                            handle.write(b"peer")
                        return original(
                            directory_fd,
                            source_leaf,
                            destination_leaf,
                            destination_path=destination_path,
                        )

                    patch = mock.patch(
                        "jsonl_engine.publication._rename_directory_no_replace_posix",
                        side_effect=race,
                    )
                with patch, self.assertRaises(FileExistsError):
                    root.publish_directory(staged, destination)
            self.assertEqual(b"candidate", Path(staged, "main.tex").read_bytes())
            self.assertEqual(b"peer", Path(destination, "peer.txt").read_bytes())

    def test_owned_private_tree_cleanup_is_recursive(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            staged = self._tree(root_path, "paper-tex.123.1.tmp", b"candidate")
            nested = Path(staged, "chapters")
            nested.mkdir()
            Path(nested, "one.tex").write_bytes(b"chapter")
            with PinnedPublicationRoot(root_path) as root:
                root.remove_owned_tree(staged)
                self.assertFalse(os.path.lexists(staged))

    def test_owned_private_tree_cleanup_rejects_links(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            with PinnedPublicationRoot(root_path) as root:
                unsafe = os.path.join(root_path, "paper-tex.123.2.tmp")
                os.mkdir(unsafe)
                target = os.path.join(root_path, "outside.txt")
                Path(target).write_bytes(b"outside")
                link = os.path.join(unsafe, "redirect")
                try:
                    os.symlink(target, link)
                except (OSError, NotImplementedError) as exc:
                    self.skipTest(f"symbolic links are unavailable: {exc}")
                with self.assertRaisesRegex(PublicationConflict, "link, reparse point"):
                    root.remove_owned_tree(unsafe)
                self.assertEqual(b"outside", Path(target).read_bytes())


class TestPinnedArticleManifest(unittest.TestCase):
    def test_article_read_and_publish_use_the_supplied_directory_generation(self) -> None:
        with tempfile.TemporaryDirectory() as root_path:
            record = article_record("pinned-article")
            with PinnedPublicationRoot(root_path) as root:
                manifest = ArticleManifest(root_path, publication_root=root)
                path = manifest.publish(record)
                self.assertEqual(os.path.join(root_path, "article.json"), path)
                self.assertEqual(record, manifest.read())
                self.assertEqual(
                    [],
                    [name for name in os.listdir(root_path) if name.endswith(".tmp")],
                )
                conflicting = article_record("pinned-article")
                conflicting["title"] = "A conflicting replacement"
                with self.assertRaises(FileExistsError):
                    manifest.publish(conflicting)
                self.assertEqual(record, manifest.read())

    @unittest.skipIf(os.name == "nt", "Windows retains the article route against replacement")
    def test_article_refuses_a_replacement_generation(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            root_path = os.path.join(parent, "root")
            retired = os.path.join(parent, "retired")
            os.mkdir(root_path)
            with PinnedPublicationRoot(root_path) as root:
                manifest = ArticleManifest(root_path, publication_root=root)
                os.rename(root_path, retired)
                os.mkdir(root_path)
                with self.assertRaisesRegex(RuntimeError, "no longer names"):
                    manifest.publish(article_record("replacement-refused"))
            self.assertEqual([], os.listdir(root_path))
            self.assertEqual([], os.listdir(retired))


if __name__ == "__main__":
    unittest.main()

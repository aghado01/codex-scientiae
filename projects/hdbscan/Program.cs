using CodexSci.Hdbscan;

// Entry point for hdbscan.exe. All logic lives in the library sources at src/hdbscan
// (routed in via SharedSource); this file only forwards argv and the exit code so the
// shared sources carry no entry point and also compile cleanly into the test assembly.
return HdbscanCli.Run(args);

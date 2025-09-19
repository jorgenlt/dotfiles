#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const os = require("os");
const { spawn } = require("child_process");

// --------- Configuration / Arguments ---------
const folderName = process.argv[2];
const bookmarksPath =
  process.argv[3] ||
  path.join(os.homedir(), ".config", "vivaldi", "Default", "Bookmarks");

// --------- Basic validation ---------
if (!folderName) {
  const scriptName = path.basename(
    process.argv[1] || "open_bookmarks_simple.js"
  );
  console.error(
    `Usage: ${scriptName} "Bookmark Folder Name" [path/to/Bookmarks]`
  );
  process.exit(2);
}
if (!fs.existsSync(bookmarksPath)) {
  console.error(`Bookmarks file not found: ${bookmarksPath}`);
  process.exit(5);
}

// --------- Read and parse bookmarks ---------
let root;
try {
  root = JSON.parse(fs.readFileSync(bookmarksPath, "utf8"));
} catch (e) {
  console.error("Failed to parse bookmarks JSON");
  process.exit(1);
}

// --------- Helpers: collect URLs recursively ---------
function collectAllUrls(node, acc) {
  if (!node || typeof node !== "object") return;
  if (node.type === "url" && typeof node.url === "string") acc.push(node.url);
  const children = Array.isArray(node.children) ? node.children : [];
  for (const child of children) collectAllUrls(child, acc);
}

// Walk the tree and collect URLs from folders named folderName
function walk(node, acc) {
  if (!node || typeof node !== "object") return;
  if (node.type === "folder" && node.name === folderName) {
    collectAllUrls(node, acc);
  }
  const children = Array.isArray(node.children) ? node.children : [];
  for (const child of children) walk(child, acc);
}

// Start from data.roots (if present) or from the root
let urls = [];
if (root && typeof root === "object") {
  if (root.roots && typeof root.roots === "object") {
    for (const key of Object.keys(root.roots)) {
      walk(root.roots[key], urls);
    }
  } else {
    walk(root, urls);
  }
}

// Deduplicate URLs
const uniqueUrls = Array.from(new Set(urls));

if (uniqueUrls.length === 0) {
  console.error(
    `No bookmarks found in folder "${folderName}" (searched: ${bookmarksPath}).`
  );
  process.exit(6);
}

// --------- Open URLs in Vivaldi ---------
const vivaldiBin = process.env.VIVALDI_BIN || "vivaldi";
const args = ["--new-window", ...uniqueUrls];

try {
  const child = spawn(vivaldiBin, args, { detached: true, stdio: "ignore" });
  child.unref();
} catch (err) {
  console.error(
    `Failed to start Vivaldi. Is it installed and in PATH? (${err.message})`
  );
  process.exit(4);
}

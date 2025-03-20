import { fileURLToPath } from 'url';
import fs from 'fs';
import path from 'path';
import MarkdownIt from 'markdown-it';
import hljs from 'highlight.js';

export default function (eleventyConfig) {
  const __dirname = path.dirname(fileURLToPath(import.meta.url));
  
  // markdown parser
  const markdownLib = MarkdownIt({
    html: true,
    breaks: true,
    linkify: true,
    typographer: true,
    highlight: function (str, lang) {
      if (lang && hljs.getLanguage(lang)) {
        try {
          return hljs.highlight(str, { language: lang }).value;
        } catch (__) {}
      }
  
      return ''; // use external default escaping
    }
  });
  
  // exports
  eleventyConfig.addPassthroughCopy({
    'node_modules/@github/relative-time-element/dist/bundle.js': 'assets/js/relative-time/relative-time-element.js',
    '_includes/_data/og.png': 'public/img/og.png',
    '_includes/js': 'assets/js',
    '_includes/img': 'assets/img',
    // '_includes/css': 'assets/css',
  });

  // Add filter to include markdown content by UUID and convert to HTML
  eleventyConfig.addFilter('includeMarkdown', function(uuid) {
    const filePath = path.join(__dirname, '_includes', 'posts', 'contents', `${uuid}.md`);
    if (fs.existsSync(filePath)) {
      const markdownContent = fs.readFileSync(filePath, 'utf8');
      // Convert the markdown content to HTML before returning it
      return markdownLib.render(markdownContent);
    }
    return 'Content not found';
  });

  return {
    dir: {
      input: "_includes",
      output: "_site",
      includes: "_includes",
      layouts: "_layouts",
    },
  };
}

import hljs from '/node_modules/highlight.js';
import '/node_modules/highlight.js/styles/github.css';

document.querySelectorAll('pre code').forEach((block) => {
  hljs.highlightElement(block);
});
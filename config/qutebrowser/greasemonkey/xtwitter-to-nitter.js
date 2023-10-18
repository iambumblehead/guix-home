// ==UserScript==
// @name        Twitter and Xcom to Nitter
// @description Changes Twitter links from both twitter.com and x.com to nitter.net links.
// @match       *://*/*
// @grant       none
// @version     4.1
// @author      sunmilk50
// @license     public domain
// @description 2023-10-06
// @namespace   https://greasyfork.org/users/1188705
// ==/UserScript==

const domainsRe = /https:\/\/(twitter|x).com/gi;
const nitterhost = 'https://nitter.net';

// Define a function to process and replace links and text on the page
const go = doc => doc
  .querySelectorAll('a[href*="twitter.com"], a[href*="x.com"]')
  .map(elem => elem.href = String(elem.href).replace(domainsRe, nitterhost));

// Create a MutationObserver to detect changes in the DOM
const mutationObserver = new MutationObserver(mutations => {
  for (const mutation of mutations) {
    if (mutation.addedNodes.length || mutation.attributeName === 'href') {
      go(document);
      break;
    }
  }
});

// Observe changes in the document's attributes and child nodes
mutationObserver.observe(document, {
  attributeFilter: ['href'],
  childList: true,
  subtree: true,
});

// Initial processing of links and text
go(document);

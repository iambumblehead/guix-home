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


const nitterDefault = "https://nitter.net";
const instance = nitterDefault;

function redirectTwitter(url) {
  if (url.host.split(".")[0] === "pbs") {
    return `${instance}/pic/${encodeURIComponent(url.href)}`;
  } else if (url.host.split(".")[0] === "video") {
    return `${instance}/gif/${encodeURIComponent(url.href)}`;
  } else if (url.pathname.includes("tweets")) {
    return `${instance}${url.pathname.replace("/tweets", "")}${url.search}`;
  } else {
    return `${instance}${url.pathname}${url.search}`;
  }
}

const twitter_hosts = [
  "twitter.com",
  "www.twitter.com",
  "mobile.twitter.com",
  "pbs.twimg.com",
  "video.twimg.com",
];

// Define a function to process and replace links and text on the page
const go = doc => Array.from(
    doc.querySelectorAll('a[href*="twitter.com"], a[href*="x.com"]'))
      .forEach(elem => elem.href = redirectTwitter(new URL(elem.href)));

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

if (twitter_hosts.includes(window.location.hostname)) {
    const url = new URL(window.location);
    const redirect = redirectTwitter(url);
    console.info("Redirecting", `"${url.href}"`, "=>", `"${redirect}"`);
    window.location = redirect;
}


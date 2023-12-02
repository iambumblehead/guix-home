// ==UserScript==
// @name        X Redirect to Nitter
// @description Redirect from x to nitter
// @match       *://*/*
// @grant       none
// @version     4.1
// @author      sunmilk50
// @license     public domain
// @description 2023-10-06
// @namespace   https://greasyfork.org/users/1188705
// @run-at      document-start
// ==/UserScript==

const twitterHosts = [
  "x.com",
  "twitter.com",
  "www.twitter.com",
  "mobile.twitter.com",
  "pbs.twimg.com",
  "video.twimg.com",
];

const twitterHostsRe = new RegExp(twitterHosts.join('|'));

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

(win => {
    if (!twitterHostsRe.test(win.location.hostname))
        return null;
    if (/flow/gi.test(win.location.href) && !/redirect/gi.test(win.location.href))
        return null;

    const url = /redirect/gi.test(win.location.search)
      ? win.location.search
        .split('&')
        .filter(s => /redirect/gi.test(s))
        .map(s => win.location.origin + decodeURIComponent(s.split('=')[1]))
        .map(s => (console.log({ s }),new URL(s)))[0]
      : new URL(win.location);
    
    const redirect = redirectTwitter(url);
    console.info("redirect start ", `"${url.href}"`);
    console.info("redirect to ", `"${redirect}"`);
    // win.location.href = redirect.href;
})(window);

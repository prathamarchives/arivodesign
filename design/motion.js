/* motion.js — INT-020 motion system + INT-027 app behaviors.
   (master: scripts/design-glue/)
   ---------------------------------------------------------------
   LAWS (motion.css mirror):
   1. EXPAND, never bounce — no stagger cascades anywhere.
   2. Entrance = 2-3 soft block rises (70ms steps).
   3. The rail expands on hover/focus (64 -> 168) — CSS owns the
      motion; this file flips the `expanded` class only.
   AMENDED (owner turn 28, INT-027): view + theme transitions are
   BLUR-swept by explicit order ("blur out and blur in with motion")
   — implemented with the Web Animations API so NO stylesheet
   transition stack is touched (law 5 holds for CSS).
   NEW (owner turn 28):
   - ROUTER: internal links swap the page in-place (no reload):
     old view blurs out sliding RIGHT, new view blurs in from the
     LEFT; history + popstate wired; the rail element is ADOPTED
     into the new shell (hover/expansion state never dies).
   - THEME: the toggle flips body.theme-* (never navigates), swaps
     the rail + toggle glyph srcs, persists via sessionStorage; a
     blur-out/blur-in sweep covers the flip. The mode survives
     section switches (the owner's "mode changes" bug).
   - AUTO-HIDE: when the pointer is idle (or outside the chrome)
     for 3.2s, the rail + header fade and slide up and the content
     column takes the full width (body.chrome-hidden, CSS side);
     any activity brings them back. */
(function () {
  var body = document.body;
  body.classList.add('js');

  /* ---- theme normalization on every load (INT-027) ----
     The inline restore script (right after <body>) flips the CLASS
     early to dodge the canvas flash, but it cannot swap icon srcs
     (the imgs are not parsed yet). This is the second half: apply
     the persisted theme fully — rail icon set + toggle glyph — or,
     on a first visit, pin the icons to the baked theme. Without
     this, a direct load of a light page in a saved dark session
     renders light glyphs on the dark rail (invisible icons). */
  (function themeInit() {
    var saved = null;
    try { saved = sessionStorage.getItem('pa-theme'); } catch (e) {}
    if (saved === 'theme-dark' || saved === 'theme-light') applyTheme(saved, { animate: false });
    else swapIcons(currentTheme());
  })();

  var REDUCED = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var EASE = 'cubic-bezier(0.32, 0.72, 0, 1)';
  var VIEW_LEAVE_MS = 240, VIEW_ENTER_MS = 320, THEME_MS = 170;
  var IDLE_MS = 3200;

  var busy = false;

  function pageRoot()   { return document.querySelector('body > div'); }
  function shellEl()    { return document.querySelector('body > div > [class^="study-shell-"]'); }
  function railWrap(el) { return (el || shellEl()).querySelector('[class^="navigation-rail-"], [class^="expanded-navigation-"]'); }
  function headerEl(el) { return (el || shellEl()).querySelector(':scope > [class^="workspace-header-"]'); }
  function contentEl(el){ var sh = (el || shellEl()); var kids = sh.children;
                          for (var i = 0; i < kids.length; i++) {
                            var c = kids[i].className || '';
                            if (c.indexOf('navigation-rail-') === 0 || c.indexOf('expanded-navigation-') === 0) continue;
                            if (c.indexOf('workspace-header-') === 0) continue;
                            if (c.indexOf('study-shell-') === 0) continue;
                            return kids[i]; }
                          return null; }
  function wait(ms)     { return new Promise(function (r) { setTimeout(r, ms); }); }

  /* ---- entrance: 2-3 block rises, one 70ms step apart (run ONCE per load) ---- */
  (function entrance() {
    var shell = shellEl();
    if (!shell) return;
    var blocks = [];
    var kids = shell.children;
    for (var i = 0; i < kids.length; i++) {
      var cls = kids[i].className || '';
      if (/navigation-rail-|expanded-navigation-/.test(cls)) continue;
      blocks.push(kids[i]);
    }
    for (var b = 0; b < blocks.length && b < 3; b++) {
      blocks[b].classList.add('rise');
      blocks[b].style.setProperty('--d', (b * 70) + 'ms');
    }
  })();

  /* ---- rail: mark the current page's item selected (ink pill) ---- */
  function markSelected() {
    var page = body.getAttribute('data-page');
    var items = document.querySelectorAll('.rail-panel [class^="navigation-item-"]');
    for (var k = 0; k < items.length; k++) {
      var on = items[k].getAttribute('href') === page;
      items[k].classList.toggle('selected', on);
      if (on) items[k].setAttribute('aria-current', 'page');
      else items[k].removeAttribute('aria-current');
    }
  }
  markSelected();

  /* ---- rail expansion: hover + keyboard focus (one class flip) ----
     railCtl is exposed for the ROUTER: after a view swap the adopted rail
     must be re-opened THROUGH the controller (canceling any close-grace
     armed by the DOM-move mouseleave) — a bare classList.add loses the
     race to the 140ms timer and the rail collapses under the pointer. */
  var railCtl = null;
  (function railExpand() {
    var rail = document.querySelector('.rail-panel');
    if (!rail) return;
    var closeTimer = null;
    var open = function () {
      if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
      rail.classList.add('expanded');
    };
    var close = function () {
      closeTimer = setTimeout(function () {
        rail.classList.remove('expanded');
        closeTimer = null;
      }, 140);
    };
    rail.addEventListener('mouseenter', open);
    rail.addEventListener('mouseleave', close);
    rail.addEventListener('focusin', open);
    rail.addEventListener('focusout', function (e) {
      if (!rail.contains(e.relatedTarget)) close();
    });
    railCtl = { open: open };
  })();

  /* ==================== THEME (INT-027) ==================== */
  function currentTheme() {
    return body.classList.contains('theme-dark') ? 'theme-dark' : 'theme-light';
  }

  function swapIcons(theme) {
    var key = theme === 'theme-dark' ? 'data-icon-dark' : 'data-icon-light';
    document.querySelectorAll('img[' + key + ']').forEach(function (img) {
      img.src = img.getAttribute(key);
    });
  }

  function applyTheme(theme, opts) {
    opts = opts || {};
    body.classList.remove('theme-dark', 'theme-light');
    body.classList.add(theme);
    swapIcons(theme);
    try { sessionStorage.setItem('pa-theme', theme); } catch (e) {}
    if (opts.animate && !REDUCED) {
      var root = pageRoot();
      if (root) {
        root.animate(
          [{ filter: 'blur(0px)', opacity: 1 },
           { filter: 'blur(10px)', opacity: 0.55 }],
          { duration: THEME_MS, easing: 'ease', fill: 'forwards' }
        ).onfinish = function () {
          root.animate(
            [{ filter: 'blur(10px)', opacity: 0.55 },
             { filter: 'blur(0px)', opacity: 1 }],
            { duration: THEME_MS + 90, easing: EASE }
          );
        };
      }
    }
  }

  /* toggle: never navigates (the href stays as the no-JS fallback) */
  document.addEventListener('click', function (e) {
    var tog = e.target.closest && e.target.closest('[data-theme-toggle]');
    if (!tog) return;
    e.preventDefault();
    if (busy) return;
    var next = currentTheme() === 'theme-dark' ? 'theme-light' : 'theme-dark';
    if (REDUCED) { applyTheme(next, { animate: false }); return; }
    busy = true;
    var root = pageRoot();
    var out = root.animate(
      [{ filter: 'blur(0px)', opacity: 1 },
       { filter: 'blur(10px)', opacity: 0.55 }],
      { duration: THEME_MS, easing: 'ease', fill: 'forwards' }
    );
    out.onfinish = function () {
      applyTheme(next, { animate: false });
      root.animate(
        [{ filter: 'blur(10px)', opacity: 0.55 },
         { filter: 'blur(0px)', opacity: 1 }],
        { duration: THEME_MS + 90, easing: EASE }
      );
      busy = false;
    };
  });

  /* bfcache: a restored page may carry a stale theme — re-normalize */
  window.addEventListener('pageshow', function (e) {
    if (e.persisted) {
      var saved = null;
      try { saved = sessionStorage.getItem('pa-theme'); } catch (err) {}
      if (saved === 'theme-dark' || saved === 'theme-light') {
        if (saved !== currentTheme()) applyTheme(saved, { animate: false });
        else swapIcons(saved);
      }
      markSelected();
    }
  });

  /* ==================== ROUTER (INT-027) ==================== */
  /* Cache the HTML STRING, never the parsed node: adopting a parsed
     root into the live document EMPTIES the cached doc (cross-document
     adoption moves the node), so a node cache returns null on revisit
     and the fallback reload fires — the exact "hard refresh" the
     owner ordered dead. Re-parsing a small static page is free. */
  var htmlCache = {};

  function fetchHTML(url) {
    if (htmlCache[url]) return Promise.resolve(htmlCache[url]);
    return fetch(url, { credentials: 'same-origin' })
      .then(function (r) {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.text();
      })
      .then(function (html) {
        htmlCache[url] = html;
        return html;
      });
  }

  function animateLeave(els, dir) {
    if (REDUCED || !els.length) return Promise.resolve();
    els.forEach(function (el) {
      el.animate(
        [{ opacity: 1, filter: 'blur(0px)', transform: 'none' },
         { opacity: 0, filter: 'blur(8px)', transform: 'translateX(' + (48 * dir) + 'px)' }],
        { duration: VIEW_LEAVE_MS, easing: EASE, fill: 'forwards' }
      );
    });
    return wait(VIEW_LEAVE_MS);
  }

  function animateEnter(els, dir) {
    if (REDUCED || !els.length) return;
    els.forEach(function (el, i) {
      var travel = i === 0 ? 48 : 24;   // content travels far, header less
      el.animate(
        [{ opacity: 0, filter: 'blur(8px)', transform: 'translateX(' + (-travel * dir) + 'px)' },
         { opacity: 1, filter: 'blur(0px)', transform: 'none' }],
        { duration: VIEW_ENTER_MS, easing: EASE }
      );
    });
  }

  function resolveURL(href) {
    var a = document.createElement('a');
    a.href = href;
    return a;
  }

  function navigate(url, dir, push) {
    if (busy) return;
    var target = resolveURL(url);
    if (target.pathname.indexOf('.html') === -1) return; // not a page link
    /* The no-op guard reads the DOM STATE, not the URL: on popstate the
       browser has ALREADY moved the URL before the event fires, so a URL
       comparison would compare the target with itself and swallow the
       back/forward swap (the DOM would desync from the address bar).
       data-page is the truth of what is on screen. */
    var targetPage = target.pathname.replace(/^.*\//, '');
    if (body.getAttribute('data-page') === targetPage) return;
    busy = true;
    var oldShell = shellEl();
    var leaving = [];
    if (contentEl(oldShell)) leaving.push(contentEl(oldShell));
    if (headerEl(oldShell)) leaving.push(headerEl(oldShell));

    fetchHTML(target.pathname)
      .then(function (html) {
        var doc = new DOMParser().parseFromString(html, 'text/html');
        return animateLeave(leaving, dir).then(function () { return doc; });
      })
      .then(function (doc) {
        var newRoot = doc.querySelector('body > div');
        if (!newRoot) throw new Error('bad doc');
        var newShell = newRoot.querySelector('[class^="study-shell-"]');
        var liveRail = railWrap(null);
        var newRail = railWrap(newShell);
        if (liveRail) {
          if (newRail) newRail.replaceWith(liveRail);   // ADOPT: hover state + listeners survive
          /* a REVISITED cached root has an EMPTY rail slot (the live rail
             was adopted out of it on the previous visit) — re-seat the live
             rail as the shell's first child (every page's DOM order) */
          else newShell.insertBefore(liveRail, newShell.firstChild);
        }
        pageRoot().replaceWith(newRoot);

        /* the DOM move can drop the browser's hover flag under a
           stationary pointer AND arms the 140ms close-grace via the
           synthetic mouseleave — re-assert THROUGH the controller so
           the grace is canceled, not raced (clicking a nav item must
           never collapse the rail out from under the cursor) */
        var railPanel = document.querySelector('.rail-panel');
        if (railPanel) {
          var rr = liveRail ? liveRail.getBoundingClientRect() : null;
          if (rr && pointer.x >= rr.left && pointer.x <= rr.right && pointer.y >= rr.top && pointer.y <= rr.bottom) {
            if (railCtl) railCtl.open();
            else railPanel.classList.add('expanded');
          }
        }

        body.setAttribute('data-page', doc.body.getAttribute('data-page') || '');
        document.title = doc.title || document.title;
        applyTheme(currentTheme(), { animate: false });           // mode PERSISTS across sections
        markSelected();
        var sh = shellEl();
        sh.querySelectorAll('[class^="home-content-"], [class^="library-content-"], [class^="archive-content-"], [class^="reading-page-"], [class^="authored-day-page-"], [class^="reader-"], [class^="journal-"]')
          .forEach(function (n) { if (n.scrollTop) n.scrollTop = 0; });
        if (window.scrollTo) window.scrollTo(0, 0);

        if (push) history.pushState({ d: dir }, '', target.pathname);
        var entering = [];
        if (contentEl(sh)) entering.push(contentEl(sh));
        if (headerEl(sh)) entering.push(headerEl(sh));
        animateEnter(entering, dir);
        wakeChrome();
        busy = false;
      })
      .catch(function () {
        /* graceful degradation: a failed fetch is a real navigation */
        window.location.href = url;
      });
  }

  document.addEventListener('click', function (e) {
    if (e.defaultPrevented) return;
    if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey || e.button !== 0) return;
    var a = e.target.closest && e.target.closest('a[href]');
    if (!a) return;
    if (a.getAttribute('data-theme-toggle')) return;   // theme path owns it
    var url = a.getAttribute('href');
    if (!url || url.charAt(0) === '#' || url.indexOf('://') !== -1 || url.indexOf('mailto:') === 0) return;
    var target = resolveURL(url);
    if (target.host !== location.host) return;
    e.preventDefault();
    navigate(target.pathname, 1, true);
  });

  window.addEventListener('popstate', function () {
    navigate(location.pathname, -1, false);
  });

  /* ==================== CHROME AUTO-HIDE (INT-027) ==================== */
  var idleTimer = null;
  var pointer = { x: -1, y: -1 };

  function chromeRects() {
    var out = [];
    var rw = railWrap(null), hd = headerEl(null);
    if (rw) { var r = rw.getBoundingClientRect(); out.push(r); }
    if (hd) { var h = hd.getBoundingClientRect(); out.push(h); }
    return out;
  }

  function pointerInChrome() {
    var rects = chromeRects();
    for (var i = 0; i < rects.length; i++) {
      var r = rects[i];
      if (pointer.x >= r.left && pointer.x <= r.right && pointer.y >= r.top && pointer.y <= r.bottom) return true;
    }
    return false;
  }

  function focusInChrome() {
    /* only TYPING contexts pin the chrome open — a link that merely
       received a click-focus is not "interacting" (the owner's rule is
       about use, not about residual focus; otherwise one toggle click
       would keep the chrome awake forever) */
    var a = document.activeElement;
    if (!a) return false;
    var tag = a.tagName;
    if (tag !== 'INPUT' && tag !== 'TEXTAREA' && !a.isContentEditable) return false;
    return !!(a.closest && (a.closest('[class^="workspace-header-"]') || a.closest('.rail-panel')));
  }

  function railExpanded() {
    var p = document.querySelector('.rail-panel');
    return !!(p && p.classList.contains('expanded'));
  }

  function hideChrome() {
    if (busy || pointerInChrome() || focusInChrome() || railExpanded()) { armIdle(); return; }
    body.classList.add('chrome-hidden');
  }

  function armIdle() {
    if (idleTimer) clearTimeout(idleTimer);
    idleTimer = setTimeout(hideChrome, IDLE_MS);
  }

  function wakeChrome() {
    body.classList.remove('chrome-hidden');
    armIdle();
  }

  ['pointermove', 'pointerdown', 'keydown', 'wheel', 'touchstart'].forEach(function (ev) {
    window.addEventListener(ev, function (e) {
      if (e.clientX != null) { pointer.x = e.clientX; pointer.y = e.clientY; }
      if (body.classList.contains('chrome-hidden')) wakeChrome();
      else armIdle();
    }, { passive: true, capture: true });
  });
  armIdle();

  /* ---- go ---- */
  requestAnimationFrame(function () {
    requestAnimationFrame(function () { body.classList.add('ready'); });
  });
})();

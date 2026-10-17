/* motion.js — INT-018: entrance stagger, rail selection, rail EXPANSION.
   (master: scripts/design-glue/) The prototype's statics stay verbatim.
   The rail is a floating glass column that opens on hover/focus
   (64 -> 168) revealing labels, account, and save-state; it closes
   180ms after the pointer leaves (grace against flicker). The
   expansion overlays content — nothing reflows. */
(function () {
  var body = document.body;
  body.classList.add('js');

  // ---- entrance stagger ----
  var shell = document.querySelector('body > div > [class^="study-shell-"]');
  if (shell) {
    var slots = shell.querySelectorAll(
      '[class^="workspace-header-"], [class^="home-content-"] > *, ' +
      '[class^="library-content-"] > *, [class^="archive-content-"] > *, ' +
      '[class^="reading-page-"], [class^="reader-heading-"], ' +
      '[class^="authored-day-page-"], [class^="day-navigation-"]'
    );
    var t = 0;
    for (var i = 0; i < slots.length; i++) {
      slots[i].classList.add('rise');
      slots[i].style.setProperty('--d', t + 'ms');
      t += 60;
      var kids = slots[i].querySelectorAll(':scope > *');
      var tt = 60;
      for (var j = 0; j < kids.length && j < 6; j++) {
        if (kids[j].classList.contains('rise')) continue;
        kids[j].classList.add('rise');
        kids[j].style.setProperty('--d', Math.max(t - 60, 0) + tt + 'ms');
        tt += 55;
      }
    }
  }

  // ---- rail: mark the current page's item selected (ink pill) ----
  var page = body.getAttribute('data-page');
  if (page) {
    var items = document.querySelectorAll('.rail-panel [class^="navigation-item-"]');
    for (var k = 0; k < items.length; k++) {
      if (items[k].getAttribute('href') === page) {
        items[k].classList.add('selected');
        items[k].setAttribute('aria-current', 'page');
      }
    }
  }

  // ---- INT-018: rail expansion (hover + keyboard focus) ----
  var rail = document.querySelector('.rail-panel');
  if (rail) {
    var closeTimer = null;
    var open = function () {
      if (closeTimer) { clearTimeout(closeTimer); closeTimer = null; }
      rail.classList.add('expanded');
    };
    var close = function () {
      closeTimer = setTimeout(function () {
        rail.classList.remove('expanded');
        closeTimer = null;
      }, 180);
    };
    rail.addEventListener('mouseenter', open);
    rail.addEventListener('mouseleave', close);
    rail.addEventListener('focusin', open);
    rail.addEventListener('focusout', function (e) {
      if (!rail.contains(e.relatedTarget)) close();
    });
  }

  // ---- go ----
  requestAnimationFrame(function () {
    requestAnimationFrame(function () { body.classList.add('ready'); });
  });
})();

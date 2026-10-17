/* motion.js — INT-016: entrance stagger, rail selection, nothing else.
   (master: scripts/design-glue/) The prototype's statics stay verbatim.
   The rail is now the STATIC reference rail (INT-016): no hover/expand,
   no pin — the paint layer marks the current page's item selected. */
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

  // ---- rail: mark the current page's item selected (reference pill) ----
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

  // ---- go ----
  requestAnimationFrame(function () {
    requestAnimationFrame(function () { body.classList.add('ready'); });
  });
})();

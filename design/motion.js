/* motion.js — INT-013: entrance stagger, rail hover/pin, nothing else.
   (master: scripts/design-glue/) The prototype's statics stay verbatim;
   this only classes the body and wires the two interactions the frames
   describe. */
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

  // ---- rail: hover opens, pin holds ----
  var rail = document.querySelector('[class^="navigation-rail-"], [class^="expanded-navigation-"]');
  var pin = document.querySelector('[class^="pin-"]');
  if (rail) {
    rail.addEventListener('mouseenter', function () { body.classList.add('nav-open'); });
    rail.addEventListener('mouseleave', function () {
      if (!body.classList.contains('pinned')) body.classList.remove('nav-open');
    });
  }
  if (pin) {
    pin.setAttribute('tabindex', '0');
    pin.setAttribute('role', 'button');
    pin.setAttribute('aria-pressed', body.classList.contains('pinned') ? 'true' : 'false');
    var togglePin = function () {
      var nowPinned = !body.classList.contains('pinned');
      body.classList.toggle('pinned', nowPinned);
      if (!nowPinned) body.classList.remove('nav-open');
      pin.setAttribute('aria-pressed', nowPinned ? 'true' : 'false');
    };
    pin.addEventListener('click', togglePin);
    pin.addEventListener('keydown', function (e) {
      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); togglePin(); }
    });
  }

  // ---- go ----
  requestAnimationFrame(function () {
    requestAnimationFrame(function () { body.classList.add('ready'); });
  });
})();

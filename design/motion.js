/* motion.js — INT-020: the motion system, rebuilt from zero.
   (master: scripts/design-glue/)
   LAWS (mirror motion.css):
   1. EXPAND, never bounce — no stagger cascades anywhere.
   2. Entrance = 2-3 soft block rises (70ms steps), NOT the
      pass-4..10 twenty-element 60/55ms cascade wave.
   3. The rail expands on hover/focus (64 -> 168) — width + the
      text fade/blur ride CSS transitions; this file only flips
      the `expanded` class (plus a 140ms close grace against
      flicker). The expansion overlays content — no reflow. */
(function () {
  var body = document.body;
  body.classList.add('js');

  // ---- entrance: the shell's own blocks, one 70ms step apart ----
  // (header, content column, trailing nav — never their children:
  // the child-level cascade was the "bounces on screen" verdict)
  var shell = document.querySelector('body > div > [class^="study-shell-"]');
  if (shell) {
    var blocks = [];
    var kids = shell.children;
    for (var i = 0; i < kids.length; i++) {
      var cls = kids[i].className || '';
      if (/navigation-rail-|expanded-navigation-/.test(cls)) continue;  // the rail has its own entrance
      blocks.push(kids[i]);
    }
    for (var b = 0; b < blocks.length && b < 3; b++) {
      blocks[b].classList.add('rise');
      blocks[b].style.setProperty('--d', (b * 70) + 'ms');
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

  // ---- rail expansion: hover + keyboard focus (INT-018, INT-020 timing) ----
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
      }, 140);
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

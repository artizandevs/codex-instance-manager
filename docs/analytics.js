/* Website analytics only. The desktop launcher does not load this file. */
(() => {
  'use strict';

  const track = (name, data) => {
    try {
      const pending = window.umami?.track(name, data);
      pending?.catch?.(() => {});
    } catch {
      // Analytics must never interrupt the page when a tracker is unavailable.
    }
  };

  const version = document.querySelector('.download-note')?.textContent.match(/v(\d+\.\d+\.\d+)/)?.[1];
  if (version) {
    document.querySelectorAll('[data-umami-event="download_click"]').forEach(link => {
      link.setAttribute('data-umami-event-version', version);
    });
  }

  document.querySelectorAll('details[data-analytics-question]').forEach(details => {
    let wasOpen = details.open;
    details.addEventListener('toggle', () => {
      if (details.open && !wasOpen) {
        track('faq_open', { question: details.dataset.analyticsQuestion });
      }
      wasOpen = details.open;
    });
  });

  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting && entry.intersectionRatio >= 0.15) {
          track('section_view', { section: entry.target.dataset.analyticsSection });
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.15 });
    document.querySelectorAll('[data-analytics-section]').forEach(section => observer.observe(section));
  }

  const milestones = [25, 50, 75, 100];
  const reached = new Set();
  let scheduled = false;
  const checkScroll = () => {
    scheduled = false;
    const available = document.documentElement.scrollHeight - window.innerHeight;
    if (available <= 0) return;
    const depth = window.scrollY >= available - 2 ? 100 : window.scrollY / available * 100;
    milestones.forEach(percent => {
      if (depth >= percent && !reached.has(percent)) {
        reached.add(percent);
        track('scroll_depth', { percent });
      }
    });
  };
  window.addEventListener('scroll', () => {
    if (!scheduled) {
      scheduled = true;
      window.requestAnimationFrame(checkScroll);
    }
  }, { passive: true });
  window.addEventListener('load', checkScroll, { once: true });
})();

# Website analytics

The GitHub Pages website uses the self-hosted Umami tracker at `https://umami.rtzn.pt` with website ID `f0fe288b-d8ce-4502-a942-7809b0aac994`. Umami records page views automatically. Query strings and URL fragments are excluded from tracked URLs. No user identification or form values are added by this site.

Analytics is confined to `docs/`; the desktop launcher does not include this tracker. Blocking the analytics script does not disable the website.

## Events

| Event | Properties | Meaning |
| --- | --- | --- |
| `download_click` | `location` (`hero`, `footer_cta`), `platform` (`windows`), `format` (`zip`), `version` | Someone clicked a download button. Version comes from the displayed release note. |
| `navigation_click` | `location` (`header`), `destination` (`setup`, `questions`) | Someone used an in-page navigation link. |
| `github_click` | `location` (`header`, `hero`, `footer`), `destination` (`repository`, `author`) | Someone opened a GitHub source or author link. |
| `guide_click` | `location` (`setup`) | Someone opened the full installation guide. |
| `license_click` | `location` (`footer`) | Someone opened the license. |
| `issue_click` | `location` (`footer`) | Someone opened the issue tracker. |
| `release_click` | `location` (`footer`) | Someone opened the release list. |
| `faq_open` | `question` (`official`, `account-isolation`, `instance-setup`, `existing-data`, `instance-settings`, `telemetry`) | Someone expanded an answer. Closing does not count; reopening counts again. The initially open answer does not count on page load. |
| `section_view` | `section` (`preview`, `features`, `setup`, `questions`, `closing`) | At least 15% of a section entered the viewport, once per page load. |
| `scroll_depth` | `percent` (25, 50, 75, 100; number) | The visitor reached this proportion of the available scroll distance, once per page load. Jumping down the page also crosses thresholds. |

## Reading the dashboard

Select this website in Umami and inspect **Events**. Use **Properties** to compare download button locations and release versions, FAQ topics, or sections reached. Compare page views, setup visits, and download clicks to understand where visitors stop. Standard Umami breakdowns provide referrers, devices, and countries.

A click does not prove a completed download or an installed app. A visible section does not prove it was read. Blocked trackers and visitors who leave before the tracker loads will not appear. No application usage or sign-in behavior is measured.

See Umami's [event documentation](https://docs.umami.is/docs/track-events).

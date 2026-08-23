/**
 * The global HTMX error handler — one listener pair on `document.body`, never per element.
 *
 * HTMX swaps on 2xx only, so without this a 500 or 503 replaces *nothing*: the indicator
 * stops, the page is unchanged, and the user re-clicks. The view nobody expected to fail is
 * the one that will, which is why this is global rather than attached where a failure was
 * anticipated.
 *
 * User errors are NOT handled here. They are a 200 with the re-rendered form, per view.
 *
 * Nothing loads this script at baseline — there is no base template yet.
 */

const ERROR_REGION_ID = "error-region";

/* Placeholder copy. Rewrite at first-time setup against how-to/src/BRAND-VOICE.md Section 3 —
   the template may not invent a voice (Section 2). Both strings are last resorts: the server's
   own rendered partial is preferred wherever there is one. */
const FALLBACK_MESSAGE = "Something went wrong at our end. Please try again.";
const OFFLINE_MESSAGE = "That request did not reach us. Check your connection and try again.";

/**
 * The region every error lands in, created if the page does not define one.
 *
 * The documented snippet assigned `document.getElementById(...)` straight to the swap
 * target, which is `null` on any page without the region — and a swap into `null` fails
 * silently, reproducing the exact defect this handler exists to close. Creating it is the
 * only option that cannot degrade back into silence.
 */
function errorRegion() {
  const existing = document.getElementById(ERROR_REGION_ID);
  if (existing !== null) {
    return existing;
  }

  const region = document.createElement("div");
  region.id = ERROR_REGION_ID;
  // Announced immediately: the user has just acted and nothing else on the page changed,
  // so a screen reader would otherwise report no result at all (WCAG 2.2 AA, 4.1.3).
  region.setAttribute("role", "alert");
  region.setAttribute("aria-live", "assertive");
  document.body.prepend(region);
  return region;
}

/**
 * Whether a response body is a fragment this page can safely swap in.
 *
 * A 5xx from the *application* is a rendered partial (see the guide). A 5xx from the *edge*
 * — nginx returning 502 or 504 because the app is not answering — is a complete HTML
 * document, and swapping one into a `div` nests a page inside a page. Neither the status
 * code nor the content type separates the two; the doctype does.
 */
function isFragment(body) {
  const start = body.trimStart().slice(0, 15).toLowerCase();
  return start !== "" && !start.startsWith("<!doctype") && !start.startsWith("<html");
}

document.body.addEventListener("htmx:beforeSwap", (event) => {
  if (event.detail.xhr.status < 500) {
    return;
  }

  // `isError` is deliberately left alone. Clearing it would suppress htmx's own console
  // error, and a handler that quietens the console while claiming to make failure visible
  // is worse than no handler.
  const region = errorRegion();
  event.detail.shouldSwap = true;
  event.detail.target = region;

  if (!isFragment(event.detail.serverResponse ?? "")) {
    region.textContent = FALLBACK_MESSAGE;
    event.detail.shouldSwap = false;
  }
});

// A request that never lands produces no response, so no swap is attempted and nothing
// above fires. Same region, different cause: this one is the environment class.
document.body.addEventListener("htmx:sendError", () => {
  errorRegion().textContent = OFFLINE_MESSAGE;
});

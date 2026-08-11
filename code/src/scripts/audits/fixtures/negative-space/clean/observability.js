// Fixture static script for negative-space.sh --self-test. Never served.
//
// One global listener, never per element — the view nobody expected to fail is the one
// that will. The clause keys on this listener, not on the file's path.
document.body.addEventListener("htmx:beforeSwap", (event) => {
  if (event.detail.xhr.status >= 500) {
    event.detail.shouldSwap = true;
    event.detail.target = document.getElementById("error-region");
  }
});

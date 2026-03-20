const windows = Array.from(document.querySelectorAll("[data-window]"));
const timeEl = document.querySelector("[data-time]");
const scrim = document.querySelector("[data-scrim]");
const launcher = document.querySelector("[data-launcher]");
const controlCenter = document.querySelector("[data-panel]");
const notifications = document.querySelector("[data-notifications]");
const launcherInput = document.querySelector(".launcher__search input");
const actionButtons = Array.from(document.querySelectorAll("[data-action]"));

let topZ = 1;

function setActive(target) {
  windows.forEach((win) => win.classList.remove("is-active"));
  target.classList.add("is-active");
  target.style.zIndex = String(++topZ);
}

function closePanels() {
  [launcher, controlCenter, notifications].forEach((panel) => {
    if (panel) {
      panel.classList.remove("open");
    }
  });
  if (scrim) {
    scrim.classList.remove("open");
  }
}

function openPanel(panel) {
  if (!panel) {
    return;
  }
  panel.classList.add("open");
  if (scrim) {
    scrim.classList.add("open");
  }
  if (panel === launcher && launcherInput) {
    launcherInput.focus();
  }
}

function togglePanel(target) {
  if (!target) {
    return;
  }
  const isOpen = target.classList.contains("open");
  closePanels();
  if (!isOpen) {
    openPanel(target);
  }
}

windows.forEach((win) => {
  win.addEventListener("pointerdown", () => setActive(win));
});

actionButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const action = button.dataset.action;
    if (action === "launcher") {
      togglePanel(launcher);
      return;
    }
    if (action === "control") {
      togglePanel(controlCenter);
      return;
    }
    if (action === "notifications") {
      togglePanel(notifications);
    }
  });
});

if (scrim) {
  scrim.addEventListener("click", closePanels);
}

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape") {
    closePanels();
  }
  if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
    event.preventDefault();
    togglePanel(launcher);
  }
});

function updateTime() {
  const now = new Date();
  if (timeEl) {
    timeEl.textContent = now.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
  }
}

updateTime();
setInterval(updateTime, 60000);

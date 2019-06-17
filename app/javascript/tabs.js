document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('.tabs').forEach((tabCollection) => {
    tabCollection.addEventListener('click', (event) => switchTab(tabCollection, event.target));
  });
});

function switchTab(tabCollection, clickedElement) {
  if (!clickedElement.matches('[data-toggle="tab"]'))
    return;

  const activeClassName = 'is-active';
  // Ensure all the other tabs are hidden
  tabCollection.querySelectorAll('[data-toggle="tab"]').forEach((tabElement) => {
    const targetElement = document.getElementById(tabElement.dataset.target);
    targetElement.classList.remove(activeClassName);
    tabElement.classList.remove(activeClassName);
  })

  // Display the clicked tab
  const targetElement = document.getElementById(clickedElement.dataset.target);
  targetElement.classList.add(activeClassName);
  clickedElement.classList.add(activeClassName);
}

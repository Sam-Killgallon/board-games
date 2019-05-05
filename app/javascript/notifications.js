// Remove notifications when clicking the 'X'
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.notification .delete').forEach((deleteButton) => {
    const notification = deleteButton.parentNode;
    deleteButton.addEventListener('click', () => {
      notification.parentNode.removeChild(notification);
    });
  });
});

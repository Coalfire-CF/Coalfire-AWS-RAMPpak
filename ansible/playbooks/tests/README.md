# Testing Playbooks
These are intended to run automated User Acceptance Tests with a specific emphasis on answering the question of "how do I know X application is working properly?".

Testing is primarily focused around Linux applications.  The general application check is to ensure the services in question are in a running state, and that the ports the application uses are both open and reachable (from Ansible host as a quick check).  Next steps are then to attempt login (mainly using an API, or Selenium if one isn't available) as both an authorized and unauthorized user.

Run setup.yml first to create an authorized and unauthorized AD user, other tests can then be run depending on whether the application exists.
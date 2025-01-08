const database = {
    users: {},
    groups: {
      "Kit Kat": ["chocolate", "sweet", "candy"],
      "Twirl": ["twist", "dance", "spin"],
      "Bounty": ["treasure", "reward", "island"]
    },
    results: {}
  };
  
  function createUser(username) {
    if (database.users[username]) {
      return "User already exists. Please log in.";
    }
    database.users[username] = { username, group: null };
    return `User ${username} created successfully!`;
  }
  
  function login(username) {
    if (!database.users[username]) {
      return "User does not exist. Please create a user.";
    }
    return database.users[username];
  }
  
  function selectGroup(user, groupName) {
    if (!database.groups[groupName]) {
      return "Invalid group name.";
    }
    user.group = groupName;
    return `${user.username} joined the group: ${groupName}`;
  }
  
  function saveResult(username, group, score) {
    if (!database.results[username]) {
      database.results[username] = [];
    }
    database.results[username].push({
      group,
      score,
      date: new Date().toLocaleDateString("en-GB")
    });
  }
  
  function getResults(username) {
    return database.results[username] || [];
  }
  
  module.exports = { database, createUser, login, selectGroup, saveResult, getResults };
  
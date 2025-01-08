const { createUser, login, selectGroup, saveResult, getResults } = require("./database");

function spellingTest(user, spellings) {
  let correctAnswers = 0;
  for (const word of spellings) {
    let attempts = 0;
    let correct = false;
    console.log(`Spell the word: ${word}`);
    while (!correct && attempts < 3) {
      const userAnswer = prompt(`Your answer (attempt ${attempts + 1}/3):`);
      if (userAnswer.toLowerCase() === word.toLowerCase()) {
        console.log("Correct!");
        correct = true;
        correctAnswers++;
      } else {
        console.log("Incorrect. Try again.");
      }
      attempts++;
    }
    if (!correct) console.log(`The correct spelling is: ${word}`);
  }
  const percentage = (correctAnswers / spellings.length) * 100;
  saveResult(user.username, user.group, percentage);
  console.log(`Test complete. Your score: ${correctAnswers}/${spellings.length} (${percentage.toFixed(2)}%)`);
}

function main() {
  const username = prompt("Enter your username:");
  console.log(createUser(username));
  const user = login(username);
  const groupName = prompt("Select your group: Kit Kat, Twirl, Bounty");
  console.log(selectGroup(user, groupName));
  const spellings = database.groups[user.group];
  console.log(`Spellings for this week: ${spellings.join(", ")}`);
  const action = prompt("Enter 'test' to start the test or 'exit' to quit:");
  if (action === "test") {
    spellingTest(user, spellings);
  } else {
    console.log("Goodbye!");
  }
  console.log("Historic Results:", getResults(user.username));
}

main();

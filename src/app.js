const readline = require("readline");
const { createUser, login, selectGroup, saveResult, getResults } = require("./database");

// Function to handle user input with readline
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

function askQuestion(query) {
  return new Promise((resolve) => rl.question(query, resolve));
}

async function spellingTest(user, spellings) {
  let correctAnswers = 0;
  for (const word of spellings) {
    let attempts = 0;
    let correct = false;
    console.log(`Spell the word: ${word}`); // Replace with TTS if needed
    while (!correct && attempts < 3) {
      const userAnswer = await askQuestion(`Your answer (attempt ${attempts + 1}/3): `);
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

async function main() {
  const username = await askQuestion("Enter your username: ");
  console.log(createUser(username));
  const user = login(username);
  if (!user) {
    rl.close();
    return;
  }
  const groupName = await askQuestion("Select your group (Kit Kat, Twirl, Bounty): ");
  console.log(selectGroup(user, groupName));
  const spellings = require("./database").database.groups[user.group];
  console.log(`Spellings for this week: ${spellings.join(", ")}`);
  const action = await askQuestion("Enter 'test' to start the test or 'exit' to quit: ");
  if (action === "test") {
    await spellingTest(user, spellings);
  } else {
    console.log("Goodbye!");
  }
  console.log("Historic Results:", getResults(user.username));
  rl.close();
}

main();

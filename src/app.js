const readline = require("readline");
const say = require("say");
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

    console.log(`Listen to the word being spoken.`);

    while (!correct && attempts < 3) {
      // Speak the word aloud
      say.speak(word, "Alex", 1.0, (err) => {
        if (err) console.error("Error playing audio:", err);
      });

      const userAnswer = await askQuestion(`Your answer (attempt ${attempts + 1}/3): `);

      if (userAnswer.toLowerCase() === word.toLowerCase()) {
        console.log("Correct!");
        correct = true;
        correctAnswers++;
      } else {
        console.log("Incorrect. Try again.");
        const replay = await askQuestion("Do you want to hear the word again? (yes/no): ");
        if (replay.toLowerCase() !== "yes") break;
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

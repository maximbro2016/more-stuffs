let num1, num2, correctAnswer;

function generateQuestion() {
  num1 = Math.floor(Math.random() * 10) + 1; // Random number 1-10
  num2 = Math.floor(Math.random() * 10) + 1;
  correctAnswer = num1 + num2;
  document.getElementById('question').innerText = `What is ${num1} + ${num2}?`;
}

function checkAnswer() {
  const userAnswer = parseInt(document.getElementById('user-answer').value);
  const feedback = document.getElementById('feedback');
  if (userAnswer === correctAnswer) {
    feedback.innerText = "Correct!";
    generateQuestion(); // Load next question
  } else {
    feedback.innerText = "Try again!";
  }
}

// Start the quiz on load
generateQuestion();

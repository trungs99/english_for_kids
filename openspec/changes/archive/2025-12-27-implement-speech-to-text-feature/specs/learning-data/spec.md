## ADDED Requirements

### Requirement: Speech Recognition Integration
The Speech Game SHALL use the `speech_to_text` package with English locale (`en_US`) for optimal English word recognition and proper microphone permission handling.

#### Scenario: Initialize speech recognition with English locale
- **WHEN** `SpeechGameController` initializes speech recognition
- **THEN** it SHALL configure `speech_to_text` with locale `en_US`
- **AND** ensure English language recognition regardless of device system language

#### Scenario: Request microphone permission before initialization
- **WHEN** `SpeechGameController` starts
- **THEN** it SHALL request microphone permission using `Permission.microphone.request()`
- **AND** wait for permission result before initializing speech recognition

#### Scenario: Microphone permission denied
- **GIVEN** microphone permission is denied by the user
- **WHEN** `SpeechGameController` receives denied result
- **THEN** it SHALL show a permission rationale message
- **AND** allow the user to skip the game

#### Scenario: Speech recognition initialization failure
- **GIVEN** speech recognition fails to initialize (e.g., hardware error, service unavailable)
- **WHEN** `SpeechGameController` catches the initialization exception
- **THEN** it SHALL display an error message to the user
- **AND** enable skip-only mode (skip button only, no speech input)

---

### Requirement: Speech Matching Logic
The system SHALL match spoken text against vocabulary words using case-insensitive substring matching with normalized text to handle variations and phonetic similarities.

#### Scenario: Successful match with exact word
- **GIVEN** a vocabulary targets the word "Apple"
- **AND** user speaks "Apple"
- **WHEN** `ProcessSpeechUseCase` evaluates the spoken text
- **THEN** it SHALL return `true` (match found)

#### Scenario: Successful match with word in sentence
- **GIVEN** a vocabulary targets the word "Apple"
- **AND** user speaks "I see an Apple"
- **WHEN** `ProcessSpeechUseCase` evaluates the spoken text
- **THEN** it SHALL return `true` (word found in sentence)

#### Scenario: Successful match with case variation
- **GIVEN** a vocabulary targets the word "Apple"
- **AND** user speaks "apple" (lowercase)
- **WHEN** `ProcessSpeechUseCase` evaluates the spoken text
- **THEN** it SHALL return `true` (case-insensitive match)

#### Scenario: Handle speech recognition variations
- **GIVEN** a vocabulary targets the word "Apple"
- **AND** speech recognition returns "apple pie" (word embedded in phrase)
- **WHEN** `ProcessSpeechUseCase` evaluates the spoken text
- **THEN** it SHALL return `true` (target word found in recognized text)

#### Scenario: No match for unrelated word
- **GIVEN** a vocabulary targets the word "Apple"
- **AND** user speaks "Banana"
- **WHEN** `ProcessSpeechUseCase` evaluates the spoken text
- **THEN** it SHALL return `false` (word not found)

#### Scenario: Normalize whitespace before matching
- **GIVEN** a vocabulary targets the word "Apple"
- **AND** user speaks "  Apple  " (with extra spaces)
- **WHEN** `ProcessSpeechUseCase` evaluates the spoken text
- **THEN** it SHALL normalize whitespace and return `true` (match found)

---

### Requirement: Speech Game Flow
The Speech Game SHALL guide the user through speaking vocabulary words and handle success/skip actions.

#### Scenario: Display target word
- **WHEN** Speech Game page is displayed
- **THEN** it SHALL show "Say the word: [WORD]" where `[WORD]` is the current vocabulary item
- **AND** display a listening indicator when speech recognition is active

#### Scenario: Start listening on page load
- **GIVEN** microphone permission is granted
- **WHEN** Speech Game page is displayed
- **THEN** speech recognition SHALL automatically start listening
- **AND** display a visual indicator that the app is listening

#### Scenario: Speech match success
- **GIVEN** user speaks a word that matches the target vocabulary
- **WHEN** `ProcessSpeechUseCase` returns `true`
- **THEN** the game SHALL stop listening
- **AND** show a success celebration dialog
- **AND** provide a "Next" button to proceed

#### Scenario: No match after speech
- **GIVEN** user speaks a word that does not match the target vocabulary
- **WHEN** `ProcessSpeechUseCase` returns `false`
- **THEN** the game SHALL continue listening
- **AND** optionally show a "Try again" message
- **AND** allow the user to speak again

#### Scenario: Skip button action
- **GIVEN** the user taps the skip button
- **WHEN** the skip action is triggered
- **THEN** the game SHALL stop listening
- **AND** complete without requiring speech match
- **AND** proceed to the next lesson step

#### Scenario: Resource cleanup
- **WHEN** Speech Game page is closed
- **THEN** `SpeechGameController` SHALL stop speech recognition
- **AND** cancel any active listening sessions

---

### Requirement: Speech Game Translations
The Speech Game SHALL support localized UI text in English and Vietnamese.

#### Scenario: English translations
- **WHEN** app locale is English
- **THEN** "Say the word: @word" SHALL display as "Say the word: Apple"
- **AND** listening indicator SHALL display "Listening..."
- **AND** skip button SHALL display "Skip"
- **AND** success message SHALL display "Great job! You said @word correctly!"

#### Scenario: Vietnamese translations
- **WHEN** app locale is Vietnamese
- **THEN** "Say the word: @word" SHALL display as "Nói từ: Apple"
- **AND** listening indicator SHALL display "Đang nghe..."
- **AND** skip button SHALL display "Bỏ Qua"
- **AND** success message SHALL display "Tuyệt vời! Bạn đã nói đúng từ @word!"

---

### Requirement: Home Page Debug Button for Speech Game
For testing purposes, the home page SHALL include a debug button to launch Speech Game.

#### Scenario: Debug button visibility
- **GIVEN** the app is running in debug mode (`kDebugMode == true`)
- **WHEN** the home page is displayed
- **THEN** a "Test Speech Game" button SHALL be visible

#### Scenario: Debug button navigation
- **GIVEN** the debug button is tapped
- **WHEN** navigation is triggered
- **THEN** it SHALL navigate to Speech Game with mock vocabulary data
- **AND** the mock vocabulary SHALL have a predefined word for testing

#### Scenario: Debug button hidden in release
- **GIVEN** the app is running in release mode (`kDebugMode == false`)
- **WHEN** the home page is displayed
- **THEN** the "Test Speech Game" button SHALL NOT be visible

---


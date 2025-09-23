# Rick & Morty + LLM (iOS · SwiftUI · GraphQL)

SwiftUI app that lists Rick & Morty characters via GraphQL and shows a richer detail screen with an inline **AI Insights** card (Summarize / Fun fact / Q\&A) powered by a swappable LLM client (OpenAI or a mock fallback).

---

## 🚀 Setup

### Requirements

* **Xcode 15.6+**, **Swift 5**, **iOS 15+**
* Uses **SPM** (no CocoaPods)

### 1) Open the project

* Open the `.xcodeproj` (or workspace if you prefer).
* Xcode will resolve SPM dependencies automatically.

### 2) GraphQL (Apollo) – schema & codegen

Schema and config are included. If you change operations, regenerate:

```bash
# From repo root
./apollo-ios-cli fetch-schema
./apollo-ios-cli generate
```

* Operations live in: `GraphQL/Operations/*.graphql`
* Schema lives in: `GraphQL/Schema/schema.graphqls`
* Generated Swift goes to the `RickAndMortyAPI` package (already linked).

### 3) LLM API key (optional; mock used if absent)

Paste you key into **LLMClientFactory.swift** line **12**:

```text
private let llmKey: String = "" // Paste key here for testing
```

The app reads `OpenAIAPIKey` at runtime:

* If present → uses **OpenAIClient** (`gpt-3.5-turbo` by default).
* If missing → uses **MockLLMClient** (deterministic, no network).

### 4) Run

* Select **iPhone (iOS 15+)** simulator
* **⌘R** to build & run
* Tap a character → Details → try **AI Insights**

---

## 🧩 Chosen APIs

***GraphQL API:** Rick & Morty GraphQL — `https://rickandmortyapi.com/graphql`
  Used for listing characters and fetching per-character details (name, status, species/type, gender, origin, location, episodes, created date).

***LLM:** OpenAI Chat Completions (`/v1/chat/completions`) with `gpt-3.5-turbo`
  Used to summarize, generate a fun fact, or answer a user question about the selected character.
  **Fallback:** A local `MockLLMClient` returns context-aware canned responses when no key is set (or when rate-limited during demo).

---

## 🏗 Architecture

### High-level

* **SwiftUI + MVVM**
* **Apollo iOS** with async/await
* **DI** via an `AppContainer` (composition root)
* **Modularization:** a SPM package **`NetworkKit`**, **`LLMKit`**, **`RickAndMortyAPIKit`**

```text
App (Views, ViewModels, InsightsService, Repositories)
   ├── uses → NetworkKit (HTTP + Apollo wrappers)
   ├── uses → RickAndMortyAPI (generated types)
   └── uses → LLMKit (OpenAI client via HTTP from NetworkKit)
```

## 🧪 Tests

**Scope (per assignment):** Unit tests for **ViewModels**.

* `CharactersViewModelTests`

  * Success populates characters
  * Failure sets `errorMessage`
  * `loading` toggles correctly
* `CharacterDetailsViewModelTests`

  * Success sets `details`
  * Failure sets error
  * `loading` toggles
* `AIInsightsViewModelTests`

  * Summarize / Fun fact / Ask transitions (`idle → loading → result/error`)
  * Question trimming & forwarding to LLM
---

## ⚖️ Tradeoffs & Limitations

* **iOS version:** Please note only iOS 26.0 has been looked at. Lower iOS versions are untested. 
* **Caching:** No offline mode implemented.
* **Paging:** No paging implemented in UI for characters however api implementation supports it.
* **Minimal modularization:** Only `NetworkKit` is a separate package—deliberate to keep the project lean while still demonstrating modularity. A `Core`/`LLMKit` split could be added later.
* **No streaming:** LLM responses are single-shot (simpler code and UI). Streaming could be added with Server-Sent Events / incremental decoding.
* **Rate limits / quotas:** The app falls back to a mock LLM when no key is set.
* **Accessibility:** Basic support via SwiftUI defaults
* **Dark mode:** No support for dark mode.
* **Navigation:** No centralised navigation logic via use of coordinators.

---

## 🔧 Commands & Scripts

```bash
# Fetch schema (if ever needed)
./apollo-ios-cli fetch-schema

# Generate GraphQL code (after editing *.graphql)
./apollo-ios-cli generate
```
---

## 🔄 Swapping the LLM

In `LLMClientFactory`:

```swift
let llm: LLMClient = {
  if let key = Bundle.main.infoDictionary?["OpenAIAPIKey"] as? String, !key.isEmpty {
    return OpenAIClient(apiKey: llmKey)    // real OpenAI
  } else {
    return MockLLMClient()               // offline/demo fallback
  }
}()
```

Replace `OpenAIClient` with another `LLMClient` implementation (Cohere/Gemini) without touching ViewModels or Views.

---

## 📸 Demo
<video src="Demo/demo.mp4" controls width="720" poster="Demo/thumbnail.png">
  https://github.com/5ayeem/RickAndMorty/blob/main/Demo/demo.mov
</video>

## 🙏 Credits

* GraphQL: [https://rickandmortyapi.com/graphql](https://rickandmortyapi.com/graphql)
* OpenAI API: [https://platform.openai.com/docs/overview](https://platform.openai.com/docs/overview)
